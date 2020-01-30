
<cfquery name="Unit" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	  SELECT *
	  FROM   Organization
	  WHERE  OrgUnit = '#URL.OrgUnit#' 
</cfquery>

<cfoutput>

	<input type="text" class="regular" name="orgunitname1" value="#Unit.OrgUnitName#" size="60" maxlength="60" readonly>
	<input type="hidden" name="orgunit1" value="#Unit.OrgUnit#">
	
</cfoutput>
