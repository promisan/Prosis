
<cfquery name="Update" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE  ProgramAllotmentRequest
		SET     ExecutionStatus = '#url.status#'
		FROM    ProgramAllotmentRequest		
</cfquery>

<cfoutput>

<cfif url.status eq "0">

	 <cf_img icon="log" onclick="alldetexecution('#requirementid#','3')"
						   tooltip="Pending Execution">
<!---
    <img src="#SESSION.root#/images/pending.png" 
	   style="cursor:pointer" 
	   height="14" 
	   width="14" 
	   onclick="alldetexecution('#url.requirementid#','3')"
	   alt="Pending Execution" 
	   border="0" 
	   align="absmiddle">
	   
	   --->
		   
<cfelse>

	<img src="#SESSION.root#/images/Validate.gif" 
		  onclick="alldetexecution('#url.requirementid#','0')"
		  style="cursor:pointer" alt="Executed" border="0" align="absmiddle">
		  
</cfif>

</cfoutput>