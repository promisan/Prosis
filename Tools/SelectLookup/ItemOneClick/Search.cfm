<cf_screentop 
   label="Item Select" 
   height="100%" 
   scroll="no" 
   layout="webapp" 
   banner="gray" 
   close="ColdFusion.Window.hide('dialog#url.box#')">

<table align="center" bgcolor="FFFFFF" width="100%" height="100%">

<tr><td valign="top">
<cf_divscroll>

<cfoutput>

<table width="98%" border="0" align="center" cellspacing="0" cellpadding="0" align="center" bordercolor="silver" class="formpadding">

<tr><td>

<form name="select_#url.box#" id="select_#url.box#" method="post">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" onkeyup="if (window.event.keyCode == '13') { document.getElementById('search').click() }">

<cfinvoke component = "Service.Language.Tools"  
	   method           = "LookupOptions" 
	   returnvariable   = "SelectOptions">	

<cfoutput>

    <tr><td height="4"></td></tr>
  
    <!--- Field: UserNames.Account=CHAR;40;FALSE --->
	<INPUT type="hidden" name="Crit1_FieldName_#url.box#" id="Crit1_FieldName_#url.box#" value="ItemDescription">
	
	<INPUT type="hidden" name="Crit1_FieldType_#url.box#" id="Crit1_FieldType_#url.box#" value="CHAR">
	<TR>
	<TD width="100" class="labelit" style="height:30">Name:</TD>
	<TD><SELECT name="Crit1_Operator_#url.box#" id="Crit1_Operator_#url.box#" class="regularxl">
			#SelectOptions	#
		</SELECT>
		
	<INPUT type="text" name="Crit1_Value_#url.box#" id="Crit1_Value_#url.box#" size="20" class="regularxl">
	
	</TD>
	</TR>
	
	<!--- Field: UserNames.LastName=CHAR;40;FALSE --->
	<INPUT type="hidden" name="Crit2_FieldName_#url.box#" id="Crit2_FieldName_#url.box#" value="ItemNo">
	
	<INPUT type="hidden" name="Crit2_FieldType_#url.box#" id="Crit2_FieldType_#url.box#" value="CHAR">
	<TR>
	<TD class="labelit" style="height:30">Code:</TD>
	<TD><SELECT name="Crit2_Operator_#url.box#" id="Crit2_Operator_#url.box#" class="regularxl">
			#SelectOptions	#
		</SELECT>
		
	<INPUT type="text" name="Crit2_Value_#url.box#" id="Crit2_Value_#url.box#" size="20" class="regularxl"> 
	
	</TD>
	</TR>
			
</TABLE>

</tr>

<tr><td colspan="2" class="linedotted"></td></tr>
	
<tr><td colspan="2" align="center">
	
	<cf_tl id="Search" var="1">
	<input type="button" 
	   name="search"
	   id="search"
	   value="<cfoutput>#lt_text#</cfoutput>" 
	   onclick="ColdFusion.navigate('#SESSION.root#/tools/selectlookup/ItemOneClick/Result.cfm?page=1&close=#url.close#&box=#url.box#&link=#url.link#&des1=#url.des1#&filter1=#url.filter1#&filter1value=#url.filter1value#&filter2=#url.filter2#&filter2value=#url.filter2value#','result#url.box#','','','POST','select_#url.box#')"
	   class="button10g">
	   
</td></tr>

<tr><td height="1" class="linedotted"></td></tr>

</cfoutput>

<tr>
	<td colspan="2" align="center">
		<cfdiv id="result#url.box#">
	</td>
</tr>

</table>

</form>

</cfoutput>
</cf_divscroll>
</td></tr>

</table>

<cf_screenbottom layout="webdialog">