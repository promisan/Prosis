
<!--- get the totals --->

<cfparam name = "URL.Source"           default="">
<cfparam name = "URL.Warehouse"        default="">
<cfparam name = "URL.Location"         default="">
<cfparam name = "URL.ItemNo"           default="">
<cfparam name = "URL.UoM"              default="">
<cfparam name = "URL.SystemFunctionId" default="00000000-0000-0000-0000-000000000000">

<cfset tableName = "StockTransaction#URL.Warehouse#_#url.mode#"> 

<cfquery name="Total"
datasource="AppsTransaction" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

    SELECT   count(*) as Lines, 
	         isNULL(sum(TransactionQuantity),0) as Quantity
			 
	FROM     #tableName# T
	WHERE    T.Warehouse      = '#url.warehouse#'
	AND      (T.Location      = '#url.location#' OR T.LocationTransfer = '#url.location#')
	AND      T.ItemNo         = '#url.itemNo#'
	AND      T.TransactionUoM = '#url.uom#'		
	<cfif url.source eq "Device">
	AND      T.Source = 'Device'
	</cfif>
	
</cfquery>		

<cfset submitgo  = TRUE>	

<cfif Total.recordcount gt "0">  	

	<cfoutput>

	 <table width="100%" cellspacing="0" cellpadding="0"> 
		 
		  <tr>		      				
						
			<cfset qty = -total.quantity>					
			
			<td colspan="5" width="70%" align="left" style="padding-left:4px">
			
			 	<cfquery name="get"
				    datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT *
						FROM   Warehouse
						WHERE  Warehouse = '#url.warehouse#'
				  </cfquery>	
				 	 
				  <cfif url.systemfunctionid neq "undefined" and url.systemfunctionid neq "">
				  	   	  
					    <cfinvoke component = "Service.Access"  
					     method             = "WarehouseProcessor"  
						 role               = "'WhsPick'"
						 mission            = "#get.mission#"
						 warehouse          = "#url.warehouse#"		
						 SystemFunctionId   = "#url.SystemFunctionId#" 
						 returnvariable     = "access">	 	
						 						 
						 <cfif access neq "ALL">
						 
						 	<cfset submitgo  = FALSE>		
						 
						 </cfif>
					 
				  </cfif>	 
					 
				  <cfif submitgo and Total.Lines gte "1">	 
				  
				  <!--- submission is only allows if the user has access rights = all --->
				  
										 	   	   
					    <cf_tl id="Submit Transactions for Clearance" var="1">
										
						<input type     = "button"
							value       = "#lt_text#" 				
							onclick		= "processStockIssue('#url.mode#','#url.warehouse#','#url.tratpe#','#url.location#','#url.itemno#','#url.uom#','','#url.systemfunctionid#');"
							id          = "Save"					
							style       = "font-size:13;height:26;width:280">
										 
				  
				  </cfif>
									
			    </td>	
				<td colspan="1" class="labelit" align="right">Transactions:</td>		
				<td colspan="1" class="labelmedium" align="right">#Total.Lines#</td>				
				<td colspan="1" class="labelit" align="right">Quantity:</td>
				<td class="labelmedium" align="right">#NumberFormat(qty,'_____,__._')#</td>
				<td style="width:50">&nbsp;</td>
					
		  </tr> 		 
		  
	 </table> 
	 
	 </cfoutput>
				
<cfelse>

	<cf_compression>	
	
</cfif>		