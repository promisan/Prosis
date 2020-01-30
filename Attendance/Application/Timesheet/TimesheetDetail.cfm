
<cfparam name="url.mode" default="View">
<cfparam name="URL.edit" default="0">

<cfset dateob  = CreateDate(URL.startyear,URL.startmonth,1)>
<cfset thedate = Createdate(URL.startyear, URL.startmonth, url.day)>
<cfset url.date = dateFormat(thedate,CLIENT.DateFormatShow)>

<cfset stcheck = Hour(now())>
<cfset etcheck = Hour(now())+1>

<cfquery name="getOrganizationAction" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	OrganizationAction
	WHERE 	OrgUnit IN (
				SELECT 	PAx.OrgUnit 
				FROM 	Employee.dbo.PersonAssignment PAx 
						INNER JOIN Employee.dbo.Position POx 
							ON PAx.PositionNo = POx.PositionNo 
				WHERE 	PAx.AssignmentStatus IN ('0','1')
				AND 	#thedate# BETWEEN PAx.DateEffective AND PAx.DateExpiration
				AND		PAx.PersonNo = '#URL.id#'
			)
	AND     #thedate# BETWEEN CalendarDateStart AND CalendarDateEnd
    AND     WorkAction = 'Attendance'	
</cfquery>

<cfif getOrganizationAction.recordCount eq 0 OR getOrganizationAction.actionStatus eq "0">
	<cfset url.edit = "1">
</cfif>

	<cfoutput>
	
		<script>
			document.getElementById('datefield').value  = '#day(thedate)#'
			document.getElementById('monthfield').value = '#month(thedate)#'
			document.getElementById('yearfield').value  = '#year(thedate)#'
		</script>
	
	</cfoutput>
		
	<table width="100%" height="100%">
       
	<tr>
	
	<td width="200" valign="top" style="border-right:1px solid silver;min-width:200">
	
	    <table width="100%" cellspacing="0" cellpadding="0">
								
			<tr><td>
		
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<td>
				   <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
				   <tr>
				   <td width="100%" align="center" valign="middle" style="padding-right:6px;padding-left:10px">
					   <cfinclude template="TimesheetCalendar.cfm"> 
				   </td>
				   </tr>
				   </table>
		        </td>
				</table>
			
			</td>
			</tr>			
			
			<tr>
			<td id="summ" width="100%" valign="top"  style="padding-top:4px;padding-right:6px;padding-left:10px">
			    <cf_space spaces="63">
				<cfinclude template="DayViewHourSummary.cfm">
			</td>
			</tr>
		
		</table>
	
	</td>	
			
	<td width="100%" height="100%" valign="top" align="center" id="detail" style="padding-top:4px;padding-left:8px">		    
		<cfinclude template="DayView.cfm">	
	</td>
		
   </tr>
   
   <tr class="hide"><td id="footer" colspan="2">
	  <!--- <cfinclude template="TimesheetFooter.cfm"> --->
   </td></tr>
   
</table>

<script>
	Prosis.busy('no')
</script>
	