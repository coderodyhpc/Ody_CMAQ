#!/bin/bash

#------------------------------------------------------------------------------#
#  The Community Multiscale Air Quality (CMAQ) system software is in           #
#  continuous development by various groups and is based on information        #
#  from these groups: Federal Government employees, contractors working        #
#  within a United States Government contract, and non-Federal sources         #
#  including research institutions.  These groups give the Government          #
#  permission to use, prepare derivative works of, and distribute copies       #
#  of their work in the CMAQ system to the public and to permit others         #
#  to do so.  The United States Environmental Protection Agency                #
#  therefore grants similar permission to use the CMAQ system software,        #
#  but users are requested to provide copies of derivative works or            #
#  products designed to operate in the CMAQ system to the United States        #
#  Government without restrictions as to use by others.  Software              #
#  that is used with the CMAQ system but distributed under the GNU             #
#  General Public License or the GNU Lesser General Public License is          #
#  subject to their copyright restrictions.                                    #
#------------------------------------------------------------------------------#


#-----------------------------------------------------------------------
# Set identification for input and output files.
#
#   APPL       = Application Name (tag for MCIP output file names)
#   CoordName  = Coordinate system name for GRIDDESC
#   GridName   = Grid Name descriptor for GRIDDESC
#   InMetDir   = Directory that contains input meteorology files
#   InGeoDir   = Directory that contains input WRF "GEOGRID" file to
#                provide fractional land-use categories if "LANDUSEF"
#                was not included in the WRFOUT files.
#   OutDir     = Directory to write MCIP output files
#   ProgDir    = Directory that contains the MCIP executable
#   WorkDir    = Working Directory for Fortran links and namelist
#-----------------------------------------------------------------------

source $CMAQ_HOME/config_cmaq.csh

APPL=160702
CoordName=LamCon_40N_97W    # 16-character maximum
GridName=2016_12SE1        # 16-character maximum

DataPath=$CMAQ_DATA
InMetDir=$DataPath/wrf
InGeoDir=$DataPath/wrf
OutDir=$DataPath/mcip/$GridName
ProgDir=$CMAQ_HOME/PREP/mcip/src
WorkDir=$OutDir

InMetFiles=($InMetDir/subset_wrfout_d01_2016-07-01_00:00:00 \
                $InMetDir/subset_wrfout_d01_2016-07-02_00:00:00 \
                $InMetDir/subset_wrfout_d01_2016-07-03_00:00:00 )

IfGeo="F"
InGeoFile=$InGeoDir/geo_em_d01.nc

LPV=0
LWOUT=0
LUVBOUT=1

MCIP_START=2016-07-02-00:00:00.0000  # [UTC]
MCIP_END=2016-07-03-00:00:00.0000  # [UTC]

INTVL=60 # [min]

IOFORM=1

#-----------------------------------------------------------------------
# Set number of meteorology "boundary" points to remove on each of four
# horizontal sides of MCIP domain.  This affects the output MCIP domain
# dimensions by reducing meteorology domain by 2*BTRIM + 2*NTHIK + 1,
# where NTHIK is the lateral boundary thickness (in BDY files), and the
# extra point reflects conversion from grid points (dot points) to grid
# cells (cross points).  Setting BTRIM = 0 will use maximum of input
# meteorology.  To remove MM5 lateral boundaries, set BTRIM = 5.
#
# *** If windowing a specific subset domain of input meteorology, set
#     BTRIM = -1, and BTRIM will be ignored in favor of specific window
#     information in X0, Y0, NCOLS, and NROWS.
#-----------------------------------------------------------------------

set BTRIM = 0

#-----------------------------------------------------------------------
# Define MCIP subset domain.  (Only used if BTRIM = -1.  Otherwise,
# the following variables will be set automatically from BTRIM and
# size of input meteorology fields.)
#   X0:     X-coordinate of lower-left corner of full MCIP "X" domain
#           (including MCIP lateral boundary) based on input MM5 domain.
#           X0 refers to the east-west dimension.  Minimum value is 1.
#   Y0:     Y-coordinate of lower-left corner of full MCIP "X" domain
#           (including MCIP lateral boundary) based on input MM5 domain.
#           Y0 refers to the north-south dimension.  Minimum value is 1.
#   NCOLS:  Number of columns in output MCIP domain (excluding MCIP
#           lateral boundaries).
#   NROWS:  Number of rows in output MCIP domain (excluding MCIP
#           lateral boundaries).
#-----------------------------------------------------------------------

X0=13
Y0=94
NCOLS=89
NROWS=104

LPRT_COL=0
LPRT_ROW=0

WRF_LC_REF_LAT=40.0

#=======================================================================
#=======================================================================
# Set up and run MCIP.
#   Should not need to change anything below here.
#=======================================================================
#=======================================================================

PROG=mcip

date

#-----------------------------------------------------------------------
# Make sure the input files exist.
#-----------------------------------------------------------------------

#if ( $IfGeo == "T" ) then
#  if ( ! -f $InGeoFile ) then
#    echo "No such input file $InGeoFile"
#    exit 1
#  endif
#endif

#foreach fil ( $InMetFiles )
#  if ( ! -f $fil ) then
#    echo "No such input file $fil"
#    exit 1
#  endif
#end


#-----------------------------------------------------------------------
# Create a work directory for this job.
#-----------------------------------------------------------------------

#if ( ! -d $WorkDir ) then
#  mkdir -p $WorkDir
#  if ( $status != 0 ) then
#    echo "Failed to make work directory, $WorkDir"
#    exit 1
#  endif
#endif

cd $WorkDir

#-----------------------------------------------------------------------
# Set up script variables for input files.
#-----------------------------------------------------------------------

#if ( $IfGeo == "T" ) then
#  if ( -f $InGeoFile ) then
#    set InGeo = $InGeoFile
#  else
#    set InGeo = "no_file"
#  endif
#else
#  set InGeo = "no_file"
#endif

FILE_GD=$OutDir/GRIDDESC

#-----------------------------------------------------------------------
# Create namelist with user definitions.
#-----------------------------------------------------------------------

Marker="&END"

cat > $WorkDir/namelist.${PROG} << !
 &FILENAMES
  file_gd    = "$FILE_GD"
  file_mm    = "$InMetFiles[1]",
!

if [ $#InMetFiles > 1 ]
then
  @ nn = 2
  while [ $nn <= $#InMetFiles ]
    cat >> $WorkDir/namelist.${PROG} << !
               "$InMetFiles[$nn]",
!
    @ nn ++
  end
fi

if [ $IfGeo == "T" ]
then
cat >> $WorkDir/namelist.${PROG} << !
  file_geo   = "$InGeo"
!
fi

cat >> $WorkDir/namelist.${PROG} << !
  ioform     =  $IOFORM
 $Marker
 &USERDEFS
  lpv        =  $LPV
  lwout      =  $LWOUT
  luvbout    =  $LUVBOUT
  mcip_start = "$MCIP_START"
  mcip_end   = "$MCIP_END"
  intvl      =  $INTVL
  coordnam   = "$CoordName"
  grdnam     = "$GridName"
  btrim      =  $BTRIM
  lprt_col   =  $LPRT_COL
  lprt_row   =  $LPRT_ROW
  wrf_lc_ref_lat = $WRF_LC_REF_LAT
 $Marker
 &WINDOWDEFS
  x0         =  $X0
  y0         =  $Y0
  ncolsin    =  $NCOLS
  nrowsin    =  $NROWS
 $Marker
!

#-----------------------------------------------------------------------
# Set links to FORTRAN units.
#-----------------------------------------------------------------------

rm fort.*
if [ -f $FILE_GD ] rm -f $FILE_GD

ln -s $FILE_GD                   fort.4
ln -s $WorkDir/namelist.${PROG}  fort.8

NUMFIL = 0
foreach fil ( $InMetFiles )
  @ NN = $NUMFIL + 10
  ln -s $fil fort.$NN
  @ NUMFIL ++
end

#-----------------------------------------------------------------------
# Set output file names and other miscellaneous environment variables.
#-----------------------------------------------------------------------

export IOAPI_CHECK_HEADERS=T
export EXECUTION_ID=$PROG

export GRID_BDY_2D=$OutDir/GRIDBDY2D_${APPL}.nc
export GRID_CRO_2D=$OutDir/GRIDCRO2D_${APPL}.nc
export GRID_DOT_2D=$OutDir/GRIDDOT2D_${APPL}.nc
export MET_BDY_3D=$OutDir/METBDY3D_${APPL}.nc
export MET_CRO_2D=$OutDir/METCRO2D_${APPL}.nc
export MET_CRO_3D=$OutDir/METCRO3D_${APPL}.nc
export MET_DOT_3D=$OutDir/METDOT3D_${APPL}.nc
export LUFRAC_CRO=$OutDir/LUFRAC_CRO_${APPL}.nc
export SOI_CRO=$OutDir/SOI_CRO_${APPL}.nc
export MOSAIC_CRO=$OutDir/MOSAIC_CRO_${APPL}.nc

if [ -f $GRID_BDY_2D ] rm -f $GRID_BDY_2D
if [ -f $GRID_CRO_2D ] rm -f $GRID_CRO_2D
if [ -f $GRID_DOT_2D ] rm -f $GRID_DOT_2D
if [ -f $MET_BDY_3D  ] rm -f $MET_BDY_3D
if [ -f $MET_CRO_2D  ] rm -f $MET_CRO_2D
if [ -f $MET_CRO_3D  ] rm -f $MET_CRO_3D
if [ -f $MET_DOT_3D  ] rm -f $MET_DOT_3D
if [ -f $LUFRAC_CRO  ] rm -f $LUFRAC_CRO
if [ -f $SOI_CRO     ] rm -f $SOI_CRO
if [ -f $MOSAIC_CRO  ] rm -f $MOSAIC_CRO

if [ -f $OutDir/mcip.nc      ] rm -f $OutDir/mcip.nc
if [ -f $OutDir/mcip_bdy.nc  ] rm -f $OutDir/mcip_bdy.nc

#-----------------------------------------------------------------------
# Execute MCIP.
#-----------------------------------------------------------------------

$ProgDir/${PROG}.exe

if [ $status == 0 ]
then
  rm fort.*
  exit 0
else
  echo "Error running $PROG"
  exit 1
fi
