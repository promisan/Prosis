<!--
    Copyright © 2025 Promisan B.V.

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
<cfquery name="Bank" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT Max(Code) as Code,Description
    FROM     Ref_Bank
	GROUP BY Description
	ORDER BY Description
</cfquery>

<cfquery name="Currency" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Currency
</cfquery>

<cf_tl id="Bank Account" var="1">

<cf_screenTop height="100%" layout="innerbox" jquery="Yes" html="No" border="0" title="#lt_text#" scroll="yes" flush="Yes">

<cf_calendarscript>

<cfoutput>

<cfform action="AccountEntrySubmit.cfm" method="POST" name="accountentry">

<cfinclude template="../UnitView/UnitViewHeader.cfm">

<cfif Bank.recordcount eq "0">

	<table align="center"><tr><td align="center" height="40"><cf_tl id="Sorry no banks have been recorded">.</td></tr></table>
	<cfabort>

</cfif>

	<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	  <tr><td>
	
	<input type="hidden" name="OrgUnit" id="OrgUnit" value="#URL.ID#" class="regular">
	
	<table width="97%" align="center" border="0" cellspacing="0" cellpadding="0" align="center">
	  <tr class="line">
	    <td width="100%" style="font-size:25;height:42" align="left" valign="middle" class="labellarge">
	    	 <cf_tl id="Register Bank Account">
	    </td>
	  </tr> 	 
	     
	  <tr>
	    <td width="100%" style="padding-left:10px">
	    <table border="0" cellpadding="0" cellspacing="0" width="100%" class="formpadding">
		
		<tr><td height="3" colspan="1"></td></tr>
		
	    <TR>
	    <TD style="width:220px" class="labelmedium"><cf_tl id="Bank name">:</TD>
	   	
	    <TD>
		  	<select name="BankCode" id="BankCode" size="1" class="regularxl enterastab">
				<cfloop query="Bank">
					<option value="#Code#">
			    		#Description#
					</option>
				</cfloop>
		    </select>
		</TD>
		
		</TR>
			
		<TR>
	    <TD class="labelmedium"><cf_tl id="Address">:</TD>
	   	<TD>
		<input type="text" name="BankAddress" id="BankAddress" style="width:95%" size="80" maxlength="80" class="regularxl enterastab">
		 </TD>
		
		</TR>
		
		<TR>
	    <TD class="labelmedium"><cf_tl id="Account type">:</TD>
		<TD class="labelmedium">
	        <INPUT type="radio" class="enterastab" name="AccountType" id="AccountType" value="Checking" checked> <cf_tl id="Checking">
			<INPUT type="radio" class="enterastab" name="AccountType" id="AccountType" value="Savings"> <cf_tl id="Savings">:
		</TD>
		</TR>
			
		<TR>
	    <TD class="labelmedium"><cf_tl id="Account Name">: <font color="FF0000">*)</font></TD>
	   	<TD>
		<cf_tl id="Please enter an account name" var="vEnterName" class="message">
		
		<cfinput type="Text"
	       name="AccountName"
	       message="#vEnterName#"
	       required="Yes"
	       visible="Yes"
	       enabled="Yes"
	       size="50"
	       maxlength="80"
	       class="regularxl enterastab">
		</TD>
		
		</TR>
			
		<TR>
	    <TD class="labelmedium"><cf_tl id="Account No">:  <font color="FF0000">*)</font></TD>
	    <TD>
		
			<cf_tl id="You must enter a bank account no" var="vAccount" class="message">
		
		   <cfinput type="Text"
	       name="accountno"
	       message="#vAccount#"
	       validate="noblanks"
	       required="Yes"
	       visible="Yes"
	       enabled="Yes"
	       size="20"
	       maxlength="35"
	       class="regularxl enterastab">
		   
	    </TD>
		
		</TR>
			
		<TR>
	    <TD class="labelmedium"><cf_tl id="ABA">:</TD>
	    <TD><input type="text" class="regularxl enterastab" name="AccountABA" id="AccountABA" size="10" maxlength="20"></TD>
		
		</TR>
			
		<TR>
	    <TD class="labelmedium"><cf_tl id="Swift code">:</TD>
	    <TD><input type="text" class="regularxl enterastab" name="SwiftCode" id="SwiftCode" size="10" maxlength="10"></TD>	
		</TR>
			
		<TR>
	    <TD class="labelmedium"><cf_tl id="Account currency">:</TD>	
		<TD>
				 
		 <select name="AccountCurrency" id="AccountCurrency" class="regularxl enterastab">
		  	<cfloop query="Currency">
			<option value="#Currency#" <cfif currency eq APPLICATION.BaseCurrency>selected</cfif>> #Currency#</option>
			</cfloop>
		 </select>
		 
		</TD>	  
		</TR>
		
		<TR>
	    <TD class="labelmedium" width="140"><cf_tl id="Effective date">:</TD>
	    <TD>	
			  <cf_intelliCalendarDate9
			FieldName="DateEffective" 
			Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
			AllowBlank="False" class="regularxl enterastab">			
		</TD>
		</TR>
			
	    <TR>
	    <TD class="labelmedium"><cf_tl id="Expiration date">:</TD>
	    <TD>	
			  <cf_intelliCalendarDate9
			FieldName="DateExpiration" 
			Default=""
			AllowBlank="True" class="regularxl enterastab">			
		</TD>
		</TR>
				   
		<TR>
	        <td class="labelmedium"><cf_tl id="Remarks">:</td>
	        <TD><textarea cols="50" style="width:95%" class="regular" style="padding:3px;font-size:13px" rows="3" name="Remarks"></textarea> </TD>
		</TR>
			   </TABLE>
	   
	   </td>
	   </tr>
	   
	   <tr><td style="padding-top:5px" height="1" colspan="2" class="line"></td></tr>
	
	     <tr>
	    <td height="35" align="center">
		   <cf_tl id="Cancel" var="vCancel">
	 	   <input type="button" name="cancel" id="cancel" value="#vCancel#" class="button10g" onClick="history.back()">
		   <cf_tl id="Save" var="vSave">
		   <input class="button10g" type="submit" name="Submit" id="Submit" value=" #vSave# " >
	    </td>
		</tr>
		
	   </table>
	   
	   </table>
   
   </CFFORM>

 </cfoutput>
   



