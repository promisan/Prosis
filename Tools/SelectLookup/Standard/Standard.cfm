<cf_screentop label="Search" height="100%" scroll="Yes" layout="webapp" close="ColdFusion.Window.hide('dialog#url.box#')">

<table align="center" bgcolor="FFFFFF" width="100%" height="100%">

<tr><td valign="top">

<cfoutput>

<table 
	width="93%" 
	border="0" 
	align="center" 
	cellspacing="0" 
	cellpadding="0" 
	align="center" 
	class="formpadding">

<tr><td>

<form name="select" id="select" method="post">

<table width="100%" border="0" class="formpadding" cellspacing="0" cellpadding="0" align="center" onkeyup="if (window.event.keyCode == '13') { document.getElementById('search').click() }">

<cfinvoke component = "Service.Language.Tools"  
	   method           = "LookupOptions" 
	   returnvariable   = "SelectOptions">


    <tr><td height="4"></td></tr>
  
    <!--- Field: UserNames.Account=CHAR;40;FALSE --->
	<INPUT type="hidden" name="Crit1_FieldName" id="Crit1_FieldName" value="Description">
	
	<INPUT type="hidden" name="Crit1_FieldType" id="Crit1_FieldType" value="CHAR">
	<TR class="labelmedium">
	<TD width="100">Name:</TD>
	<TD><SELECT name="Crit1_Operator" id="Crit1_Operator" class="regularxl">
		
			#SelectOptions#
		
		</SELECT>
		
	<INPUT type="text" name="Crit1_Value" id="Crit1_Value" size="20" class="regularxl">
	
	</TD>
	</TR>
	
	<!--- Field: UserNames.LastName=CHAR;40;FALSE --->
	<INPUT type="hidden" name="Crit2_FieldName" id="Crit2_FieldName" value="Code">
	
	<INPUT type="hidden" name="Crit2_FieldType" id="Crit2_FieldType" value="CHAR">
	<TR class="labelmedium">
	<TD>Code:</TD>
	<TD><SELECT name="Crit2_Operator" id="Crit2_Operator" class="regularxl">
		
			#SelectOptions#
		
		</SELECT>
		
	<INPUT type="text" name="Crit2_Value" id="Crit2_Value" size="20" class="regularxl"> 
	
	</TD>
	</TR>
			
</TABLE>

</tr>
	
<tr><td colspan="2" align="center">
   
	<cf_tl id="Search" var="1">
	<input type="button" 
	   name="search" id="search"
	   value="<cfoutput>#lt_text#</cfoutput>" 
	   onclick="ptoken.navigate('#SESSION.root#/tools/selectlookup/Standard/StandardResult.cfm?page=1&close=#url.close#&box=#box#&link=#link#&des1=#des1#&filter1=#filter1#&filter1value=#filter1value#&filter2=#filter2#&filter2value=#filter2value#','standardresult','','','POST','select')"
	   class="button10g">
</td></tr>

<tr class="line">
	<td colspan="2" align="center">
		<cfdiv id="standardresult">
	</td>
</tr>

</table>


</FORM>

</cfoutput>

</td></tr>

</table>
