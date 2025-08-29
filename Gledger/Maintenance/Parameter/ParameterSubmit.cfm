<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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


	
