classdef Test

    
    
    properties 
        
        cHello = 'Hello pkg.c';
        
    end
    
     
    methods
       
        function this = Test()
        end
        
        function talk(this)
            fprintf('%s\n', this.cHello);
        end
        
        function a = getA(this)
            import pkg.a.A
            a = A();
        end
               
    end
    
end
        
