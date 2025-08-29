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
	<cfparam name="url.id" default="">
	<cfparam name="dsn" default="appsOrganization">

	<cfset val = replaceNoCase("#val#", "@action", "#ActionId#" , "ALL")>
	<cfset val = replaceNoCase("#val#", "@object", "#Object.ObjectId#" , "ALL")>	
	<cfset val = replaceNoCase("#val#", "@key1", "#Object.ObjectKeyValue1#" , "ALL")>
	<cfset val = replaceNoCase("#val#", "@key2", "#Object.ObjectKeyValue2#" , "ALL")>
	<cfset val = replaceNoCase("#val#", "@key3", "#Object.ObjectKeyValue3#" , "ALL")>
	<cfset val = replaceNoCase("#val#", "@key4", "#Object.ObjectKeyValue4#" , "ALL")>
		
	<!--- runtime conversion of custom object fields --->
	
	<cfquery name="Fields" 
		 datasource="#dsn#"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">	 
	     SELECT    R.EntityCode, R.DocumentCode, R.DocumentDescription, I.DocumentItem, I.DocumentItemValue, R.DocumentId
         FROM      Organization.dbo.Ref_EntityDocument AS R INNER JOIN
                   Organization.dbo.OrganizationObjectInformation AS I ON R.DocumentId = I.DocumentId AND I.Objectid = '#Object.ObjectId#'
         WHERE     (R.EntityCode = '#Object.EntityCode#') 
		 AND       (R.DocumentType = 'field') 
	</cfquery>	       
	
	<cfloop query="fields">
	
	    <cfif documentitem eq "date">
				
			<cfif DocumentItemValue neq "">
		        <cfset dateValue = "">
				<CF_DateConvert Value="#DocumentItemValue#">
				<cfset DTE = dateValue>
				<cfset val = replaceNoCase("#val#", "@#documentcode#","#dateformat(dte,client.datesql)#", "ALL")>
			<cfelse>
			    <cfset val = replaceNoCase("#val#", "@#documentcode#","01/01/1900", "ALL")>
			</cfif>  
					
		<cfelse>
		
		   	<cfset val = replaceNoCase("#val#", "@#documentcode#","#DocumentItemValue#", "ALL")>
		
		</cfif>
		    		
	</cfloop>
	
	<cfset val = replaceNoCase("#val#", "@last",  "#SESSION.last#"  , "ALL")>
	<cfset val = replaceNoCase("#val#", "@first", "#SESSION.first#" , "ALL")>
	<cfset val = replaceNoCase("#val#", "@acc",   "#SESSION.acc#"   , "ALL")>
	
	<cfquery name="SQL" 
	 datasource="#dsn#"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">	 	 	 
	 	#preserveSingleQuotes(val)#  
	</cfquery>
	
	<script>
		Prosis.busy('no');
	</script>
	
		

		