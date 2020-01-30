<!-- 
	DocumentRotatingPersonDeleteSubmit.cfm
	
	Delete deployed persons that have been associated to the new Personnel
	Request document.  Activated by clicking the CANCEL link beside each
	person record.
	
	Calls: none
	Parameters:
	  URL_ID  - Document (Request) Number
	  URL_ID1 - Person Number
	  
	Modification History:
	17Oct03 - Created by MM
 -->
 <cfquery name="Delete_DocumentRotatingPerson" 
 datasource="#CLIENT.Datasource#" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 DELETE DocumentRotatingPerson
	 WHERE DocumentNo = '#URL.ID#' AND PersonNo = '#URL.ID1#'
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