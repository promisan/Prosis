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
<cf_screentop html="No">

<cfset Page         = "0">
<cfset add          = "0">
<cfinclude template = "../HeaderMaintain.cfm"> 		

<cfform action="ItemSearchQuery.cfm?idmenu=#url.idmenu#" method="post">

<cfquery name="lookupGLAccount" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT	*
  	FROM Ref_Account A
  	WHERE EXISTS (SELECT *
					FROM Ref_AccountMission M
					WHERE M.GLAccount = A.GLAccount)
	AND glAccount in (SELECT DISTINCT glAccount FROM workorder.dbo.ref_funding)
	ORDER BY GlAccount ASC
</cfquery>

<table width="95%" border="0" cellspacing="2" cellpadding="2" align="center">

	<tr><td height="1" class="line"></td></tr>
	<tr><td height="10"></td></tr>
	
	<tr>
	<td align="center">
	
	    <table width="70%" border="0" class="formpadding formspacing" cellspacing="0" cellpadding="0" align="center">
	 
		<!--- Field: FundingType=CHAR;100;FALSE --->
		<INPUT type="hidden" name="Crit1_FieldName" id="Crit1_FieldName" value="FundingType">
		
		<INPUT type="hidden" name="Crit1_FieldType" id="Crit1_FieldType" value="CHAR">
		<TR>
		<TD class="labelmedium" width="20%">Funding Type:</TD>
		<TD width="20%"><SELECT class="regularxl" name="Crit1_Operator" id="Crit1_Operator">
			
				<OPTION value="CONTAINS">contains
				<OPTION value="BEGINS_WITH">begins with
				<OPTION value="ENDS_WITH">ends with
				<OPTION value="EQUAL">is
				<OPTION value="NOT_EQUAL">is not
				<OPTION value="SMALLER_THAN">before
				<OPTION value="GREATER_THAN">after
			
			</SELECT>
		</TD>
		<TD width="60%">
	
	    <INPUT type="text" class="regularxl" name="Crit1_Value" id="Crit1_Value" size="30">
		
		</TD>
		</TR>	
		<!---
		<tr valign="top"><td height="19"></td></tr>
		<!--- ---------------------------- --->
		
		
		<!--- Field: Period=CHAR;100;FALSE --->
		<INPUT type="hidden" name="Crit2_FieldName" id="Crit2_FieldName" value="Period">
		
		<INPUT type="hidden" name="Crit2_FieldType" id="Crit2_FieldType" value="CHAR">
		<TR>
		<TD class="label">Period:</TD>
		<TD><SELECT name="Crit2_Operator" id="Crit2_Operator">
			
				<OPTION value="CONTAINS">contains
				<OPTION value="BEGINS_WITH">begins with
				<OPTION value="ENDS_WITH">ends with
				<OPTION value="EQUAL">is
				<OPTION value="NOT_EQUAL">is not
				<OPTION value="SMALLER_THAN">before
				<OPTION value="GREATER_THAN">after
			
			</SELECT>
		</TD>
		<TD>
	
	    <INPUT type="text" name="Crit2_Value" id="Crit2_Value" size="30">
		
		</TD>
		</TR>	
		--->
		
		
		<!--- Field: Fund=CHAR;100;FALSE --->
		<INPUT type="hidden" name="Crit3_FieldName" id="Crit3_FieldName" value="Fund">
		
		<INPUT type="hidden" name="Crit3_FieldType" id="Crit3_FieldType" value="CHAR">
		<TR>
		<TD class="labelmedium">Fund:</TD>
		<TD><SELECT class="regularxl" name="Crit3_Operator" id="Crit3_Operator">
			
				<OPTION value="CONTAINS">contains
				<OPTION value="BEGINS_WITH">begins with
				<OPTION value="ENDS_WITH">ends with
				<OPTION value="EQUAL">is
				<OPTION value="NOT_EQUAL">is not
				<OPTION value="SMALLER_THAN">before
				<OPTION value="GREATER_THAN">after
			
			</SELECT>
		</TD>
		<TD>
	
	    <INPUT type="text" class="regularxl" name="Crit3_Value" id="Crit3_Value" size="30">
		
		</TD>
		</TR>	
		
		
		<!--- Field: OrgUnitCode=CHAR;100;FALSE --->
		<INPUT type="hidden" name="Crit4_FieldName" id="Crit4_FieldName" value="OrgUnitCode">
		
		<INPUT type="hidden" name="Crit4_FieldType" id="Crit4_FieldType" value="CHAR">
		<TR>
		<!--- <TD class="labelmedium">OrgUnit:</TD> --->
		<TD class="labelmedium">Cost Center:</TD>
		<TD><SELECT class="regularxl" name="Crit4_Operator" id="Crit4_Operator">
			
				<OPTION value="CONTAINS">contains
				<OPTION value="BEGINS_WITH">begins with
				<OPTION value="ENDS_WITH">ends with
				<OPTION value="EQUAL">is
				<OPTION value="NOT_EQUAL">is not
				<OPTION value="SMALLER_THAN">before
				<OPTION value="GREATER_THAN">after
			
			</SELECT>
		</TD>
		<TD>
	
	    <INPUT type="text" class="regularxl" name="Crit4_Value" id="Crit4_Value" size="30">
		
		</TD>
		</TR>	
		
		<!--- Field: ProjectCode=CHAR;100;FALSE --->
		<INPUT type="hidden" name="Crit5_FieldName" id="Crit5_FieldName" value="ProjectCode">
		
		<INPUT type="hidden" name="Crit5_FieldType" id="Crit5_FieldType" value="CHAR">
		<TR>
		<!--- <TD class="labelmedium">Project:</TD> --->
		<TD class="labelmedium">WBSe:</TD>
		<TD><SELECT class="regularxl" name="Crit5_Operator" id="Crit5_Operator">
			
				<OPTION value="CONTAINS">contains
				<OPTION value="BEGINS_WITH">begins with
				<OPTION value="ENDS_WITH">ends with
				<OPTION value="EQUAL">is
				<OPTION value="NOT_EQUAL">is not
				<OPTION value="SMALLER_THAN">before
				<OPTION value="GREATER_THAN">after
			
			</SELECT>
		</TD>
		<TD>
	
	    <INPUT type="text" class="regularxl" name="Crit5_Value" id="Crit5_Value" size="30">
		
		</TD>
		</TR>	
				
		<!--- Field: ProgramCode=CHAR;100;FALSE --->
		<INPUT type="hidden" name="Crit6_FieldName" id="Crit6_FieldName" value="ProgramCode">
		
		<INPUT type="hidden" name="Crit6_FieldType" id="Crit6_FieldType" value="CHAR">
		<TR>
		<!--- <TD class="labelmedium">Program:</TD> --->
		<TD class="labelmedium">Functional Area:</TD>
		<TD><SELECT class="regularxl" name="Crit6_Operator" id="Crit6_Operator">
			
				<OPTION value="CONTAINS">contains
				<OPTION value="BEGINS_WITH">begins with
				<OPTION value="ENDS_WITH">ends with
				<OPTION value="EQUAL">is
				<OPTION value="NOT_EQUAL">is not
				<OPTION value="SMALLER_THAN">before
				<OPTION value="GREATER_THAN">after
			
			</SELECT>
		</TD>
		<TD>
	
	    <INPUT type="text" class="regularxl" name="Crit6_Value" id="Crit6_Value" size="30">
		
		</TD>
		</TR>	
				
		
		<!--- Field: ObjectCode=CHAR;100;FALSE --->
		<INPUT type="hidden" name="Crit7_FieldName" id="Crit7_FieldName" value="ObjectCode">
		
		<INPUT type="hidden" name="Crit7_FieldType" id="Crit7_FieldType" value="CHAR">
		<TR>
		<!--- <TD class="labelmedium">Object:</TD> --->
		<TD class="labelmedium">Sponsored Class:</TD>
		<TD><SELECT class="regularxl" name="Crit7_Operator" id="Crit7_Operator">
			
				<OPTION value="CONTAINS">contains
				<OPTION value="BEGINS_WITH">begins with
				<OPTION value="ENDS_WITH">ends with
				<OPTION value="EQUAL">is
				<OPTION value="NOT_EQUAL">is not
				<OPTION value="SMALLER_THAN">before
				<OPTION value="GREATER_THAN">after
			
			</SELECT>
		</TD>
		<TD>
	
	    <INPUT type="text" class="regularxl" name="Crit7_Value" id="Crit7_Value" size="30">
		
		</TD>
		</TR>	
		
		<INPUT type="hidden" name="Crit9_FieldName" id="Crit9_FieldName" value="CBGrant">
		
		<INPUT type="hidden" name="Crit9_FieldType" id="Crit9_FieldType" value="CHAR">
		<TR>
		<TD class="labelmedium">Grant:</TD>
		<TD><SELECT class="regularxl" name="Crit9_Operator" id="Crit9_Operator">
			
				<OPTION value="CONTAINS">contains
				<OPTION value="BEGINS_WITH">begins with
				<OPTION value="ENDS_WITH">ends with
				<OPTION value="EQUAL">is
				<OPTION value="NOT_EQUAL">is not
				<OPTION value="SMALLER_THAN">before
				<OPTION value="GREATER_THAN">after
			
			</SELECT>
		</TD>
		<TD>
		
		<INPUT type="text" class="regularxl" name="Crit9_Value" id="Crit9_Value" size="30">
		
		</TD>
		</TR>			
				
		
		<!--- Field: GLAccount=CHAR;100;FALSE --->
		<INPUT type="hidden" name="Crit8_FieldName" id="Crit8_FieldName" value="GLAccount">
		
		<INPUT type="hidden" name="Crit8_FieldType" id="Crit8_FieldType" value="CHAR">
		<TR>
		<TD class="labelmedium">GLAccount:</TD>
		<TD><SELECT class="regularxl" name="Crit8_Operator" id="Crit8_Operator">
			
				<OPTION value="CONTAINS">contains
				<OPTION value="BEGINS_WITH">begins with
				<OPTION value="ENDS_WITH">ends with
				<OPTION value="EQUAL">is
				<OPTION value="NOT_EQUAL">is not
				<OPTION value="SMALLER_THAN">before
				<OPTION value="GREATER_THAN">after
			
			</SELECT>
		</TD>
		<TD>
		
		<select name="Crit8_Value" id="Crit8_Value" class="regularxl">
			<option value=""></option>
			<cfoutput query="lookupGLAccount">
			  <option value="#lookupGLAccount.glAccount#">#lookupGLAccount.glAccount# - #lookupGLAccount.description#</option>
		  	</cfoutput>
		</select>
		
		</TD>
		</TR>	
				
	</table>	
	
	</TD>
</TR>

<tr><td height="1" class="line"></td></tr>	

<tr>
	<td height="19" align="center">
	<input class="button10s" style="width:130px" type="submit" name"Search" id="Search" value="Search">
	</td>
</tr>

</cfform>

<tr><td height="1" class="line"></td></tr>
	
</TABLE>
