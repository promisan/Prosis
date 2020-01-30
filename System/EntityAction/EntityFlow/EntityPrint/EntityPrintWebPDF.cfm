<!--- <cfset strVersion = SERVER.ColdFusion.ProductVersion />
<cfset strLevel = SERVER.ColdFusion.ProductLevel />
 
<cfset aVersion = strVersion.split(",")>
 
<cfif aVersion[1] gte 11>
	<cfinclude template="EntityPrintWorkflowIE11.cfm"> 
<cfelse>
	<cfinclude template="EntityPrintWorkflow.cfm"> 
</cfif> --->


<cfinclude template="EntityPrintWorkflow.cfm">
