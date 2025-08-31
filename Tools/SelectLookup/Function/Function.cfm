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
<!--- not needed
<cf_screentop label="Associate a function" bannerheight="50" html="No" line="no" scroll="Yes" layout="webapp" banner="gray" close="ColdFusion.Window.hide('dialog#url.box#')">
---> 

<table align="center" bgcolor="FFFFFF" width="97%" height="100%">

<tr><td valign="top">

<cfinvoke component = "Service.Language.Tools"  
	   method           = "LookupOptions" 
	   returnvariable   = "SelectOptions">	
	   
<cfoutput>

<table width="98%" border="0" align="center" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<tr><td>

	<form name="select" method="post">
	
	<table width="100%" border="0" cellspacing="0" class="formpadding" cellpadding="0" align="center" onkeyup="if (window.event.keyCode == '13') { document.getElementById('search').click() }">
	
	    <tr><td height="4"></td></tr>
	  
	    <!--- Field: UserNames.Account=CHAR;40;FALSE --->
		<INPUT type="hidden" name="Crit1_FieldName" id="Crit1_FieldName" value="FunctionDescription">
		
		<INPUT type="hidden" name="Crit1_FieldType" id="Crit1_FieldType" value="CHAR">
		<TR class="labelmedium">
		<TD width="100"><cf_tl id="Name">:</TD>
		<TD><SELECT name="Crit1_Operator" id="Crit1_Operator" class="regularxl">
				#SelectOptions#
			</SELECT>
			
		<INPUT type="text" name="Crit1_Value" id="Crit1_Value" size="20" class="regularxl">
		
		</TD>
		</TR>
		
		<!--- Field: UserNames.LastName=CHAR;40;FALSE --->
		<INPUT type="hidden" name="Crit2_FieldName" id="Crit2_FieldName" value="FunctionNo">
		
		<INPUT type="hidden" name="Crit2_FieldType" id="Crit2_FieldType" value="CHAR">
		<TR class="labelmedium">
		<TD><cf_tl id="Code">:</TD>
		<TD><SELECT name="Crit2_Operator" id="Crit2_Operator" class="regularxl">
				#SelectOptions#
			</SELECT>
			
		<INPUT type="text" name="Crit2_Value" id="Crit2_Value" size="20" class="regularxl"> 
		
		</TD>
		</TR>
				
	</TABLE>
	
	</tr>
		
	<tr><td colspan="2" >
		<cf_tl id="Close" var="1">
		<input type="button" 
		   value="<cfoutput>#lt_text#</cfoutput>" 
		   onclick="ProsisUI.closeWindow('dialog#url.box#')"
		   class="button10g">
		<cf_tl id="Search" var="1">
		<input type="button" 
		   name="search"
	   id="search"
		   value="<cfoutput>#lt_text#</cfoutput>" 
		   onclick="ptoken.navigate('#SESSION.root#/tools/selectlookup/Function/FunctionResult.cfm?page=1&close=#url.close#&box=#box#&link=#link#&des1=#des1#&filter1=#filter1#&filter1value=#filter1value#&filter2=#filter2#&filter2value=#filter2value#','result#url.box#','','','POST','select')"
		   class="button10g">
	</td></tr>
	
	<tr>
		<td colspan="2" align="center" style="padding-top:5px">
			<cfdiv id="result#url.box#">
		</td>
	</tr>
	
	</table>	
	
	</FORM>

</cfoutput>

</td></tr>

</table>
