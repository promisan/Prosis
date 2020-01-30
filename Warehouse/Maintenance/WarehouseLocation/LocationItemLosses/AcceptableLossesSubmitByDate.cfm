
<cfset dateValue = "">
<cf_DateConvert Value="#Form.dateEffective#">
<cfset vDateEffective = dateValue>
<cf_tl id = "All transaction losses must be a number between 0% and 100%." class="text" var="msg">

<cfquery name="lossClasses" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		 
		SELECT   *
		FROM     Ref_LossClass
</cfquery>

<cfset isDirty = 0>

<cfloop query="lossClasses">

	<cfset vCodeFormatted = replace(Code," ","","ALL")>	
	
	<cfif isDefined('form.lossClass_#vCodeFormatted#')>
		
		<cfif Evaluate("form.lossCalculation_#vCodeFormatted#") eq "Transaction">
			<cfif Evaluate("form.lossQuantity_#vCodeFormatted#") lt 0 or Evaluate("form.lossQuantity_#vCodeFormatted#") gt 100>
				<cfset isDirty = 1>
			</cfif>
		</cfif>
		
	</cfif>

</cfloop>

<cfif isDirty eq 0>

	<cftransaction>

		<cfquery name="clear" 
		    datasource="AppsMaterials" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">		 		 	  
				 DELETE FROM ItemWarehouseLocationLoss
				 WHERE		Warehouse = '#url.warehouse#'
				 AND       	Location = '#url.location#'		
				 AND		ItemNo = '#url.itemNo#'
				 AND		UoM = '#url.UoM#'
				 AND		DateEffective = #vDateEffective#
		</cfquery>
	
		<cfloop query="lossClasses">
	
			<cfset vCodeFormatted = replace(Code," ","","ALL")>	
		
			<cfif isDefined('form.lossClass_#vCodeFormatted#')>
			
				<cfset vLossQuantity = Evaluate("form.LossQuantity_#vCodeFormatted#")>
				<cfif Evaluate("form.LossCalculation_#vCodeFormatted#") eq "Transaction">
					<cfset vLossQuantity = vLossQuantity / 100>
				</cfif>
			
				<cfquery name="insert" 
				    datasource="AppsMaterials" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">		 		 	  
						 INSERT INTO ItemWarehouseLocationLoss
						 	(
								Warehouse,
								Location,
								ItemNo,
								UoM,
								DateEffective,
								LossClass,
								LossCalculation,
								<cfif trim(Evaluate("form.transactionClass_#vCodeFormatted#")) neq "">TransactionClass,</cfif>
								LossQuantity,
								AcceptedPointer,
								OfficerUserId,
								OfficerLastName,
								OfficerFirstName
							)
						 VALUES
						 	(
								'#url.warehouse#',
								'#url.location#',
								'#url.itemNo#',
								'#url.uom#',
								#vDateEffective#,
								'#Evaluate("form.LossClass_#vCodeFormatted#")#',
								'#Evaluate("form.LossCalculation_#vCodeFormatted#")#',
								<cfif trim(Evaluate("form.transactionClass_#vCodeFormatted#")) neq "">'#Evaluate("form.transactionClass_#vCodeFormatted#")#',</cfif>
								'#vLossQuantity#',
								#Evaluate("form.AcceptedPointer_#vCodeFormatted#")#,
								'#SESSION.acc#',
								'#SESSION.last#',
								'#SESSION.first#'
							)
				</cfquery>
				
			</cfif>
			
		</cfloop>
	
	</cftransaction>
			
	<cfoutput>
		<script>
			ColdFusion.Window.hide('mydialog');
			ColdFusion.navigate('../LocationItemLosses/AcceptableLosses.cfm?warehouse=#url.warehouse#&location=#url.location#&itemNo=#url.itemNo#&UoM=#url.uom#&effectivedate=#Form.dateEffective#&class=','contentbox2');
		</script>
	</cfoutput>

<cfelse>
	<cfoutput>
	<script>
		alert('#msg#');
	</script>
	</cfoutput>
			
</cfif>