
<!---
<cf_screentop label="Search" height="100%"
    scroll="no" jquery="Yes" banner="gray" line="no" layout="webapp" close="ProsisUI.closeWindow('dialog#url.box#')">
	--->

<table align="center" bgcolor="FFFFFF" width="100%" height="100%">

<tr><td valign="top">

	<cfoutput>
		
	<form name="selectcustomerform#url.box#" id="selectcustomerform#url.box#" onsubmit="return false" method="post">
	
	<table width="98%" border="0" align="center" cellspacing="0" cellpadding="0" align="center">
	
	<tr><td>
			
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<cfinvoke component = "Service.Language.Tools"  
		   method           = "LookupOptions" 
		   returnvariable   = "SelectOptions">	
		  
	    <tr><td height="4"></td></tr>
	  
		<INPUT type="hidden" name="Crit1_FieldName" id="Crit1_FieldName" value="CustomerName">		
		<INPUT type="hidden" name="Crit1_FieldType" id="Crit1_FieldType" value="CHAR">
		<TR>
		<TD style="height:27px;padding:2px;min-width:100px"  class="labelmedium"><cf_tl id="Name">:</TD>
		<TD><SELECT name="Crit1_Operator" id="Crit1_Operator" class="regularxl">#SelectOptions#</SELECT>			
		<INPUT type="text" name="Crit1_Value" id="Crit1_Value" class="regularxl" size="20" value=""> 	
		</TD>
		</TR>
		
		<INPUT type="hidden" name="Crit5_FieldName" id="Crit5_FieldName" value="CustomerSerialNo">		
		<INPUT type="hidden" name="Crit5_FieldType" id="Crit5_FieldType" value="CHAR">
		<TR>
		<TD style="height:27px;padding:2px" class="labelmedium"><cf_tl id="CustomerNo">:</TD>
		<TD><SELECT name="Crit5_Operator" id="Crit5_Operator" class="regularxl">#SelectOptions#</SELECT>			
		<INPUT type="text" name="Crit5_Value" id="Crit5_Value" size="20" class="regularxl"> 		
		</TD>
		</TR>
				
		<INPUT type="hidden" name="Crit2_FieldName" id="Crit2_FieldName" value="Reference">		
		<INPUT type="hidden" name="Crit2_FieldType" id="Crit2_FieldType" value="CHAR">
		<TR>
		<TD style="height:27px;padding:2px" class="labelmedium"><cf_tl id="Customer Code">:</TD>
		<TD><SELECT name="Crit2_Operator" id="Crit2_Operator" class="regularxl">#SelectOptions#</SELECT>			
		<INPUT type="text" name="Crit2_Value" id="Crit2_Value" size="20" class="regularxl"> 		
		</TD>
		</TR>		
					
		<INPUT type="hidden" name="Crit3_FieldName" id="Crit3_FieldName" value="PhoneNumber">		
		<INPUT type="hidden" name="Crit3_FieldType" id="Crit3_FieldType" value="CHAR">
		<TR>
		<TD style="height:27px;padding:2px" class="labelmedium"><cf_tl id="Number">:</TD>
		<TD><SELECT name="Crit3_Operator" id="Crit3_Operator" class="regularxl enterastab">#SelectOptions#</SELECT>			
		<INPUT type="text" name="Crit3_Value" id="Crit3_Value" size="20" class="regularxl enterastab"> 		
		</TD>
		</TR>
					
		<INPUT type="hidden" name="Crit4_FieldName" id="Crit4_FieldName" value="eMailAddress">		
		<INPUT type="hidden" name="Crit4_FieldType" id="Crit4_FieldType" value="CHAR">
		<TR>
		<TD style="height:27px;padding:2px" class="labelmedium"><cf_tl id="EMail">:</TD>
		<TD><SELECT name="Crit4_Operator" id="Crit4_Operator" class="regularxl enterastab">#SelectOptions#</SELECT>			
		<INPUT type="text" name="Crit4_Value" id="Crit4_Value" size="20" class="regularxl enterastab"> 		
		</TD>
		</TR>		
				
	</TABLE>
	
	
	</td>
	
	</tr>
			
	<tr class="line"><td colspan="2" style="padding:4px">
	  
		<cf_tl id="Search" var="1">
		
		<cfoutput>
		
		<input type="submit"
		   name="search" 
		   id="search"
		   value="<cfoutput>#lt_text#</cfoutput>" 
		   onclick="ptoken.navigate('#SESSION.root#/tools/selectlookup/Customer/CustomerResult.cfm?datasource=#datasource#&page=1&close=#url.close#&box=#box#&link=#link#&des1=#des1#&filter1=#filter1#&filter1value=#filter1value#&filter2=#filter2#&filter2value=#filter2value#','resultunit#box#','','','POST','selectcustomerform#box#')"
		   class="button10g">
		   
		  </cfoutput> 
		   
	</td></tr>
		
	<cfoutput>
	<tr>
		<td colspan="2" align="center" id="resultunit#box#"></td>
	</tr>
	</cfoutput>
	
	</FORM>
	
	</cfoutput>	
	
	</table>


</td></tr>

</table>