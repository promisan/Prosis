
<link rel="stylesheet" type="text/css" href="../../../<cfoutput>#client.style#</cfoutput>">

  <cfquery name="Delete" 
 datasource="#CLIENT.Datasource#" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 DELETE ActionAuthorization
 WHERE UserAccount  = '#URL.ID#' AND Mission = '#URL.ID1#'
 </cfquery>

 <CF_RegisterAction 
 SystemFunctionId="0129" 
 ActionClass="Delete Access" 
 ActionType="Mission" 
 ActionReference="#URL.ID# #URL.ID1#" 
 ActionScript="">  
  
<script language="JavaScript">
  opener.location.reload();  
  window.close();
</script>

