classdef ApiHioFromAxis < InterfaceAPIHardwareIO

    properties (Access = private)
        % {api 1x1} - must implement InterfaceAxis
        api
    end
    
    methods

        function this = ApiHioFromAxis(api) 
            this.api = api;
        end
        
        function d = get(this) % retrieve value
            d = this.api.getPosition();
        end
        
        function l = isReady(this) % true when stopped or at its target
            l = this.api.isReady();
        end
        
        function set(this, dDest) % set new destination and move to it
            this.api.moveAbsolute(dDest);
        end
        
        function stop(this) % stop motion to destination
            this.api.stopMove();
        end
        
        
        function index(this) % index
        end
        
   end
    
    
end
