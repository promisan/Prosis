
<!--- set eMail address --->

<cfif isValid("email","#url.email#")>		
	
	<cfquery name="Customer" 
		   datasource="AppsMaterials" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			UPDATE   Customer
			SET      EMailAddress = '#email#'
			WHERE    CustomerId = '#url.customeridinvoice#'       
	</cfquery>
	
	<cfoutput>
	
		<cf_tl id="eMail" var="1">
							
		<input type="button" 
		     class="button10g" 
		     onclick="ColdFusion.navigate('#session.root#/Warehouse/Application/SalesOrder/POS/Settlement/doInvoiceMail.cfm?batchid=#url.batchid#','mailbox')" 
		     style="height:28;width:150;font-size:13px" class="regular" name="save" id="save" value="#lt_text#">
			 
	</cfoutput>

</cfif>		 