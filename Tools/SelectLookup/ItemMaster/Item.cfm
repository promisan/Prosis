
<table align="center" bgcolor="FFFFFF" width="100%" height="100%">

<tr><td valign="top">

<cfoutput>

<table 
	width="98%" 
	border="0" 
	align="center" 
	cellspacing="0" 
	cellpadding="0" 
	class="formpadding"
	align="center" 
	bordercolor="silver">

<tr><td>

<form name="select" id="select" method="post">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" onkeyup="if (window.event.keyCode == '13') { document.getElementById('search').click() }">

<cfinvoke component = "Service.Language.Tools"  
	   method           = "LookupOptions" 
	   returnvariable   = "SelectOptions">	

    <tr><td height="4"></td></tr>
  
    <!--- Field: UserNames.Account=CHAR;40;FALSE --->
	<INPUT type="hidden" name="Crit1_FieldName" id="Crit1_FieldName" value="Description">
	
	<INPUT type="hidden" name="Crit1_FieldType" id="Crit1_FieldType" value="CHAR">
	<TR class="labelmedium">
	<TD width="100" class="regular">Name:</TD>
	<TD><SELECT class="regularxl" name="Crit1_Operator" id="Crit1_Operator">
			#SelectOptions#
		</SELECT>
		
	<INPUT class="regularxl" type="text" name="Crit1_Value" id="Crit1_Value" size="20"> </font>
	
	</TD>
	</TR>
	
	<!--- Field: UserNames.LastName=CHAR;40;FALSE --->
	<INPUT type="hidden" name="Crit2_FieldName" id="Crit2_FieldName" value="Code">
	
	<INPUT type="hidden" name="Crit2_FieldType" id="Crit2_FieldType" value="CHAR">
	<TR class="labelmedium">
	<TD >Code:</TD>
	<TD><SELECT class="regularxl" name="Crit2_Operator" id="Crit2_Operator">
			#SelectOptions#
		</SELECT>
		
	<INPUT class="regularxl" type="text" name="Crit2_Value" id="Crit2_Value" size="20"> 
	
	</TD>
	</TR>
			
</TABLE>

</tr>

<tr class="line"><td colspan="2" height="1"></td></tr>
	
<tr><td colspan="2" align="center">
	<cf_tl id="Close" var="1">
	<input type="button" 
	   value="<cfoutput>#lt_text#</cfoutput>" 
	   onclick="ColdFusion.Window.hide('dialog#url.box#')"
	   class="button10g">
	<cf_tl id="Search" var="1">
	<input type="button" 
	   name="search" id="search"
	   value="<cfoutput>#lt_text#</cfoutput>" 
	   onclick="ptoken.navigate('#SESSION.root#/tools/selectlookup/ItemMaster/ItemResult.cfm?page=1&close=#url.close#&box=#box#&link=#link#&des1=#des1#&filter1=#filter1#&filter1value=#filter1value#&filter2=#filter2#&filter2value=#filter2value#','result#url.box#','','','POST','select')"
	   class="button10g">
</td></tr>

<tr class="line"><td colspan="2" height="1"></td></tr>

<tr>
	<td colspan="2" align="center" id="result#url.box#">	
	</td>
</tr>

</table>


</FORM>

</cfoutput>

</td></tr>

</table>
