
<cfset vValue = 0>
<cfif url.value eq "true">
	<cfset vValue = 1>
</cfif>

<cfif url.list neq "">

	<cfquery name="selectItems"
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			
			UPDATE	Receipt#URL.Warehouse#_#SESSION.acc#
			SET		Selected = '#vValue#'
					<cfif vValue eq 0>
						,
						TransferWarehouse = null,
						TransferLocation  = null,
						TransferQuantity  = Quantity,
						TransferItemNo    = null,
						TransferUoM       = null,
						TransferMemo      = null
					</cfif>
			WHERE   TransactionId IN (#url.list#)
			
	</cfquery>
</cfif>

<cfif vValue eq 0>

	<cfloop list="#url.list#" index="id">
	
		<cfquery name="receipt"
			datasource="AppsTransaction" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT 	*
				FROM	Receipt#URL.Warehouse#_#SESSION.acc#
				WHERE   TransactionId = #id#
		</cfquery>
	
		<cfoutput>
			<script>
				document.getElementById('quantity_#id#').value = #receipt.quantity#;
			</script>
		</cfoutput>
		
	</cfloop>
	
</cfif>

<!--- <cf_tl id="Process Selected Receipts" var="1">
<cfoutput>
	<input type="Button" class="button10g" id="btnSubmit" value="  #lt_text#  " onclick="submitSelectedItems('#url.mission#','#url.warehouse#');" style="width:200px;">
</cfoutput> --->