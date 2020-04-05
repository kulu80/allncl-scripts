;----------------------------------------------------------------------
; overlay_11.ncl
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


   dir                      = "./"
   ;files = systemfunc (" ls -1 " + dir + "zave_midcent_rcp85_selmon_concat_latlon_pr_AFR-44_*.nc")
   ;numfiles = dimsizes(files)
   ;print(files)
   ;print(" ")

  ; do it = 0,numfiles-1
    
     fpr1  = addfile("zave_regridded_cpc_jaso_daily_clim.nc", "r")
     fva1  = addfile("zave_midcent_rcp85_selmon_concat_latlon_va850_AFR-44_MIROC-MIROC5_rcp85_r1i1p1_SMHI-RCA4_v1_day.nc", "r")
     fua1  = addfile("zave_zmidcent_rcp85_selmon_zconcat_latlon_ua850_AFR-44_MIROC-MIROC5_rcp85_r1i1p1_SMHI-RCA4_v1_day.nc", "r") 
  
    
     fpr2  = addfile("zave_cpc_jaso_daily_clim.nc", "r")
     fva2  = addfile("zave_midcent_rcp85_selmon_concat_latlon_va850_AFR-44_ICHEC-EC-EARTH_rcp85_r3i1p1_DMI-HIRHAM5_v2_day.nc", "r")
     fua2  = addfile("zave_zmidcent_rcp85_selmon_zconcat_latlon_ua850_AFR-44_ICHEC-EC-EARTH_rcp85_r3i1p1_DMI-HIRHAM5_v2_day.nc", "r")

    
     fpr3  = addfile("zave_midcent_rcp85_selmon_concat_latlon_pr_AFR-44_ICHEC-EC-EARTH_rcp85_r1i1p1_KNMI-RACMO22T_v1_day.nc", "r")
     fva3  = addfile("zave_midcent_rcp85_selmon_concat_latlon_va850_AFR-44_ICHEC-EC-EARTH_rcp85_r1i1p1_KNMI-RACMO22T_v1_day.nc", "r")
     fua3  = addfile("zave_zmidcent_rcp85_selmon_zconcat_latlon_ua850_AFR-44_ICHEC-EC-EARTH_rcp85_r1i1p1_KNMI-RACMO22T_v1_day.nc", "r")
    
     fpr4  = addfile("zave_midcent_rcp85_selmon_concat_latlon_pr_AFR-44_ICHEC-EC-EARTH_rcp85_r1i1p1_SMHI-RCA4_v1_day.nc", "r")
     fva4  = addfile("zave_midcent_rcp85_selmon_concat_latlon_va850_AFR-44_ICHEC-EC-EARTH_rcp85_r12i1p1_SMHI-RCA4_v1_day.nc", "r")
     fua4  = addfile("zave_zmidcent_rcp85_selmon_zconcat_latlon_ua850_AFR-44_ICHEC-EC-EARTH_rcp85_r12i1p1_SMHI-RCA4_v1_day.nc", "r")
    
    
     fpr5  = addfile("zave_midcent_rcp85_selmon_concat_latlon_pr_AFR-44_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_SMHI-RCA4_v1_day.nc", "r")
     fva5  = addfile("zave_midcent_rcp85_selmon_concat_latlon_va850_AFR-44_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_SMHI-RCA4_v1_day.nc", "r")
     fua5  = addfile("zave_zmidcent_rcp85_selmon_zconcat_latlon_ua850_AFR-44_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_SMHI-RCA4_v1_day.nc", "r")
    
  
    




  ; u    = a->CPC(0,:,:)              ; read data (64 x 128)
    pr1    = fpr1->CPC(0,:,:)              ; read data (64 x 128)
    va1    = fva1->vwind(0,:,:)
    ua1    = fua1->uwind(0,:,:)
   
    printMinMax (ua1, False)
    printMinMax (va1, False)

    pr2    = fpr2->CPC(0,:,:)              ; read data (64 x 128)
    va2    = fva2->vwind(0,:,:)
    ua2    = fua2->uwind(0,:,:)
       
    printMinMax (ua2, False)
    printMinMax (va2, False)


    pr3    = fpr3->pr(0,:,:)              ; read data (64 x 128)
    va3    = fva3->vwind(0,:,:)
    ua3    = fua3->uwind(0,:,:)
       
    printMinMax (ua3, False)
    printMinMax (va3, False)


    pr4    = fpr4->pr(0,:,:)              ; read data (64 x 128)
    va4    = fva4->vwind(0,:,:)
    ua4    = fua4->uwind(0,:,:)
      
    printMinMax (ua4, False)
    printMinMax (va4, False)

 
    pr5    = fpr5->pr(0,:,:)              ; read data (64 x 128)
    va5    = fva5->vwind(0,:,:)
    ua5    = fua5->uwind(0,:,:)
     
    printMinMax (ua5, False)
    printMinMax (va5, False)

  

    

   ; precmm2 = pr2
   ; precmm2 = precmm2*86400
   ; prdf2 =  precmm2
   ; prdf2  = pr2 -pr1
 
    precmm3 = pr3
    precmm3 = precmm3*86400
    prdf3  =  precmm3
    prdf3  = pr3 -pr1

    precmm4 = pr4
    precmm4 = precmm4*86400
    prdf4  =  precmm4
    prdf4  = pr4 -pr1


    precmm5 = pr5
    precmm5 = precmm5*86400
    prdf5  =  precmm5
    prdf5  = pr5 -pr1

    
   ;precmm1@units = "mm/day"
   ;precmm1@long_name = "Precipitation"
   ;precmm1@_FillValue = -9999
   ;printMinMax (precmm1, False)
    
   ;precmm2@units = "mm/day"
   ;precmm2@long_name = "Precipitation"
   ;precmm2@_FillValue = -9999
   ;printMinMax (precmm2, False)
    
   precmm3@units = "mm/day"
   precmm3@long_name = "Precipitation"
   precmm3@_FillValue = -9999
   printMinMax (precmm3, False)
    
   precmm4@units = "mm/day"
   precmm4@long_name = "Precipitation"
   precmm4@_FillValue = -9999
   printMinMax (precmm4, False)
    
   precmm5@units = "mm/day"
   precmm5@long_name = "Precipitation"
   precmm5@_FillValue = -9999
   printMinMax (precmm5, False)
   lon  = fpr1->lon
   lat  = fpr1->lat
;   printVarSummary(u)
        minlat = -5;min(lat)
        maxlat=  25;max(lat)
        minlon = -25;min(lon)
        maxlon = 45;max(lon)

;;create plots;;
        wks = gsn_open_wks("x11","overlay") ; send graphics to PNG file
;       gsn_define_colormap(wks,"BkBlAqGrYeOrReViWh200")
        res                = True
        res@gsnDraw        = False
        res@gsnFrame       = False
        res@gsnAddCyclic = False
        res@gsnMaximize    = True 
        res@tmXTOn         = False
        res@tmYROn         = False
        res@gsnLeftString  = ""
        res@gsnRightString = ""
        
;;set map;;
    ;    mpres                             = res
    ;    mpres@mpDataSetName               = "Earth..4"
    ;    mpres@mpDataBaseVersion           = "MediumRes"
    ;    mpres@mpOutlineOn                 = True
     ;   mpres@mpOutlineSpecifiers         = (/"China:states","Taiwan"/)
     ;   mpres@mpGeophysicalLineThicknessF = 2
     ;   mpres@mpNationalLineThicknessF    = 2
       ; mpres@mpFillDrawOrder             = "PostDraw"
       ; mpres@mpFillOn                    = True
     ;   mpres@mpFillAreaSpecifiers        = (/"water",       "land" /)
      ;  mpres@mpSpecifiedFillColors       = (/"deepskyblue2","white"/)
;     ;  mpres@mpSpecifiedFillColors      = (/100,0/)
      ;  mpres@mpMaskAreaSpecifiers        = (/"China:states","Taiwan"/)

;;set area;;
 ;       mpres@mpMinLatF                   = minlat
 ;       mpres@mpMaxLatF                   = maxlat
 ;       mpres@mpMinLonF                   = minlon
 ;       mpres@mpMaxLonF                   = maxlon

;;set contour;;
        cnres                             = res
        ;cnres@cnFillDrawOrder             = "PreDraw"
        cnres@cnFillOn                    = True
        cnres@cnLinesOn                   = False
        cnres@pmLabelBarWidthF            = 0.2
        cnres@pmLabelBarHeightF           = 0.025
        cnres@pmLabelBarOrthogonalPosF    = 0.15
        cnres@lbLabelFontHeightF          = 0.006 
        cnres@lbLabelAngleF               = 90
        
        cnres@mpDataSetName               = "Earth..4"
        cnres@mpDataBaseVersion           = "MediumRes"
        cnres@mpOutlineOn                 = True
     ;   mpres@mpOutlineSpecifiers         = (/"China:states","Taiwan"/)
        cnres@mpGeophysicalLineThicknessF = 2
        cnres@mpNationalLineThicknessF    = 2
        cnres@mpMinLatF                   = minlat
        cnres@mpMaxLatF                   = maxlat
        cnres@mpMinLonF                   = minlon
        cnres@mpMaxLonF                   = maxlon

  
; Newer way to subset a color map
        cmap = read_colormap_file("BlAqGrWh2YeOrReVi22");"BlAqGrWh2YeOrReVi22" ;
        cnres@cnFillPalette               = cmap(::-1,:)
        cnres@cnLevelSelectionMode = "ManualLevels"        ; set manual contour levels
        cnres@cnMinLevelValF       =  -10                 ; set min contour level
        cnres@cnMaxLevelValF       =   10              ; set max contour level
        cnres@cnLevelSpacingF      =0.5                  ; set contour spacing


  
        cnres@lbLabelBarOn = False

        cnres@gsnLeftString               = "Precip"
        
;set vector;;
        res_vc                            = res
        res_vc@vcGlyphStyle               = "LineArrow"
       ; res_vc@vcLineArrowThicknessF      = 1.2
        res_vc@vcMinDistanceF             = 0.015
        res_vc@vcRefMagnitudeF            = 0.01
       res_vc@vcRefLengthF               = 0.018
      ;  res_vc@vcMinMagnitudeF            = 0.2
        ;res@vcMinFracLengthF              = 0.6
;;; map resources

        res_vc@mpDataSetName               = "Earth..4"
        res_vc@mpDataBaseVersion           = "MediumRes"
        res_vc@mpOutlineOn                 = True
        res_vc@mpGeophysicalLineThicknessF = 2
        res_vc@mpNationalLineThicknessF    = 2

;;set area;;
        res_vc@mpMinLatF                   = minlat
        res_vc@mpMaxLatF                   = maxlat
        res_vc@mpMinLonF                   = minlon
        res_vc@mpMaxLonF                   = maxlon
;;wind barb resources don't apply
;;      res_vc@vcGlyphStyle               = "WindBarb"
;;      res_vc@vcWindBarbLineThicknessF   = 2
;;      res_vc@vcWindBarbColor            = "Gray40"

         res_vc@vcRefAnnoOn               = False
      ;  res_vc@vcRefMagnitudeF           = 30
      ;  res_vc@vcRefAnnoString1          = "30"
      ;  res_vc@vcRefAnnoSide             = "Top"
      ;  res_vc@vcRefAnnoString2On        = False
      ;  res_vc@vcRefAnnoPerimOn          = False
      ;  res_vc@vcRefAnnoOrthogonalPosF   = -0.12
      ;  res_vc@vcRefAnnoParallelPosF     = 0.999
      ;  res_vc@vcRefAnnoBackgroundColor  = "Purple"
      ;  res_vc@vcVectorDrawOrder         = "PostDraw"
       res_vc@gsnRightString            = " "
       res_vc@gsnLeftString            = " "

        
;;plot;;
 ;       map1     = gsn_csm_map(wks,mpres)
 ;       contour1 = gsn_csm_contour(wks,precmm1,cnres)
 ;       vector1  = gsn_csm_vector(wks,ua1,va1,res_vc)

 ;       map2     = gsn_csm_map(wks,mpres)
 ;       contour2 = gsn_csm_contour(wks,precmm2,cnres)
 ;       vector2  = gsn_csm_vector(wks,ua2,va2,res_vc)

 ;       map3     = gsn_csm_map(wks,mpres)
 ;       contour3 =gsn_csm_contour(wks,precmm3,cnres)
 ;      vector3  = gsn_csm_vector(wks,ua3,va3,res_vc)

  ;      map4     = gsn_csm_map(wks,mpres)
  ;      contour4 = gsn_csm_contour(wks,precmm4,cnres)
 ;       vector4  = gsn_csm_vector(wks,ua4,va4,res_vc)

 ;       map5    = gsn_csm_map(wks,mpres)
 ;       contour5 = gsn_csm_contour(wks,precmm5,cnres)
 ;       vector5  = gsn_csm_vector(wks,ua5,va5,res_vc)
; plot = ;gsn_csm_contour_map(wks,pr1,res)
        plot1  = gsn_csm_contour_map(wks,pr1,cnres)
      
        plot2  = gsn_csm_contour_map(wks, pr2,cnres)

        plot3  = gsn_csm_contour_map(wks, prdf3,cnres)
      
        plot4  = gsn_csm_contour_map(wks, prdf4,cnres)
      
        plot5 = gsn_csm_contour_map(wks,  prdf5,cnres)


        vector1  = gsn_csm_vector(wks,ua1,va1, res_vc)
        vector2  = gsn_csm_vector(wks,ua2,va2, res_vc)
        vector3  = gsn_csm_vector(wks,ua3,va3, res_vc)
        vector4  = gsn_csm_vector(wks,ua4,va4, res_vc)
        vector5  = gsn_csm_vector(wks,ua5,va5, res_vc)





;;overlay filled contours and vectors on the map;;
        ;overlay(map1,contour1)
       ; overlay(plot1,vector1)

        ;overlay(map2,contour2)
       ; overlay(plot2,vector2)

       ; overlay(map3,contour3)
       ; overlay(plot3,vector3)

       ; overlay(map4,contour4)
      ;  overlay(plot4,vector4)

       ; overlay(map5,contour5)
       ; overlay(plot5,vector5)
;;add text;;
        txres                       = True
        txres@txFontHeightF         = 0.02
        txres@txFontColor           = "Purple"
        txres@txBackgroundFillColor = "White"
        txres@txFontOpacityF        = 0.8
        txres@txFontThicknessF      = 4.0
       ; dum = gsn_add_text(wks,(/contour_u/),pressure+"hPa",105,52.7,txres)



    pres                  = True
    pres@gsnMaximize      = True
    ;pres@txString         = pressure + " hPa"   ; "TRMM- " + raintotal@description + " (" + raintotal@units + ")"
    pres@gsnPanelLabelBar = True
    pres@gsnPanelRowSpec  = True
    pres@gsnPanelYWhiteSpacePercent = 0.2
    ;pres@gsnPanelXWhiteSpacePercent = 2
    pres@pmLabelBarWidthF = 0.32

   gsn_panel(wks,(/plot1,plot2,plot3,plot4,plot5/),(/2,2,2/),pres)
        




end

        
        
         
