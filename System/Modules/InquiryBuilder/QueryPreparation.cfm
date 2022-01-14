
<cfquery name="Module" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM    Ref_ModuleControlDetail
	WHERE   SystemFunctionId = '#systemfunctionid#' 
	AND     FunctionSerialNo = '#functionserialno#'
</cfquery>  



<cfquery name="Param" 
	datasource="AppsInit" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM Parameter
	WHERE HostName = '#CGI.HTTP_HOST#' 	
</cfquery> 

<cfinclude template="QueryPreparationVars.cfm">

<cftry>
	<cfdirectory action="CREATE" directory="#SESSION.rootDocumentpath#\CFRStage\user\#SESSION.acc#">
	<cfcatch></cfcatch>
</cftry>

<cfif Module.preparationscript neq "">

	<cf_getmid>
	<cffile action="WRITE" 
	    file="#Param.ListingRootPath#\Listing#mid#.cfm" 
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
			<cfinclude template="/Listing/Listing#mid#.cfm">
		</cftransaction>
	
	<cfcatch>
	
	<cfinclude template="/Listing/Listing#mid#.cfm">
	
	</cfcatch>
	</cftry>

</cfif> 

