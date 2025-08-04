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
   
  <cfparam name="fieldselectmultiple" default="0">
  <cfparam name="ObjectUsage" default="">
  
  <table class="formpadding">
     	   
	   <tr class="fixlengthlist">
	   
	   <cfif documentMode eq "Step" or documentMode eq "Header" or documentmode eq "-1">
	  
	   <td>Usage:</td>
	   <td>
	   
	   <cfquery name="ObjectList" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM  Ref_EntityUsage
				WHERE EntityCode = '#URL.EntityCode#' 						
		</cfquery>
		
		<cfset val = ObjectUsage>
		
		<select name="ObjectUsage" type="text">
		 <option value=""><cf_tl id="N/A"></option>
		 <cfoutput query="ObjectList">
		     <option value="#ObjectUsage#" <cfif ObjectUsage eq val>selected</cfif>>#ObjectUsageName#</option>
		 </cfoutput>
		</select>	   
	   
	   </td>
	  	   
	   <cfelse>
	   
	   <input type="hidden" name="ObjectUsage" value="">
	   
	   </cfif>
	   
	 
	   </tr>
	   
  </table>
   