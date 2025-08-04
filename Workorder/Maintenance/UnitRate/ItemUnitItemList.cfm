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

<cfparam name="url.action" default="">

<cfif url.action eq "delete">
	
	<cfquery name="Delete" 
		     datasource="AppsWorkOrder" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     DELETE FROM   ServiceItemUnitItem
			 WHERE 	ServiceItem = '#URL.ID1#'
			 AND 	Unit = '#URL.ID2#'
			 AND	ItemNo = '#URL.ItemNo#'
	</cfquery>
	
<cfelseif url.action eq "Insert">	

    <cftry>
	<cfquery name="Insert" 
		     datasource="AppsWorkOrder" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO ServiceItemUnitItem
		           (
		           ServiceItem,
		           Unit,
		           ItemNo,
		           Operational,
		           OfficerUserId,
		           OfficerLastName,
		           OfficerFirstName)
		     VALUES
		           (
		           '#url.id1#',
		           '#url.id2#',
		           '#url.ItemNo#',
		           1,
				   '#SESSION.acc#',
				   '#SESSION.last#',
				   '#SESSION.first#')
	</cfquery>
	
	<cfcatch></cfcatch>
	
	</cftry>

</cfif>

<cfquery name="List" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   I.*, (SELECT ItemDescription FROM Materials.dbo.Item WHERE ItemNo = I.ItemNo) as ItemDescription
	FROM   	 ServiceItemUnitItem I
	WHERE 	 I.ServiceItem = '#URL.ID1#'
	AND 	 I.Unit = '#URL.ID2#'
	ORDER BY I.ItemNo
</cfquery>
	
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="navigation_table">

	<tr class="labelmedium2 line fixlengthlist" height="25" valign="middle">	   
	   <td align="center"><cf_tl id="Code"></td>
	   <td><cf_tl id="Description"></td>	  
	   <td align="center" width="10%"><cf_tl id="Operational"></td>	   
	   <td></td>
	   <td></td>
    </tr>
						
	<cfif List.recordcount eq "0">
		<tr><td colspan="5" class="labelmedium" align="center" height="21"><font color="gray">No material items recorded</b></font></td></tr>
	</cfif>
					
	<cfoutput query="List">			
			
		<TR style="height:20px" class="navigation_row line labelmedium2 fixlengthlist">
		   <td align="center" height="17">#ItemNo#</td>
		   <td>#ItemDescription#</td>
		   <td align="center"><cfif operational eq 1>Yes<cfelse><b>No</b></cfif></td>			 
		   <td align="center">
				<cf_img icon="edit" navigation="Yes" onclick="showItemUnitItem('#ItemNo#', '#URL.ID1#', '#URL.ID2#')">
		   </td>				
		   <td align="center">
				<cf_img icon="delete" onclick="if (confirm('Do you want to remove this item ?')) ptoken.navigate('ItemUnitItemList.cfm?action=delete&id1=#url.id1#&id2=#url.id2#&ItemNo=#itemno#','ItemUnitItemList');">
		   </td>					
		</TR>	
													
	</cfoutput>
							
</table>

<cfset ajaxonload("doHighlight")>