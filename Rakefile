Rake.add_rakelib 'lib/tasks'

task :config do |t|
    CONFIG[:asciidoctor_opts] = [
        '--attribute', 'allow-uri-read',
        '--require', 'asciidoctor-diagram'
    ]
end