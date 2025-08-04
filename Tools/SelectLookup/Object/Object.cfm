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

<table align="center" bgcolor="FFFFFF" width="100%" height="100%">
<tr><td valign="top">

<form name="selectobject" id="selectobject" method="post" style="height:100%">

<cfoutput>

<table width="94%" height="100%" align="center" class="formpadding">

<tr><td height="20">
 
<table width="100%" 
	border="0" 
	class="formpadding"
	cellspacing="0" 
	cellpadding="0" 
	align="center"
    onkeyup="if (window.event.keyCode == '13') { document.getElementById('search').click() }">

<cfinvoke component = "Service.Language.Tools"  
   method           = "LookupOptions" 
   returnvariable   = "SelectOptions">	
  
    <tr><td height="4"></td></tr>
		
	<cfquery name="Usage"
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_ObjectUsage R
	</cfquery>	

	<TR>
	<TD width="100" class="labelit"><cf_tl id="Usage Class">:</TD>
	<TD>
	
	  <select name="objectusage" id="objectusage" class="regularxl" style="width:100">
     	   <cfloop query="Usage">
        	<option value="#Code#">#Description#</option>
         	</cfloop>
	    </select>
	
	</TD>
	</TR>
  
    <!--- Field: UserNames.Account=CHAR;40;FALSE --->
	<INPUT type="hidden" name="Crit1_FieldName" id="Crit1_FieldName" value="Description">
	
	<INPUT type="hidden" name="Crit1_FieldType" id="Crit1_FieldType" value="CHAR">
	<TR>
	<TD width="100" class="labelit"><cf_tl id="Name">:</TD>
	<TD><SELECT name="Crit1_Operator" id="Crit1_Operator" class="regularxl" style="width:100;">
			#SelectOptions#
		</SELECT>
		
	<INPUT type="text" name="Crit1_Value" id="Crit1_Value" size="20" class="regularxl"> </font>
	
	</TD>
	</TR>
	
	<!--- Field: UserNames.LastName=CHAR;40;FALSE --->
	<INPUT type="hidden" name="Crit2_FieldName" id="Crit2_FieldName" value="Code">	
	<INPUT type="hidden" name="Crit2_FieldType" id="Crit2_FieldType" value="CHAR">
	
	<TR>
	<TD class="labelit"><cf_tl id="Code">:</TD>
	
	<TD><SELECT name="Crit2_Operator" id="Crit2_Operator" class="regularxl" style="width:100;">
			#SelectOptions#
		</SELECT>
		
	<INPUT type="text" name="Crit2_Value" id="Crit2_Value" size="20" class="regularxl"> 
	
	</TD>
	</TR>
			
</TABLE>

</tr>

<tr><td colspan="2" class="line" height="1"></td></tr>
	
<tr><td colspan="2" align="center">

	<cf_tl id="Search" var="1">
	<input type="button" 
	   name="search"
	   id="search"
	   value="<cfoutput>#lt_text#</cfoutput>" 
	   onclick="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/tools/selectlookup/Object/ObjectResult.cfm?page=1&close=#url.close#&box=#box#&link=#link#&des1=#des1#&filter1=#filter1#&filter1value=#filter1value#&filter2=#filter2#&filter2value=#filter2value#','objectresult','','','POST','selectobject')"
	   class="button10g">
</td></tr>

<tr><td height="1" class="line"></td></tr>

<tr>
	<td colspan="2" align="center" height="100%">
	    <cf_divscroll id="objectresult"/>		
	</td>
</tr>

</table>

</FORM>

</cfoutput>

</td></tr>

</table>
