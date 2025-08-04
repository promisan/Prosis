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
<cfparam name="URL.UoM" default="">

<cfif URL.UoM eq "">

	<!--- we get a default uom --->
	
	<cfquery name="GetUoM" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT 	TOP 1 U.*
	    FROM 	ItemUoM U
		WHERE	U.ItemNo = '#URL.ItemNo#'
	</cfquery>		
	
	<cfset URL.Uom = GetUoM.UoM> 
	
</cfif>	

<cfquery name="getCurrent" 
	datasource="AppsMaterials"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   TOP 1 *
	FROM     ItemBOM 
	WHERE	 ItemNo  = '#URL.ItemNo#'
	AND      UoM     = '#URL.UoM#' 
	AND      Mission = '#URL.mission#'
	ORDER BY DateEffective ASC	
</cfquery>

<cfquery name="ItemMaterial" 
	datasource="AppsMaterials"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  BD.MaterialId,
	        I.ItemDescription,
	        BD.MaterialItemNo,
			BD.MaterialUoM,
			BD.MaterialQuantity, 
			BD.MaterialMemo,
			U.UoMDescription
	FROM    ItemBOM B 
	        INNER JOIN ItemBOMDetail BD ON B.BOMId = BD.BOMId 
	        INNER JOIN Materials.dbo.Item I	ON BD.MaterialItemNo = I.ItemNo 
			INNER JOIN Materials.dbo.ItemUoM U ON U.ItemNo = I.ItemNo AND U.UoM = BD.MaterialUoM
	<cfif getCurrent.BOMId neq "">
	WHERE	B.BOMId = '#getCurrent.BOMid#'		
	<cfelse>
	WHERE   1= 0
	</cfif>
</cfquery>
			
<table width="100%" class="navigation_table" padding="4">

	<cfif ItemMaterial.recordcount eq "0">
	
		<tr><td class="labelmedium" align="center" height="70"><font color="gray"><cf_tl id="No BOM associated to this item"></font></td></tr>	
	
	<cfelse>
	
		<cfoutput>
		
			<tr>
				<td height="20"><input type="checkbox" name="chk_all" value="" onclick="selectall(this)"></td>
				<td class="labelit"><cf_tl id="Select all"></td>
			</tr>	
			
			<tr><td colspan="5" class="line"></td></tr>
			
			<cfloop query="ItemMaterial">
				<tr class="labelit">
					<td width="10%"><input type="checkbox" name="chk_material" value="#MaterialId#"></td>	
					<td>#ItemDescription#</td>
					<td>#UoMDescription#</td>
					<td>#MaterialMemo#</td>
					<td style="padding-right:5px" align="right">#MaterialQuantity#</td>				
				</tr>
			</cfloop>
			
		</cfoutput>
		
	</cfif>
	
</table>
