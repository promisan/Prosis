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
<cfparam name="client.header" default="">

<cfquery name="Get" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM ItemMaster
		WHERE Code = '#URL.ID1#'
</cfquery>

<cfoutput>

	<cfsavecontent variable="myquery">		
	
		SELECT     I.ItemNo, 
		           I.ItemDescription, 
				   U.UoMDescription, 
				   I.Category, 
				   R.Description, 
				   I.ItemMaster, 
				   I.ItemNoExternal, 
				   I.Classification, 
				   I.Operational,
		              (SELECT     SUM(TransactionQuantityBase) AS Expr1
		               FROM       ItemTransaction
					   WHERE      Mission = '#URL.Mission#'
		               AND        ItemNo = I.ItemNo 
					   AND        TransactionUoM = U.UoM
					   ) AS OnHand, 
				   I.Created
				   
		FROM       Item AS I INNER JOIN
		           Ref_Category AS R ON I.Category = R.Category INNER JOIN
		           ItemUoM AS U ON I.ItemNo = U.ItemNo
		WHERE      ItemMaster = '#URL.ID1#' 		   
						  
	</cfsavecontent>					  

</cfoutput>

<table width="100%" border="0" height="100%" align="center">
	
	<tr height="20">
		<td height="10" class="labelit" width="10%" style="padding-left:8px;"><cf_tl id="Is UoM Each">:</td>
	    <td width="70%" class="labelit">
			<cfoutput>
			<table><tr><td class="labelmedium">
			
				<input type="radio" name="IsUoMEach" id="IsUoMEach" onclick="saveUoMEach('#url.id1#',this);" <cfif get.IsUoMEach eq "1">checked</cfif> value="1"><cf_tl id="Yes, all item/uoms can be treated as a unit">
				</td>
				<td style="padding-left:5px"  class="labelit">
				<input type="radio" name="IsUoMEach" id="IsUoMEach" onclick="saveUoMEach('#url.id1#',this);" <cfif get.IsUoMEach eq "0">checked</cfif> value="0"><cf_tl id="No, every item/uom may be different">			
			</td></tr>
			</table>	
			</cfoutput>
	    </td>
		<td id="processUomEach">
		</td>
    </tr>
	
	<tr height="100%">
	
		<td height="100%" colspan="3">
		
			<cfset fields=ArrayNew(1)>
				
			<cfset fields[1] = {label       = "No",                  
								field       = "ItemNo",		
								alias       = "I",
								functionscript    = "item",			
								search      = "text"}>		
							
			<cfset fields[2] = {label       = "Name",                  
								field       = "ItemDescription",					
								search      = "text"}>	
												
			<cfset fields[3] = {label       = "UoM",                  
								field       = "UoMDescription"}>					
			
			<cfset fields[4] = {label       = "Category",                  
								field       = "Description"}>		
									
			<cfset fields[5] = {label       = "Reference", 					
								field       = "Classification"}>	
								
			<cfset fields[6] = {label       = "Op.", 					
								field       = "Operational",										
								align       = "center",
								formatted   = "YesNoFormat(Operational)"}>	
									
			<cfset fields[7] = {label       = "Entered",  					
								field       = "Created",					
								formatted   = "dateformat(Created,'#CLIENT.DateFormatShow#')"}>	
								
			<cfset fields[8] = {label       = "On Hand", 					
								field       = "OnHand",		
								Sort        = "No",								
								align       = "right",
								formatted   = "numberformat(OnHand,'__,__')"}>						
				
			<cf_listing
				header        = "Warehouseitems"		
				box           = "warehouse"
				link          = "#SESSION.root#/Procurement/Maintenance/Item/Items/WarehouseListing.cfm?id1=#url.id1#&mission=#URL.Mission#"
				html          = "No"
				show          = "24"
				datasource    = "AppsMaterials"
				listquery     = "#myquery#"		
				listorder     = "ItemNo"
				listorderalias = "I"
				listorderdir  = "ASC"
				height        = "100%"
				headercolor   = "ffffff"
				listlayout    = "#fields#"
				filterShow    = "Yes"
				excelShow     = "Yes"
				drillmode     = ""	
				drillargument = "800;900;true;true">
				
		</td>
	</tr>
</table>