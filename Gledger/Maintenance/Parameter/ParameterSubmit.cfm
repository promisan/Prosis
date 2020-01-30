<cf_systemscript>

<cfquery name="Update" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE Parameter
	SET    BaseCurrency          = '#Form.BaseCurrency#'
</cfquery>
	
<cfquery name="MissionSelect" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * FROM Ref_ParameterMission
	WHERE Mission IN (SELECT Mission
	                  FROM   Organization.dbo.Ref_MissionModule 
					  WHERE  SystemModule = 'Accounting')
</cfquery>

<cfloop query="MissionSelect">
	
	<cfset level  = Evaluate("FORM.#Mission#_AdministrationLevel")>
	<cfset per    = Evaluate("FORM.#Mission#_CurrentAccountPeriod")>
	<cfset tax    = Evaluate("FORM.#Mission#_TaxExemption")>
	<cfset amt    = Evaluate("FORM.#Mission#_AmountPresentation")>
	<cfset emp    = Evaluate("FORM.#Mission#_EmployeeAccount")>
		
	<cfquery name="Update" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_ParameterMission
		SET    AdministrationLevel = '#level#',
		       CurrentAccountPeriod = '#per#', 
			   TaxExemption         = '#tax#',
			   AmountPresentation   = '#amt#',
			   EmployeeGLAccount    = '#emp#',
			   OfficerUserId 	 = '#SESSION.ACC#',
			   OfficerLastName  = '#SESSION.LAST#',
			   OfficerFirstName = '#SESSION.FIRST#',
			   Created          =  getdate()			   
		WHERE  Mission = '#Mission#'
	</cfquery>
	
</cfloop>


<cfoutput>
<script language="JavaScript">

	window.location = "ParameterEdit.cfm?idmenu=#url.idmenu#"

</script>
</cfoutput>


	
