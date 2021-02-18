Rake.add_rakelib 'lib/tasks'

task :config do |t|
    CONFIG[:asciidoctor_opts] = [
        '--attribute', 'allow-uri-read',
        '--require', 'asciidoctor-diagram',
    ]
    CONFIG[:asciidoctor_pdf_opts] = [
        '--require', 'asciidoctor-mathematical', '-a', 'mathematical-format=svg',
    ]
    CONFIG[:htmlproofer_opts] = [
        '--url-ignore', '/github\.com\/EpicGames\/UnrealEngine/',
    ]
end