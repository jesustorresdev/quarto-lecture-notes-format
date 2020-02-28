require 'asciidoctor'

Asciidoctor::Extensions.register do
  inline_macro do
    named :cmd
    match_format :short
    name_positional_attributes 'command'

    process do |parent, target, attrs|
      command = attrs['command']
      create_inline(parent, :quoted, command, {type: :monospaced})
    end
  end
end

Asciidoctor::Extensions.register do
  inline_macro do
    named :path
    match_format :short
    name_positional_attributes 'pathname'

    process do |parent, target, attrs|
      pathname = attrs['pathname']
      create_inline(parent, :quoted, pathname, {type: :monospaced})
    end
  end
end