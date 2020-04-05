;-----------------------------------------------------------------
;
;  DKRZ - NCL Example:  NCL_map_settings.ncl
;
;  30.10.14 kmf
;-----------------------------------------------------------------
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin
;-- set file name
;  diri = "$HOME/NCL/general/data/new_data/"
  diri = "./"
  fili = "zave_midcent_rcp85_selmon_concat_latlon_va850_AFR-44_ICHEC-EC-EARTH_rcp85_r1i1p1_KNMI-RACMO22T_v1_day.nc"

;-- open file and read variable
  f    =  addfile(diri+fili, "r")
  var  =  f->vwind(0,:,:)
  lat  =  f->lat
  lon  =  f->lon
  printMinMax (lon, False)
 ; printVarSummary(var)

;-- define the workstation (plot type and name)
wks = gsn_open_wks("x11","unstructured_grid")
;-- set resources
res = True
res@gsnMaximize = True
res@cnFillOn   = True
res@cnFillPalette = "rainbow"
res@gsnAddCyclic = False
res@mpMinLatF                   = min(lat)
res@mpMaxLatF                   = max(lat)
res@mpMinLonF                   = min(lon)
res@mpMaxLonF                   = max(lon)
res@tiMainString   = "African Cordex Domain"
res@tiMainFontHeightF = 0.02
;---Lat/lon arrays of unstructured grid for overlaying on map
;res@sfXArray = f->lon
;res@sfYArray = f->lat
;-- draw the contour map
plot = gsn_csm_contour_map(wks,var,res)
 ;plot = gsn_csm_contour_map(wks, var(0,:,:), res)

end
