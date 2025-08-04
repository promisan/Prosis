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

<cf_tl id="Prior Searches" var="vResult">

<cf_UItree id="root" title="<span style='font-size:16px;color:gray;padding-bottom:3px'>#vResult#</span>" expand="Yes">
	
	<cfquery name="Date" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		  SELECT   DISTINCT Created
		  FROM     PersonSearch
		  WHERE    Status        = '1'
		  AND      OfficerUserId = '#SESSION.acc#'
		  ORDER BY Created DESC
	</cfquery>

	<cfloop query = "Date">
	
		<cfif currentrow eq "1">
			<cfset exp = "Yes">
		<cfelse>
			<cfset exp = "No">	
		</cfif>
	 
	  <cfset CreatedDate = DateFormat(Date.Created, CLIENT.DateFormatShow)>
	  
	  <cf_UItreeitem value="#CreatedDate#"
	        display="<span style='font-size:16px;padding-bottom:3px;font-weight:bold' class='labelit'>#CreatedDate#</span>"												
			parent="root" 
			expand="#Exp#">		
	  
		  <cfquery name="DateSearch" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  SELECT  SearchId, Description
			  FROM    PersonSearch
			  WHERE   Status        = '1'
			  AND     OfficerUserId = '#SESSION.acc#'
			  AND     Created       = '#DateFormat(Created, CLIENT.DateSQL)#'      
		  </cfquery>
	
		  <cfloop query="DateSearch">
		  
		  <cf_UItreeitem value="#SearchId#"
			        display="<span style='font-size:14px' class='labelit'>#SearchId# #Description#</span>"						
					href="SearchTree.cfm?ID1=#SearchId#&Mission=#URL.Mission#"		
					target="left"		
					parent="#CreatedDate#">	
					
		  </cfloop>
	  
	</cfloop>    

</cf_UItree>
