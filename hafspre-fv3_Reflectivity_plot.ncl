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

figType="x11"
isStormDomaint=True 
replace=True 
is6Hr=False 
trackOn=False 
graphicDir="./" 
stormModel="HAFS" 
;stormModel="HAFA" 
startDate=2021070612 
startTimeLevel=0 
endTimeLevel=43 
atcfFile="/scratch1/NCEPDEV/hwrf/scrub/Bantwale.Enyew/hafs_multi_nest_rt_globnest_static_test/com/2021081612/00L/natl00l.2021081612.trak.hafs.atcfunix.all" 
stormDir="/scratch1/NCEPDEV/hwrf/scrub/Bantwale.Enyew/hafsv0p2a_rehwrf/2021070612/00L/intercom/chgres"




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
domain1_dir = stormDir + "/" + "sfc_data.tile7"  ;.storm.0p015. ;006.grb2  ;   sdstr + "." + str_lower(stormModel) +  "prs.synoptic.0p03.f"

;-----------------------get domain boundary ----------------------------------

name0 = domain1_dir  +  ".nc"
grb_file_new=addfile(name0, "r")

lat=grb_file_new->geolat
lon=grb_file_new->geolon

minLat  =  min(lat)       ;12    ; min(lat) ; 7
maxLat  =  max(lat)       ;48    ; max(lat)  ; 47
minLon  =  min(lon)      ; -95
maxLon  =  max(lon)        ;-50   ; max(lon)  ; -55

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

      res1@mpGridLatSpacingF = 5.0
      res1@mpGridLonSpacingF = 5.0
      res1@tmXBTickSpacingF = 10.0
      res1@tmYLTickSpacingF = 10.0
      res1@gsnMinorLatSpacing = 5.0
      res1@gsnMinorLonSpacing = 5.0
      res1@pmLabelBarOrthogonalPosF = -0.0115
      res1@pmLabelBarHeightF  = 0.705
  
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

  ; res1@gsnLeftString = stormModel + " " + stormName + stormID 
   res1@gsnStringFontHeightF = 0.012
   res1@lbLabelFontHeightF = 0.01
   res1@tmXTOn = False
   res1@tmYROn = False
  ; res1@tiMainString = "Composite Reflectivity (dB)"

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

   res1@sfXArray         = lon(:,:)
   res1@sfYArray         = lat(:,:)

    wks = gsn_open_wks("X11", "elsa")

                   
    t2m=grb_file_new->t2m(0,:,:)
    t2m=t2m
    
  plot = gsn_csm_contour_map(wks, t2m(:,:), res1)
            




;************************************************************************************************
;-- convert the plot output from PNG to Animated GIF


  print("Converting to GIF....")

  system("convert -delay 50 NATL00L.2021070612.HAFS.*.png hwrf-core_animation.gif")
  

;************************************************************************************************


end


