module Spree::Admin::ServiceRequestsHelper
  def event_service_request_links(service_request, events)
    links = []
    events.each do |event|
      next unless service_request.send("can_#{event}?")

      label = Spree.t(event, scope: 'admin.service_request.events', default: Spree.t(event))
      links << button_link_to(
        "Mark as #{label.capitalize}",
        [event, :admin, service_request],
        method: :put,
        icon: event.to_s,
        data: { confirm: Spree.t(:service_request_sure_want_to, event: label) }
      )
    end
    safe_join(links, '&nbsp;'.html_safe)
  end
end