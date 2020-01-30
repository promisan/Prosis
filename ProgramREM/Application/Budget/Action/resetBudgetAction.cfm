
<cfparam name="Object.ObjectKeyValue4"        default="">

<cfquery name="get" 
   datasource="AppsProgram" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
    SELECT * 
	FROM  ProgramAllotmentAction
	WHERE ActionId = '#Object.ObjectKeyValue4#'
</cfquery>

<cfif get.ActionClass eq "Transaction">	
	
	<cfquery name="set" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		UPDATE ProgramAllotmentAction
		SET    Status = '9'
		WHERE  ActionId = '#Object.ObjectKeyValue4#'
	</cfquery>
	
	<cfquery name="set" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		UPDATE ProgramAllotmentDetail
		SET    Status = '0', 
		       ActionId = NULL
		WHERE  ActionId = '#Object.ObjectKeyValue4#'
	</cfquery>
	
	<!--- reset contribution associations --->
	
	<cfquery name="resetcontribution" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		DELETE FROM ProgramAllotmentDetailContribution
		WHERE  TransactionId IN (SELECT TransactionId 
		                         FROM   ProgramAllotmentDetail
								 WHERE  ActionId = '#Object.ObjectKeyValue4#')
	</cfquery>
	
<cfelse>

	<cfquery name="deletelines" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		DELETE FROM ProgramAllotmentDetail	
		WHERE  ActionId = '#Object.ObjectKeyValue4#'
	</cfquery>
	
	<cfquery name="disableaction" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		UPDATE ProgramAllotmentAction
		SET Status = '9'
		WHERE ActionId = '#Object.ObjectKeyValue4#'
	</cfquery>	
	
</cfif>



