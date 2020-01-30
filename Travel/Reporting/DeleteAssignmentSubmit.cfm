<!---
	..Travel/Reporting/DeleteAssignmentSubmit.cfm
	
	Delete specified PersonAssignment, Position, and PositionParent records.
	
	Note: deleting the PositionParent record will cascade deletes to associated Position and PersonAssignment records.
	
	Only the following can access this function:
	Michael Marano (fornyma4)
	Jose Solorzano (dpknyjs77) 
	Carlos Peralta (dpknycp2)
	Florin Stanciu (forthcoming)	
	
	Called by: DeploymentListing.cfm
	
	Modification History:
	24Feb04 MM - created code

--->
<!--- verify that person assignment record is there --->
<cfquery name="GetPositionParentId" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">
	 SELECT P.PositionParentId 
	 FROM  Position P, PersonAssignment PA
	 WHERE P.PositionNo = PA.PositionNo
	 AND   AssignmentNo = #URL.ID#
</cfquery>	

<cfquery name="DeletePositionParent" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">
   DELETE PositionParent 
   WHERE PositionParentId = #GetPositionParentId.PositionParentId#
</cfquery>	
  
<cfoutput>
<script language="JavaScript">
   opener.history.go()
   window.close()
</script>
</cfoutput> 	