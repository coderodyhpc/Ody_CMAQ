#!/bin/bash

# ======================= CCTMv5.3.X Build Script ========================= 
# Usage: bldit.cctm >&! bldit.cctm.log                                   
# Requirements: I/O API & netCDF libraries, a Fortran compiler,               
#               and MPI for multiprocessor computing                     
# ======================================================================= 

#> Set the compiler option
 export compiler=gcc
 export Vrsn=13.1
 echo "Compiler is set to $compiler"
 
#> Source the config.cmaq file to set the build environment
 cd ../..
 source ./config_isam.sh

# =======================================================================
#> Begin User Input Section
# =======================================================================

#> Source Code Locations
 export CCTM_SRC=${CMAQ_REPO}/CCTM/src #> location of the CCTM source code
 GlobInc=$CCTM_SRC/ICL           #> location of the global include files
 Mechs=$CCTM_SRC/MECHS         #> location of the chemistry mechanism include files
 export REPOROOT=$CCTM_SRC

#> Controls for managing the source code and MPI compilation
CompileBLDMAKE=true      #> Recompile the BLDMAKE utility from source
                         #>   comment out to use an existing BLDMAKE executable CopySrc=true             #> copy the source files into the build directory
#set CopySrcTree=true    #> copy the source files and directory tree into the build directory
#set MakeFileOnly=true   #> uncomment to build a Makefile, but do not compile; 
                         #>   comment out to compile the model (default if not set)
 ParOpt=true             #> uncomment to build a multiple processor (MPI) executable; 
                         #>   comment out for a single processor (serial) executable
#set build_parallel_io=true   #> uncomment to build with parallel I/O (pnetcdf); 
                              #>   comment out to use standard netCDF I/O
#set Debug_CCTM=true     #> uncomment to compile CCTM with debug option equal to TRUE
                         #>   comment out to use standard, optimized compile process
# make_options = "-j"    #> additional options for make command if MakeFileOnly is not set
                         #>   comment out if no additional options are wanted.

#> Integrated Source Apportionment Method (ISAM)
ISAM_CCTM=true      #> uncomment to compile CCTM with ISAM activated
                    #>   comment out to use standard process

#set DDM3D_CCTM=true     #> uncomment to compile CCTM with DD3D activated
                         #>   comment out to use standard process
                         #> Two-way WRF-CMAQ 
#set build_twoway=true   #> uncomment to build WRF-CMAQ twoway; 
                         #>   comment out for off-line chemistry 

#> Potential vorticity free-troposphere O3 scaling
#set potvortO3=true

 echo "ISAM_CCTM is set to $ISAM_CCTM"
# echo "DDM3D_CCTM is set to $DDM3D_CCTM"
#> Working directory and Version IDs
# if [ $ISAM_CCTM==true ] 
# then
     VRSN=v54_ISAM             #> model configuration ID for CMAQ_ISAM
#     echo "Wrong place $ISAM_CCTM"
# elif [ $DDM3D_CCTM==true ] 
# then
#     VRSN=v532_DDM3D             #> model configuration ID for CMAQ_DDM
# else
#     VRSN=v532                   #> model configuration ID for CMAQ
# fi
 
 EXEC=CCTM_${VRSN}.exe          #> executable name
 CFG=CCTM_${VRSN}.cfg          #> configuration file name

 echo "VRSN is set to $VRSN"
 echo "EXEC is set to $EXEC"
 echo "CFG is set to $CFG"


#========================================================================
#> CCTM Science Modules
#========================================================================
#> NOTE: For the modules with multiple options, a note is 
#>   provided on where to look in the CCTM source code 
#>   archive for a list of the possible settings. Users 
#>   may also refer to the CMAQ documentation.

 ModGrid=grid/cartesian             #> grid configuration module 
 
 DepMod=m3dry                      #> m3dry or stage
# DepMod=stage
 ModAdv=wrf_cons                   #> 3-D Advection Scheme [Options: wrf_cons (default), local_cons]
 ModHdiff=hdiff/multiscale           #> horizontal diffusion module
 ModVdiff=vdiff/acm2_${DepMod}       #> vertical diffusion module (see $CMAQ_MODEL/CCTM/src/vdiff)
 ModDepv=depv/${DepMod}             #> deposition velocity calculation module 
                                            #>     (see $CMAQ_MODEL/CCTM/src/depv)
 ModEmis=emis/emis                  #> in-line emissions module
 ModBiog=biog/beis3                 #> BEIS3 in-line emissions module 
 ModPlmrs=plrise/smoke               #> in-line emissions plume rise
 ModCgrds=spcs/cgrid_spcs_nml        #> chemistry species configuration module 
                                            #>     (see $CMAQ_MODEL/CCTM/src/spcs)
 ModPhot=phot/inline                #> photolysis calculation module 
                                            #>     (see $CMAQ_MODEL/CCTM/src/phot)
 Mechanism=cb6r5_ae7_aq               #> chemical mechanism (see $CMAQ_MODEL/CCTM/src/MECHS)
 ModGas=gas/ebi_${Mechanism}       #> gas-phase chemistry solver (see $CMAQ_MODEL/CCTM/src/gas)
                                            #> use gas/ros3 or gas/smvgear for a solver independent 
                                            #  of the photochemical mechanism
 ModAero=aero/aero7                 #> aerosol chemistry module (see $CMAQ_MODEL/CCTM/src/aero)
 ModCloud=cloud/acm_ae7              #> cloud chemistry module (see $CMAQ_MODEL/CCTM/src/cloud)
                                            #>   overwritten below if using cb6r3m_ae7_kmtbr mechanism
 ModUtil=util/util                  #> CCTM utility modules
 ModDiag=diag                       #> CCTM diagnostic modules
 Tracer=trac0                      #> tracer configuration directory under 
                                            #>   $CMAQ_MODEL/CCTM/src/MECHS [ default: no tracer species ]
 ModPa=procan/pa                  #> CCTM process analysis
 ModPvO3=pv_o3                      #> potential vorticity from the free troposphere
 ModISAM=isam                       #> CCTM Integrated Source Apportionment Method
 ModDDM3D=ddm3d                      #> Decoupled Direct Method in 3D

#============================================================================================
#> Computing System Configuration:
#>    Most of these settings are done in config.cmaq
#============================================================================================

 export FC=${myFC}                     #> path of Fortan compiler; set in config.cmaq
 FP=$FC                       #> path of Fortan preprocessor; set in config.cmaq
 CC=${myCC}                   #> path of C compiler; set in config.cmaq
 export BLDER=${CMAQ_HOME}/UTIL/bldmake/bldmake_${compilerString}.exe   #> name of model builder executable

#> Libraries/include files
#LIOAPI="${IOAPI_DIR}/lib ${ioapi_lib}"      #> I/O API library directory
#IOAPIMOD="${IOAPI_DIR}/include"               #> I/O API module directory
 NETCDF="${NETCDF_DIR}/lib ${netcdf_lib}"    #> netCDF C library directory
 NETCDFF="${NETCDFF_DIR}/lib ${netcdff_lib}"  #> netCDF Fortran library directory
 PNETCDF="${PNETCDF_DIR}/lib ${pnetcdf_lib}"  #> Parallel netCDF library directory
# PIO_INC="${IOAPI_DIR}/src"

#> Compiler flags set in config.cmaq
 FSTD="${myFSTD}"
 DBG="${myDBG}"
 export F_FLAGS="${myFFLAGS}"            #> F77 flags
 F90_FLAGS="${myFRFLAGS}"           #> F90 flags
 CPP_FLAGS=""                       #> Fortran preprocessor flags
 C_FLAGS="${myCFLAGS} -DFLDMN -I" #> C flags
 LINK_FLAGS="${myLINK_FLAG}"         # Link flags

#============================================================================================
#> Implement User Input
#============================================================================================

#> Check for CMAQ_REPO and CMAQ_LIB settings:
 if [ ! -e $CMAQ_REPO ] && [ ! -e $CMAQ_LIB ] 
 then
    echo "   $CMAQ_REPO or $CMAQ_LIB directory not found"
###    exit 1
 fi

#> If $CMAQ_MODEL is not set, default to $CMAQ_REPO
 if [ CMAQ_MODEL ] 
 then
    echo "         Model repository path: $CMAQ_MODEL"
 else
    export CMAQ_MODEL=$CMAQ_REPO
    echo " default Model repository path: $CMAQ_MODEL"
 fi

#> This script was written for Linux hosts only. If
#> the host system is not Linux, produce an error and stop
 BLD_OS=`uname -s`       
    echo " BLD_OS $BLD_OS"
 if [ $BLD_OS != 'Linux' ] 
 then
    echo "   $BLD_OS -> wrong bldit script for host!"
###    exit 1
 fi

#> If the two-way, coupled WRF-CMAQ model is being built,
#> then just generate the Makefile. Don't compile.
# if [ build_twoway ] 
# then
#    MakeFileOnly=true   
#    ModTwoway=twoway
# fi

#> If parallel-io is selected, then make sure the multiprocessor
#> option is also set.
### if ( $?build_parallel_io ) then
###    if ( ! $?ParOpt ) then
###       echo "*** ParOpt is not set: required for the build_parallel_io option"
###       exit 1
###    endif
###    set PIO = ( -Dparallel_io )
### else
###    set PIO = ""
### endif


 if [ "$DepMod" == "m3dry" ] 
 then
    cpp_depmod='-Dm3dry_opt'
    echo "cpp_depmod $cpp_depmod"]
 elif [ "$DepMod" == "stage" ] 
 then
    cpp_depmod='-Dstage_opt'
 fi

#> Set variables needed for multiprocessor and serial builds
 if [ ParOpt ] 
 then    
    #Multiprocessor system configuration
    echo "   Parallel; set MPI flags"
    ModStenex=STENEX/se
    ModPario=PARIO
    ModPar=par/mpi
    PARIO=${CMAQ_MODEL}/PARIO
    STENEX=${CMAQ_MODEL}/STENEX
    echo " ModStenex $ModStenex "
    echo " ModPario $ModPario "
    echo " ModPar $ModPar "
    echo " PARIO $PARIO "
    echo " STENEX $STENEX "
    # MPI_INC is set in config.cmaq
    # PIO_INC="${IOAPI_DIR}/src/fixed_src"
    PAR=( -Dparallel )
    Popt=SE
    seL=se_snl
    LIB2="${ioapi_lib}"
    LIB3="${mpi_lib} ${extra_lib}"
    echo " LIB2 $LIB2 "
    echo " LIB3 $LIB3 "
    Str1=("// Parallel / Include message passing definitions")
    Str2=("include SUBST_MPI mpif.h;")
 else
    #Serial system configuration
    echo "   Not Parallel; set Serial (no-op) flags"
    ModStenex=STENEX/noop
    ModPar=par/par_noop
    PARIO="."
    STENEX=${CMAQ_MODEL}/STENEX/noop
    MPI_INC="."
    # PIO_INC = "."
    PAR=""
    Popt=NOOP
    seL=sef90_noop
    LIB2="${ioapi_lib} ${extra_lib}"
    Str1 =
    Str2 =
 fi 

echo "End Multiprocessing"
#> if DDM-3D is set, add the pre-processor flag for it.
 if [ DDM3D_CCTM ]
 then
    SENS=( -Dsens )
 else
    SENS=""
 fi
 
#> Mechanism location
 ModMech=MECHS/$Mechanism        #> chemical mechanism module

#> Cloud chemistry options
 if [ $Mechanism == cb6r3m_ae7_kmtbr ]
 then
    ModCloud=cloud/acm_ae7_kmtbr
 fi

#> Tracer configuration files
 ModTrac=MECHS/$Tracer

#> free trop. O3 potential vorticity scaling
 if [ potvortO3 ]
 then 
    POT=( -Dpotvorto3 )
 else
    POT=""
 fi 
    echo " POT $POT "

#> Set and create the "BLD" directory for checking out and compiling 
#> source code. Move current directory to that build directory.
 Bld=$CMAQ_HOME/CCTM/scripts/BLD_CCTM_${VRSN}_${compilerString}
 if [ ! -e "$Bld" ]
 then
    mkdir $Bld
 else
    if [ ! -d "$Bld" ]
    then
       echo "   *** target exists, but not a directory ***"
###       exit 1
    fi
 fi
 cd $Bld
    echo " Bld $Bld "

#> Set locations for the include files of various modules
 ICL_PAR=$GlobInc/fixed/mpi         
 ICL_CONST=$GlobInc/fixed/const       
 ICL_FILES=$GlobInc/fixed/filenames
 ICL_EMCTL=$GlobInc/fixed/emctrl
# ICL_PA=$GlobInc/procan/$PAOpt

 #Test with xlib commented out
# if [ ParOpt ]
# then
#    ICL_MPI= .  #$xLib_Base/$xLib_3
# fi


 ICL_MPI=$ICL_PAR

#> If the source code is being copied to the build directory,
#> then move the include files as well and direct the Makefile
#> to the current directory.
 if [ CopySrc ]
 then
    /bin/cp -fp ${ICL_PAR}/*   ${Bld}
    /bin/cp -fp ${ICL_CONST}/* ${Bld}
    /bin/cp -fp ${ICL_FILES}/* ${Bld}
    /bin/cp -fp ${ICL_EMCTL}/* ${Bld}
#    #/bin/cp -fp ${ICL_PA}/*    ${Bld}
    if [ ParOpt ]
    then
#       /bin/cp -fp ${ICL_MPI}/mpif.h ${Bld}
  echo " "
    fi

#    ICL_PAR   = .
#    ICL_CONST = .
#    ICL_FILES = .
#    ICL_EMCTL = .
#    # ICL_PA    = .
#    if [ ParOpt ]
#    then
#       ICL_MPI   = .
#    fi
 fi


# STX1=( -DSUBST_BARRIER=${Popt}_BARRIER )
# STX1=( -DSUBST_BARRIER=${Popt}_BARRIER -DSUBST_GLOBAL_MAX=${Popt}_GLOBAL_MAX -DSUBST_GLOBAL_MIN=${Popt}_GLOBAL_MIN -DSUBST_GLOBAL_MIN_DATA=${Popt}_GLOBAL_MIN_DATA -DSUBST_GLOBAL_TO_LOCAL_COORD=${Popt}_GLOBAL_TO_LOCAL_COORD -DSUBST_GLOBAL_SUM=${Popt}_GLOBAL_SUM -DSUBST_GLOBAL_LOGICAL=${Popt}_GLOBAL_LOGICAL -DSUBST_LOOP_INDEX=${Popt}_LOOP_INDEX -DSUBST_SUBGRID_INDEX=${Popt}_SUBGRID_INDEX )

 STX1=" -DSUBST_BARRIER=${Popt}_BARRIER\
        -DSUBST_GLOBAL_MAX=${Popt}_GLOBAL_MAX\
        -DSUBST_GLOBAL_MIN=${Popt}_GLOBAL_MIN\
        -DSUBST_GLOBAL_MIN_DATA=${Popt}_GLOBAL_MIN_DATA\
        -DSUBST_GLOBAL_TO_LOCAL_COORD=${Popt}_GLOBAL_TO_LOCAL_COORD\
        -DSUBST_GLOBAL_SUM=${Popt}_GLOBAL_SUM\
        -DSUBST_GLOBAL_LOGICAL=${Popt}_GLOBAL_LOGICAL\
        -DSUBST_LOOP_INDEX=${Popt}_LOOP_INDEX\
        -DSUBST_SUBGRID_INDEX=${Popt}_SUBGRID_INDEX "
# STX2="( -DSUBST_HI_LO_BND_PE=${Popt}_HI_LO_BND_PE -DSUBST_SUM_CHK=${Popt}_SUM_CHK )"

 STX2=" -DSUBST_HI_LO_BND_PE=${Popt}_HI_LO_BND_PE\
          -DSUBST_SUM_CHK=${Popt}_SUM_CHK\
          -DSUBST_SE_INIT=${Popt}_INIT\
          -DSUBST_INIT_ARRAY=${Popt}_INIT_ARRAY\
          -DSUBST_COMM=${Popt}_COMM\
          -DSUBST_MY_REGION=${Popt}_MY_REGION\
          -DSUBST_SLICE=${Popt}_SLICE\
          -DSUBST_GATHER=${Popt}_GATHER\
          -DSUBST_DATA_COPY=${Popt}_DATA_COPY\
          -DSUBST_IN_SYN=${Popt}_IN_SYN "

 echo "    STX1: $STX1"
 echo "    STX2: $STX2"

#> 3-D Advection Options
 if [ $ModAdv==wrf_cons ]
 then
    ModCpl=couple/gencoor_wrf_cons    #> unit conversion and concentration coupling module 
                                               #>     (see $CMAQ_MODEL/CCTM/src/couple)
    ModHadv=hadv/ppm                   #> horizontal advection module   
    ModVadv=vadv/wrf_cons              #> Vertical advection module                             
 elif [ $ModAdv==local_cons ]
 then
    ModCpl=couple/gencoor_local_cons  #> unit conversion and concentration coupling module 
                                               #>     (see $CMAQ_MODEL/CCTM/src/couple)
    ModHadv=hadv/ppm                     #> horizontal advection module
    ModVadv=vadv/local_cons              #> Vertical advection module
 fi

 echo " Before Config File "

# ============================================================================
#> Create Config File 
# ============================================================================

Cfile=${Bld}/${CFG}.bld      # Config Filename
 quote='"'
 echo " Cfile $Cfile"

 echo                                                               > $Cfile
 if [ make_options ]
 then
    echo "make_options $quote$make_options$quote;"                 >> $Cfile
    echo                                                           >> $Cfile
 fi
 echo "model        $EXEC;"                                        >> $Cfile
 echo                                                              >> $Cfile
 echo "repo        $CCTM_SRC;"                                     >> $Cfile
 echo                                                              >> $Cfile
 echo "mechanism   $Mechanism;"                                    >> $Cfile
 echo                                                              >> $Cfile
 echo "lib_base    $CMAQ_LIB;"                                     >> $Cfile
 echo                                                              >> $Cfile
 echo "lib_1       ioapi/lib;"                                     >> $Cfile
 echo                                                              >> $Cfile
 echo "lib_2       ioapi/include_files;"                           >> $Cfile
 echo                                                              >> $Cfile
 if [ ParOpt ]
 then
    echo "lib_3       ${quote}mpi -I.$quote;"                      >> $Cfile
    echo                                                           >> $Cfile
 fi
 echo                                                              >> $Cfile
 echo "lib_4       ioapi/lib;"                                     >> $Cfile
 echo                                                              >> $Cfile
 text="$quote$CPP_FLAGS $PAR $SENS $PIO $cpp_depmod $POT $STX1 $STX2$quote;"
 echo "cpp_flags   $text"                                          >> $Cfile
 echo                                                              >> $Cfile
 echo "f_compiler  $FC;"                                           >> $Cfile
 echo                                                              >> $Cfile
 echo "fstd        $quote$FSTD$quote;"                             >> $Cfile
 echo                                                              >> $Cfile
 echo "dbg         $quote$DBG$quote;"                              >> $Cfile
 echo                                                              >> $Cfile
 echo "f_flags     $quote$F_FLAGS$quote;"                          >> $Cfile
 echo                                                              >> $Cfile
 echo "f90_flags   $quote$F90_FLAGS$quote;"                        >> $Cfile
 echo                                                              >> $Cfile
 echo "c_compiler  $CC;"                                           >> $Cfile
 echo                                                              >> $Cfile
 echo "c_flags     $quote$C_FLAGS$quote;"                          >> $Cfile
 echo                                                              >> $Cfile
 echo "link_flags  $quote$LINK_FLAGS$quote;"                       >> $Cfile
 echo                                                              >> $Cfile
 echo "ioapi       $quote$LIB2$quote;     "                        >> $Cfile
 echo                                                              >> $Cfile
 echo "netcdf      $quote$netcdf_lib$quote;"                       >> $Cfile
 echo                                                              >> $Cfile
 echo "netcdff     $quote$netcdff_lib$quote;"                      >> $Cfile
 echo                                                              >> $Cfile
 if [ ParOpt ]
 then
    echo "mpich       $quote$LIB3$quote;"                          >> $Cfile
    echo                                                           >> $Cfile
 fi
 echo "include SUBST_PE_COMM    $ICL_PAR/PE_COMM.EXT;"             >> $Cfile
 echo "include SUBST_CONST      $ICL_CONST/CONST.EXT;"             >> $Cfile
 echo "include SUBST_FILES_ID   $ICL_FILES/FILES_CTM.EXT;"         >> $Cfile
 echo "include SUBST_EMISPRM    $ICL_EMCTL/EMISPRM.EXT;"           >> $Cfile
 echo                                                              >> $Cfile

 if [ ParOpt ]
 then
    echo "$Str1"                                                   >> $Cfile
    echo "include SUBST_MPI        ./mpif.h;"                      >> $Cfile
 fi
 echo                                                              >> $Cfile

 text="stenex or se_noop"
 echo "// options are" $text                                       >> $Cfile
 echo "Module ${ModStenex};"                                       >> $Cfile
 if [ ParOpt ]
 then
    text="// parallel executable; stenex and pario included"
    echo $text                                                     >> $Cfile
    echo "Module ${ModPario};"                                     >> $Cfile
 else
    text="serial executable; noop stenex"
    echo $text                                                     >> $Cfile
 fi
 echo                                                              >> $Cfile

 text="par, par_nodistr and par_noop"
 echo "// options are" $text                                       >> $Cfile
 if [ ParOpt ]
 then
    echo "Module ${ModPar};"                                       >> $Cfile
 fi
 echo                                                              >> $Cfile

# if [ build_twoway ]
# then
#    echo "// option set for WRF-CMAQ twoway"                       >> $Cfile
#    echo "Module ${ModTwoway};"                                    >> $Cfile
#    echo                                                           >> $Cfile
# fi

 text="driver"
 echo "// options are" $text                                       >> $Cfile
 echo "Module driver;"                                             >> $Cfile
 echo                                                              >> $Cfile

 text="cartesian"
 echo "// options are" $text                                       >> $Cfile
 echo "Module ${ModGrid};"                                         >> $Cfile
 echo                                                              >> $Cfile

 text="Init"
 echo "// options are" $text                                       >> $Cfile
 echo "Module init;"                                               >> $Cfile
 echo                                                              >> $Cfile

 text="gencoor_wrf_cons and gencoor_local_cons"
 echo "// options are" $text                                       >> $Cfile
 echo "Module ${ModCpl};"                                          >> $Cfile
 echo                                                              >> $Cfile

 text="ppm"
 echo "// options are" $text                                       >> $Cfile
 echo "Module ${ModHadv};"                                         >> $Cfile
 echo                                                              >> $Cfile

 text="wrf_cons and local_cons"
 echo "// options are" $text                                       >> $Cfile
 echo "Module ${ModVadv};"                                         >> $Cfile
 echo                                                              >> $Cfile

 text="multiscale"
 echo "// options are" $text                                       >> $Cfile
 echo "Module ${ModHdiff};"                                        >> $Cfile
 echo                                                              >> $Cfile

 text="acm2_m3dry or acm2_stage"
 echo "// options are" $text                                       >> $Cfile
 echo "Module ${ModVdiff};"                                        >> $Cfile
 echo                                                              >> $Cfile

 text="m3dry or stage"
 echo "// options are" $text                                       >> $Cfile
 echo "Module ${ModDepv};"                                         >> $Cfile
 echo                                                              >> $Cfile

 text="emis"
 echo "// options are" $text                                       >> $Cfile
 echo "Module ${ModEmis};"                                         >> $Cfile
 echo                                                              >> $Cfile

 text="beis3"
 echo "// options are" $text                                       >> $Cfile
 echo "Module ${ModBiog};"                                         >> $Cfile
 echo                                                              >> $Cfile

 text="smoke"
 echo "// options are" $text                                       >> $Cfile
 echo "Module ${ModPlmrs};"                                        >> $Cfile
 echo                                                              >> $Cfile

 text="cgrid_spcs_nml and cgrid_spcs_icl"
 echo "// options are" $text                                       >> $Cfile
 echo "Module ${ModCgrds};"                                        >> $Cfile
 echo                                                              >> $Cfile

 text="inline and table"
 echo "// options are" $text                                       >> $Cfile
 echo "Module ${ModPhot};"                                         >> $Cfile
 echo                                                              >> $Cfile

 text="gas chemistry solvers"
 echo "// " $text                                                  >> $Cfile
 text="smvgear, ros3, and ebi_<mech>; see 'gas chemistry mechanisms' for <mech>"
 echo "// options are" $text                                       >> $Cfile
 echo "Module ${ModGas};"                                          >> $Cfile
 echo                                                              >> $Cfile

 MechList=" cb6mp_ae6_aq, cb6r3_ae6_aq, cb6r3_ae7_aq, cb6r3_ae7_aqkmt2, cb6r3m_ae7_kmtbr, racm2_ae6_aq, saprc07tc_ae6_aq, saprc07tic_ae6i_aq, saprc07tic_ae6i_aqkmti, saprc07tic_ae7i_aq, saprc07tic_ae7i_aqkmt2"
 text="gas chemistry mechanisms"
 echo "// " $text                                                  >> $Cfile
 text="$MechList"
 echo "// options are" $text                                       >> $Cfile
 echo "Module ${ModMech};"                                         >> $Cfile
 echo                                                              >> $Cfile

 text="tracer modules"
 echo "// " $text                                                  >> $Cfile
 echo "// options are trac0, trac1"                                >> $Cfile
 echo "Module ${ModTrac};"                                         >> $Cfile
 echo 

 text="aero6"
 echo "// options are" $text                                       >> $Cfile
 echo "Module ${ModAero};"                                         >> $Cfile
 echo                                                              >> $Cfile

 text="acm_ae6, acm_ae6_kmt, acm_ae7_kmt2, acm_ae6_mp, acm_ae7"
 echo "// options are" $text                                       >> $Cfile
 echo "Module ${ModCloud};"                                        >> $Cfile
 echo                                                              >> $Cfile

 text="// compile for inline process analysis"
 echo $text                                                        >> $Cfile
 echo "Module ${ModPa};"                                           >> $Cfile
 echo                                                              >> $Cfile

 text="// compile for integrated source apportionment method"
 echo $text                                                        >> $Cfile
 echo "Module ${ModISAM};"                                         >> $Cfile
 echo                                                              >> $Cfile

 text="util"
 echo "// options are" $text                                       >> $Cfile
 echo "Module ${ModUtil};"                                         >> $Cfile
 echo                                                              >> $Cfile

 text="diag"
 echo "// options are" $text                                       >> $Cfile
 echo "Module ${ModDiag};"                                         >> $Cfile
 echo                                                              >> $Cfile

 text="stm"
 echo "// options are" $text                                       >> $Cfile
 echo "Module stm;"                                                >> $Cfile
 echo                                                              >> $Cfile

 text="cio"
 echo "// options are" $text                                       >> $Cfile
 echo "Module cio;"                                                >> $Cfile
 echo                                                              >> $Cfile

# ============================================================================
#> Create Makefile and Model Executable
# ============================================================================
 echo "Beginning create Makefile"
 echo " $CompileBLDMAKE"
 echo " $BLDER"
# unalias mv rm

#> Recompile BLDMAKE from source if requested or if it does not exist
# if [ CompileBLDMAKE ] && [ ! -f $BLDER]
# then
   echo "Calling bldmake"
   cd ${CMAQ_REPO}/UTIL/bldmake/scripts
   ./bldit_bldmake.sh
   echo "End bldmake"
# fi

#> Relocate to the BLD_* directory 
 cd $Bld

#> Set multiprocessor/serial options for BLDMAKE execution
 if [ ParOpt ]
 then
    Blder="$BLDER -verbose"
 else
    Blder="$BLDER -serial -verbose"
 fi

   echo "Blder ___ $Blder"

#> Run BLDMAKE Utility
 bld_flags=""
 if [ MakeFileOnly ]
 then   # Do not compile the Model
    bld_flags="${bld_flags} -makefo"
 fi


 if [ CopySrc ]
 then
    bld_flags="${bld_flags}"
 elif [ CopySrcTree ]
 then   
    bld_flags="${bld_flags} -co"
 else 
    bld_flags="{bld_flags} -git_local" # Run BLDMAKE with source code in 
                                              # version-controlled git repo
                                              # $Cfile = ${CFG}.bld
 fi

 if [ Debug_CCTM ]
 then
    bld_flags="${bld_flags} -debug_cctm"
 fi

 if [ ISAM_CCTM ]
 then
    bld_flags="${bld_flags} -isam_cctm"
 fi

   echo "START Blder ___***____ $Blder $bld_flags $Cfile"
#> Run BLDMAKE with source code in build directory
 $Blder $bld_flags $Cfile   

#> Rename Makefile to specify compiler option and link back to Makefile
   echo "START Makefile"
 mv Makefile Makefile.$compilerString
 if [ -e Makefile.$compilerString ] && [ -e Makefile ]
 then
   rm Makefile
   ln -s Makefile.$compilerString Makefile
 fi
 
#> Alert user of error in BLDMAKE if it ocurred
   echo "ALERT Makefile"
 if [ $status != 0 ]
 then
    echo "   *** failure in $Blder ***"
    exit 1
 endif

#> Preserve old Config file, if it exists, before moving new one to 
#> build directory.
   echo "Last element"
 if [ -e "$Bld/${CFG}" ]
 then
    echo "   >>> previous ${CFG} exists, re-naming to ${CFG}.old <<<"
    mv $Bld/${CFG} $Bld/${CFG}.old
 endif
 mv ${CFG}.bld $Bld/${CFG}



###exit

