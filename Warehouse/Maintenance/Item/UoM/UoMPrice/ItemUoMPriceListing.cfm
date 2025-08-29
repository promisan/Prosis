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
	<cfquery name="CheckMission" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT TOP 1 *
		FROM 	ItemUoMPrice
		WHERE 	Mission = '#URL.selectedMission#'
	</cfquery>
	
	<cfif CheckMission.recordCount eq 0><cfset URL.selectedMission = ""></cfif>
	
	<cfquery name="UoMPrice" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	P.*, 
				ISNULL(W.WarehouseName, 'For All Warehouses') as WarehouseName, 
				S.Description as PriceScheduleName,
				(SELECT Description FROM Accounting.dbo.Ref_Tax WHERE TaxCode = P.TaxCode) as TaxDescription
		FROM 	ItemUoMPrice P INNER JOIN Ref_PriceSchedule S ON P.PriceSchedule = S.Code
				LEFT OUTER JOIN Warehouse W	ON P.Warehouse = W.Warehouse
		WHERE 	P.ItemNo = '#URL.ID#'
		AND		P.UoM = '#URL.UoM#'
		<cfif trim(URL.selectedMission) neq "">AND P.Mission = '#URL.selectedMission#'</cfif>
		ORDER BY P.Mission, P.Warehouse, P.PriceSchedule, P.DateEffective
	</cfquery>
	
	<table width="97%" align="center" class="navigation_table">
	
	<tr class="labelmedium2 line">
		<td style="height:30px;padding-left:4px" colspan="8">
		
			<cf_tl id="Entity">: &nbsp;
			<cfquery name="getLookup" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT 	*
				FROM 	Ref_ParameterMission
				WHERE	Mission in (SELECT Mission
				                    FROM   ItemUoMPrice 
									WHERE  ItemNo = '#URL.ID#' 
									AND    UoM    = '#URL.UoM#')
			</cfquery>
			<cfoutput>
			<select name="missionfilter" id="missionfilter" class="regularxxl"
				onchange="ptoken.navigate('UoMPrice/ItemUoMPriceListing.cfm?id=#url.id#&UoM=#URL.UoM#&selectedMission='+this.value,'itemUoMPricelist')">
				<option value="">-- Any --</option>
				<cfloop query="getLookup">
				  <option value="#getLookup.mission#" <cfif getLookup.mission eq url.selectedmission>selected</cfif>>#getLookup.mission#</option>
			  	</cfloop>
			</select>
			</cfoutput>
			
		</td>
	</tr>
			
	<cfoutput>
	<tr height="20" class="labelmedium2 line">	    		
		<td align="center" colspan="3"><a class="navigation_action" href="javascript:uompriceedit('#URL.ID#', '#URL.UoM#', '', '#URL.selectedmission#')"><cf_tl id="New Price"></a></td>		
		<td><cf_tl id="Effective"></td>				
		<td><cf_tl id="Tax"></td>
		<td align="center"><cf_tl id="Calculation Mode"></td>
		<td align="center"><cf_tl id="Currency"></td>
		<td align="right"><cf_tl id="Price">&nbsp;</td>
	</tr>
			
	<cfif UoMPrice.recordCount eq 0>
		<tr><td colspan="8" align="center" class="labelmedium" style="color:808080;"><cf_tl id="No prices recorded"></td></tr>	
	</cfif>
	
	</cfoutput>	
	
	<cfoutput query="UoMPrice" group="Mission">
	
	<tr><td height="20" style="font-size:20px;padding-left:5px" class="labellarge" colspan="8">#Mission#</td></tr>
	
	<cfoutput group="Warehouse">
	
	<tr class="labelmedium2">
	    <td></td>
		<td height="20" colspan="7">#WarehouseName#</td>
	</tr>
	
	<cfoutput group="PriceSchedule">
	
	<tr class="labelmedium2">
	    <td></td>
		<td></td>
		<td height="20" colspan="7">#PriceScheduleName#</td>
	</tr>
	
	<cfoutput>
	
	<tr class="navigation_row labelmedium2 line" style="height:15px">
	
	  <td width="20"></td>
	  <td width="20"></td>
	  <td width="80" align="center">
	  
	  	<table cellspacing="0" cellpadding="0">
			<tr>
			<td style="padding-top:2px">
				<cf_img icon="edit" onClick="javascript:uompriceedit('#URL.ID#', '#URL.UoM#', '#PriceId#', '#URL.selectedmission#')">		
			</td>
			<td style="padding-left:6px;padding-top:3px">			
				<cf_img icon="delete" onClick="uompricedelete('#URL.ID#', '#URL.UoM#', '#PriceId#', '#URL.selectedmission#')">		  						  
			</td>
			</tr>
		</table>	  		 
	  
	  </td>
	  <td>#Dateformat(DateEffective, "#CLIENT.DateFormatShow#")#</td>	  
	  <td>#TaxDescription#</td>		  
	  <td align="center">#CalculationMode#</td>
	  <td align="center">#Currency#</td>
	  <td align="right" style="padding-right:3px">#LSNumberFormat(SalesPrice, ",.__")#</td>
	</tr>  
	</cfoutput>
	</cfoutput>
	</cfoutput>
	</cfoutput>
	
	<tr><td height="1" class="line" colspan="8"></td></tr>	
	<tr><td height="7" colspan="8"></td></tr>
	
	<!--- <tr>
		<td align="center" colspan="8">
			<input class="button10g" type="button" name="Cancel" value="Cancel" onclick="canceledit()">
		</td>
	</tr> --->
	
	</table>
	
<cfset AjaxOnLoad("doHighlight")>