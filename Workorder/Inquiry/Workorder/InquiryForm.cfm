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
<HTML><HEAD>
    <TITLE>Workorder - Search Form</TITLE>
</HEAD><BODY bgcolor="#FFFFFF">

<link href="../../pkdb.css" rel="stylesheet" type="text/css">
<cfinclude template="../../Control/VerifyLogin.cfm">

<table width="100%">
<TD><font size="4"><b>Workorder inquiry</b></font>
</TD>
<TD><img src="../../warehouse.JPG" alt="" width="30" height="30" border="1" align="right"></TD>
</table>
<hr>

<font face="Tahoma" size="2"><b>Search by any or all of the criteria below:</b></font>

<cfquery 
name="Class" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT distinct WorkCategory 
    FROM WorkOrd
</cfquery>

<cfquery 
name="Location" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT distinct LocationCode, LocationDescription 
    FROM WorkOrd
	WHERE LocationCode is not null
</cfquery>

<cfquery 
name="Contractor" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT distinct Contractor, ContractorName
    FROM WorkOrd
	WHERE Contractor is not NULL
</cfquery>

<cfquery 
name="Status" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT distinct Status
    FROM Workord
	WHERE Status is not NULL
	ORDER BY Status
</cfquery>

<!--- Search form --->
<cfform action="InquiryQuery.cfm" method="POST" enablecab="No" name="MyForm">

<table cellspacing="1" cellpadding="1" align="center" bordercolor="#111111" bgcolor="#FFFFFF" style="border-collapse: collapse" title="Select criteria">

<!--- Field: Class=CHAR;20;TRUE --->
	
	<TR>
	<td width="142" height="25" valign="top" bgcolor="#6688AA">
    <font size="1" face="Tahoma" color="#FFFFFF">&nbsp;Category:</font></td>
		
	<td width="142" valign="top" bgcolor="#6688AA">
    <font size="1" face="Tahoma" color="#FFFFFF">&nbsp;Location:</font></td>
	
    <td width="142" valign="top" bgcolor="#6688AA">
    <font size="1" face="Tahoma" color="#FFFFFF">&nbsp;Contractor:</font></td>	
	
	</tr>
	
	<tr>
	<td align="left" valign="top">
	<select name="WorkCategory" id="WorkCategory" size="8" multiple>
	    <cfoutput query="Class">
		<option value="'#WorkCategory#'">
		<font face="Tahoma" size="1">
		#WorkCategory#
		</font></option>
		</cfoutput>
	    </select>

    <table>
	
    <tr>
		
	<td width="142" valign="top" bgcolor="#6688AA">
    <font size="1" face="Tahoma" color="#FFFFFF">&nbsp;Status:</font></td>
	    	
	</tr>
	
	<tr>
		
	<td align="left" valign="top" width="182"><select name="Status" id="Status" size="5" multiple>
	    <cfoutput query="Status">
		<option value="'#Status#'">
		<font face="Tahoma" size="1">
		#Status#
		</font></option>
		</cfoutput>
	    </select>
	</td>	
		
	</TR>	
	
	</table>		
		
		
		
	</td>	
	
	
	<td align="left" valign="top">
	<select name="LocationCode" id="LocationCode" size="15" multiple>
	    <cfoutput query="Location">
		<option value="'#LocationCode#'">
		<font face="Tahoma" size="1">
		#LocationDescription#
		</font></option>
		</cfoutput>
	    </select>
	</td>	
	
    <td align="left" valign="top">
	<select name="Contractor" id="Contractor" size="15" multiple>
	    <cfoutput query="Contractor">
		<option value="'#Contractor#'">
		<font face="Tahoma" size="1">
		#ContractorName#
		</font></option>
		</cfoutput>
	    </select>
	</td>		
	
	</tr>	
	
	
	
	
    <TR>
	
	<td colspan="1" valign="top" bgcolor="#6688AA">
    <font size="1" face="Tahoma" color="#FFFFFF">&nbsp;Workbriefs:</font></td>
	
	<INPUT type="hidden" name="Crit1_FieldName" id="Crit1_FieldName" value="P.Workbriefs">
	<INPUT type="hidden" name="Crit1_FieldType" id="Crit1_FieldType" value="CHAR">
	    
	<td colspan="3"><font color="#000000"><SELECT name="Crit1_Operator" id="Crit1_Operator">
			<OPTION value="CONTAINS">contains
			<OPTION value="BEGINS_WITH">begins with
			<OPTION value="ENDS_WITH">ends with
			<OPTION value="EQUAL">is
			<OPTION value="NOT_EQUAL">is not
			<OPTION value="SMALLER_THAN">before
			<OPTION value="GREATER_THAN">after
		</SELECT></font><font color="#6688AA"> </font><font color="#000000">
		
	<INPUT type="text" name="Crit1_Value" id="Crit1_Value" size="40"></td>
    </font></font>
	
	</TD>
	</tr>
	
	<tr>
	
	<td colspan="1" valign="top" bgcolor="#6688AA">
    <font size="1" face="Tahoma" color="#FFFFFF">&nbsp;Order date:</font></td>
	
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
	<INPUT type="hidden" name="Crit2_FieldName" id="Crit2_FieldName" value="C.Amount">
	<INPUT type="hidden" name="Crit2_Value_float" id="Crit2_Value_float">
	
	<INPUT type="hidden" name="Crit2_FieldType" id="Crit2_FieldType" value="FLOAT">
		
	<td colspan="3"><SELECT name="Crit2_Operator" id="Crit2_Operator">
		
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