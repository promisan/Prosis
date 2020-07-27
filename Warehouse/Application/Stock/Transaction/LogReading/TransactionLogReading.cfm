
<cfquery name="get" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT W.*,C.Description as ClassName
	FROM   WarehouseLocation W, Ref_WarehouseLocationClass C
	WHERE  W.LocationClass = C.Code
	AND    W.Warehouse = '#url.warehouse#'	
	AND    W.Location  = '#url.location#'		
</cfquery>

<cfquery name="reading" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   ItemWarehouseLocation 
	WHERE  Warehouse = '#url.warehouse#'	
	AND    Location  = '#url.location#'	
	AND    ItemNo    = '#url.itemno#'
	AND    UoM       = '#url.UoM#' 				
</cfquery>
						
<!--- Query returning search results --->
<cfquery name="check"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   WarehouseLocation
	WHERE  Warehouse = '#url.warehouse#'
	AND    Location  = '#url.location#'
</cfquery>	

<cfoutput>

<table width="100%" cellspacing="0" cellpadding="0">

<tr>

<td width="60%" style="height:35">

		<table width="100%" cellspacing="0" cellpadding="0">
		
			<tr><td  style="padding-left:7px;padding-top:2px" class="labelmedium">#get.ClassName# - #get.StorageCode# (<b>#get.Description#</b>)</td></tr>
					
		</table>
	
   </td>
   
   <td width="40%" valign="top" align="right" style="padding-right:4px;<cfif reading.readingenabled neq "0">padding-top:7px<cfelse>padding-top:2px</cfif>">
   
	   <table>
		   <tr>
		  	   <td class="labelit">Show details:</td>
			   <td style="padding-left:4px;padding-top:2px;padding-right:4px" valign="top"><input type="checkbox" id="showdetails" name="showdetails" value="1" onclick="javascript:transactionreload(this.checked)"></td>
		   </tr>
	   </table>
	   
   </td>
  
	<cfif reading.readingenabled neq "0">

	<td align="right" valign="top" style="padding-top:4px">
	
		<table cellspacing="0" cellpadding="0" align="right">
	
	    <tr class="labelmedium">	
		<td style="padding-left:10px"><cf_tl id="Meter"></td>
		<td height="20" style="padding-left:5px;min-width:70px"><cf_tl id="Opening"></td>	
		
		<td style="padding-left:6px">	   
			<input type="Text"
		       name="transactionOpening"
			   id="transactionOpening"
			   onchange="ColdFusion.navigate('../Transaction/LogReading/TransactionLogReadingSet.cfm?warehouse=#url.warehouse#&location=#url.location#&ItemNo=#url.itemno#&UoM=#url.uom#&field=opening&value='+this.value,'openingset')"
		       message="Please enter a numeric value"
			   value="#reading.ReadingOpening#"	     
		       class="regularxl"
	           style="width:80;text-align:right;padding-right:2px">
			</td>
			<td class="hide" id="openingset"></td>		
				
			<td style="padding-left:6px;min-width:70px"><cf_tl id="Closing"></td>			
			
			<td style="padding-left:6px;padding-right:4px">
			<input type="Text"
		       name="transactionClosing"
			   id="transactionClosing"
			   onchange="ColdFusion.navigate('../Transaction/LogReading/TransactionLogReadingSet.cfm?warehouse=#url.warehouse#&location=#url.location#&ItemNo=#url.itemno#&UoM=#url.uom#&field=closing&value='+this.value,'closingset')"	       
		       message="Please enter a numeric value"
			   value="#reading.ReadingClosing#"		     
		       class="regularxl"
	           style="width:80;text-align:right;padding-right:2px">
			 </td>
			 <td class="hide" id="closingset"></td>
		</tr>
		</table>
	</td>	
		
	</cfif>
	
</tr>


<cfif Check.EnableReference eq "1">
		
	<tr>	
	
	<td colspan="3" style="height:10;padding-right:10px">

		<cfinvoke component = "Service.Presentation.TableFilter"  
			   method           = "tablefilterfield" 
			   filtermode       = "direct"
			   name             = "filtersearch"
			   label            = "Find Voucher"
			   style            = "font:14px;height:24;width:120"
			   rowclass         = "clsTransaction"
			   rowfields        = "ccontent">		
			   		
	</td>		
	
	</tr>	
			
		
</cfif>

</table>	
	
</cfoutput>		