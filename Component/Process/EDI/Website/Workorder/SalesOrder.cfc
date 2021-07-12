
<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Salesorder">
			
	<cffunction name="recordOrder" access="public"  displayname="Create Sales Order" securejson="true">
	
		    <cfargument name = "Cart"  type="string"  required="true"   default="">				
			<cfargument name = "Mode"  type="string"  required="true"   default="Order">	 <!--- Quote | Order --->
			
			<!--- meta for Request mode			
			  check if a sale already exists for the warehouse, customer and addressid, only if not we add,			
			--->			
			
			<cfset arrayCart       = deserializeJSON(Cart)>
			
			<cfset vStore          = arrayCart['store']>
			<cfset vCustomer       = arrayCart['customer']>
			<cfset vCustomer       = arrayCart['shipping']>
			<cfset vCustomer       = arrayCart['billing']>
			<cfset vProduct        = arrayCart['products']>
			
			<cfset Mission         = vStore.Mission>
			<cfset Warehouse       = vStore.Warehouse>
			
			<cfset CustomerId      = vCustomer.CustomerId>
			<cfset AddressId       = vCustomer.AddressId>
	
    	<!--- 1. verify the customer information and record customer if not exist yet -> send eMail for new account., followed by order conformation
		      2. CustomerPayer : record the CC info, accountNo, name, expiration and security code
		      3. Create a workorder and workorderline : 1:1
			  4. Record address information for shipping (and invoice address)
			  5. WorkOrderLineItem records for the order		
		--->	
	
	</cffunction>
	
</cfcomponent>	