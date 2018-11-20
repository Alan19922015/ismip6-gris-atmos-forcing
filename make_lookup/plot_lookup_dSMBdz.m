% Plot the lookup tables

lookup_file='../Data/lookup/TdSMBdz_trans_lookup_MAR37_b25.nc';

% basin definition
load ../Data/Basins/ExtBasinMasks25.mat

figure

% produce custom line colors
cmap = colormap(jet(17));
colororder = cmap(1:1:17,:);
set(0,'DefaultAxesColorOrder', colororder);

lookup = ncload(lookup_file);

for t=1:5:85
for b=1:25
    subplot(5,5,b)
    hold on; box on;
    eval(['look = lookup.dSMBdz_ltbl(:,b,t);']);
    plot(lookup.z,look(:),'-')
    title(['B' num2str(bas.ids(b)) ' ID' num2str(b) ])
    axis([0 3300 -0.006 0.001])
end
end
cb = colorbar;
caxis([0 85])
set(cb,'Ticks',[5:15:85])

% print('-dpng', '-r300', [lookup_file]); 
