classdef A

    properties 
        
        cHello = 'Hello pkg.a';
        
    end
    
     
    methods
       
        function this = A()
        end
        
        function talk(this)
            fprintf('%s\n', this.cHello);
        end
               
    end
    
end
        
