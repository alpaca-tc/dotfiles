# IRB.conf[:USE_AUTOCOMPLETE] = false
# IRB.conf[:PROMPT_MODE] = :SIMPLE
# IRB.conf[:PROMPT_MODE] = :SIMPLE
# IRB.conf[:USE_MULTILINE] = false
IRB.conf[:INSPECT_MODE] = :pp
IRB.conf[:USE_AUTOCOMPLETE] = false

IRB.conf[:COMMAND_ALIASES][:cd] = :irb_pry_change_workspace

IRB.conf[:PROMPT][:CUSTOM] = {
  :PROMPT_I => ">> ",
  :PROMPT_S => "%l>> ",
  :PROMPT_C => ".. ",
  :PROMPT_N => ".. ",
  :RETURN => "=> %s\n"
}
IRB.conf[:PROMPT_MODE] = :CUSTOM
IRB.conf[:AUTO_INDENT] = true

IRB::Irb.prepend(Module.new do
  # Constants +PROMPT_I+, +PROMPT_S+ and +PROMPT_C+ specify the format. In the
  # prompt specification, some special strings are available:
  #
  #     %N    # command name which is running
  #     %m    # to_s of main object (self)
  #     %M    # inspect of main object (self)
  #     %l    # type of string(", ', /, ]), `]' is inner %w[...]
  #     %NNi  # indent level. NN is digits and means as same as printf("%NNd").
  #           # It can be omitted
  #     %NNn  # line number.
  #     %%    # %
  def prompt(prompt, ltype, indent, line_no) # :nodoc:
    nest_string = '‣'
    module_name = view_clip(@context.main)
    nest = nest_string * (@context.workspaces.size + 1)
    format("\e[33;1m%-30.30s \e[36;5m%-4.4s\e[0m $ ", module_name, nest)

    # p = prompt.dup
    # p.gsub!(/%([0-9]+)?([a-zA-Z])/) do
    #   case $2
    #   when "N"
    #     @context.irb_name
    #   when "m"
    #     @context.main.to_s
    #   when "M"
    #     @context.main.inspect
    #   when "l"
    #     ltype
    #   when "i"
    #     if indent < 0
    #       if $1
    #         "-".rjust($1.to_i)
    #       else
    #         "-"
    #       end
    #     else
    #       if $1
    #         format("%" + $1 + "d", indent)
    #       else
    #         indent.to_s
    #       end
    #     end
    #   when "n"
    #     if $1
    #       format("%" + $1 + "d", line_no)
    #     else
    #       line_no.to_s
    #     end
    #   when "%"
    #     "%"
    #   end
    # end
    # p
  end

  private

  def view_clip(obj)
    obj = obj.__getobj__ if obj.is_a?(SimpleDelegator)
    max = 60

    if obj == TOPLEVEL_BINDING.eval('self')
      'main'
    elsif obj.is_a?(Module) && obj.name.to_s != "" && obj.name.to_s.length <= max
      obj.name.to_s
    elsif [String, Numeric, Symbol, nil, true, false].any? { |v| v === obj } && obj.inspect.length <= max
      obj.inspect
    else
      "#<#{obj.class}>"
    end
  rescue RescuableException
    "unknown"
  end
end)

require 'irb/cmd/pushws'

module IRB
  @@__statements = nil

  module ExtendCommandBundle
    @MY_EXTEND_COMMANDS = [
      [
        :irb_pry_change_workspace, :PryChangeWorkspace,
        [[:cd, NO_OVERRIDE]],
      ]
    ].freeze

    def self.install_my_extend_commands
      @MY_EXTEND_COMMANDS.each do |(cmd_name, cmd_class, aliases)|
        @EXTEND_COMMANDS.push([cmd_name, cmd_class, '', []])
        install_my_extend_command(cmd_name, cmd_class)

        for ali, flag in aliases
          @ALIASES.push [ali, cmd_name, flag]
        end
      end
    end

    def self.install_my_extend_command(cmd_name, cmd_class)
      line = __LINE__; eval %[
        def #{cmd_name}(*opts, **kwargs, &b)
          arity = IRB::ExtendCommand::#{cmd_class}.instance_method(:execute).arity
          args = (1..(arity < 0 ? ~arity : arity)).map {|i| "arg" + i.to_s }
          args << "*opts, **kwargs" if arity < 0
          args << "&block"
          args = args.join(", ")
          line = __LINE__; eval %[
            unless singleton_class.class_variable_defined?(:@@#{cmd_name}_)
              singleton_class.class_variable_set(:@@#{cmd_name}_, true)
              def self.#{cmd_name}_(\#{args})
                IRB::ExtendCommand::#{cmd_class}.execute(irb_context, \#{args})
              end
            end
          ], nil, __FILE__, line
          __send__ :#{cmd_name}_, *opts, **kwargs, &b
        end
      ], nil, __FILE__, line
    end

    install_my_extend_commands
  end

  module ExtendCommand
    class PryChangeWorkspace < Nop
      category "IRB"
      description "Change the current workspace to an object. (pry mode)"

      class BackwardToken
        attr_reader :count

        def initialize(count = 0)
          @count = count
        end
      end

      # parse `cd ..` `cd ../../`
      def self.transform_args(args)
        return args unless args.strip.match?(/\A[\.\/]+\z/)

        backward_count = 0

        require 'strscan'
        scanner = ::StringScanner.new(args.chomp)

        loop do
          next_segment = +""

          loop do
            next_segment += scanner.scan(%r{[^/]*})

            if ['.', '..'].include?(next_segment.chomp) || scanner.eos?
              scanner.getch
              break
            else
              scanner.getch
            end
          end

          case next_segment.chomp
          when "."
            next
          when ".."
            backward_count += 1
          else
            raise ArgumentError, "invalid path: #{next_segment}"
          end

          break if scanner.eos?
        end

        "#{BackwardToken.name}.new(#{backward_count})"
      end

      def execute(*obj)
        if obj[0].is_a?(BackwardToken)
          obj[0].count.times do
            irb_context.pop_workspace
          end
        elsif obj.empty?
          irb_context.pop_workspace while irb_context.workspaces.size > 0
        else
          irb_context.push_workspace(*obj)
        end
      end
    end
  end
end
