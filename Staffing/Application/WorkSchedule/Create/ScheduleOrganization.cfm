
<!--- ------------------------------------- --->
<!--- -------------show orgunits----------- --->
<!--- ------------------------------------- --->

<cfquery name  = "get" 
    datasource= "AppsEmployee" 
    username  = "#SESSION.login#" 
	password  = "#SESSION.dbpw#">      				 
		SELECT   *
		FROM     WorkSchedule W
		WHERE    W.Code = '#url.workschedule#'	
</cfquery>

<cfparam name="url.selecteddate"     default="#now()#">

<cfset dateValue = "">
<CF_DateConvert Value="#DateFormat(url.selecteddate,CLIENT.DateFormatShow)#">
<cfset DTE = dateValue>

<cfquery name  = "mandate" 
    datasource= "AppsEmployee" 
    username  = "#SESSION.login#" 
	password  = "#SESSION.dbpw#">      				 
		SELECT   M.*
		FROM     Organization.dbo.Ref_Mandate M
		WHERE    M.Mission = '#get.mission#'	
		AND      DateEffective  <= #DTE#
		AND      DateExpiration >= #DTE#
</cfquery>

<!--- ------------------------------------- --->
<!--- pending to group the units by mandate --->
<!--- ------------------------------------- --->

<table width="100%">

<cfoutput query="mandate">

	<tr><td colspan="2">
	
		<table width="100%" cellspacing="0" cellpadding="0" class="formpadding ">
		<tr class="labelmedium">
		
		<td style="height:30" class="labelit">#MandateNo#</td>		
		<td class="labelit">#dateformat(DateEffective,client.dateformatshow)#</td>		
		<td class="labelit">#dateformat(DateExpiration,client.dateformatshow)#</td>
		
		<td class="labelit" style="width:20%;padding-right:8px" align="right">
		
		  <cfset link = "#SESSION.root#/Staffing/Application/WorkSchedule/Create/ScheduleOrganizationSubmit.cfm?workschedule=#url.workschedule#&mission=#get.mission#&mandateno=#mandateno#">	
											   
		   	  <cf_selectlookup
			    box          = "box#mandateno#"
				link         = "#link#"
				title        = "Unit"
				icon         = "edit.gif"
				iconheight   = "15px"
				iconwidth    = "15px"
				button       = "No"
				close        = "No"	
				filter1      = "mission"
				filter1value = "#get.mission#"		
				filter2      = "mandateno"
				filter2value = "#mandateno#"				
				class        = "organization"
				des1         = "OrgUnit">	
		
		</td>
		</tr>	
				
		</table>		
										
		</td>
	</tr>	
	
	<tr><td colspan="2" class="linedotted"></td></tr>		
	
	<tr><td colspan="2" id="box#mandateno#">
		<cfinclude template="ScheduleOrganizationDetail.cfm">	
	</td></tr>	
	
	
	<tr>		
		<td colspan="2" id="targetleftdate" style="padding-left:2px;padding-right:8px">
		
		    <!--- show valid positions for this schedule on this date --->			
			<cfinclude template="ScheduleOrganizationPosition.cfm">										
			
		</td>
	</tr>	
			
</cfoutput>
</table>


