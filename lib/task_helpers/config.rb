Struct.new(
    'Config',
    :asciidoctor_opts,
    keyword_init: true
)

CONFIG = Struct::Config.new(
    asciidoctor_opts: []
)
