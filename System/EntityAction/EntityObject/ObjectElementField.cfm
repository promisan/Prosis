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

 <cfif url.fieldtype eq "text">
 
 <table class="formpadding">	
 
 	  <cfquery name="Val" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  * FROM Ref_EntityDocument
			WHERE    DocumentId = '#URL.documentid#'		
	  </cfquery>						  
				   
	  <cfquery name="Field" 
		datasource="AppsControl" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   FieldName
			FROM     DictionaryTableField
			WHERE    DataSource = '#url.lookupdatasource#' 
			AND      TableName = '#url.lookupTable#'
			ORDER BY FieldOrder
	  </cfquery>			   
   
      <tr><td class="labelmedium" width="198"><cf_tl id="Key"></td>
	  <td>
	  
	  <cfif Field.recordcount eq "0">
	  <input name="LookupFieldKey" id="LookupFieldKey" class="regularxl" style="width:300px" value="<cfoutput>#val.lookupfieldkey#</cfoutput>">
	  <cfelse>
	  <select name="LookupFieldKey" id="LookupFieldKey" class="regularxl">
	  <cfoutput query="Field">
	  	<option value="#FieldName#" <cfif fieldname eq val.lookupfieldkey>selected</cfif>>#FieldName#</option>
	  </cfoutput>
	  </select>
	  </cfif>
	  </td>	 
	  </tr>
	  <tr>
      <td class="labelmedium"><cf_tl id="Descriptive">:</td>
	  <td>
	  <cfif Field.recordcount eq "0">
	  <input name="LookupFieldName" id="LookupFieldName" class="regularxl" style="width:300px" value="<cfoutput>#val.lookupfieldname#</cfoutput>">
	  <cfelse>
	  <select name="LookupFieldName" id="LookupFieldName" class="regularxl">
	  <cfoutput query="Field">
	  	<option value="#FieldName#" <cfif fieldname eq val.lookupfieldname>selected</cfif>>#FieldName#</option>
	  </cfoutput>
	  </select>		
	  </cfif>			  
	   </td>
	  </tr>
   </table>
   
</cfif>   