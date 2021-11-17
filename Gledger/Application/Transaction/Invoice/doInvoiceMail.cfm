
<!--- sent mail --->

<cfquery name="GetMail" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT * 
	FROM   Journal 
	WHERE  Journal IN (SELECT Journal FROM TransactionHeaderAction WHERE ActionId = '#url.actionid#')					 						 				 
</cfquery>	

<cfif GetMail.eMailTemplate neq "">
	<cfinclude template="../../../../../#GetMail.emailTemplate#">
<cfelse>
	<cf_receiptLedger actionid="#url.actionid#">	
</cfif>

<script>
	alert('eMail sent')
</script>

	