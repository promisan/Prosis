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

	<cfquery name="UoMMission" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	UoMM.*, UoM.UoMDescription AS TransactionUoMDescription
		FROM 	ItemUoMMission UoMM
				LEFT JOIN ItemUoM UoM
					ON UoMM.ItemNo = UoM.ItemNo AND UoMM.TransactionUoM = UoM.UoM
		WHERE	UoMM.ItemNo = '#URL.ID#'
		AND		UoMM.UoM = '#URL.UoM#'
	</cfquery>
	
	<cfquery name="check" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT 	*
			FROM 	Ref_ParameterMission
			WHERE	Mission IN (SELECT Mission 
			                    FROM   Organization.dbo.Ref_MissionModule 
								WHERE  SystemModule = 'Warehouse')
			AND     Mission NOT IN (SELECT Mission 
			                        FROM   ItemUoMMission 
									WHERE  ItemNo = '#url.id#' 
									AND    UoM = '#url.uom#')					
		</cfquery>
	
	<table width="90%" class="navigation_table" class="formpadding">	
	
	<cfoutput>
	<tr class="line labelmedium2 fixlengthlist">	    		
		<td align="center" height="20">
		<cfif check.recordcount gte "1">
		<a href="javascript:uommissionedit('#URL.ID#', '#URL.UoM#', '')"><cf_tl id="Add"></a>
		</cfif>
		</td>		
		<td><cf_tl id="Entity"></td>
		<td><cf_tl id="Transaction UoM"></td>
		<td align="center"><cf_tl id="Reference"></td>
		<td align="center"><cf_tl id="Selfservice"></td>	
		<td align="center"><cf_tl id="Stock Classification"></td>					
		<td align="right"><cf_tl id="Standard Cost"></td>		
		<td align="center"><cf_tl id="Operational"></td>	
	</tr>
		
	<cfif UoMMission.recordCount eq 0>
	<tr><td colspan="7" align="center"><font color="808080"><cf_tl id="No entities recorded"></font></td></tr>	
	</cfif>
	
	</cfoutput>	
	
	<cfoutput query="UoMMission">	
	
	<tr class="navigation_row line labelmedium2 fixlengthlist">
	  <td width="80" height="18" align="center">
	  
	  	<table class="formspacing">
		<tr>
		<td>
	  		<cf_img icon="edit"	onClick="uommissionedit('#URL.ID#', '#URL.UoM#', '#Mission#')" navigation="Yes">
		</td>
		<td style="padding-left:4px;padding-top:1px">
			<cf_img icon="delete" onClick="uommissiondelete('#URL.ID#', '#URL.UoM#', '#Mission#')">	
		</td>
		</tr>
		</table>		  
	  
	  </td>
	  <td>#Mission#</td>	 
	  <td><cfif TransactionUoMDescription eq ""><cf_tl id="Standard"><cfelse>#TransactionUoMDescription#</cfif></td> 
	  <td align="center">#Reference#</td>
	  <td align="center"><cfif Selfservice eq 1>Yes<cfelse><b>No</b></cfif></td>
	  <td align="center"><cfif EnableStockClassification eq 1><b>Yes</b><cfelse>No</cfif></td>	  
	  <td align="right" style="padding-right:4px">#LSNumberFormat(StandardCost, ",.__")#</td>
	  <td align="center"><cfif Operational eq 1>Yes<cfelse><b>No</b></cfif></td>		  	  
	</tr>  	
	</cfoutput>
	
	<tr><td height="7" colspan="7"></td></tr>
		
	</table>
	
	
<cfset AjaxOnLoad("doHighlight")>