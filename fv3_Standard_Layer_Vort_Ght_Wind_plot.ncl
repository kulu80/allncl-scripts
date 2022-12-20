;----------------------------------------------------------------------
;example: ncl isStormDomain=False replace=True is6Hr=True trackOn=True 'graphicDir="/your/figure/dir"' 'stormModel="HAFS"' 'stormModel="HAFA"' startDate=2019071506 startTimeLevel=0 endTimeLevel=11 'atcfFile="/hafs/com/2019071506/00L/natl00l.2019071506.trak.hafs.atcfunix.all"' 'stormDir="/hafs/com/2019071506/00L"' fv3_Standard_Layer_Vort_Ght_Wind_plot.ncl

;************************************************
; isStormDomain: plot for storm domain or whole domain
; is6Hur: make plots for every 6 forecast hour or 3 forefast hour
; replace: replace if an image is already there
; trackOn: draw or not draw tracks
; standardLayer: 850, 700, 500, 200
;************************************************

; plot every 3 or 6 Hour
if (.not. isvar("is6Hr")) then
   is6Hr=True
end if

if ( is6Hr ) then
   maxLen = 22  ;
else
   maxLen = 43  ; number of forecasts. 43 for 126 hrs, 59 for 174 hr
end if

;-------------------------------------------------------------------
loadscript("readTracks.ncl")
loadscript("validTime.ncl")
loadscript("colorPlans.ncl")

;------------------------------------------------------------------
begin
if (.not. isvar("trackOn")) then
   trackOn=True  
end if

if (.not. isvar("isStormDomain")) then
   isStormDomain=False
end if

if (.not. isvar("replace")) then
   replace=True  ; replace if the image is already there
end if

if (.not. isvar("graphicDir")) then
   graphicDir="/your/figure/dir"  ; replace if the image is already there
end if

if ( .not. isvar("standardLayer")) then
  standardLayer=850
end if

if ( .not. isvar("startTimeLevel")) then
  startTimeLevel=0
end if

if ( .not. isvar("endTimeLevel")) then
  endTimeLevel=maxLen-1
end if

print("===" + tostring(standardLayer) + "mb_Vort_Ght_Wind_plot===")

if (.not. isvar("stormModel")) then
    stormModel="HAFS"
end if

if (.not. isvar("figType")) then
   figType="png" ; x11, png, ps, pdf, ncgm, etc.
end if

if (.not. isvar("stormName")) then
   stormName="natl"
end if

if (.not. isvar("stormID")) then
   stormID="00l"
end if

;sids=systemfunc("sh getStormIDs.sh "+atcfFile )
;names=systemfunc("sh getStormNames.sh "+atcfFile + " " + tostring(startDate))
;if strlen(sids) .gt. 0 then
;   stormIDs=str_split(sids," ")
;   stormNames=str_split(names," ")
;   stormCount=dimsizes(stormIDs)
;else
;   stormIDs=(/stormID/)
;   stormNames=(/stormName/)
;   stormCount=0
;end if

stormIDs = "05L"
;if isstring(startDate) then
;    sDate=tointeger(startDate)
;    delete(startDate)
;    startDate=sDate
;end if

modelName = str_upper(stormModel)
stormID = str_upper(stormID)
stormName = str_upper(stormName)


startDate=2021070618
hour=018


;sdstr = str_lower(stormName) + str_lower(stormID) + "." + tostring(startDate)
domain1_dir = "/scratch1/NCEPDEV/hwrf/scrub/Bantwale.Enyew/hwrf-product" + "/"  + "elsa05l.2021070612.hwrfprs.synoptic.0p25.f"   ;006.grb2  ;   sdstr + "." + str_lower(stormModel) +  "prs.synoptic.0p03.f"

;---------------- get tracks ---------------------------
stormCount = 1
if stormCount .gt. 0 then
    track_xp=new((/stormCount, maxLen/), float, default_fillvalue("float"))
    track_yp=new((/stormCount, maxLen/), float, default_fillvalue("float"))
    track_w=new((/stormCount, maxLen/), float, default_fillvalue("float"))
    line1 = new(stormCount, graphic)
    markers1 = new(stormCount, graphic)
    line2 = new(stormCount, graphic)
    markers1_2 = new(stormCount, graphic)
    line3 = new(stormCount, graphic)
    markers1_3 = new(stormCount, graphic)
    markers2 = new(stormCount, graphic)
    markers3 = new(stormCount, graphic)
    texts = new(stormCount, graphic)
    texts_w1 = new(stormCount, graphic)
    texts_w2 = new(stormCount, graphic)
    texts_w3 = new(stormCount, graphic)
    texts_w4 = new(stormCount, graphic)
end if

;do i = 0, stormCount-1
;  if ( is6Hr ) then
;    track_data = getATCFTrack_6Hr_2(atcfFile,stormIDs(i))
;  else
;    track_data = getATCFTrack_2(atcfFile,stormIDs(i))
;  end if
;  track_xp(i,:)=track_data(0,:)
;  track_yp(i,:)=track_data(1,:)
;  track_w(i,:)=track_data(2,:)
;end do

;-----------------------get domain boundary ----------------------------------

;name0 = "/scratch1/NCEPDEV/hwrf/scrub/Bantwale.Enyew/hwrf-product"  +  "000.grb2"
;grb_file_new=addfile("/scratch1/NCEPDEV/hwrf/scrub/Bantwale.Enyew/hwrf-product/elsa05l.2021070612.hwrfprs.global.0p25.f090.grb2", "r")

;name0 =domain1_dir  +  "018.grb2" 
grb_file_new=addfile("/scratch1/NCEPDEV/hwrf/scrub/Bantwale.Enyew/hwrf-product/elsa05l.2021070612.hwrfprs.global.0p25.f090.grb2", "r")


lat=grb_file_new->lat_0
lon=grb_file_new->lon_0

lids=get1Dindex(grb_file_new->lv_ISBL0, standardLayer*100)
if ismissing(lids) then
   layerId = dimsizes(grb_file_new->lv_ISBL0)-1
else
   layerId = lids(0)
end if

minLat  = -12 ;min(lat)       ;12    ; min(lat) ; 7
maxLat  = 70 ;max(lat)       ;48    ; max(lat)  ; 47
minLon  = -140 ;min(lon)      ; -95
maxLon  = -10 ;max(lon)        ;-50   ; max(lon)  ; -55

list_vars()
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
   res1@gsnAddCyclic = False

   res1@lbOrientation            = "Vertical"     ; vertical label bar
   res1@cnLevelSelectionMode = "ExplicitLevels" ;"ManualLevels"  ;"ExplicitLevels"
   res1@cnLevels = ispan(10,18,1)   ;ispan(4,18,2) ; (/10, 20, 34, 50, 64, 83, 96, 113, 137/)     ;(/20, 34, 64, 83, 96, 113, 137/)     ;ispan(0,64,4) ;(/5, 7.5, 10, 12.5, 15, 17.5, 20, 25, 30, 40, 45, 50/)
 
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

   if isStormDomain then
      res1@mpGridLatSpacingF = 1.0
      res1@mpGridLonSpacingF = 1.0
      res1@tmXBTickSpacingF = 1.0
      res1@tmYLTickSpacingF = 1.0
      res1@gsnMinorLatSpacing = 1.0
      res1@gsnMinorLonSpacing = 1.0
      res1@pmLabelBarOrthogonalPosF = -0.0114
      res1@pmLabelBarHeightF  = 0.705
   else
      res1@mpGridLatSpacingF = 5.0
      res1@mpGridLonSpacingF = 5.0
      res1@tmXBTickSpacingF = 10.0
      res1@tmYLTickSpacingF = 10.0
      res1@gsnMinorLatSpacing = 5.0
      res1@gsnMinorLonSpacing = 5.0
      res1@pmLabelBarOrthogonalPosF = -0.0139 ; move laber bar further away
      res1@pmLabelBarHeightF  = 0.71*(maxLat-minLat)/(maxLon-minLon) ;0.515 for HAFC
  end if

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

   res1@gsnLeftString = stormModel + " " + stormName + stormID 
   res1@gsnStringFontHeightF = 0.012
   res1@lbLabelFontHeightF = 0.01
   res1@tmXTOn = False
   res1@tmYROn = False
   res1@tiMainString = tostring(standardLayer)+ "hPa Vorticity(10~S~-5~N~/s), Geo. Height (x10m), and Wind (kt)"

   res1@gsnLeftStringOrthogonalPosF = 0.006
   res1@gsnRightStringOrthogonalPosF = 0.006

   res1@tiMainFont = 21
   res1@tiMainFontHeightF = 0.013
   res1@tmXBMajorLengthF=0.008
   res1@tmXBMinorLengthF=0.004
   res1@tmYLMajorLengthF=0.008
   res1@tmYLMinorLengthF=0.004

   res1@mpMinLatF   = minLat  ;12    ; min(lat) ; 7
   res1@mpMaxLatF   = maxLat  ;48    ; max(lat)  ; 47
   res1@mpMinLonF   = minLon  ;-86   ; min(lon)   ; -95
   res1@mpMaxLonF   = maxLon  ;-50   ; max(lon)  ; -55

   res1@sfXArray         = lon(:)
   res1@sfYArray         = lat(:)

;------------- res2 ------------
   res2 = True
   res2@cnLevelSelectionMode = "ExplicitLevels" ;"ManualLevels"  ;"ExplicitLevels"

   if standardLayer .eq. 850 then
     res2@cnLevels = ispan(100,200,2) ;(/5, 7.5, 10, 12.5, 15, 17.5, 20, 25, 30, 40, 45, 50/)
   else if standardLayer .eq. 500 then
     res2@cnLevels = ispan(400,700,2)   
   else if standardLayer .eq. 200 then
     res2@cnLevels = ispan(1000,1400,2)
   else
     res2@cnLevels = ispan(2000,100,2)
   end if
   end if
   end if

   if .not. isStormDomain then
      res2@cnSmoothingOn = True
      res2@cnSmoothingDistanceF = 0.005
   end if   
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

   res2@sfXArray         = lon(:)
   res2@sfYArray         = lat(:)

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

   vres@vfXArray         = lon(:)
   vres@vfYArray         = lat(:)
;------------------------------------------------------
   pres                  = True               ; polyline resources
   pres@gsLineColor      = "black"
   if isStormDomain then
      pres@gsLineThicknessF = 6.0                ; line thickness
   else
      pres@gsLineThicknessF = 3.75
   end if

   mres                = True         ; marker resources for best track
   mres@gsMarkerIndex  = 16           ; marker style (filled circle)
   mres@gsMarkerSizeF  = 9.0          ; marker size
   mres@gsMarkerColor  = "black"      ; maker color

   txres               = True
   txres@txFontHeightF = 0.012             ; Set the font height
   txres@txJust = "TopLeft"
   txres@txFont = 22 ; helvetica bold
 
   format = "%Y%N%D%H"    ; "%Y (%HH)", "%d %c

;   if startTimeLevel .lt. 0 then
;     startTimeLevel = 0
;   end if
;   if endTimeLevel .gt. maxLen-1 then
;     endTimeLevel=maxLen-1
;   end if

 ;  do ifil = startTimeLevel, endTimeLevel
 ;     if ( is6Hr ) then
 ;         hour = sprinti("%0.3i",ifil*6)
 ;     else  ; 3hr
 ;         hour = sprinti("%0.3i",ifil*3)
 ;     end if

startDate=2021070618
hour=018
            wks1 = gsn_open_wks("X11", "elsa")
            ;wks = gsn_open_wks("png", "elsa")
            ;figName = figName +  "." + figType
            hrind = NhlNewMarker(wks1, "p", 37, 0.0, 0.0, 1.0, 1.0, 0.0)

            ;name0 = domain1_dir  +  hour + ".grb2"
           ; valid = validtime(startDate, tointeger(hour), format)
            ;res1@gsnRightString = "Init: " + tostring(startDate) + "Z, F" + hour  + ", Valid: " + valid + "Z"

            ;grb_file_new=addfile(name0, "r")

            ;names = getfilevarnames(grb_file_new)  ; Get the variable names in the
            ;print(names)

            u = grb_file_new->UGRD_P0_L100_GLL0(layerId,:,:)*1.94384  ;UGRD_P0_L100_GLL0
            v = grb_file_new->VGRD_P0_L100_GLL0(layerId,:,:)*1.94384   ;VGRD_P0_L100_GLL0
            H = grb_file_new->HGT_P0_L100_GLL0(layerId,:,:)/10.0
            RV =grb_file_new->ABSV_P0_L100_GLL0(layerId,:,:)*100000  ;uv2vr_cfd (u, v, lat, lon, 0)*100000 
            RV=smth9(RV, 0.50, 0.25, False)
            RV=smth9(RV, 0.50, 0.25, False)
            RV=smth9(RV, 0.50, 0.25, False)
            RV=smth9(RV, 0.50, 0.25, False)
            RV=smth9(RV, 0.50, 0.25, False)
            RV=smth9(RV, 0.50, 0.25, False)
            RV=smth9(RV, 0.50, 0.25, False)
            RV=smth9(RV, 0.50, 0.25, False)
            RV=smth9(RV, 0.50, 0.25, False)
            RV=smth9(RV, 0.50, 0.25, False)

            plotV = gsn_csm_vector(wks1,u, v, vres)
            plot = gsn_csm_contour_map(wks1, RV, res1)
            plot1 = gsn_csm_contour(wks1, H ,res2)

            overlay(plot,plot1)
            overlay(plot,plotV)
           
           draw(plot)
           frame(wks1)
           
            wks2 = gsn_open_wks("x11", "elsa-windv")

            
             
     ;************************************************
; create plot
;************************************************
   res3                      = True               ; plot mods desired
   res3@cnFillOn             = True               ; turn on color for contours
   res3@cnLinesOn            = False              ; turn off contour lines
   res3@cnLineLabelsOn       = False              ; turn off contour line labels
   res3@gsnSpreadColors      = True               ; use full color map
   res3@cnFillColors = getColorMap("reflectivity")
   res3@cnFillMode = "RasterFill"
   res3@cnRasterSmoothingOn = True
   res3@gsnMaximize           = True         ; enlarge plo

   res3@cnConstFEnableFill = True
   res3@cnConstFLabelOn    =  False          ; Turn off the "constant field" label in the middle of the plot
   res3@gsnAddCyclic = False

   res3@lbOrientation            = "Vertical"     ; vertical label bar
   res3@cnLevelSelectionMode ="ExplicitLevels" ;"ManualLevels"  ;"ExplicitLevels"
   res3@cnLevels =  ispan(5,70,5) ; (/10, 20, 34, 50, 64, 83, 96, 113, 137/);(/20, 34, 64, 83, 96, 113, 137/);ispan(0,64,4) ;(/5, 7.5, 10, 12.5, 15, 17.5, 20, 25, 30, 40, 45, 50/)

   res3@pmLabelBarWidthF = 0.05
   res3@pmLabelBarOrthogonalPosF = -0.011 ; move laber bar further away
   res3@pmLabelBarHeightF  = 0.71*(maxLat-minLat)/(maxLon-minLon)

   res3@gsnDraw          = False                    ; turn off draw and frame
   res3@gsnFrame         = False                    ; b/c this is an overlay plot
   res3@vpWidthF         = 0.7
   res3@vpHeightF         = 0.7
   res3@vpXF = 0.15
   res3@vpYF = 0.85
   res3@cnInfoLabelOn = False

   if isStormDomain then
      res3@mpGridLatSpacingF = 1.0
      res3@mpGridLonSpacingF = 1.0
      res3@tmXBTickSpacingF = 1.0
      res3@tmYLTickSpacingF = 1.0
      res3@gsnMinorLatSpacing = 1.0
      res3@gsnMinorLonSpacing = 1.0
      res3@pmLabelBarOrthogonalPosF = -0.0115
      res3@pmLabelBarHeightF  = 0.705
   else
      res3@mpGridLatSpacingF = 5.0
      res3@mpGridLonSpacingF = 5.0
      res3@tmXBTickSpacingF = 10.0
      res3@tmYLTickSpacingF = 10.0
      res3@gsnMinorLatSpacing = 5.0
      res3@gsnMinorLonSpacing = 5.0
      res3@pmLabelBarOrthogonalPosF = -0.0116 ; move laber bar further away
      res3@pmLabelBarHeightF  = 0.71*(maxLat-minLat)/(maxLon-minLon) ;0.515 for HAFC
   end if


    res3@mpDataBaseVersion      = "MediumRes"    ; better map outlines
   res3@mpDataSetName          = "Earth..2"
   res3@mpOutlineBoundarySets  = "GeophysicalAndUSStates"
   res3@mpGeophysicalLineThicknessF = 1.5
   res3@mpUSStateLineThicknessF = 1.5
   res3@mpFillOn = False

   res3@mpGridAndLimbOn = True
   res3@mpGridLineColor = "gray30"
   res3@mpGridLineDashPattern = 2

   res3@tmXBLabelFontHeightF = 0.01
   res3@tmYLLabelFontHeightF = 0.01

   res3@gsnLeftString = stormModel + " " + stormName + stormID
   res3@gsnStringFontHeightF = 0.012
   res3@lbLabelFontHeightF = 0.01
   res3@tmXTOn = False
   res3@tmYROn = False
   res3@tiMainString = "Composite Reflectivity (dB)"

   res3@gsnLeftStringOrthogonalPosF = 0.006
   res3@gsnRightStringOrthogonalPosF = 0.006

   res3@tiMainFont = 21
   res3@tiMainFontHeightF = 0.013
   res3@tmXBMajorLengthF=0.008
   res3@tmXBMinorLengthF=0.004
   res3@tmYLMajorLengthF=0.008
   res3@tmYLMinorLengthF=0.004

   res3@mpMinLatF   = minLat  ;12    ; min(lat) ; 7
   res3@mpMaxLatF   = maxLat  ;48    ; max(lat)  ; 47
   res3@mpMinLonF   = minLon  ;-86   ; min(lon)   ; -95
   res3@mpMaxLonF   = maxLon  ;-50   ; max(lon)  ; -55

   res3@sfXArray         = lon(:)
   res3@sfYArray         = lat(:)


  hrind = NhlNewMarker(wks2, "p", 37, 0.0, 0.0, 1.0, 1.0, 0.0)
           
  Ref=grb_file_new->REFC_P0_L200_GLL0
  plot4 = gsn_csm_contour_map(wks2, Ref, res3)

          draw(plot4)
           frame(wks2)
 
end

