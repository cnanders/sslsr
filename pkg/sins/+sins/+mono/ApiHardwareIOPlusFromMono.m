classdef ApiHardwareIOPlusFromMono < InterfaceApiHardwareIOPlus

    % Calls of methods of a loaded .dll
    
    properties (Constant)
        
        cPropPhotonEnergy = 'energy'
        cPropPhotonWav = 'wav'
        cPropGrating = 'grating'
        
        % {double 1x1} nm * eV product
        dEvNm = 1239.84193
    end
    
    properties (Access = private)
        
        % {char 1xm} name of the library
        cLib = 'EUV_LV'
        
        % {char 1xm} name of property we are retreiving: 
        % this.cPropPhotonWav, this.cPropPhotonEnergy, this.cPropGrating
        cProp
        
        
    end


    properties

        
    end

            
    methods
        
        function this = ApiHardwareIOPlusFromMono(cProp)
            this.cProp = cProp;
        end

        function d = get(this)
            switch(this.cProp)
                case this.cPropPhotonEnergy
                    d = calllib(this.cLib, 'GetEncoderEnergy');
                case this.cPropPhotonWav
                    d = this.ev2nm(calllib(this.cLib, 'GetEncoderEnergy'));
                case this.cPropGrating
                    d = calllib(this.cLib, 'CheckGrating');
                otherwise
                    cMsg = sprintf('get() %s is not supported', this.cProp);
                    this.msg(cMsg);
            end
        end


        function l = isReady(this)
            switch(this.cProp)
                case this.cPropPhotonEnergy
                case this.cPropPhotonWav
                    l = calllib(this.cLib, 'CheckEnergyOK');
                case this.cPropGrating
                    % FIXME
                    l = true;
                otherwise
                    cMsg = sprintf('isReady() %s is not supported', this.cProp);
                    this.msg(cMsg);
            end
        end
        
        
        function set(this, dDest)
            switch(this.cProp)
                case this.cPropPhotonEnergy
                    calllib(this.cLib, 'SetPhotonEnergy', dDest);
                case this.cPropPhotonWav
                    calllib(this.cLib, 'SetPhotonEnergy', this.nm2ev(dDest));
                case this.cPropGrating
                    calllib(this.cLib, 'SetGratingNo', dDest)
                otherwise
                    cMsg = sprintf('set() %s is not supported', this.cProp);
                    this.msg(cMsg);
            end
        end 

        function stop(this)
            switch(this.cProp)
                case this.cPropPhotonEnergy
                case this.cPropPhotonWav
                    calllib(this.cLib, 'StopSetEnergy');
                case this.cPropGrating
                    % FIXME
                otherwise
                    cMsg = sprintf('stop() %s is not supported', this.cProp);
                    this.msg(cMsg);
            end
            
        end

        function index(this)
            
        end
        
        function initialize(this)
            
        end
        
        function l = isInitialized(this)
            l = true;
        end


    end %methods
    
    methods (Access = private)
       
        % @param {double 1x1} dVal - photon wavelength in nm
        % @return {double 1x1} photon energy in eV
        function d = nm2ev(this, dVal)
            d = this.dEvNm / dVal;
        end
        
        % @param {double 1x1} dVal - photon energy in eV
        % @return {double 1x1} photon wavelength in nm
        function d = ev2nm(this, dVal)
            d = this.dEvNm / dVal;
        end
    end
end %class
    

            
            
            
        