%Filename:     class_type.m
%Description:  Class of battery charging
%
%Modification History: 
%======================================================================
%Author          Date        Ver   Remarks  
%======================================================================
%william         2016-04-14  1.0   Creation
%======================================================================

classdef class_type < uint8
    enumeration 
        CLASS_A (1)
        CLASS_B (2)
        CLASS_C (3)
        CLASS_D (4)
    end
end 