function [sediment_bc] = update_sediment(MyLake_concentrations, MyLake_params, sediment_params)
%update_sedimets function convert BC values for sediment module (different Units)
    %   [Water-column units] ------>  [Sediments units]
    % for dissolved species - concentration BC
    % for solid - Neumann (flux) BC
    pH = MyLake_params.pH;
    % pH = 6.47;
    w_s = MyLake_params.w_s * 100 * 365; %settling velocity for S [m d-1] -> [cm year-1]
    w_chl = MyLake_params.w_chl * 100 * 365; %settling velocity for S [m d-1] -> [cm year-1]
    w_chl_2 = MyLake_params.w_chl_2 * 100 * 365; %settling velocity for S [m d-1] -> [cm year-1]
    fi = sediment_params.fi;

    sediment_bc.O2_c = dissolved_bc(MyLake_concentrations.O2z, fi);
    sediment_bc.OM1_fx = solid_bc(MyLake_concentrations.Chlz, w_chl, fi) + solid_bc(MyLake_concentrations.Cz, w_chl_2, fi);
    sediment_bc.OM2_fx = solid_bc(MyLake_concentrations.POCz, w_s, fi);
    sediment_bc.PO4_c = dissolved_bc(MyLake_concentrations.Pz, fi);
    sediment_bc.NO3_c = dissolved_bc(MyLake_concentrations.NO3z, fi);
    sediment_bc.FeOH3_fx = solid_bc(MyLake_concentrations.Fe3z, w_s, fi);
    sediment_bc.SO4_c = dissolved_bc(MyLake_concentrations.SO4z, fi);
    sediment_bc.Fe2_c = dissolved_bc(MyLake_concentrations.Fe2z, fi);
    sediment_bc.FeOOH_fx = 0;
    sediment_bc.FeS_fx = 0;
    sediment_bc.S0_c = 0;
    sediment_bc.S8_fx = 0;
    sediment_bc.FeS2_fx = 0;
    sediment_bc.AlOH3_fx = solid_bc(MyLake_concentrations.Al3z, w_s, fi);
    sediment_bc.PO4adsa_fx = solid_bc(MyLake_concentrations.PPz, w_s, fi);
    sediment_bc.PO4adsb_fx = 0;
    sediment_bc.Ca2_c = dissolved_bc(MyLake_concentrations.Ca2z, fi);
    sediment_bc.Ca3PO42_fx = 0;
    sediment_bc.OMS_fx = 0;
    sediment_bc.H_c = 10^-pH*10^3;
    sediment_bc.OH_c = 10^-(14-pH)*10^3;
    sediment_bc.CO2_c = 0;
    sediment_bc.CO3_c = 2.19E-05;
    sediment_bc.HCO3_c = 0.62387047;
    sediment_bc.NH3_c = 3.68E-09;
    sediment_bc.NH4_c = dissolved_bc(MyLake_concentrations.NH4z, fi);
    sediment_bc.HS_c = 1.01E-10;
    sediment_bc.H2S_c = 1.06E-10;
    sediment_bc.H2CO3_c = 1.06E-15;
    sediment_bc.DOM1_c = dissolved_bc(MyLake_concentrations.DOPz, fi);
    sediment_bc.DOM2_c = dissolved_bc(MyLake_concentrations.DOCz, fi);
    sediment_bc.T = MyLake_params.Tz(end);

end

function C_bc = dissolved_bc(C, fi)
% return the value of boundary concentration for sediment
% In MyLake the concentrations are bulk concentrations
% in sediment the are per V of H2O or per V of solid
% C - concentration of the particular species in MyLake [umol/cm3]
    C_bc = C(end);
end

function solid_fx = solid_bc(C, w_s, fi)
    % C   - concentration in WC [umol/cm3]
    % w_s - settling velocity of solids [cm year-1]
    % mmol arriving at SWI interface is
    % solid_fx - flux of solid at SWI [umol cm-2 yr-1]
    solid_fx = w_s * C(end) * (1 - fi(1));
end



