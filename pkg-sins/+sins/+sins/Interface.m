classdef Interface < HandlePlus

    methods (Abstract)
        
       % @return {Axis 1x1}
       axis = getDetectorT(this)
       axis = getDetectorX(this)
       axis = getFilterStage(this)
       axis = getMaskT(this)
       axis = getMaskX(this)
       axis = getMaskY(this)
       axis = getMaskZ(this)
               
    end
    
end
        
