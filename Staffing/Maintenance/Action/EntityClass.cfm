<cfset vActionSource = url.ActionSource>
<cfset vEntityCode = "">

<cfif vActionSource eq "Assignment">
	<cfset vEntityCode = "Assignment">
<cfelseif vActionSource eq "Dependent">
	<cfset vEntityCode = "Dependent">
<cfelseif vActionSource eq "SPA">
	<cfset vEntityCode = "PersonSPA">
<cfelseif vActionSource eq "Person">
	<cfset vEntityCode = "PersonAction">
<cfelse>
	<cfset vEntityCode = "">
</cfif>

<cfif vEntityCode neq "">

	<cfquery name="WF" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM 	Ref_EntityClass
			WHERE	EntityCode = '#vEntityCode#'
	</cfquery>
	<select name="EntityClass" class="regularxl">		
		<cfoutput query="WF">
			<option value="#EntityClass#" <cfif EntityClass eq url.entityClass>selected</cfif>>#EntityClassName#</option>
		</cfoutput>
	</select>
	
<cfelse>

    <table>
	<tr><td class="labelmedium">Standard</td></tr>    
	</table>
	<input name="EntityClass" type="Hidden" value="Standard">
	
</cfif>