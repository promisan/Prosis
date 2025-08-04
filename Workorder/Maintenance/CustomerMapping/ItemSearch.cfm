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


<cfset Page         = "0">
<cfset add          = "0">
<cfinclude template = "../HeaderMaintain.cfm"> 

<cfform action="ItemSearchQuery.cfm?idmenu=#url.idmenu#" method="post">

<table width="99%" border="0" cellspacing="2" cellpadding="2" align="center" >

<tr><td align="center">

	<table width="50%" border="0" cellspacing="1" cellpadding="1" align="center" class="formpadding formspacing">
 
	<!--- Field: FundingType=CHAR;100;FALSE --->
	<INPUT type="hidden" name="Crit1_FieldName" id="Crit1_FieldName" value="Mission">	
	<INPUT type="hidden" name="Crit1_FieldType" id="Crit1_FieldType" value="CHAR">
	<TR>
	<TD class="labelmedium" width="30%">Mission</TD>
	<TD>
		<INPUT type="hidden" name="Crit1_Operator" id="Crit1_Operator" value="EQUAL">
		<cfquery name="lookup" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT	*
		  	FROM 	Ref_ParameterMission
		</cfquery>

		<cfoutput><select name="Crit1_Value" class="regularxl" onchange="javascript: ColdFusion.navigate('ItemSearch_Customer.cfm?mission='+this.value,'customerContainer');"></cfoutput>
			<option value="">- All -</option>
			<cfoutput query="lookup">
			  <option value="#lookup.Mission#">#lookup.Mission#</option>
		  	</cfoutput>
		</select>
	</TD>	
	</TR>	
	
	<!--- Field: Period=CHAR;100;FALSE --->
	<INPUT type="hidden" name="Crit2_FieldName" id="Crit2_FieldName" value="CustomerId">	
	<INPUT type="hidden" name="Crit2_FieldType" id="Crit2_FieldType" value="CHAR">
	<INPUT type="hidden" name="Crit2_Operator" id="Crit2_Operator" value="EQUAL">
	<TR>
	<TD class="labelmedium">Customer</TD>
	<TD>		
		<cfdiv id="customerContainer" bind="url:ItemSearch_Customer.cfm?mission=">
	</TD>
	</TR>	
	
	<!--- Field: FundingType=CHAR;100;FALSE --->
	<INPUT type="hidden" name="Crit6_FieldName" id="Crit6_FieldName" value="MappingCode">
	
	<INPUT type="hidden" name="Crit6_FieldType" id="Crit6_FieldType" value="CHAR">
	<TR>
	<TD class="labelmedium">Mapping Code</TD>
	<TD><SELECT name="Crit6_Operator" id="Crit6_Operator" class="regularxl">
		
			<OPTION value="CONTAINS">contains
			<OPTION value="BEGINS_WITH">begins with
			<OPTION value="ENDS_WITH">ends with
			<OPTION value="EQUAL">is
			<OPTION value="NOT_EQUAL">is not
			<OPTION value="SMALLER_THAN">before
			<OPTION value="GREATER_THAN">after
		
		</SELECT>
		
		<INPUT type="text" name="Crit6_Value" id="Crit6_Value" size="20" class="regularxl">
	</TD>	
	</TR>	
	

	<!--- Field: OrgUnitCode=CHAR;100;FALSE --->
	<INPUT type="hidden" name="Crit5_FieldName" id="Crit5_FieldName" value="nullCustomers">
	
	<INPUT type="hidden" name="Crit5_FieldType" id="Crit5_FieldType" value="CHAR">
	<TR>
	<TD class="labelmedium">Customer assigned</TD>	
	<TD class="labelmedium">
		<input type="radio" name="Crit5_Value" id="Crit5_Value" value="0" checked>No
		<input type="radio" name="Crit5_Value" id="Crit5_Value" value="1">Yes			
	</TD>
	</TR>	
	
	<tr valign="top"><td height="19"></td></tr>
	<!--- ---------------------------- --->	

</table>	

</TD></TR>	

<tr valign="top"><td height="19" align="center">

<input class="button10g" type="submit" name"Search" id="Search" value="Submit">

</td></tr>


<tr valign="top"><td class="line" height="1"></td></tr>
	
</TABLE>

</cfform>