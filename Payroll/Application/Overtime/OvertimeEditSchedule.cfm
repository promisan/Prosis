
<cf_CalendarScript>

<!--- added 18/9/2013 to ensure access --->
<cfparam name="url.refer"               default="">
<cfparam name="url.mode"                default="#url.refer#">
<cfparam name="client.width"            default="800">
<cfparam name="SESSION.isAdministrator" default="No">

<cfquery name="GetOvertime" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   PersonOvertime
	WHERE  OvertimeId = '#URL.ID1#'
</cfquery>

<cfif url.mode eq "workflow">
	<cf_screentop height="100%" scroll="Yes" jquery="Yes" label="Overtime - Clearance" banner="yellow" layout="webapp">
<cfelse>
	<cf_screentop height="100%" scroll="Yes" jquery="Yes" html="no">
</cfif>

<cfajaximport tags="cfform, cfdiv">

<cf_dialogPosition>
<cf_filelibraryscript>
<cf_actionListingScript>

<cf_tl id="The overtime must be greater than 0" var="vLblError1">
<cf_tl id="The total overtime must match the detailed amounts" var="vLblError2">

<cfoutput>

<script language="JavaScript">

	function check(act) {
	
		if (validateSubmission()) {
			 Prosis.busy('yes')
			 ptoken.navigate('#session.root#/payroll/application/overtime/OvertimeEditSubmit.cfm?refer=#url.refer#&mode=schedule&action='+act,'process','','','POST','overtimeedit')			
		}
	}

	function validateSubmission() {
		
		    hr = $('##OvertimeHours').val()			
			mn = $('##OvertimeMinutes').val()		
							
			if (hr == '0') { 			
			    if (mn == '0') {				  
			     //  alert('#vLblError2#');
				 //  return false	
				} else {
				return true
				}					
		    } else {
			  return true
			}
		 
		 }

</script>

</cfoutput>

<cfset url.id = getOvertime.PersonNo>

<cfquery name="Object" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   * 
    FROM     OrganizationObject
	WHERE    ObjectKeyValue4 = '#GetOvertime.Overtimeid#'	
	AND      Operational =  1
</cfquery>

<cfif GetOvertime.recordcount eq "0">

	<table align="center"><tr><td height="40" class="labellarge" align="center"><b>Attention : </b>Document no longer exists</td></tr></table>
	<cfabort>
	
</cfif>

<cf_divscroll width="99%"  height="100%">
	
	<table cellpadding="0" cellspacing="0" width="99%" align="center">
	
		<tr><td height="10" style="padding-left:7px">	
			  <cfset ctr      = "0">		
		      <cfset openmode = "hide"> 
			  <cfinclude template="../../../Staffing/Application/Employee/PersonViewHeaderToggle.cfm">		  
			 </td>
		</tr>	
					
		<tr><td height="100%" valign="top">
		
			<table height="100%" width="99%">
				<tr>
					<td style="padding-left:15px" id="edit_#GetOvertime.OverTimeId#">				  
						<cfdiv bind="url:OvertimeEditScheduleForm.cfm?id1=#GetOvertime.OverTimeId#&id=#url.id#&mode=#url.mode#&refer=#url.refer#"/>
					</td>
				</tr>
				
				<tr class="hide"><td id="process"></td></tr>
				<tr><td height="15"></td></tr> 
				<cfif getOvertime.Status eq "5" and Object.recordcount eq "0">
					<!--- nada --->
				<cfelse>
				<tr><td style="padding-left:35px;padding-right:25px" align="center">		
					<cf_securediv id="#GetOvertime.OverTimeId#" 
					    bind="url:OvertimeWorkflow.cfm?id=#GetOvertime.OverTimeId#&ajaxid=#GetOvertime.OvertimeId#&mission=#Object.Mission#&mode=#url.mode#&refer=#url.refer#&id2=#url.id#">   					
					</td>
				</tr>
				</cfif>
			</table>
		
		</td></tr>
	</table>

</cf_divscroll>

<cfif url.mode eq "workflow">
	<cf_screenbottom layout="webapp">
</cfif>