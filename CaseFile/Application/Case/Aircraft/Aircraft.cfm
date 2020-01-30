
<cfparam name="wf" default="1">
<cfparam name="url.id" default="">


<cfif url.id neq "">
	
	<cfquery name="Action" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  OrganizationObjectAction A, OrganizationObject O
		WHERE A.ObjectId = O.ObjectId
		AND   A.ActionId = '#URL.ID#'
	</cfquery>
	
	<cfparam name="URL.claimid" default="#Action.ObjectKeyValue4#">

</cfif>


<table width="99%" cellspacing="0" cellpadding="0" class="formpadding">
	<tr><td height="10"></td></tr>
	<tr><td><b><cf_tl id="Incident Details"></b></td></tr>
	<tr><td class="line"></td></tr>
	<tr><td>
	<cf_ObjectHeaderFields 
	     entityId = "#URL.claimId#"
		 filter   = ""  <!--- not operational yet, but can be used to limit the fileds here --->
		 mode     = "'header','step'"
		 caller   = "#SESSION.root#/CaseFile/Application/Claim/Aircraft/Aircraft.cfm?ClaimId=#URL.ClaimId#">
		 
	</td>	 
	</tr>
</table>


