module Katello
  module Concerns
    module HttpProxyExtensions
      extend ActiveSupport::Concern

      included do
        has_many :repositories, :class_name => "Katello::Repository", :dependent => :nullify, :inverse_of => :http_proxy
      end
    end
  end
end