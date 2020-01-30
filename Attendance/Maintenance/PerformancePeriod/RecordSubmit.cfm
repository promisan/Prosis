

<cfset dateValue = "">
<CF_DateConvert Value="#DateFormat(Form.PASEvaluation,CLIENT.DateFormatShow)#">
<cfset DTE = dateValue>

<cfif ParameterExists(Form.Update)>
	
	<cfquery name="Update" 
	datasource="AppsePas" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE  Ref_ContractPeriod
		SET     PASEvaluation  = #dte#
		WHERE   Code           = '#url.Code#'
	</cfquery>
	
</cfif>

<cfif ParameterExists(Form.Insert)> 
	<cfinclude template="setContractPeriod.cfm">	
</cfif>	
	
<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
