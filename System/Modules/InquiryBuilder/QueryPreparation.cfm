
<cfparam name="functionserialNo" default="1">

<cfquery name="Module"
		datasource="AppsSystem"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
		SELECT  *
		FROM    Ref_ModuleControlDetail
		WHERE   SystemFunctionId = '#systemfunctionid#'
	    AND     FunctionSerialNo = '#functionserialno#'
</cfquery>

<cfinclude template="QueryPreparationVars.cfm">

<cftry>
	<cfdirectory action="CREATE" directory="#SESSION.rootDocumentpath#\CFRStage\user\#SESSION.acc#">
	<cfcatch></cfcatch>
</cftry>

<cfif Module.preparationscript neq "">

	<cffile action="WRITE"
			file="#SESSION.rootDocumentpath#\CFRStage\user\#SESSION.acc#\Listing.cfm"
			output="#Module.preparationscript#"
			addnewline="Yes"
			fixnewline="No">

	<cfloop index="t" from="1" to="20">
		<cfset tbl  = Evaluate("Answer" & #t#)>
		<cfif tbl neq "">
			<CF_DropTable dbName="appsQuery" tblName="#tbl#" timeout="6">
		</cfif>
	</cfloop>

	<cfparam name="url.mission" default="">

	<cftry>

		<cftransaction isolation="read_uncommitted">
			<cfoutput>
				#Module.preparationscript#
			</cfoutput>
		</cftransaction>

		<cfcatch>

			<cfoutput>
				#Module.preparationscript#
			</cfoutput>

		</cfcatch>
	</cftry>

</cfif>

