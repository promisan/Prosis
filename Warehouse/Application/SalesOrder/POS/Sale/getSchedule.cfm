
<cfparam name="url.customerid" default="">

<cfquery name="qThisSale" 
	 datasource="AppsMaterials" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	    SELECT *
	    FROM  CustomerRequestLine
	    WHERE 
	    <cfif url.customerId neq "">
			CustomerIdInvoice = '#url.customerid#'
		<cfelse>
			1=0	
	    </cfif>
	    AND PriceSchedule IS NOT NULL
</cfquery>		

<cfquery name="default" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	 SELECT *
	 FROM   Ref_PriceSchedule	
	 WHERE  FieldDefault = 1						   							   
</cfquery>
		
<cfif qThisSale.recordcount neq 0>		
	<cfset sch = qThisSale.PriceSchedule>
<cfelse>
	<cfset sch = default.Code>
</cfif>
	
<cfif url.customerid neq "">
	
	<cfquery name="getSchedule" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		SELECT   TOP 1 *
		FROM     CustomerSchedule
		WHERE    CustomerId = '#url.customerid#' 
		AND      DateEffective =
	                          (SELECT     MAX(DateEffective) 
	                            FROM      CustomerSchedule
	                            WHERE     CustomerId = '#url.customerid#'
								AND       Category IN
	                                            (SELECT  Category
	                                             FROM    WarehouseCategory
	                                             WHERE   Warehouse = '#url.warehouse#')
								)
																
	</cfquery>		
			
	<cfif getSchedule.recordcount gte "1">					
		<cfset sch = getSchedule.PriceSchedule>	
	</cfif>			

</cfif>

<cfquery name="schedulelist" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	 SELECT *
	 FROM   Ref_PriceSchedule							   							   
</cfquery>

<cfoutput>

<select name="PriceSchedule" id="PriceSchedule" style="font-size:16px;height:100%;width:100%;border:0px;" class="regularXXL"
	onchange="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/Warehouse/Application/SalesOrder/POS/Sale/applySaleHeader.cfm?field=schedule&priceschedule='+this.value+'&requestno='+document.getElementById('RequestNo').value+'&customeridinvoice='+document.getElementById('customerinvoiceidselect').value,'salelines','','','POST','saleform')">
	
	<!--- <option value="">&nbsp;&nbsp;&nbsp;--- <cf_tl id="default"> ---</option> --->
	<cfloop query="schedulelist">
		<option value="#Code#" <cfif code eq sch>selected</cfif>>#Description#</option>
	</cfloop>
	
</select>	

</cfoutput>	