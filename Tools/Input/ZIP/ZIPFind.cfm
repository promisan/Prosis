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

<cfparam name="url.fld" default="">
<cfparam name="attributes.style" default="min-width:200px">

<cfif URL.Code neq "">
	
	<!--- Query returning search results --->
	<cfquery name="SearchResult" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	    FROM  PostalCode
	    WHERE PostalCode = '#URL.Code#' 
	</cfquery>
	
	<cfset l = len(SearchResult.PostalCode)>
	<cfset k = len(SearchResult.Location)>
	
	<cfoutput>
	
	    <cfif SearchResult.recordcount eq "1">
			<input size="#k+l+4#" 
			       type="text" 
				   name="Postal" 
				   id="Postal"
				   style="#attributes.style#;min-width:260px;"
				   value="#SearchResult.Location#" 			   
				   readonly class="regularxl">				   
				 
		<cfelse>
			&nbsp;<cf_tl id="...">&nbsp;
		</cfif>
		
	
	<cfif url.fld neq "">	
		
		<script>			
			$('###url.fld#').trigger('keyup');
		</script>
		
	</cfif>
	
	</cfoutput>

</cfif>

	