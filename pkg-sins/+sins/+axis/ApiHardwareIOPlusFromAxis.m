classdef ApiHardwareIOPlusFromAxis < InterfaceApiHardwareIOPlus

    % apiv

    properties (Access = private)
      
        % {Axis 1x1} java instance that implements Carl Cork Axis interface
        axis
        
        % {java.util.concurrent.Future 1x1} java future
        future
        
    end


    properties

        
    end

            
    methods
        
        function this = ApiHardwareIOPlusFromAxis(axis)
            this.axis = axis;      
        end

        function d = get(this)
            d = this.axis.getPosition();
        end


        function l = isReady(this)
                       
            if isempty(this.future)
                l = true;
                return;
            end
            
            if this.future.isDone()
                l = true;
                return;
            end
            
            l = false;
        end
        
        
        function set(this, dDest)
            this.future = this.axis.moveAbsolute(dDest);
        end 

        function stop(this)
            this.axis.stopMove();
        end

        function index(this)
            % Need to implement this
            this.axis.initialize();
        end
        
        

    end %methods
end %class
    

            
            
            
        