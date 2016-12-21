classdef Interface < HandlePlus

    methods (Abstract)
        
       % @return {double 1x1} the position
       d = getPosition(this) 
       
       % @param {double 1x1} destination
       % @return {future 1x1} future
       future = moveAbsolute(this, dDest)
       
       % stop motion, normal deceleration.
       stopMove(this)
       
       % @return {future 1x1} future
       future = initialize(this)
               
    end
    
end
        
