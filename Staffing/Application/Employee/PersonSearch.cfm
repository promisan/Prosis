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

<cf_screentop height="100%" jquery="Yes"
     scroll="Vertical" menuAccess="Yes" systemfunctionid="#url.idmenu#"
	 html="No" title="Employee Inquiry">
	
<cfquery name="Nation" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   CODE, NAME 
    FROM     Ref_Nation
	WHERE    NAME > 'A'
	AND      Code IN (SELECT DISTINCT Nationality FROM Employee.dbo.Person)
	ORDER BY NAME
</cfquery>

<br><br>
<!--- Search form --->
<FORM action="PersonSearchQuery.cfm?height=<cfoutput>600</cfoutput>" method="post">

<cf_tl id="contains" var="1">
<cfset vcontains=#lt_text#>
<cf_tl id="begins with" var="1">
<cfset vbegins=#lt_text#>
<cf_tl id="ends with" var="1">
<cfset vends=#lt_text#>
<cf_tl id="is" var="1">
<cfset vis=#lt_text#>
<cf_tl id="is not" var="1">
<cfset visnot=#lt_text#>
<cf_tl id="before" var="1">
<cfset vbefore=#lt_text#>
<cf_tl id="after" var="1">
<cfset vafter=#lt_text#>
  
  
<table width="80%" align="center">

	<tr>
	<td colspan="2">
		<table width="100%">
			
		    <tr>
			    <td height="25" width="90%" style="font-size:26px" class="labellarge">
				<cf_tl id="SearchBy" class="Message">:
				</td>
				<cf_tl id="Reset" var="1">
				<cfset vReset=#lt_text#>
				<cf_tl id="Submit" var="1">
				<cfset vSubmit=#lt_text#>
				<!---
				<td align="right" class="top4n">
				<cf_tl id="Reset" var="1">
				
				<cfoutput>
				<input class="button10g" type="reset"  value="#vReset#">
				</cfoutput>
				</td>
				<td width="100"  class="top4n">				
				<cfset vSubmit=#lt_text#>
				<cfoutput>
			    <input class="button10g" type="submit" value=" #vSubmit# ">
				</cfoutput>
				</td>
				--->
			</tr> 	
			
			<tr><td colspan="1" class="linedotted"></td></tr>
		 
		</table>
	
	</td>
	</tr>
	
	</tr>

    <tr><td height="5" colspan="1" class="regular"></td></tr>

    <!--- Field: Status=CHAR;40;FALSE --->
	<INPUT type="hidden" name="Crit5_FieldName" value="PersonStatus">	
	<INPUT type="hidden" name="Crit5_FieldType" value="CHAR">
	<INPUT type="hidden" name="Crit5_Operator" value="CONTAINS">
		<TR>
	<TD class="labelmedium"><cf_tl id="Status">:</TD>
	
	<TD class="labelmedium">
	
	<input type="radio" class="radiol" name="Crit5_Value" value="0"><cf_tl id="Pending">
    <input type="radio" class="radiol" name="Crit5_Value" value="1"><cf_tl id="Confirmed">
	<input type="radio" class="radiol" name="Crit5_Value" value="" checked><cf_tl id="Both">
   
	</TD>
	</TR>
	
	 <tr><td height="5" colspan="1"></td></tr>
	
	<!--- Field: Staff.IndexNo=CHAR;20;TRUE --->
	<INPUT type="hidden" name="Crit0_FieldName" value="PersonNo">
	<INPUT type="hidden" name="Crit0_FieldType" value="CHAR">
	<TR>
	<TD class="labelmedium"><cf_tl id="Person No"></TD>
	
	<TD><SELECT name="Crit0_Operator" class="regularxl">
		
			<OPTION value="CONTAINS"><cfoutput>#vcontains#</cfoutput>
			<OPTION value="BEGINS_WITH"><cfoutput>#vbegins#</cfoutput>
			<OPTION value="ENDS_WITH"><cfoutput>#vends#</cfoutput>
			<OPTION value="EQUAL"><cfoutput>#vis#</cfoutput>
			<OPTION value="NOT_EQUAL"><cfoutput>#visnot#</cfoutput>
			<OPTION value="SMALLER_THAN"><cfoutput>#vbefore#</cfoutput>
			<OPTION value="GREATER_THAN"><cfoutput>#vafter#</cfoutput>
		
		</SELECT>
		
	<INPUT type="text" class="regularxl" name="Crit0_Value" size="20">
	
	</TD>
	</TR>
		
    <tr><td height="5" colspan="1"></td></tr>
	
	<!--- Field: Staff.IndexNo=CHAR;20;TRUE --->
	<INPUT type="hidden" name="Crit1_FieldName" value="IndexNo">
	<INPUT type="hidden" name="Crit1_FieldType" value="CHAR">
	<TR>
	<TD class="labelmedium"><cfoutput>#client.IndexNoName#</cfoutput></b>
    </TD>
	<TD class="labelmedium"><SELECT class="regularxl" name="Crit1_Operator">
		
			<OPTION value="CONTAINS"><cfoutput>#vcontains#</cfoutput>
			<OPTION value="BEGINS_WITH"><cfoutput>#vbegins#</cfoutput>
			<OPTION value="ENDS_WITH"><cfoutput>#vends#</cfoutput>
			<OPTION value="EQUAL"><cfoutput>#vis#</cfoutput>
			<OPTION value="NOT_EQUAL"><cfoutput>#visnot#</cfoutput>
			<OPTION value="SMALLER_THAN"><cfoutput>#vbefore#</cfoutput>
			<OPTION value="GREATER_THAN"><cfoutput>#vafter#</cfoutput>
		
		</SELECT>
		
	<INPUT type="text" name="Crit1_Value" class="regularxl" size="20">
	
	</TD>
	</TR>
	
	<tr><td height="3" colspan="1"></td></tr>
	
	<INPUT type="hidden" name="Crit1a_FieldName" value="Reference">	
		<INPUT type="hidden" name="Crit1a_FieldType" value="CHAR">
		<TR>
		<TD class="labelmedium"><cf_tl id="ExternalReference">:</TD>
		<TD><SELECT name="Crit1a_Operator" class="regularxl">
				
					<OPTION value="CONTAINS"><cfoutput>#vcontains#</cfoutput>
					<OPTION value="BEGINS_WITH"><cfoutput>#vbegins#</cfoutput>
					<OPTION value="ENDS_WITH"><cfoutput>#vends#</cfoutput>
					<OPTION value="EQUAL"><cfoutput>#vis#</cfoutput>
									
				</SELECT>
				
				<INPUT type="text" name="Crit1a_Value" size="20" class="regularxl">
				
		</TD>
				
		</TR>	     
	
	
	<tr><td height="5" colspan="1"></td></tr>

	<!--- Field: Staff.FirstName=CHAR;40;FALSE --->
	<INPUT type="hidden" name="Crit3b_FieldName" value="FullName">
	
	<INPUT type="hidden" name="Crit3b_FieldType" value="CHAR">
	<TR>
	<TD class="labelmedium">Full name:</b></TD>
	<TD><select name="Crit3b_Operator" class="regularxl">
		
			<OPTION value="CONTAINS"><cfoutput>#vcontains#</cfoutput>
			<OPTION value="BEGINS_WITH"><cfoutput>#vbegins#</cfoutput>
			<OPTION value="ENDS_WITH"><cfoutput>#vends#</cfoutput>
			<OPTION value="EQUAL"><cfoutput>#vis#</cfoutput>
			<OPTION value="NOT_EQUAL"><cfoutput>#visnot#</cfoutput>
			<OPTION value="SMALLER_THAN"><cfoutput>#vbefore#</cfoutput>
			<OPTION value="GREATER_THAN"><cfoutput>#vafter#</cfoutput>
		
		</SELECT>
		
	<INPUT type="text" name="Crit3b_Value" size="20" class="regularxl">
	
	</TD>
	</TR>
	
	<tr><td height="5" colspan="1"></td></tr>

	<!--- Field: Staff.LastName=CHAR;40;FALSE --->
	<INPUT type="hidden" name="Crit2_FieldName" value="LastName">
	
	<INPUT type="hidden" name="Crit2_FieldType" value="CHAR">
	<TR>
	<TD class="labelmedium"><cf_tl id="Last name">:</TD>
	<TD><SELECT name="Crit2_Operator" class="regularxl">
		
			<OPTION value="CONTAINS"><cfoutput>#vcontains#</cfoutput>
			<OPTION value="BEGINS_WITH"><cfoutput>#vbegins#</cfoutput>
			<OPTION value="ENDS_WITH"><cfoutput>#vends#</cfoutput>
			<OPTION value="EQUAL"><cfoutput>#vis#</cfoutput>
			<OPTION value="NOT_EQUAL"><cfoutput>#visnot#</cfoutput>
			<OPTION value="SMALLER_THAN"><cfoutput>#vbefore#</cfoutput>
			<OPTION value="GREATER_THAN"><cfoutput>#vafter#</cfoutput>
		
		</SELECT>
		
	<INPUT type="text" name="Crit2_Value" size="20" class="regularxl">
	
	</TD>
	</TR>
	
	<tr><td height="5" colspan="1"></td></tr>

	<!--- Field: Staff.FirstName=CHAR;40;FALSE --->
	<INPUT type="hidden" name="Crit3_FieldName" value="FirstName">
	
	<INPUT type="hidden" name="Crit3_FieldType" value="CHAR">
	<TR>
	<TD class="labelmedium"><cf_tl id="First name">:</b>
    </TD>
	<TD><select name="Crit3_Operator" class="regularxl">
		
			<OPTION value="CONTAINS"><cfoutput>#vcontains#</cfoutput>
			<OPTION value="BEGINS_WITH"><cfoutput>#vbegins#</cfoutput>
			<OPTION value="ENDS_WITH"><cfoutput>#vends#</cfoutput>
			<OPTION value="EQUAL"><cfoutput>#vis#</cfoutput>
			<OPTION value="NOT_EQUAL"><cfoutput>#visnot#</cfoutput>
			<OPTION value="SMALLER_THAN"><cfoutput>#vbefore#</cfoutput>
			<OPTION value="GREATER_THAN"><cfoutput>#vafter#</cfoutput>
		
		</SELECT>
		
	<INPUT type="text" name="Crit3_Value" size="20" class="regularxl">
	
	</TD>
	</TR>
	
	<tr><td height="5" colspan="1"></td></tr>

	<!--- Field: Staff.FirstName=CHAR;40;FALSE --->
	<INPUT type="hidden" name="Crit3a_FieldName" value="MiddleName">
	
	<INPUT type="hidden" name="Crit3a_FieldType" value="CHAR">
	<TR>
	<TD class="labelmedium">Middle name:</b></TD>
	<TD><select name="Crit3a_Operator" class="regularxl">
		
			<OPTION value="CONTAINS"><cfoutput>#vcontains#</cfoutput>
			<OPTION value="BEGINS_WITH"><cfoutput>#vbegins#</cfoutput>
			<OPTION value="ENDS_WITH"><cfoutput>#vends#</cfoutput>
			<OPTION value="EQUAL"><cfoutput>#vis#</cfoutput>
			<OPTION value="NOT_EQUAL"><cfoutput>#visnot#</cfoutput>
			<OPTION value="SMALLER_THAN"><cfoutput>#vbefore#</cfoutput>
			<OPTION value="GREATER_THAN"><cfoutput>#vafter#</cfoutput>
		
		</SELECT>
		
	<INPUT type="text" name="Crit3a_Value" size="20" class="regularxl">
	
	</TD>
	</TR>
	
	<tr><td height="5" colspan="1"></td></tr>
		
	<cfquery name="Status" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM Ref_PersonStatus
		ORDER BY Code DESC
	</cfquery>
			
	<!--- Field: Staff.Nationality=CHAR;40;FALSE --->
	<TR>
	<TD class="labelmedium">Class:</b>
	
	</TD>
	
	<TD><select name="PersonStatus" size="2" class="regularxl">
	<option value="" selected>All</option>
	    <cfoutput query="Status">
		
		<option value="#Code#">
		#Description# only
		</option>
		</cfoutput>
	    </select>
		
	</TD>
	</TR>
			
	<tr><td height="5" colspan="1"></td></tr>

   <!--- Field: Staff.Gender=CHAR;40;FALSE --->
	<INPUT type="hidden" name="Crit4_FieldName" value="Gender">
	
	<INPUT type="hidden" name="Crit4_FieldType" value="CHAR">
	<INPUT type="hidden" name="Crit4_Operator" value="CONTAINS">
		<TR>
	<TD class="labelmedium"><cf_tl id="Gender">:</b></TD>
	
	<TD class="labelmedium">
	
	<input type="radio" class="radiol" name="Crit4_Value" value="M">Male
    <input type="radio" class="radiol" name="Crit4_Value" value="F">Female
	<input type="radio" class="radiol" name="Crit4_Value" value="" checked>Both
   
	</TD>
	</TR>
	
	<tr><td height="5" colspan="1"></td></tr>
	
	<TR>
		<TD class="labelmedium" valign="top" style="padding-top:4px"><cf_tl id="Nationality">:</TD>
		
		<TD>
		
		<cf_UIselect name = "Nationality"					
					size           = "1"
					class          = "regularXXL"
					id             = "Nationality"		
					multiple       = "Yes"													
					style          = "width:100%"											
					query          = "#Nation#"
					queryPosition  = "below"
					value          = "Code"
					display        = "Name"/>
		
		<!---
	    	<select name="Nationality" id="Nationality" size="10" multiple disabled class="regularxl" style="height:150px;min-width:200">
			    <cfoutput query="Nation">		
				<option value="'#Code#'"selected>#Name#</option>
				</cfoutput>
		    </select>
			--->
			
		</TD>
		</TR>
			
	
	<tr><td height="5" colspan="1"></td></tr>
	
	<tr><td class="line" colspan="2"></td></tr>
		
	<tr>
    <td colspan="2" style="height:30">
	 <cfoutput>
	 <input type="submit" name="Submit" value="#vSubmit#" class="button10g" style="width:130;height:23">
	 </cfoutput>
	</td>
	
	 </tr> 	
 
</TABLE>	

</FORM>
