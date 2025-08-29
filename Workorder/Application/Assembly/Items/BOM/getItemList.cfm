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
<cfparam name="url.class" default="Supply">

<cfquery name="Item" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     IM.Description AS ItemMaster, 
		           C.Description, 
				   I.ItemNo, 
				   I.ItemDescription, 
				   I.Classification, 
				   I.ItemDescription, 
				   IM.Code
		FROM       Item I 
		           INNER JOIN Purchase.dbo.ItemMaster IM ON I.ItemMaster = IM.Code 
				   INNER JOIN Ref_Category C ON I.Category = C.Category			
		
		<!--- change done by dev on 1/22/2014 --->
		
		<cfif url.class eq "Supply">
		WHERE      (
						(I.ItemClass IN ('Supply','Service') AND I.Category IN (SELECT Category FROM Ref_Category WHERE FinishedProduct = '0'))
						<!--- exclude final product items --->
						OR
						(I.ItemClass='Supply' AND I.Category IN (SELECT Category FROM Ref_Category WHERE FinishedProduct = '1'))
					)		
		<cfelse>
		WHERE      ( 
					 I.ItemClass IN ('Service') 
		               OR
					 I.Category IN (SELECT Category FROM Ref_Category WHERE RawMaterial = '1')
					 )
		</cfif>		
		   
		<!--- if item belongs to the mission --->
		
		AND        I.ItemNo IN (SELECT ItemNo FROM Materials.dbo.ItemUoMMission WHERE ItemNo = I.ItemNo AND Mission = '#url.mission#') 
		
		AND        (I.Classification LIKE '%#url.find#%' OR I.ItemDescription LIKE '%#url.find#%')	
		
		AND        I.Operational = '1'				
				 
		ORDER BY   C.Description, I.ItemMaster, I.ItemNo, I.ItemDescription
		
</cfquery>

<table width="100%" cellspacing="0" cellpadding="0" class="navigation_table">

	<cfif Item.recordcount eq "0">
		<tr><td class="labelit" align="center" height="70"><font color="#808080">No items found..</font></td></tr>	
	</cfif>
	
	<cfoutput query="Item" group="Description">
	
		<tr><td style="height:40px" class="labellarge line"><b>#Description#</td></tr>	
		<td><td></td></td>	
		
		<cfoutput>
		<tr class="navigation_row labelit">
		   <td width="100%" style="padding-left:10px" class="navigation_action line" onclick="selectresourceitem('#itemno#','#url.mission#')">#ItemDescription# <cfif Classification neq "">(#classification#)</cfif></td>
	    </tr>
		</cfoutput>		
				
	</cfoutput>		
								
</table>

<cfset AjaxOnLoad("doHighlight")>	
