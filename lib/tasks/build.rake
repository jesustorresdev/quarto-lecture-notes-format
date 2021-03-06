require_relative '../task_helpers/project.rb'

Project::documents.each do |document|
    namespace "#{document[:namespace_prefix]}build" do

        task :default => [:docstats, :all]

        desc "Generar todas las versiones de '#{document[:pathname]}'"
        task :all => [:html, :pdf, :epub]

    end
end