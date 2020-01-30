
<cfquery name="Whs" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		SELECT   *
		FROM     Warehouse	
		WHERE    Warehouse      = '#getTask.SourceWarehouse#' 		
</cfquery>

<cfquery name="Get" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		SELECT   L.Location, 
		         (SELECT SUM(S.TransactionQuantity) 
					 FROM ItemTransaction S
					 WHERE S.Warehouse = L.Warehouse
					 AND   S.Location = L.Location
					 AND   S.ItemNo         = '#getTask.itemno#' 
			         AND   S.TransactionUoM = '#getTask.uom#'
				 ) AS Stock, 
				 L.Description,
				 L.ListingOrder
		FROM     ItemWarehouseLocation I 
				 INNER JOIN WarehouseLocation L ON I.Warehouse = L.Warehouse AND I.Location = L.Location				 
		WHERE    I.Warehouse      = '#getTask.SourceWarehouse#' 
		AND      I.ItemNo         = '#getTask.itemno#' 
		AND      I.UoM            = '#getTask.uom#' 
		AND      L.Operational    = 1
		AND      L.Distribution   = 1
		GROUP BY L.Warehouse,L.Location, L.Description, L.ListingOrder	
		ORDER BY ListingOrder 		
</cfquery>

<cfquery name="ItemUoM" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		SELECT   *
		FROM     ItemUoM I
		WHERE    I.ItemNo   = '#getTask.itemno#' 	
		AND      I.UoM      = '#getTask.uom#'   
</cfquery>

<table width="300" cellspacing="0" cellpadding="0">

<cfoutput>

	<tr>
	  <td></td> 
	  <td style="padding:2px">Location</td>
	  <td style="padding:2px" align="right">On Hand</td>	 	 
	</tr>
	<tr><td colspan="3" class="line"></td></tr>
	
	<cfif get.recordcount eq "0">
	
	<tr><td colspan="3" height="30" align="center"><font face="Verdana" color="FF0000">No stock location defined</td></tr>
	
	</cfif>	
	
	<cfset row = 0>
	
	<cfloop query="Get">
		
	    <cfif Get.Stock gt "0">
		
		<cfset row = row+1>
	
		<tr>
		  <td width="40" style="padding:0px" align="center">
		  <input type="radio" name="sourcelocation" id="sourcelocation" value="#location#" <cfif row eq "1">checked</cfif>>		  
		  </td>			
		  <td style="padding:0px">#Description#</td>
		  <td style="padding:0px" align="right"><cfif stock lt 0><font color="FF0000"></cfif>#numberformat(stock,"__,__")#</td>
		   
		</tr>
		
		</cfif>
	
	</cfloop>	
	

</cfoutput>

</table> 





























