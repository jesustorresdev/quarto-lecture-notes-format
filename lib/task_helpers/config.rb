Struct.new('Config', :asciidoctor_opts, :htmlproofer_opts) do
    def self.build(asciidoctor_opts: nil, htmlproofer_opts: nil)
        asciidoctor_opts ||= []
        htmlproofer_opts ||= []

        if ENV.key?('HTMLPROOFER_DISABLE_EXTERNAL')
            htmlproofer_opts |= ["--disable-external"]
        end
        Struct::Config.new(asciidoctor_opts, htmlproofer_opts)
    end
end

CONFIG = Struct::Config.build()
