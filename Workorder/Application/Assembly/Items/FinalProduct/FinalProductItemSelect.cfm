
<cfparam name="url.find" default="">

<cfquery name="Line" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
    	SELECT  R.ServiceType
        FROM    WorkOrderLine WL INNER JOIN
                Ref_ServiceItemDomainClass R ON WL.ServiceDomain = R.ServiceDomain AND WL.ServiceDomainClass = R.Code		
		WHERE   WorkOrderId = '#url.WorkOrderId#'			
		AND		WorkOrderLine = '#url.WorkOrderLine#'
</cfquery>

<cfquery name="Item" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     TOP 100 IM.Description AS ItemMaster, 
		           C.Description, 
				   I.ItemNo, 
				   I.ItemNoExternal,
				   I.ItemDescription, 
				   I.Classification, 
				   I.Classification+' '+I.ItemDescription as ItemName, 
				   IM.Code
		
		FROM       Item I INNER JOIN Purchase.dbo.ItemMaster IM ON I.ItemMaster = IM.Code INNER JOIN Ref_Category C ON I.Category = C.Category
		<cfif Line.ServiceType eq "Sale">
		WHERE      (I.ItemClass = 'Supply' and C.FinishedProduct = 1) 
		<cfelse>
		WHERE      I.ItemClass = 'Service' <!--- to generate final items items : Hicosa mode --->
		</cfif>
		AND        I.ItemNo IN
		                   (SELECT  ItemNo
		                    FROM    ItemUoMMission
		                    WHERE   Mission = '#url.Mission#' 
						    AND     ItemNo  = I.ItemNo)
					 
		AND        (I.Classification LIKE '%#url.find#%' 
		                   OR I.ItemDescription LIKE '%#url.find#%'
						   OR I.ItemNoExternal  LIKE '%#url.find#%'
						   OR I.ItemNo IN (SELECT ItemNo FROM ItemUoM WHERE ItemNo = I.ItemNo AND ItemBarCode LIKE '%#url.find#%')						   
						   
						   )					 
		ORDER BY   C.Description, I.ItemMaster, I.ItemNo, I.ItemDescription
</cfquery>

<table width="100%" class="navigation_table">
	<cfif Item.recordcount eq "0">
		<tr class="labelmedium2"><td align="center" height="70"><font color="#808080"><cf_tl id="No items found"></font></td></tr>	
	</cfif>
	<cfoutput query="Item" group="Description">
		<tr class="line"><td class="labellarge" style="font-weight:bold;height:40px">#Description#</td></tr>
		<cfoutput>
		<tr class="navigation_row labelmedium2 linedotted">
		<td class="navigation_action" style="min-width:99%;padding-left:2px;padding-right:4px" onclick="selectitem('#itemno#')"><font style="font-weight:bold" color="000080"><cfif ItemNoExternal neq "">#ItemNoExternal#<cfelse>#Classification#</cfif></font> #ItemDescription#</td>
		</tr>
		</cfoutput>				
	</cfoutput>									
</table>

<cfset AjaxOnLoad("doHighlight")>	