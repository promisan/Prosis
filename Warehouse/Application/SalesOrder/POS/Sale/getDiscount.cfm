

<cfquery name="qThisSale" 
	 datasource="AppsMaterials" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	    SELECT *
	    FROM  CustomerRequestLine
	    WHERE RequestNo = '#url.requestno#'		
</cfquery>	

<cfif qthisSale.recordcount gte "1">
	<cfset def = qThisSale.SalesDiscount>
<cfelse>
	<cfset def = "0">
</cfif>		

<cfquery name="get" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	    SELECT  *
		FROM   Warehouse
		WHERE  Warehouse = '#url.warehouse#'
</cfquery>

<cfoutput>

<select name="Discount" id="Discount" style="background-color:f1f1f1;font-size:16px;height:100%;width:100%;min-width:80px;border:0px;" class="regularXXL"
		onchange="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/Warehouse/Application/SalesOrder/POS/Sale/applySaleHeader.cfm?field=discount&discount='+this.value+'&requestno='+document.getElementById('RequestNo').value+'&customeridinvoice='+document.getElementById('customerinvoiceidselect').value,'salelines','','','POST','saleform')">
				
		<cfloop index="dis" from="0" to="#get.SaleDiscount#" step="1">
			<option value="#dis#" <cfif def eq dis>selected</cfif>>#dis# %</option>
		</cfloop>
		
</select>	

</cfoutput>	

