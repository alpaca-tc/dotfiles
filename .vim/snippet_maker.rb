# {{{
defines = <<-DOC
altKey	Returns whether or not the "ALT" key was pressed when an event was triggered
button	Returns which mouse button was clicked when an event was triggered
clientX	Returns the horizontal coordinate of the mouse pointer, relative to the current window, when an event was triggered
clientY	Returns the vertical coordinate of the mouse pointer, relative to the current window, when an event was triggered
ctrlKey	Returns whether or not the "CTRL" key was pressed when an event was triggered
keyIdentifier	Returns the identifier of a key	3
keyLocation	Returns the location of the key on the device	3
metaKey	Returns whether or not the "meta" key was pressed when an event was triggered
relatedTarget	Returns the element related to the element that triggered the event
screenX	Returns the horizontal coordinate of the mouse pointer, relative to the screen, when an event was triggered
screenY	Returns the vertical coordinate of the mouse pointer, relative to the screen, when an event was triggered
shiftKey	Returns whether or not the "SHIFT" key was pressed when an event was triggered
DOC
# }}}

defines.split(/$/).each do |line|
  method, doc = line.gsub("\n", '').split(/\t/)
  brackets = /\(.*\)/
  method_name, without_brackets = if method =~ brackets then 
      ["#{method} :", method.gsub(brackets, '')] 
    else
      ['', method]
  end

  puts <<SNIP
snippet #{without_brackets}
abbr    #{method_name}#{doc}
regexp  'mouseEvent\\\.'
options word
  #{method}

SNIP
end
