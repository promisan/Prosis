<cfparam name="orgunit" default="">

<cfquery name="Nation" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   Code, Name 
    FROM     Ref_Nation
	WHERE    Operational = '1'
	ORDER BY Name
</cfquery>

<cfquery name="Selected" 
 datasource="AppsSystem" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 	SELECT TOP 1 Country
	FROM   Ref_Address
	WHERE  AddressId IN (
		SELECT AddressId
		FROM   Organization.dbo.OrganizationAddress
		WHERE  OrgUnit = '#url.orgunit#'
	)
 </cfquery>
 
<select name="Nationality" id="Nationality" onchange="validate()" required="Yes" message="Select Nationality" class="regularxl enterastab">
	<cfoutput query="Nation">
		<option value="#Code#" <cfif Selected.Country eq Code>selected</cfif>>#Name#</option>
	</cfoutput>
</select>	