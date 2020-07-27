
<!--- update the status --->

<cfparam name="url.batchcheck" default="yes">
														
<cfquery name="get"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     ItemTransaction 
	WHERE    TransactionId   = '#url.transactionid#'	
</cfquery>

<!--- we are getting the mode of this transaction --->
														
<cfquery name="Check"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     ItemWarehouseLocationTransaction 
	WHERE    Warehouse       = '#get.warehouse#'
	AND      Location        = '#get.Location#'
	AND      ItemNo          = '#get.itemno#'
	AND      UoM             = '#get.transactionuom#'
	AND      TransactionType = '#get.transactiontype#'
</cfquery>

<cfoutput>

<cfif get.ActionStatus eq "1">

     <!--- cleared --->
	
	 <img src="#SESSION.root#/Images/validate.gif" border="0" 								  
		 align="absmiddle">
		 
	<!--- ----------------------------- --->
	<!--- create a shipping transaction --->	 
		 
    <cfif get.TransactionType eq "2">
		 		 
		<cfquery name="Check"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT * FROM ItemTransactionShipping
			WHERE TransactionId = '#get.transactionid#'
		</cfquery>	
		
		<cfif check.recordcount eq "0">
	
			<cfquery name="Insert"
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO ItemTransactionShipping
				(TransactionId,OfficerUserId,OfficerLastName,OfficerFirstName)
				SELECT     TransactionId,'#SESSION.acc#','#SESSION.last#','#SESSION.first#'
				FROM       ItemTransaction
				WHERE      TransactionId = '#get.transactionid#'
			</cfquery>	
		
		</cfif>
	
	</cfif>
		 		 
<cfelse>

	
	<cfif check.clearancemode eq "1" or check.clearancemode eq "">
	
	 <img src="#SESSION.root#/Images/pending.gif" border="0" 								  
		 align="absmiddle" alt="Batch clearance">	 
	
	<cfelse>
	
	 <img src="#SESSION.root#/Images/pending2.gif" border="0" 								  
		 align="absmiddle" alt="Process workflow">									
	
	</cfif>	 
		 
</cfif>	 	


<!--- this will check if the overall transaction can be processed, driven by workflow (inventory) so the action can be automatically set --->

<cfif url.batchcheck eq "yes">

	<script>
		ptoken.navigate('setBatchStatus.cfm?batchno=#get.transactionBatchNo#','status')
	</script>
	
</cfif>
	
</cfoutput>	
	

