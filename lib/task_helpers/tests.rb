require 'json'
require 'nokogiri'
require 'rake'

module Tests

    module HTMLProofer

        TYPHOEUS_CONFIG = {
            :headers => {
                "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:84.0) Gecko/20100101 Firefox/84.0",
            },
            :ssl_verifyhost => 0,
            :ssl_verifypeer => false,
        }

        def htmlproofer(pathname)
            Rake::FileUtilsExt.sh "htmlproofer", "--typhoeus_config", TYPHOEUS_CONFIG.to_json, pathname
        end
        module_function :htmlproofer
        
    end

    def find_missing_variables(string_or_io)
        document = Nokogiri::HTML.parse(string_or_io)
        # Ignorar bloques stem: <div class='stemblock'> o \$texto\$
        variables = document.xpath('//body//text()[not(ancestor::div[@class="stemblock"])]').flat_map do |text|
            text.content.gsub(/\\\$.*?\\\$/, "").scan(/\{[\w-]+\}/)
        end

        return variables.uniq.sort
    end
    module_function :find_missing_variables

end