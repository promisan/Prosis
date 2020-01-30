<HTML><HEAD>
    <TITLE>User Administration</TITLE>
	 <link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
</HEAD><body onLoad="window.focus()">

<p align="center">
</p>
<p>&nbsp;</p>
<p>&nbsp;</p>

<!--- Search form --->

<FORM action="DialogSearchCriteria.cfm" method="post">

<cfoutput>
<INPUT type="hidden" name="FormName" id="FormName"       value="#URL.FormName#">
<INPUT type="hidden" name="flduserid" id="flduserid"      value="#URL.flduserid#">
<INPUT type="hidden" name="fldlastname" id="fldlastname"    value="#URL.fldlastname#">
<INPUT type="hidden" name="fldfirstname" id="fldfirstname"   value="#URL.fldfirstname#">
<INPUT type="hidden" name="fldname" id="fldname"        value="#URL.fldname#">
</cfoutput>

<table width="70%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#C0C0C0" class="formpadding">
<tr>
  <td height="24" class="labelmedium"><b>Locate user account</b></td>
</tr>

<tr><td colspan="2">
<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

   <!--- Field: UserNames.IndexNo --->
	<INPUT type="hidden" name="Crit0_FieldName" id="Crit0_FieldName" value="IndexNo">
	
	<INPUT type="hidden" name="Crit0_FieldType" id="Crit0_FieldType" value="CHAR">
	<TR>
	<TD class="labelit">IndexNo:</TD>
	<TD><SELECT name="Crit0_Operator" id="Crit0_Operator">
		
			<OPTION value="CONTAINS">contains
			<OPTION value="BEGINS_WITH">begins with
			<OPTION value="ENDS_WITH">ends with
			<OPTION value="EQUAL">is
			<OPTION value="NOT_EQUAL">is not
			<OPTION value="SMALLER_THAN">before
			<OPTION value="GREATER_THAN">after
		
		</SELECT>
		
	<INPUT type="text" name="Crit0_Value" id="Crit0_Value" size="20"> 
	
	</TD>
	</TR>


    <!--- Field: UserNames.Account=CHAR;40;FALSE --->
	<INPUT type="hidden" name="Crit1_FieldName" id="Crit1_FieldName" value="Account">
	
	<INPUT type="hidden" name="Crit1_FieldType" id="Crit1_FieldType" value="CHAR">
	<TR>
	<TD class="labelit">Account:</TD>
	<TD><SELECT name="Crit1_Operator" id="Crit1_Operator">
		
			<OPTION value="CONTAINS">contains
			<OPTION value="BEGINS_WITH">begins with
			<OPTION value="ENDS_WITH">ends with
			<OPTION value="EQUAL">is
			<OPTION value="NOT_EQUAL">is not
			<OPTION value="SMALLER_THAN">before
			<OPTION value="GREATER_THAN">after
		
		</SELECT>
		
	<INPUT type="text" name="Crit1_Value" id="Crit1_Value" size="20"> </font>
	
	</TD>
	</TR>

	
	<!--- Field: UserNames.LastName=CHAR;40;FALSE --->
	<INPUT type="hidden" name="Crit2_FieldName" id="Crit2_FieldName" value="LastName">
	
	<INPUT type="hidden" name="Crit2_FieldType" id="Crit2_FieldType" value="CHAR">
	<TR>
	<TD class="labelit">Name:</TD>
	<TD><SELECT name="Crit2_Operator" id="Crit2_Operator">
		
			<OPTION value="CONTAINS">contains
			<OPTION value="BEGINS_WITH">begins with
			<OPTION value="ENDS_WITH">ends with
			<OPTION value="EQUAL">is
			<OPTION value="NOT_EQUAL">is not
			<OPTION value="SMALLER_THAN">before
			<OPTION value="GREATER_THAN">after
		
		</SELECT>
		
	<INPUT type="text" name="Crit2_Value" id="Crit2_Value" size="20"> 
	
	</TD>
	</TR>
	
	<!---

	<!--- Field: UserNames.FirstName=CHAR;40;FALSE --->
	<INPUT type="hidden" name="Crit3_FieldName" value="FirstName">
	
	<INPUT type="hidden" name="Crit3_FieldType" value="CHAR">
	<TR>
	<TD class="regular">First name:</TD>
	<TD><SELECT name="Crit3_Operator">
		
			<OPTION value="CONTAINS">contains
			<OPTION value="BEGINS_WITH">begins with
			<OPTION value="ENDS_WITH">ends with
			<OPTION value="EQUAL">is
			<OPTION value="NOT_EQUAL">is not
			<OPTION value="SMALLER_THAN">before
			<OPTION value="GREATER_THAN">after
		
		</SELECT>
		
	<INPUT type="text" name="Crit3_Value" size="20"> 
	
	</TD>
	</TR>
	
	--->
	
	<!--- Field: UserNames.Group=CHAR;40;FALSE --->
	<INPUT type="hidden" name="Crit4_FieldName" id="Crit4_FieldName" value="AccountGroup">
	
	<INPUT type="hidden" name="Crit4_FieldType" id="Crit4_FieldType" value="CHAR">
	<TR>
	<TD class="labelit">Group:</TD>
	<TD><SELECT name="Crit4_Operator" id="Crit4_Operator">
		
			<OPTION value="CONTAINS">contains
			<OPTION value="BEGINS_WITH">begins with
			<OPTION value="ENDS_WITH">ends with
			<OPTION value="EQUAL">is
			<OPTION value="NOT_EQUAL">is not
			<OPTION value="SMALLER_THAN">before
			<OPTION value="GREATER_THAN">after
		
		</SELECT>
		
	<INPUT type="text" name="Crit4_Value" id="Crit4_Value" size="20">
	
	</TD>
	</TR>	
	
	<!--- Field: UserNames.Group=CHAR;40;FALSE --->
	
	<TR>
	<TD class="labelit">Status:</TD>
	<TD class="regular"><input type="radio" name="Status" id="Status" value="0" checked>Active
    	<input type="radio" name="Status" id="Status" value="1">Disabled
	</TD>
	</TR>	
	
</table>	
	
	<tr><td colspan="2" align="center" height="30">
	<input type="submit" value="Search" class="buttonFlat" style="width:120px">
	</td></tr>

</TABLE>

</FORM>

</BODY></HTML>