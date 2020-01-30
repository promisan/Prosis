<cfparam name="URL.orgUnit" default="">

<cfquery name="GetOrganization" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Organization
		<cfif Url.OrgUnit neq "">
		WHERE OrgUnit in (#PreserveSingleQuotes(url.OrgUnit)#)
		<cfelse>
		WHERE 1=0
		</cfif>
</cfquery>

<cfoutput>
		
	<input type="hidden" name="OrgUnit" id="OrgUnit" value="#getOrganization.OrgUnit#" >
	#getOrganization.OrgUnit#
	<cfif Url.OrgUnit neq "">
		<cfif GetOrganization.recordcount eq "1">#getOrganization.OrgUnitName#<cfelse>Invalid Orgunit</cfif>	
	</cfif>
	
</cfoutput>


	