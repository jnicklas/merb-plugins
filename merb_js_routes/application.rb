module MerbJsRoutes
  
  # All Slice code is expected to be namespaced inside this module.
  
  class Application < Merb::Controller
    
    controller_for_slice
    
    private
    
    # Construct a path relative to the public directory
    def public_path_for(type, *segments)
      ::MerbJsRoutes.public_path_for(type, *segments)
    end
    
    # Construct an app-level path.
    def app_path_for(type, *segments)
      ::MerbJsRoutes.app_path_for(type, *segments)
    end
    
    # Construct a slice-level path
    def slice_path_for(type, *segments)
      ::MerbJsRoutes.slice_path_for(type, *segments)
    end
    
  end
  
  class Main < Application
    
    def index
      only_provides :js
      <<-JS.to_a.map{|l| l.strip}.join("\n")
        if(window.Url === undefined) var Url = {};
        #{js_routes Merb::Router.named_routes.keys}
      JS
    end
    
  end
  
end