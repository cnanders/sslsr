classdef Interface < HandlePlus

    methods (Abstract)
        
       % @return {logical 1x1} if future is done
       l = isDone(this)
               
       % @return {char 1xm} the status of the future
       c = get(this)
    end
    
end
        
