
<!--- launch document from the my clearances listing --->

<cftry>
	
	<cfquery name="Object" 
	 datasource="AppsOrganization">
	 SELECT *
	 FROM OrganizationObject 		
	 WHERE (ObjectId = <cfqueryparam
						value="#URL.ID#"
						cfsqltype="CF_SQL_IDSTAMP"> 
	 OR ObjectKeyValue4 = <cfqueryparam
						value="#URL.ID#"
						cfsqltype="CF_SQL_IDSTAMP"> )
	 AND Operational  = 1 
	</cfquery>
	
	<cfif Object.recordcount gte "1" and Object.ObjectURL neq "">
		
	<cflocation url="../../#Object.ObjectURL#&mycl=1" addtoken="No"> 
	
	<cfelse>
	
	<title>Problem</title>

	<font color="gray"><b>Attention:</b> Requested document has been processed already or does not longer exist.

	
	</cfif>

<cfcatch>
	
	<title>Problem</title>

	<font color="FF0000">Requested document could not be loaded. <p>Please contact your administrator if the problem persists.

</cfcatch>

</cftry>

