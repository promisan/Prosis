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
<cfquery name="SearchResult"
datasource="appsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM 	#CLIENT.LanPrefix#Ref_ModuleControlSectionCell
	WHERE	SystemFunctionId = '#url.id#'
	AND		FunctionSection  = '#url.section#'
</cfquery>

<table width="95%" height="100%" align="center" class="navigation_table">

	<tr><td height="10"></td></tr>

 	<TR height="20">
	   <td class="labelmedium" style="padding-left:10px;">Code</td>
	   <td class="labelmedium">Label</td>
	   <td class="labelmedium">Datasource</td>
	   <td class="labelmedium">Format</td>
	   <td align="center" class="labelmedium">
	   		<cfoutput>
	   		<a href="javascript: editSectionCell('#url.id#', '#url.section#' ,'');" title="Click to add a new section cell">
				<font color="0080FF">
					[Add new]
				</font>
			</a>
			</cfoutput>
	   </td>
    </TR>	
	
	<tr><td colspan="6" class="line"></td></tr>
	
	<cfif SearchResult.recordCount eq 0>
	<tr><td height="10"></td></tr>
	<tr>
		<td align="center" colspan="6" class="labellarge">								
		<font color="808080">
			<cfoutput>
			[ No section cells recorded ]
			</cfoutput>
		</font>
		</td>
	</tr>
	<tr><td height="10"></td></tr>
	<tr><td colspan="6" class="line"></td></tr>
	</cfif>

	<cfoutput query="SearchResult">
	 
	<tr class="navigation_row">
		
		<td height="23" class="labelmedium" style="padding-left:10px;">#CellCode#</td>
		<td class="labelmedium">#CellLabel#</td>
		<td class="labelmedium">#CellValueDatasource#</td>
		<td class="labelmedium">#CellValueFormat#</td>
		<td align="center" class="labelmedium">
		   <img style="cursor:pointer"			
		   	onclick="javascript: editSectionCell('#url.id#', '#FunctionSection#', '#CellCode#');"	    			
		    src="#SESSION.root#/Images/edit.gif" height="13" width="13" title="edit" border="0" align="absmiddle">
			&nbsp;
			<img style="cursor:pointer"
			    onclick="if (confirm('Do you want to remove this section cell ?')) removeSectionCell('#url.id#', '#FunctionSection#', '#CellCode#');"
			    src="#SESSION.root#/Images/delete5.gif" height="13" width="13" title="delete" border="0" align="absmiddle">
		</td>
	 </tr>		   		   
	<tr><td height="1" colspan="6" class="linedotted"></td></tr>
   
	</cfoutput>   

</table>

<cfset AjaxOnLoad("doHighlight")>
