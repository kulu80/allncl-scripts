
verlay_11.ncl
;
; Concepts illustrated:
;   - Overlaying vectors and filled contours on a map
;   - Masking out particular areas in a map
;   - Subsetting a color map
;----------------------------------------------------------------------
; This script shows how to overlay contours and vectors on a map,
; but with the contours limited to specific areas, and the 
; vectors not limited.
;
; The point of this script is to show how to mask contours against a
;geographical boundary, but in a way that allows them to be drawn up to
; the boundary location. This is unlike the shapefile masking examples,
;where grid points are set to missing if they fall outside a boundary,
; and hence you can get blocky features close to the boundary.
;
; The uvt.nc data file can be downloaded from:
;
; http://www.ncl.ucar.edu/Applications/Data/
;
;; This script was written by Yang Zhao (CAMS) 
;; (Chinese Academy of Meteorological Sciences) 
;;  email: 409360946@qq.com    Thanks you!
;;----------------------------------------------------------------------
;;Main Code;;

; These files are loaded by default in NCL V6.2.0 and newer
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin


#   dir                      = "/mnt/lfs4/HFIP/hwrfv3/Bantwale.Enyew/allncl-scripts"
#   files = systemfunc (" ls -1 " + dir + "zave_zmidcent_rcp85_selmon_zconcat_latlon_ua850*.nc")
#   numfiles = dimsizes(files)
#   print(files)
#   print(" ")



   dir                      = "/mnt/lfs4/HFIP/hwrfv3/Bantwale.Enyew/allncl-scripts"
   files = systemfunc (" ls -1 " + dir + "*.nc")
    numfiles = dimsizes(files) 
   print(files)
   print(" ")



do it= 0,numfiles-1 


  f=addfile(files(it),"r")
 uwind=f->uwind
 printVarSummary(vwind)

end do 

end
