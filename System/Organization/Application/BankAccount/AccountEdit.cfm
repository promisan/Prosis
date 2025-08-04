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

<cf_screentop height="100%" jquery="Yes" scroll="Yes" html="No">

<cf_calendarscript>

<cfquery name="Bank" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   DISTINCT Max(Code) as Code, Description
    FROM     Ref_Bank
	GROUP BY Description
	ORDER BY Description
</cfquery>

<cfif Bank.recordcount eq "0">

	<table align="center"><tr><td align="center" height="40"><cf_tl id="Sorry no banks have been recorded">.</td></tr></table>
	<cfabort>

</cfif>

<cfquery name="Currency" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Currency
</cfquery>

<cfquery name="Account" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM OrganizationBankAccount
	WHERE OrgUnit = '#URL.ID#'
	AND AccountId = '#URL.ID1#'
</cfquery>

<cfinclude template="../UnitView/UnitViewHeader.cfm">
 
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
  <tr><td>

<cfform action="AccountEditSubmit.cfm" method="POST" name="accountedit">

<cfoutput query = "Account">

<input type="hidden" name="OrgUnit" id="OrgUnit" value="#OrgUnit#">
<input type="hidden" name="AccountId" id="AccountId" value="#AccountId#">

<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="100%" style="font-size:22px;height:45px;padding-left:6px" align="left" class="labellarge">
	   	 <cf_tl id="Update Bankaccount"></font>
	 </td>
  </tr> 	
  
  <tr><td class="linedotted"  colspan="1"></td></tr>
  
 <tr>
    <td width="100%" style="padding:8px">
	    <table border="0" cellpadding="0" cellspacing="0" width="100%" class="formpadding">
		 		
		</cfoutput>
		
	    <TR>
	    <TD class="labelmedium"><cf_tl id="Bank name">:</TD>   
		
	    <TD>
		  	<select name="BankCode" id="BankCode" size="1" class="regularxl enterastab">
			<cfoutput query="Bank">
			<option value="#Code#" <cfif #Account.BankCode# eq #Code#>checked</cfif>>
	    		#Description#
			</option>
			</cfoutput>
		    </select>
		</TD>
		
		</TR>
		
		<cfoutput query="Account">
			
		<TR>
	    <TD class="labelmedium"><cf_tl id="Address">:</TD>
	   	<TD>
		<input type="text" style="width:95%" name="BankAddress" id="BankAddress" value="<cfoutput>#BankAddress#</cfoutput>" size="80" maxlength="80" class="regularxl enterastab">
		</TD>
		
		</TR>
			
		<TR>
	    <TD class="labelmedium"><cf_tl id="Account type">:</TD>
		<TD class="labelmedium">
		   <INPUT type="radio" class="enterastab" name="AccountType" id="AccountType" value="Checking" <cfif Account.AccountType eq "Checking">checked</cfif>> <cf_tl id="Checking">
			<INPUT type="radio" class="enterastab" name="AccountType" id="AccountType" value="Savings" <cfif Account.AccountType neq "Checking">checked</cfif>> <cf_tl id="Savings">
		</TD>
		</TR>	
		
		<TR>
	    <TD class="labelmedium"><cf_tl id="Account Name">:</TD>
	   	<TD>
		<input type="text" name="AccountName" id="AccountName" value="<cfoutput>#AccountName#</cfoutput>" size="50" maxlength="80" class="regularxl enterastab">
		</TD>
		
		</TR>
		
		<TR>
	    <TD  class="labelmedium"><cf_tl id="Account No">:</TD>
	    <TD><input type="text" class="regularxl enterastab" value="#AccountNo#" name="accountno" id="accountno" size="35" maxlength="35"></TD>
		
		</TR>
		
	    <TR>
	    <TD  class="labelmedium"><cf_tl id="Effective date">:</TD>
	    <TD>
		
			  <cf_intelliCalendarDate9
			FormName="accountedit"
			FieldName="DateEffective" 
			DateFormat="#APPLICATION.DateFormat#"
			Default="#Dateformat(DateEffective, CLIENT.DateFormatShow)#"
			class="regularxl enterastab"
			AllowBlank="False">	
			
		</TD>
		</TR>
			
		<TR>
	    <TD  class="labelmedium"><cf_tl id="Expiration date">:</TD>
	    <TD>
		
			  <cf_intelliCalendarDate9
			FormName="accountedit"
			FieldName="DateExpiration" 
			DateFormat="#APPLICATION.DateFormat#"
			class="regularxl enterastab"
			Default="#Dateformat(DateExpiration, CLIENT.DateFormatShow)#"
			AllowBlank="True">	
			
		</TD>
		</TR>
			
		<TR>
	    <TD class="labelmedium"><cf_tl id="ABA">:</TD>
	    <TD><input type="text" class="regularxl enterastab" value="#AccountABA#" name="AccountABA" id="AccountABA" size="20" maxlength="20"></TD>
		
		</TR>
			
		<TR>
	    <TD  class="labelmedium"><cf_tl id="Swift code">:</TD>
	    <TD><input type="text" class="regularxl enterastab" value="#SwiftCode#" name="SwiftCode" id="SwiftCode" size="10" maxlength="10"></TD>
		
		</TR>
			
		</cfoutput>
		 
		<TR>
	    <TD class="labelmedium"><cf_tl id="Account currency">:</TD>
		
		 <TD>
		 <select name="AccountCurrency" id="AccountCurrency" class="regularxl enterastab">
		  	<cfoutput query="Currency">
				<option value="#Currency#" <cfif Account.AccountCurrency eq "#Currency#">selected</cfif>> #Currency#</option>
			</cfoutput>
		 </select>
		</TD>
		
		<cfoutput query="Account">
		  
		</TR>
			
		<tr><td height="2" colspan="1"></td></tr>
			   
		<TR>
	        <td class="labelmedium" valign="top" style="padding-top:3px"><cf_tl id="Remarks">:</td>
	        <TD><textarea cols="50" rows="3" class="regular" style="width:95%;padding:3px;font-size:13px" name="Remarks">#Remarks#</textarea> </TD>
		</TR>
		
		</cfoutput>
				
	   <tr><td height="1" colspan="2" class="linedotted"></td></tr>
	
	   <tr> 
	   	  <td height="23" align="center" colspan="2">
		  	<cfoutput>
				<cf_tl id="Reset" var="vReset">
				<cf_tl id="Cancel" var="vCancel">
				<cf_tl id="Save" var="vSave">
				
			   	<input class="button10g" type="reset"  name="Reset" id="reset" value=" #vReset# ">
	    		<input type="button" 	 name="cancel" id="cancel" value="#vCancel#" class="button10g" onClick="history.back()">
			    <input class="button10g" type="submit" name="Submit" id="Submit" value="#vSave#" >
			</cfoutput>
	     </td>
	   </tr>
	 	
	</table>
	
	 </td>
	   </tr>
	 	
	</table>
		  
  </CFFORM>
  
   </td>
	   </tr>
	 	
	</table>
