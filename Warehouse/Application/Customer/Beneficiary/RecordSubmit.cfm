<cfset dateValue = "">
<cf_dateConvert value="#form.BirthDate#">
<cfset vDateEffective = dateValue>

<cftransaction>
		<cfquery name="setBeneficiary"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE CustomerBeneficiary
				SET    	
					FirstName = '#FORM.FirstName#',
					LastName = '#FORM.LastName#',
					BirthDate = #vDateEffective#,
					Gender = '#FORM.Gender#',
					Relationship  = '#FORM.Relationship#'
				WHERE  	BeneficiaryId = '#URL.BeneficiaryId#'	
		</cfquery>	
</cftransaction>


	<script>
		opener.applyfilter('1','','content')
		window.close()
	</script>