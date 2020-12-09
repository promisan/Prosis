
<cfparam name="URL.Title"           default="Official holidays">
<cfparam name="URL.startyear"       default="#Year(now())#">
<cfparam name="URL.startmonth"      default="#Month(now())#">
<cfparam name="URL.day"             default="1">

<cfajaximport tags="cfform">


<cfquery name="MissionList" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
        password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_ParameterMission	
		WHERE  Mission IN (SELECT Mission FROM Organization.dbo.Ref_MissionModule WHERE SystemModule = 'Attendance')	
</cfquery>

<cfparam name="url.mission" default="#MissionList.Mission#">

<cf_CalendarViewScript>

<script language="JavaScript">

function validate(mis,date) {
	document.holidayform.onsubmit() 	
	if( _CF_error_messages.length == 0 ) {            
		ptoken.navigate('setHolidaySubmit.cfm?mission='+mis+'&selecteddate='+date,'calendartarget','','','POST','holidayform')
	 }   
}	

function validatelist(mis,act) {
	document.holidaylistform.onsubmit() 	
	if( _CF_error_messages.length == 0 ) {            
		ptoken.navigate('setHolidaySubmit.cfm?mission='+mis+'&action='+act,'listsubmit','','','POST','holidaylistform')
	 }   
}	  

</script>

<cfset add          = "0">
<cfset save         = "0"> 
<cfinclude template = "../HeaderMaintain.cfm"> 

<cf_screentop scroll="Yes" html="no" jquery="Yes">

<table width="100%" border="0" class="formpadding" bgcolor="FFFFFF">

<tr><td width="96%" style="padding-left:20px">

		<table border="0" cellspacing="0" cellpadding="0">
		
		<tr><td height="6"></td></tr>
		
		<tr>
		<td colspan="2">
			<table>
			<tr><td height="30" class="label"></td>			
				<td>	
				
				    <cfoutput>
						<select name="mission" id="mission" class="regularxl" onchange="_cf_loadingtexthtml='';Prosis.busy('yes');ColdFusion.navigate('HolidayCalendarContent.cfm?idmenu=#url.idmenu#&mission='+this.value,'missioncontent');ColdFusion.navigate('HolidayList.cfm?idmenu=#url.idmenu#&startyear=#url.startyear#&mission='+this.value,'holidaylistcontent')">
							<cfloop query="MissionList">
							<option value="#Mission#" <cfif url.mission eq mission>selected</cfif>>#Mission#</option>
							</cfloop>		
						</select>		
					</cfoutput>
				</td>
			</tr>
			</table>
		</td>
		</tr>
		
		<tr>
		<td colspan="1" align="left" valign="top" id="missioncontent" style="padding-left:30px;border:0px solid silver;width:550">		
			<cfinclude template="HolidayCalendarContent.cfm">								
		</td>
		
		<td width="5"></td>
						
		<td valign="top" height="100%" id="holidaylistcontent" style="padding-top:40px;padding-left:10px;">		
			
			<cfset dateob       = CreateDate(url.startyear,url.startmonth,url.day)>  
			<cfset FIRSTOFMONTH = CreateDate(Year(DateOb),Month(DateOb),1)>
			<cfset ENDOFMONTH   = CreateDate(Year(DateOb),Month(DateOb),DaysInMonth(DateOb))>
			
			<cfinclude template="HolidayList.cfm">		
		</td>
		
		</tr>				
	
</table>

</body>
</html>