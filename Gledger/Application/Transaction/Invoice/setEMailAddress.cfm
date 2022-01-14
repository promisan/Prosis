
<!--- set eMail address --->

<cfif isValid("email","#url.email#")>		
	
	<cfquery name="Customer" 
		   datasource="AppsLedger" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			UPDATE   TransactionHeaderAction
			SET      EMailAddress = '#email#'
			WHERE    ActionId = '#url.actionid#'       
	</cfquery>
			
	<cfoutput>
	
		<cf_tl id="eMail" var="1">
							
		<input type="button" 
		     class="button10g" 
		     onclick="ptoken.navigate('#session.root#/GLedger/Application/Transaction/Invoice/doInvoiceMail.cfm?actionid=#url.actionid#','mailbox')" 
		     style="height:28;width:150;font-size:13px;border:1px solid silver" class="regular" name="save" id="save" value="#lt_text#">
			
	</cfoutput>

</cfif>		 