

<!--- staffing view events --->

<cfquery name="PersonEvent"
   datasource="AppsEmployee"
   username="#SESSION.login#"
   password="#SESSION.dbpw#">
	SELECT     Pe.PersonNo, Pe.Mission, Pe.OrgUnit, Pe.EventId, 
	           Pe.EventTrigger, T.Description AS EventTriggerName, 
			   Pe.EventCode, R.Description AS EventName, 
			   Pe.ReasonCode, Pe.ReasonListCode, 
               Pe.DateEventDue, Pe.ActionDateEffective, Pe.ActionDateExpiration, Pe.Remarks,
			   Pe.ActionStatus
    FROM       PersonEvent AS Pe INNER JOIN
               Ref_PersonEvent AS R ON Pe.EventCode = R.Code INNER JOIN
               Ref_EventTrigger AS T ON Pe.EventTrigger = T.Code
	WHERE 	   Mission = '#url.mission#'
	-- AND     PersonNo = '#url.personNo#'	
	ORDER BY Pe.Created DESC   
</cfquery>

<table width="100%" class="navigation_table" style="min-width:500px;height:20px">

<cfoutput query="PersonEvent">

<tr class="labelmedium <cfif currentrow neq recordcount>line</cfif> navigation_row">
    <td>
	<cf_img icon="edit" navigation="Yes" onClick="eventdialog('#eventid#')">
	</td>
	<td style="padding-left:4px;width:100%">#EventTriggerName# : #EventName#</td>	
	<td style="padding-left:4px;min-width:90px">#dateformat(DateEventDue,client.dateformatshow)#</td>
	<td style="padding-left:4px;min-width:90px">#dateformat(ActionDateEffective,client.dateformatshow)#</td>
	<td style="padding-left:4px;min-width:90px"><cfif actionstatus eq "1"><cf_tl id="Completed"><cfelse><cf_tl id="Pending"></cfif></td>
</tr>

</cfoutput>

</table>

<cfset ajaxonload("doHighlight")>

	 