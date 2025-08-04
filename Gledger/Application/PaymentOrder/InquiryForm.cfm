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
<HTML><HEAD>
    <TITLE>Account Payable</TITLE>
</HEAD><BODY bgcolor="#FFFFFF">

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<table width="100%">
<TD><font size="4"><b>Payment Inquiry</b></font>
</TD>
<TD><img src="../../../warehouse.JPG" alt="" width="30" height="30" border="1" align="right"></TD>
</table>
<hr>

<font face="Tahoma" size="2"><b>Search by any or all of the criteria below:</b></font>

<cfquery 
name="Journal" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT distinct T.Journal, J.Description , J.Currency, J.Bank
    FROM TransactionHeader T, Journal J
	WHERE T.TransactionCategory = 'Payment'
	AND T.Journal = J.Journal
</cfquery>

<cfquery 
name="Vendor" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT distinct ReferenceName 
    FROM Transaction
	WHERE TransactionCategory = 'Payment'
</cfquery>

<cfquery 
name="Period" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT distinct AccountPeriod, Status 
    FROM Period
	ORDER BY AccountPeriod DESC
</cfquery>

<cfquery 
name="Parameter" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
	FROM Ref_ParameterMission
    WHERE Mission = '#URL.Mission#'
</cfquery>

<!--- Search form --->
<cfform action="InquiryQuery.cfm" method="POST" enablecab="No" name="MyForm">

<table border="0" cellspacing="0" cellpadding="0" class="formpadding" align="center" bordercolor="#8EA4BB" rules="cols" style="border-collapse: collapse">

<!--- Field: Class=CHAR;20;TRUE --->
	
	<TR>
	<td width="142" height="25" valign="top" bgcolor="#6688AA">
    <font size="1" face="Tahoma" color="#FFFFFF">&nbsp;Payee:</font></td>
		
	<td width="100" valign="top" bgcolor="#6688AA">
    <font size="1" face="Tahoma" color="#FFFFFF">&nbsp;Journal:</font></td>
	
    <td width="60" valign="top" bgcolor="#6688AA">
    <font size="1" face="Tahoma" color="#FFFFFF">&nbsp;Acc Period:</font></td>	
	
	</tr>
	
	<tr>
		 	
	<td align="left" valign="top">
	<select name="ReferenceName" size="15" multiple>
	    <cfoutput query="Vendor">
		<option value="'#ReferenceName#'">
		<font face="Tahoma" size="1">
		#ReferenceName#
		</font></option>
		</cfoutput>
	    </select>
	   	
	<td align="left" valign="top">
	<select name="Journal" size="15" multiple>
	    <cfoutput query="Journal">
		<option value="'#Journal#'">
		<font face="Tahoma" size="1">
		#Journal# #Description# (#Bank#)
		</font></option>
		</cfoutput>
	    </select>
    </td>			
   		
    <td align="left" valign="top">
	<select name="Period" size="15">
	    <cfoutput query="Period">
		<option value="'#AccountPeriod#'" <cfif #Parameter.CurrentAccountPeriod# is '#AccountPeriod#'>selected</cfif>>
		<font face="Tahoma" size="1">
		#AccountPeriod#
		</font></option>
		</cfoutput>
	    </select>
	</td>		
	
	</tr>	
		
	
	<tr>
		
	<td width="142" valign="top" bgcolor="#6688AA">
    <font size="1" face="Tahoma" color="#FFFFFF">&nbsp;Status:</font></td>
	   	
	
	<td align="left" valign="top" width="182">
	<select name="Status" size="2">
	
			<OPTION value="AmountOutstanding <= 0">Paid
			<OPTION value="AmountOutstanding > 0" selected>Outstanding
		
	    </select>
	</td>	
	</TR>	
		
    <TR>
	
	<td colspan="1" valign="top" bgcolor="#6688AA">
    <font size="1" face="Tahoma" color="#FFFFFF">&nbsp;InvoiceNo:</font></td>
	
	<INPUT type="hidden" name="Crit1_FieldName" value="ReferenceNo">
	<INPUT type="hidden" name="Crit1_FieldType" value="CHAR">
	    
	<td colspan="3"><font color="#000000"><SELECT name="Crit1_Operator">
			<OPTION value="CONTAINS">contains
			<OPTION value="BEGINS_WITH">begins with
			<OPTION value="ENDS_WITH">ends with
			<OPTION value="EQUAL">is
			<OPTION value="NOT_EQUAL">is not
			<OPTION value="SMALLER_THAN">before
			<OPTION value="GREATER_THAN">after
		</SELECT></font><font color="#6688AA"> </font><font color="#000000">
		
	<INPUT type="text" name="Crit1_Value" size="40"></td>
    </font></font>
	
	</TD>
	</tr>
	
	<tr>
	
	<td colspan="1" valign="top" bgcolor="#6688AA">
    <font size="1" face="Tahoma" color="#FFFFFF">&nbsp;Transaction date:</font></td>
	
	<td colspan="3"><cf_intelliCalendar
		FieldName="Start" 
		DateFormat="#APPLICATION.DateFormat#"
		Default="01/01/02">
		
      <cf_intelliCalendar
		FieldName="End" 
		DateFormat="#APPLICATION.DateFormat#"
		Default="today">			
	</td>
	
	</tr>
		
	
	</td>
	
	<td width="142" valign="top" bgcolor="#6688AA">
    <font size="1" face="Tahoma" color="#FFFFFF">&nbsp;Amount:</font></td>	
		
	<!--- Field: Amount=FLOAT;8;FALSE --->
	<INPUT type="hidden" name="Crit2_FieldName" value="Amount">
	<INPUT type="hidden" name="Crit2_Value_float">
	
	<INPUT type="hidden" name="Crit2_FieldType" value="FLOAT">
		
	<td colspan="3"><SELECT name="Crit2_Operator">
		
			<OPTION value="EQUAL">is
			<OPTION value="NOT_EQUAL">is not
			<option value="GREATER_THAN" selected>greater than
			<OPTION value="SMALLER_THAN">smaller than
		
		</SELECT>
		
	<cfinput type="Text" name="Crit2_Value" value="-1" message="Please enter an amount" required="Yes" size="20"></td>
	</TR>

</TABLE>
<P>
<hr>
<input type="reset"  value=" Reset  ">
<input type="submit" value=" Search ">

</CFFORM>

</BODY></HTML>