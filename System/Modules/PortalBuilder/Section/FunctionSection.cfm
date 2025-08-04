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

<cfquery name="SearchResult"
datasource="appsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM 	#CLIENT.LanPrefix#Ref_ModuleControlSection
	WHERE	SystemFunctionId = '#url.id#'
	ORDER BY ListingOrder
</cfquery>

<table width="85%" align="center" class="navigation_table">

	<tr><td height="10"></td></tr>

 	<TR height="20">	 	
	   <td class="labelmedium" align="center">Order</td>
	   <td class="labelmedium">Code</td>
	   <td class="labelmedium">Name</td>
	   <td class="labelmedium">Icon Class</td>
	   <!--- <td class="labelmedium" align="center">Presentation</td> --->
	   <td class="labelmedium" align="center">
	   		<cfoutput>
	   		<a href="javascript: editSection('#url.id#', '');" title="Click to add a new section">
				<font color="0080FF">
					[Add new]
				</font>
			</a>
			</cfoutput>
	   </td>
    </TR>	
	
	<tr><td colspan="6" class="linedotted"></td></tr>
	
	<cfif SearchResult.recordCount eq 0>
	<tr><td height="10"></td></tr>
	<tr>
		<td align="center" colspan="6" class="labellarge">								
		<font color="808080">
			<cfoutput>
			[ No sections recorded ]
			</cfoutput>
		</font>
		</td>
	</tr>
	<tr><td height="10"></td></tr>
	<tr><td colspan="6" class="linedotted"></td></tr>
	</cfif>

	<cfoutput query="SearchResult">
	 
	<tr class="navigation_row">
		
		<td align="center" height="23" class="labelmedium">#ListingOrder#</td>
		<td class="labelmedium">#FunctionSection#</td>
		<td class="labelmedium">#SectionName#</td>
		<td class="labelmedium">#SectionIcon#</td>
		<!--- <td class="labelmedium" align="center">#SectionPresentation#</td> --->
		<td class="labelmedium" align="center">
		   <img style="cursor:pointer"			
		   	onclick="javascript: editSection('#url.id#', '#FunctionSection#');"	    			
		    src="#SESSION.root#/Images/edit.gif" height="13" width="13" title="edit" border="0" align="absmiddle">
			&nbsp;
			<img style="cursor:pointer"
			    onclick="if (confirm('Do you want to remove this section and all its details ?')) removeSection('#url.id#', '#FunctionSection#');"
			    src="#SESSION.root#/Images/delete5.gif" height="13" width="13" title="delete" border="0" align="absmiddle">
		</td>
	 </tr>		   		   
	<tr><td colspan="6" class="linedotted"></td></tr>
   
	</cfoutput>   

</table>

<cfset AjaxOnLoad("doHighlight")>
