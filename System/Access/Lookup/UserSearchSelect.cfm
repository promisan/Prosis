
<cf_screentop height="100%"               
			  banner="gray" 
			  layout="webapp" 
			  band="No" 
			  scroll="No"
			  html="No"			  
			  label="Find User Account"			  
			  systemmodule="System" 
			  close="parent.ColdFusion.Window.destroy('userdialog',true)"
			  functionclass="Window" 
			  functionName="User search">

<!--- Search form --->

<cfparam name="URL.Form" default="">
<cfparam name="URL.ID"   default="">
<cfparam name="URL.ID1"  default="">
<cfparam name="URL.ID2"  default="">
<cfparam name="URL.ID3"  default="">
<cfparam name="URL.ID4"  default="">

<table style="width:100%;height:100%">

<tr><td style="width:100%;height:100%" valign="top">

<FORM target="result" action="UserSearchCriteria.cfm?Form=<cfoutput>#URL.Form#&ID=#URL.Id#&ID1=#URL.ID1#&ID2=#URL.ID2#&ID3=#URL.ID3#&ID4=#URL.ID4#</cfoutput>" method="post">

<table width="90%" align="center" class="formpadding">

    <tr><td height="7"></td></tr>
  
    <!--- Field: UserNames.Account=CHAR;40;FALSE --->
	<INPUT type="hidden" name="Crit1_FieldName" id="Crit1_FieldName" value="Account">
	
	<INPUT type="hidden" name="Crit1_FieldType" id="Crit1_FieldType" value="CHAR">
	<TR>
	<TD class="labelmedium"><cf_tl id="Account">:</TD>
	<TD><SELECT name="Crit1_Operator" id="Crit1_Operator" class="regularxl">
		
			<OPTION value="CONTAINS">contains
			<OPTION value="BEGINS_WITH">begins with
			<OPTION value="ENDS_WITH">ends with
			<OPTION value="EQUAL">is
			<OPTION value="NOT_EQUAL">is not
			<OPTION value="SMALLER_THAN">before
			<OPTION value="GREATER_THAN">after
		
		</SELECT>
		
	<INPUT type="text" name="Crit1_Value" id="Crit1_Value" size="20" class="regularxl">
	
	</TD>
	</TR>
	
	<!--- Field: UserNames.LastName=CHAR;40;FALSE --->
	<INPUT type="hidden" name="Crit2_FieldName" id="Crit2_FieldName" value="LastName">
	
	<INPUT type="hidden" name="Crit2_FieldType" id="Crit2_FieldType" value="CHAR">
	<TR>
	<TD class="labelmedium"><cf_tl id="Last name">:</TD>
	<TD><SELECT name="Crit2_Operator" id="Crit2_Operator" class="regularxl">
		
			<OPTION value="CONTAINS">contains
			<OPTION value="BEGINS_WITH">begins with
			<OPTION value="ENDS_WITH">ends with
			<OPTION value="EQUAL">is
			<OPTION value="NOT_EQUAL">is not
			<OPTION value="SMALLER_THAN">before
			<OPTION value="GREATER_THAN">after
		
		</SELECT>
		
	<INPUT type="text" name="Crit2_Value" id="Crit2_Value" size="20" class="regularxl"> 
	
	</TD>
	</TR>
	
	<!--- Field: UserNames.LastName=CHAR;40;FALSE --->
	<INPUT type="hidden" name="Crit3_FieldName" id="Crit3_FieldName" value="FirstName">
	
	<INPUT type="hidden" name="Crit3_FieldType" id="Crit3_FieldType" value="CHAR">
	<TR>
	<TD class="labelmedium"><cf_tl id="First name">:</TD>
	<TD><SELECT name="Crit3_Operator" id="Crit3_Operator" class="regularxl">
		
			<OPTION value="CONTAINS">contains
			<OPTION value="BEGINS_WITH">begins with
			<OPTION value="ENDS_WITH">ends with
			<OPTION value="EQUAL">is
			<OPTION value="NOT_EQUAL">is not
			<OPTION value="SMALLER_THAN">before
			<OPTION value="GREATER_THAN">after
		
		</SELECT>
		
	<INPUT type="text" name="Crit3_Value" id="Crit3_Value" size="20" class="regularxl"> 
	
	</TD>
	</TR>
	
	 <!--- Field: UserNames.IndexNo --->
	<INPUT type="hidden" name="Crit0_FieldName" id="Crit0_FieldName" value="IndexNo">
	
	<INPUT type="hidden" name="Crit0_FieldType" id="Crit0_FieldType" value="CHAR">
	<TR>
	<TD class="labelmedium"><cf_tl id="IndexNo">:</TD>
	<TD><SELECT name="Crit0_Operator" id="Crit0_Operator" class="regularxl">
		
			<OPTION value="CONTAINS">contains
			<OPTION value="BEGINS_WITH">begins with
			<OPTION value="ENDS_WITH">ends with
			<OPTION value="EQUAL">is
			<OPTION value="NOT_EQUAL">is not
			<OPTION value="SMALLER_THAN">before
			<OPTION value="GREATER_THAN">after
		
		</SELECT>
		
	<INPUT type="text" name="Crit0_Value" id="Crit0_Value" size="20" class="regularxl"> 
	
	</TD>
	</TR>
	
	<!--- Field: UserNames.LastName=CHAR;40;FALSE --->
	<INPUT type="hidden" name="Crit21_FieldName" id="Crit21_FieldName" value="LastName">
	
	<INPUT type="hidden" name="Crit21_FieldType" id="Crit21_FieldType" value="CHAR">
	<TR>
	<TD class="labelmedium"><cf_tl id="User group name">:</TD>
	<TD><SELECT name="Crit21_Operator" id="Crit21_Operator" class="regularxl">
		
			<OPTION value="CONTAINS">contains
			<OPTION value="BEGINS_WITH">begins with
			<OPTION value="ENDS_WITH">ends with
			<OPTION value="EQUAL">is
			<OPTION value="NOT_EQUAL">is not
			<OPTION value="SMALLER_THAN">before
			<OPTION value="GREATER_THAN">after
		
		</SELECT>
		
	<INPUT type="text" name="Crit21_Value" id="Crit21_Value" size="20" class="regularxl"> 
	
	</TD>
	</TR>

	
	<!--- Field: UserNames.Group=CHAR;40;FALSE --->
	<INPUT type="hidden" name="Crit4_FieldName" id="Crit4_FieldName" value="AccountGroup">
	
	<INPUT type="hidden" name="Crit4_FieldType" id="Crit4_FieldType" value="CHAR">
	<TR>
	<TD class="labelmedium"><cf_tl id="Account group">:</TD>
	<TD><SELECT name="Crit4_Operator" id="Crit4_Operator" class="regularxl">
		
			<OPTION value="CONTAINS">contains
			<OPTION value="BEGINS_WITH">begins with
			<OPTION value="ENDS_WITH">ends with
			<OPTION value="EQUAL">is
			<OPTION value="NOT_EQUAL">is not
			<OPTION value="SMALLER_THAN">before
			<OPTION value="GREATER_THAN">after
		
		</SELECT>
		
	<INPUT type="text" name="Crit4_Value" id="Crit4_Value" size="20" class="regularxl">
	
	</TD>
	</TR>	
	
	<!--- Field: UserNames.Group=CHAR;40;FALSE --->
	
	<TR>
	<TD class="labelmedium"><cf_tl id="Status">:</TD>
	<TD class="labelmedium"><input type="radio" class="radiol" name="Status" id="Status" value="0" checked>Active
    	<input type="radio" class="radiol" name="Status" id="Status" value="1">Disabled
	</TD>
	</TR>	
	
	
	<tr><td colspan="2" class="line" height="1"></td></tr>
	<tr><td colspan="2" align="center" height="30">
		<input type="submit"  value="Locate" class="button10s" style="width:190;height:25;font-size:14">
	</td></tr>

</TABLE>

</FORM>

</td>

</tr>

</table>

<cf_screenbottom layout="webapp">
