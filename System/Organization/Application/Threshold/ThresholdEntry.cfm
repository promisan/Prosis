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

<cfquery name="Bank" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT Max(Code) as Code,Description
    FROM     Ref_Bank
	GROUP BY Description
	ORDER BY Description
</cfquery>

<cfquery name="CurrencyList" 
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

<cfform action="ThresholdEntrySubmit.cfm" method="POST" name="accountentry">

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
	    <td width="100%" style="font-size:22;height:42" align="left" valign="middle" class="labellarge">
	    	 <cf_tl id="Register Threshold">
	    </td>
	  </tr> 	 
	     
	  <tr>
	    <td width="100%" style="padding-left:10px">
	    <table border="0" cellpadding="0" cellspacing="0" width="100%" class="formpadding">
		
		<tr><td height="3" colspan="1"></td></tr>
		  			
		
		<TR>
	    <TD class="labelmedium"><cf_tl id="Threshold type">:</TD>
		<TD class="labelmedium">
	        <INPUT type="radio" class="enterastab" name="ThresholdType" id="ThresholdType" value="Payable" checked> <cf_tl id="Payable">
			<INPUT type="radio" class="enterastab" name="ThresholdType" id="ThresholdType" value="Receivable"> <cf_tl id="Receivable">:
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
	    <TD class="labelmedium"><cf_tl id="Currency">:</TD>	
		<TD>
				 
		 <select name="Currency" id="Currency" class="regularxl enterastab">
		  	<cfloop query="CurrencyList">
			<option value="#Currency#" <cfif currency eq APPLICATION.BaseCurrency>selected</cfif>> #Currency#</option>
			</cfloop>
		 </select>
		 
		</TD>	  
		</TR>
		
		<TR>
	    <TD class="labelmedium"><cf_tl id="Amount">:</TD>
	   	<TD>
			<cf_tl id="Amount" var="vEnterName" class="message">
			
			<cfinput type="Text"
		       name="AmountThreshold"
		       message="#vEnterName#"
			   validate="float"
		       required="Yes"
		       visible="Yes"
		       enabled="Yes"
		       size="14"
			   style="text-align:right"
		       maxlength="20"
		       class="regularxl enterastab">
		</TD>
		
		</TR>
			
		<TR>
	    <TD class="labelmedium"><cf_tl id="Memo">:</TD>
	   	<TD>
			<cf_tl id="Memo" var="vEnterName" class="message">
			
			<cfinput type="Text"
		       name="Memo"
		       message="#vEnterName#"
		       required="No"
		       visible="Yes"
		       enabled="Yes"
		       size="80"
		       maxlength="80"
		       class="regularxl enterastab">
		</TD>
		
		</TR>
		
		<!---	
			
		
					
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
		
		--->
		
	   </TABLE>
	   
	   </td>
	   </tr>
	   
	   <tr class="line"><td style="padding-top:5px" height="1" colspan="2"></td></tr>
	
	     <tr>
	    <td height="35" align="center">
		   <cf_tl id="Back" var="vCancel">
	 	   <input type="button" name="cancel" id="cancel" value="#vCancel#" class="button10g" onClick="history.back()">
		   <cf_tl id="Save" var="vSave">
		   <input class="button10g" type="submit" name="Submit" id="Submit" value=" #vSave# " >
	    </td>
		</tr>
		
	   </table>
	   
	   </td>
		</tr>
	   
	   </table>
   
   </CFFORM>

 </cfoutput>
   



