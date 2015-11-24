module Katello
  module Candlepin
    class Consumer
      include LazyAccessor
      attr_accessor :uuid

      lazy_accessor :entitlements, :initializer => lambda { |_s| Resources::Candlepin::Consumer.entitlements(uuid) }

      def initialize(uuid)
        self.uuid = uuid
      end

      def regenerate_identity_certificates
        Resources::Candlepin::Consumer.regenerate_identity_certificates(self.uuid)
      end

      def backend_data
        Resources::Candlepin::Consumer.get(self.uuid)
      end

      def checkin(checkin_time)
        Resources::Candlepin::Consumer.checkin(self.uuid, checkin_time)
      end

      # def installed_products
      #
      # end
      #
      # def installed_product_ids
      #   installed_products.map {|product| product['productId']}
      # end
    end
  end
end
