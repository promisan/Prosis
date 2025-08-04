<!--
    Copyright © 2025 Promisan

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

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cf_SystemScript>

<script language="JavaScript">

function editAccount(persno, no) {
	ptoken.location = "AccountEdit.cfm?ID=" + persno + "&ID1=" + no ;
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

   <table style="width:100%"><tr class="labelmedium2"><td align="center" style="padding-top:30px" onclick="history.back()">
   <cfoutput>
    <cf_tl id="Problem, must provide with an ABA or SwiftCode in order to continue">
  </cfoutput>
  </td></tr></table>
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
	
	<font face="Calibri" size="3" color="FF0000">An account with this AccountNo was already registered</font></b></p>
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
		   ptoken.location("AccountEdit.cfm?ID=#Form.PersonNo#&Id1=#vAccountId#"); 
	//	   ptoken.location("EmployeeBankAccount.cfm?ID=#Form.PersonNo#");    
	     </script>	
	 
	 </cfoutput>	
	
</cfif>	

