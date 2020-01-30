
<link rel="stylesheet" type="text/css" href="../../../<cfoutput>#client.style#</cfoutput>">

  <cfquery name="Delete" 
 datasource="#CLIENT.Datasource#" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 DELETE DocumentCandidate
 WHERE DocumentNo  = '#URL.ID#' AND PersonNo = '#URL.ID1#'
 </cfquery>

 <CF_RegisterAction 
 SystemFunctionId="1101" 
 ActionClass="Delete Candidate" 
 ActionType="Select" 
 ActionReference="#URL.ID# #URL.ID1#" 
 ActionScript="">    
  
<script language="JavaScript">
  window.close()
  opener.location.reload();
</script>

