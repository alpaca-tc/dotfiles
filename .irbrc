# IRB.conf[:USE_AUTOCOMPLETE] = false
# IRB.conf[:PROMPT_MODE] = :SIMPLE
# IRB.conf[:PROMPT_MODE] = :SIMPLE
# IRB.conf[:USE_MULTILINE] = false
IRB.conf[:INSPECT_MODE] = :pp
IRB.conf[:USE_AUTOCOMPLETE] = false

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
  def format_prompt(prompt, ltype, indent, line_no) # :nodoc:
    nest_string = '‣'
    workspace_stack = @context.instance_variable_get(:@workspace_stack)
    module_name = view_clip(@context.main)
    nest = nest_string * [workspace_stack.size, 1].max
    format("\e[33;1m%-30.30s \e[36;5m%-4.4s\e[0m $ ", module_name, nest)
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

require 'irb/command'

class PryChangeWorkspace < IRB::Command::Base
  NOT_GIVEN = Object.new

  category "Workspace"
  description "Change the current workspace to an object."

  class BackwardToken
    attr_reader :count

    def initialize(count = 0)
      @count = count
    end
  end

  def execute(args)
    obj = transform_args(args)

    case obj
    when BackwardToken
      obj.count.times do
        irb_context.pop_workspace
      end
    when NOT_GIVEN
      workspace_stack = irb_context.instance_variable_get(:@workspace_stack)
      irb_context.pop_workspace while workspace_stack.size > 1
    else
      irb_context.push_workspace(obj)
    end
  end

  private

  # parse `cd ..` `cd ../../`
  def transform_args(string)
    return NOT_GIVEN if string == ''
    return eval(string, irb_context.workspace.binding) unless string.strip.match?(/\A[\.\/]+\z/)

    backward_count = 0

    require 'strscan'
    scanner = ::StringScanner.new(string.chomp)

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

    BackwardToken.new(backward_count)
  end
end

IRB::Command.register(:cd, PryChangeWorkspace)
