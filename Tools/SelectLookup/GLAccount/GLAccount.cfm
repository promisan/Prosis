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
<cf_screentop label="Search" height="100%" scroll="Yes" banner="yellow" option="Select GL account" layout="webdialog" close="ColdFusion.Window.hide('dialog#url.box#')">

<table align="center" bgcolor="FFFFFF" width="100%" height="100%">
<tr><td valign="top">

<cfoutput>

<table width="98%" border="0" align="center" cellspacing="0" cellpadding="0" align="center" bordercolor="silver" class="formpadding">

<tr><td>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center"
   onkeyup="if (window.event.keyCode == '13') { document.getElementById('search').click() }"
   class="formpadding">

<cfinvoke component = "Service.Language.Tools"  
	   method           = "LookupOptions" 
	   returnvariable   = "SelectOptions">	
	      
<form name="selectaccount" id="selectaccount" method="post">

    <tr><td height="4"></td></tr>
		
	<cfquery name="Parent"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
   		SELECT *
		FROM   Ref_AccountParent
	</cfquery>	

	<TR>
	<TD width="100" class="regular">Usage Class:</TD>
	<TD>
	
	  <select name="AccountParent" id="AccountParent" style="width:100;font:10px">
     	   <cfloop query="Parent">
        	<option value="#AccountParent#">#Description#</option>
         	</cfloop>
	    </select>
	
	</TD>
	</TR>
  
    <!--- Field: UserNames.Account=CHAR;40;FALSE --->
	<INPUT type="hidden" name="Crit1_FieldName" id="Crit1_FieldName" value="Description">
	
	<INPUT type="hidden" name="Crit1_FieldType" id="Crit1_FieldType" value="CHAR">
	<TR>
	<TD width="100" class="regular">Name:</TD>
	<TD><SELECT name="Crit1_Operator" id="Crit1_Operator" style="font:10px;width:100;">
		
						#SelectOptions	#									
		
		</SELECT>
		
	<INPUT type="text" name="Crit1_Value" id="Crit1_Value" size="20" class="regular"> </font>
	
	</TD>
	</TR>
	
	<!--- Field: UserNames.LastName=CHAR;40;FALSE --->
	<INPUT type="hidden" name="Crit2_FieldName" id="Crit2_FieldName" value="GLAccount">
	
	<INPUT type="hidden" name="Crit2_FieldType" id="Crit2_FieldType" value="CHAR">
	<TR>
	<TD class="regular">Code:</TD>
	<TD><SELECT name="Crit2_Operator" id="Crit2_Operator" style="width:100;font:10px">
						#SelectOptions	#									
		</SELECT>
		
	<INPUT type="text" name="Crit2_Value" id="Crit2_Value" size="20" class="regular"> 
	
	</TD>
	</TR>
			
</TABLE>

</tr>

<tr><td colspan="2" bgcolor="silver" height="1"></td></tr>
	
<tr><td colspan="2" align="center">

	<cf_tl id="Search" var="1">
	<input type="button" 
	   name="search"
	   id="search"
	   value="<cfoutput>#lt_text#</cfoutput>" 
	   onclick="ptoken.navigate('#SESSION.root#/tools/selectlookup/GLAccount/GLAccountResult.cfm?page=1&close=#url.close#&box=#box#&link=#link#&des1=#des1#&filter1=#filter1#&filter1value=#filter1value#&filter2=#filter2#&filter2value=#filter2value#','accountresult','','','POST','selectaccount')"
	   class="button10g">
</td></tr>

<tr><td height="1" bgcolor="silver"></td></tr>

</FORM>

<tr>
	<td colspan="2" align="center">
		<cfdiv id="accountresult">
	</td>
</tr>

</table>

</cfoutput>

</td></tr>

</table>
