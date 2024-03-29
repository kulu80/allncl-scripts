;----------------------------------------------------------------------
;example: ncl isStormDomain=False replace=True is6Hr=True trackOn=True 'graphicDir="/your/figure/dir"' 'stormModel="HAFS"' 'stormModel="HAFA"' startDate=2019071506 startTimeLevel=0 endTimeLevel=11 'atcfFile="/hafs/com/2019071506/00L/natl00l.2019071506.trak.hafs.atcfunix.all"' 'stormDir="/hafs/com/2019071506/00L"' fv3_Reflectivity_plot.ncl

; isStormDomain: plot for storm domain or whole domain
; is6Hur: make plots for every 6 forecast hour or 3 forefast hour
; replace: replace if an image is already there
; track: draw or not draw tracks

;************************************************
; plot every 3 or 6 Hour

;**************************************************************

;Declaring some string varieable to run manually

;******************************************************************************************

figType="X11"
;figType="png"
isStormDomaint=True 
replace=True 
is6Hr=True 
trackOn=True 
graphicDir="./" 
stormModel="HAFS" 
;stormModel="HAFA" 
startDate=2021082712
startTimeLevel=0 
endTimeLevel=11 
atcfFile="/scratch1/NCEPDEV/hwrf/scrub/Bantwale.Enyew/hafs_202211_v1a_baseline_viirs_2cyl/com/2020082518/13L/13l.2020082518.hafs.trak.atcfunix.all" 
stormDir="/scratch1/NCEPDEV/hwrf/scrub/Bantwale.Enyew/hafs_202211_v1a_baseline_viirs_2cyl/com/2020082518/13L"




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
print("===Reflectivity_plot===")
;---------------- init ---------------------------
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

if ( .not. isvar("startTimeLevel")) then
  startTimeLevel=0
end if

if ( .not. isvar("endTimeLevel")) then
  endTimeLevel=maxLen-1
end if

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

sids=systemfunc("sh getStormIDs.sh "+atcfFile )
names=systemfunc("sh getStormNames.sh "+atcfFile + " " + tostring(startDate))
if strlen(sids) .gt. 0 then
   stormIDs=str_split(sids," ")
   stormNames=str_split(names," ")
   stormCount=dimsizes(stormIDs)
else
   stormIDs=(/stormID/)
   stormNames=(/stormName/)
   stormCount=0
end if

if isstring(startDate) then
    sDate=tointeger(startDate)
    delete(startDate)
    startDate=sDate
end if

modelName = str_upper(stormModel)
stormID = str_upper(stormID)
stormName = str_upper(stormName)

sdstr = str_lower(stormName) + str_lower(stormID) + "." + tostring(startDate)
domain1_dir = stormDir + "/" + "13l.2020082518.hafs.grid02.f"   ;006.grb2  ;   sdstr + "." + str_lower(stormModel) +  "prs.synoptic.0p03.f"

;-----------------------get domain boundary ----------------------------------

name0 = domain1_dir  +  "000.grb2"
grb_file_new=addfile(name0, "r")

lat=grb_file_new->lat_0
lon=grb_file_new->lon_0

minLat  =  min(lat)       ;12    ; min(lat) ; 7
maxLat  =  max(lat)       ;48    ; max(lat)  ; 47
minLon  =  min(lon)      ; -95
maxLon  =  max(lon)        ;-50   ; max(lon)  ; -55

printMinMax(lon,0)
printMinMax(lat,0)
;----------------------------get tracks -----------------------------------
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

do i = 0, stormCount-1
  if ( is6Hr ) then
    track_data = getATCFTrack_6Hr_2(atcfFile,stormIDs(i))
  else
    track_data = getATCFTrack_2(atcfFile,stormIDs(i))
  end if
  track_xp(i,:)=track_data(0,:)
  track_yp(i,:)=track_data(1,:)
  track_w(i,:)=track_data(2,:)
end do

;------------------------------------------------------

;************************************************
; create plot
;************************************************
   res1                      = True               ; plot mods desired
   res1@cnFillOn             = True               ; turn on color for contours
   res1@cnLinesOn            = False              ; turn off contour lines
   res1@cnLineLabelsOn       = False              ; turn off contour line labels
   res1@gsnSpreadColors      = True               ; use full color map
   res1@cnFillColors = getColorMap("reflectivity")
   res1@cnFillMode = "RasterFill"
   res1@cnRasterSmoothingOn = True
   res1@gsnMaximize           = True         ; enlarge plo

   res1@cnConstFEnableFill = True
   res1@cnConstFLabelOn    =  False          ; Turn off the "constant field" label in the middle of the plot
   res1@gsnAddCyclic = False

   res1@lbOrientation            = "Vertical"     ; vertical label bar
   res1@cnLevelSelectionMode = "ExplicitLevels" ;"ManualLevels"  ;"ExplicitLevels"
   res1@cnLevels =  ispan(5,70,5) ; (/10, 20, 34, 50, 64, 83, 96, 113, 137/)     ;(/20, 34, 64, 83, 96, 113, 137/)     ;ispan(0,64,4) ;(/5, 7.5, 10, 12.5, 15, 17.5, 20, 25, 30, 40, 45, 50/)

   res1@pmLabelBarWidthF = 0.05
   res1@pmLabelBarOrthogonalPosF = -0.011 ; move laber bar further away
   res1@pmLabelBarHeightF  = 0.71*(maxLat-minLat)/(maxLon-minLon)

   res1@gsnDraw          = False                    ; turn off draw and frame
   res1@gsnFrame         = False                    ; b/c this is an overlay plot
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
      res1@pmLabelBarOrthogonalPosF = -0.0115
      res1@pmLabelBarHeightF  = 0.705
   else
      res1@mpGridLatSpacingF = 5.0
      res1@mpGridLonSpacingF = 5.0
      res1@tmXBTickSpacingF = 10.0
      res1@tmYLTickSpacingF = 10.0
      res1@gsnMinorLatSpacing = 5.0
      res1@gsnMinorLonSpacing = 5.0
      res1@pmLabelBarOrthogonalPosF = -0.0116 ; move laber bar further away
      res1@pmLabelBarHeightF  = 0.71*(maxLat-minLat)/(maxLon-minLon) ;0.515 for HAFC
   end if

   res1@mpDataBaseVersion      = "MediumRes"    ; better map outlines
   res1@mpDataSetName          = "Earth..2"
   res1@mpOutlineBoundarySets  = "GeophysicalAndUSStates"
   res1@mpGeophysicalLineThicknessF = 1.5	
   res1@mpUSStateLineThicknessF = 1.5
   res1@mpFillOn = False

   res1@mpGridAndLimbOn = True
   res1@mpGridLineColor = "gray30"
   res1@mpGridLineDashPattern = 2 

   res1@tmXBLabelFontHeightF = 0.01
   res1@tmYLLabelFontHeightF = 0.01

   res1@gsnLeftString = stormModel + " " + stormName + stormID 
   res1@gsnStringFontHeightF = 0.012
   res1@lbLabelFontHeightF = 0.01
   res1@tmXTOn = False
   res1@tmYROn = False
   res1@tiMainString = "Composite Reflectivity (dB)"

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

;;;-------------pres/mres-----------;;;

   pres                  = True               ; polyline resources
   pres@gsLineColor      = "black"
   if isStormDomain then
      pres@gsLineThicknessF = 6.0                ; line thickness
   else
     pres@gsLineThicknessF = 3.75
   end if
 
   mres                = True         ; marker resources for best track
   ;mres@gsMarkerIndex  = 16           ; marker style (filled circle)
   mres@gsMarkerColor  = "black"      ; maker color
   txres               = True
   txres@txFontHeightF = 0.012             ; Set the font height
   txres@txJust = "TopLeft"
   txres@txFont = 22 ; helvetica bold
 
   format = "%Y%N%D%H"    ; "%Y (%HH)", "%d %c

   if startTimeLevel .lt. 0 then
      startTimeLevel = 0
   end if
   if endTimeLevel .gt. maxLen-1 then
      endTimeLevel=maxLen-1
   end if

   do ifil = startTimeLevel, endTimeLevel
      ;do ifil = 0,maxLen-1

      if ( is6Hr ) then
         hour = sprinti("%0.3i",ifil*6)
      else  ; 3hr
         hour = sprinti("%0.3i",ifil*3)
      end if

      if (.not. isStormDomain) then
         figName = stormName + stormID + "." + tostring(startDate) + "." +  modelName + ".reflectivity.f" + hour
         if replace .or. ( .not. (fileexists( graphicDir + "/" + figName + "." + figType )) ) then
            print(ifil)
            wks = gsn_open_wks(figType, figName )
            figName = figName +  "." + figType
            hrind = NhlNewMarker(wks, "p", 37, 0.0, 0.0, 1.0, 1.0, 0.0)
            name0 = domain1_dir  +  hour + ".grb2"
            valid = validtime(startDate, tointeger(hour), format)
            res1@gsnRightString = "Init: " + tostring(startDate) + "Z, F" + hour  + ", Valid: " + valid + "Z"
            grb_file_new=addfile(name0, "r")
            Ref=grb_file_new->REFC_P0_L200_GLL0
            plot = gsn_csm_contour_map(wks, Ref, res1)
            if trackOn then  
		 do i = 0, stormCount-1
                     mres@gsMarkerSizeF = 5.0
                     mres@gsMarkerIndex = 16
                     mres@gsMarkerThicknessF = 1.0

                     mres@gsMarkerColor = "gray98"
                     pres@gsLineColor = "gray98"
                     line2(i) = gsn_add_polyline(wks,plot, track_xp(i,:)+0.14, track_yp(i,:)-0.14,pres)            ; draw the traj
                     markers1_2(i) = gsn_add_polymarker(wks,plot,track_xp(i,:)+0.14,track_yp(i,:)-0.14,mres)
                     line3(i) = gsn_add_polyline(wks,plot, track_xp(i,:)-0.14, track_yp(i,:)+0.14,pres)            ; draw the traj
                     markers1_3(i) = gsn_add_polymarker(wks,plot,track_xp(i,:)-0.14,track_yp(i,:)+0.14,mres)

                     mres@gsMarkerColor = "Black"
                     pres@gsLineColor = "black"
                     line1(i) = gsn_add_polyline(wks,plot,track_xp(i,:),track_yp(i,:),pres)      ; draw the traj
                     markers1(i) = gsn_add_polymarker(wks,plot,track_xp(i,:),track_yp(i,:),mres)
                     mres@gsMarkerSizeF = 11.0          ; marker size
                     mres@gsMarkerIndex = hrind
                     mres@gsMarkerColor = "black"
                     mres@gsMarkerThicknessF = 5.0

                     markers2(i) = gsn_add_polymarker(wks,plot,track_xp(i,ifil),track_yp(i,ifil),mres)
                     mres@gsMarkerSizeF = 10.0          ; marker size
                     mres@gsMarkerColor = "red"
                     mres@gsMarkerThicknessF = 2.0
                     markers3(i) = gsn_add_polymarker(wks,plot,track_xp(i,ifil),track_yp(i,ifil),mres)
                     txres@txFontColor = "black"
                     texts(i) = gsn_add_text(wks,plot,stormNames(i), track_xp(i,ifil)+0.68, track_yp(i,ifil)-0.68, txres)
                     txres@txFontColor = "gray98"
                     texts_w1(i) = gsn_add_text(wks,plot,stormNames(i), track_xp(i,ifil)+0.82, track_yp(i,ifil)-0.82, txres)
                     texts_w2(i) = gsn_add_text(wks,plot,stormNames(i), track_xp(i,ifil)+0.54, track_yp(i,ifil)-0.54, txres)
                     texts_w3(i) = gsn_add_text(wks,plot,stormNames(i), track_xp(i,ifil)+0.82, track_yp(i,ifil)-0.54, txres)
                     texts_w4(i) = gsn_add_text(wks,plot,stormNames(i), track_xp(i,ifil)+0.54, track_yp(i,ifil)-0.82, txres)
                 end do
            end if
            draw(plot)
            frame(wks)
            ;system("convert -crop 985x630+18+194 " + figName + " " + figName)
            system("convert -trim " + figName + " " + figName)
         end if
      else
         do i = 0, stormCount-1
            figName = stormNames(i) + "." + tostring(startDate) + "." +  modelName +  ".storm.reflectivity.f" + hour
            if .not. ismissing(track_xp(i,ifil)) .and. ( replace .or. ( .not. (fileexists( graphicDir + "/" + figName + "." + figType )) ) ) then
               print(ifil)
               wks = gsn_open_wks(figType,  figName)
               figName = figName +  "." + figType

               hrind = NhlNewMarker(wks, "p", 37, 0.0, 0.0, 1.0, 1.0, 0.0)
               name0 = domain1_dir  +  hour + ".grb2"

               valid = validtime(startDate, tointeger(hour), format)
               res1@gsnLeftString = stormModel + " " + stormNames(i)
               res1@gsnRightString = "Init: " + tostring(startDate) + "Z, F" + hour  + ", Valid: " + valid + "Z"

               res1@mpMinLatF = track_yp(i,ifil) -3.5
               res1@mpMaxLatF = track_yp(i,ifil) +3.5
               res1@mpMinLonF = track_xp(i,ifil) -3.5
               res1@mpMaxLonF = track_xp(i,ifil) +3.5

               grb_file_new=addfile(name0, "r")

               Ref=grb_file_new->REFC_P0_L200_GLL0
               plot = gsn_csm_contour_map(wks, Ref, res1)
               if trackOn then
		       mres@gsMarkerSizeF = 10.0
		       mres@gsMarkerIndex = 16
		       mres@gsMarkerThicknessF = 1.0
		       mres@gsMarkerColor = "white"
		       pres@gsLineColor = "white"

		       mres@gsMarkerColor = "Black"
		       pres@gsLineColor = "black"
		       line1(i) = gsn_add_polyline(wks,plot,track_xp(i,:),track_yp(i,:),pres)      ; draw the traj
		       markers1(i) = gsn_add_polymarker(wks,plot,track_xp(i,:),track_yp(i,:),mres)

		       mres@gsMarkerSizeF = 18.0          ; marker size
		       mres@gsMarkerIndex = hrind
		       mres@gsMarkerColor = "black"
		       mres@gsMarkerThicknessF = 10.0

		       markers2(i) = gsn_add_polymarker(wks,plot,track_xp(i,ifil),track_yp(i,ifil),mres)
		       mres@gsMarkerSizeF = 18.0          ; marker size
		       mres@gsMarkerColor = "red"
	   
		       mres@gsMarkerSizeF = 18.0          ; marker size
		       mres@gsMarkerIndex = hrind
		       mres@gsMarkerColor = "black"
		       mres@gsMarkerThicknessF = 10.0

		       markers2(i) = gsn_add_polymarker(wks,plot,track_xp(i,ifil),track_yp(i,ifil),mres)
		       mres@gsMarkerSizeF = 18.0          ; marker size
		       mres@gsMarkerColor = "red"
		       mres@gsMarkerThicknessF = 4.0
		       markers3(i) = gsn_add_polymarker(wks,plot,track_xp(i,ifil),track_yp(i,ifil),mres)
               end if
               draw(plot)
               frame(wks)

               ;system("convert -crop 985x985+18+18 " + figName + " " + figName)
               system("convert -trim " + figName + " " + figName)
           end if
       end do
   end if

end do


;************************************************************************************************
;-- convert the plot output from PNG to Animated GIF


  print("Converting to GIF....")

  system("convert -delay 50 NATL00L.2021*.png ida-snyoptic_animation.gif")


;************************************************************************************************


print("end")

end


