<!-- 
	IncidentEditSubmit.cfm
	
	Process user request to save updates to current incident record.

	Called by: IncidentEdit.Cfm
	
	Modification history:
	09Mar04 - added code to handle new field Status
			- also added code to handle CloseDate and ApprovalDate which are now optional fields
-->	
<cfset dateValue = "">
<cfif #FORM.OpenDate# NEQ "">
	<CF_DateConvert Value="#FORM.OpenDate#">
	<cfset oDate = #dateValue#>
</cfif>

<cfset dateValue = "">
<cfif #FORM.CloseDate# NEQ "">
 	<CF_DateConvert Value="#FORM.CloseDate#">
	 <cfset cDate = #dateValue#>
</cfif>
 
<!--- Write changes to Incident table --->
<cfquery name="Update_Incident" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
UPDATE Incident
SET Description       	= RTRIM(SUBSTRING('#FORM.Description#', 1,300)),
	Mission			   	= '#Form.Mission#',
	MissionCaseNumber   = '#Form.MissionCaseNumber#',
	<cfif #Form.OpenDate# NEQ "">OpenDate = #oDate#,<cfelse>OpenDate = NULL,</cfif>
	<cfif #Form.CloseDate# NEQ "">CloseDate = #cDate#,<cfelse>CloseDate = NULL,</cfif>
	RequestedBy			= '#Form.RequestedBy#',
	InvestigatingOffice = #Form.InvestigatingOffice#,
	Status			    = #Form.Status#
WHERE Incident		    = '#Form.Incident#'
</cfquery>

<!--- Write log entry into UserAction table --->
<CF_RegisterAction 
   SystemFunctionId="1207" 
   ActionClass="Edit Incident" 
   ActionType="Update Incident" 
   ActionReference="#Form.Incident#" 
   ActionScript="">

<cfoutput>
<script language="JavaScript">
   opener.history.go()
</script>
</cfoutput>

<cflocation url="IncidentEdit.cfm?ID=#FORM.Incident#">