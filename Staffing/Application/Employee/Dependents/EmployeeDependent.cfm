<cfparam name="url.scope" default="Backoffice">

<cfif url.scope neq "Backoffice">
	 <cfset url.id = CLIENT.personno>
</cfif>


<!--- Create Criteria string for query from data entered thru search form --->

<cfquery name="RevertPayroll" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
      UPDATE Payroll.dbo.PersonDependentEntitlement 
	  SET  	 Status      = '9'						   
	  WHERE  PersonNo    = '#PersonNo#'
	  AND    DependentId IN (SELECT DependentId 
	                         FROM   PersonDependent 
							 WHERE  PersonNo     = '#URL.ID#' 
							 AND    ActionStatus = '9')					    
</cfquery>			

<cfparam name="url.action" default="Person">
<cfparam name="url.status" default="Valid">
<cfparam name="url.webapp" default="">

<cfif url.action eq "claim">
<cf_screentop html="no" scroll="yes" jquery="Yes" menuaccess="context"  actionobject="Person"
		actionobjectkeyvalue1="#url.id#">
<cfelse>
<cf_screentop html="no" scroll="yes" jquery="Yes" menuaccess="context"  actionobject="Person"
		actionobjectkeyvalue1="#url.id#">
</cfif>

<table width="96%" align="center" border="0" cellspacing="0" cellpadding="0">
<tr>		
<td>

<cfif url.action eq "Person">
		
	<cf_actionListingScript>
	<cf_FileLibraryScript>
	<cf_dialogPosition>
	<cfinclude template="EmployeeDependentScript.cfm">	
	<cfset ctr = "1">
	<cfset openmode = "show">
	<cfinclude template="../PersonViewHeaderToggle.cfm">
	<table><tr><td height="1"></td></tr></table>
	
<cfelseif url.action eq "Claim">	

	<cf_actionListingScript>
	<cf_FileLibraryScript>
	<cfinclude template="EmployeeDependentScript.cfm">
		
</cfif>

<table style="min-width:800px" width="98%" align="center">
<tr>		
	<td colspan="14" id="contentdependent" style="min-width:800px;padding-left:5px;padding-right:5px">
		<cfinclude template="../Dependents/EmployeeDependentDetail.cfm">
	</td>
</tr>
</table>	

</td>
</tr>
</table>

