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
<cfparam name="url.find" default="">

<cfquery name="Item" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     IM.Description AS ItemMaster, C.Description, I.ItemNo, I.ItemDescription, I.Classification, I.Classification+' '+I.ItemDescription as ItemName, IM.Code
		FROM       Item I INNER JOIN Purchase.dbo.ItemMaster IM ON I.ItemMaster = IM.Code INNER JOIN Ref_Category C ON I.Category = C.Category
		WHERE      I.ItemClass = 'Service' 
		AND        I.ItemNo IN
		                   (SELECT  ItemNo
		                    FROM    ItemUoMMission
		                    WHERE   Mission = '#url.Mission#' 
						    AND     ItemNo  = I.ItemNo)
					 
		AND        (I.Classification LIKE '%#url.find#%' OR I.ItemDescription LIKE '%#url.find#%')					 
		ORDER BY   C.Description, I.ItemMaster, I.ItemNo, I.ItemDescription
</cfquery>

<table width="100%" class="navigation_table">
	<cfif Item.recordcount eq "0">
		<tr><td class="labelit" align="center" height="70"><font color="#808080">No items found</font></td></tr>	
	</cfif>
	<cfoutput query="Item" group="Description">
		<tr><td class="labellarge" style="height:40px">#Description#</td></tr>
		<!--- <cfoutput group="ItemMaster"> <tr><td style="padding-left:5px" class="labelmedium"><b>#ItemMaster#</td></tr> --->
		<cfoutput>
		<tr class="navigation_row"><td width="100%" style="padding-left:10px" class="navigation_action labelit" onclick="selectitem('#itemno#')">#ItemName#</td></tr>
		</cfoutput>		
		<!--- </cfoutput> --->
	</cfoutput>									
</table>

<cfset AjaxOnLoad("doHighlight")>	