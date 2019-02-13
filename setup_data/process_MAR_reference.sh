#!/bin/bash
# Make SMB forcing from original MAR files 
# Heiko Goelzer 2019 (h.goelzer@uu.nl)

#### Present-day reference is specific per scenario !

# Expected input data on archive
# MIROC5-histo_1950_2005/
#	MARv3.9-yearly-MIROC5-histo-1950.nc
# MIROC5-rcp85_2006_2100/
#	MARv3.9-yearly-MIROC5-rcp85-2006.nc

datapath=/Volumes/ISMIP6/Data/Raw/SMB/MAR3.9/
#datapath=/work/hgoelzer/Processing/RCM/MAR3.9/

gcm=MIROC5
scen=rcp85

#gcm=NorESM1
#scen=rcp85

mkdir -p proc
cd proc
# Collect files from hist and rcp 
for i in `seq 1960 1989`; do
	cp ${datapath}/${gcm}-histo_1950_2005/MARv3.9-yearly-${gcm}-histo-${i}.nc ./MAR_${i}.nc
done

# add time information 
for i in `seq 1960 1989`; do
    filename=MAR_${i}.nc
    ncks -O --mk_rec_dmn time $filename $filename
    ncap2 -O -s "time=time*0+$i-1900" $filename $filename
done

# concat them to one time series
ncrcat -O MAR_1960.nc MAR_1961.nc MAR_1962.nc MAR_1963.nc MAR_1964.nc MAR_1965.nc MAR_1966.nc MAR_1967.nc MAR_1968.nc MAR_1969.nc MAR_1970.nc MAR_1971.nc MAR_1972.nc MAR_1973.nc MAR_1974.nc MAR_1975.nc MAR_1976.nc MAR_1977.nc MAR_1978.nc MAR_1979.nc MAR_1980.nc MAR_1981.nc MAR_1982.nc MAR_1983.nc MAR_1984.nc MAR_1985.nc MAR_1986.nc MAR_1987.nc MAR_1988.nc MAR_1989.nc  MARv3.9-yearly-${gcm}-${scen}-1960-1989.nc

# Long-term average
ncra -O  MARv3.9-yearly-${gcm}-${scen}-1960-1989.nc MARv3.9-yearly-${gcm}-${scen}-ltm1960-2089.nc

# Copy to destination
/bin/cp MARv3.9-yearly-${gcm}-${scen}-ltm1960-1989.nc ../../Data/MAR/

# Extract topg
ncks -O -v SRF MARv3.9-yearly-${gcm}-${scen}-ltm1960-1989.nc ../../Data/MAR/MARv3.9_topg_01000m.nc
ncrename -v SRF,topg ../../Data/MAR/MARv3.9_topg_01000m.nc
