<!-- 
	InheritNominees.Cfm  
	
	Copy deployed personnel for the specified request.
	Used when identifying rotating personnel during UNMO/SO Request Creation.

	Called by ..Application/PersonSearch.cfm
	Parameters:
		URL.ID
		URL.ID1
	
	Modification History:
	17Oct03 - created by MM
 -->

<cfparam name="URL.ID" default="0">
<cfparam name="URL.ID_OLD" default="0">
 
<!--- record action in UserAction table
<CF_RegisterAction 
SystemFunctionId="1201" 
ActionClass="Document Rotation Person" 
ActionType="Enter" 
ActionReference="#URL.ID# #URL.ID1#" 
ActionScript="">   ---> 

<!--- Retrieve deployed candidates from DocumentCandidate table - status 3 
	  for the user-specified OLD Document Request Number, and for those
	  persons that have not been previously specified for the NEW request
	  record that is being created
--->	
<cfquery name="InheritNominees" 
datasource="#CLIENT.Datasource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO DocumentRotatingPerson (DocumentNo, PersonNo, ReplacementPersonNo,
	OfficerUserId, OfficerLastName, OfficerFirstName, Created)
SELECT '#URL.ID#', DC.PersonNo, '', '#SESSION.acc#', '#SESSION.last#', '#SESSION.first#',
	'#DateFormat(Now(),"mm/dd/yyyy")#' 
FROM DocumentCandidate DC 
WHERE DC.Status = '3' 
AND DC.DocumentNo = '#URL.ID_OLD#'
AND NOT EXISTS (SELECT * FROM DocumentRotatingPerson DRP WHERE DRP.PersonNo = DC.PersonNo
			    AND DRP.DocumentNo = '#URL.ID#')
</cfquery>		  

<cfoutput>
<script>
	window.location = "../PersonSearch.cfm?ID=#URL.ID#" 
</script>
</cfoutput>