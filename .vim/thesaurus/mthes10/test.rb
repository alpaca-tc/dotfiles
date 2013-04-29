
require 'benchmark'

def complete_thesaurus(file_path, filter)
  file = File.new(file_path, "r")
  result = []
  file.each_line do |line|
    line.strip!

    result << line if line.match filter
  end
  file.close

  result.join(" ").split(/[, ]/).flatten.uniq!
end

p complete_thesaurus("./mthesaur.txt", "public")

