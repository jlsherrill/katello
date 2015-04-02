#
# Copyright 2014 Red Hat, Inc.
#
# This software is licensed to you under the GNU General Public
# License as published by the Free Software Foundation; either version
# 2 of the License (GPLv2) or (at your option) any later version.
# There is NO WARRANTY for this software, express or implied,
# including the implied warranties of MERCHANTABILITY,
# NON-INFRINGEMENT, or FITNESS FOR A PARTICULAR PURPOSE. You should
# have received a copy of GPLv2 along with this software; if not, see
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.

module Actions
  module Katello
    module SyncPlan
      class RemoveProducts < Actions::EntryAction
        def plan(sync_plan, product_ids)
          action_subject(sync_plan)

          products = ::Katello::Product.where(:id => product_ids).editable
          sync_plan.product_ids = (sync_plan.product_ids - products.collect { |p| p.id }).uniq
          sync_plan.save!

          products.each do |product|
            plan_action(::Actions::Katello::Product::Update, product, :sync_plan_id => nil)
          end
        end

        def humanized_name
          _("Update Sync Plan Products")
        end
      end
    end
  end
end