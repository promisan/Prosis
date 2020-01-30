
<cfif Len(Form.Remarks) gt 100>
  <cfset remarks = left(Form.Remarks,100)>
<cfelse>
  <cfset remarks = Form.Remarks>
</cfif> 

<cfif Len(Form.BankAddress) gt 100>
  <cfset address = left(Form.BankAddress,100)>
<cfelse>
  <cfset address = Form.BankAddress>
</cfif>   

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateEffective#">
<cfset STR = #dateValue#>

<cfset dateValue = "">

<cfif Form.DateExpiration neq ''>
    <CF_DateConvert Value="#Form.DateExpiration#">
    <cfset END = dateValue>
<cfelse>
    <cfset END = 'NULL'>
</cfif>	

<cfif Len(Form.Remarks) gt 100>
  <cfset remarks = left(#Form.Remarks#,100)>
<cfelse>
  <cfset remarks = Form.Remarks>
</cfif>  

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateEffective#">
<cfset STR = dateValue>

<cfset dateValue = "">
<cfif Form.DateExpiration neq ''>
    <CF_DateConvert Value="#Form.DateExpiration#">
    <cfset END = #dateValue#>
<cfelse>
    <cfset END = 'NULL'>
</cfif>	

<!--- verify if record exist --->

<cfquery name="Account" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT A.*
	FROM   OrganizationBankAccount A
	WHERE  OrgUnit    = '#Form.Orgunit#' 
	AND    AccountId  = '#Form.AccountId#'
</cfquery>

<cfif Account.recordCount eq 1> 
	
	 <cfquery name="InsertContract" 
	   datasource="AppsOrganization" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   UPDATE OrganizationBankAccount 
	   SET   DateEffective       = #STR#,
			 DateExpiration      = #END#,
	    	 BankCode            = '#Form.BankCode#',
			 AccountNo           = '#Form.AccountNo#',
			 AccountType         = '#Form.AccountType#',
			 AccountName         = '#Form.AccountName#',
			 AccountCurrency     = '#Form.AccountCurrency#', 
			 BankAddress         = '#Form.BankAddress#',
			 AccountABA          = '#Form.AccountABA#',
			 SwiftCode           = '#Form.SwiftCode#',		
			 Remarks             = '#Remarks#'
	   WHERE OrgUnit    = '#Form.Orgunit#' 
	   AND   AccountId  = '#Form.AccountId#' 
	   </cfquery>
  
</cfif>	

<cfset url.id = Form.OrgUnit>	  
<cfinclude template="OrganizationBankAccount.cfm">	  

	

