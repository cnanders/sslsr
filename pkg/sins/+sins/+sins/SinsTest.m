classdef SinsTest < HandlePlus
        
    properties (Constant)
        dHeightHio = 30;       
    end
    
	properties
        
        clock
        hioFilterY
        hioMaskT
        
        deviceSins
        deviceFilterY
        deviceMaskT
                
    end
    
    properties (SetAccess = private)
    
    end
    
    properties (Access = private)
        hFigure
        cDirThis
        cDirApp
        cPathConfigFilterY
        cPathConfigMaskT
        
        configMaskT
        configFilterY
    end
    
        
    events
        
        
    end
    

    
    methods
        
        
        function this = SinsTest()
             
            [this.cDirThis, cName, cExt] = fileparts(mfilename('fullpath'));

            this.clock = Clock('master'); 

            % App root
            this.cDirApp = fullfile(this.cDirThis, '..', '..', '..', '..');
            
            this.initDevices();
            this.initHardwareUI();
            this.setApis();
            
        end
        
        function initDevices(this)
            
            return;
            
            this.deviceSins = nus.sins2.Sins2Instruments();
            % this.deviceFilterY = this.deviceSins.getFilterStage();
            this.deviceMaskT = this.deviceSins.getMaskT();
            
            
        end
        
        
        
        function initHardwareUI(this)
            
            this.cPathConfigFilterY = fullfile(this.cDirApp, 'config', 'hiop', 'filterY.json');
            this.configFilterY = ConfigHardwareIOPlus(this.cPathConfigFilterY);
            this.hioFilterY = HardwareIOPlus(...
                'cName', 'filter-y', ...
                'cLabel', 'Filter Y', ...
                'clock', this.clock, ...
                'config', this.configFilterY, ...
                'lShowStores', true, ...
                'lShowUnit', true, ...
                'lShowInitButton', true, ...
                'lShowInitState', true, ...
                'cConversion' , 'f', ... % fixed point notaion // exponential notaion
                'fhValidateDest', @this.validateDest ...
            );
        
        
            this.cPathConfigMaskT = fullfile(this.cDirApp, 'config', 'hiop', 'maskT.json');
            this.configMaskT = ConfigHardwareIOPlus(this.cPathConfigMaskT);
            this.hioMaskT = HardwareIOPlus(...
                'cName', 'mask-theta', ...
                'cLabel', 'Mask T', ...
                'clock', this.clock, ...
                'config', this.configMaskT, ...
                'lShowLabels', false, ...
                'lShowStores', true, ...
                'lShowUnit', true, ...
                'lShowInitButton', true, ...
                'lShowInitState', true, ...
                'cConversion' , 'f', ... % fixed point notaion // exponential notaion
                'fhValidateDest', @this.validateDest ...
            );
        
        end
        
        function setApis(this)
            % this.hioFilterY.setApi(sins.axis.ApiHardwareIOPlusFromAxis(this.deviceFilterY));
            
            deviceSins = nus.sins2.Sins2Instruments();
            % this.deviceFilterY = this.deviceSins.getFilterStage();
            deviceMaskT = deviceSins.getMaskT();
            
            this.hioMaskT.setApi(sins.axis.ApiHardwareIOPlusFromAxis(deviceMaskT));
        end
        
        function l = validateDest(this)
            l = true;
        end
        
        function build(this, hParent, dLeft, dTop)
            if ishghandle(this.hFigure)
                % Bring to front
                figure(this.hFigure);
                return
            end
            
            dLeft = 10;
            dTop = 10;
            
            this.hFigure = figure;
            this.hioFilterY.build(this.hFigure, dLeft, dTop); 
            dTop = dTop + this.dHeightHio + 20; % 20 for labels
            this.hioMaskT.build(this.hFigure, dLeft, dTop);
        end
        
        function deleteDevices(this)
            return;
            this.msg('deleteDevices()');
            % this.deviceFilterY.destroy();
            this.deviceMaskT.destroy();
        end
        
        function deleteHardwareUI(this)
            this.msg('deleteHardwareUI');
            delete(this.hioFilterY);
            delete(this.hioMaskT)
        end
        
        function delete(this)
            this.msg('delete', 5);
            
            this.deleteHardwareUI();
            this.deleteDevices();
            delete(this.clock);
        end
               
    end
    
    methods (Access = protected)
       
        
    end
    
    methods (Access = private)
        
        
        
    end 
    
    
end