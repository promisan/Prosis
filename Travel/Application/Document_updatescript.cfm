
<link rel="stylesheet" type="text/css" href="../../<cfoutput>#client.style#</cfoutput>">

<!--- select all document --->

<cfquery name="Document" 
datasource="AppsTravel" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">  
SELECT D.DocumentNo, F.*
FROM Document D, FlowAction F
WHERE DocumentNo = 3
ORDER BY DocumentNo

</cfquery>

<!--- loop document --->

<cfoutput query="Document">

<!--- verify if flowaction exists in reference --->

<cfquery name="Flow" 
datasource="AppsTravel" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">  
SELECT DocumentNo
FROM DocumentFlow
WHERE DocumentNo = #DocumentNo#
AND ActionId = #ActionId#
</cfquery>

<cfif Flow.RecordCount eq 0>

<!--- insert action --->

<cfquery name="InsertFlow" 
datasource="AppsTravel" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">  
  INSERT INTO DocumentFlow 
  (DocumentNo, ActionId, ActionDirectory, ActionClass, 
 ActionLevel, ActionType, ActionArea, ActionForm, ActionParent, 
 ActionDescription, ActionCompleted, ActionReferenceShow, ActionReferenceFieldName, ActionOrder, 
 ActionOrderSub, ActionLeadTime, ActionResetToOrder, ActionRequired, 
 ActionRejectDisabled, ActionByPassDisabled, ActionLevelTrigger, ActionShowAllCandidates, 
 ActionCandidateRevoke, ActionCandidateBatch, Operational)
SELECT #DocumentNo#, A.ActionId, A.ActionDirectory, A.ActionClass, A.ActionLevel, 
 A.ActionType, A.ActionArea, A.ActionForm, A.ActionParent, 
 A.ActionDescription, A.ActionCompleted, A.ActionReferenceShow, A.ActionReferenceFieldName, A.ActionOrder, 
 A.ActionOrderSub, A.ActionLeadTime, A.ActionResetToOrder, 
 A.ActionRequired, A.ActionRejectDisabled, A.ActionByPassDisabled, 
 A.ActionLevelTrigger, A.ActionShowAllCandidates, A.ActionCandidateRevoke, A.ActionCandidateBatch, A.Operational 
FROM FlowAction A
WHERE Operational  = 1
AND ActionId = #ActionId#
</cfquery>

<cfelse>

<!--- update action --->

<cfquery name="UpdateFlow" 
datasource="AppsTravel" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">  
  UPDATE DocumentFlow 
  SET ActionDirectory = '#ActionDirectory#', 
  ActionClass    = '#ActionClass#', 
  ActionLevel    = '#ActionLevel#', 
  ActionType     = '#ActionType#', 
  ActionArea     = '#ActionArea#', 
  ActionForm     = '#ActionForm#', 
  ActionParent   = '#ActionParent#', 
  ActionDescription = '#ActionDescription#', 
  ActionCompleted   = '#ActionCompleted#', 
  ActionReferenceFieldName = '#ActionReferenceFieldName#', 
  ActionOrder = '#ActionOrder#', 
  ActionOrderSub = '#ActionOrderSub#', 
  ActionLeadTime = '#ActionLeadTime#', 
  ActionResetToOrder      = '#ActionResetToOrder#', 
  ActionRequired          = '#ActionRequired#', 
  ActionRejectDisabled    = '#ActionRejectDisabled#', 
  ActionByPassDisabled    = '#ActionByPassDisabled#', 
  ActionLevelTrigger      = '#ActionLevelTrigger#', 
  ActionShowAllCandidates = '#ActionShowAllCandidates#',
  ActionCandidateRevoke   = '#ActionCandidateRevoke#', 
  ActionCandidateBatch    = '#ActionCandidateBatch#', 
  Operational             = '#Operational#'
  WHERE DocumentNo = #DocumentNo#
  AND ActionId = #ActionId#
</cfquery>

</cfif>

<!--- verify if action exists --->

<cfquery name="Action" 
datasource="AppsTravel" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">  
SELECT DocumentNo
FROM DocumentAction
WHERE DocumentNo = #DocumentNo#
AND ActionId = #ActionId#
</cfquery>

<cfif Action.RecordCount eq 0>

<!--- insert action --->

  <cfif #ActionLevel# eq "0">
     <cfset status = "0">
  <cfelse>
     <cfset status = "4">
  </cfif>

<cfquery name="InsertAction" 
datasource="AppsTravel" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">  
  INSERT INTO DocumentAction 
  (DocumentNo, ActionId, ActionOrder, ActionOrderSub, ActionStatus)
SELECT #DocumentNo#, #ActionId#, A.ActionOrder, A.ActionOrderSub, #Status# 
FROM FlowAction A
WHERE Operational  = 1
AND ActionId = #ActionId#
</cfquery>

<cfelse>

<!--- update action --->

<cfquery name="UpdateAction" 
datasource="AppsTravel" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">  
  UPDATE DocumentAction
  SET  
  ActionOrder    = '#ActionOrder#', 
  ActionOrderSub = '#ActionOrderSub#'
  WHERE DocumentNo = #DocumentNo#
  AND ActionId = #ActionId#
</cfquery>

</cfif>

</cfoutput>



<!--- select all document --->

<cfquery name="DocumentCandidate" 
datasource="AppsTravel" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">  
SELECT D.DocumentNo, D.PersonNo, F.*
FROM DocumentCandidate D, FlowAction F
WHERE F.ActionLevel = 1 AND DocumentNo = 635
ORDER BY DocumentNo, PersonNo
</cfquery>

<cfoutput query="DocumentCandidate">

<!--- verify if candidate action exists --->

<cfquery name="ActionCandidate" 
datasource="AppsTravel" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">  
SELECT DocumentNo
FROM DocumentCandidateAction
WHERE DocumentNo = #DocumentNo#
AND PersonNo = '#PersonNo#'
AND ActionId = #ActionId#
</cfquery>

<cfif ActionCandidate.RecordCount eq 0>

<!--- insert action --->

<cfquery name="InsertCandidate" 
datasource="AppsTravel" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">  
  INSERT INTO DocumentCandidateAction 
  (DocumentNo, PersonNo, ActionId, ActionOrder, ActionOrderSub, ActionStatus)
SELECT #DocumentNo#, '#PersonNo#', #ActionId#, A.ActionOrder, A.ActionOrderSub, 0 
FROM FlowAction A
WHERE Operational  = 1
AND ActionId = #ActionId#
</cfquery>

<cfelse>

<!--- update action --->

<cfquery name="UpdateFlow" 
datasource="AppsTravel" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">  
  UPDATE DocumentCandidateAction
  SET  
  ActionOrder = #ActionOrder#, 
  ActionOrderSub = #ActionOrderSub#
  WHERE DocumentNo = #DocumentNo#
   AND PersonNo = '#PersonNo#'
   AND ActionId = #ActionId#
</cfquery>

</cfif>

</cfoutput>

<script language="JavaScript">
alert("finished")
</script>





