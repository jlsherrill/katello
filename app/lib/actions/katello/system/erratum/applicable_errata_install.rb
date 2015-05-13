module Actions
  module Katello
    module System
      module Erratum
        class ApplicableErrataInstall < Actions::EntryAction
          include Helpers::Presenter

          #takes a list of errata and schedules the installation of those that are applicable
          def plan(system, errata_uuids)
            applicable_errata = system.applicable_errata.where(:uuid => errata_uuids)
            plan_action(Actions::Katello::System::Erratum::Install, system, applicable_errata.pluck(:errata_id))
          end

          def save_input(system, errata_uuids)
            input[:errata_count] = errata_uuids.count
            input[:system_name] = system.name
          end

          def humanized_name
            if input[:system_name]
              n_("Install %{count} Applicable Erratum on %{name}",
                 "Install %{count} Applicable Erratum on %{name}", input[:errata_count]) %
                  {:count => input[:errata_count], :name => input[:system_name] }
            else
              n_("Install Applicable Errata")
            end
          end

          def presenter
            Helpers::Presenter::Delegated.new(self, planned_actions(Katello::System::Erratum::Install))
          end
        end
      end
    end
  end
end
