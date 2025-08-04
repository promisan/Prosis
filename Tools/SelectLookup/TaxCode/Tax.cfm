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

<!--- not needed 
<cf_screentop label="Search" height="100%"
    scroll="no" jquery="Yes" banner="gray" line="no" layout="webapp" close="ProsisUI.closeWindow.hide('dialog#url.box#')">
--->

<table align="center" bgcolor="FFFFFF" width="100%" height="100%">

<tr><td valign="top">

	<table width="98%" border="0" align="center" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<tr><td>
	
	<cfoutput>
		
	<form name="tax#url.box#" id="tax#url.box#" method="post">
		
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<cfinvoke component = "Service.Language.Tools"  
		   method           = "LookupOptions" 
		   returnvariable   = "SelectOptions">	
		  
	    <tr><td height="4"></td></tr>
	  
		<INPUT type="hidden" name="Crit1_FieldName" id="Crit1_FieldName" value="TaxName">
		
		<INPUT type="hidden" name="Crit1_FieldType" id="Crit1_FieldType" value="CHAR">
		<TR>
		<TD style="height:28px;padding:3px" width="100" class="labelmedium"><cf_tl id="Name">:</TD>
		<TD><SELECT name="Crit1_Operator" id="Crit1_Operator" class="regularxl enterastab">
			
				#SelectOptions#
			
			</SELECT>
			
		<INPUT type="text" name="Crit1_Value" id="Crit1_Value" class="regularxl enterastab" size="20" value=""> 
	
		</TD>
		</TR>
		
		<!--- Field: UserNames.LastName=CHAR;40;FALSE --->
		<INPUT type="hidden" name="Crit2_FieldName" id="Crit2_FieldName" value="TaxCode">
		
		<INPUT type="hidden" name="Crit2_FieldType" id="Crit2_FieldType" value="CHAR">
		<TR>
		<TD style="height:28px;padding:3px" class="labelmedium"><cf_tl id="TaxId">:</TD>
		<TD><SELECT name="Crit2_Operator" id="Crit2_Operator" class="regularxl enterastab">
			
				#SelectOptions#
			
			</SELECT>
			
		<INPUT type="text" name="Crit2_Value" id="Crit2_Value" size="20" class="regularxl enterastab"> 
		
		</TD>
		</TR>
		
		<!---
			
		<INPUT type="hidden" name="Crit3_FieldName" id="Crit3_FieldName" value="PhoneNumber">
		
		<INPUT type="hidden" name="Crit3_FieldType" id="Crit3_FieldType" value="CHAR">
		<TR>
		<TD style="height:28px;padding:3px" class="labelmedium"><cf_tl id="Number">:</TD>
		<TD><SELECT name="Crit3_Operator" id="Crit3_Operator" class="regularxl enterastab">
			
				#SelectOptions#
			
			</SELECT>
			
		<INPUT type="text" name="Crit3_Value" id="Crit3_Value" size="20" class="regularxl enterastab"> 
		
		</TD>
		</TR>
		
			
		<INPUT type="hidden" name="Crit4_FieldName" id="Crit4_FieldName" value="eMailAddress">
		
		<INPUT type="hidden" name="Crit4_FieldType" id="Crit4_FieldType" value="CHAR">
		<TR>
		<TD style="height:28px;padding:3px" class="labelmedium"><cf_tl id="EMail">:</TD>
		<TD><SELECT name="Crit4_Operator" id="Crit3_Operator" class="regularxl enterastab">
			
				#SelectOptions#
			
			</SELECT>
			
		<INPUT type="text" name="Crit4_Value" id="Crit4_Value" size="20" class="regularxl enterastab"> 
		
		</TD>
		</TR>
		
		--->
		
				
	</TABLE>
	
	</FORM>
	
	</cfoutput>	
	
	</td>
	
	</tr>
	
	<tr><td colspan="2" class="line"></td></tr>
		
	<tr><td colspan="2">
	  
		<cf_tl id="Search" var="1">
		
		<cfoutput>
		
		<input type="button"
		   name="search" 
		   id="search"
		   value="<cfoutput>#lt_text#</cfoutput>" 
		   onclick="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/tools/selectlookup/TaxCode/TaxResult.cfm?datasource=#datasource#&page=1&close=#url.close#&box=#box#&link=#link#&des1=#des1#&filter1=#filter1#&filter1value=#filter1value#&filter2=#filter2#&filter2value=#filter2value#','resultunit#box#','','','POST','tax#box#')"
		   class="button10g">
		   
		  </cfoutput> 
		   
	</td></tr>
	
	
	<tr><td height="1" class="line"></td></tr>
	
	<tr>
		<td colspan="2" align="center">
			<cfdiv id="resultunit#box#">
		</td>
	</tr>
	
	</table>


</td></tr>

</table>