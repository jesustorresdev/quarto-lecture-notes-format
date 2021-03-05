require_relative '../task_helpers/docstats.rb'
require_relative '../task_helpers/project.rb'
require_relative '../task_helpers/utils.rb'

Project::find_documents().each do |document|
    namespace "#{document[:namespace_prefix]}build" do
        task :default => [:docstats, :html]

        desc "Generar todas las versiones de '#{document[:pathname]}'"
        task :all => [:html, :pdf, :epub]

        desc "Generar la versión en HTML de '#{document[:pathname]}'"
        task :html => [ document[:output_pathname][:html], :html_media_files ]

        file document[:output_pathname][:html] => [*document[:dependencies], :config] do |t|
            asciidoctor_opts = CONFIG[:asciidoctor_opts] + CONFIG[:asciidoctor_html_opts]
            sh "asciidoctor", '--backend', 'html5',
                              '--require', './lib/time-admonition-block.rb',
                              '--attribute', "basedir=#{Project::PROJECT_DIRECTORY}",
                              '--attribute', "outdir=#{document[:output_directories][:html]}",
                              *asciidoctor_opts,
                              '--out-file', t.name, t.prerequisites.first()
        end

        task :html_media_files do |t|
           Utils.copy_files(document[:media_files], document[:output_directories][:html], document[:source_directory]) 
        end

        desc "Generar la versión en PDF de '#{document[:pathname]}'"
        task :pdf => [ document[:output_pathname][:pdf] ]

        file document[:output_pathname][:pdf] => [*document[:dependencies], :config] do |t|
            asciidoctor_opts = CONFIG[:asciidoctor_opts] + CONFIG[:asciidoctor_pdf_opts]
            sh "asciidoctor", '--backend', 'pdf',
                              '--require', 'asciidoctor-pdf',
                              '--require', './lib/time-admonition-block.rb',
                              '--attribute', "basedir=#{Project::PROJECT_DIRECTORY}",
                              '--attribute', "outdir=#{document[:output_directories][:pdf]}",
                              *asciidoctor_opts,
                              '--out-file', t.name, t.prerequisites.first()
        end

        desc "Generar la versión en EPUB de '#{document[:pathname]}'"
        task :epub => [ document[:output_pathname][:epub] ]

        file document[:output_pathname][:epub] => [*document[:dependencies], :config] do |t|
            asciidoctor_opts = CONFIG[:asciidoctor_opts] + CONFIG[:asciidoctor_epub_opts]
            sh "asciidoctor", '--backend', 'epub3',
                              '--require', 'asciidoctor-epub3',
                              '--require', './lib/time-admonition-block.rb',
                              '--attribute', "basedir=#{Project::PROJECT_DIRECTORY}",
                              '--attribute', "outdir=#{document[:output_directories][:epub]}",
                              *asciidoctor_opts,
                              '--out-file', t.name, t.prerequisites.first()
        end

        desc "Generar el archivo de estadística de '#{document[:pathname]}'"
        task :docstats do |t|
            Rake::Task["#{document[:namespace_prefix]}build:html"].invoke
            html_output_document = open(document[:output_pathname][:html])
            docstats = Docstats::get_document_stats(html_output_document)
            Docstats.generate_docstats_document(docstats, document[:docstats_pathname])
        end
    end

    if ! document[:namespace_prefix].empty?
        namespace :build do
            desc 'Generar la versión en HTML de todos los documentos del proyecto'
            task :html => "#{document[:namespace_prefix]}build:html"

            desc 'Generar la versión en PDF de todos los documentos del proyecto'
            task :pdf => "#{document[:namespace_prefix]}build:pdf"

            desc 'Generar la versión en EPUB de todos los documentos del proyecto'
            task :epub => "#{document[:namespace_prefix]}build:epub"

            desc 'Generar el archivo de estadísticas de todos los documentos del proyecto'
            task :docstats => "#{document[:namespace_prefix]}build:docstats"
        end
    end

end