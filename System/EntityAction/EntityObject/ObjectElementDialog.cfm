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
  <cfparam name="lookupdatasource" default="">
  <cfparam name="lookuptable" default="">
  <cfparam name="lookupselect" default="0">
          		
	<table cellspacing="0" cellpadding="0">
	
	<tr><td class="labelmedium">
	
	<cfset ds = "#LookupDataSource#">
	
	<!--- Get "factory" --->
	<CFOBJECT ACTION="CREATE"
	TYPE="JAVA"
	CLASS="coldfusion.server.ServiceFactory"
	NAME="factory">
		<CFSET dsService=factory.getDataSourceService()>

	
		<cfset dsNames = dsService.getNames()>
		<cfset ArraySort(dsnames, "textnocase")> 
	
	    <select name="lookupdatasource" id="lookupdatasource" class="regularxl" onchange="javascript:up(this.value)">
		    <option value="" selected>Not applicable</option>
			<CFLOOP INDEX="i" FROM="1" TO="#ArrayLen(dsNames)#">
				<CFOUTPUT>
					<option value="#dsNames[i]#" <cfif ds eq dsNames[i]>selected</cfif>>#dsNames[i]#</option>
				</cfoutput>
			</cfloop>
		</select>
	
	</td>
			
	<cfif ds eq "">
	  <cfset cl = "hide">
	<cfelse>
	  <cfset cl = "regular">
	</cfif>
		
	<td id="fieldlookup1" class="<cfoutput>#cl#</cfoutput>">
	
		<table>
		
		<tr>
		<td class="labelmedium" style="padding-left:8px;padding-right:4px">dbo.</td>
		
		<td>
		
		 <cfinput type="Text"
	       name         = "lookuptable"
	       value        = "#LookupTable#"
	       autosuggest="cfc:service.reporting.presentation.gettable({lookupdatasource},{cfautosuggestvalue})"
	       maxresultsdisplayed="6"
		   showautosuggestloadingicon="No"
	       typeahead    = "Yes"
	       required     = "No"
	       size         = "30"
	       maxlength    = "30"
		   class="regularxl">
		   
		   </td>
			
			</tr>
			</table>
	   
	   </td>
	  
	   <td id="fieldlookup2" class="<cfoutput>#cl#</cfoutput>"></td>
					   
  </tr>   
  
  <tr id="fieldlookup3" class="<cfoutput>#cl#</cfoutput>">
 	
	 <cfparam name="documentId" default="00000000-0000-0000-0000-000000000000">
   
     <td></td>     
	 <td colspan="3" bgcolor="white" style="padding-left:41px">
		<cf_securediv bind="url:../../EntityObject/ObjectElementField.cfm?documentid=#documentid#&fieldtype=text&lookupdatasource={lookupdatasource}&lookuptable={lookuptable}" 
		   id="tablefields"/>
	  
	 </td>
	   
     </tr> 
  
  </table>