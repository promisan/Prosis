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
<cfquery name="get" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT *
      FROM   Request R, Item I
	  WHERE  RequestId = '#URL.RequestId#'
	  AND    R.ItemNo = I.ItemNo
</cfquery>

<cfquery name="Current" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	  SELECT  * 
	  FROM    RequestTask			  
	  WHERE   RequestId    = '#URL.RequestId#'
	  AND     TaskSerialNo = '#URL.SerialNo#'
</cfquery>

<cfquery name="Warehouse" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT  W.Warehouse, 
	        W.WarehouseName,
		    WL.Location, 
		    WL.StorageId,
			WL.StorageCode,
		    WL.Description as LocationDescription,
		   
		    (SELECT Description 
		     FROM   Ref_WarehouseLocationClass 
			 WHERE  Code = WL.LocationClass) as LocationClass,
		   
		   <!--- stock on hand --->
		   
		    (SELECT SUM(TransactionQuantity)
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
		   
	WHERE    W.Mission         = '#get.mission#' 
	AND      W.Warehouse       = WL.Warehouse
	AND      WL.Warehouse      = I.Warehouse
	AND      W.Warehouse       = '#url.taskedWarehouse#' 
	AND      WL.Location       = I.Location
	AND      WL.Operational    = 1	
	AND      W.Operational     = 1
	AND      WL.Distribution IN ('1')
	AND      I.ItemNo          = '#get.itemno#'	
	AND      I.UoM             = '#get.uom#'	
	
	ORDER BY WL.Location	
		
</cfquery>

<table width="100%" cellspacing="0" cellpadding="0">

<tr><td height="12"></td></tr>

<tr>  
   <td width="40" height="25"></td>
   <td class="labelit">Storage</td>
   <td class="labelit">Barcode</td>
   <td class="labelit">Class</td>  
   <td class="labelit" align="right">Minimum</td>
   <td class="labelit" align="right">On hand</td>
   <td class="labelit" align="right">Maximum</td>
   <td class="labelit" align="right">Highest</td>
   <td class="labelit" align="right">Last updated</td>
   <td></td>
</tr>

<tr><td colspan="10" class="linedotted"></td></tr>

<cfif warehouse.recordcount eq "0">

<tr><td colspan="10" style="padding-top:6px" align="center" class="labelmedium"><font color="FF0000">No items found to be used</font></td></tr>

</cfif>

<cfoutput group="Warehouse" query="Warehouse">

    <cfset loc = "">
		
	<cfoutput>	
		
		<!---
		<cfif onhand gt "0">
		--->
				
			<cfif Location eq current.sourcelocation>		
				<tr class="highlight1" id="line_#location#">
			<cfelse>				
				<tr id="line_#location#">		
			</cfif>
			
			<cfif loc neq location>
			
			  <td width="40" style="padding-left:6px">	
			  
			 			  								
			    <input type="radio" 
			      id      = "selectline" style="height:14px;width:14px"
			      onclick = "taskedit('#url.requestId#','#url.serialno#','location',this.value)"
			      name    = "selectline" 
				  value   = "#StorageId#" <cfif Location eq current.sourcelocation>checked</cfif>>  
				  
			  </td>	
			  <td class="labelit">#LocationDescription#</td>
			  <td class="labelit">#StorageCode#</td>
			  <td class="labelit">#LocationClass#</td>	
				
			<cfelse>
			
			  <td colspan="4"></td>	
			
			</cfif>	
			
				
		      <td align="right" class="labelit">#numberformat(minimumstock,'__,__')#</td>
			  <td align="right" class="labelit">
				  <cfif minimumstock gte onhand>
				  <font size="2" color="FF0000">
				  <cfelse>				 
				  </cfif>
				  #numberformat(onhand,'__,__')#
			  </td>
			  <td align="right" class="labelit">#numberformat(maximumstock,'__,__')#</td>
			  <td align="right" class="labelit">#numberformat(higheststock,'__,__')#</td>
			  <td align="right" class="labelit">#dateformat(LastUpdated,CLIENT.DateFormatShow)#</td>	  
			  <td></td>
			  
		 	</tr>		
		
		<!---
		</cfif>
		--->
	
	    <cfset loc = location>
						
    </cfoutput>

</cfoutput>

</table>