
<cfif ParameterExists(Form.Insert)> 

	<cfquery name="check" 
	datasource="AppsePas" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * FROM Ref_ContractPeriod		
		WHERE   Code  = '#form.Code#'
	</cfquery>
	
	<cfif check.recordcount gte "1">
	
		<cf_tl id="Code already exists!" var="1">
		<cfoutput>
			<script>   
				alert('#lt_text#'); 
			</script>
		</cfoutput> 
	
	<cfelse>

		<cfset dateValue = "">
		<CF_DateConvert Value="#Form.PASPeriodStart#">
		<cfset STR = dateValue>
		
		<cfset dateValue = "">
		<CF_DateConvert Value="#Form.PASPeriodEnd#">
		<cfset END = dateValue>
	
		<cfset dateValue = "">
		<CF_DateConvert Value="#Form.PASEvaluation#">
		<cfset DTE = dateValue>
		
		<cfquery name="Update" 
		datasource="AppsePas" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO Ref_ContractPeriod
				(Code,
				 Mission, 
				 ContractClass, 
				 PASPeriodStart, 
				 PASPeriodEnd, 
				 PASEvaluation, 			 
				 OfficerUserId, 
				 OfficerLastName, 
				 OfficerFirstName)
	        VALUES ('#Form.Code#','#Form.Mission#','#Form.ContractClass#',#STR#,#END#,#DTE#,'#session.acc#','#session.last#','#session.first#')
			
		</cfquery>	
		
		<cfset url.code = form.code>
	
		<cfinclude template="setContractPeriod.cfm">	
		
	 </cfif>	
	
</cfif>	

<cfif ParameterExists(Form.Update)>

	<cfset dateValue = "">
	<CF_DateConvert Value="#Form.PASEvaluation#">
	<cfset DTE = dateValue>
	
	<cfquery name="Update" 
	datasource="AppsePas" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE  Ref_ContractPeriod
		SET     PASEvaluation  = #dte#
		WHERE   Code           = '#url.Code#'
	</cfquery>
	
</cfif>
	
<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
