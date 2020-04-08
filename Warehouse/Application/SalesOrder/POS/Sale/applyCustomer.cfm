
<!--- ------------------------------------------------------------------------------- --->
<!--- Ajax template template to set the customer upon selection and update the screen --->
<!--- ------------------------------------------------------------------------------- --->

<cfparam name="url.init"       default="0">
<cfparam name="url.batchid"    default="">
<cfparam name="url.mission"    default="">
<cfparam name="url.customerid" default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.addressid"  default="00000000-0000-0000-0000-000000000000">


<cfif url.customerid eq "00000000-0000-0000-0000-000000000000">

    <script>
		$(document).ready(function() {
			try {
				document.getElementById('customerselect').value = ''
				document.getElementById('customerselect').focus()
				document.getElementById('customerinvoiceselect').value = ''
				customertoggle('customerdata','#url.customerid#','open','#url.warehouse#','#url.addressid#');	
				document.getElementById('customerdata_toggle').className = 'hidden'
				
				} catch(e) {}
		});	 
	</script>
	
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
							 OfficerUserId, OfficerLastName, OfficerFirstName, Created)
					SELECT   CustomerId, Mission, OrgUnit, PersonNo, 
					         CustomerName,  Reference, PhoneNumber, MobileNumber, eMailAddress, PostalCode, 
							 Memo, TaxExemption, Terms, Operational, 
							 OfficerUserId, OfficerLastName, OfficerFirstName, Created
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
				
				 if (!!Prosis) {
					 //Hide all notifications
				     Prosis.notification.hide();
				 }
				
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
					
				 #customer.CustomerName#			
				 <input type="hidden" name="batchid" id="batchid" value="">
				 		
			<cfelse>
			
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
					FROM   CustomerAddress CA INNER JOIN
							System.dbo.Ref_Address A 
							ON CA.AddressId = A.AddressId
					WHERE  CustomerId = '#url.customerid#'
			</cfquery>
			
			
			
			
			<cfquery name="qExisting"
			datasource="AppsTransaction" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM   Sale#URL.Warehouse#
				WHERE CustomerId = '#url.customerid#'
				AND AddressId IS NOT NULL
				AND AddressId != '00000000-0000-0000-0000-000000000000'
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
		
		

		<script>
			$(document).ready(function() {
			    try {
			 	document.getElementById('customerselect').value = '#customer.reference#' 			
				customertoggle('customerdata','#url.customerid#','open','#url.warehouse#','#url.addressid#');	
				document.getElementById('customerdata_toggle').className = 'regular'
						 	
			 	} catch(e){console.log(e)}
			});			

		</script>
				
		<!--- important, we associated the pending lines to the current customer --->
		
		<cfquery name="associate" 
			 datasource="AppsTransaction" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			    UPDATE Sale#URL.Warehouse#
				SET    CustomerId = '#url.customerid#'
				WHERE  CustomerId = '00000000-0000-0000-0000-000000000000'					
		</cfquery>
		
		<cfquery name="associate" 
			 datasource="AppsTransaction" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			    UPDATE Sale#URL.Warehouse#
				SET    CustomerIdInvoice = '#url.customerid#'
				WHERE  CustomerIdInvoice = '00000000-0000-0000-0000-000000000000'					
		</cfquery>
				
		<cfquery name="associate" 
			 datasource="AppsTransaction" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			    UPDATE Sale#URL.Warehouse#
				SET    AddressId = '00000000-0000-0000-0000-000000000000'
				WHERE  AddressId IS NULL				
				AND CustomerId = '#url.customerid#'	
		</cfquery>
	
		
		<!--- ---------------------------------------- --->	
		<!--- populate additional customer information --->
		<!--- ---------------------------------------- --->
		
		<cfif url.init eq "0">
		
			<cfinclude template="applyCustomerSale.cfm">
			
		</cfif>
	
	</cfif>

</cfoutput>
