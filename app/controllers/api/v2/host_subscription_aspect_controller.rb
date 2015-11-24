class Api::V2::SubscriptionAspect < Api::V2::ApiController
  respond_to :json

  before_filter :find_host_with_subscriptions

  api :PUT, "/hosts/:id/subscriptions/refresh", N_("Trigger a refresh of subscriptions, auto-attaching if enabled")
  param :id, String, :desc => N_("id of the host"), :required => true
  def refresh_subscriptions
    sync_task(::Actions::Katello::System::AutoAttachSubscriptions, @system)
    respond_for_show(:resource => @system)
  end

  api :GET, "/hosts/:id/subscriptions", N_("List a host's subscriptions"), :deprecated => true
  param :id, String, :desc => N_("id of the host"), :required => true
  def subscriptions
    entitlements = Katello::Candlepin::Consumer.new(@host.subscription_aspect.uuid).entitlements
    subscriptions =  entitlements.map { |entitlement| SystemSubscriptionPresenter.new(entitlement) }
    @collection = { :results => subscriptions,
                    :total => subscriptions.count,
                    :page => 1,
                    :per_page => subscriptions.count,
                    :subtotal => subscriptions.count }
  end

  api :POST, "/hosts/:id/subscriptions", N_("Add a subscription to a host"), :deprecated => true
  param :id, String, :desc => N_("id of a host"), :required => false
  param :subscriptions, Array, :desc => N_("Array of subscriptions to add"), :required => false do
    param :id, String, :desc => N_("Subscription Pool uuid"), :required => true
    param :quantity, :number, :desc => N_("Quantity of this subscriptions to add"), :required => true
  end
  def add_subscriptions
    params[:subscriptions] ||= []
    entitlements = params[:subscriptions].map do |sub_params|
      { :pool => Pool.find(pool_id), :quantity => sub_params[:quantity] }
    end
    sync_task(::Actions::Katello::Host::AttachSubscriptions, host, entitlements)

    respond_for_show(:resource => @host)
  end

  api :GET, "/systems/:id/releases", N_("Show releases available for the content host"), :deprecated => true
  param :id, String, :desc => N_("UUID of the content host"), :required => true
  desc <<-DESC
    A hint for choosing the right value for the releaseVer param
  DESC
  def releases
    response = { :results => @system.available_releases,
                 :total => @system.available_releases.size,
                 :subtotal => @system.available_releases.size }
    respond_for_index :collection => response
  end

  api :PUT, "/systems/:id/content_override", N_("Set content overrides for the content host")
  param :id, String, :desc => N_("UUID of the content host"), :required => true
  param :content_override, Hash, :desc => N_("Content override parameters") do
    param :content_label, String, :desc => N_("Label of the content"), :required => true
    param :value, [0, 1, "default"], :desc => N_("Override to 0/1, or 'default'"), :required => true
  end
  def content_override
    content_override = validate_content_overrides(params[:content_override])
    @system.set_content_override(content_override[:content_label], 'enabled', content_override[:value])

    content = @system.available_content
    response = {
      :results => content,
      :total => content.size,
      :subtotal => content.size
    }
    respond_for_index :collection => response
  end

  api :GET, "/systems/:id/product_content", N_("Get content overrides for the content host")
  param :id, String, :desc => N_("UUID of the content host"), :required => true
  def product_content
    content = @system.available_content
    response = {
      :results => content,
      :total => content.size,
      :subtotal => content.size
    }
    respond_for_index :collection => response
  end

  api :GET, "/systems/:id/events", N_("List Candlepin events for the content host")
  param :id, String, :desc => N_("UUID of the content host"), :required => true
  def events
    @events = @system.events.map { |e| OpenStruct.new(e) }
    respond_for_index :collection => @events
  end

  private

  def find_host_with_subscriptions
    @host = Host.find(params[:id])
    fail _("Host has not been registered with subscription-manager") if @host.subscription_aspect.nil?
  end

  def validate_content_overrides(content_params)
    case content_params[:value].to_s
    when 'default'
      content_params[:value] = nil
    when '1'
      content_params[:value] = 1
    when '0'
      content_params[:value] = 0
    else
      fail HttpErrors::BadRequest, _("Value must be 0/1, or 'default'")
    end

    unless @system.available_content.map(&:content).any? { |content| content.label == content_params[:content_label] }
      fail HttpErrors::BadRequest, _("Invalid content label: %s") % content_params[:content_label]
    end
    content_params
  end
end