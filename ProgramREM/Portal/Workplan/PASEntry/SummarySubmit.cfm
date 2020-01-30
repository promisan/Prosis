<cfoutput>

<cfif ParameterExists(Form.Process)>

   	 
	 <cfquery name="Verify" 
		datasource="appsEPAS" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE Contract
			SET    ActionStatus = '1'
			WHERE  ContractId = '#URL.ContractID#'
	 </cfquery>	
	 
	 <cflocation url="Summary.cfm?Code=#URL.Code#&ContractID=#URL.ContractID#&Section=#URL.Section#" addtoken="No">
		 
</cfif>		 

</cfoutput>	
