<!-- 
	IncidentPersonDeleteSubmit.cfm
	
	Delete deployed persons that have been associated to the current Incident.
	Activated by clicking the DISASSOCIATE link beside each	person record.
	
	Calls: none
	Parameters:
	  URL_ID  - Incident Number
	  URL_ID1 - Person Number
	  
	Modification History:
	24Oct03 - Created by MM
 -->
 <cfquery name="Delete_IncidentPerson" 
 datasource="#CLIENT.Datasource#" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 DELETE IncidentPerson
	 WHERE Incident = #URL.ID# AND PersonNo = '#URL.ID1#'
 </cfquery>

<!--- release later when UNMOs are live
 <CF_RegisterAction 
 SystemFunctionId="1202" 
 ActionClass="Delete Rotating Person" 
 ActionType="Select" 
 ActionReference="#URL.ID# #URL.ID1#" 
 ActionScript="">    
--->

<cfoutput>
<script language="JavaScript">
  window.close()
  opener.location.reload();
</script>
</cfoutput>