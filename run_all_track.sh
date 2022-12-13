#!/bin/sh
#SBATCH -N 1  --ntasks-per-node=6 --mem=256GB
#SBATCH -t 0:30:00
#SBATCH -A hurricane
#SBATCH -J chgres_driver
#SBATCH -q debug
##SBATCH -q debug
##SBATCH -q batch --partition=bigmem
#SBATCH -o log.cube.%j
#SBATCH -e log.cube.%j
##SBATCH --exclusive
#SBATCH -D.
set -x
hafstrack=/scratch1/NCEPDEV/hwrf/noscrub/${USER}/hafstrak/
rm -rf *hafs.trak.atcfunix
rm -rf ATCF
rm -rf figures	
for cyc in 2020082512 2020082518 2022072712  2022072606
  do
for dir in ${hafstrack}/*
  
 do
   echo ${dir} 
   veg_type=`echo "${dir}" | awk -F"_" '{print $5}' | awk -F"_" '{print $NF}'`
   echo ${veg_type}
 
  ymdh=${1:-${cyc}}
  stormModel=${2:-HAFS${veg_type}}
  echo $stormModel
  stormname=${3:-LAURA}
  stormid=${4:-13L}
  #COMhafs=${dir}
  COMhafs=${5:-${COMhafs:-/scratch1/NCEPDEV/hwrf/scrub/${USER}/plotrack/}}
  HOMEgraph=${HOMEgraph:-/scratch1/NCEPDEV/hwrf/save/Bantwale.Enyew/hafs_graphics_202211}
  STORMID=`echo ${stormid} | tr '[a-z]' '[A-Z]' `
  stormid=`echo ${stormid} | tr '[A-Z]' '[a-z]' `
  STORMNAME=`echo ${stormname} | tr '[a-z]' '[A-Z]' `
  stormname=`echo ${stormname} | tr '[A-Z]' '[a-z]' `

  stormnmid=`echo ${stormname}${stormid} | tr '[A-Z]' '[a-z]' `
  STORMNMID=`echo ${stormnmid} | tr '[a-z]' '[A-Z]' `
  STORMNM=${STORMNMID:0:-3}
  stormnm=${STORMNM,,}
  STID=${STORMNMID: -3}
  stid=${STID,,}
  STORMNUM=${STID:0:2}
  BASIN1C=${STID: -1}
  basin1c=${BASIN1C,,}
  yyyy=`echo ${ymdh} | cut -c1-4`

  cp ${dir}/${stormid}.${ymdh}.hafs.trak.atcfunix  ./${stormid}.${ymdh}_${veg_type}.hafs.trak.atcfunix
  sed -i 's/HAFS/'${stormModel}'/' ./${stormid}.${ymdh}_${veg_type}.hafs.trak.atcfunix
  cat ./${stormid}.${ymdh}_${veg_type}.hafs.trak.atcfunix >> ./${stormid}.${ymdh}.hafs.trak.atcfunix
  nset=""

done
 
modelLabels="['BEST','HAFSmodis','HAFSviirs','HWRF']"
modelColors="['black','cyan','red','purple']"
modelMarkers="['hr','.','.','.']"
modelMarkerSizes="[18,15,15,15]"
stormModel=${2:-HAFS}


#atcfFile=${6:-${dir}/${stormid}.${ymdh}.hafs.trak.atcfunix}

#export HOMEgraph=${HOMEgraph:-/scratch1/NCEPDEV/hwrf/scrub/${USER}/plotrack}
export USHgraph=${USHgraph:-/scratch1/NCEPDEV/hwrf/save/Bantwale.Enyew/hafs_graphics_202211/ush}
export WORKgraph=${WORKgraph:-/scratch1/NCEPDEV/hwrf/scrub/${USER}/plotrack}
export COMgraph=${COMgraph:-/scratch1/NCEPDEV/hwrf/scrub/${USER}/plotrack}

atcfFile=${6:-${WORKgraph}/${stormid}.${ymdh}.hafs.trak.atcfunix}
source ${USHgraph}/graph_pre_job.sh.inc
export machine=${WHERE_AM_I:-wcoss_cray} # platforms: wcoss_cray, wcoss_dell_p3, hera, orion, jet

if [ ${machine} = hera ]; then

  export ADECKgraph=${ADECKgraph:-/scratch1/NCEPDEV/hwrf/noscrub/input/abdeck/aid}
  export BDECKgraph=${BDECKgraph:-/scratch1/NCEPDEV/hwrf/noscrub/input/abdeck/btk}
  export cartopyDataDir=${cartopyDataDir:-/scratch1/NCEPDEV/hwrf/noscrub/local/share/cartopy}


fi


if [ ${basin1c} = 'l' ]; then
  basin2c='al'
  BASIN2C='AL'
  BASIN='NATL'

fi

work_dir="${WORKgraph}"
archbase="${COMgraph}/figures"
archdir="${archbase}/RT${yyyy}_${BASIN}/${STORMNM}${STID}/${STORMNM}${STID}.${ymdh}"

mkdir -p ${work_dir}
cd ${work_dir}

if [ -f ${atcfFile} ]; then
  atcfFile=${atcfFile}
elif [ -f ${atcfFile%.all} ]; then
  atcfFile=${atcfFile%.all}
else
  echo "File ${atcfFile} does not exist"
  echo 'SCRIPT WILL EXIT'
  exit 1
fi

# make the track and intensity plots
sh plotATCF.sh ${STORMNM} ${STID} ${ymdh} ${stormModel} ${COMhafs} ${ADECKgraph} ${BDECKgraph} ${HOMEgraph}/ush/python ${WORKgraph} ${archdir} ${modelLabels} ${modelColors} ${modelMarkers} ${modelMarkerSizes} ${nset}

date
done
echo 'job done'

