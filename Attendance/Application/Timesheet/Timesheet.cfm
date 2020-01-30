<cfparam name="url.scope" default="Backoffice">

<cfif url.scope neq "Backoffice">
	 <cfset url.id = CLIENT.personno>
</cfif>

 <cfquery name="Employee" 
    datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
          SELECT *
          FROM   Person
          WHERE  PersonNo = '#URL.ID#'
   </cfquery>  

<!--- CF Personal Appointment Calendar by Kerry Reutens --->
<!--- Set Varibles Start --->
<cfparam name="url.header"      default="1">
<cfparam name="datetime"        default="#Now()#">
<cfparam name="url.day"         default="#dateformat(datetime,"d")#">
<cfparam name="url.startmonth"  default="#dateformat(datetime,"mm")#">
<cfparam name="url.startyear"   default="#Year(datetime)#">
<cfset dateob=CreateDate(URL.startyear,URL.startmonth,1)>
<cfset thedate = Createdate(URL.startyear, URL.startmonth, url.day)>
<cfparam name="url.adam"        default="0">
<cfparam name="URL.ID0"         default="">

<cfajaximport tags="cfdiv,cfform">
<cf_menuscript>
<cf_calendarscript>
<cf_dialogstaffing>
<cf_dialogPosition>

<cf_screentop height="100%" title="ts:#Employee.LastName# #Employee.PersonNo#" jquery="Yes" scroll="No" html="no" layout="webapp" label="Timesheet: #Employee.FirstName# #Employee.LastName# #Employee.IndexNo#">

<cfparam name="caller" default="dayview"> 

<cfoutput>

<script language="JavaScript">
	
	function hl(itm,fld,name){
	
		ie = document.all?1:0
	    ns4 = document.layers?1:0
			 
	     if (ie){
	          while (itm.tagName!="TABLE")
	          {itm=itm.parentElement;}
	     }else{
	          while (itm.tagName!="TABLE")
	          {itm=itm.parentNode;}
	     }
			 	 		 	
		 if (fld != false){
			
		 //itm.className = "highLight";
		 itm.bgColor = 'F2F6FF';
		 document.body.style.cursor = "hand";
		 self.status = name;
		 }else{
			
	     //itm.className = "white";		
		 itm.bgColor = '';
		 document.body.style.cursor = "";
		 self.status = name;
		 }
	  }
	  
	function entryhour(pers,x,mth,yr,hr,slot,context,actionclass,actioncode) {								
			_cf_loadingtexthtml='';									
			ptoken.navigate('#SESSION.root#/attendance/application/TimeSheet/Dialog/DialogOpen.cfm?id='+pers+'&day='+x+'&startmonth='+mth+'&startyear='+yr+'&hour='+hr+'&slot='+slot+'&context='+context+'&actionclass='+actionclass+'&actioncode='+actioncode,'dialog')								
 	}  	
	
	function schedulesave() 	{
		
		    count = 0
			ds = ""
			se = document.getElementsByName("selecthour")
			while (se[count]) {
				if (se[count].checked == true)	{
					ds = ds+'-'+se[count].value
			}
			count++
			} 		
								
			mis  = document.getElementById("mission").value			
			eff  = document.getElementById("dateeffective").value			
			slt  = document.getElementById("slots").value								
			url  = "#SESSION.root#/attendance/application/workschedule/ScheduleEditSubmit.cfm?mission="+mis+"&dateeffective="+eff+"&slots="+slt+"&id=#URL.id#&ds="+ds
			_cf_loadingtexthtml='';	
			ColdFusion.navigate(url,'contentbox1')
			// _cf_loadingtexthtml="<div><img src='<cfoutput>#SESSION.root#</cfoutput>/images/busy10.gif'/>";
									
		}
		
	function scheduleedit(per,mis,eff) {
	    Prosis.busy('yes')
		url = "#SESSION.root#/attendance/application/workschedule/ScheduleEdit.cfm?mission="+mis+"&dateeffective="+eff+"&id=#URL.id#"
		_cf_loadingtexthtml="";	
		ColdFusion.navigate(url,'contentbox1')
	}
				
	function showdate(d) {
	    ColdFusion.navigate('#SESSION.root#/attendance/application/TimeSheet/TimesheetDetail.cfm?ID0=#URL.ID0#&id=#URL.ID#&day='+d+'&startmonth=#url.startmonth#&startyear=#url.startyear#&adam=0','contentbox1') 
	}
	
	function gotodate(pers,x,mth,yr,a) {
	       _cf_loadingtexthtml="";	
		   Prosis.busy('yes')		 
		   ColdFusion.navigate('#SESSION.root#/attendance/application/TimeSheet/TimesheetDetail.cfm?id0=#url.id0#&id='+pers+'&day='+x+'&startmonth='+mth+'&startyear='+yr+'&adam=0','contentbox1') 		
	}	
	
	function gotoweek(pers,x,mth,yr,a) {
		   ColdFusion.navigate('#SESSION.root#/attendance/application/TimeSheet/WeekView.cfm?id0=#url.id0#&id=#URL.ID#&day='+x+'&startmonth='+mth+'&startyear='+yr+'&adam=0','contentbox1') 
	}	
	
	function gotomonth(pers,x,mth,yr,a) {
		   ptoken.navigate('#SESSION.root#/attendance/application/TimeSheet/CalMonth.cfm?id0=#url.id0#&id=#URL.ID#&day='+x+'&startmonth='+mth+'&startyear='+yr+'&adam=0','contentbox1') 
	}	
	
	function gotoyear(pers,x,mth,yr,a) {		
		   ptoken.navigate('#SESSION.root#/attendance/application/TimeSheet/Summary/Summary.cfm?id0=#url.id0#&id=#URL.ID#&day='+x+'&startmonth='+mth+'&startyear='+yr+'&adam=0','contentbox1') 
	}	
	 				
	function activity(id) {		     
           w = #CLIENT.width#  - 80;
           h = #CLIENT.height# - 120;	 
	       ptoken.open("#SESSION.root#/programrem/application/program/ActivityProject/ActivityView.cfm?ActivityId=" + id,"activity","width="+w+",height="+h+",status=yes,toolbar=no,scrollbars=yes,resizable=yes")		  					
	}	  	
		
	function hourdel(pers,date,hr,slot,context) {	
	       Prosis.busy('yes')	        
		   url = "#SESSION.root#/attendance/application/TimeSheet/HourEntryDelete.cfm?context="+context+"&id="+pers+"&date="+date+"&hr="+hr+"&slot="+slot			
		   if (context == "day") {
			  ptoken.navigate(url,'list');
			  sum(date);
		   } else {
			  ptoken.navigate(url,'contentbox1')
		   }			
	 }	 
		
	function hourcopy(pers,date,frm,context) {
	       _cf_loadingtexthtml="";	
		   url = "#SESSION.root#/attendance/application/TimeSheet/HourEntryCopy.cfm?context="+context+"&id="+pers+"&date="+date+"&from="+frm
		   if (context == "day") {
			  ColdFusion.navigate(url,'list')
		   } else {
			  ColdFusion.navigate(url,'contentbox1')
		   }
		   _cf_loadingtexthtml="<div><img src='<cfoutput>#SESSION.root#</cfoutput>/images/busy10.gif'/>";				
		 }	 			
				
	function sum(date) { 
	     _cf_loadingtexthtml="";    		
		 ptoken.navigate('#SESSION.root#/attendance/application/TimeSheet/DayViewHourSummary.cfm?id=#URL.id#&date='+date,'summ')		
		 ptoken.navigate('#SESSION.root#/attendance/application/TimeSheet/TimesheetFooter.cfm?id=#URL.id#&date='+date,'footer')							
	}		
	
	function clearWSSelection() {
		$('.clsWSHrSlot input[type=checkbox]').prop('checked', false);
		$('.clsWSHrSlot').css('background-color', '');
	}
	
	function selectWS9To5() {
		clearWSSelection();
		$('.clsWSHrSlot95 input[type=checkbox]').prop('checked', true);
		$('.clsWSHrSlot95').css('background-color', '##ffffcf');
	}
		
</script>

</cfoutput>

<cfparam name="url.scope" default="Backoffice">

<cfif url.scope neq "Backoffice">
	 <cfset url.id = CLIENT.personno>
</cfif>

<!--- check if valid assignment --->

 <cfquery name="Employee" 
    datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
          SELECT *
          FROM   Person
          WHERE  PersonNo = '#URL.ID#'
   </cfquery>      
   	
   <cfif Employee.recordcount eq "0">         
          	
         <cfquery name  = "Employee" 
		     datasource= "AppsEmployee" 
			 username  = "#SESSION.login#" 
			 password  = "#SESSION.dbpw#">               
             	SELECT TOP 1*
            	FROM   Person
            	WHERE  IndexNo = '#URL.ID#'
         </cfquery>
             	            	            
         <cfset URL.ID = "#Employee.PersonNo#">
     
   </cfif>  

<cfif Employee.recordcount eq "0">

   <cf_message message = "Your account has not been registered for the Timesheet function. Please consult your administrator"
   return = "back">
   
   <cfabort>
        
</cfif>
       
<style>
    #menu1,
    #menu2,
    #menu3,
    #menu4,
    #menu5{
        padding: 2px 0 10px !important;
        border-top: 1px solid #f5f5f5!important;
        border-right: 1px solid #f3f3f3!important;
        border-bottom: 1px solid #f5f5f5!important;
    }
    #menu5{
        border-right: 0!important;
    }
    #menu1_text.labelit,
    #menu2_text.labelit,
    #menu3_text.labelit,
    #menu4_text.labelit,
    #menu5_text.labelit{
        padding: 0!important;
        
    }
</style>
       

<table width="100%" height="100%" align="center" border="0" cellspacing="0" cellpadding="0" align="center">

<tr class="line">
	<td style="background-color:f1f1f1">			
		<cfinclude template="../../../Staffing/Application/Employee/PersonViewHeaderToggle.cfm">			
	</td>
</tr>

<tr><td style="height:20px">

		<!--- top menu --->
				
		<table width="100%" border="0" align="center" cellspacing="0" cellpadding="0">		  		
						
			<cfset ht = "64">
			<cfset wd = "64">
			
			<cfset add = 1>
			
			<cfoutput>
			
			<input type="hidden" name="datefield" id="datefield"  value="#day(now())#">
			<input type="hidden" name="monthfield" id="monthfield" value="#month(now())#">
			<input type="hidden" name="yearfield" id="yearfield"  value="#year(now())#">
			
			</cfoutput>
							
			<tr>					
			
					<cfset itm = "1">
						
					<cf_menutab item       = "1" 
					            iconsrc    = "Logos/Attendance/DayView.png" 
								iconwidth  = "#wd#" 
								targetitem = "1"
								iconheight = "#ht#" 
								class      = "highlight1"
								name       = "Day View"
								source     = "#SESSION.root#/attendance/application/TimeSheet/TimesheetDetail.cfm?ID0=#URL.ID0#&id=#url.id#&day={datefield}&startmonth={monthfield}&startyear={yearfield}">			
					
					
					<cfset itm = itm+1>	
								
					<cf_menutab item       = "#itm#" 
					            iconsrc    = "Logos/Attendance/WeekView.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								targetitem = "1"
								name       = "Week View"
								source     = "#SESSION.root#/attendance/application/TimeSheet/WeekView.cfm?ID0=#URL.ID0#&id=#url.id#&day={datefield}&startmonth={monthfield}&startyear={yearfield}">			
																	
					<cfset itm = itm+1>				
					
					<cf_menutab item       = "#itm#" 
					            iconsrc    = "Logos/Attendance/MonthView.png" 
								iconwidth  = "#wd#" 
								targetitem = "1"
								iconheight = "#ht#" 
								name       = "Month View"
								source     = "#SESSION.root#/attendance/application/TimeSheet/CalMonth.cfm?ID0=#URL.ID0#&id=#url.id#&day={datefield}&startmonth={monthfield}&startyear={yearfield}">
					
					
					<cfset itm = itm+1>				
					
					<cf_menutab item       = "#itm#" 
					            iconsrc    = "Logos/Attendance/Summary.png" 
								iconwidth  = "#wd#" 
								targetitem = "1"
								iconheight = "#ht#" 
								name       = "Summary"
								source     = "#SESSION.root#/attendance/application/TimeSheet/Summary/Summary.cfm?ID0=#URL.ID0#&id=#url.id#&day={datefield}&startmonth={monthfield}&startyear={yearfield}">
				
				
					<cfset itm = itm+1>	
					
					<cf_menutab item       = "#itm#" 
					            iconsrc    = "Logos/Attendance/Schedule.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								targetitem = "1"
								name       = "Week Schedule"
								source     = "#SESSION.root#/attendance/application/workschedule/ScheduleEdit.cfm?id=#url.id#">		
																				 		
				</tr>
		</table>

</td></tr>

<tr><td class="line"></td></tr>

<tr id="box1">
	<td width="99%" height="100%" valign="top" align="Center" id="contentbox1">	
	
		<cfset url.mode = "view">
		<cfinclude template="TimesheetDetail.cfm">				
	</td>
</tr>

<tr><td id="dialog"></td></tr>


</table>
	
