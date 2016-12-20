classdef AxisVirtual < sins.axis.Interface

    properties (Access = protected)
       
        dVal = 0
        % {sins.future.Future 1x1} storage of a future
        future
        
        % {Clock 1x1}
        clock
        
        % {double 1xm} stores path from dVal to dDest in set method
        dPath
        % {double 1x1} stores which index of dPath we are on during move.
        % Resets every call to moveAbsolute()
        dPathCycle = 1 
        % {double 1x1} % Number of task periods to move through path
        dPathCycles = 10
        % {double 1x1} clock period
        dPeriod = 20/1000;
                
    end
    
    properties
        
        cName

    end
    
    
    methods
       
        function this = AxisVirtual(varargin)
            for k = 1 : 2: length(varargin)
                % this.msg(sprintf('passed in %s', varargin{k}));
                if this.hasProp( varargin{k})
                    this.msg(sprintf('settting %s', varargin{k}), 3);
                    this.(varargin{k}) = varargin{k + 1};
                end
            end 
        end
        
       % @return {double 1x1} the position
       function d = getPosition(this) 
          d = this.dVal; 
       end
       
       % @param {double 1x1} destination
       % @return {future 1x1} future
       function future = moveAbsolute(this, dDest)
          
            % See ApivHardwareIO.  I copied it.  Only difference is I use
            % futures now.

            this.future = sins.future.Future();
            
            if isempty(this.clock)
                this.future.done();
                this.dVal = dDest;
                
                future = this.future;
                return;
            end
            
            this.dPath = linspace(this.dVal, dDest, this.dPathCycles);
            this.dPathCycle = 1;

            % 2013.07.08 CNA
            % Adding support for Clock

            % this.msg(sprintf('%s.moveAbsolute() calling this.c1.add()', this.id()));

            if ~this.clock.has(this.id())
                this.clock.add(@this.handleClock, this.id(), this.dPeriod);
            else
                this.msg(sprintf('set() not adding %s', this.id()), 5);
            end
            
            future = this.future;
           
            
       end
       
       % stop motion, normal deceleration.
       function stopMove(this)
          
       	  % Kill timer task that is updating dVal
                      
            if ~isempty(this.clock)
                this.clock.remove(this.id());
                this.future.done();
            end
            
       end
       
       % initialize
       function initialize(this)
           
       end
       

        function handleClock(this)

            try

                % Update pos
                this.dVal = this.dPath(this.dPathCycle);
                
                this.msg(sprintf('handleClock() updating dVal to %1.3f', this.dVal), 5);

                % Do we need to stop the timer?
                if (this.dVal == this.dPath(end))
                    this.clock.remove(this.id()); 
                    this.future.done();
                end

            catch err
                this.msg(getReport(err), 2);
            end
            
            % Update counter
            if this.dPathCycle < this.dPathCycles
                this.dPathCycle = this.dPathCycle + 1;
            end

        end

        function delete(this)

            this.msg('delete()', 5);

            % Clean up clock tasks
            if isvalid(this.clock) && ...
               this.clock.has(this.id())
                this.clock.remove(this.id());
            end


        end
        
               
    end
    
end
        
