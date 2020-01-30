
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cf_SystemScript>

<script language="JavaScript">

function editAccount(persno, no) {
	window.location = "AccountEdit.cfm?ID=" + persno + "&ID1=" + no ;
}
</script>

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

<cfparam name="Form.DateExpiration" default="">

<cfset dateValue = "">
<cfif Form.DateExpiration neq ''>
    <CF_DateConvert Value="#Form.DateExpiration#">
    <cfset END = dateValue>
<cfelse>
    <cfset END = 'NULL'>
</cfif>	

<cfif Form.AccountABA eq "" and Form.SwiftCode eq "">
   <cfoutput>
    <cf_tl id="Problem, must provide with an ABA or SwiftCode in order to continue">
  </cfoutput>
  <cfabort>
</cfif>

<!--- verify if record exist --->

<cfquery name="Account" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   PersonAccount
	WHERE  PersonNo    = '#Form.PersonNo#' 
	AND    AccountNo   = '#Form.AccountNo#'
	AND    Destination = '#Form.Destination#'
</cfquery>

<cfif Account.recordCount gte 1> 

<cfoutput>

<cfparam name="URL.ID" default="#Account.PersonNo#">
<cfinclude template="../../../Staffing/Application/Employee/PersonViewHeader.cfm">

<p align="center">

<font face="Calibri" size="2" color="FF0000">An account with this AccountNo was already registered</font></b></p>
<hr>

<input type="button" class="button10g" value="Edit Account" onClick="javascript:editAccount('#Account.PersonNo#','#Account.AccountId#');">

</cfoutput>

<CFELSE>

<!---

<cfif #Form.DistributionMethod# is "Percentage">

    <cfquery name="Check" 
     datasource="AppsPayroll" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
       SELECT sum(AmountPercentage) as Total
       FROM PersonAccount
       WHERE DistributionMethod = '#Form.DistributionMethod#'
	   AND   Destination = '#Form.Destination#'
	   AND   PersonNo = '#Form.PersonNo#'
  	</cfquery>
	
	<cfparam name="prior" default="0"> 
	<cfif #Check.Total# gt "0">
	 <cfset prior = #Check.Total#>
	</cfif>
	
	<cfoutput>
	<cfset new = #prior# + #Form.Amount#>
	</cfoutput>
	
	<cfif new gt "0">
	
	<script>
	
	 alert("Problem, you can't distribute more than 100%")
	 history.back()
	 
	 </script>
	
	</cfif>

</cfif>


--->

	<cf_assignid>

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
		 AccountType,
		 SwiftCode,
		 IBAN,
		 AccountCurrency,
		 Destination,
		 Remarks,
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
		  '#Form.AccountType#',
		  '#Form.SwiftCode#',
		  '#Form.IBAN#',
		  '#Form.AccountCurrency#',
		  '#Form.Destination#',
		  '#Remarks#',
		  '0',
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#')
	  </cfquery>

	  <cfset vPersonNo = Form.PersonNo>
	  <cfset vAccountid = rowguid>
	  
	  <cfinclude template="AccountMissionSubmit.cfm">
	  <cfinclude template="AccountWorkflow.cfm">
	  	    
     <cfoutput>
	
	     <script>	 
		   ptoken.location("EmployeeBankAccount.cfm?ID=#Form.PersonNo#");    
	     </script>	
	 
	 </cfoutput>
	
	
</cfif>	

