<cfparam name="Form.Warehouse" default="">

<cfset vMessage = "">
<cf_tl id = "The combination price already exists.  Operation aborted." class="message" var = "vAlready">

<cfset dateValue = "">
<CF_DateConvert Value="#form.DateEffective#">
<cfset STR = dateValue>

<cftransaction>

	<cfquery name="verifyUnique" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	TOP 1 PriceId
			FROM    ItemUoMPrice
			WHERE	ItemNo = '#Form.ItemNo#'
			AND		UoM = '#Form.UoM#'
			AND		(Mission <cfif trim(form.mission) eq "">IS NULL OR Mission = ''<cfelse>= '#Form.Mission#'</cfif>)
			AND		(Warehouse <cfif trim(form.Warehouse) eq "">IS NULL OR Warehouse = ''<cfelse>= '#Form.Warehouse#'</cfif>)
			AND		DateEffective = #STR#
			AND		PriceSchedule = '#Form.PriceSchedule#'
			AND		Currency = '#Form.Currency#'		
	</cfquery>

	<cfif ParameterExists(Form.Save)>	
		
		<cfif verifyUnique.recordCount gt 0>

			<cfset vMessage = vAlready>
		
		<cfelse>
		
			<cfquery name="Insert" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
			INSERT INTO ItemUoMPrice
					(ItemNo,
					UoM,
					PriceId,
					PriceSchedule,
					<cfif trim(Form.mission) neq "">Mission,</cfif>
					<cfif trim(Form.warehouse) neq "">Warehouse,</cfif>
					Currency,
					DateEffective,
					SalesPrice,
					TaxCode,
					<cfif trim(Form.CalculationMode) neq "">CalculationMode,</cfif>
					<cfif trim(Form.CalculationClass) neq "">CalculationClass,</cfif>
					<cfif trim(Form.CalculationPointer) neq "">CalculationPointer,</cfif>	           
					OfficerUserId,
					OfficerLastName,
					OfficerFirstName)
				VALUES
					('#Form.ItemNo#',
					'#Form.UoM#',
					newId(),
					'#Form.PriceSchedule#',
					<cfif trim(Form.Mission) neq "">'#Form.Mission#',</cfif>
					<cfif trim(Form.Warehouse) neq "">'#Form.Warehouse#',</cfif>
					'#Form.Currency#',
					#STR#,
					#Form.SalesPrice#,
					'#Form.TaxCode#',
					<cfif trim(Form.CalculationMode) neq "">'#Form.CalculationMode#',</cfif>
					<cfif trim(Form.CalculationClass) neq "">'#Form.CalculationClass#',</cfif>
					<cfif trim(Form.CalculationPointer) neq "">#Form.CalculationPointer#,</cfif>
					'#SESSION.acc#',
					'#SESSION.last#',
					'#SESSION.first#')
			
			</cfquery>
			
		</cfif>
			
	</cfif>

	<cfif ParameterExists(Form.Update)>	
		
		<cfif verifyUnique.recordCount gt 0 and Form.PriceId neq verifyUnique.PriceId>
		
			<cfset vMessage = vAlready>
		
		<cfelse>
		
			<cfquery name="Update" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE ItemUoMPrice
			SET 
				PriceSchedule       = '#Form.PriceSchedule#',
				Mission             = <cfif trim(Form.Mission) eq "">null<cfelse>'#Form.Mission#'</cfif>,
				Warehouse           = <cfif trim(Form.Warehouse) eq "">null<cfelse>'#Form.Warehouse#'</cfif>,
				Currency            = '#Form.Currency#',
				DateEffective       = #STR#,
				SalesPrice          = #Form.SalesPrice#,
				TaxCode             = '#Form.TaxCode#',
				CalculationMode     = <cfif trim(Form.CalculationMode) eq "">null<cfelse>'#Form.CalculationMode#'</cfif>,
				CalculationClass    = <cfif trim(Form.CalculationClass) eq "">null<cfelse>'#Form.CalculationClass#'</cfif>,
				CalculationPointer  = <cfif trim(Form.CalculationPointer) eq "">null<cfelse>#Form.CalculationPointer#</cfif>
			WHERE ItemNo              = '#Form.ItemNo#'
			AND   UoM                 = '#Form.UoM#'
			AND   PriceId             = '#Form.PriceId#'
			</cfquery>
			
		</cfif>

	</cfif>	

	<cfif ParameterExists(Form.Delete)> 	
				
		<cfquery name="Delete" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM ItemUoMPrice
			WHERE ItemNo = '#Form.ItemNo#'
			AND   UoM = '#Form.UoM#'
			AND   PriceId = '#Form.PriceId#'
		</cfquery>
		
	</cfif>

</cftransaction>

<cfoutput>
	<cfif vMessage neq "">
		<script>
			alert("#vMessage#");
		</script>
	<cfelse>
		<script>
			parent.parent.uompricerefresh('#Form.ItemNo#','#Form.UoM#','');
			parent.parent.ColdFusion.Window.destroy('mydialog',true);
		</script>
	</cfif>
</cfoutput>