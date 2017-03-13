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
            % Need to pass in a pointer to each of call to EUV_LV "p"
            p = int32(0);
            switch(this.cProp)
                case this.cPropPhotonEnergy
                    [a, b] = calllib(this.cLib, 'GetEncoderEnergy', p);
                    d = b;
                case this.cPropPhotonWav
                    [a, b] = calllib(this.cLib, 'GetEncoderEnergy', p);
                    d = this.ev2nm(b);
                case this.cPropGrating
                    [a, b] = calllib(this.cLib, 'CheckGrating', p);
                    d = b;
                otherwise
                    cMsg = sprintf('get() %s is not supported', this.cProp);
                    this.msg(cMsg);
            end
        end


        function l = isReady(this)
            
            % Pointer
            p = int32(0);
            switch(this.cProp)
                case {this.cPropPhotonEnergy, this.cPropPhotonWav}
                    [a, b] = calllib(this.cLib, 'CheckEnergyOK', p);
                    l = b;
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
                case {this.cPropPhotonEnergy, this.cPropPhotonWav}
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
       
        % @param {double 1x1} dNm - photon wavelength in nm
        % @return {double 1x1} photon energy in eV
        function d = nm2ev(this, dNm)
            d = this.dEvNm / dNm;
        end
        
        % @param {double 1x1} dEv - photon energy in eV
        % @return {double 1x1} photon wavelength in nm
        function d = ev2nm(this, dEv)
            d = this.dEvNm / dEv;
        end
    end
end %class
    

            
            
            
        