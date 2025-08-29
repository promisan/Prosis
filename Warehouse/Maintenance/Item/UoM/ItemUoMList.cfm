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
<cfquery name="Item" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	Item
	WHERE 	ItemNo = '#URL.ID#'
</cfquery>

<!--- ensure that the default mission has an occurence --->

<cfinclude template="ItemUomMissionDefault.cfm">

<script language="JavaScript">
	var lastSelectedRow = -1;	
</script>	

<table width="100%" cellspacing="0" cellpadding="0" class="navigation_table">

 <cfoutput>
 
<!--- refresh button to be discussed with dev 5/9/2014 --->
<tr class="hide"><td>   
	<input type="button" id="refresh_uomlist" onclick="ptoken.navigate('#session.root#/Warehouse/Maintenance/Item/UoM/ItemUoMList.cfm?id=#url.id#&uomselected=#url.uomselected#','uomlist');">	
    </td>
</tr>

<tr class="line labelmedium fixlengthlist">
    <td width="60" colspan="2"><a href="javascript:recorduomedit('#URL.ID#','')"><cf_tl id="Add"></a></td>		
	<td><cf_tl id="Code"></td>
	<td><cf_tl id="Label"></td>
	<td><cf_tl id="Barcode"></td>
	<td><cf_tl id="Multi."></td>
	<td><cf_tl id="Ope"></td>
	<td><cf_tl id="Entity"></td>
	<td><cf_tl id="Reference"></td>
	<td align="right"><cf_tl id="Std.Cost">#Application.BaseCurrency#</td>		
	<td align="right"><cf_tl id="BOM Cost">#Application.BaseCurrency#</td>
	<td align="right"><cf_tl id="Last Receipt">#Application.BaseCurrency#</td>
</tr>

</cfoutput>

<cfquery name="qUoM" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	ItemUoM
	WHERE 	ItemNo = '#URL.ID#'
</cfquery>

<cfoutput query="qUoM">

<tr class="line navigation_row fixlengthlist" id="trUoMRow_#currentrow#" style="height:20px;background-color:<cfif url.uomselected eq #UoM#>'E1EDFF'<cfelse>''</cfif>">

  <td width="30">
    <table cellspacing="0" cellpadding="0">
		<tr class="labelmedium" style="height:23px">
			<td style="padding-top:2px;padding-left:2px;padding-right:4px">
		    	<cf_img icon="edit" navigation="Yes" onclick="recorduomedit('#URL.ID#','#UoM#')">			
			</td>			
			
			<!--- we check Request and ItemTransaction, ItemSupply and AssetItemSupply for the UoM to be in use --->
					
			<cfquery name="Check" 
				datasource="appsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT TOP 1 Created
					FROM 	Request
					WHERE 	ItemNo = '#URL.ID#'
					AND  	UoM = '#UoM#'
					UNION
					SELECT TOP 1 Created
					FROM   ItemTransaction
					WHERE  ItemNo         = '#URL.ID#'
					AND    TransactionUoM = '#UoM#'
					UNION
					SELECT TOP 1 Created
					FROM   ItemSupply
					WHERE  ItemNo         = '#URL.ID#'
					AND    SupplyItemUoM = '#UoM#'
					UNION
					SELECT TOP 1 Created
					FROM   AssetItemSupply
					WHERE  SupplyItemNo   = '#URL.ID#'
					AND    SupplyItemUoM  = '#UoM#'
			</cfquery>	
			
			<cfif Check.recordcount eq 0>	
				 <td style="padding-top:3px;padding-right:14px">
			     	<cf_img icon="delete" onclick="recorddelete('#URL.ID#','#UoM#');">
				 </td>
			</cfif>	
			
		</tr>
	</table>
  </td>
  <td width="20">#currentrow#.</td>	  
  <td>#UoMCode#</td>
  <td>#UoMDescription#</td>
  <td><cfif ItemBarCode eq "">n/a<cfelse>#ItemBarCode#</cfif></td>
  <td>#UoMMultiplier#</td>
  <td>
  <cfif operational eq "1">Yes<cfelse>No</cfif>
  </td>
  <td></td>
  <td align="right">#numberformat(StandardCost,",.__")#</td>  
  <td></td>
  <td></td>
  <td></td>
</tr>  

<cf_filelibraryCheck
			DocumentPath="ItemUoM"
			SubDirectory="#ItemUoMId#" 
			Filter="">	
			
<cfif files gte "1">			
	
	<tr class="line">
	<td colspan="11" style="padding-right:4px">
	
			<cf_filelibraryN
				DocumentPath="ItemUoM"
				SubDirectory="#ItemUoMId#" 
				Filter=""
				Presentation="all"
				Insert="no"
				Remove="no"
				width="100%"	
				Loadscript="no"				
				border="0">	
	</td>
	</tr>

</cfif>

<!--- show missions --->

<cfquery name="UoMMission" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	ItemUoMMission
		WHERE 	ItemNo = '#URL.ID#'
		AND		UoM = '#uom#'
</cfquery>

<cfloop query="UoMMission">
	
	<tr class="line navigation_row_child labelmedium2">
		
	<td colspan="7"></td>
	<td style="background-color:##e4e4e450;padding-left:4px">#Mission#</td>
	<td style="background-color:##f4f4f450;padding-left:4px">#Reference#</td>
	<td align="right" style="background-color:##f4f4f450;padding-right:4px">#numberformat(StandardCost,",.__")#</td>
	<td align="right" style="background-color:##f4f4f450;padding-right:4px">
				
		<cfquery name="LastBOM" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT SUM(MaterialAmount) as Total
			FROM   ItemBOMDetail
			WHERE  BOMId IN (
					SELECT 	TOP 1 BOMId
					FROM 	ItemBOM
					WHERE 	ItemNo = '#URL.ID#'
					AND		UoM = '#uom#'
					AND     Mission = '#Mission#'
					ORDER BY DateEffective DESC
				)
		</cfquery>
	
		#numberformat(LastBOM.Total,",.__")#
		
	</td>
	
	<td align="right" style="background-color:##f4f4f4;padding-right:4px">
				
		<cfquery name="Last" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT TOP 1 * 
			FROM   ItemTransaction
			WHERE  Mission = '#Mission#'
			AND    ItemNo = '#url.id#'
			AND    TransactionUoM  = '#uom#'
			AND    TransactionType IN ('1','9')
			ORDER BY Created DESC			
		</cfquery>
	
		#numberformat(Last.ReceiptCostPrice,",.__")# (#last.transactionType#)
	
	</td>
		
	</tr>

</cfloop>

</cfoutput>
</table>

<cfset AjaxOnLoad("doHighlight")>	
