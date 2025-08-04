<!--
    Copyright © 2025 Promisan

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

<cfparam name="URL.SystemFunctionId" default="">

<cfquery name="Header" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_ModuleControlDetail
	WHERE SystemFunctionId = '#URL.SystemFunctionId#'
	AND   FunctionSerialNo = '#url.FunctionSerialNo#'	
</cfquery>


<cftry>

    <cfset sc = replace(Header.QueryScript, "SELECT",  "SELECT TOP 1")> 
	
	<!--- -------------------------- --->
	<!--- preparation of the listing --->
	<!--- -------------------------- --->
	
	<cfset fileNo = "#Header.DetailSerialNo#">						
	<cfinclude template="QueryPreparationVars.cfm">	
	<cfinclude template="QueryValidateReserved.cfm">
			
	<cfquery name="SelectQuery" 
	datasource="#Header.QueryDataSource#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
	   #preservesinglequotes(sc)# 
	</cfquery>
	
	 <select name="DrillFieldKey" id="DrillFieldKey" style="width:200px" style="font:10px">
		<cfoutput>						 
			 <cfloop index="col" list="#SelectQuery.columnList#" delimiters=",">
			  	  <option value="#col#" <cfif col eq header.drillfieldkey>selected</cfif>>#col#</option> 
			  </cfloop>
		</cfoutput>									
	 </select>
	 
	 &nbsp;<b>Attention:</b> Must be a unique identifier if also used for deletion !

	<cfcatch>
	
	error
				
	</cfcatch>

</cftry>
	
