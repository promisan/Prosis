
<!---

	Function to get a strapping value
	
	id          = ItemWarehouseLocation identifier
	lookupValue = value to look up in the strapping table
	getType     = type expected, it could be "measurement" in centimeters, or "quantity" in uoms.

 --->

<cfparam name="Attributes.id"           default="00000000-0000-0000-0000-000000000000"> <!--- itemLocationId from ItemWarehouseLocation --->	
<cfparam name="Attributes.lookupValue"  default="1"> <!--- numeric value to look for --->
<cfparam name="Attributes.getType"      default="measurement"> <!--- quantity or measurement --->

<cfset returnValue = -1>
<cfset isDirty = 0>

<!--- remove empty spaces --->
<cfset Attributes.lookupValue = trim(Attributes.lookupValue)>

<!--- not empty values --->
<cfif Attributes.lookupValue eq "">
	<cfset isDirty = 1>
</cfif>

<!--- a valid number --->
<cfif not isNumeric(Attributes.lookupValue)>
	<cfset isDirty = 1>
</cfif>

<cfif isDirty eq 0>

	<cfset returnValue = 0>
	<cfset priorQuantity = 0>
	<cfset priorMeasurement = 0>
	<cfset lowMeasurement = 0>
	<cfset lowQuantity = 0>
	<cfset highMeasurement = 0>
	<cfset highQuantity = 0>
	<cfset vDifference = 0>
	<cfset vDifferenceReal = 0>
	
	<cfquery name="StrappingLookup" 
	    datasource="AppsMaterials" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">		 		 	  
			 SELECT   	*
			 FROM     	ItemWarehouseLocation L,
			 			ItemWarehouseLocationStrapping S
			 WHERE	  	L.Warehouse = S.Warehouse
			 AND      	L.Location = S.Location
			 AND	  	L.ItemNo = S.ItemNo
			 AND	  	L.UoM = S.UoM
			 AND		L.ItemLocationId = '#Attributes.id#'
			 ORDER BY S.Measurement <cfif lcase(Attributes.getType) eq "measurement">DESC<cfelseif lcase(Attributes.getType) eq "quantity">ASC</cfif>
	</cfquery>
	
	<cfloop query="StrappingLookup">
	
		<cfif lcase(Attributes.getType) eq "quantity">
			<cfif priorMeasurement lte Attributes.lookupValue and measurement gte Attributes.lookupValue>
				<cfset lowMeasurement = priorMeasurement>
				<cfset lowQuantity = priorQuantity>				
				<cfset highMeasurement = measurement>
				<cfset highQuantity = quantity>
			</cfif>
		</cfif>
		
		<cfif lcase(Attributes.getType) eq "measurement">
			<cfif priorQuantity lte Attributes.lookupValue and quantity gte Attributes.lookupValue>
				<cfset lowMeasurement = priorMeasurement>
				<cfset lowQuantity = priorQuantity>				
				<cfset highMeasurement = measurement>
				<cfset highQuantity = quantity>
			</cfif>
		</cfif>
		
		<cfset priorQuantity    = quantity>		
		<cfset priorMeasurement = measurement>
		
	</cfloop>
	
	<cfif lcase(Attributes.getType) eq "quantity">
		<cfset vDifference       = highMeasurement - lowMeasurement>
		<cfset vDifferenceReal   = Attributes.lookupValue - lowMeasurement>
	</cfif>
	
	<cfif lcase(Attributes.getType) eq "measurement">
		<cfset vDifference     = highQuantity - lowQuantity>
		<cfset vDifferenceReal = Attributes.lookupValue - lowQuantity>
	</cfif>
	
	<cfif vDifference gt 0>
		<cfset vDifferential = vDifferenceReal / vDifference>
		
		<cfif lcase(Attributes.getType) eq "quantity">
			<cfset returnValue   = lowQuantity + (vDifferential * (highQuantity - lowQuantity))>
		</cfif>
		
		<cfif lcase(Attributes.getType) eq "measurement">
			<cfset returnValue = lowMeasurement + (vDifferential * (highMeasurement - lowMeasurement))>
		</cfif>
	<cfelse>
		<cfset returnValue = -1>
	</cfif>

</cfif>

<cfset caller.resultStrappingValue = returnValue>