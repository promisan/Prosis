
<link rel="stylesheet" type="text/css" href="../../../<cfoutput>#client.style#</cfoutput>">

 <cfquery name="FlowClass" 
 datasource="#CLIENT.Datasource#" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT *
 FROM Document
 WHERE DocumentNo  = '#URL.ID#'
   </cfquery>

 <cfquery name="Status" 
 datasource="#CLIENT.Datasource#" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 UPDATE DocumentCandidate
 SET Status = '0'
 WHERE DocumentNo  = '#URL.ID#' AND PersonNo = '#URL.ID1#'
 </cfquery>
 
 <cfquery name="GetStatus" 
 datasource="#CLIENT.Datasource#" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    UPDATE DocumentCandidateAction 
	SET ActionStatus = '0'
	WHERE DocumentNo  = '#URL.ID#' AND PersonNo = '#URL.ID1#'
	AND (ActionStatus = '9' AND ActionStatus = '6')
</cfquery>
 
 <cfquery name="Check" 
 datasource="#CLIENT.Datasource#" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT DocumentNo
 FROM DocumentCandidateAction
 WHERE DocumentNo  = '#URL.ID#' AND PersonNo = '#URL.ID1#'
 </cfquery>
 
 <cfif Check.recordCount lt 1>

 <CF_RegisterAction 
 SystemFunctionId="1101" 
 ActionClass="Document Candidate" 
 ActionType="Select" 
 ActionReference="#URL.ID# #URL.ID1#" 
 ActionScript="">    
    
 <cfquery name="Action" 
datasource="#CLIENT.Datasource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM DocumentFlow
WHERE Operational  = '1'
AND ActionLevel    = '1'
AND DocumentNo  = '#URL.ID#'
   </cfquery>
   
 <cfset dte = now()>
 <cfoutput query="action">
  
 <cfif #ActionLeadTime# neq "">
      <cfset dte = DateAdd("d",  #ActionLeadTime#,  #dte#)>
 <cfelse>
      <cfset dte = DateAdd("d",  0,  #dte#)>
 </cfif>
    
 <cfquery name="InsertDocumentAction" 
    datasource="#CLIENT.Datasource#" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    INSERT INTO DocumentCandidateAction
            (DocumentNo,
		     PersonNo,
		     ActionId,
			 ActionClass,
		     ActionOrder,
			 ActionOrderSub,
		     ActionDatePlanning)
    VALUES  ('#URL.ID#',
             '#URL.ID1#',
             '#ActionId#',
			 '#Class.ActionClass#',
		     '#ActionDefaultOrder#',
			 '#ActionOrderSub#',
		     #dte#)
 </cfquery>
 
 </cfoutput> 
     
 </cfif>

<script language="JavaScript">
  window.close()
  opener.location.reload();
</script>

