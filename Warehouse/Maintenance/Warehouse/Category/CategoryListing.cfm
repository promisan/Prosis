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

<cfquery name="List" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*,
			(SELECT Description FROM Ref_Category WHERE Category = C.Category) AS CategoryDescription,
			(
				SELECT 	ISNULL(COUNT(*),0)
				FROM 	ItemWarehouseLocation
				WHERE 	Warehouse = C.Warehouse
				AND		ItemNo IN (SELECT ItemNo FROM Item WHERE Category  = C.Category)
			) as Validate
    FROM  	WarehouseCategory C
	WHERE 	Warehouse = '#URL.ID1#'
</cfquery>

<cf_tl id = "Yes" var = "vYes">

<table width="100%" align="left">
<tr>

<td colspan="2" style="padding-left:4px">

<table width="100%" class="navigation_table">

<tr class="line labelmedium fixlengthlist">
    
    <td style="padding-left:2px"><cf_tl id="Category"></td>
    <td align="center"><label title="Operational"><cf_tl id="Op"></label></td>
	<td align="center"><label title="Discount"><cf_tl id="Disc"></label></td>
	<td align="center"><label title="Tax"><cf_tl id="Tax"></label></td>
	<td align="center"><label title="Oversale"><cf_tl id="Os"></label></td>
	<td align="center"><label title="Selfservice"><cf_tl id="WWW"></label></td>
	<td align="center"><label title="Min order"><cf_tl id="Min"></label></td>
	<td align="center"><label title="Request Mode Petrol Oil Lubricants"><cf_tl id="POL"></label></td>
	<td></td>
	
	<td style="padding-left:2px"><cf_tl id="Category"></td>
    <td align="center"><label title="Operational"><cf_tl id="Op"></label></td>
	<td align="center"><label title="Discount"><cf_tl id="Disc"></label></td>
	<td align="center"><label title="Tax"><cf_tl id="Tax"></label></td>
	<td align="center"><label title="Oversale"><cf_tl id="Os"></label></td>
	<td align="center"><label title="Selfservice"><cf_tl id="WWW"></label></td>
	<td align="center"><label title="Min order"><cf_tl id="Min"></label></td>
	<td align="center"><label title="Request Mode Petrol Oil Lubricants"><cf_tl id="POL"></label></td>
	
	<td height="23" align="right" style="padding-left:20px">
		<cfoutput>
		<A href="javascript:editCategory('#url.id1#','')"><cf_tl id="add"></a>
		</cfoutput>
	</td>
	
</tr>

<cfif List.recordCount eq 0>
	<tr><td align="center" class="labelit line" height="25" colspan="7" style="color:red;">[<cf_tl id="No categories recorded">]</td></tr>	
</cfif>


<cfset cnt = 0>

<cfoutput query="List">
	
		<cfset cnt = cnt+1>		
		
		<cfif cnt eq "1">
		<tr class="navigation_row line labelit fixlengthlist" style="height:16px">
		<cfelse>
		   <cfset cnt = 0>
		</cfif>
		<td style="padding-left:3px">#Category# #CategoryDescription#</td>
		<td align="center"><cfif Operational eq 1>#vYes#<cfelse><b>No</b></cfif></td>		
		<td align="center">#ThresholdDiscount#%</td>	
		
		<cfquery name="TaxCodes" 
		datasource="appsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM 	Ref_Tax	
			WHERE  TaxCode = '#taxcode#'
		</cfquery>
		
		<td align="center">#TaxCodes.Description#</td>
		<td align="center"><cfif OverSale eq 1>#vYes#<cfelse><b>No</b></cfif></td>
		<td align="center"><cfif SelfService eq 1>#vYes#<cfelse><b>No</b></cfif></td>
		<td align="center">#MinReorderMode#</td>
		<td align="center"><cfif RequestMode eq 1><label title="Consolidated">C</label><cfelse><label title="Not Consolidated">NC</label></cfif></td>
		<td align="right" style="padding-top:1px; padding-left:10px;padding-right:10px;">
			<table>
				<tr>
					<cfif validate eq 0>					
					<td style="padding-right:3px">
						<cf_img icon="delete" onclick="purgeCategory('#url.id1#','#category#');">
					</td>
					</cfif>
					<td><cf_img icon="open" onclick="editCategory('#url.id1#','#category#');"></td>
					
				</tr>
			</table>
		</td>
		
		<cfif cnt eq "2">
			<cfset cnt = 0>
			</tr>
		</cfif>
		
	
</cfoutput>
</TABLE>

</td>

</TABLE>


<cfset AjaxOnLoad("doHighlight")>	
