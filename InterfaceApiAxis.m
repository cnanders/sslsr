classdef InterfaceApiAxis < HandlePlus

    methods (Abstract)
        
        l = enable(this)
        l = disable(this)
        d = getPosition(this)
        l = isReady(this)
        moveAbsolute(this)
        stopMove(this)
               
    end
    
end
        
