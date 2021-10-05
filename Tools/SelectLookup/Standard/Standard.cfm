
<table align="center" border="0" width="98%" height="100%">

<tr><td valign="top">

<cfoutput>

	<form name="select" id="select" method="post" syle="height:98%">
	
	<table 
		width="100%" 	
		align="center" 
		class="formpadding">
	
	<tr><td>
	
	<table width="100%" class="formpadding" 
	align="center" onkeyup="if (window.event.keyCode == '13') { document.getElementById('search').click() }">
	
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
	
	</td>
	
	</tr>
		
	<tr><td colspan="2" align="center">
	   
		<cf_tl id="Search" var="1">
		<input type="button" 
		   name="search" id="search" style="border:1px solid silver"
		   value="<cfoutput>#lt_text#</cfoutput>" 
		   onclick="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/tools/selectlookup/Standard/StandardResult.cfm?page=1&close=#url.close#&box=#box#&link=#link#&des1=#des1#&filter1=#filter1#&filter1value=#filter1value#&filter2=#filter2#&filter2value=#filter2value#','standardresult','','','POST','select')"
		   class="button10g">
	</td></tr>
	
	<tr class="line">
		<td colspan="2" align="center" id="standardresult"></td>
	</tr>
	
	</table>
	
	</FORM>

</cfoutput>

</td></tr>

</table>
