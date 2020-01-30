<!---
	..Travel/Reporting/DeleteAssignmentAndPersonSubmit.cfm
	
	Delete specified PersonAssignment, Position, and PositionParent records.
	Also delete Person record IF no other assignment (other than current one) exists.
	
	Note: deleting the PositionParent record will cascade deletes to associated Position and PersonAssignment records.
	
	Only the following can access this function:
	Michael Marano (fornyma4)
	Jose Solorzano (dpknyjs77) 
	Carlos Peralta (dpknycp2)
	Florin Stanciu (forthcoming)	
	
	Called by: DeploymentListing.cfm
	
	Input Params:	URL.ID  - Assignment No (integer)	
					URL.ID1 - Person No (varchar 20)
	
	Modification History:
	08Jan05 MM - created code

--->
<cfquery name="ChkForOtherAssignments" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">
	 SELECT P.*
	 FROM  Person P, PersonAssignment PA
	 WHERE P.PersonNo = PA.PersonNo
	 AND   PA.AssignmentNo <> #URL.ID#               <!--- look for assignments other than currently selected assignment --->
	 AND   P.PersonNo = '#URL.ID2#'
</cfquery>	

<cfif #ChkForOtherAssignments.RecordCount# GT 0>
	<cfoutput>
	<script language="JavaScript">
	   alert("Other assignments exist for this officer.  Person record shall be retained, but assignment record shall be deleted.")
	   window.close()
	</script>
	</cfoutput> 
<cfelse>
	<cfquery name="DeletePerson" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">
	   DELETE Person 
	   WHERE PersonNo = '#URL.ID2#'
	</cfquery>		
</cfif>

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