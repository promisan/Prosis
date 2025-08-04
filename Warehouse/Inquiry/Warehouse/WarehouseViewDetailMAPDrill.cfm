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

<!--- show in this template the stock for the warehouse to which the person has access, then the option to open the
warehouse to process --->

<cfquery name="Warehouse" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT W.Mission,
	       W.Warehouse, 
	       W.WarehouseName,
		   WL.Location, 
		   WL.Description as LocationDescription,
		   I.ItemLocationId,
		   
		   (SELECT Description 
		    FROM   Ref_WarehouseLocationClass 
			WHERE  Code = WL.LocationClass) as LocationClass,
		   
		   <!--- stock on hand --->
		   
		   (SELECT SUM(TransactionQuantityBase)
                FROM     ItemTransaction
                WHERE    Warehouse      = I.Warehouse 
			    AND      Location       = I.Location 
			    AND      ItemNo         = I.ItemNo 
			    AND      TransactionUoM = I.UoM) AS OnHand, 
			
			<!--- last transaction --->
					  
			(SELECT MAX(Created) as LastUpdated
                FROM     ItemTransaction
                WHERE    Warehouse      = I.Warehouse 
			    AND      Location       = I.Location 
			    AND      ItemNo         = I.ItemNo 
			    AND      TransactionUoM = I.UoM) AS LastUpdated, 	  		   
		 	 
		     I.MinimumStock,
		     I.MaximumStock,
		     I.HighestStock
		   
	FROM     Warehouse W, 
	         WarehouseLocation WL, 
		     ItemWarehouseLocation I
		   
	WHERE    WL.Warehouse  = '#url.cfmapname#' 
	AND      W.Warehouse  = WL.Warehouse
	AND      WL.Warehouse = I.Warehouse
	AND      WL.Location  = I.Location
	AND      WL.Operational = 1
	AND      I.ItemNo     = '#url.itemno#'	
	AND      I.UoM        = '#url.uom#'	
	ORDER BY WL.Location	
	
</cfquery>

<table width="500" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<tr>
	<td colspan="8" style="padding:4px">
	<font face="Verdana" size="2">
	<cfoutput>
	<a href="javascript:warehouse('#warehouse.mission#','#url.cfmapname#')"><font color="0080C0">#Warehouse.WarehouseName#</a>
	</cfoutput>
	</font>
	</td>
</tr>

<tr><td></td><td colspan="8" class="line"></td></tr>
<tr>    
   <td></td>
   <td class="labelit">Storage</td>
   <td class="labelit">Class</td>  
   <td class="labelit" align="right">Min</td>  
   <td class="labelit" align="right">Max</td>   
   <td class="labelit" align="right">On hand</td>
   <td class="labelit" align="right">Last</td>
   <td></td>
</tr>

<tr><td></td><td colspan="7" class="line"></td></tr>

<cfoutput query="Warehouse">

    <cfset loc = "">
		
	<tr>
	
	<cfif loc neq location>
	
	  <td width="20"></td>	
	  <td><a href="javascript:itemlocation('#itemlocationid#')"><font face="Verdana" color="0080FF">#LocationDescription#</a></td>
	  <td><font face="Verdana">#LocationClass#</td>	
		
	<cfelse>
	
	  <td colspan="3"></td>	
	
	</cfif>
		
      <td align="right"><font face="Verdana">#numberformat(minimumstock,'__,__')#</td>	 
	  <td align="right"><font face="Verdana">#numberformat(maximumstock,'__,__')#</td>	 
	  <td align="right" bgcolor="fafafa">
		  <cfif minimumstock gte onhand>
		  <font face="Verdana" size="2" color="FF0000">
		  <cfelse>
		  <font face="Verdana">
		  </cfif>
		  #numberformat(onhand,'__,__')#
	  </td>
	  <td align="right"><font face="Verdana">#dateformat(LastUpdated,CLIENT.DateFormatShow)#</td>	  
	  <td></td>
	  
 	</tr>
		
	<tr>
	  <td></td>	 
	  <td colspan="7" style="border-top:1px dotted silver"></td>
	</tr>
	
	<cfset loc = location>
	
</cfoutput>

</table>


