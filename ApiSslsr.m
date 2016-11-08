classdef ApiSslsr < InterfaceApiSslsr

    properties (Access = private)
    
        % {java 1x1} - instance of master java object
        j 
        
    end
    
    methods 
        
        function this = ApiSslsr()  
            
        end
        
        % Code that needs to be executed before get*() can be called
        function init(this)
            
            
        end        
        
        function apiAxis = getMaskX(this)
            apiAxis = this.j.getMaskX();
        end
        
        function apiAxis = getMaskY(this)
            apiAxis = this.j.getMaskY();
        end
        
        function apiAxis = getMaskZ(this)
            apiAxis = this.j.getMaskZ();
        end
        
        function apiAxis = getMaskT(this)
            apiAxis = this.j.getMaskT();
        end
        
        function apiAxis = getDetX(this)
            apiAxis = this.j.getDecX();
        end
        
        function apiAxis = getDetT(this)
            apiAxis = this.j.getDetT();
        end
        
        function apiAxis = getFilterY(this)
            apiAxis = this.j.getFilterY();
        end
        
        function apiMono = getMono(this)
            apiMono = this.j.getMono();
        end
               
    end
    
end
        


