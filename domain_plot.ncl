;----------------------------------------------------------------------
;example: ncl isStormDomain=False replace=True is6Hr=True trackOn=True 'graphicDir="/your/figure/dir"' 'stormModel="HAFS"' 'stormModel="HAFA"' startDate=2019071506 startTimeLevel=0 endTimeLevel=11 'atcfFile="/hafs/com/2019071506/00L/natl00l.2019071506.trak.hafs.atcfunix.all"' 'stormDir="/hafs/com/2019071506/00L"' fv3_Standard_Layer_Vort_Ght_Wind_plot.ncl

;************************************************
; isStormDomain: plot for storm domain or whole domain
; is6Hur: make plots for every 6 forecast hour or 3 forefast hour
; replace: replace if an image is already there
; trackOn: draw or not draw tracks
; standardLayer: 850, 700, 500, 200
;************************************************


;-------------------------------------------------------------------
loadscript("readTracks.ncl")
loadscript("validTime.ncl")
loadscript("colorPlans.ncl")

;------------------------------------------------------------------
begin

grb_file_new=addfile("/scratch1/NCEPDEV/hwrf/scrub/Bantwale.Enyew/hafsv0p2a_hwrfdom/2021070612/00L/intercom/chgres/sfc_data.tile7.nc", "r")


lat=grb_file_new->geolat
lon=grb_file_new->geolon


minLat  = min(lat)       ;12    ; min(lat) ; 7
maxLat  = max(lat)       ;48    ; max(lat)  ; 47
minLon  = min(lon)      ; -95
maxLon  = max(lon)        ;-50   ; max(lon)  ; -55
printMinMax(lat, 0)
printMinMax(lon, 0)

;************************************************
; create plot
;************************************************
     
;-------res1---------
   res1                      = True               ; plot mods desired
   res1@cnFillOn             = True               ; turn on color for contours
   res1@cnLinesOn            = False              ; turn off contour lines
   res1@cnLineLabelsOn       = False              ; turn off contour line labels
   ;cmap = read_colormap_file("wh-bl-gr-ye-re")
   ;cmap(0,:)= (/0.0,0,0,0/)
   res1@cnFillPalette = getColorMap("vorticity")
   res1@cnFillMode = "RasterFill"
   res1@cnRasterSmoothingOn = True 
   res1@cnSpanFillPalette = True
   res1@cnFillOpacityF = 0.75

   res1@gsnMaximize           = True         ; enlarge plo

   res1@cnConstFEnableFill = True
   res1@cnConstFLabelOn    =  False          ; Turn off the "constant field" label in the middle of the plot
  ; res1@gsnAddCyclic = False

   res1@lbOrientation            = "Vertical"     ; vertical label bar
   res1@cnLevelSelectionMode = "ExplicitLevels" ;"ManualLevels"  ;"ExplicitLevels"
   res1@cnLevels = ispan(10,18,1)   ;ispan(4,18,2) ; (/10, 20, 34, 50, 64, 83, 96, 113, 137/)     ;(/20, 34, 64, 83, 96, 113, 137/)   
   res1@pmLabelBarWidthF = 0.05

   res1@gsnDraw          = False                    ; turn off draw and frame
   res1@gsnFrame         = False                    ; b/c this is an overlay plot
   res1@cnFillDrawOrder   = "Draw"  ; draw contours first
   res1@mpOutlineDrawOrder = "Postdraw"
   res1@vpWidthF         = 0.7
   res1@vpHeightF         = 0.7
   res1@vpXF = 0.15
   res1@vpYF = 0.85
   res1@cnInfoLabelOn = False
   res1@mpDataBaseVersion      = "MediumRes"    ; better map outlines
   res1@mpDataSetName          = "Earth..2"
   res1@mpOutlineBoundarySets  = "GeophysicalAndUSStates"
   ;;res1@mpGeophysicalLineColor="gray50" 

   res1@mpGeophysicalLineThicknessF = 2.0 ;1.5
   res1@mpUSStateLineThicknessF = 2.0 ;1.5

   ;;res1@mpUSStateLineColor="gray50"

   res1@mpFillOn = False
   res1@mpGridAndLimbOn = True
   res1@mpGridLineColor = "gray40"
   res1@mpGridLineDashPattern = 2

   res1@tmXBMinorOn = True
   res1@tmYLMinorOn = True

   res1@tmXBMinorPerMajor = 2
   res1@tmYLMinorPerMajor = 2
   res1@tmXBLabelFontHeightF = 0.01
   res1@tmYLLabelFontHeightF = 0.01

   ;res1@gsnLeftString = stormModel + " " + stormName + stormID 
   res1@gsnStringFontHeightF = 0.012
   res1@lbLabelFontHeightF = 0.01
   res1@tmXTOn = False
   res1@tmYROn = False
  ; res1@tiMainString = tostring(standardLayer)+ "hPa Vorticity(10~S~-5~N~/s), Geo. Height (x10m), and Wind (kt)"

   res1@gsnLeftStringOrthogonalPosF = 0.006
   res1@gsnRightStringOrthogonalPosF = 0.006

   res1@tiMainFont = 21
   res1@tiMainFontHeightF = 0.013
   res1@tmXBMajorLengthF=0.008
   res1@tmXBMinorLengthF=0.004
   res1@tmYLMajorLengthF=0.008
   res1@tmYLMinorLengthF=0.004

   res1@mpMinLatF   = -15 ;minLat  ;12    ; min(lat) ; 7
   res1@mpMaxLatF   = 70  ;maxLat  ;48    ; max(lat)  ; 47
   res1@mpMinLonF   = -135 ;minLon  ;-86   ; min(lon)   ; -95
   res1@mpMaxLonF   = -15 ;maxLon  ;-50   ; max(lon)  ; -55

   ;res1@sfXArray         = lon(:)
   ;res1@sfYArray         = lat(:)

;------------- res2 ------------
   res2 = True
   res2@cnLevelSelectionMode = "ExplicitLevels" ;"ManualLevels"  
   ;wks = gsn_open_wks("x11","color")
   ;cmap = (/(/1.00, 1.00, 1.00, 0.1/)/)
   ;gsn_define_colormap(wks,cmap)

   res2@cnFillOn             = False               ; turn on color for contours
   res2@cnLinesOn            = True              ; turn off contour lines
   res2@cnLineLabelsOn       = True              ; turn off contour line labels
   ;res2@cnLineLabelPlacementMode = "computed"  ; "constant" often not work, computed
   res2@cnLineLabelDensityF = 3.0 ; does not work if cnLineLabelPlacementMode = "constant"
   res2@cnLineLabelFontHeightF = 0.006
   res2@cnLineLabelFont  = "helvetica-bold"
   ;res2@cnLineLabelBackgroundColor = "transparent"  ;;comment out to get solid font backgroup
   ;res2@cnLabelMasking             = True  ;;

   res2@cnLineColor = "black"
   res2@cnLineThicknessF = 2.5 ; 1.75
   res2@gsnDraw          = False                    ; turn off draw and frame
   res2@gsnFrame         = False
   res2@cnInfoLabelOn = False
   res2@gsnLeftString = ""
   res2@gsnRightString = ""

   ;res2@sfXArray         = lon(:)
   ;res2@sfYArray         = lat(:)

;;;------------- vres-----------;;;

   vres = True
   vres@vcRefMagnitudeF           = 15.0             ; define vector ref mag
   vres@vcRefLengthF              = 0.016 ;0.018          ; define length of vec ref
   vres@vcRefAnnoOn   = False         ; change ref vector color
   vres@vcMinDistanceF          = 0.018 ;0.0225 ;0.01 ;0.015
   ;vres@vcLineArrowColor        = "blue"   ;"deeppink1"           ; change vector color

   vres@vcWindBarbColor   = "gray20" ;"black" ; "royalblue1"
   vres@vcWindBarbLineThicknessF   = 1.5 ;25               ; change vector thickness
   vres@gsnAddCyclic = True
   vres@gsnDraw          = False                    ; turn off draw and frame
   vres@gsnFrame         = False                    ; b/c this is an overlay plot
   vres@vcGlyphStyle     = "WindBarb"         ; select wind barbs
   vres@vcVectorDrawOrder = "Postdraw"
   vres@vcPositionMode = "ArrowHead"

   vres@gsnLeftString = ""
   vres@gsnRightString = ""

   ;vres@vfXArray         = lon(:)
   ;vres@vfYArray         = lat(:)
;------------------------------------------------------
    
  

    wks1 = gsn_open_wks("X11", "elsa")
    veg = grb_file_new->t2m(0,:,:)
    printVarSummary(veg) 
    ;plotV = gsn_csm_vector(wks1,u, v, vres)
    plot = gsn_csm_contour_map(wks1, veg, res1)
    ;plot1 = gsn_csm_contour(wks1, H ,res2)
    ;overlay(plot,plot1)
    ;overlay(plot,plotV)
           
     draw(plot)
     frame(wks1)
           
     
 
end

