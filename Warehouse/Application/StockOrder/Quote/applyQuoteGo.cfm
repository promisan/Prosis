
<!--- various options to apply the quote --->

<cfparam name="url.action" default="">

<cfswitch expression="#url.action#">

	<cfcase value="pdf"> 
				
		<cfset fileName = "myQuote_#url.requestno#">
		
		<cfquery name="getRequest"
				datasource="AppsMaterials"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
				SELECT * 
				FROM   CustomerRequest				
				WHERE  RequestNo = '#url.RequestNo#'				
		</cfquery> 
				
		 <cfquery name="template"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT  * 
			FROM    WarehouseJournal 
			WHERE   Warehouse    = '#getRequest.Warehouse#'			
			AND     Area         = 'Sale'
		</cfquery>
		
		<cfif template.transactionTemplateMode1 eq "">
		     <cfset tmp = "Warehouse/Application/StockOrder/Quote/defaultQuote.cfm">            
		<cfelse>
		     <cfset tmp = "#template.transactionTemplateMode1#">			 
		</cfif>
				
		<cfquery name="getRequest"
				datasource="AppsMaterials"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
				SELECT * 
				FROM   CustomerRequest				
				WHERE  RequestNo = '#url.RequestNo#'				
		</cfquery> 
		
		
		
		<cfset subject = "#getRequest.mission# Quotation #url.RequestNo#">
		<cfset mailto  = "#getRequest.customerMail#">
		
		<!---
		<cfquery name="setLog" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
								
			INSERT INTO CustomerRequestAction ( 	
				        RequestNo,
						ActionCode, 
						ActionMemo,
						OfficerUserId, 
						OfficerLastName, 
						OfficerFirstName )
					
			VALUES ( '#url.RequestNo#', 
					 'Print', 
					 '----', 			
					 '#session.acc#',
					 '#session.last#',
					 '#session.first#' )
					 
		</cfquery>
		
		--->
				
		<cfoutput>
     	<script>	
		
			ptoken.navigate('applyQuoteSend.cfm?id=pdf&subject=#subject#&to=#mailto#&filename=#getrequest.mission# Quotation #url.RequestNo#&templatepath=#tmp#&id1=#url.requestNo#','contentbox1')
			
		</script>
		</cfoutput>

	</cfcase>

    <cfcase value="Quote"> 
				
		<cfset fileName = "myQuote_#url.requestno#">
		
		<cfquery name="getRequest"
				datasource="AppsMaterials"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
				SELECT * 
				FROM   CustomerRequest				
				WHERE  RequestNo = '#url.RequestNo#'				
		</cfquery> 
				
		 <cfquery name="template"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT  * 
			FROM    WarehouseJournal 
			WHERE   Warehouse    = '#getRequest.Warehouse#'			
			AND     Area         = 'Sale'
		</cfquery>
		
		<cfif template.transactionTemplateMode1 eq "">
		     <cfset tmp = "Warehouse/Application/StockOrder/Quote/defaultQuote.cfm">            
		<cfelse>
		     <cfset tmp = "#template.transactionTemplateMode1#">			 
		</cfif>
				
		<cfquery name="getRequest"
				datasource="AppsMaterials"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
				SELECT * 
				FROM   CustomerRequest				
				WHERE  RequestNo = '#url.RequestNo#'				
		</cfquery> 
		
		<cfset subject = "#getRequest.mission# Quotation #url.RequestNo#">
		<cfset mailto  = "#getRequest.customerMail#">
		
		<cfquery name="setLog" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
								
			INSERT INTO CustomerRequestAction ( 	
				        RequestNo,
						ActionCode, 
						ActionMemo,
						OfficerUserId, 
						OfficerLastName, 
						OfficerFirstName )
					
			VALUES ( '#url.RequestNo#', 
					 'Send', 
					 '----', 			
					 '#session.acc#',
					 '#session.last#',
					 '#session.first#' )
					 
		</cfquery>
				
		<cfoutput>
     	<script>	
		
			ptoken.navigate('applyQuoteSend.cfm?id=mail&subject=#subject#&to=#mailto#&filename=#getrequest.mission# Quotation #url.RequestNo#&templatepath=#tmp#&id1=#url.requestNo#','contentbox1')
			
		</script>
		</cfoutput>

	</cfcase>
	
	<cfcase value="POS">
		
		<cfquery name="getRequest"
				datasource="AppsMaterials"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
				SELECT * FROM CustomerRequest				
				WHERE  RequestNo = '#url.RequestNo#'
		</cfquery>
		
		<cfquery name="warehouse"
				datasource="AppsMaterials"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
				SELECT * FROM Warehouse		
				WHERE  Warehouse = '#getRequest.Warehouse#'
		</cfquery>
		
		<!--- we verify if this can indeed be submitted to POS, line, customer and not a batch --->
		
		<cfquery name="getRequest"
				datasource="AppsMaterials"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
				SELECT * 
				FROM   CustomerRequest				
				WHERE  Requestno = '#url.RequestNo#'
				AND    CustomerId IN (SELECT Customerid FROM Customer) <!--- has a customer set --->
			    AND    RequestNo  IN (SELECT RequestNo FROM CustomerRequestLine) <!--- has lines --->				        		
				AND    NOT EXISTS (SELECT 'X' FROM WorkOrder.dbo.WorkOrderLine WHERE Source = 'Quote' and SourceNo = '#url.Requestno#')
        				<!--- was not processed already in workorder --->	
				AND    BatchNo   is NULL	<!--- is not processed in POS --->			
		</cfquery>
		
		<cfif getRequest.recordcount eq "0">
		
			<cfoutput>
			<table align="center">
			    <tr><td style="height:50px"></td></tr>
			    <tr class="labelmedium2"><td align="center" style="font-size:20px">Quote #url.RequestNo# can not be issued to POS</td></tr>
			    <tr class="labelmedium2"><td align="center" style="font-size:20px">Please add items and/or select a customer</td></tr>
			</table>
			</cfoutput>
				
		<cfelse>
		
		    <!---
			<cfquery name="clearRequest"
				datasource="AppsMaterials"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
				DELETE CustomerRequest				
				WHERE  Source        = 'Quote'
				AND    OfficerUserid = '#session.acc#'				
				AND    RequestNo NOT IN (SELECT RequestNo FROM CustomerRequestLine)
			</cfquery>
			--->
			
			<cfquery name="getRequest"
				datasource="AppsMaterials"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
				UPDATE CustomerRequest
				SET    ActionStatus = '1'
				WHERE  RequestNo = '#url.RequestNo#'		
				AND    ActionStatus  = '0' 		
			</cfquery>
			
			<cfoutput>
			
			<table align="center">
			    <tr><td style="height:50px"></td></tr>
			    <tr class="labelmedium2"><td align="center" style="font-size:20px">Quote was submitted to #Warehouse.WarehouseName# POS</td></tr>			  
			</table>
			</cfoutput>
								
			<script>									
				addquote() <!--- new quote --->			
			</script>			
			
		</cfif>
		
			
	</cfcase>
	
	<cfcase value="WorkOrder">
	
		<cfquery name="getRequest"
				datasource="AppsMaterials"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
				SELECT * 
				FROM   CustomerRequest				
				WHERE  Requestno = '#url.RequestNo#'
				AND    CustomerId IN (SELECT Customerid FROM Customer) <!--- has customer --->
			    AND    RequestNo  IN (SELECT RequestNo FROM CustomerRequestLine) <!--- has lines --->
				AND    Batchno is NULL <!--- is not processed --->
				AND    NOT EXISTS (SELECT 'X' FROM WorkOrder.dbo.WorkOrderLine WHERE Source = 'Quote' and SourceNo = '#url.Requestno#')
				 <!--- if action status <> 0 then it has been submitted already and we do not want ot have it twice --->
		</cfquery>
		
		<cfoutput>
		
			<cfif getRequest.recordcount eq "0">	
			
				<table align="center">
				    <tr><td style="height:50px"></td></tr>
				    <tr class="labelmedium2"><td align="center" style="font-size:20px">Quote #url.RequestNo# can not be issued as sales order</td></tr>
				    <tr class="labelmedium2"><td align="center" style="font-size:20px">Please add items and/or select a customer</td></tr>
				</table>	
			
			<cfelse>
		
	     	     <script>	
							  
					ptoken.navigate('#session.root#/workorder/application/workorder/create/quote/document.cfm?requestNo=#url.requestNo#','contentbox1')
				
			     </script>
				 
			</cfif>
			 
		</cfoutput>	
	
	</cfcase>

</cfswitch> 
