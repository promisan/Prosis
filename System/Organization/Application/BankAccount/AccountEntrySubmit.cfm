
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<script language="JavaScript">

function editAccount(persno, no) {
window.location = "AccountEdit.cfm?ID=" + persno + "&ID1=" + no ;
}
</script>

<cfif Len(Form.Remarks) gt 100>
  <cfset remarks = left(#Form.Remarks#,100)>
<cfelse>
  <cfset remarks = Form.Remarks>
</cfif> 

<cfif Len(Form.BankAddress) gt 100>
	<cfset address = left(#Form.BankAddress#,100)>
<cfelse>
	<cfset address = Form.BankAddress>
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
SELECT *
FROM   OrganizationBankAccount
WHERE  OrgUnit  = '#Form.OrgUnit#' 
  AND  BankCode   = '#Form.BankCode#'
  AND  AccountNo  = '#Form.AccountNo#'
</cfquery>

<cfif Account.recordCount gte 1> 

<cfoutput>

<cfparam name="URL.ID" default="#Account.OrgUnit#">

<p align="center">

<font face="Verdana" size="2" color="FF0000"><b>An account with this AccountNo was already registered</font></b></p>

<hr>

   <input type="button"
          class="button10p" 
		  value="Edit Account" 
		  onClick="javascript:editAccount('#Account.OrgUnit#','#Account.AccountId#');">

</cfoutput>

<CFELSE>

      <cfquery name="InsertAccount" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     INSERT INTO OrganizationBankAccount 
	         (Orgunit,
			 DateEffective,
			 DateExpiration,
			 BankCode,
			 BankAddress,
			 AccountName,
			 AccountNo,
			 AccountABA,
			 AccountType,
			 SwiftCode,
			 AccountCurrency,			
			 Remarks,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName)
	      VALUES ('#Form.Orgunit#',
	          #STR#,
			  #END#,
			  '#Form.BankCode#',
			  '#Form.BankAddress#',
			  '#Form.AccountName#',
			  '#Form.AccountNo#',
			  '#Form.AccountABA#',
			  '#Form.AccountType#',
			  '#Form.SwiftCode#',
			  '#Form.AccountCurrency#',			  
			  '#Remarks#',
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#')
 	  </cfquery>
	  
     <cfoutput>
	 
	     <script>
	 
	 window.location = "OrganizationBankAccount.cfm?ID=#Form.OrgUnit#";
    
     </script>	
	 
	 </cfoutput>
	
	
</cfif>	

