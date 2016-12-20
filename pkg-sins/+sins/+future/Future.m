classdef Future < sins.future.Interface

    properties (Access = private)
        lDone = false
    end
    
    methods
       
       
       % @return {logical 1x1} if future is done
       function l = isDone(this)
           l = this.lDone;
       end
               
       % @return {char 1xm} the status of the future
       function c = get(this)
           c = 'status';
       end
       
       % Tell the future it is done
       function done(this)
           this.lDone = true;
       end
    end
    
end
        
