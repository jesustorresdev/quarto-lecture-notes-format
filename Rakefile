Rake.add_rakelib 'lib/tasks'

task :config do |t|
    CONFIG[:asciidoctor_opts] = [
        '--attribute', 'allow-uri-read',
        '--require', 'asciidoctor-diagram',
    ]
    CONFIG[:asciidoctor_pdf_opts] = [
        '--require', 'asciidoctor-mathematical', '-a', 'mathematical-format=svg',
    ]
end