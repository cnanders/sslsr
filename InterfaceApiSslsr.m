classdef InterfaceApiSslsr < HandlePlus

    methods (Abstract)
        
        apiAxis = getFilter(this)
        apiAxis = getMaskX(this)
        apiAxis = getMaskY(this)
        apiAxis = getMaskZ(this)
        apiAxis = getMaskT(this)
        apiMono = getMono(this)
        apiAxis = getDetX(this)
        apiAxis = getDetT(this)
        apiAxis = getFilterY(this)
               
    end
    
end
        
