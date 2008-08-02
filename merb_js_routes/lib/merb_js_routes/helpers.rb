module MerbJsRoutes
  
  module Helpers
    
    def register_js_route(name)
      "Url.register(#{name.to_json}, #{js_route(name)});"
    end
    
    def js_route(name)
      "function(params) { return #{get_segments_for_js_route(name)}; }"
    end
    
    protected
    
    def get_segments_for_js_route(name)
      Merb::Router.named_routes[name].segments.map do |segment|
        case segment
        when Symbol then "params.#{segment}"
        when String then segment.to_json
        end
      end.join(' + ')
    end

  end
  
end

class Merb::Controller
  include MerbJsRoutes::Helpers
end