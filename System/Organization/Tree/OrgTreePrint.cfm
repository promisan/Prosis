<cfset strVersion = SERVER.ColdFusion.ProductVersion />
<cfset strLevel = SERVER.ColdFusion.ProductLevel />

<cfset aVersion = strVersion.split(",")>


<cfif aVersion[1] gte 11>
	<cfinclude template="OrgTreePrint11.cfm">
<cfelse>
	<cfinclude template="OrgTreePrint10.cfm">	
</cfif>


