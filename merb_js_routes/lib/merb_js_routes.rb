if defined?(Merb::Plugins)

  $:.unshift File.dirname(__FILE__)

  load_dependency 'merb-slices'
  Merb::Plugins.add_rakefiles "merb_js_routes/merbtasks", "merb_js_routes/slicetasks"

  # Register the Slice for the current host application
  Merb::Slices::register(__FILE__)
  
  # Slice configuration - set this in a before_app_loads callback.
  # By default a Slice uses its own layout.
  Merb::Slices::config[:merb_js_routes][:layout] ||= :merb_js_routes
  
  # All Slice code is expected to be namespaced inside a module
  module MerbJsRoutes
    
    # Slice metadata
    self.description = "Merb route generation from JavaScript"
    self.version = "0.9.4"
    self.author = "Jonas Nicklas"
    
    # Stub classes loaded hook - runs before LoadClasses BootLoader
    # right after a slice's classes have been loaded internally.
    def self.loaded
    end
    
    # Initialization hook - runs before AfterAppLoads BootLoader
    def self.init
    end
    
    # Activation hook - runs after AfterAppLoads BootLoader
    def self.activate
    end
    
    # Deactivation hook - triggered by Merb::Slices.deactivate(MerbJsRoutes)
    def self.deactivate
    end
    
    # Setup routes inside the host application
    #
    # @param scope<Merb::Router::Behaviour>
    #  Routes will be added within this scope (namespace). In fact, any 
    #  router behaviour is a valid namespace, so you can attach
    #  routes at any level of your router setup.
    #
    # @note prefix your named routes with :merb_js_routes_
    #   to avoid potential conflicts with global named routes.
    def self.setup_router(scope)
      scope.match('/javascripts/routes.js').to(:controller => 'main', :action => 'index', :format => 'js')
    end
    
    # This sets up a thin slice's structure.
    def self.setup_default_structure!
      self.push_app_path(:root, Merb.root / 'slices' / self.identifier, nil)
      
      self.push_path(:stub, root_path('stubs'), nil)
      self.push_app_path(:stub, app_dir_for(:root), nil)
      
      self.push_path(:application, root, 'application.rb')
      self.push_app_path(:application, app_dir_for(:root), 'application.rb')
      
      self.push_path(:view, dir_for(:application) / "views")
      self.push_app_path(:view, app_dir_for(:application) / "views")
      
      self.push_path(:public, root_path('public'), nil)
      self.push_app_path(:public, Merb.root / 'public' / 'slices' / self.identifier, nil)
      
      public_components.each do |component|
        self.push_path(component, dir_for(:public) / "#{component}s", nil)
        self.push_app_path(component, app_dir_for(:public) / "#{component}s", nil)
      end
    end
    
  end
  
  # Setup the slice layout for MerbJsRoutes
  #
  # Use MerbJsRoutes.push_path and MerbJsRoutes.push_app_path
  # to set paths to merb_js_routes-level and app-level paths. Example:
  #
  # MerbJsRoutes.push_path(:application, MerbJsRoutes.root)
  # MerbJsRoutes.push_app_path(:application, Merb.root / 'slices' / 'merb_js_routes')
  # ...
  #
  # Any component path that hasn't been set will default to MerbJsRoutes.root
  #
  # For a thin slice we just add application.rb, :view and :public locations.
  MerbJsRoutes.setup_default_structure!
  
  # Add dependencies for other MerbJsRoutes classes below. Example:
  dependency "merb_js_routes/helpers"
  
end