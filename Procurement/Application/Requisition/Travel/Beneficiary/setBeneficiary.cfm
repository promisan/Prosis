<cfquery name="getPerson" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	*
	    FROM 	Employee.dbo.Person 
		WHERE 	PersonNo = '#url.personno#'
</cfquery>

<cfquery name="getPersonPassport" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT TOP 1 *
		FROM    Employee.dbo.PersonDocument
		WHERE 	PersonNo = '#URL.Personno#'
		AND       DocumentType = 'Passport'
		AND       ActionStatus = '1'
		ORDER BY DateEffective DESC
</cfquery>

<cfoutput>
	<script>
		$('##PersonNo', '##beneficiaryform').val('#getPerson.personno#');
		$('##lastname', '##beneficiaryform').val('#getPerson.lastname#');
		$('##firstname', '##beneficiaryform').val('#getPerson.firstname#');
		$('##nationality', '##beneficiaryform').val('#getPerson.nationality#');
		$('##birthdate', '##beneficiaryform').val('#dateformat(getPerson.birthdate,client.dateformatshow)#');
		$('##reference', '##beneficiaryform').val('#getPersonPassport.documentReference#');
	</script>
</cfoutput>