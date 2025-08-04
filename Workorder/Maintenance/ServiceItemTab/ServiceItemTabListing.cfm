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

<cfquery name="Tab" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    ServiceItemTab
	WHERE 	Code  = '#URL.ID1#'
	AND     Mission IN (SELECT Mission FROM Organization.dbo.Ref_MissionModule WHERE SystemModule = 'WorkOrder')
	ORDER BY Mission, TabOrder asc
</cfquery>

<table width="100%" class="formpadding navigation_table">

	<tr><td height="7"></td></tr> 

	<tr>
		<td align="right" colspan="12">
			<cfoutput>
			<input class="button10g" type="Button" name="AddRecord" id="AddRecord" value=" Add New "
			 	onclick="showitemtab('', '#URL.ID1#', '')">
			</cfoutput>
		</td>
	</tr>

	<tr><td height="7"></td></tr> 

 	<TR class="line labelmedium2" height="18">	 	
	   <td width="5"></td>
	   <td>Name</td>	  
	   <td align="center">Order</td>
	   <td align="center">Icon</td>
	   <td>Template</td>
	   <td align="center">Read</td>
	   <td align="center">Edit</td>
	   <td align="center">Mode</td>
	   <td align="center">Op.</td>
	   <td>Created</td>
	   <td></td>
	   <td></td>
    </TR>	
		
	<tr><td height="7"></td></tr> 

<cfoutput query="Tab" group="mission">	
	
	<TR>	
		<td width="5"></td>
		<td colspan="12" class="labelmedium"><b>#Mission#</b></td>	  		
   </tr>
   <tr><td height="7"></td></tr>		   
          
   <cfoutput>   
	 
		<tr class="navigation_row line labelmedium2">
			
			<td></td>
			<td>#tabName#</td>	  
			<td align="center">#tabOrder#</td>
			<td align="center"><cfif trim(tabIcon) neq ""><img src="#SESSION.root#/Images/#tabIcon#" height="22" width="22" alt="#SESSION.root#/Images/#tabIcon#" border="0" align="absmiddle"></cfif></td>				
			<td>#tabTemplate#</td>
			<td align="center">#AccessLevelRead#</td>
			<td align="center">#AccessLevelEdit#</td>
			<td align="center">#modeOpen#</td>
			<td align="center"><cfif operational eq "0"><b>No</b><cfelse>Yes</cfif></td>	   				
			<td>#dateformat(created,CLIENT.DateFormatShow)#</td>		   	      	   		   
			<td align="center" width="20">
				<cf_img icon="edit" navigation="true" onclick="showitemtab('#mission#', '#code#', '#tabName#')">
			</td>
			<td align="center" width="20">
				<cf_img icon="delete" onclick="if (confirm('Do you want to remove this record ?')) ptoken.navigate('#SESSION.root#/workorder/maintenance/ServiceItemTab/ServiceItemTabPurge.cfm?ID1=#mission#&ID2=#code#&ID3=#tabName#','contentbox2');">
			</td>
			
		</tr>		   		   
	  
   </cfoutput>
   
   <tr><td height="10"></td></tr>
   
</cfoutput>   

</table>

<cfset ajaxonload("doHighlight")>
