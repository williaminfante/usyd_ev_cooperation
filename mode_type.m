%Filename:     mode_type.m
%Description:  Different battery modes in business model
%
%Modification History: 
%======================================================================
%Author          Date        Ver   Remarks  
%======================================================================
%william         2016-04-14  1.0   Creation
%======================================================================

classdef mode_type 
    enumeration 
        HIGH_EV_MODE 
        LOW_EV_MODE 
        IDLE_MODE
        GRID_MODE 
        DISPOSE_MODE
    end
end