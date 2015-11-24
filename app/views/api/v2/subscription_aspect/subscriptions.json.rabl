object false

extends "katello/api/v2/common/metadata"

child @collection[:results] => :results do
  attributes :quantity_attached
  child :subscription => subscription do
    extends "katello/api/v2/subscriptions/base"
  end
end
