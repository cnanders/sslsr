classdef ApiHardwareIOPlusFromAxis < InterfaceApiHardwareIOPlus

    % There are two ways do do moves with {cxro.common.device.axis}
    % 
    % 1.
    % call axis.moveAbsolute() in set(). axis.moveAbsolute()returns a future
    % call future.isDone() in isReady() to check if the move is complete
    %
    % 2.
    % call axis.setTarget() in set().  This returns an int
    % call axis.isReady() in isReady() to check if the stage is at the
    % target
    %
    % Option 1 has a big CON which is that calling axis.moveAbsolute()
    % when the previous future is not finished doesn't do anything; there
    % is no way to update the destination in the middle of a move.
    %
    % With option 2, the destination can be updated mid-move. 
    %
    % There is a {logical} useFuture property to define which method of
    % setting and checking should be used
    
    properties (Access = private)
      
        % {Axis 1x1} java instance that implements Carl Cork Axis interface
        axis
        
        % {java.util.concurrent.Future 1x1} java future
        future
        
        % {logical 1x1} see discussion at the top of this class
        useFuture = false
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
               
            if this.useFuture
                if isempty(this.future)
                    l = true;
                    return;
                end

                if this.future.isDone()
                    l = true;
                    return;
                end
                l = false;
            else
                l = this.axis.isReady();
            end
        end
        
        
        function set(this, dDest)
            if this.useFuture
                this.future = this.axis.moveAbsolute(dDest);
            else
                this.axis.setTarget(dDest);
            end
        end 

        function stop(this)
            this.axis.stopMove();
        end

        function index(this)
            % Need to implement this
            this.axis.initialize();
        end
        
        
        function initialize(this)
            this.axis.initialize();
        end
        
        function l = isInitialized(this)
            l = this.axis.isInitialized();
        end


    end %methods
end %class
    

            
            
            
        