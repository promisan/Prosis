<cfquery name="validate" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	*
	    FROM 	RequisitionLineBeneficiary 
		WHERE 	1=1
		<cfif url.Beneficiaryid neq "">
		AND 	Beneficiaryid = '#URL.Beneficiaryid#'
		<cfelse>
		AND 	1=0
		</cfif>
</cfquery>

<cfquery name="Line" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  RequisitionLine 
	WHERE RequisitionNo = '#URL.requisitionno#'
</cfquery>

<cfset dateValue = "">
<cf_DateConvert Value="#Form.birthdate#">
<cfset vBirthdate = dateValue>

<cfif validate.recordcount eq 0>

	<cfquery name="validatePerson" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT 	*
		    FROM 	RequisitionLineBeneficiary 
			WHERE 	PersonNo = '#form.personno#'
			AND 	Requisitionno = '#url.requisitionno#'
			AND 	PersonNo != ''
	</cfquery>
	
	<cfif validateperson.recordcount gt 0>
	
		<cfoutput>
			<cf_tl id="This person has been added already." var="vErrormessage">
			<script>
				alert('#vErrormessage#');
			</script>
		</cfoutput>
	
	<cfelse>

		<cfquery name="insert" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO [dbo].[RequisitionLineBeneficiary]
				           ([RequisitionNo]
				           ,[PersonNo]
				           ,[LastName]
				           ,[FirstName]
				           ,[Nationality]
				           ,[BirthDate]
				           ,[Reference]
				           ,[OfficerUserId]
				           ,[OfficerLastName]
				           ,[OfficerFirstName])
				     VALUES
				           (
						   	'#url.requisitionno#'
							,'#form.personno#'
							,'#trim(form.LastName)#'
							,'#trim(form.FirstName)#'
							,'#form.Nationality#'
							,#vBirthdate#
							,'#trim(form.reference)#'
							,'#session.acc#'
							,'#session.last#'
							,'#session.first#')
		</cfquery>
	
	</cfif>
	
<cfelse>

	<cfquery name="update" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE 	RequisitionLineBeneficiary 
			SET		PersonNo = '#form.personno#',
					LastName = '#trim(form.LastName)#',
					FirstName = '#trim(form.FirstName)#',
					Nationality = '#form.Nationality#',
					birthdate = #vBirthdate#,
					reference = '#trim(form.reference)#'
			WHERE 	Beneficiaryid = '#URL.Beneficiaryid#'
	</cfquery>

</cfif>

<cfoutput>
	<script>
		ProsisUI.closeWindow('dialogbeneficiary');
		ptoken.navigate('#session.root#/procurement/application/requisition/travel/beneficiary/beneficiarylisting.cfm?requisitionno=#url.requisitionno#&mission=#line.mission#&access=#url.access#', 'divBeneficiary');
	</script>
</cfoutput>