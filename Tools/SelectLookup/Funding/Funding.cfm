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
<cf_screentop label="Search" height="100%" scroll="No" layout="webapp" banner="yellow" close="ColdFusion.Window.hide('dialog#url.box#')">

<table align="center" bgcolor="FFFFFF" width="100%" height="100%" >

<tr><td valign="top" height="100%" style="padding:10px">

<cfoutput>

<form name="searchselectfunding" style="width:100%;height:100%" id="searchselectfunding" method="post">

<table width="100%" height="100%" border="0" align="center" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<tr><td height="30">

<cfinvoke component = "Service.Language.Tools"  
	   method           = "LookupOptions" 
	   returnvariable   = "SelectOptions">	
	   
	  
	<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	    <tr><td height="4"></td></tr>
		
		<INPUT type="hidden" name="Crit0_FieldName" id="Crit0_FieldName" value="FundingType">	
		<INPUT type="hidden" name="Crit0_FieldType" id="Crit0_FieldType" value="CHAR">
		<TR>
		<TD align="left" class="labelit"><cf_tl id="Type">:</TD>
		<TD>
		<table cellspacing="0" cellpadding="0">
			<tr>
				<td>
				<SELECT name="Crit0_Operator" id="Crit0_Operator" class="regularxl">
						#SelectOptions	#									
				</SELECT>
				</td>
				<td>	
					<INPUT type="text" name="Crit0_Value" id="Crit0_Value" size="12" class="regularxl">
				</td>
		   	</tr>
		</table>
		</TD>
		  
		
		<INPUT type="hidden" name="Crit5_FieldName" id="Crit5_FieldName" value="Reference">	
		<INPUT type="hidden" name="Crit5_FieldType" id="Crit5_FieldType" value="CHAR">
		
		<TD style="padding-left:5px" align="left" class="labelit"><cf_tl id="Reference">:</TD>
		<TD>
		<table cellspacing="0" cellpadding="0">
			<tr>
				<td>
				<SELECT name="Crit5_Operator" id="Crit5_Operator" class="regularxl">
						#SelectOptions	#									
				</SELECT>
				</td>
				<td>	
					<INPUT type="text" name="Crit5_Value" id="Crit5_Value" size="12" class="regularxl">
				</td>
		   	</tr>
		</table>
		</TD>
				
		</TR>	            
			
		<!--- Field: Staff.LastName=CHAR;40;FALSE --->
		<INPUT type="hidden" name="Crit2_FieldName" id="Crit2_FieldName" value="Fund">
		<INPUT type="hidden" name="Crit2_FieldType" id="Crit2_FieldType" value="CHAR">
		<TR>
		<td width="100" class="labelit" align="left"><cf_tl id="Fund">:</td>
				
		<TD>
		<table cellspacing="0" cellpadding="0">
			<tr>
				<td>
				<SELECT name="Crit2_Operator" id="Crit2_Operator" class="regularxl">
						#SelectOptions	#									
				</SELECT>
				</td>
				<td>	
					<INPUT type="text" name="Crit2_Value" id="Crit2_Value" size="12" class="regularxl">
				</td>
		   	</tr>
		</table>
		</TD>
		
		
		<INPUT type="hidden" name="Crit1_FieldName" id="Crit1_FieldName" value="ProjectCode">	
		<INPUT type="hidden" name="Crit1_FieldType" id="Crit1_FieldType" value="CHAR">
		
		<TD  style="padding-left:5px" align="left" class="labelit"><cf_tl id="WBSe">:</TD>
		<TD>
		<table cellspacing="0" cellpadding="0">
			<tr>
				<td>
				<SELECT name="Crit1_Operator" id="Crit1_Operator" class="regularxl">
						#SelectOptions#									
				</SELECT>
				</td>
				<td>	
					<INPUT type="text" name="Crit1_Value" id="Crit1_Value" size="12" class="regularxl">
				</td>
		   	</tr>
		</table>
		</TD>
				
		</TR>	
		
		<INPUT type="hidden" name="Crit4_FieldName" id="Crit4_FieldName" value="OrgUnitCode">	
		<INPUT type="hidden" name="Crit4_FieldType" id="Crit4_FieldType" value="CHAR">
		<TR>
		<TD align="left" class="labelit"><cf_tl id="Cost Center">:</TD>
		<TD>
		<table cellspacing="0" cellpadding="0">
			<tr>
				<td>
				<SELECT name="Crit4_Operator" id="Crit4_Operator" class="regularxl">
						#SelectOptions#									
				</SELECT>
				</td>
				<td>	
					<INPUT type="text" name="Crit4_Value" id="Crit4_Value" size="12" class="regularxl">
				</td>
		   	</tr>
		</table>
		</TD>
				
		<INPUT type="hidden" name="Crit3_FieldName" id="Crit3_FieldName" value="ObjectCode">	
		<INPUT type="hidden" name="Crit3_FieldType" id="Crit3_FieldType" value="CHAR">
		
		<TD  style="padding-left:5px" class="labelit"><cf_tl id="Sponsored Class">:</TD>
		<TD>
		<table cellspacing="0" cellpadding="0">
			<tr>
				<td>
				<SELECT name="Crit3_Operator" id="Crit3_Operator" class="regularxl">
						#SelectOptions#									
				</SELECT>
				</td>
				<td>	
					<INPUT type="text" name="Crit3_Value" id="Crit3_Value" size="12" class="regularxl">
				</td>
		   	</tr>
		</table>
		</TD>
				
		</TR>	
		
		<INPUT type="hidden" name="Crit6_FieldName" id="Crit6_FieldName" value="ProgramCode">	
		<INPUT type="hidden" name="Crit6_FieldType" id="Crit6_FieldType" value="CHAR">
		<TR>
		<TD align="left" class="labelit"><cf_tl id="Functional Area">:</TD>
		<TD>
		<table cellspacing="0" cellpadding="0">
			<tr>
				<td>
				<SELECT name="Crit6_Operator" id="Crit6_Operator" class="regularxl">
						#SelectOptions#									
				</SELECT>
				</td>
				<td>	
					<INPUT type="text" name="Crit6_Value" id="Crit6_Value" size="12" class="regularxl">
				</td>
		   	</tr>
		</table>
		</TD>
				
				
		<INPUT type="hidden" name="Crit7_FieldName" id="Crit7_FieldName" value="CBGrant">	
		<INPUT type="hidden" name="Crit7_FieldType" id="Crit7_FieldType" value="CHAR">
		
		<TD  style="padding-left:5px" class="labelit"><cf_tl id="Grant">:</TD>
		<TD>
		<table cellspacing="0" cellpadding="0">
			<tr>
				<td>
				<SELECT name="Crit7_Operator" id="Crit7_Operator" class="regularxl">
						#SelectOptions#									
				</SELECT>
				</td>
				<td>	
					<INPUT type="text" name="Crit7_Value" id="Crit7_Value" size="12" class="regularxl">
				</td>
		   	</tr>
		</table>
		</TD>						
		</TR>	    
					
	 						
	</TABLE>

</td></tr>
		
<tr class="line"><td></td></tr>

<cfset nav = "#SESSION.root#/tools/selectlookup/Funding/FundingResult.cfm?close=#url.close#&box=#box#&link=#link#&des1=#des1#">
	
<tr><td colspan="2" height="22" align="center">
	<cf_tl id="Close" var="1">
	<input type="button" 
	   value="<cfoutput>#lt_text#</cfoutput>" 
	   onclick="ColdFusion.Window.hide('dialog#url.box#')"
	   class="button10g" style="width:100;height:25">
	<cf_tl id="Search" var="1">
	<input type="button" 
	   value="<cfoutput>#lt_text#</cfoutput>" 
	   onclick="ptoken.navigate('#nav#&page=1','searchresultfunding#box#','','','POST','searchselectfunding')"
	   class="button10g" style="width:100;height:25">
</td></tr>
<tr>
	<td colspan="2" height="100%" align="center">
	
	<cf_divscroll id="searchresultfunding#box#"></cf_divscroll>
	</td>
</tr>

</table>

</FORM>
</cfoutput>
	
</td></tr>

</table>

