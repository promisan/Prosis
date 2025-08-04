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

<!---
<cf_screentop label="Search Entity" height="100%" banner="yellow" scroll="no" layout="webapp" user="no" close="ColdFusion.Window.hide('dialog#url.box#')">
--->

<cf_divscroll>

<table align="center" bgcolor="FFFFFF" width="100%" height="100%">
<tr><td valign="top">

<form name="selectmission" id="selectmission" method="post" onsubmit="return false">

<table width="98%" border="0" align="center"  align="center">

<tr><td>

	<table width="100%" class="formpadding" align="center">
	<cfoutput>
	
	<cfinvoke component = "Service.Language.Tools"  
		   method           = "LookupOptions" 
		   returnvariable   = "SelectOptions">	
	
	    <tr><td height="4"></td></tr>
	  	
		<!--- Field: UserNames.LastName=CHAR;40;FALSE --->
		<INPUT type="hidden" name="Crit2_FieldName" id="Crit2_FieldName" value="MissionType">	
		<INPUT type="hidden" name="Crit2_FieldType" id="Crit2_FieldType" value="CHAR">
		<TR>
		<TD class="labelmedium">Type:</TD>
		<TD>
		<input type="Hidden" name="Crit2_Operator" id="Crit2_Operator" value="EQUAL">
		<cfquery name="qMissionType" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  *
			FROM	Ref_MissionType
		</cfquery>
		
		<SELECT name="Crit2_Value" id="Crit2_Value" class="regularxl">
			<option value="">-- All --</option>
			<cfloop query="qMissionType">
				<OPTION value="#MissionType#">#MissionType#
			</cfloop>
		</SELECT>
		
		</TD>
		</TR>
		
		<!--- Field: UserNames.LastName=CHAR;40;FALSE --->
		<INPUT type="hidden" name="Crit3_FieldName" id="Crit3_FieldName" value="MissionName">	
		<INPUT type="hidden" name="Crit3_FieldType" id="Crit3_FieldType" value="CHAR">
		<TR>
		<TD class="labelmedium">Name:</TD>
		<TD><SELECT name="Crit3_Operator" id="Crit3_Operator" class="regularxl">
				#SelectOptions	#
			</SELECT>
			
		<input type="input" 
		     name="Crit3_Value" 
			 id="Crit3_Value"
		     class="regularxl"  
		     onkeyup="if (window.event.keyCode == '13') { document.getElementById('search').click() }"> 
		
		</TD>
		</TR>
				
	</TABLE>



</td>

</tr>

</cfoutput>
		
<tr class="line"><td colspan="2" align="center" style="padding-top:4px;height:35px">
  
	<cf_tl id="Search" var="1">
	<cfoutput>
	<input type="button"
       name="search"
	   id="search"
       value="#lt_text#"
       class="button10g"
       onClick="javascript:ptoken.navigate('#SESSION.root#/tools/selectlookup/Mission/Result.cfm?page=1&close=#url.close#&box=#box#&link=#link#&des1=#des1#&filter1=#url.filter1#&filtervalue1=#url.filtervalue1#','resultmission#box#','','','POST','selectmission')">
	 </cfoutput>  
	   
</td></tr>

<tr>
	<td colspan="2" style="padding:5px" align="center" id="resultmission<cfoutput>#box#</cfoutput>"></td>
</tr>

</table>

</form>

</td></tr>

</table>
</cf_divscroll>