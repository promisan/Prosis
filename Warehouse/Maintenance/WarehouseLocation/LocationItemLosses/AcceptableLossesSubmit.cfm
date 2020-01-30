
<cfset Form.LossQuantity = replace(Form.LossQuantity, ',', '', 'ALL')>
<cfset isDirty = 0>

<cf_tl id="Please, enter a valid numeric loss quantity between 0 and 1." class="text" var="msg1">
<cf_tl id="This date and class is already recorded!" class="text" var = "msg2">


<cfif form.LossCalculation eq "Transaction">
	<cfif form.lossQuantity lt 0 or form.lossQuantity gt 1>
		<cfset isDirty = 1>
		<cfoutput>
		<script>
			alert('#msg1#');
		</script>
		</cfoutput>
	</cfif>
</cfif>

<cfif isDirty eq 0>

	<cfset dateValue = "">
	<cf_DateConvert Value="#Form.dateEffective#">
	<cfset vDateEffective = dateValue>
	
	<cfquery name="validate" 
		    datasource="AppsMaterials" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			SELECT	*
			FROM	ItemWarehouseLocationLoss
			WHERE	Warehouse = '#url.warehouse#'
			AND     Location = '#url.location#'		
			AND		ItemNo = '#url.itemNo#'
			AND		UoM = '#url.UoM#'
			AND		DateEffective = #vDateEffective#
			AND		LossClass = '#Form.lossClass#'
	</cfquery>
	
	
	<cfif url.effDate eq "" and url.class eq "">
	
		<cfif validate.recordCount eq 0>
	
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
							<cfif trim(form.transactionClass) neq "">TransactionClass,</cfif>
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
							'#Form.LossClass#',
							'#Form.LossCalculation#',
							<cfif trim(form.transactionClass) neq "">'#Form.TransactionClass#',</cfif>
							#Form.LossQuantity#,
							#Form.AcceptedPointer#,
							'#SESSION.acc#',
							'#SESSION.last#',
							'#SESSION.first#'
						)
			</cfquery>
			
			<cfoutput>
				<script>
					ColdFusion.Window.hide('mydialog');
					ColdFusion.navigate('../LocationItemLosses/AcceptableLosses.cfm?warehouse=#url.warehouse#&location=#url.location#&itemNo=#url.itemNo#&UoM=#url.uom#&effectivedate=#Form.dateEffective#&class=#Form.lossClass#','contentbox2');
				</script>
			</cfoutput>
		
		<cfelse>
			<cfoutput>
			<script>
				alert('#msg2#');
			</script>
			</cfoutput>
		
		</cfif>
	
	<cfelse>
	
		<cfset vyear = mid(url.effDate, 1, 4)>
		<cfset vmonth = mid(url.effDate, 6, 2)>
		<cfset vday = mid(url.effDate, 9, 2)>
		<cfset vDateEffectiveOld = createDate(vyear, vmonth, vday)>
	
		<cfif validate.recordCount eq 0 or (vDateEffective eq vDateEffectiveOld and Form.lossClass eq url.class)>
		
			<cfquery name="update" 
			    datasource="AppsMaterials" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">		 		 	  
						UPDATE 	ItemWarehouseLocationLoss
					 	SET		DateEffective 		= #vDateEffective#,
								LossClass 			= '#Form.LossClass#',
								LossCalculation 	= '#Form.LossCalculation#',
								<cfif Form.LossCalculation neq "Month">
								TransactionClass    = NULL,
								<cfelse>								
								TransactionClass	= '#Form.TransactionClass#',
								</cfif>
								LossQuantity		= '#Form.LossQuantity#',
								AcceptedPointer		= #Form.AcceptedPointer#
						WHERE	Warehouse		 	= '#url.warehouse#'
						AND     Location 			= '#url.location#'		
						AND		ItemNo 				= '#url.itemNo#'
						AND		UoM 				= '#url.UoM#'
						AND		DateEffective 		= #vDateEffectiveOld#
						AND		LossClass 			= '#url.class#'
			</cfquery>
	
			<cfoutput>
				<script>
					ColdFusion.Window.hide('mydialog');
					ColdFusion.navigate('../LocationItemLosses/AcceptableLosses.cfm?warehouse=#url.warehouse#&location=#url.location#&itemNo=#url.itemNo#&UoM=#url.uom#&effectivedate=#Form.dateEffective#&class=#Form.lossClass#','contentbox2');
				</script>
			</cfoutput>
		
		<cfelse>
			<cfoutput>
			<script>
				alert('#msg2#');
			</script>
			</cfoutput>		
		
		</cfif>
	
	</cfif>

</cfif>