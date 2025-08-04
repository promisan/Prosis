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

<cfquery name="CheckForKey" 
   datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_ModuleControlDetailField
		WHERE  SystemFunctionId = '#URL.SystemFunctionId#'		
		AND    FunctionSerialNo = '#URL.FunctionSerialNo#'
		AND    FieldIsKey = 1
</cfquery>

<cftry>

    <cfset sc = replace(Header.QueryScript, "SELECT",  "SELECT TOP 1")> 
	
	<cfoutput>
		<cfsavecontent variable="sc">	
			SELECT *
			FROM (#preservesinglequotes(sc)#) as D
			WHERE 1=0		
		</cfsavecontent>		
		</cfoutput>
	
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
		
	<cfquery name="Entity" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
	   SELECT  *
	   FROM    Ref_Entity
	   WHERE   EntityKeyField1 IN ('#CheckForKey.fieldName#') OR EntityKeyField4 IN ('#CheckForKey.fieldName#')
	</cfquery>
			
	 <select name="EntityCode" id="EntityCode" class="regularxl" style="border:0px">
	    <option value="">Not applicable</option>					 
			 <cfoutput query="entity">		
			     <cfif CheckForKey.fieldName neq "">	 
			  	  <option value="#entitycode#" <cfif entitycode eq header.entitycode>selected</cfif>>#entitycode#</option> 
				  </cfif>
			 </cfoutput>									
	 </select>
	 
	
	<cfcatch>
	
	error
				
	</cfcatch>

</cftry>
	
