


<cf_screentop jquery="Yes" height="100%" scroll="yes" html="No" menuaccess="context">

<cfparam name="url.refer" default="">

<cf_calendarScript>

<cfquery name="Bank" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
    FROM     Ref_Bank	
	ORDER BY Code,Description
</cfquery>

<cfquery name="Currency" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Currency
</cfquery>

<cfif url.id1 eq ""><cfabort></cfif>

<cfquery name="Account" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   PersonAccount
	WHERE  PersonNo = '#URL.ID#'
	AND    AccountId = '#URL.ID1#' 
</cfquery>

<table cellpadding="0" cellspacing="0" width="99%" align="center">

	<tr><td height="10" style="padding-left:7px">	
		  <cfset ctr      = "0">		
	      <cfset openmode = "open"> 
		  <cfinclude template="../../../Staffing/Application/Employee/PersonViewHeaderToggle.cfm">		  
		 </td>
	</tr>	
	
<tr><td>

	<cfform action="AccountEditSubmit.cfm" method="POST" name="accountedit">
	  
	<cfoutput query = "Account">
	
	<input type="hidden" name="PersonNo"  value="#PersonNo#">
	<input type="hidden" name="AccountId" value="#AccountId#">
	
	<table width="95%" cellspacing="0" cellpadding="0" align="center">
	
	  <tr>
	    <td width="100%" class="labelmedium" style="font-weight:200;padding-left:12px;height:46px;font-size:25px">
		
		<table class="formpadding">
		 <tr>
		 <td>
		    <cf_space spaces="20">   
			<img src="#SESSION.root#/Images/BankAccounts.png" height="68" alt=""  border="0" align="absmiddle">			
		 </td>
		 <td height="24" style="padding-left:15px;font-size:27px;padding-top:28px;font-weight:200" class="labelmedium"><cf_tl id="Maintain bankaccount"></td>	
	     </tr> 		
		 </table>
		
		 </td>
	  </tr> 	
	  	  
	 <tr>
	    <td style="padding-left:10px" width="100%">
		
		    <table border="0" cellpadding="0" cellspacing="0" width="99%" align="center" class="formpadding">
			
			<tr><td height="2" colspan="1"></td></tr>
		  
		    <TR style="height:40px" class="line labelmedium">
		    <TD><cf_tl id="Effective">:</TD>
		    <TD>
			
			   <table><tr class="labelmedium"><td>
			
				  <cf_intelliCalendarDate9
					FormName="accountedit"
					FieldName="DateEffective" 
					class="regularxl enterastab"
					DateFormat="#APPLICATION.DateFormat#"
					Default="#Dateformat(DateEffective, CLIENT.DateFormatShow)#"
					AllowBlank="False">	
							
				</td>
				<TD style="padding-left:15px"><cf_tl id="Expiration">:</TD>
		        <TD>
			
				  <cf_intelliCalendarDate9
					FormName="accountedit"
					FieldName="DateExpiration" 
					class="regularxl enterastab"
					DateFormat="#APPLICATION.DateFormat#"
					Default="#Dateformat(DateExpiration, CLIENT.DateFormatShow)#"
					AllowBlank="True">	
					
			    </TD>
				
				</tr></table>
				
			</TD>
			</TR>
				
				
			<TR style="height:30px" class="labelmedium">
		    <TD><cf_tl id="Destination">:</TD>
		    <TD>
			
				<INPUT type="radio" name="Destination" class="enterastab" value="Personal" <cfif Account.Destination eq "Personal">checked</cfif>> Personal
				<INPUT type="radio" name="Destination" class="enterastab" value="Beneficiary" <cfif Account.Destination eq "Beneficiary">checked</cfif>> Beneficiary
				
			</TD>
			</TR>
				
						
		    <TR class="labelmedium">
		    <TD><cf_tl id="Bank name">:</TD>
		   	
		    <TD>
			  	<select name="BankCode" size="1" class="regularxl enterastab">
					<cfloop query="Bank">
					<cfif Operational eq "0" and Account.BankCode neq Code>
						<!--- not showing --->
					<cfelse>
						<option value="#Code#" <cfif Account.BankCode eq Code>selected</cfif>>#Description#</option>
					</cfif>	
					</cfloop>
			    </select>
			</TD>
			
			</TR>
										
			<TR class="labelmedium">
		    <TD style="padding-left:10px;"><cf_tl id="Bank Address">:</TD>
		   	<TD>
			<input type="text" style="width:95%" name="BankAddress" value="<cfoutput>#BankAddress#</cfoutput>" size="60" maxlength="80" class="regularxl enterastab">
			</TD>
			
			</TR>
				
			<TR class="labelmedium">
		    <TD style="padding-left:10px;"><cf_tl id="Bank Telephone">:</TD>
		   	<TD>
			<input type="text" name="BankTelephoneNo" id="BankTelephoneNo" value="<cfoutput>#BankTelephoneNo#</cfoutput>" size="15" maxlength="20" class="regularxl enterastab">
			</TD>
			
			</TR>
				
			<TR class="labelmedium">
		    <TD style="height:26"><cf_tl id="Account type">:</TD>
			<TD>
		        <INPUT type="radio" class="enterastab" name="AccountType" value="Checking" <cfif AccountType eq "Checking">checked</cfif>> Checking
				<INPUT type="radio" class="enterastab" name="AccountType" value="Savings" <cfif AccountType eq "Savings">checked</cfif>> Savings
				<INPUT type="radio" class="enterastab" name="AccountType" value="Credit" <cfif AccountType eq "Credit">checked</cfif>> <cf_tl id="Credit Card">		
			</TD>
			</TR>
				
			<TR class="labelmedium">
		    <TD><font color="0000FF"><cf_tl id="Account Name">:</TD>
		   	<TD>
			<input type="text" name="AccountName" value="#AccountName#" size="50" maxlength="80" class="regularxl enterastab">
			</TD>
			
			</TR>
				
			<TR class="labelmedium">
		    <TD><font color="0000FF"><cf_tl id="Account No">:</TD>
		    <TD><input type="text" class="regularxl enterastab" value="#AccountNo#" name="accountno" size="35" maxlength="35"></TD>
			
			</TR>
				
			<TR class="labelmedium">
		    <TD style="padding-left:10px;"><font color="0000FF"><cf_tl id="ABA">:</TD>
		    <TD><input type="text" class="regularxl enterastab" value="#AccountABA#" name="AccountABA" size="20" maxlength="20"></TD>
			
			</TR>
				
			<TR class="labelmedium">
		    <TD style="padding-left:10px;"><font color="0000FF"><cf_tl id="Swift code">:</TD>
		    <TD><input type="text" class="regularxl enterastab" value="#SwiftCode#" name="SwiftCode" size="15" maxlength="12"></TD>
			
			</TR>
			
			<TR class="labelmedium">
		    <TD style="padding-left:10px;"><font color="0000FF"><cf_tl id="IBAN">:</TD>
		    <TD><input type="text" class="regularxl enterastab" value="#IBAN#" name="IBAN" id="IBAN" size="25" maxlength="35"></TD>
			
			</TR>
						 
			<TR class="labelmedium">
		    <TD><font color="0000FF"><cf_tl id="Account currency">:</TD>
			
			 <TD>
			 <select name="AccountCurrency" class="regularxl enterastab">
			  	<cfloop query="Currency">
				<option value="#Currency#" <cfif Account.AccountCurrency eq "#Currency#">selected</cfif>> #Currency#</option>
				</cfloop>
				</select>
			</TD>
			</tr>
				  
			<TR class="labelmedium">
			    <td valign="top" style="padding-top:6px;"><font color="008000"><cf_tl id="Pay through">:</td>
			    <TD valign="top" style="padding-top:0px;">
			    	<cfdiv id="divAccountMission" bind="url:AccountMission.cfm?PersonNo=#Account.PersonNo#&AccountId=#Account.AccountId#">
			    </TD>
			</TR>
						  			   
			<TR class="labelmedium">
		        <td valign="top" style="padding-top:3px"><cf_tl id="Remarks">:</td>
		        <TD><textarea cols="50"  rows="3" style="width:95%;font-size:13px;padding:3px" class="regular" name="Remarks">#Remarks#</textarea> </TD>
			</TR>
			
			</cfoutput>
					   
		   <tr class="line"><td height="1" colspan="2"></td></tr>
		  		
		   <tr class="line"> 
		   	  <td height="40" align="center" colspan="2">
			  	<cfoutput>
				<cf_tl id="Reset"  var="vReset">
				<cf_tl id="Back" var="vCancel">
				<cf_tl id="Save"   var="vSave">
				
				<cfif url.refer eq "">		
					<input type="button" name="cancel" value="#vCancel#" class="button10g" onClick="ptoken.location('EmployeeBankAccount.cfm?ID=#Account.PersonNo#')">
				<cfelse>
					<input type="button" name="close" value="Close" class="button10g" onClick="window.close()">	
				</cfif>	
		
		   		<input class="button10g" type="reset"  name="Reset" value=" #vReset# ">
		    	<input class="button10g" type="submit" name="Submit" value="#vSave#" >
		
				</cfoutput>
				
		     </td>
		   </tr>
		      
		   <tr class="labelmedium">
		   
		        <td colspan="2">
				
				<cfquery name="Person" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   Person
					WHERE  PersonNo = '#URL.ID#' 
				</cfquery>	
				
				<cfquery name="OnBoard" 
				  datasource="AppsEmployee" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					SELECT TOP 1 *
					FROM      PersonAssignment
					WHERE     PersonNo = '#URL.ID#' 
					-- AND       DateEffective <= '#Dateformat(now(), CLIENT.DateSQL)#'
					-- AND       DateExpiration >= '#Dateformat(now(), CLIENT.DateSQL)#'
					AND       AssignmentStatus IN ('0','1') 
					ORDER BY  DateExpiration DESC
				</cfquery>
				
				<cfif OnBoard.recordcount eq "0">
				
					<cf_tl id="Problem, no active assignment found">
				
				<cfelse>
						
				<cfquery name="currentContract" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				    SELECT TOP 1 L.*, 
				           R.Description as ContractDescription, 
					       A.Description as AppointmentDescription
				    FROM   PersonContract L, 
					       Ref_ContractType R,
						   Ref_AppointmentStatus A
					WHERE  L.PersonNo = '#URL.ID#'
					AND    L.ContractType = R.ContractType
					AND    L.AppointmentStatus = A.Code
					AND    L.ActionStatus != '9'
					ORDER BY L.DateEffective DESC 
			 	</cfquery>	
					
					<cfset link = "Payroll/Application/BankAccount/AccountEdit.cfm?id=#url.id#&id1=#account.accountid#">
				
					<cf_ActionListing 
					    EntityCode       = "PayBank"
						EntityClass      = "Standard"
						EntityGroup      = ""
						EntityStatus     = ""
						Mission			 = "#currentContract.Mission#"		
						OrgUnit          = "#OnBoard.OrgUnit#" 
						PersonNo         = "#Person.PersonNo#"
						ObjectReference  = "#account.AccountName# #account.AccountNo#"
						ObjectReference2 = "#Person.FirstName# #Person.LastName#" 
					    ObjectKey1       = "#url.id#"
						ObjectKey4       = "#account.AccountId#"
						ObjectURL        = "#link#"
						Show             = "Yes"
						CompleteFirst    = "Yes">
													
				 </cfif>
				 	
				 </td>
				 </tr>
		
		</table>
		
	</td></tr>
		
	</table>	
	
	</CFFORM>

</td></tr>

</table>