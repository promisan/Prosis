
<cfoutput>

<cf_dialogstaffing>
<cf_PresentationScript>

<script language="JavaScript">
			
	function opendate(pers,x,mth,yr,a) {		    
		ptoken.open('#session.root#/Attendance/Application/Timesheet/TimeSheet.cfm?mode=view&id=' + pers + '&caller=listing&day='+x+'&startmonth='+mth+'&startyear='+yr+'&adam='+a,'timesheet'+pers) 	
	}	
	
	function opendaterefresh(pers,x,mth,yr) {		
	    _cf_loadingtexthtml='';				    	   
	    if (document.getElementById(pers+'_'+x)) {	    	   		    
		    ColdFusion.navigate('#session.root#/Tools/TimeSheet/TimeSheetDetailCell.cfm?mode=cell&personno='+pers+'&x='+x+'&mth='+mth+'&yr='+yr,pers+'_'+x)	    			
		}   			
	}
	
	function activityrefresh(actid,org,x,mth,yr) {		   
	    _cf_loadingtexthtml='';				 			
		if (document.getElementById(actid)) {					   		
	    ColdFusion.navigate('#session.root#/Tools/TimeSheet/TimeSheetActivity.cfm?orgunit='+org+'&activityid='+actid+'&x='+x+'&month='+mth+'&year='+yr,actid)			
		}    					
	}
		
	function personrefresh(per,org,x,mth,yr) {		   
	    _cf_loadingtexthtml='';					 										   		
	    ColdFusion.navigate('#session.root#/Tools/TimeSheet/TimeSheetPerson.cfm?orgunit='+org+'&personno='+per+'&x='+x+'&month='+mth+'&year='+yr,per+'_recap')					 					
	}
	
	function timesheet(date,object,val1,val2,detail,copyScheduleFunction,removeScheduleFunction) {		       
		_cf_loadingtexthtml='';			
	    ColdFusion.navigate('#session.root#/Tools/TimeSheet/TimeSheetContent.cfm?selectiondate='+date+'&object='+object+'&objectkeyvalue1='+val1+'&objectkeyvalue2='+val2+'&detail='+detail+'&copyScheduleFunction='+copyScheduleFunction+'&removeScheduleFunction='+removeScheduleFunction,'timesheetbox')	
	}

	function copySchedule(personNo, pType, doCopy) {
		doCopy(personNo, pType);
	}

	function removeSchedule(personNo, doRemove) {
		doRemove(personNo);
	}
	
	ie = document.all?1:0
	ns4 = document.layers?1:0
	
	function hl(itm,fld,name){
			 
	     if (ie){
	          while (itm.tagName!="TD")
	          {itm=itm.parentElement;}
	     }else{
	          while (itm.tagName!="TD")
	          {itm=itm.parentNode;}
	     }	 
		 	 		 	
		 if (fld != false){		
		 	itm.className = "highLight";	 
			 self.status   = name;	 
		 }else{		
	    	 itm.className = "white";		
			 self.status   = name;
		 }
	  }

</script>

</cfoutput>