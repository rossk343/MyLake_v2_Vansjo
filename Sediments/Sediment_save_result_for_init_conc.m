function sediment_save_result_for_init_conc(sed_res, n)

if n == 1
    file_name = 'IO/sediment_initial_concentrations.txt';
else
    file_name = 'IO/sediment_initial_concentrations_2.txt';
end

fid = fopen(file_name,'wt');
fprintf(fid, 'z\t OMzt\t OMbzt\t DOM1zt\t DOM2zt\t O2zt\t NO3zt\t NH4zt\t NH3zt\t FeOH3zt\t FeOOHzt\t Fe2zt\t SO4zt\t H2Szt\t HSzt\t PO4zt\t PO4adsazt\t PO4adsbzt\t S0zt\t S8zt\t FeSzt\t FeS2zt\t AlOH3zt\t Ca2zt\t Ca3PO42zt\t OMSzt\t Hzt\t OHzt\t CO2zt\t CO3zt\t HCO3zt\t H2CO3zt\t Chlzt\n');
fclose(fid);

dlmwrite(file_name, ...
[sed_res.params.x', ...
sed_res.concentrations.POP(:,end), ...
sed_res.concentrations.POC(:,end), ...
sed_res.concentrations.DOP(:,end), ...
sed_res.concentrations.DOC(:,end), ...
sed_res.concentrations.O2(:,end), ...
sed_res.concentrations.NO3(:,end), ...
sed_res.concentrations.NH4(:,end), ...
sed_res.concentrations.NH3(:,end), ...
sed_res.concentrations.FeOH3(:,end), ...
sed_res.concentrations.FeOOH(:,end), ...
sed_res.concentrations.Fe2(:,end), ...
sed_res.concentrations.SO4(:,end), ...
sed_res.concentrations.H2S(:,end), ...
sed_res.concentrations.HS(:,end), ...
sed_res.concentrations.PO4(:,end), ...
sed_res.concentrations.PO4adsa(:,end), ...
sed_res.concentrations.PO4adsb(:,end), ...
sed_res.concentrations.S0(:,end), ...
sed_res.concentrations.S8(:,end), ...
sed_res.concentrations.FeS(:,end), ...
sed_res.concentrations.FeS2(:,end), ...
sed_res.concentrations.AlOH3(:,end), ...
sed_res.concentrations.Ca2(:,end), ...
sed_res.concentrations.Ca3PO42(:,end), ...
sed_res.concentrations.OMS(:,end), ...
sed_res.concentrations.H(:,end), ...
sed_res.concentrations.OH(:,end), ...
sed_res.concentrations.CO2(:,end), ...
sed_res.concentrations.CO3(:,end), ...
sed_res.concentrations.HCO3(:,end), ...
sed_res.concentrations.H2CO3(:,end), ...
sed_res.concentrations.Chl(:,end)], 'delimiter', '\t', '-append')
