
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
	<tr class="line labelmedium2">	    		
		<td align="center" height="20">
		<cfif check.recordcount gte "1">
		<a href="javascript:uommissionedit('#URL.ID#', '#URL.UoM#', '')"><cf_tl id="New Entity"></a>
		</cfif>
		</td>		
		<td><cf_tl id="Entity"></td>
		<td><cf_tl id="Transaction UoM"></td>
		<td align="center"><cf_tl id="Selfservice"></td>	
		<td align="center"><cf_tl id="Stock Classification"></td>					
		<td align="right"><cf_tl id="Standard Cost"></td>		
		<td align="center"><cf_tl id="Operational"></td>	
	</tr>
		
	<cfif UoMMission.recordCount eq 0>
	<tr><td colspan="6" align="center"><font color="808080"><cf_tl id="No entities recorded"></font></td></tr>	
	</cfif>
	
	</cfoutput>	
	
	<cfoutput query="UoMMission">	
	
	<tr class="navigation_row line labelmedium2">
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
	  <td align="center"><cfif Selfservice eq 1>Yes<cfelse><b>No</b></cfif></td>
	  <td align="center"><cfif EnableStockClassification eq 1><b>Yes</b><cfelse>No</cfif></td>	  
	  <td align="right" style="padding-right:4px">#LSNumberFormat(StandardCost, ",.__")#</td>
	  <td align="center"><cfif Operational eq 1>Yes<cfelse><b>No</b></cfif></td>		  	  
	</tr>  	
	</cfoutput>
	
	<tr><td height="7" colspan="6"></td></tr>
		
	</table>
	
	
<cfset AjaxOnLoad("doHighlight")>