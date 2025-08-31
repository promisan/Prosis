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
<cfquery name="qListing" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	I.*,
			(SELECT ItemDescription FROM Materials.dbo.Item WHERE ItemNo = I.ItemNo) as ItemDescription
	FROM   	ServiceItemUnitItem I
	WHERE 	I.ServiceItem = '#URL.ID1#'
	AND 	I.Unit = '#URL.ID2#'
	ORDER BY I.ItemNo
</cfquery>

<cfif url.id2 neq "">
	
	<table width="100%" cellspacing="2" cellpadding="2"  align="center">
				
		<TR class="line">
			<TD style="height:40px;font-weight:bold" colspan="2" class="labellarge">Equipment associated to service unit</TD>	
		
			<td align="right" colspan="3" class="labelit">
				
				<cfset link = "ItemUnitItemList.cfm?id1=#url.id1#&id2=#url.id2#">		
	
			    <cf_selectlookup
				    box          = "ItemUnitItemList"
					link         = "#link#"
					button       = "Yes"
					close        = "No"	
					title        = "Add Unit Item"											
					class        = "ItemOneClick"
					des1         = "ItemNo"
					filter1      = "ServiceItem"
					filter1value = "#url.id1#">
					
			</td>
		</tr>
		
		<tr><td colspan="5" class="line"></td></tr>
		
		<tr>
		
			<td colspan="5">
			
				<cfdiv id = "ItemUnitItemList">
					<cfinclude template="ItemUnitItemList.cfm">
				</cfdiv>			
			
			</td>
		
		</tr>								
					
	</table>	

</cfif>	