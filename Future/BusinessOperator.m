%Filename:     BusinessOperator.m
%Description:  Generates the class for business operator managing if 
%              battery should be used for grid or EV battery swap.
%
%Modification History: 
%======================================================================
%Author          Date        Ver   Remarks  
%======================================================================
%william         2016-04-13  1.0   Creation
%======================================================================
classdef BusinessOperator
    %BusinessOperator: manages battery for grid use, EV swap or disposal
    %   This class also decides if additional batteries should be bought.
    
    properties
        bought_batteries %control the id of batteries 
        consumer_profile %constrol the number of existing consumers 
        batteries_in_area %constrols the batteries need 
    end
    
    methods
    end
    
end

