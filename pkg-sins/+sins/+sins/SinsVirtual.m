classdef SinsVirtual < sins.sins.Interface

    properties (Access = private)
    
        clock
    end
    
    methods 
       
        function this = SinsVirtual(varargin)
        
            for k = 1 : 2: length(varargin)
                % this.msg(sprintf('passed in %s', varargin{k}));
                if this.hasProp( varargin{k})
                    this.msg(sprintf('settting %s', varargin{k}), 3);
                    this.(varargin{k}) = varargin{k + 1};
                end
            end
            
        end
        
        
        % @return {Axis 1x1}
        function axis = getDetectorT(this)
           axis = sins.axis.AxisVirtual(...
               'cName', 'sins-detector-t', ...
               'clock', this.clock ...
           );
        end

        function axis = getDetectorX(this)
            axis = sins.axis.AxisVirtual(...
               'cName', 'sins-detector-x', ...
               'clock', this.clock ...
           );
        end

        function axis = getFilterStage(this)
            axis = sins.axis.AxisVirtual(...
               'cName', 'sins-filter-stage', ...
               'clock', this.clock ...
           );
        end

        function axis = getMaskT(this)
            axis = sins.axis.AxisVirtual(...
               'cName', 'sins-mask-t', ...
               'clock', this.clock ...
           );
        end

        function axis = getMaskX(this)
            axis = sins.axis.AxisVirtual(...
               'cName', 'sins-mask-x', ...
               'clock', this.clock ...
           );
        end

        function axis = getMaskY(this)
            axis = sins.axis.AxisVirtual(...
               'cName', 'sins-mask-y', ...
               'clock', this.clock ...
           );
        end

        function axis = getMaskZ(this)
            axis = sins.axis.AxisVirtual(...
               'cName', 'sins-mask-z', ...
               'clock', this.clock ...
           );
        end
               
    end
    
end
        
