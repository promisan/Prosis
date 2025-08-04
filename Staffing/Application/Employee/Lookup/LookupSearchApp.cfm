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
    <TITLE>Staff lookup candidate</TITLE>
   <link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 
     
   
</HEAD><body onLoad="window.focus()">

<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>

<cfif #URL.sLast# eq "undefined">
  <cfset #URL.SLast# = "">
  <cfset #URL.SFirst# = "">
</cfif>

<cfquery name="Nation" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT CODE, NAME 
    FROM Ref_Nation
	WHERE NAME > 'A'
	ORDER BY NAME
</cfquery>

<!--- Search form --->
</font></b>
<p>

<b><font face="BondGothicLightFH">

</p>
<form action="LookupSearchAppResult.cfm" method="post">

<cfoutput>
   <INPUT type="hidden" name="FormName"  value="#URL.FormName#">
   <INPUT type="hidden" name="FieldName" value="#URL.FieldName#">

<table width="70%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="silver" class="formpadding">
  <tr>
  <td height="20" bgcolor="f4f4f4"><b>
  <img src="#SESSION.root#/Images/employee.gif" align="absmiddle" alt="" border="0">
  </td>
  <td valign="bottom" align="right" bgcolor="f4f4f4">
  <font size="2"><cf_tl id="Locate employee">&nbsp;</b></td>
  </tr>
</table> 
</cfoutput> 
  
  <cf_tableTop size = "70%" omit="true">
  
  <table border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
  
  <tr><td colspan="2">
  
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" style="border-collapse: collapse">
     	    
	<!--- Field: Staff.LastName=CHAR;40;FALSE --->
	<INPUT type="hidden" name="Crit2_FieldName" value="LastName">
	<INPUT type="hidden" name="Crit2_FieldType" value="CHAR">
	<TR>
	<td width="100" align="left" >&nbsp;<cf_tl id="Last name">:<input type="hidden" name="Crit2_Operator" value="CONTAINS"></td>
	<TD>
		
	<INPUT type="text" name="Crit2_Value" size="20" class="regular" value="<cfoutput>#URL.SLast#</cfoutput>">
   	
	</TD>
	</TR>	
	
	<!--- Field: Staff.FirstName=CHAR;40;FALSE --->
	<INPUT type="hidden" name="Crit3_FieldName" value="FirstName">
	
	<INPUT type="hidden" name="Crit3_FieldType" value="CHAR">
	<TR>
	<TD align="left" class="regular">&nbsp;<cf_tl id="First name">:
	<input type="hidden" name="Crit3_Operator" value="CONTAINS">
	</TD>
	<TD>
		
	<INPUT type="text" class="regular" name="Crit3_Value" size="20" value="<cfoutput>#URL.SFirst#</cfoutput>">
	
	</TD>
	</TR>
		
	
    <!--- Field: Staff.Gender=CHAR;40;FALSE --->
	<INPUT type="hidden" name="Crit4_FieldName" value="Gender">
	
	<INPUT type="hidden" name="Crit4_FieldType" value="CHAR">
	<INPUT type="hidden" name="Crit4_Operator" value="CONTAINS">
		<TR>
		
	<TD align="left" class="regular">&nbsp;<cf_tl id="Gender">: </TD>
	
	<TD class="regular">
		
	<input type="radio" name="Crit4_Value" value="M"><cf_tl id="Male">
    <input type="radio" name="Crit4_Value" value="F"><cf_tl id="Female">
	<input type="radio" name="Crit4_Value" value="" checked><cf_tl id="Either">
   	
	</TD>
	</TR>
		
	<INPUT type="hidden" name="Crit1_FieldName" value="IndexNo">	
	<INPUT type="hidden" name="Crit1_FieldType" value="CHAR">
	<TR>
	<TD align="left">&nbsp;<cf_tl id="Index No">:<input type="hidden" name="Crit1_Operator" value="CONTAINS"></TD>
	<TD>		
	<INPUT type="text" name="Crit1_Value" size="20" class="regular">
    	
	</TD>
	</TR>	
	
    <!--- Field: Staff.Nationality=CHAR;40;FALSE --->
	<TR>
	<TD align="left" class="regular">&nbsp;<cf_tl id="Nationality">:</TD>
	
	<TD>
    	<select name="Nationality" size="1">
		<option value="" selected>[<cf_tl id="All">]</option>
	    <cfoutput query="Nation">
		<option value="'#Code#'">
		#Name#
		</option>
		</cfoutput>
	    </select>
		</TD>
	</TR>
	</TABLE>
	
	<tr valign="top"><td height="12"></td></tr>
	
	</Td></Tr>
	 
	<tr><td colspan="2" class="top3n"></td></tr>
	<tr><td colspan="2" align="center">
	<cf_tl id="Search" var="1">
	<input type="submit" value="#lt_text#" class="button10g">
	</td></tr>

</TABLE>

<cf_tableBottom size = "70%">

</FORM>

</BODY></HTML>