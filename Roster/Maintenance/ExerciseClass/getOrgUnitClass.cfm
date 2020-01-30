<cfparam name="url.mission" default="">
<cfparam name="url.selected" default="">

<cfquery name="OrgUnit" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT DISTINCT OrgUnitClass
	FROM   Organization.dbo.Organization
	WHERE  Mission = '#url.mission#'

</cfquery>

<select name="OrgUnitClass" id="OrgUnitClass" class="regularxl">
    <option value=""></option>
	<cfoutput query="OrgUnit">
		<option value="#OrgUnitClass#" <cfif url.selected eq OrgUnitClass>selected</cfif>>#OrgUnitClass#</option>
	</cfoutput>
</select>