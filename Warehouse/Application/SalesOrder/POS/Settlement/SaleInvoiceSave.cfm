
<cfparam name="url.batchreference" default="instant">

<cfif url.batchreference eq "">
	<cf_alert message="Please record the printed invoice No">
	<cfabort>
</cfif>

<cfquery name="setSale"
 datasource="AppsLedger" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 	UPDATE   TransactionHeaderAction
	SET      ActionReference1 = '#url.batchreference#'
	WHERE    ActionId = '#url.actionid#'	
</cfquery>

<!--- the below we likely will disable onwards --->

<cfquery name="setSale"
 datasource="AppsMaterials" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 	UPDATE   WarehouseBatch
	SET      BatchReference = '#url.batchreference#'
	WHERE    BatchId = '#url.batchid#'	
</cfquery>

<script>
    try { ProsisUI.closeWindow('wsettle',true)} catch(e){};
</script> 