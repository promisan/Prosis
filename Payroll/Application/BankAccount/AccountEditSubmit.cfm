
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfparam name="Form.AccountId" default="">

<cfif Form.AccountId eq "">
  <table align="center">
	  <tr class="labelmedium2">
	  <td style="padding-top:20px;font-size:20px">
	  <cfoutput>
	    <cf_tl id="Problem, the request can not be executed">
	  </cfoutput>
	  </td>
	  </tr>
  </table>
  <cfabort>
</cfif>

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
<cfset STR = dateValue>

<cfset dateValue = "">
<cfif Form.DateExpiration neq ''>
    <CF_DateConvert Value="#Form.DateExpiration#">
    <cfset END = dateValue>
<cfelse>
    <cfset END = 'NULL'>
</cfif>	

<cfif Form.AccountABA eq "" and Form.SwiftCode eq "">
   <table align="center">
	  <tr class="labelmedium2">
	  <td style="padding-top:20px;font-size:20px">	
	  <cfoutput>
	    <cf_tl id="Problem, you must provide an ABA or SwiftCode in order to continue">
	  </cfoutput>
	   </td>
	  </tr>
  </table>
  <cfabort>
</cfif>

<!--- verify if record exist --->

<cfquery name="Account" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   PersonAccount
	WHERE  PersonNo   = '#Form.PersonNo#' 
	AND    AccountId  = '#Form.AccountId#'
</cfquery>

<cfif Account.recordCount eq 1> 

	<cfif (account.accountNo neq Form.AccountNo 
	     or account.accountABA neq Form.AccountABA 
		 or Account.Swiftcode neq Form.SwiftCode
		 or Account.IBAN neq Form.IBAN
		 or Account.AccountName neq Form.AccountName
		 or Account.AccountCurrency neq Form.AccountCurrency) and account.actionstatus eq "1">
		 
		 <cf_assignid>
		 
		 <cfquery name="Bank" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   Ref_Bank
				WHERE  Code   = '#Form.BankCode#' 				
		</cfquery>

	      <cfquery name="InsertAccount" 
	     datasource="AppsPayroll" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     INSERT INTO PersonAccount 
	         (PersonNo,
			 AccountId,
			 DateEffective,
			 DateExpiration,
			 BankCode,
			 BankAddress,
			 BankTelephoneNo,
			 AccountName,
			 AccountNo,
			 AccountABA,
			 BankName,
			 AccountType,
			 SwiftCode,
			 IBAN,
			 AccountCurrency,
			 Destination,
			 Remarks,
			 Source,
			 SourceId,
			 ActionStatus,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName)
	      VALUES ('#Form.PersonNo#',
		      '#rowguid#',
	          #STR#,
			  #END#,
			  '#Form.BankCode#',
			  '#Form.BankAddress#',
			  '#Form.BankTelephoneNo#',
			  '#Form.AccountName#',
			  '#Form.AccountNo#',
			  '#Form.AccountABA#',
			  '#Bank.Description#',
			  '#Form.AccountType#',
			  '#Form.SwiftCode#',
			  '#Form.IBAN#',
			  '#Form.AccountCurrency#',
			  '#Form.Destination#',
			  '#Remarks#',
			  'MANUAL',
			  '#Form.AccountId#',
			  '0',
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#')
		  </cfquery>
		  
		  <cfset vPersonNo = Form.PersonNo>
		  <cfset vAccountid = rowguid>
	  
	      <cfinclude template="AccountMissionSubmit.cfm"> 	
		  <cfinclude template="AccountWorkflow.cfm">	 
		 
	<cfelse>	 
	
		<!--- old way we just save the renewed values --->
	
		 <cfquery name="UpdateBank" 
		   datasource="AppsPayroll" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		   UPDATE PersonAccount 
		   SET    DateEffective       = #STR#,
				  DateExpiration      = #END#,
				  AccountName         = '#Form.AccountName#',
				  AccountNo           = '#Form.AccountNo#',
				  AccountABA          = '#Form.AccountABA#',
				  AccountCurrency     = '#Form.AccountCurrency#',
				  SwiftCode           = '#Form.SwiftCode#',
				  IBAN                = '#Form.IBAN#',
		    	  BankCode            = '#Form.BankCode#',			 
				  AccountType         = '#Form.AccountType#',				 				 
				  BankAddress         = '#Form.BankAddress#',
				  BankTelephoneNo	  = '#Form.BankTelephoneNo#',			 			 
				  Destination         = '#Form.Destination#',
				  Remarks             = '#Remarks#'
		   WHERE  PersonNo            = '#Form.PersonNo#' 
		   AND    AccountId           = '#Account.AccountId#' 
		   </cfquery>
		   
		 <cfset vPersonNo    = Form.PersonNo>
		 <cfset vAccountid   = Form.AccountId>
		 <cfinclude template = "AccountMissionSubmit.cfm">
		   
	</cfif>	   
  
</cfif>	

<cf_SystemScript>

<cfoutput>	

<script>
	 ptoken.location("EmployeeBankAccount.cfm?ID=#Form.PersonNo#");
</script>	

</cfoutput>

	

