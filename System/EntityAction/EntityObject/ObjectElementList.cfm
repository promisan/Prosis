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
	   
	   <td class="labelmedium2">Multiple Select:</td>
  	   <td><input type="radio" class="radiol" name="FieldSelectMultiple" id="FieldSelectMultiple" value="0" <cfif FieldSelectMultiple neq "1">checked</cfif>></td><td style="padding-left:4px;padding-right:10px" class="labelit">No</td>
	   <td><input type="radio" class="radiol" name="FieldSelectMultiple" id="FieldSelectMultiple" value="1" <cfif FieldSelectMultiple eq "1">checked</cfif>></td><td style="padding-left:4px" class="labelit">Yes</td>
	   
	   </tr>
	   
  </table>
   