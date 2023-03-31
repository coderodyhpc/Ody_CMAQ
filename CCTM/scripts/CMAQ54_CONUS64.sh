#!/bin/bash

# ===================== CCTMv5.4 Run Script =========================
# To report problems or request help with this script
# contact us at support@odyhpc.com
# ===================================================================

# ===================================================================
#> Runtime Environment Options
# ===================================================================

 echo 'Start Model Run At ' `date`
 export CMAQ_HOME=/home/ubuntu/CMAQv5.4
 export CMAQ_DATA=$CMAQ_HOME/dat3

#> Toggle Diagnostic Mode which will print verbose information to standard output
 export CTM_DIAG_LVL=0

#> Choose compiler
 export compiler=gcc
 export Vrsn=11.3
 export compilerString=${compiler}${compilerVrsn}

#> Set General Parameters for Configuring the Simulation
 export VRSN=v54               #> Code Version
 export PROC=mpi               #> serial or mpi
 export MECH=cb6r5_ae7_aq      #> Mechanism ID
 export EMIS=WR413_MYR
 export APPL=CONUS18_12US1     #> Application Name (e.g. Gridname)

#> Define RUNID as any combination of parameters above or others
 export RUNID=${VRSN}_${compilerString}_${APPL}

#> Set the build directory.
 export BLD=${CMAQ_HOME}/CCTM/scripts/BLD_CCTM_${VRSN}_${compilerString}
 export EXEC=CCTM_${VRSN}.exe

#> Output Each line of Runscript to Log File
 if [ $CTM_DIAG_LVL -ne 0 ]
 then
   set echo
 fi

#> Set Working, Input, and Output Directories
 export WORKDIR=${CMAQ_HOME}/CCTM/scripts          #> Working Directory. Where the runscript is.
 export OUTDIR=${CMAQ_HOME}/CCTM/output            #> Output Directory
 export INPDIR=${CMAQ_DATA}/2018CONUS              #> Input Directory
 export LOGDIR=${OUTDIR}/LOGS                      #> Log Directory Location
 export NMLpath=${BLD}                             #> Location of Namelists. Common places are:
                                                   #>   ${WORKDIR} | ${CCTM_SRC}/MECHS/${MECH} | ${BLD}
 export VEXILLA="--mca io_ompi_grouping_option 4 --mca io_ompi_bytes_per_agg 2147483648"
# =====================================================================
#> CCTM Configuration Options
# =====================================================================
 rm -rf $OUTDIR 
#> Set Start and End Days for looping
 export NEW_START=TRUE              #> Set to FALSE for model restart
 export START_DATE="2017-12-22"     #> beginning date (July 1, 2016)
 export END_DATE="2017-12-22"       #> ending date    (July 1, 2016)

#> Set Timestepping Parameters
 STTIME=000000            #> beginning GMT time (HHMMSS)
 NSTEPS=240000            #> time duration (HHMMSS) for this run
 TSTEP=010000            #> output time step interval (HHMMSS)

#> Horizontal domain decomposition - assuming MPI
   NPCOL=8
   NPROW=8
   NPROCS=$((NPCOL*NPROW))
   export NPCOL_NPROW="$NPCOL $NPROW"

#> Define Execution ID: e.g. [CMAQ-Version-Info]_[User]_[Date]_[Time]
export EXECUTION_ID="CMAQ_CCTM${VRSN}_`id -u -n`_`date -u +%Y%m%d_%H%M%S_%N`"    #> Inform IO/API of the Execution ID
echo ""
echo "---CMAQ EXECUTION ID: $EXECUTION_ID ---"

#> Keep or Delete Existing Output Files
CLOBBER_DATA=TRUE

#> Logfile Options
#> Master Log File Name; uncomment to write standard output to a log, otherwise write to screen
export LOGFILE=$CMAQ_HOME/$RUNID.log
if [ ! -e $LOGDIR ]
then
  mkdir -p $LOGDIR
fi
export PRINT_PROC_TIME=Y           #> Print timing for all science subprocesses to Logfile
                                   #>   [ default: TRUE or Y ]
export STDOUT=T                    #> Override I/O-API trying to write information to both the processor
                                   #>   logs and STDOUT [ options: T | F ]

export GRID_NAME=12US1              #> check GRIDDESC file for GRID_NAME options
export GRIDDESC=$INPDIR/GRIDDESC    #> grid description file

#> Retrieve the number of columns, rows, and layers in this simulation
NZ=35
NX=459
NY=299
NCELLS=`echo "${NX} * ${NY} * ${NZ}" | bc -l`

#> Output Species and Layer Options
   #> CONC file species; comment or set to "ALL" to write all species to CONC
   export CONC_SPCS="CO SO2 O3 NO ANO3I ANO3J ANO3K NO2 NO3 N2O5 HONO HNO3 PNA CRON CLNO2 CLNO3 FORM ISOP GLY NH3 ANH4I ANH4J ASO4I ASO4J AALJ ASIJ ACAJ AFEJ ATIJ AECI AECJ NTR1 NTR2 INTR PAN PANX OPAN ALVPO1I ASVPO1I ASVPO2I APOCI ALVPO1J ASVPO1J ASVPO2J ASVPO3J AIVPO1J APOCJ ALVOO1I ALVOO2I ASVOO1I ASVOO2I AISO1J AISO2J AISO3J AMT1J AMT2J AMT3J AMT4J AMT5J AMT6J AMTNO3J AMTHYDJ AGLYJ ASQTJ AORGCJ AOLGBJ AOLGAJ ALVOO1J ALVOO2J ASVOO1J ASVOO2J ASVOO3J APCSOJ AAVB1J AAVB2J AAVB3J AAVB4J APNCOMI APNCOMJ ANAI ANAJ ACLI ACLJ AOTHRI AOTHRJ AMNJ AMGJ AKJ"
   export CONC_BLEV_ELEV=" 1 35" #> CONC file layer range; comment to write all layers to CONC

   #> ACONC file species; comment or set to "ALL" to write all species to ACONC
   #export AVG_CONC_SPCS="O3 NO CO NO2 ASO4I ASO4J NH3"
   export AVG_CONC_SPCS="ALL"
   export ACONC_BLEV_ELEV=" 1 1" #> ACONC file layer range; comment to write all layers to ACONC
   export AVG_FILE_ENDTIME=N     #> override default beginning ACONC timestamp [ default: N ]

   #> Synchronization Time Step and Tolerance Options
export CTM_MAXSYNC=300       #> max sync time step (sec) [ default: 720 ]
export CTM_MINSYNC=60        #> min sync time step (sec) [ default: 60 ]
export SIGMA_SYNC_TOP=0.7    #> top sigma level thru which sync step determined [ default: 0.7 ]
#export ADV_HDIV_LIM=0.95    #> maximum horiz. div. limit for adv step adjust [ default: 0.9 ]
export CTM_ADV_CFL=0.95      #> max CFL [ default: 0.75]
#export RB_ATOL=1.0E-09      #> global ROS3 solver absolute tolerance [ default: 1.0E-07 ]

#> Science Options
export CTM_OCEAN_CHEM=Y      #> Flag for ocean halgoen chemistry and sea spray aerosol emissions [ default: Y ]
export CTM_WB_DUST=N         #> use inline windblown dust emissions [ default: Y ]
export CTM_WBDUST_BELD=BELD3 #> landuse database for identifying dust source regions
                             #>    [ default: UNKNOWN ]; ignore if CTM_WB_DUST = N
export CTM_LTNG_NO=N         #> turn on lightning NOx [ default: N ]
export KZMIN=Y               #> use Min Kz option in edyintb [ default: Y ],
                             #>    otherwise revert to Kz0UT
export CTM_MOSAIC=N          #> landuse specific deposition velocities [ default: N ]
export CTM_STAGE_P22=N       #> Pleim et al. 2022 Aerosol deposition model [default: N]
export CTM_STAGE_E20=Y       #> Emerson et al. 2020 Aerosol deposition model [default: Y]
export CTM_STAGE_S22=N
export CTM_FST=N             #> mosaic method to get land-use specific stomatal flux
                             #>    [ default: N ]
export PX_VERSION=Y          #> WRF PX LSM
export CLM_VERSION=N         #> WRF CLM LSM
export NOAH_VERSION=N        #> WRF NOAH LSM
export CTM_ABFLUX=Y          #> ammonia bi-directional flux for in-line deposition
                             #>    velocities [ default: N ]
export CTM_BIDI_FERT_NH3=T   #> subtract fertilizer NH3 from emissions because it will be handled
                             #>    by the BiDi calculation [ default: Y ]
export CTM_HGBIDI=N          #> mercury bi-directional flux for in-line deposition
                             #>    velocities [ default: N ]
export CTM_SFC_HONO=Y        #> surface HONO interaction [ default: Y ]
export CTM_GRAV_SETL=Y       #> vdiff aerosol gravitational sedimentation [ default: Y ]

export CTM_BIOGEMIS_BE=Y     #> calculate in-line biogenic emissions with BEIS
export CTM_BIOGEMIS_MG=N     #> turns on MEGAN biogenic emission [ default: N ]
export BDSNP_MEGAN=N         #> turns on BDSNP soil NO emissions [ default: N ]

#> Vertical Extraction Options
export VERTEXT=N
export VERTEXT_COORD_PATH=${WORKDIR}/lonlat.csv

#> I/O Controls
export IOAPI_LOG_WRITE=F     #> turn on excess WRITE3 logging [ options: T | F ]
export FL_ERR_STOP=N         #> stop on inconsistent input files
export PROMPTFLAG=F          #> turn on I/O-API PROMPT*FILE interactive mode [ options: T | F ]
export IOAPI_OFFSET_64=YES   #> support large timestep records (>2GB/timestep record) [ options: YES | NO ]
export IOAPI_CHECK_HEADERS=N #> check file headers [ options: Y | N ]
export CTM_EMISCHK=N         #> Abort CMAQ if missing surrogates from emissions Input files
export EMISDIAG=F            #> Print Emission Rates at the output time step after they have been
                             #>   scaled and modified by the user Rules [options: F | T or 2D | 3D | 2DSUM ]
                             #>   Individual streams can be modified using the variables:
                             #>       GR_EMIS_DIAG_## | STK_EMIS_DIAG_## | BIOG_EMIS_DIAG
                             #>       MG_EMIS_DIAG    | LTNG_EMIS_DIAG   | DUST_EMIS_DIAG
                             #>       SEASPRAY_EMIS_DIAG
                             #>   Note that these diagnostics are different than other emissions diagnostic
                             #>   output because they occur after scaling.
export EMISDIAG_SUM=F        #> Print Sum of Emission Rates to Gridded Diagnostic File

#> Diagnostic Output Flags
export CTM_CKSUM=Y           #> checksum report [ default: Y ]
export CLD_DIAG=N            #> cloud diagnostic file [ default: N ]

export CTM_PHOTDIAG=Y        #> photolysis diagnostic file [ default: N ]
export NLAYS_PHOTDIAG="1"    #> Number of layers for PHOTDIAG2 and PHOTDIAG3 from
                             #>     Layer 1 to NLAYS_PHOTDIAG  [ default: all layers ]
#export NWAVE_PHOTDIAG="294 303 310 316 333 381 607"  #> Wavelengths written for variables
                                                      #>   in PHOTDIAG2 and PHOTDIAG3
                                                      #>   [ default: all wavelengths ]

export CTM_SSEMDIAG=N        #> sea-spray emissions diagnostic file [ default: N ]
export CTM_DUSTEM_DIAG=N     #> windblown dust emissions diagnostic file [ default: N ];
                             #>     Ignore if CTM_WB_DUST = N
export CTM_DEPV_FILE=Y       #> deposition velocities diagnostic file [ default: N ]
export VDIFF_DIAG_FILE=N     #> vdiff & possibly aero grav. sedimentation diagnostic file [ default: N ]
export LTNGDIAG=Y            #> lightning diagnostic file [ default: N ]
export B3GTS_DIAG=Y          #> BEIS mass emissions diagnostic file [ default: N ]
export CTM_WVEL=Y            #> save derived vertical velocity component to conc
                             #>    file [ default: Y ]

# =====================================================================
#> Input Directories and Filenames
# =====================================================================

ICpath=$INPDIR/icbc/CMAQv54_2018_108NHEMI_M3DRY  #> initial conditions input directory
BCpath=$INPDIR/icbc/CMAQv54_2018_108NHEMI_M3DRY  #> boundary conditions input directory
EMISpath=$INPDIR/emis/cb6r3_ae6_20200131_MYR/cmaq_ready/merged_nobeis_norwc 
EMISpath2=$INPDIR/emis/cb6r3_ae6_20200131_MYR/premerged/rwc
IN_PTpath=$INPDIR/emis/cb6r3_ae6_20200131_MYR/cmaq_ready #> point source emissions input directory
IN_LTpath=$INPDIR/nldn                   #> lightning NOx input directory
METpath=$INPDIR/met/WRFv4.3.3_LTNG_MCIP5.3.3_compressed                  #> meteorology input directory
#JVALpath=$INPDIR/jproc                        #> offline photolysis rate table directory
OMIpath=$BLD                                  #> ozone column data for the photolysis model
EPICpath=$INPDIR/epic                         #> BELD landuse data for windblown dust model
LUpath=$INPDIR/surface
SZpath=$INPDIR/surface                        #> surf zone file for in-line seaspray emissions

# =====================================================================
#> Begin Loop Through Simulation Days
# =====================================================================
rtarray=""

TODAYG=${START_DATE}
TODAYJ=`date -ud "${START_DATE}" +%Y%j` #> Convert YYYY-MM-DD to YYYYJJJ
START_DAY=${TODAYJ}
STOP_DAY=`date -ud "${END_DATE}" +%Y%j` #> Convert YYYY-MM-DD to YYYYJJJ
NDAYS=0

while [ $TODAYJ -le $STOP_DAY ]            #>Compare dates in terms of YYYYJJJ
do
  NDAYS=`echo "${NDAYS} + 1" | bc -l`

  #> Retrieve Calendar day Information
  YYYYMMDD=`date -ud "${TODAYG}" +%Y%m%d` #> Convert YYYY-MM-DD to YYYYMMDD
  YYYYMM=`date -ud "${TODAYG}" +%Y%m`     #> Convert YYYY-MM-DD to YYYYMM
  YYMMDD=`date -ud "${TODAYG}" +%y%m%d`   #> Convert YYYY-MM-DD to YYMMDD
  YYYY=`date -ud "${TODAYG}" +%Y`             #> Convert YYYY-MM-DD to YYYY
  MM=`date -ud "${TODAYG}" +%m`
  YYYYJJJ=$TODAYJ

  #> Calculate Yesterday's Date
  YESTERDAY=`date -ud "${TODAYG}-1days" +%Y%m%d` #> Convert YYYY-MM-DD to YYYYJJJ
# =====================================================================
#> Set Output String and Propagate Model Configuration Documentation
# =====================================================================
  echo ""
  echo "Set up input and output files for Day ${TODAYG}."

  #> set output file name extensions
  export CTM_APPL=${RUNID}_${YYYYMMDD}

  #> Copy Model Configuration To Output Folder
  if [ ! -d $OUTDIR ]; then
    mkdir -p $OUTDIR
  fi
  cp $BLD/CCTM_${VRSN}.cfg $OUTDIR/CCTM_${CTM_APPL}.cfg

# =====================================================================
#> Input Files (Some are Day-Dependent)
# =====================================================================

  #> Initial conditions
  if [ "$NEW_START" == "true" ] || [ "$NEW_START" == "TRUE" ]
  then
#     export ICFILE=ICON_v532_CMAQv53_TS_regrid_12US1_20091201
     export ICFILE=CCTM_CGRID_v54_cb6r5_ae7_aq_WR413_MYR_M3DRY_2018_12US1_20171221.nc
     export INIT_MEDC_1=notused
     export INITIAL_RUN=Y #related to restart soil information file
  else
     ICpath=$OUTDIR
     export ICFILE=CCTM_CGRID_${RUNID}_${YESTERDAY}.nc
     export INIT_MEDC_1=$ICpath/CCTM_MEDIA_CONC_${RUNID}_${YESTERDAY}.nc
     export INITIAL_RUN=N
  fi

  #> Boundary conditions
  BCFILE=BCON_CONC_12US1_CMAQv54_2018_108NHEMI_M3DRY_regrid_${YYYYMM}.nc

  echo "I/BCFILE $ICFILE $BCFILE"
  #> Off-line photolysis rates
  #export JVALfile=JTABLE_${YYYYJJJ}

  #> Ozone column data
  OMIfile=OMI_1979_to_2019.dat

  #> Optics file
  OPTfile=PHOT_OPTICS.dat

  #> MCIP meteorology files
  export GRID_BDY_2D=$METpath/GRIDBDY2D_$YYYYMMDD.nc4
  export GRID_CRO_2D=$METpath/GRIDCRO2D_$YYYYMMDD.nc4
  export GRID_CRO_3D=$METpath/GRIDCRO3D_$YYYYMMDD.nc4
  export GRID_DOT_2D=$METpath/GRIDDOT2D_$YYYYMMDD.nc4
  export MET_CRO_2D=$METpath/METCRO2D_$YYYYMMDD.nc4
  export MET_CRO_3D=$METpath/METCRO3D_$YYYYMMDD.nc4
  export MET_DOT_3D=$METpath/METDOT3D_$YYYYMMDD.nc4
  export MET_BDY_3D=$METpath/METBDY3D_$YYYYMMDD.nc4
  export LUFRAC_CRO=$METpath/LUFRAC_CRO_$YYYYMMDD.nc4

  #> Control Files
  #>
  #> IMPORTANT NOTE
  #>
  #> The DESID control files defined below are an integral part of controlling the behavior of the model simulation.
  #> Among other things, they control the mapping of species in the emission files to chemical species in the model and
  #> several aspects related to the simulation of organic aerosols.
  #> Please carefully review the DESID control files to ensure that they are configured to be consistent with the assumptions
  #> made when creating the emission files defined below and the desired representation of organic aerosols.
  #> For further information, please see:
  #> + AERO7 Release Notes section on 'Required emission updates':
  #>   https://github.com/USEPA/CMAQ/blob/master/DOCS/Release_Notes/aero7_overview.md
  #> + CMAQ User's Guide section 6.9.3 on 'Emission Compatability':
  #>   https://github.com/USEPA/CMAQ/blob/master/DOCS/Users_Guide/CMAQ_UG_ch06_model_configuration_options.md#6.9.3_Emission_Compatability
  #> + Emission Control (DESID) Documentation in the CMAQ User's Guide:
  #>   https://github.com/USEPA/CMAQ/blob/master/DOCS/Users_Guide/Appendix/CMAQ_UG_appendixB_emissions_control.md
  #>
  export DESID_CTRL_NML=${BLD}/CMAQ_Control_DESID.nml
  export DESID_CHEM_CTRL_NML=${BLD}/CMAQ_Control_DESID_${MECH}.nml

  #> The following namelist configures aggregated output (via the Explicit and Lumped
  #> Air Quality Model Output (ELMO) Module), domain-wide budget output, and chemical
  #> family output.
  export MISC_CTRL_NML=${BLD}/CMAQ_Control_Misc.nml

  #> The following namelist controls the mapping of meteorological land use types and the NH3 and Hg emission
  #> potentials
  export STAGECTRL_NML=${BLD}/CMAQ_Control_STAGE.nml
 
  #> Spatial Masks For Emissions Scaling
  #export CMAQ_MASKS=$SZpath/OCEAN_${MM}_L3m_MC_CHL_chlor_a_12NE3.nc #> horizontal grid-dependent ocean file
  export CMAQ_MASKS=$SZpath/OCEAN_${MM}_L3m_MC_CHL_chlor_a_12US1.nc

#> NEW IS IT NEEDED ? Determine Representative Emission Days
#  set EMDATES = /work/MOD3DATA/CMAQv53_TS/emis_dates/${YYYY}/smk_merge_dates_${YYYYMM}.txt
#  set intable = `grep "^${YYYYMMDD}" $EMDATES`
#  set Date     = `echo $intable[1] | cut -d, -f1`
#  set aveday_N = `echo $intable[2] | cut -d, -f1`
#  set aveday_Y = `echo $intable[3] | cut -d, -f1`
#  set mwdss_N  = `echo $intable[4] | cut -d, -f1`
#  set mwdss_Y  = `echo $intable[5] | cut -d, -f1`
#  set week_N   = `echo $intable[6] | cut -d, -f1`
#  set week_Y   = `echo $intable[7] | cut -d, -f1`
#  set all      = `echo $intable[8] | cut -d, -f1`

  #> Gridded Emissions Files 
  export N_EMIS_GR=2
  EMISfile=emis_mole_all_${YYYYMMDD}_12US1_nobeis_norwc_WR413_MYR_${YYYY}.nc4
  export GR_EMIS_001=${EMISpath}/${EMISfile}
  export GR_EMIS_LAB_001=GRIDDED_EMIS
  export GR_EM_SYM_DATE_001=F 

  EMISfile=emis_mole_rwc_${YYYYMMDD}_12US1_cmaq_cb6_WR413_MYR_${YYYY}.nc4
  export GR_EMIS_002=${EMISpath2}/${EMISfile}
  export GR_EMIS_LAB_002=GR_RES_FIRES
  export GR_EM_SYM_DATE_002=F 

  #> In-line point emissions configuration
  export N_EMIS_PT=10          #> Number of elevated source groups

  STKCASEE=12US1_cmaq_cb6_WR413_MYR_2018  
  STKCASEG=12US1_WR413_MYR_2018           
  STKCASEE_2017=12US1_cmaq_cb6_WR413_MYR_2017
  STKCASEG_2017=12US1_WR413_MYR_2017

  # Time-Independent Stack Parameters for Inline Point Sources
  export STK_GRPS_001=$IN_PTpath/ptnonipm/stack_groups_ptnonipm_${STKCASEG_2017}.nc4
  export STK_GRPS_002=$IN_PTpath/ptegu/stack_groups_ptegu_${STKCASEG_2017}.nc4
  export STK_GRPS_003=$IN_PTpath/othpt/stack_groups_othpt_${STKCASEG_2017}.ncf
  export STK_GRPS_004=$IN_PTpath/ptagfire/stack_groups_ptagfire_${YYYYMMDD}_${STKCASEG_2017}.nc4
  export STK_GRPS_005=$IN_PTpath/ptfire/stack_groups_ptfire_${YYYYMMDD}_${STKCASEG_2017}.nc4
  export STK_GRPS_006=$IN_PTpath/ptfire_grass/stack_groups_ptfire_grass_${YYYYMMDD}_${STKCASEG_2017}.nc4
  export STK_GRPS_007=$IN_PTpath/ptfire_othna/stack_groups_ptfire_othna_${YYYYMMDD}_${STKCASEG_2017}.nc4
  export STK_GRPS_008=$IN_PTpath/pt_oilgas/stack_groups_pt_oilgas_${STKCASEG_2017}.nc4
  export STK_GRPS_009=$IN_PTpath/cmv_c1c2_12/stack_groups_cmv_c1c2_12_${STKCASEG_2017}.nc4
  export STK_GRPS_010=$IN_PTpath/cmv_c3_12/stack_groups_cmv_c3_12_${STKCASEG_2017}.nc4

  export STK_EMIS_001=$IN_PTpath/ptnonipm/inln_mole_ptnonipm_${YYYYMMDD}_${STKCASEE_2017}.nc4
  export STK_EMIS_002=$IN_PTpath/ptegu/inln_mole_ptegu_${YYYYMMDD}_${STKCASEE_2017}.nc4
  export STK_EMIS_003=$IN_PTpath/othpt/inln_mole_othpt_${YYYYMMDD}_${STKCASEE_2017}.nc4
  export STK_EMIS_004=$IN_PTpath/ptagfire/inln_mole_ptagfire_${YYYYMMDD}_${STKCASEE_2017}.nc4
  export STK_EMIS_005=$IN_PTpath/ptfire/inln_mole_ptfire_${YYYYMMDD}_${STKCASEE_2017}.nc4
  export STK_EMIS_006=$IN_PTpath/ptfire_grass/inln_mole_ptfire_grass_${YYYYMMDD}_${STKCASEE_2017}.nc4
  export STK_EMIS_007=$IN_PTpath/ptfire_othna/inln_mole_ptfire_othna_${YYYYMMDD}_${STKCASEE_2017}.nc4
  export STK_EMIS_008=$IN_PTpath/pt_oilgas/inln_mole_pt_oilgas_${YYYYMMDD}_${STKCASEE_2017}.nc4
  export STK_EMIS_009=$IN_PTpath/cmv_c1c2_12/inln_mole_cmv_c1c2_12_${YYYYMMDD}_${STKCASEE_2017}.nc4
  export STK_EMIS_010=$IN_PTpath/cmv_c3_12/inln_mole_cmv_c3_12_${YYYYMMDD}_${STKCASEE_2017}.nc4

  export STK_EMIS_LAB_001=PT_NONEGU
  export STK_EMIS_LAB_002=PT_EGU
  export STK_EMIS_LAB_003=PT_OTHER
  export STK_EMIS_LAB_004=PT_AGFIRES
  export STK_EMIS_LAB_005=PT_FIRES
  export STK_EMIS_LAB_006=PT_RXFIRES
  export STK_EMIS_LAB_007=PT_OTHFIRES
  export STK_EMIS_LAB_008=PT_OILGAS
  export STK_EMIS_LAB_009=PT_CMV_C1C2
  export STK_EMIS_LAB_010=PT_CMV_C3

  # Allow CMAQ to Use Point Source files with dates that do not
  # match the internal model date
  # To change default behaviour please see Users Guide for EMIS_SYM_DATE
  export STK_EM_SYM_DATE_001=T
  export STK_EM_SYM_DATE_002=T
  export STK_EM_SYM_DATE_003=T
  export STK_EM_SYM_DATE_004=T
  export STK_EM_SYM_DATE_005=T
  export STK_EM_SYM_DATE_006=T
  export STK_EM_SYM_DATE_007=T
  export STK_EM_SYM_DATE_008=T
  export STK_EM_SYM_DATE_009=T
  export STK_EM_SYM_DATE_010=T

  #> Lightning NOx configuration
  if [ "$CTM_LTNG_NO" == "Y" ] 
  then
     export LTNGNO="InLine"    #> set LTNGNO to "Inline" to activate in-line calculation

  #> In-line lightning NOx options
     export USE_NLDN=Y        #> use hourly NLDN strike file [ default: Y ]
     if [ "$USE_NLDN" == "Y" ]
     then
        export NLDN_STRIKES=${IN_LTpath}/NLDN_12km_60min_${YYYYMMDD}.ioapi
     fi
     export LTNGPARMS_FILE=${IN_LTpath}/LTNG_AllParms_12NE3.nc #> lightning parameter file
  fi

  #> In-line biogenic emissions configuration
  if [ "$CTM_BIOGEMIS_BE" == "Y" ]
  then
     IN_BEISpath=${INPDIR}/misc
     export GSPRO=$BLD/gspro_biogenics.txt
     export BEIS_NORM_EMIS=$IN_BEISpath/b3grd.smoke30_beis361_beld5.12US1.ncf
     export BEIS_SOILINP=$OUTDIR/CCTM_BSOILOUT_${RUNID}_${YESTERDAY}.nc
                             #> Biogenic NO soil input file; ignore if NEW_START = TRUE
  fi
  if [ "$CTM_BIOGEMIS_MG" == "Y" ]
  then
    export MEGAN_SOILINP=$OUTDIR/CCTM_MSOILOUT_${RUNID}_${YESTERDAY}.nc
                             #> Biogenic NO soil input file; ignore if INITIAL_RUN = Y
                             #>                            ; ignore if IGNORE_SOILINP = Y
         export MEGAN_CTS=$SZpath/megan3.2/CT3_CONUS.ncf
         export MEGAN_EFS=$SZpath/megan3.2/EFMAPS_CONUS.ncf
         export MEGAN_LDF=$SZpath/megan3.2/LDF_CONUS.ncf
         if [ "$BDSNP_MEGAN" == "Y"]
         then
            export BDSNPINP=$OUTDIR/CCTM_BDSNPOUT_${RUNID}_${YESTERDAY}.nc
            export BDSNP_FFILE=$SZpath/megan3.2/FERT_tceq_12km.ncf
            export BDSNP_NFILE=$SZpath/megan3.2/NDEP_tceq_12km.ncf
            export BDSNP_LFILE=$SZpath/megan3.2/LANDTYPE_tceq_12km.ncf
            export BDSNP_AFILE=$SZpath/megan3.2/ARID_tceq_12km.ncf
            export BDSNP_NAFILE=$SZpath/megan3.2/NONARID_tceq_12km.ncf
         fi
  fi

  #> Windblown dust emissions configuration
  if [ $CTM_WB_DUST == 'Y' ]
  then
     # Input variables for BELD3 Landuse option
     export DUST_LU_1=$LUpath/beld3_12US1_459X299_output_a.ncf
     export DUST_LU_2=$LUpath/beld4_12US1_459X299_output_tot.ncf
  fi


  #> In-line sea spray emissions configuration
  export OCEAN_1=$SZpath/OCEAN_${MM}_L3m_MC_CHL_chlor_a_12US1.nc

  #> Bidirectional ammonia configuration
  if [ "$CTM_ABFLUX" == "Y" ]
  then
     export E2C_SOIL=${INPDIR}/epic/${YYYY}r1_EPIC0509_12US1_soil.nc4
     export E2C_CHEM=${INPDIR}/epic/${YYYY}r1_EPIC0509_12US1_time${YYYYMMDD}.nc4
     export E2C_LU=${EPICpath}/beld4_12US1_2011.nc4
  fi

#> Inline Process Analysis 
  export CTM_PROCAN=N        #> use process analysis [ default: N]
#  if ( $?CTM_PROCAN ) then   # $CTM_PROCAN is defined
#     if ( $CTM_PROCAN == 'Y' || $CTM_PROCAN == 'T' ) then
##> process analysis global column, row and layer ranges
##       setenv PA_BCOL_ECOL "10 90"  # default: all columns
##       setenv PA_BROW_EROW "10 80"  # default: all rows
##       setenv PA_BLEV_ELEV "1  4"   # default: all levels
#        setenv PACM_INFILE ${NMLpath}/pa_${MECH}.ctl
#        setenv PACM_REPORT $OUTDIR/"PA_REPORT".${YYYYMMDD}
#     endif
#  endif

#> Sulfur Tracking Model (STM)
 export STM_SO4TRACK=N        #> sulfur tracking [ default: N ]
# if ( $?STM_SO4TRACK ) then
#    if ( $STM_SO4TRACK == 'Y' || $STM_SO4TRACK == 'T' ) then

#      #> option to normalize sulfate tracers [ default: Y ]
#      setenv STM_ADJSO4 Y

#    endif
# endif

# =====================================================================
#> Output Files
# =====================================================================

  #> set output file names
  export S_CGRID="$OUTDIR/CCTM_CGRID_${CTM_APPL}.nc"                  #> 3D Inst. Concentrations
  export CTM_CONC_1="$OUTDIR/CCTM_CONC_${CTM_APPL}.nc -v"             #> On-Hour Concentrations
  export A_CONC_1="$OUTDIR/CCTM_ACONC_${CTM_APPL}.nc -v"              #> Hourly Avg. Concentrations
  export MEDIA_CONC="$OUTDIR/CCTM_MEDIA_CONC_${CTM_APPL}.nc -v"       #> NH3 Conc. in Media
  export CTM_DRY_DEP_1="$OUTDIR/CCTM_DRYDEP_${CTM_APPL}.nc -v"        #> Hourly Dry Deposition
  export CTM_DEPV_DIAG="$OUTDIR/CCTM_DEPV_${CTM_APPL}.nc -v"          #> Dry Deposition Velocities
  export B3GTS_S="$OUTDIR/CCTM_B3GTS_S_${CTM_APPL}.nc -v"             #> Biogenic Emissions
  export BDSNPOUT="$OUTDIR/CCTM_BDSNPOUT_${CTM_APPL}.nc"      #> Soil Emissions
  export BEIS_SOILOUT="$OUTDIR/CCTM_BSOILOUT_${CTM_APPL}.nc"      #> Soil Emissions
  export MEGAN_SOILOUT="$OUTDIR/CCTM_MSOILOUT_${CTM_APPL}.nc"      #> Soil Emissions
  export CTM_WET_DEP_1="$OUTDIR/CCTM_WETDEP1_${CTM_APPL}.nc -v"       #> Wet Dep From All Clouds
  export CTM_WET_DEP_2="$OUTDIR/CCTM_WETDEP2_${CTM_APPL}.nc -v"       #> Wet Dep From SubGrid Clouds
  export CTM_WET_DEP_1="$OUTDIR/CCTM_WETDEP1_${CTM_APPL}.nc -v"    #> Wet Dep From All Clouds
  export CTM_WET_DEP_2="$OUTDIR/CCTM_WETDEP2_${CTM_APPL}.nc -v"    #> Wet Dep From SubGrid Clouds
  export CTM_ELMO_1="$OUTDIR/CCTM_ELMO_${CTM_APPL}.nc -v"       #> On-Hour Particle Diagnostics
  export CTM_AELMO_1="$OUTDIR/CCTM_AELMO_${CTM_APPL}.nc -v"      #> Hourly Avg. Particle Diagnostics
  export CTM_RJ_1="$OUTDIR/CCTM_PHOTDIAG1_${CTM_APPL}.nc -v"          #> 2D Surface Summary from Inline Photolysis
  export CTM_RJ_2="$OUTDIR/CCTM_PHOTDIAG2_${CTM_APPL}.nc -v"          #> 3D Photolysis Rates
  export CTM_RJ_3="$OUTDIR/CCTM_PHOTDIAG3_${CTM_APPL}.nc -v"          #> 3D Optical and Radiative Results from Photolysis
  export CTM_SSEMIS_1="$OUTDIR/CCTM_SSEMIS_${CTM_APPL}.nc -v"         #> Sea Spray Emissions
  export CTM_DUST_EMIS_1="$OUTDIR/CCTM_DUSTEMIS_${CTM_APPL}.nc -v"    #> Dust Emissions
  export CTM_IPR_1="$OUTDIR/CCTM_PA_1_${CTM_APPL}.nc -v"              #> Process Analysis
  export CTM_IPR_2="$OUTDIR/CCTM_PA_2_${CTM_APPL}.nc -v"              #> Process Analysis
  export CTM_IPR_3="$OUTDIR/CCTM_PA_3_${CTM_APPL}.nc -v"              #> Process Analysis
  export CTM_IRR_1="$OUTDIR/CCTM_IRR_1_${CTM_APPL}.nc -v"             #> Chem Process Analysis
  export CTM_IRR_2="$OUTDIR/CCTM_IRR_2_${CTM_APPL}.nc -v"             #> Chem Process Analysis
  export CTM_IRR_3="$OUTDIR/CCTM_IRR_3_${CTM_APPL}.nc -v"             #> Chem Process Analysis
  export CTM_DRY_DEP_MOS="$OUTDIR/CCTM_DDMOS_${CTM_APPL}.nc -v"       #> Dry Dep
  export CTM_DEPV_MOS="$OUTDIR/CCTM_DEPVMOS_${CTM_APPL}.nc -v"    #> Dry Dep Velocity
  export CTM_VDIFF_DIAG="$OUTDIR/CCTM_VDIFF_DIAG_${CTM_APPL}.nc -v"   #> Vertical Dispersion Diagnostic
  export CTM_VSED_DIAG="$OUTDIR/CCTM_VSED_DIAG_${CTM_APPL}.nc -v"     #> Particle Grav. Settling Velocity
  export CTM_LTNGDIAG_1="$OUTDIR/CCTM_LTNGHRLY_${CTM_APPL}.nc -v"     #> Hourly Avg Lightning NO
  export CTM_LTNGDIAG_2="$OUTDIR/CCTM_LTNGCOL_${CTM_APPL}.nc -v"      #> Column Total Lightning NO
  export CTM_VEXT_1="$OUTDIR/CCTM_VEXT_${CTM_APPL}.nc -v"             #> On-Hour 3D Concs at select sites

  #> set floor file (neg concs)
  export FLOOR_FILE=${OUTDIR}/FLOOR_${CTM_APPL}.txt

  #> look for existing log files and output files
  ( ls CTM_LOG_???.${CTM_APPL} > buff.txt ) >& /dev/null
  ( ls ${LOGDIR}/CTM_LOG_???.${CTM_APPL} >> buff.txt ) >& /dev/null
  log_test=`cat buff.txt`; rm -f buff.txt

  OUT_FILES=(${FLOOR_FILE} ${S_CGRID} ${CTM_CONC_1} ${A_CONC_1} ${MEDIA_CONC}                     \
             ${CTM_DRY_DEP_1} $CTM_DEPV_DIAG $B3GTS_S $MEGAN_SOILOUT $BEIS_SOILOUT $BDSNPOUT      \
             $CTM_WET_DEP_1 $CTM_WET_DEP_2 $CTM_ELMO_1 $CTM_AELMO_1                               \
             $CTM_RJ_1 $CTM_RJ_2 $CTM_RJ_3 $CTM_SSEMIS_1 $CTM_DUST_EMIS_1 $CTM_IPR_1 $CTM_IPR_2   \
             $CTM_IPR_3 $CTM_BUDGET $CTM_IRR_1 $CTM_IRR_2 $CTM_IRR_3 $CTM_DRY_DEP_MOS             \
             $CTM_DEPV_MOS $CTM_VDIFF_DIAG $CTM_VSED_DIAG                                         \
             $CTM_LTNGDIAG_1 $CTM_LTNGDIAG_2 $CTM_VEXT_1 )

#  OUT_FILES = (${FLOOR_FILE} ${S_CGRID} ${CTM_CONC_1} ${A_CONC_1} ${MEDIA_CONC}         \
#             ${CTM_DRY_DEP_1} $CTM_DEPV_DIAG $B3GTS_S $MEGAN_SOILOUT $BEIS_SOILOUT $BDSNPOUT \
#             $CTM_WET_DEP_1 $CTM_WET_DEP_2 $CTM_ELMO_1 $CTM_AELMO_1             \
#             $CTM_RJ_1 $CTM_RJ_2 $CTM_RJ_3 $CTM_SSEMIS_1 $CTM_DUST_EMIS_1 $CTM_IPR_1 $CTM_IPR_2       \
#             $CTM_IPR_3 $CTM_BUDGET $CTM_IRR_1 $CTM_IRR_2 $CTM_IRR_3 $CTM_DRY_DEP_MOS                 \
#             $CTM_DEPV_MOS $CTM_VDIFF_DIAG $CTM_VSED_DIAG $CTM_LTNGDIAG_1 $CTM_LTNGDIAG_2 $CTM_VEXT_1 )

  OUT_FILES=`echo $OUT_FILES | sed "s; -v;;g" | sed "s;MPI:;;g" `
  ( ls $OUT_FILES > buff.txt ) >& /dev/null
  out_test=`cat buff.txt`; rm -f buff.txt

  #> delete previous output if requested
  if [ "$CLOBBER_DATA" == "true" ] || [ "$CLOBBER_DATA" == "TRUE" ]
  then
     echo
     echo "Existing Logs and Output Files for Day ${TODAYG} Will Be Deleted"

     #> remove previous log files
     for file in $log_test ; do
#        #echo "Deleting log file: $file"
        /bin/rm -f "$file"
     done
     #> remove previous output files
     for file in $out_test ; do
#        #echo "Deleting output file: $file"
        /bin/rm -f "$file"
     done
     /bin/rm -f ${OUTDIR}/CCTM_EMDIAG*${RUNID}_${YYYYMMDD}.nc

  else
     #> error if previous log files exist
     if [ "$log_test" -ne "" ]
     then
       echo "*** Logs exist - run ABORTED ***"
       echo "*** To overide, set CLOBBER_DATA = TRUE in run_cctm.csh ***"
       echo "*** and these files will be automatically deleted. ***"
       exit 1
   fi

     #> error if previous output files exist
     if [ "$out_test" != "" ]
     then
       echo "*** Output Files Exist - run will be ABORTED ***"
     for file in $out_test ; do
        echo " cannot delete $file"
     done
       echo "*** To overide, set CLOBBER_DATA = TRUE in run_cctm.csh ***"
       echo "*** and these files will be automatically deleted. ***"
       exit 1
     fi
  fi

  #> for the run control ...
  export CTM_STDATE=$YYYYJJJ
  export CTM_STTIME=$STTIME
  export CTM_RUNLEN=$NSTEPS
  export CTM_TSTEP=$TSTEP
  export INIT_CONC_1=/home/ubuntu/CMAQ/dat3/2018CONUS/icbc/CCTM_CGRID_v54_cb6r5_ae7_aq_WR413_MYR_M3DRY_2018_12US1_20171221.nc
  export BNDY_CONC_1=$BCpath/$BCFILE
  export OMI=$OMIpath/$OMIfile
  export OPTICS_DATA=$OMIpath/$OPTfile
 #export XJ_DATA=$JVALpath/$JVALfile

  #> species defn & photolysis
  export gc_matrix_nml=${NMLpath}/GC_$MECH.nml
  export ae_matrix_nml=${NMLpath}/AE_$MECH.nml
  export nr_matrix_nml=${NMLpath}/NR_$MECH.nml
  export tr_matrix_nml=${NMLpath}/Species_Table_TR_0.nml

  #> check for photolysis input data
  export CSQY_DATA=${NMLpath}/CSQY_DATA_$MECH


#|#  if [ ! (-e $CSQY_DATA ) ]
#|#  then
#|#     echo " $CSQY_DATA  not found "
#|#     exit 1
#|#  fi
#|#  if [ ! (-e $OPTICS_DATA ) ]
#|#  then
#|#     echo " $OPTICS_DATA  not found "
#|#     exit 1
#|#  fi

# ===================================================================
#> Execution Portion
# ===================================================================

  #> Print attributes of the executable
#|#  if [ $CTM_DIAG_LVL != 0 ]
#|#  then
#|#     ls -l $BLD/$EXEC
#|#     size $BLD/$EXEC
#|#     unlimit
#|#     limit
#|#  fi

  #> Print Startup Dialogue Information to Standard Out
  echo
  echo "CMAQ Processing of Day $YYYYMMDD Began at `date`"
  echo

  #> Executable call for single PE, uncomment to invoke
  #( /usr/bin/time -p $BLD/$EXEC ) |& tee buff_${EXECUTION_ID}.txt

  #> Executable call for multi PE, configure for your system
  # MPI=/usr/local/intel/impi/3.2.2.006/bin64
  # MPIRUN=$MPI/mpirun
  ( /usr/bin/time -p mpirun -np $NPROCS $VEXILLA $BLD/$EXEC ) |& tee buff_${EXECUTION_ID}.txt

  #> Harvest Timing Output so that it may be reported below
  rtarray="${rtarray} `tail -3 buff_${EXECUTION_ID}.txt | grep -Eo '[+-]?[0-9]+([.][0-9]+)?' | head -1` "
  rm -rf buff_${EXECUTION_ID}.txt

  #> Abort script if abnormal termination
  if [ ! -e $OUTDIR/CCTM_CGRID_${CTM_APPL}.nc ]
  then
    echo ""
    echo "**************************************************************"
    echo "** Runscript Detected an Error: CGRID file was not written. **"
    echo "**   This indicates that CMAQ was interrupted or an issue   **"
    echo "**   exists with writing output. The runscript will now     **"
    echo "**   abort rather than proceeding to subsequent days.       **"
    echo "**************************************************************"
    break
  fi

  #> Print Concluding Text
  echo
  echo "CMAQ Processing of Day $YYYYMMDD Finished at `date`"
  echo
  echo "\\\\\=====\\\\\=====\\\\\=====\\\\\=====/////=====/////=====/////=====/////"
  echo

# ===================================================================
#> Finalize Run for This Day and Loop to Next Day
# ===================================================================

  #> Save Log Files and Move on to Next Simulation Day
  echo "CTM_LOG_???.${CTM_APPL} and LOGDIR $LOGDIR"
  mv CTM_LOG_???.${CTM_APPL} $LOGDIR
  if [ $CTM_DIAG_LVL != 0 ]
  then
    mv CTM_DIAG_???.${CTM_APPL} $LOGDIR
  fi

  #> The next simulation day will, by definition, be a restart
  export NEW_START=false

  #> Increment both Gregorian and Julian Days
  TODAYG=`date -ud "${TODAYG}+1days" +%Y-%m-%d` #> Add a day for tomorrow
  TODAYJ=`date -ud "${TODAYG}" +%Y%j` #> Convert YYYY-MM-DD to YYYYJJJ

done
#|#done  #> Loop to the next Simulation Day

# ===================================================================
#> Generate Timing Report
# ===================================================================
RTMTOT=0
for it in `seq ${NDAYS}` ; do
    rt=`echo ${rtarray} | cut -d' ' -f${it}`
    RTMTOT=`echo "${RTMTOT} + ${rt}" | bc -l`
done

RTMAVG=`echo "scale=2; ${RTMTOT} / ${NDAYS}" | bc -l`
RTMTOT=`echo "scale=2; ${RTMTOT} / 1" | bc -l`

echo
echo "=================================="
echo "  ***** CMAQ TIMING REPORT *****"
echo "=================================="
echo "Start Day: ${START_DATE}"
echo "End Day:   ${END_DATE}"
echo "Number of Simulation Days: ${NDAYS}"
echo "Domain Name:               ${GRID_NAME}"
echo "Number of Grid Cells:      ${NCELLS}  (ROW x COL x LAY)"
echo "Number of Layers:          ${NZ}"
echo "Number of Processes:       ${NPROCS}"
echo "   All times are in seconds."
echo
echo "Num  Day        Wall Time"
d=0
day=${START_DATE}

for it in `seq ${NDAYS}` ; do
    # Set the right day and format it
    d=`echo "${d} + 1"  | bc -l`
    n=`printf "%02d" ${d}`

    # Choose the correct time variables
    rt=`echo ${rtarray} | cut -d' ' -f${it}`

    # Write out row of timing data
    echo "${n}   ${day}   ${rt}"

    # Increment day for next loop
    day=`date -ud "${day}+1days" +%Y-%m-%d`
done

echo "     Total Time = ${RTMTOT}"
echo "      Avg. Time = ${RTMAVG}"

exit
	
