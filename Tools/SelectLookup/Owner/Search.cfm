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
<!---
<cf_screentop label="Search" height="100%" scroll="no" layout="webapp" banner="gray" close="ColdFusion.Window.hide('dialog#url.box#')">
--->

<cfoutput>

<form name="selectowner" style="height:98%" method="post">

<table width="98%" height="100%" border="0" align="center" align="center">

<tr><td height="20">
	
	<table border="0" cellspacing="0" cellpadding="0" class="formpadding">
	
	<cfinvoke component = "Service.Language.Tools"  
		   method           = "LookupOptions" 
		   returnvariable   = "SelectOptions">	
	
	    <tr><td height="4"></td></tr>
	  
	    <!--- Field: UserNames.Account=CHAR;40;FALSE --->
		<INPUT type="hidden" name="Crit1_FieldName" id="Crit1_FieldName" value="Description">
		
		<INPUT type="hidden" name="Crit1_FieldType" id="Crit1_FieldType" value="CHAR">
		<TR>
		<TD width="100" class="labelit">Name:</TD>
		<TD><SELECT name="Crit1_Operator" id="Crit1_Operator" class="regularxl">
				#SelectOptions#
			</SELECT>
			
		<INPUT type="text" name="Crit1_Value" id="Crit1_Value" class="regularxl" size="20"> </font>
		
		</TD>
		</TR>
		
		<!--- Field: UserNames.LastName=CHAR;40;FALSE --->
		<INPUT type="hidden" name="Crit2_FieldName" id="Crit2_FieldName" value="Code">
		
		<INPUT type="hidden" name="Crit2_FieldType" id="Crit2_FieldType" value="CHAR">
		<TR>
		<TD class="labelit">Code:</TD>
		<TD><SELECT name="Crit2_Operator" id="Crit2_Operator" class="regularxl">
				#SelectOptions#
			</SELECT>
			
		<INPUT type="text" name="Crit2_Value" id="Crit2_Value" size="20" class="regularxl"> 
		
		</TD>
		</TR>
				
	</TABLE>
	
	</tr>
	
	<tr><td colspan="2" class="line"></td></tr>
		
	<tr><td colspan="2" align="center" height="10">
	  
		<cf_tl id="Search" var="1">
		
		<input type="button" 
		   value="<cfoutput>#lt_text#</cfoutput>" 
		   onclick="ptoken.navigate('#SESSION.root#/tools/selectlookup/Owner/Result.cfm?page=1&close=#url.close#&box=#box#&link=#link#&des1=#des1#&filter1=#filter1#&filter1value=#filter1value#&filter2=#filter2#&filter2value=#filter2value#','resultunit#box#','','','POST','selectowner')"
		   class="button10g">
		   
	</td></tr>
	
	</cfoutput>
	
	<tr><td height="1" class="line"></td></tr>
	
	<tr>
		<td colspan="2" align="center" style="padding:10px" height="100%">
		<cf_divscroll style="height:100%" id="resultunit#box#"/>				
		</td>
	</tr>
	
	</table>
	
</FORM>
