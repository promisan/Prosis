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
<!--- Ajax template template to set the customer upon selection and update the screen --->
<!--- ------------------------------------------------------------------------------- --->

<cfparam name="url.init"       default="0">
<cfparam name="url.requestno"  default="">
<cfparam name="url.batchid"    default="">
<cfparam name="url.mission"    default="">
<cfparam name="url.customerid" default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.addressid"  default="00000000-0000-0000-0000-000000000000">

<cfif url.customerid eq "00000000-0000-0000-0000-000000000000">

	<cfoutput>
    <script>
		$(document).ready(function() {
			try {
				document.getElementById('customerselect').value          = ''
				document.getElementById('customerselect').focus()				
				document.getElementById('customerinvoiceselect').value   = ''	
				document.getElementById('customerdata_toggle').className = 'hide'
											
				customertoggle('customerdata','#url.customerid#','hide','#url.warehouse#','#url.addressid#');	
											
				} catch(e) {}
		});	 
	</script>
	</cfoutput>
	
<cfelseif isvalid("GUID",url.customerid)>
		
		<cfquery name="getcustomer" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			    SELECT  *
				FROM   Customer
				WHERE  CustomerId = '#url.customerid#'	    										   
		</cfquery>	
		
		<cf_verifyOperational module="WorkOrder" Warning="No">
		
		<cfif getCustomer.recordcount eq "0" and operational eq "1">			
		
			<!--- record needs to be synced from workorder --->
			
			<cfquery name="customer" 
				  datasource="AppsMaterials" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					INSERT INTO Customer
						    (CustomerId, 
							 Mission, OrgUnit, PersonNo, 
							 CustomerName, Reference, PhoneNumber, MobileNumber, eMailAddress, PostalCode, 
							 Memo, TaxExemption, Terms, Operational, 
							 OfficerUserId, OfficerLastName, OfficerFirstName)
					SELECT   CustomerId, Mission, OrgUnit, PersonNo, 
					         CustomerName,  Reference, PhoneNumber, MobileNumber, eMailAddress, PostalCode, 
							 Memo, TaxExemption, Terms, Operational, 
							 '#session.acc#', '#session.last#','#session.first#'
					FROM     WorkOrder.dbo.Customer
					WHERE    CustomerId = '#url.customerid#'
			</cfquery>
				
		</cfif>
		
</cfif>	

<cfoutput>

	<cfif (url.customerid eq "" or url.customerid eq "insert") and url.init eq "0">
			    	    	
			<script language="JavaScript">
			
				<cf_tl id="Customer not found. Do you want to record this customer" var="1">
				
				<cfoutput>
									 				
				 if (confirm("#lt_text#?")) {
				 				 
					  ref = document.getElementById("customeridselect_val").value;
										 
					  ProsisUI.createWindow('customeradd', 'Add Customer', '',{x:100,y:100,width:700,height:document.body.clientHeight-80,resizable:false,modal:true,center:true})			  
			  	      ptoken.navigate('#SESSION.root#/Warehouse/Application/SalesOrder/POS/Sale/addCustomer.cfm?mission=#url.mission#&warehouse=#url.warehouse#&reference='+ref,'customeradd');
					  
				     // if (ret != 1 && ret) {					  
						  
					//	  document.getElementById('customeridselect').value = ret		 
			         //     ColdFusion.navigate('#SESSION.root#/warehouse/application/SalesOrder/POS/Sale/applyCustomer.cfm?warehouse=#url.warehouse#&customerid='+ret,'customerbox')					   	 
					//	  }
				  	
	  			  } else {
				    document.getElementById('customerselect').focus()
				  }
				  
			  	</cfoutput>
				
			</script>
					
			<cfabort>
		
	<cfelse>	
	
			<cfquery name="customer" 
			  datasource="AppsMaterials" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				    SELECT  *
					FROM   Customer
					WHERE  CustomerId = '#url.customerid#'	    										   
			</cfquery>		
														
			<cfif url.batchid eq "">
			
				<span style="padding-left:5px;padding-right:5px">#customer.CustomerName# <font size="2">#Customer.Reference#</span>
				 <input type="hidden" name="batchid" id="batchid" value="">
				 		
			<cfelse>
			
				<!--- correction on an already save batch --->
			
				<cfquery name="Batch" 
				  datasource="AppsMaterials" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				    SELECT  *
					FROM   WarehouseBatch
					WHERE  BatchId = '#url.BatchId#'	   							   
				</cfquery>		
				
			    #customer.CustomerName#		
				<font face="Calibri" size="2" color="808080">&nbsp;<u>#Batch.BatchReference#/#Batch.BatchNo#</u></font>		
				<input type="hidden" name="batchid" id="batchid" value="#url.batchid#">
				
			</cfif>		
								
			<cfquery name="customerAddress" 
			  datasource="AppsMaterials" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				  SELECT  A.*
				  FROM   CustomerAddress CA INNER JOIN  System.dbo.Ref_Address A ON CA.AddressId = A.AddressId
				  WHERE  CustomerId = '#url.customerid#'				 
			</cfquery>			
			
			<cfquery name="qExisting"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM   CustomerRequest
				WHERE  CustomerId = '#url.customerid#'
				AND    AddressId IS NOT NULL
				AND    AddressId != '00000000-0000-0000-0000-000000000000'
				AND    ActionStatus = '0'
				
			</cfquery> 						

			<cfif url.batchid eq "">	
					
				<cfif customerAddress.recordcount neq 0>
				
					<cfif url.addressid eq "00000000-0000-0000-0000-000000000000" and qExisting.recordcount neq 0>
						<cfset url.addressid = qExisting.AddressId>
					</cfif>	
					
				</cfif>	
			<cfelse>
				<cfset url.addressid = Batch.AddressId>
			</cfif>			
			
			<script language="JavaScript">
							
			    try {	
								   																			
				 	document.getElementById('customerselect').value    = '#customer.customerserialNo#' 											
					customertoggle('customerdata','#url.customerid#','open','#url.warehouse#','#url.addressid#');									
					document.getElementById('customerdata_toggle').className = 'regular'										 	
				} catch(e){console.log(e)}
					
			</script>
				
			<!--- important, we associated the pending lines to the current customer as a special case
			we might disable this and require custom selectio first --->
						
			<cfparam name="url.quote" default="">
												
			<cfquery name="getNULLSale" 
				 datasource="AppsMaterials" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				    SELECT * 
					FROM   CustomerRequest
					WHERE  Warehouse = '#url.warehouse#'
					AND    CustomerId = '00000000-0000-0000-0000-000000000000'					
					AND    ActionStatus != '9'
			</cfquery>
						
			<cfif url.quote eq "add">
			
				<!--- we make sure the system will generate a new quote --->
			
				<cfquery name="setPrior" 
					 datasource="AppsMaterials" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					    UPDATE CustomerRequest
						SET    ActionStatus = '1'
						WHERE  Warehouse  = '#url.warehouse#'
						AND    CustomerId = '#url.customerid#'		
						AND    AddressId  = '#url.addressid#'			
						AND    ActionStatus != '9' 				
				</cfquery>							
			
			</cfif>
			
			<cfif url.quote eq "delete">
			
				<!--- we make sure the system will generate a new quote --->
			
				<cfquery name="removeQuote" 
					 datasource="AppsMaterials" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					    DELETE FROM CustomerRequest
						WHERE  RequestNo = '#url.requestNo#'				
				</cfquery>		
				
				<cfquery name="getPrior" 
				 datasource="AppsMaterials" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				    SELECT   * 
					FROM     CustomerRequest
					WHERE    Warehouse  = '#url.warehouse#'
					AND      CustomerId = '#url.customerid#'		
					AND      AddressId  = '#url.addressid#'		
					AND      BatchNo is NULL	
					AND      ActionStatus != '9'					
					ORDER BY RequestNo DESC
				</cfquery>
				
				<cfif getPrior.recordcount eq "0">
				
					<script>
					    document.getElementById('buttonnew').click()					    
					</script>					
								
				<cfelse>
				
				     <cfset url.requestNo = getPrior.RequestNo>
				
				</cfif>
			
			</cfif>
			
			<cfquery name="getPrior" 
				 datasource="AppsMaterials" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				    SELECT * 
					FROM   CustomerRequest
					WHERE  Warehouse  = '#url.warehouse#'
					AND    CustomerId = '#url.customerid#'		
					AND    AddressId  = '#url.addressid#'			
					AND    ActionStatus = '0'					
			</cfquery>
			
			<cfif getPrior.recordcount gte "1">
			
				<cfquery name="clean" 
				 datasource="AppsMaterials" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				    DELETE FROM   CustomerRequest
					WHERE  Warehouse = '#url.warehouse#'
					AND    CustomerId = '00000000-0000-0000-0000-000000000000'								
				</cfquery>
				
				<cfif url.requestno eq "">								
					<cfset url.requestNo = getPrior.Requestno>
				</cfif>
							
			<cfelse>
						
				<cfif getNULLSale.recordcount eq "1">
				
					<cfquery name="associate" 
						 datasource="AppsMaterials" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						    UPDATE CustomerRequest
							SET    CustomerId   = '#url.customerid#', 
							       AddressId    = '#url.addressid#'
							WHERE  Requestno    = '#getNULLSale.RequestNo#'					
					</cfquery>
				
					<cfquery name="associate" 
						 datasource="AppsMaterials" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						    UPDATE CustomerRequestLine
							SET    CustomerIdInvoice = '#url.customerid#'
							WHERE  RequestNo         = '#getNULLSale.RequestNo#'					
					</cfquery>
						
					<cfquery name="associate" 
						 datasource="AppsMaterials" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						    UPDATE CustomerRequest
							SET    AddressId = '00000000-0000-0000-0000-000000000000'
							WHERE  Requestno = '#getNULLSale.RequestNo#'
							AND    AddressId IS NULL									
					</cfquery>
					
					<cfset url.requestNo = getNULLSale.RequestNo>
			
				</cfif>					
				
				
			</cfif>	
						
			<cfif url.requestNo eq "">
			
				<!--- we assign a new request no --->

				<cf_setCustomerRequest>
				<cfset url.requestNo  = thisrequestNo>
	
			</cfif>
							
			<!--- ---------------------------------------- --->	
			<!--- populate additional customer information --->
			<!--- ---------------------------------------- --->
			
			<cfif url.init eq "0">
			
				<cfinclude template="applyCustomerSale.cfm">
				
			</cfif>
	
	</cfif>

</cfoutput>
