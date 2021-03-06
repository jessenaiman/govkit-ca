module GovKit
  module CA
    module PostalCode
      module Strategy
        class ElectionsCa < Base
          base_uri 'elections.ca'
          http_method :post
          path '/Scripts/vis/FindED'
          post_data 'CommonSearchTxt=<%= @postal_code %>'

        private

          def electoral_districts!
            [ response.headers['location'][/\bED=(\d{5})&/, 1] ]
          end

          def valid?
            !response.headers['location'][/EDNotFound|MultipleEDs/]
          end
        end

        StrategySet.register ElectionsCa
      end
    end
  end
end
