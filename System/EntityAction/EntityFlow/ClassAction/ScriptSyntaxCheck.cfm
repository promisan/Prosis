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

 <cfparam name="url.method"  default="Embed">
 <cfparam name="form.#url.method#script"  default="">
 
 <cfset script = evaluate("form.#url.method#script")>

 <cfset val = Script>
 
 <cfset key1   = "0">
 <cfset key2   = "0">
 <cfset key3   = "0">
 <cfset key4   = "{00000000-0000-0000-0000-000000000000}">
 <cfset action = "{00000000-0000-0000-0000-000000000000}">
 <cfset object = "{00000000-0000-0000-0000-000000000000}">
		 
 <cfset val = replaceNoCase("#val#", "@key1",   "#key1#" , "ALL")>
 <cfset val = replaceNoCase("#val#", "@key2",   "#key2#" , "ALL")>
 <cfset val = replaceNoCase("#val#", "@key3",   "#key3#" , "ALL")>
 <cfset val = replaceNoCase("#val#", "@key4",   "#key4#" , "ALL")>
 
 <!--- runtime conversion of custom object fields --->
	
<cfquery name="Fields" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">	 
     SELECT    R.EntityCode, R.DocumentCode, R.DocumentDescription, I.DocumentItem, I.DocumentItemValue, R.DocumentId
        FROM      Ref_EntityDocument AS R LEFT OUTER JOIN
                  OrganizationObjectInformation AS I ON R.DocumentId = I.DocumentId AND I.Objectid = '#Object.ObjectId#'
        WHERE     (R.EntityCode = '#url.EntityCode#') 
	 AND       (R.DocumentType = 'field')
</cfquery>	       

<cfloop query="fields">

    <cfif documentitem eq "date">
	
		<cfset val = replaceNoCase("#val#", "@#documentcode#","01/01/1900", "ALL")>
	    	
	<cfelse>
	
	   	<cfset val = replaceNoCase("#val#", "@#documentcode#","customvalue", "ALL")>
	
	</cfif>
	    		
</cfloop>
  
<cfset val = replaceNoCase("#val#", "@object", "#object#" , "ALL")>
<cfset val = replaceNoCase("#val#", "@action", "#action#" , "ALL")>
<cfset val = replaceNoCase("#val#", "@acc",    "#SESSION.acc#" , "ALL")>
<cfset val = replaceNoCase("#val#", "@last",   "#SESSION.last#" , "ALL")>
<cfset val = replaceNoCase("#val#", "@first",  "#SESSION.first#" , "ALL")>
						  
 <cftry>
  				 									 				
	<cfquery name="SQL" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">	  	
	    <cfoutput>
		#preserveSingleQuotes(val)# 
		</cfoutput>
	 </cfquery>
	 
	 <script>
		 alert("Script has been successfully validated !")
	 </script>				 
				 
	 <cfcatch>
	    <script>
	 	 alert("Script has errors.")
		</script>
	 </cfcatch>				 
	   		 
 </cftry> 	