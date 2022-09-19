
<cfquery name="SearchResult" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		SELECT     *,
		           (SELECT Count(*)        FROM CustomerRequestLine	WHERE RequestNo = C.RequestNo) as Lines,
				   (SELECT SUM(SalesTotal) FROM CustomerRequestLine	WHERE RequestNo = C.RequestNo) as Amount
				   	
		FROM       Customer A INNER JOIN CustomerRequest C ON A.CustomerId = C.CustomerId	
		WHERE      C.Warehouse   = '#url.warehouse#' 
		-- AND        C.Created > getDate()-1  <!--- only recent --->
		AND        (
		           (Source = 'Manual' AND ActionStatus IN ('0','1'))
				   OR 
				   Source != 'Manual' AND ActionStatus = '1' <!--- web and quote --->	
				   )				  
		AND        BatchNo is NULL  <!--- not turned into a real sale yet --->
		<!--- not loaded from existing --->
		AND        C.RequestNo NOT IN (SELECT RequestNo FROM CustomerRequestLine WHERE BatchId is NOT NULL) <!--- was not reloaded for process in POS --->
	    AND        C.RequestNo IN     (SELECT RequestNo FROM CustomerRequestLine) <!--- has lines --->
		<!--- has turned into a sales order quote --->			
		AND        NOT EXISTS (SELECT 'X' FROM WorkOrder.dbo.WorkorderLine WHERE Source = 'Quote' and SourceNo = C.RequestNo)
				
		ORDER BY   CustomerName 
			
</cfquery>	

<cf_divscroll style="height:100%" overflowy="scroll">
		
	<table width="98%" class="navigation_table">
				   
	<tr class="labelmedium2 line fixrow fixlengthlist">	  
	    
		<td><cf_tl id="Id"></td>
		<td><cf_tl id="Customer"></td>
		<td><cf_tl id="Phone"></td>			
		<TD><cf_tl id="Time"></TD>		
		<td><cf_tl id="Class"></td>
		<td><cf_tl id="Quote"></td>
		<td><cf_tl id="I"></td>		
		<TD><cf_tl id="Officer"></TD>		
		<TD><cf_tl id="S"></TD>		
		<TD><cf_tl id="S"></TD>					
	</tr>  		 
			
	<cfset prior = "">
			
	<cfoutput query="SearchResult">
							
		<cfif actionStatus eq "9">
		   <cfset cl = "FAA0AE">
		   <cf_tl id="Voided" var="1">
		<cfelseif actionStatus eq "0">  		
		   <cfset cl = "FFFF00">
		   <cf_tl id="In preparation" var="1">
	    <cfelse>
		   <cfset cl = "00FF00">
		   <cf_tl id="Prepared" var="1">
		</cfif>
					
		<tr class="navigation_row labelmedium2 line fixlengthlist">		  
		
		     <cfif prior eq customerSerialNo>
			 
			 <td align="center" style="padding-bottom:2px;padding-top:2px;background-color:###cl#80">	
							
				   <!--- sales that relate to issuance/inventory/issuance batch can not be edited here, we support opening the batch --->
				   
				   <input type="button" class="button10g" style="border:1px solid silver;width:60px;height:22px" value="#CustomerSerialNo#"
				   onclick="window['fnCBDialogSaleClose'] = function(){ ProsisUI.closeWindow('dialogquotebox') }; ptoken.navigate('#SESSION.root#/warehouse/application/SalesOrder/POS/Sale/applyCustomer.cfm?warehouse=#url.warehouse#&customerid=#customerid#&addressid=#addressid#&quote=edit','customerbox','fnCBDialogSaleClose','','POST','');" >			   
				   
				</td>
			 <td></td>
			 <td></td>
			 
			 <cfelse>
			 
			    <td align="center" style="padding-bottom:2px;padding-top:2px;background-color:###cl#80">	
							
				   <!--- sales that relate to issuance/inventory/issuance batch can not be edited here, we support opening the batch --->
				   
				   <input type="button" class="button10g" style="border:1px solid silver;width:60px;height:22px" value="#CustomerSerialNo#"
				   onclick="window['fnCBDialogSaleClose'] = function(){ ProsisUI.closeWindow('dialogquotebox') }; ptoken.navigate('#SESSION.root#/warehouse/application/SalesOrder/POS/Sale/applyCustomer.cfm?warehouse=#url.warehouse#&customerid=#customerid#&addressid=#addressid#&quote=edit','customerbox','fnCBDialogSaleClose','','POST','');" >			   
				   
				</td>
				
				<td><i class="fas fa-user-circle" style="padding-right:4px"></i>#CustomerName#</td>			
				<td><i class="fas fa-phone-square" style="padding-right:4px"></i> #left(PhoneNumber,10)#</td>
				
			</cfif>
			
			<td>#timeformat(Created,"HH:MM")#</td>	
			<td>#RequestClass#</td>										
			<td>#RequestNo#</td>			
			<td>#Lines#</td>				
			<td>#OfficerLastName#</td>
			<td>#left(Source,1)#</td>
			<td>
			<table><tr><td style="height:15px;width:15px;border:1px solid gray;background-color:###cl#80"></td></tr></table>			
			</td>	
		</tr>
		
		<cfset prior = customerserialNo>
					     
	</CFOUTPUT>
	
	</TABLE>
		
</cf_divscroll>

<cfset ajaxonLoad("doHighlight")>
