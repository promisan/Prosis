<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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

