
!------------------------------------------------------------------------!
!  The Community Multiscale Air Quality (CMAQ) system software is in     !
!  continuous development by various groups and is based on information  !
!  from these groups: Federal Government employees, contractors working  !
!  within a United States Government contract, and non-Federal sources   !
!  including research institutions.  These groups give the Government    !
!  permission to use, prepare derivative works of, and distribute copies !
!  of their work in the CMAQ system to the public and to permit others   !
!  to do so.  The United States Environmental Protection Agency          !
!  therefore grants similar permission to use the CMAQ system software,  !
!  but users are requested to provide copies of derivative works or      !
!  products designed to operate in the CMAQ system to the United States  !
!  Government without restrictions as to use by others.  Software        !
!  that is used with the CMAQ system but distributed under the GNU       !
!  General Public License or the GNU Lesser General Public License is    !
!  subject to their copyright restrictions.                              !
!------------------------------------------------------------------------!

      SUBROUTINE HRRATES

C***********************************************************************
C
C  FUNCTION: To calculate rates of reactions
C
C  PRECONDITIONS: For the RACM2_AE6_AQ mechanism
C
C  KEY SUBROUTINES/FUNCTIONS CALLED: None
C
C  REVISION HISTORY: Created by EBI solver program, Jun  8, 2022
C
C***********************************************************************
      USE HRDATA

      IMPLICIT NONE

C.....INCLUDES: NONE


C.....ARGUMENTS: NONE


C.....PARAMETERS: NONE


C.....EXTERNAL FUNCTIONS: NONE


C.....SAVED VARIABLES: NONE
!     CHARACTER( 16 ), SAVE  ::  PNAME = 'HRRATES'   ! Program name


C.....LOCAL VARIABLES: None

C***********************************************************************
C..NOTE: RXRAT commented out are not referenced by any routine
      RXRAT(      1 ) = RKI(     1 ) * YC(  O3 )
      RXRAT(      2 ) = RKI(     2 ) * YC(  O3 )
      RXRAT(      3 ) = RKI(     3 ) * YC(  H2O2 )
!     RXRAT(      4 ) = RKI(     4 ) * YC(  NO2 )
      RXRAT(      5 ) = RKI(     5 ) * YC(  NO3 )
      RXRAT(      6 ) = RKI(     6 ) * YC(  NO3 )
      RXRAT(      7 ) = RKI(     7 ) * YC(  HONO )
      RXRAT(      8 ) = RKI(     8 ) * YC(  HNO3 )
      RXRAT(      9 ) = RKI(     9 ) * YC(  HNO4 )
      RXRAT(     10 ) = RKI(    10 ) * YC(  HCHO )
      RXRAT(     11 ) = RKI(    11 ) * YC(  HCHO )
      RXRAT(     12 ) = RKI(    12 ) * YC(  ACD )
      RXRAT(     13 ) = RKI(    13 ) * YC(  ALD )
      RXRAT(     14 ) = RKI(    14 ) * YC(  ACT )
      RXRAT(     15 ) = RKI(    15 ) * YC(  UALD )
      RXRAT(     16 ) = RKI(    16 ) * YC(  MEK )
      RXRAT(     17 ) = RKI(    17 ) * YC(  KET )
      RXRAT(     18 ) = RKI(    18 ) * YC(  HKET )
      RXRAT(     19 ) = RKI(    19 ) * YC(  MACR )
      RXRAT(     20 ) = RKI(    20 ) * YC(  MVK )
      RXRAT(     21 ) = RKI(    21 ) * YC(  GLY )
      RXRAT(     22 ) = RKI(    22 ) * YC(  GLY )
      RXRAT(     23 ) = RKI(    23 ) * YC(  GLY )
      RXRAT(     24 ) = RKI(    24 ) * YC(  MGLY )
      RXRAT(     25 ) = RKI(    25 ) * YC(  DCB1 )
      RXRAT(     26 ) = RKI(    26 ) * YC(  DCB2 )
      RXRAT(     27 ) = RKI(    27 ) * YC(  BALD )
      RXRAT(     28 ) = RKI(    28 ) * YC(  OP1 )
      RXRAT(     29 ) = RKI(    29 ) * YC(  OP2 )
      RXRAT(     30 ) = RKI(    30 ) * YC(  PAA )
      RXRAT(     31 ) = RKI(    31 ) * YC(  ONIT )
      RXRAT(     32 ) = RKI(    32 ) * YC(  PAN )
      RXRAT(     33 ) = RKI(    33 ) * YC(  PAN )
!     RXRAT(     34 ) = RKI(    34 ) * YC(  O3 ) * YC(  HO )
!     RXRAT(     35 ) = RKI(    35 ) * YC(  O3 ) * YC(  HO2 )
!     RXRAT(     36 ) = RKI(    36 ) * YC(  O3 ) * YC(  NO )
      RXRAT(     37 ) = RKI(    37 ) * YC(  O3 ) * YC(  NO2 )
!     RXRAT(     38 ) = RKI(    38 ) * YC(  O3P )
!     RXRAT(     39 ) = RKI(    39 ) * YC(  O3P ) * YC(  O3 )
!     RXRAT(     40 ) = RKI(    40 ) * YC(  O1D )
!     RXRAT(     41 ) = RKI(    41 ) * YC(  O1D )
!     RXRAT(     42 ) = RKI(    42 ) * YC(  O1D )
!     RXRAT(     43 ) = RKI(    43 ) * YC(  HO )
!     RXRAT(     44 ) = RKI(    44 ) * YC(  HO ) * YC(  HO2 )
      RXRAT(     45 ) = RKI(    45 ) * YC(  HO2 ) * YC(  HO2 )
      RXRAT(     46 ) = RKI(    46 ) * YC(  HO2 ) * YC(  HO2 )
      RXRAT(     47 ) = RKI(    47 ) * YC(  H2O2 ) * YC(  HO )
!     RXRAT(     48 ) = RKI(    48 ) * YC(  NO ) * YC(  O3P )
!     RXRAT(     49 ) = RKI(    49 ) * YC(  NO ) * YC(  HO )
!     RXRAT(     50 ) = RKI(    50 ) * YC(  NO ) * YC(  HO2 )
      RXRAT(     51 ) = RKI(    51 ) * YC(  NO ) * YC(  HO2 )
!     RXRAT(     52 ) = RKI(    52 ) * YC(  NO ) * YC(  NO )
      RXRAT(     53 ) = RKI(    53 ) * YC(  HONO ) * YC(  HO )
!     RXRAT(     54 ) = RKI(    54 ) * YC(  NO2 ) * YC(  O3P )
      RXRAT(     55 ) = RKI(    55 ) * YC(  NO2 ) * YC(  O3P )
      RXRAT(     56 ) = RKI(    56 ) * YC(  NO2 ) * YC(  HO )
      RXRAT(     57 ) = RKI(    57 ) * YC(  HNO3 ) * YC(  HO )
      RXRAT(     58 ) = RKI(    58 ) * YC(  NO3 ) * YC(  HO )
      RXRAT(     59 ) = RKI(    59 ) * YC(  NO3 ) * YC(  HO2 )
      RXRAT(     60 ) = RKI(    60 ) * YC(  NO3 ) * YC(  NO )
      RXRAT(     61 ) = RKI(    61 ) * YC(  NO3 ) * YC(  NO2 )
      RXRAT(     62 ) = RKI(    62 ) * YC(  NO3 ) * YC(  NO3 )
!     RXRAT(     63 ) = RKI(    63 ) * YC(  NO3 ) * YC(  NO2 )
      RXRAT(     64 ) = RKI(    64 ) * YC(  N2O5 )
      RXRAT(     65 ) = RKI(    65 ) * YC(  N2O5 )
!     RXRAT(     66 ) = RKI(    66 ) * YC(  NO2 ) * YC(  HO2 )
      RXRAT(     67 ) = RKI(    67 ) * YC(  HNO4 )
      RXRAT(     68 ) = RKI(    68 ) * YC(  HNO4 ) * YC(  HO )
      RXRAT(     69 ) = RKI(    69 ) * YC(  SO2 ) * YC(  HO )
      RXRAT(     70 ) = RKI(    70 ) * YC(  CO ) * YC(  HO )
      RXRAT(     71 ) = RKI(    71 ) * YC(  HO )
      RXRAT(     72 ) = RKI(    72 ) * YC(  ETH ) * YC(  HO )
      RXRAT(     73 ) = RKI(    73 ) * YC(  HC3 ) * YC(  HO )
      RXRAT(     74 ) = RKI(    74 ) * YC(  HC5 ) * YC(  HO )
      RXRAT(     75 ) = RKI(    75 ) * YC(  HC8 ) * YC(  HO )
      RXRAT(     76 ) = RKI(    76 ) * YC(  ETE ) * YC(  HO )
      RXRAT(     77 ) = RKI(    77 ) * YC(  OLT ) * YC(  HO )
      RXRAT(     78 ) = RKI(    78 ) * YC(  OLI ) * YC(  HO )
      RXRAT(     79 ) = RKI(    79 ) * YC(  DIEN ) * YC(  HO )
      RXRAT(     80 ) = RKI(    80 ) * YC(  ACE ) * YC(  HO )
      RXRAT(     81 ) = RKI(    81 ) * YC(  BENZENE ) * YC(  HO )
      RXRAT(     82 ) = RKI(    82 ) * YC(  TOL ) * YC(  HO )
      RXRAT(     83 ) = RKI(    83 ) * YC(  XYM ) * YC(  HO )
      RXRAT(     84 ) = RKI(    84 ) * YC(  XYP ) * YC(  HO )
      RXRAT(     85 ) = RKI(    85 ) * YC(  XYO ) * YC(  HO )
      RXRAT(     86 ) = RKI(    86 ) * YC(  ISO ) * YC(  HO )
      RXRAT(     87 ) = RKI(    87 ) * YC(  API ) * YC(  HO )
      RXRAT(     88 ) = RKI(    88 ) * YC(  LIM ) * YC(  HO )
      RXRAT(     89 ) = RKI(    89 ) * YC(  HCHO ) * YC(  HO )
      RXRAT(     90 ) = RKI(    90 ) * YC(  ACD ) * YC(  HO )
      RXRAT(     91 ) = RKI(    91 ) * YC(  ALD ) * YC(  HO )
      RXRAT(     92 ) = RKI(    92 ) * YC(  ACT ) * YC(  HO )
      RXRAT(     93 ) = RKI(    93 ) * YC(  MEK ) * YC(  HO )
      RXRAT(     94 ) = RKI(    94 ) * YC(  KET ) * YC(  HO )
      RXRAT(     95 ) = RKI(    95 ) * YC(  HKET ) * YC(  HO )
      RXRAT(     96 ) = RKI(    96 ) * YC(  MACR ) * YC(  HO )
      RXRAT(     97 ) = RKI(    97 ) * YC(  MVK ) * YC(  HO )
      RXRAT(     98 ) = RKI(    98 ) * YC(  UALD ) * YC(  HO )
      RXRAT(     99 ) = RKI(    99 ) * YC(  GLY ) * YC(  HO )
      RXRAT(    100 ) = RKI(   100 ) * YC(  MGLY ) * YC(  HO )
      RXRAT(    101 ) = RKI(   101 ) * YC(  DCB1 ) * YC(  HO )
      RXRAT(    102 ) = RKI(   102 ) * YC(  DCB2 ) * YC(  HO )
      RXRAT(    103 ) = RKI(   103 ) * YC(  DCB3 ) * YC(  HO )
      RXRAT(    104 ) = RKI(   104 ) * YC(  BALD ) * YC(  HO )
      RXRAT(    105 ) = RKI(   105 ) * YC(  PHEN ) * YC(  HO )
      RXRAT(    106 ) = RKI(   106 ) * YC(  CSL ) * YC(  HO )
      RXRAT(    107 ) = RKI(   107 ) * YC(  EPX ) * YC(  HO )
      RXRAT(    108 ) = RKI(   108 ) * YC(  MCT ) * YC(  HO )
      RXRAT(    109 ) = RKI(   109 ) * YC(  MOH ) * YC(  HO )
      RXRAT(    110 ) = RKI(   110 ) * YC(  EOH ) * YC(  HO )
      RXRAT(    111 ) = RKI(   111 ) * YC(  ROH ) * YC(  HO )
      RXRAT(    112 ) = RKI(   112 ) * YC(  ETEG ) * YC(  HO )
      RXRAT(    113 ) = RKI(   113 ) * YC(  OP1 ) * YC(  HO )
      RXRAT(    114 ) = RKI(   114 ) * YC(  OP2 ) * YC(  HO )
      RXRAT(    115 ) = RKI(   115 ) * YC(  ISHP ) * YC(  HO )
      RXRAT(    116 ) = RKI(   116 ) * YC(  MAHP ) * YC(  HO )
      RXRAT(    117 ) = RKI(   117 ) * YC(  ORA1 ) * YC(  HO )
      RXRAT(    118 ) = RKI(   118 ) * YC(  ORA2 ) * YC(  HO )
      RXRAT(    119 ) = RKI(   119 ) * YC(  PAA ) * YC(  HO )
      RXRAT(    120 ) = RKI(   120 ) * YC(  PAN ) * YC(  HO )
      RXRAT(    121 ) = RKI(   121 ) * YC(  PPN ) * YC(  HO )
      RXRAT(    122 ) = RKI(   122 ) * YC(  MPAN ) * YC(  HO )
      RXRAT(    123 ) = RKI(   123 ) * YC(  ONIT ) * YC(  HO )
      RXRAT(    124 ) = RKI(   124 ) * YC(  NALD ) * YC(  HO )
      RXRAT(    125 ) = RKI(   125 ) * YC(  ISON ) * YC(  HO )
      RXRAT(    126 ) = RKI(   126 ) * YC(  ETE ) * YC(  O3 )
      RXRAT(    127 ) = RKI(   127 ) * YC(  OLT ) * YC(  O3 )
      RXRAT(    128 ) = RKI(   128 ) * YC(  OLI ) * YC(  O3 )
      RXRAT(    129 ) = RKI(   129 ) * YC(  DIEN ) * YC(  O3 )
      RXRAT(    130 ) = RKI(   130 ) * YC(  ISO ) * YC(  O3 )
      RXRAT(    131 ) = RKI(   131 ) * YC(  API ) * YC(  O3 )
      RXRAT(    132 ) = RKI(   132 ) * YC(  LIM ) * YC(  O3 )
      RXRAT(    133 ) = RKI(   133 ) * YC(  MACR ) * YC(  O3 )
      RXRAT(    134 ) = RKI(   134 ) * YC(  MVK ) * YC(  O3 )
      RXRAT(    135 ) = RKI(   135 ) * YC(  UALD ) * YC(  O3 )
      RXRAT(    136 ) = RKI(   136 ) * YC(  DCB1 ) * YC(  O3 )
      RXRAT(    137 ) = RKI(   137 ) * YC(  DCB2 ) * YC(  O3 )
      RXRAT(    138 ) = RKI(   138 ) * YC(  DCB3 ) * YC(  O3 )
      RXRAT(    139 ) = RKI(   139 ) * YC(  EPX ) * YC(  O3 )
      RXRAT(    140 ) = RKI(   140 ) * YC(  MCTO ) * YC(  O3 )
      RXRAT(    141 ) = RKI(   141 ) * YC(  ETE ) * YC(  NO3 )
      RXRAT(    142 ) = RKI(   142 ) * YC(  OLT ) * YC(  NO3 )
      RXRAT(    143 ) = RKI(   143 ) * YC(  OLI ) * YC(  NO3 )
      RXRAT(    144 ) = RKI(   144 ) * YC(  DIEN ) * YC(  NO3 )
      RXRAT(    145 ) = RKI(   145 ) * YC(  ISO ) * YC(  NO3 )
      RXRAT(    146 ) = RKI(   146 ) * YC(  API ) * YC(  NO3 )
      RXRAT(    147 ) = RKI(   147 ) * YC(  LIM ) * YC(  NO3 )
      RXRAT(    148 ) = RKI(   148 ) * YC(  HCHO ) * YC(  NO3 )
      RXRAT(    149 ) = RKI(   149 ) * YC(  ACD ) * YC(  NO3 )
      RXRAT(    150 ) = RKI(   150 ) * YC(  ALD ) * YC(  NO3 )
      RXRAT(    151 ) = RKI(   151 ) * YC(  MACR ) * YC(  NO3 )
      RXRAT(    152 ) = RKI(   152 ) * YC(  UALD ) * YC(  NO3 )
      RXRAT(    153 ) = RKI(   153 ) * YC(  GLY ) * YC(  NO3 )
      RXRAT(    154 ) = RKI(   154 ) * YC(  MGLY ) * YC(  NO3 )
      RXRAT(    155 ) = RKI(   155 ) * YC(  PHEN ) * YC(  NO3 )
      RXRAT(    156 ) = RKI(   156 ) * YC(  CSL ) * YC(  NO3 )
      RXRAT(    157 ) = RKI(   157 ) * YC(  EPX ) * YC(  NO3 )
      RXRAT(    158 ) = RKI(   158 ) * YC(  MCT ) * YC(  NO3 )
      RXRAT(    159 ) = RKI(   159 ) * YC(  MPAN ) * YC(  NO3 )
      RXRAT(    160 ) = RKI(   160 ) * YC(  TR2 )
      RXRAT(    161 ) = RKI(   161 ) * YC(  TOLP )
      RXRAT(    162 ) = RKI(   162 ) * YC(  XY2 )
      RXRAT(    163 ) = RKI(   163 ) * YC(  XYLP )
      RXRAT(    164 ) = RKI(   164 ) * YC(  XYO2 )
      RXRAT(    165 ) = RKI(   165 ) * YC(  XYOP )
!     RXRAT(    166 ) = RKI(   166 ) * YC(  ACO3 ) * YC(  NO2 )
      RXRAT(    167 ) = RKI(   167 ) * YC(  PAN )
      RXRAT(    168 ) = RKI(   168 ) * YC(  RCO3 ) * YC(  NO2 )
      RXRAT(    169 ) = RKI(   169 ) * YC(  PPN )
      RXRAT(    170 ) = RKI(   170 ) * YC(  MACP ) * YC(  NO2 )
      RXRAT(    171 ) = RKI(   171 ) * YC(  MPAN )
      RXRAT(    172 ) = RKI(   172 ) * YC(  MO2 ) * YC(  NO )
      RXRAT(    173 ) = RKI(   173 ) * YC(  ETHP ) * YC(  NO )
      RXRAT(    174 ) = RKI(   174 ) * YC(  HC3P ) * YC(  NO )
      RXRAT(    175 ) = RKI(   175 ) * YC(  HC5P ) * YC(  NO )
      RXRAT(    176 ) = RKI(   176 ) * YC(  HC8P ) * YC(  NO )
      RXRAT(    177 ) = RKI(   177 ) * YC(  ETEP ) * YC(  NO )
      RXRAT(    178 ) = RKI(   178 ) * YC(  OLTP ) * YC(  NO )
      RXRAT(    179 ) = RKI(   179 ) * YC(  OLIP ) * YC(  NO )
      RXRAT(    180 ) = RKI(   180 ) * YC(  BENP ) * YC(  NO )
      RXRAT(    181 ) = RKI(   181 ) * YC(  TLP1 ) * YC(  NO )
      RXRAT(    182 ) = RKI(   182 ) * YC(  TOLP ) * YC(  NO )
      RXRAT(    183 ) = RKI(   183 ) * YC(  PER1 ) * YC(  NO )
      RXRAT(    184 ) = RKI(   184 ) * YC(  XYL1 ) * YC(  NO )
      RXRAT(    185 ) = RKI(   185 ) * YC(  XYLP ) * YC(  NO )
      RXRAT(    186 ) = RKI(   186 ) * YC(  PER2 ) * YC(  NO )
      RXRAT(    187 ) = RKI(   187 ) * YC(  XYOP ) * YC(  NO )
      RXRAT(    188 ) = RKI(   188 ) * YC(  ISOP ) * YC(  NO )
      RXRAT(    189 ) = RKI(   189 ) * YC(  APIP ) * YC(  NO )
      RXRAT(    190 ) = RKI(   190 ) * YC(  LIMP ) * YC(  NO )
      RXRAT(    191 ) = RKI(   191 ) * YC(  ACO3 ) * YC(  NO )
      RXRAT(    192 ) = RKI(   192 ) * YC(  RCO3 ) * YC(  NO )
      RXRAT(    193 ) = RKI(   193 ) * YC(  ACTP ) * YC(  NO )
      RXRAT(    194 ) = RKI(   194 ) * YC(  MEKP ) * YC(  NO )
      RXRAT(    195 ) = RKI(   195 ) * YC(  KETP ) * YC(  NO )
      RXRAT(    196 ) = RKI(   196 ) * YC(  MACP ) * YC(  NO )
      RXRAT(    197 ) = RKI(   197 ) * YC(  MCP ) * YC(  NO )
      RXRAT(    198 ) = RKI(   198 ) * YC(  MVKP ) * YC(  NO )
      RXRAT(    199 ) = RKI(   199 ) * YC(  UALP ) * YC(  NO )
      RXRAT(    200 ) = RKI(   200 ) * YC(  BALP ) * YC(  NO )
      RXRAT(    201 ) = RKI(   201 ) * YC(  BAL1 ) * YC(  NO )
      RXRAT(    202 ) = RKI(   202 ) * YC(  ADDC ) * YC(  NO )
      RXRAT(    203 ) = RKI(   203 ) * YC(  MCTP ) * YC(  NO )
      RXRAT(    204 ) = RKI(   204 ) * YC(  ORAP ) * YC(  NO )
      RXRAT(    205 ) = RKI(   205 ) * YC(  OLNN ) * YC(  NO )
      RXRAT(    206 ) = RKI(   206 ) * YC(  OLND ) * YC(  NO )
      RXRAT(    207 ) = RKI(   207 ) * YC(  ADCN ) * YC(  NO )
      RXRAT(    208 ) = RKI(   208 ) * YC(  XO2 ) * YC(  NO )
      RXRAT(    209 ) = RKI(   209 ) * YC(  BAL2 ) * YC(  NO2 )
      RXRAT(    210 ) = RKI(   210 ) * YC(  CHO ) * YC(  NO2 )
      RXRAT(    211 ) = RKI(   211 ) * YC(  MCTO ) * YC(  NO2 )
      RXRAT(    212 ) = RKI(   212 ) * YC(  MO2 ) * YC(  HO2 )
      RXRAT(    213 ) = RKI(   213 ) * YC(  ETHP ) * YC(  HO2 )
      RXRAT(    214 ) = RKI(   214 ) * YC(  HC3P ) * YC(  HO2 )
      RXRAT(    215 ) = RKI(   215 ) * YC(  HC5P ) * YC(  HO2 )
      RXRAT(    216 ) = RKI(   216 ) * YC(  HC8P ) * YC(  HO2 )
      RXRAT(    217 ) = RKI(   217 ) * YC(  ETEP ) * YC(  HO2 )
      RXRAT(    218 ) = RKI(   218 ) * YC(  OLTP ) * YC(  HO2 )
      RXRAT(    219 ) = RKI(   219 ) * YC(  OLIP ) * YC(  HO2 )
      RXRAT(    220 ) = RKI(   220 ) * YC(  BENP ) * YC(  HO2 )
      RXRAT(    221 ) = RKI(   221 ) * YC(  TLP1 ) * YC(  HO2 )
      RXRAT(    222 ) = RKI(   222 ) * YC(  TOLP ) * YC(  HO2 )
      RXRAT(    223 ) = RKI(   223 ) * YC(  PER1 ) * YC(  HO2 )
      RXRAT(    224 ) = RKI(   224 ) * YC(  XYL1 ) * YC(  HO2 )
      RXRAT(    225 ) = RKI(   225 ) * YC(  XYLP ) * YC(  HO2 )
      RXRAT(    226 ) = RKI(   226 ) * YC(  PER2 ) * YC(  HO2 )
      RXRAT(    227 ) = RKI(   227 ) * YC(  XYOP ) * YC(  HO2 )
      RXRAT(    228 ) = RKI(   228 ) * YC(  ISOP ) * YC(  HO2 )
      RXRAT(    229 ) = RKI(   229 ) * YC(  APIP ) * YC(  HO2 )
      RXRAT(    230 ) = RKI(   230 ) * YC(  LIMP ) * YC(  HO2 )
      RXRAT(    231 ) = RKI(   231 ) * YC(  ACO3 ) * YC(  HO2 )
      RXRAT(    232 ) = RKI(   232 ) * YC(  RCO3 ) * YC(  HO2 )
      RXRAT(    233 ) = RKI(   233 ) * YC(  ACTP ) * YC(  HO2 )
      RXRAT(    234 ) = RKI(   234 ) * YC(  MEKP ) * YC(  HO2 )
      RXRAT(    235 ) = RKI(   235 ) * YC(  KETP ) * YC(  HO2 )
      RXRAT(    236 ) = RKI(   236 ) * YC(  MACP ) * YC(  HO2 )
      RXRAT(    237 ) = RKI(   237 ) * YC(  MCP ) * YC(  HO2 )
      RXRAT(    238 ) = RKI(   238 ) * YC(  MVKP ) * YC(  HO2 )
      RXRAT(    239 ) = RKI(   239 ) * YC(  UALP ) * YC(  HO2 )
      RXRAT(    240 ) = RKI(   240 ) * YC(  ADDC ) * YC(  HO2 )
      RXRAT(    241 ) = RKI(   241 ) * YC(  CHO ) * YC(  HO2 )
      RXRAT(    242 ) = RKI(   242 ) * YC(  MCTP ) * YC(  HO2 )
      RXRAT(    243 ) = RKI(   243 ) * YC(  ORAP ) * YC(  HO2 )
      RXRAT(    244 ) = RKI(   244 ) * YC(  OLNN ) * YC(  HO2 )
      RXRAT(    245 ) = RKI(   245 ) * YC(  OLND ) * YC(  HO2 )
      RXRAT(    246 ) = RKI(   246 ) * YC(  ADCN ) * YC(  HO2 )
      RXRAT(    247 ) = RKI(   247 ) * YC(  XO2 ) * YC(  HO2 )
      RXRAT(    248 ) = RKI(   248 ) * YC(  MO2 ) * YC(  MO2 )
      RXRAT(    249 ) = RKI(   249 ) * YC(  ETHP ) * YC(  MO2 )
      RXRAT(    250 ) = RKI(   250 ) * YC(  HC3P ) * YC(  MO2 )
      RXRAT(    251 ) = RKI(   251 ) * YC(  HC5P ) * YC(  MO2 )
      RXRAT(    252 ) = RKI(   252 ) * YC(  HC8P ) * YC(  MO2 )
      RXRAT(    253 ) = RKI(   253 ) * YC(  ETEP ) * YC(  MO2 )
      RXRAT(    254 ) = RKI(   254 ) * YC(  OLTP ) * YC(  MO2 )
      RXRAT(    255 ) = RKI(   255 ) * YC(  OLIP ) * YC(  MO2 )
      RXRAT(    256 ) = RKI(   256 ) * YC(  BENP ) * YC(  MO2 )
      RXRAT(    257 ) = RKI(   257 ) * YC(  TLP1 ) * YC(  MO2 )
      RXRAT(    258 ) = RKI(   258 ) * YC(  TOLP ) * YC(  MO2 )
      RXRAT(    259 ) = RKI(   259 ) * YC(  PER1 ) * YC(  MO2 )
      RXRAT(    260 ) = RKI(   260 ) * YC(  XYL1 ) * YC(  MO2 )
      RXRAT(    261 ) = RKI(   261 ) * YC(  XYLP ) * YC(  MO2 )
      RXRAT(    262 ) = RKI(   262 ) * YC(  PER2 ) * YC(  MO2 )
      RXRAT(    263 ) = RKI(   263 ) * YC(  XYOP ) * YC(  MO2 )
      RXRAT(    264 ) = RKI(   264 ) * YC(  ISOP ) * YC(  MO2 )
      RXRAT(    265 ) = RKI(   265 ) * YC(  APIP ) * YC(  MO2 )
      RXRAT(    266 ) = RKI(   266 ) * YC(  LIMP ) * YC(  MO2 )
      RXRAT(    267 ) = RKI(   267 ) * YC(  ACO3 ) * YC(  MO2 )
      RXRAT(    268 ) = RKI(   268 ) * YC(  RCO3 ) * YC(  MO2 )
      RXRAT(    269 ) = RKI(   269 ) * YC(  ACTP ) * YC(  MO2 )
      RXRAT(    270 ) = RKI(   270 ) * YC(  MEKP ) * YC(  MO2 )
      RXRAT(    271 ) = RKI(   271 ) * YC(  KETP ) * YC(  MO2 )
      RXRAT(    272 ) = RKI(   272 ) * YC(  MACP ) * YC(  MO2 )
      RXRAT(    273 ) = RKI(   273 ) * YC(  MCP ) * YC(  MO2 )
      RXRAT(    274 ) = RKI(   274 ) * YC(  MVKP ) * YC(  MO2 )
      RXRAT(    275 ) = RKI(   275 ) * YC(  UALP ) * YC(  MO2 )
      RXRAT(    276 ) = RKI(   276 ) * YC(  BALP ) * YC(  MO2 )
      RXRAT(    277 ) = RKI(   277 ) * YC(  BAL1 ) * YC(  MO2 )
      RXRAT(    278 ) = RKI(   278 ) * YC(  ADDC ) * YC(  MO2 )
      RXRAT(    279 ) = RKI(   279 ) * YC(  MCTP ) * YC(  MO2 )
      RXRAT(    280 ) = RKI(   280 ) * YC(  ORAP ) * YC(  MO2 )
      RXRAT(    281 ) = RKI(   281 ) * YC(  OLNN ) * YC(  MO2 )
      RXRAT(    282 ) = RKI(   282 ) * YC(  OLND ) * YC(  MO2 )
      RXRAT(    283 ) = RKI(   283 ) * YC(  ADCN ) * YC(  MO2 )
      RXRAT(    284 ) = RKI(   284 ) * YC(  XO2 ) * YC(  MO2 )
      RXRAT(    285 ) = RKI(   285 ) * YC(  ETHP ) * YC(  ACO3 )
      RXRAT(    286 ) = RKI(   286 ) * YC(  HC3P ) * YC(  ACO3 )
      RXRAT(    287 ) = RKI(   287 ) * YC(  HC5P ) * YC(  ACO3 )
      RXRAT(    288 ) = RKI(   288 ) * YC(  HC8P ) * YC(  ACO3 )
      RXRAT(    289 ) = RKI(   289 ) * YC(  ETEP ) * YC(  ACO3 )
      RXRAT(    290 ) = RKI(   290 ) * YC(  OLTP ) * YC(  ACO3 )
      RXRAT(    291 ) = RKI(   291 ) * YC(  OLIP ) * YC(  ACO3 )
      RXRAT(    292 ) = RKI(   292 ) * YC(  BENP ) * YC(  ACO3 )
      RXRAT(    293 ) = RKI(   293 ) * YC(  TLP1 ) * YC(  ACO3 )
      RXRAT(    294 ) = RKI(   294 ) * YC(  TOLP ) * YC(  ACO3 )
      RXRAT(    295 ) = RKI(   295 ) * YC(  PER1 ) * YC(  ACO3 )
      RXRAT(    296 ) = RKI(   296 ) * YC(  XYL1 ) * YC(  ACO3 )
      RXRAT(    297 ) = RKI(   297 ) * YC(  XYLP ) * YC(  ACO3 )
      RXRAT(    298 ) = RKI(   298 ) * YC(  PER2 ) * YC(  ACO3 )
      RXRAT(    299 ) = RKI(   299 ) * YC(  XYOP ) * YC(  ACO3 )
      RXRAT(    300 ) = RKI(   300 ) * YC(  ISOP ) * YC(  ACO3 )
      RXRAT(    301 ) = RKI(   301 ) * YC(  APIP ) * YC(  ACO3 )
      RXRAT(    302 ) = RKI(   302 ) * YC(  LIMP ) * YC(  ACO3 )
      RXRAT(    303 ) = RKI(   303 ) * YC(  ACO3 ) * YC(  ACO3 )
      RXRAT(    304 ) = RKI(   304 ) * YC(  RCO3 ) * YC(  ACO3 )
      RXRAT(    305 ) = RKI(   305 ) * YC(  ACTP ) * YC(  ACO3 )
      RXRAT(    306 ) = RKI(   306 ) * YC(  MEKP ) * YC(  ACO3 )
      RXRAT(    307 ) = RKI(   307 ) * YC(  KETP ) * YC(  ACO3 )
      RXRAT(    308 ) = RKI(   308 ) * YC(  MACP ) * YC(  ACO3 )
      RXRAT(    309 ) = RKI(   309 ) * YC(  MCP ) * YC(  ACO3 )
      RXRAT(    310 ) = RKI(   310 ) * YC(  MVKP ) * YC(  ACO3 )
      RXRAT(    311 ) = RKI(   311 ) * YC(  UALP ) * YC(  ACO3 )
      RXRAT(    312 ) = RKI(   312 ) * YC(  BALP ) * YC(  ACO3 )
      RXRAT(    313 ) = RKI(   313 ) * YC(  BAL1 ) * YC(  ACO3 )
      RXRAT(    314 ) = RKI(   314 ) * YC(  ADDC ) * YC(  ACO3 )
      RXRAT(    315 ) = RKI(   315 ) * YC(  MCTP ) * YC(  ACO3 )
      RXRAT(    316 ) = RKI(   316 ) * YC(  ORAP ) * YC(  ACO3 )
      RXRAT(    317 ) = RKI(   317 ) * YC(  OLNN ) * YC(  ACO3 )
      RXRAT(    318 ) = RKI(   318 ) * YC(  OLND ) * YC(  ACO3 )
      RXRAT(    319 ) = RKI(   319 ) * YC(  ADCN ) * YC(  ACO3 )
      RXRAT(    320 ) = RKI(   320 ) * YC(  XO2 ) * YC(  ACO3 )
      RXRAT(    321 ) = RKI(   321 ) * YC(  RCO3 ) * YC(  RCO3 )
      RXRAT(    322 ) = RKI(   322 ) * YC(  MO2 ) * YC(  NO3 )
      RXRAT(    323 ) = RKI(   323 ) * YC(  ETHP ) * YC(  NO3 )
      RXRAT(    324 ) = RKI(   324 ) * YC(  HC3P ) * YC(  NO3 )
      RXRAT(    325 ) = RKI(   325 ) * YC(  HC5P ) * YC(  NO3 )
      RXRAT(    326 ) = RKI(   326 ) * YC(  HC8P ) * YC(  NO3 )
      RXRAT(    327 ) = RKI(   327 ) * YC(  ETEP ) * YC(  NO3 )
      RXRAT(    328 ) = RKI(   328 ) * YC(  OLTP ) * YC(  NO3 )
      RXRAT(    329 ) = RKI(   329 ) * YC(  OLIP ) * YC(  NO3 )
      RXRAT(    330 ) = RKI(   330 ) * YC(  BENP ) * YC(  NO3 )
      RXRAT(    331 ) = RKI(   331 ) * YC(  TLP1 ) * YC(  NO3 )
      RXRAT(    332 ) = RKI(   332 ) * YC(  TOLP ) * YC(  NO3 )
      RXRAT(    333 ) = RKI(   333 ) * YC(  PER1 ) * YC(  NO3 )
      RXRAT(    334 ) = RKI(   334 ) * YC(  XYL1 ) * YC(  NO3 )
      RXRAT(    335 ) = RKI(   335 ) * YC(  XYLP ) * YC(  NO3 )
      RXRAT(    336 ) = RKI(   336 ) * YC(  PER2 ) * YC(  NO3 )
      RXRAT(    337 ) = RKI(   337 ) * YC(  XYOP ) * YC(  NO3 )
      RXRAT(    338 ) = RKI(   338 ) * YC(  ISOP ) * YC(  NO3 )
      RXRAT(    339 ) = RKI(   339 ) * YC(  APIP ) * YC(  NO3 )
      RXRAT(    340 ) = RKI(   340 ) * YC(  LIMP ) * YC(  NO3 )
      RXRAT(    341 ) = RKI(   341 ) * YC(  ACO3 ) * YC(  NO3 )
      RXRAT(    342 ) = RKI(   342 ) * YC(  RCO3 ) * YC(  NO3 )
      RXRAT(    343 ) = RKI(   343 ) * YC(  ACTP ) * YC(  NO3 )
      RXRAT(    344 ) = RKI(   344 ) * YC(  MEKP ) * YC(  NO3 )
      RXRAT(    345 ) = RKI(   345 ) * YC(  KETP ) * YC(  NO3 )
      RXRAT(    346 ) = RKI(   346 ) * YC(  MACP ) * YC(  NO3 )
      RXRAT(    347 ) = RKI(   347 ) * YC(  MCP ) * YC(  NO3 )
      RXRAT(    348 ) = RKI(   348 ) * YC(  MVKP ) * YC(  NO3 )
      RXRAT(    349 ) = RKI(   349 ) * YC(  UALP ) * YC(  NO3 )
      RXRAT(    350 ) = RKI(   350 ) * YC(  BALP ) * YC(  NO3 )
      RXRAT(    351 ) = RKI(   351 ) * YC(  BAL1 ) * YC(  NO3 )
      RXRAT(    352 ) = RKI(   352 ) * YC(  ADDC ) * YC(  NO3 )
      RXRAT(    353 ) = RKI(   353 ) * YC(  MCTP ) * YC(  NO3 )
      RXRAT(    354 ) = RKI(   354 ) * YC(  ORAP ) * YC(  NO3 )
      RXRAT(    355 ) = RKI(   355 ) * YC(  OLNN ) * YC(  NO3 )
      RXRAT(    356 ) = RKI(   356 ) * YC(  OLND ) * YC(  NO3 )
      RXRAT(    357 ) = RKI(   357 ) * YC(  ADCN ) * YC(  NO3 )
      RXRAT(    358 ) = RKI(   358 ) * YC(  OLNN ) * YC(  OLNN )
      RXRAT(    359 ) = RKI(   359 ) * YC(  OLNN ) * YC(  OLND )
      RXRAT(    360 ) = RKI(   360 ) * YC(  OLND ) * YC(  OLND )
      RXRAT(    361 ) = RKI(   361 ) * YC(  XO2 ) * YC(  NO3 )
      RXRAT(    362 ) = RKI(   362 ) * YC(  XO2 ) * YC(  RCO3 )
      RXRAT(    363 ) = RKI(   363 ) * YC(  XO2 ) * YC(  XO2 )
      RXRAT(    364 ) = RKI(   364 ) * YC(  TOLRO2 ) * YC(  NO )
      RXRAT(    365 ) = RKI(   365 ) * YC(  TOLRO2 ) * YC(  HO2 )
      RXRAT(    366 ) = RKI(   366 ) * YC(  XYLRO2 ) * YC(  NO )
      RXRAT(    367 ) = RKI(   367 ) * YC(  XYLRO2 ) * YC(  HO2 )
      RXRAT(    368 ) = RKI(   368 ) * YC(  BENZRO2 ) * YC(  NO )
      RXRAT(    369 ) = RKI(   369 ) * YC(  BENZRO2 ) * YC(  HO2 )
      RXRAT(    370 ) = RKI(   370 ) * YC(  SESQ ) * YC(  O3 )
      RXRAT(    371 ) = RKI(   371 ) * YC(  SESQ ) * YC(  HO )
      RXRAT(    372 ) = RKI(   372 ) * YC(  SESQ ) * YC(  NO3 )
      RXRAT(    373 ) = RKI(   373 ) * YC(  NAPH ) * YC(  HO )
      RXRAT(    374 ) = RKI(   374 ) * YC(  PAHRO2 ) * YC(  NO )
      RXRAT(    375 ) = RKI(   375 ) * YC(  PAHRO2 ) * YC(  HO2 )
      RXRAT(    376 ) = RKI(   376 ) * YC(  SOAALK ) * YC(  HO )
      RXRAT(    377 ) = RKI(   377 ) * YC(  IEPOX ) * YC(  HO )
      RXRAT(    378 ) = RKI(   378 ) * YC(  N2O5 )
      RXRAT(    379 ) = RKI(   379 ) * YC(  NO2 )
!     RXRAT(    380 ) = RKI(   380 ) * YC(  O3 )
      RXRAT(    381 ) = RKI(   381 ) * YC(  IEPOX )
      RXRAT(    382 ) = RKI(   382 ) * YC(  AXYL1J )
      RXRAT(    383 ) = RKI(   383 ) * YC(  AXYL2J )
      RXRAT(    384 ) = RKI(   384 ) * YC(  ATOL1J )
      RXRAT(    385 ) = RKI(   385 ) * YC(  ATOL2J )
      RXRAT(    386 ) = RKI(   386 ) * YC(  ABNZ1J )
      RXRAT(    387 ) = RKI(   387 ) * YC(  ABNZ2J )
      RXRAT(    388 ) = RKI(   388 ) * YC(  ATRP1J )
      RXRAT(    389 ) = RKI(   389 ) * YC(  ATRP2J )
      RXRAT(    390 ) = RKI(   390 ) * YC(  AISO1J )
      RXRAT(    391 ) = RKI(   391 ) * YC(  AISO2J )
      RXRAT(    392 ) = RKI(   392 ) * YC(  ASQTJ )
      RXRAT(    393 ) = RKI(   393 ) * YC(  APAH1J )
      RXRAT(    394 ) = RKI(   394 ) * YC(  APAH2J )
      RXRAT(    395 ) = RKI(   395 ) * YC(  AALK1J )
      RXRAT(    396 ) = RKI(   396 ) * YC(  AALK2J )
      RXRAT(    397 ) = RKI(   397 ) * YC(  APOCI ) * YC(  HO )
      RXRAT(    398 ) = RKI(   398 ) * YC(  APNCOMI ) * YC(  HO )
      RXRAT(    399 ) = RKI(   399 ) * YC(  APOCJ ) * YC(  HO )
      RXRAT(    400 ) = RKI(   400 ) * YC(  APNCOMJ ) * YC(  HO )
      RXRAT(    401 ) = RKI(   401 ) * YC(  PCVOC ) * YC(  HO )
      RXRAT(    402 ) = RKI(   402 ) * YC(  VLVPO1 ) * YC(  HO )
      RXRAT(    403 ) = RKI(   403 ) * YC(  VSVPO1 ) * YC(  HO )
      RXRAT(    404 ) = RKI(   404 ) * YC(  VSVPO2 ) * YC(  HO )
      RXRAT(    405 ) = RKI(   405 ) * YC(  VSVPO3 ) * YC(  HO )
      RXRAT(    406 ) = RKI(   406 ) * YC(  VIVPO1 ) * YC(  HO )
      RXRAT(    407 ) = RKI(   407 ) * YC(  VLVOO1 ) * YC(  HO )
      RXRAT(    408 ) = RKI(   408 ) * YC(  VLVOO2 ) * YC(  HO )
      RXRAT(    409 ) = RKI(   409 ) * YC(  VSVOO1 ) * YC(  HO )
      RXRAT(    410 ) = RKI(   410 ) * YC(  VSVOO2 ) * YC(  HO )
      RXRAT(    411 ) = RKI(   411 ) * YC(  VSVOO3 ) * YC(  HO )


      RETURN

      END
