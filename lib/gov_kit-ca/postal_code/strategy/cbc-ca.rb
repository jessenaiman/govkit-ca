module GovKit
  module CA
    module PostalCode
      module Strategy
        # cbc.ca ought to be a reliable source. It is unknown if its database
        # is kept up-to-date between elections, however.
        # @see https://github.com/danielharan/pc_scraper
        class CbcCa < Base
          base_uri 'www.cbc.ca'

          def initialize(postal_code)
            @fsa, @letter, @ldu = postal_code.downcase.match(/\A((.).{2})(.{3})\Z/)[1..3]
            super
          end

          def json_response # Yajl barfs on bad encoding
            Yajl::Parser.parse(response.parsed_response) rescue JSON.parse(response.parsed_response)
          end

        private

          def electoral_districts!
            json_response.map{|x| self.class.rid_to_edid[x['rid']]}
          end

          def valid?
            !!response.headers['expires']
          end

          def response
            @response ||= self.class.get "/news/canadavotes/myriding/postalcodes/#{@letter}/#{@fsa}/#{@ldu}.html"
          end

          # cbc.ca uses an internal riding ID, which must be matched to a
          # canonical electoral district ID.
          # @return [Hash] a map of cbc.ca riding ID to electoral district ID
          def self.rid_to_edid
            @@yml ||= YAML.load_file(File.expand_path('../../../../data/rid_to_edid.yml', __FILE__))
          end
        end

        StrategySet.register CbcCa
      end
    end
  end
end