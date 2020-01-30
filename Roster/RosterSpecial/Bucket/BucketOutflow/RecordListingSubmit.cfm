
<cfquery name="Rules" 
	 datasource="AppsSelection" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT *
		 FROM Ref_Rule
		 WHERE TriggerGroup = 'Bucket'	
</cfquery>	

<cfloop query="Rules">

	<cfparam name="Form.#Code#_Operational"        default="0">
	<cfparam name="Form.#Code#_Days"               default="1">
	<cfparam name="Form.#Code#_AllowReactivation"  default="0">
	<cfparam name="Form.#Code#_MailNotification"   default="0">
	
	<cfset Operational       = evaluate("Form.#Code#_Operational")>
	<cfset Days              = evaluate("Form.#Code#_Days")>
	<cfset AllowReactivation = evaluate("Form.#Code#_AllowReactivation")>
	<cfset Mail              = evaluate("Form.#Code#_MailNotification")>
	
	<cfquery name="Check" 
	    datasource="AppsSelection" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	     SELECT *
		 FROM FunctionOrganizationOutflow
		 WHERE RuleCode = '#Code#'	
		 AND FunctionId = '#form.idFunction#'			
	</cfquery>
	
	<cfif check.recordcount eq "0">
	
		<cfquery name="Insert" 
			     datasource="AppsSelection" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO  FunctionOrganizationOutflow
			         (FunctionId,RuleCode,
				     Days,
					 AllowReactivation,
					 MailNotification,
					 Operational,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
			      VALUES ('#form.idfunction#',
				      '#code#',
					  '#days#',
					  '#AllowReactivation#',
					  '#Mail#',
			      	  '#Operational#',
					  '#SESSION.acc#',
					  '#SESSION.last#',
					  '#SESSION.first#')
			</cfquery>
			
	<cfelse>
	
		<cfquery name="Check" 
	    datasource="AppsSelection" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	     UPDATE FunctionOrganizationOutflow
		 SET Days = '#days#', 
		     AllowReactivation = '#AllowReactivation#',
			 Operational = '#Operational#', 
			 MailNotification = '#Mail#'
		 WHERE RuleCode = '#Code#'	
		 AND FunctionId = '#form.idFunction#'			
	</cfquery>
	
	</cfif>
	
</cfloop>	