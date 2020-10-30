
<!--- get matching item --->

<cfquery name="MParameter" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
		FROM   Ref_ParameterMission WITH (NOLOCK)
		WHERE  Mission = '#url.mission#'	
</cfquery>

<cfquery name="List" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		
	SELECT     I.ItemNo, I.ItemDescription, I.ItemNoExternal, I.ItemPrecision, U.UoM, U.UoMDescription, U.ItemUoMId, U.UoMCode,
	
               (SELECT       SUM(TransactionQuantity) 
                  FROM       ItemTransaction
                  WHERE      ItemNo = U.ItemNo  AND TransactionUoM = U.UoM AND Mission = '#url.mission#')     AS StockMission,
				  
               (SELECT       SUM(TransactionQuantity)
                  FROM       ItemTransaction
                  WHERE      ItemNo = U.ItemNo  AND TransactionUoM = U.UoM AND Warehouse = '#url.warehouse#') AS StockWarehouse
				  
	FROM      ItemUoM AS U WITH (NOLOCK) INNER JOIN
              Item AS I WITH (NOLOCK) ON U.ItemNo = I.ItemNo INNER JOIN
              ItemUoMMission AS L WITH (NOLOCK) ON U.ItemNo = L.ItemNo AND U.UoM = L.UoM AND L.Mission = '#url.mission#'
      
	WHERE     <cfif MParameter.EarmarkManagement eq "0">
			  U.ItemBarCode LIKE '#url.search#%' OR I.ItemNoExternal LIKE '%#URL.search#%'
			  <cfelse>
			  U.ItemBarCode = '#url.search#' OR I.ItemNoExternal = '#URL.search#'
			  </cfif>		    
								
</cfquery>

<table style="width:100%" class="navigation_table">

<cfoutput>
<tr class="line labelmedium">
   <td></td>
   <td><cf_tl id="ItemNo"></td>
   <td><cf_tl id="Name"></td>   
   <td><cf_tl id="UoM"></td> 
   <td><cf_tl id="Warehouse"></td>
   <td>#url.mission#</td>
</tr>
</cfoutput>

<cfoutput query="List">

	<cf_precision>
	
	<tr class="labelmedium line navigation_row">
	   
	   <td><cf_img icon="open" navigate="Yes" onclick="doItemMatch('#url.warehouse#','#itemUoMId#')"></td>
	   <td style="font-size:17px"><cfif ItemNoExternal neq "">#ItemNoExternal#<cfelse>#ItemNo#</cfif></td>
	   <td style="font-size:17px">#ItemDescription#</td>	
	    <td style="font-size:17px">#UoMDescription#</td>	  
	   <td style="font-size:17px;padding-right:3px;border-left:1px solid silver" align="right">#numberformat(stockWarehouse,"#pformat#")#</td>   
	    <td style="font-size:17px;padding-right:3px;border-left:1px solid silver" align="right">#numberformat(stockMission,"#pformat#")#</td>
	</tr>

</cfoutput>

</table>

<cfset ajaxonload("doHighlight")>
