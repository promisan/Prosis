
<cfset dateValue = "">
<cf_DateConvert Value="#Form.DateEffective#">
<cfset vEffective = dateValue>
<cfset vEffective = dateAdd('h',Int(Form.TimeEffective_Hour),vEffective)>
<cfset vEffective = dateAdd('n',Int(Form.TimeEffective_Minute),vEffective)>

<cfif Form.DateExpiration neq "">
	<cfset dateValue = "">
	<cf_DateConvert Value="#Form.DateExpiration#">
	<cfset vExpiration = dateValue>
	<cfset vExpiration = dateAdd('h',Int(Form.TimeExpiration_Hour),vExpiration)>
	<cfset vExpiration = dateAdd('n',Int(Form.TimeExpiration_Minute),vExpiration)>
</cfif>

<cfset vId = "">

<cfif url.id1 eq "">
	
	<cf_AssignId>
	<cfset vId = rowguid>
	
	<cfquery name="Insert" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO Promotion
			(
				Mission,
				PromotionId,
				Description,
				<cfif Form.CustomerLabel neq "">CustomerLabel,</cfif>
				DateEffective,
				<cfif Form.DateExpiration neq "">DateExpiration,</cfif>
				Operational,
				Priority,
				OfficerUserId,
				OfficerLastName,
				OfficerFirstName
			)	
		VALUES
			(
				'#Form.mission#',
				'#vId#',
				'#Form.Description#',
				<cfif Form.CustomerLabel neq "">'#Form.CustomerLabel#',</cfif>
				#vEffective#,
				<cfif Form.DateExpiration neq "">#vExpiration#,</cfif>
				#Form.Operational#,
				'#form.Priority#',
				'#SESSION.acc#',
				'#SESSION.last#',
				'#SESSION.first#'
			)
	</cfquery>
	
	<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                     action="Insert" 
						 content="#form#">
	
<cfelse>

	<cfset vId = url.id1>
	
	<cfquery name="Update" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Promotion
		SET
			Mission			= '#Form.mission#',
			Description		= '#Form.description#',
			Priority        = '#Form.Priority#',
			CustomerLabel   = <cfif Form.CustomerLabel neq "">'#Form.CustomerLabel#'<cfelse>null</cfif>,
			DateEffective 	= #vEffective#,
			DateExpiration 	= <cfif Form.DateExpiration neq "">#vExpiration#<cfelse>null</cfif>,
			Operational		= #Form.operational#
		WHERE
			PromotionId		= '#vId#'
	</cfquery>
	
	<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                     action="Update" 
						 content="#form#">

</cfif>

<cfoutput>
	<script>
		window.location = 'RecordEdit.cfm?idmenu=#url.idmenu#&id1=#vId#&fmission=#url.fmission#';
		window.opener.ColdFusion.navigate('RecordListingDetail.cfm?idmenu=#url.idmenu#&fmission=#url.fmission#','divListing');
	</script>
</cfoutput>