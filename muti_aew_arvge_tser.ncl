;***************************************************************
; cpcfamine_1.ncl
;
; Concepts illustrated:
;   - Reading big endian binary files
;   - Adding geographic coordinates
;   - Explicitly setting contour levels
;
;***************************************************************
; CPC/Famine Early Warning System Daily Estimates
; Readme: ftp://ftp.cpc.ncep.noaa.gov/fews/newalgo_est/RFE_readme.txt
;***************************************************************

;*****************Load Libraries ************************************
;
; These files are loaded by default in NCL V6.2.0 and newer
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl" 
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl" 
;**************************************************************
;                     MAIN
;**************************************************************
begin
;***************************************************************
   dir                      = "./"
   files = systemfunc (" ls -1 " + dir + "concat_latlon_va850_AFR-44_CCCma-CanESM2_rcp85_r1i1p1_SMHI-RCA4_v1_day.nc")
   numfiles = dimsizes(files)
   print(files)
   print(" ")

   do it = 0,numfiles
    ; vName                      = "v"        ; name of variable on the file
     a  = addfile(files(it), "r")
     filc        = tochar( files(it) )
     name        = filc(27:)
      print(a)
      pr=a->vwind
      lat=a->lat
      lon=a->lon
      time=a->time
      ;plev=a->plev
      ;print(plev)
      ntime = dimsizes(time)
      ;print(ntime)
      utc_date = cd_calendar(time,0)
      nc_year = toint(utc_date(:,0))
      nc_month = toint(utc_date(:,1))
      nc_day = toint(utc_date(:,2))

       nc_time = sprinti("%0.4i", nc_year) + "" + sprinti("%0.2i", nc_month) + "" + sprinti("%0.2i", nc_day)
    ;  print(nc_time)
       uAve_area = dim_avg_n_Wrap(pr(:,{7.5:20},{-20:0}),(/1,2/))
      ; uAve_area_mm = uAve_area*86400
       print(uAve_area)
      printMinMax(uAve_area,False) 
       filename = "CCCma-CanESM2_rcp85_r1i1p1_SMHI-RCA4-vwind-hist.csv"
       dq = str_get_dq()
       fields = (/"nc_time", "uAve_area","plev"/)
       fields = dq + fields + dq
      header = [/str_join(fields,",")/]
      format = "%s,%4.2f"
    ;  system("rm -rf " + filename)
    ;  write_table(filename, "w", header, "%s") 
     ; write_table(filename,"w",[/nc_time,uAve_area/],"%2i,%2i")  
     ; lines = sprinti("%8d",nc_time) + "," + sprinti("%8i",uAve_area) 
     ; asciiwrite(filename,lines)
     ;write_table(filename, "w",  uAve_area(:,:), "%4.2f"i)
       alist = [/nc_time,uAve_area/]
      write_table(filename, "a", alist, format)
end do
end
