require 'rake'

module Utils

    def copy_files(files, destination_directory, base_directory)
        files.each do |pathname|
            destination = pathname.sub(%r(^#{base_directory}), destination_directory)
            destination_directory = File.dirname(destination)

            if File.exist? destination
                next if [File.ctime(pathname), File.mtime(pathname)].max <= \
                    [File.ctime(destination), File.mtime(destination)].max
            end
            
            Rake::FileUtilsExt.mkdir_p destination_directory
            Rake::FileUtilsExt.cp pathname, destination
        end
    end
    module_function :copy_files

end