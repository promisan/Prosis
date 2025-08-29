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
<cfparam name="URL.ID1" default="">

<cfquery name="Get" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	Ref_ParameterMission
	WHERE	Mission = <cfif url.id1 eq "">'#MissionList.Mission#'<cfelse>'#URL.ID1#'</cfif>
</cfquery>

<cfoutput query="get">

<cfform method="POST" name="formmiscell" action="ParameterEditMiscellaneousSubmit.cfm" target="processParameterEditMiscellaneousSubmit">

<table width="95%" border="0" class="formpadding" cellspacing="0" cellpadding="0" align="center">
	
	<tr class="hide"><td><iframe name="processParameterEditMiscellaneousSubmit" id="processParameterEditMiscellaneousSubmit" frameborder="0"></iframe></td></tr>
	
	<input name="mission" id="mission" type="Hidden" value="#mission#">
	<tr><td height="5"></td></tr>					
	
	<TR>
    <td class="labelmedium" style="width:25%">Customer Detail *:</b></td>
    <TD class="labelmedium" style="height:25px">	
		<table>
		<tr>
		<td><input type="radio" class="radiol" name="customerDetail" id="customerDetail" <cfif customerDetail eq "1">checked</cfif> value="1"></td>
		<td style="padding-left:4px" class="labelmedium">Yes</td>
		<td style="padding-left:10px"><input class="radiol" type="radio" name="customerDetail" id="customerDetail" <cfif customerDetail eq "0">checked</cfif> value="0"></td>
		<td style="padding-left:4px" class="labelmedium">No</td>
		</tr>
		</table>
    </td>
    </tr>	
	
	<TR>
		<td class="labelmedium">Charges Calculation Date *:&nbsp;</td>
		<td>
		<cf_intelliCalendarDate9
			FieldName="dateChargesCalculate"
			class="regularxl"
			Message="Select a valid Charges Calculation Date"
			Default="#dateformat(get.dateChargesCalculate, CLIENT.DateFormatShow)#"
			AllowBlank="False">					 						 					 
       </td>
	</TR>
	
	<TR>
		<td class="labelmedium">Posting Start Date *:&nbsp;</td>
		<td>		    
		<cf_intelliCalendarDate9
			FieldName="datePostingStart" 
			class="regularxl"
			Message="Select a valid Posting Start Date"
			Default="#dateformat(get.datePostingStart, CLIENT.DateFormatShow)#"
			AllowBlank="False">					 						 					 
       </td>
	</TR>
	
	<TR>
		<td class="labelmedium">Posting Calculation Date *:&nbsp;</td>
		<td>		    
		<cf_intelliCalendarDate9
			FieldName="datePostingCalculate" 
			class="regularxl"
			Message="Select a valid Posting Calculation Date"
			Default="#dateformat(get.datePostingCalculate, CLIENT.DateFormatShow)#"
			AllowBlank="False">					 						 					 
       </td>
	</TR>
	
	<TR>
    <td class="labelmedium">Posting Mode:</b></td>
    <TD>		
		<cfinput type="Text" name="postingMode" value="#postingMode#" required="No" maxlength="10" style="width:65px" class="regularxl">
	</td>
    </tr>
	
	<TR>
    <td class="labelmedium">Document Host:</b></td>
    <TD>		
		<cfinput type="Text" name="documentHost" value="#documentHost#" required="No" maxlength="50" style="width:165px" class="regularxl">
	   </td>
    </tr>
	
	<TR>
    <td class="labelmedium">Document Library:</b></td>
    <TD>		
		<cfinput type="Text" name="documentLibrary" value="#documentLibrary#" required="No" maxlength="50" style="width:165px" class="regularxl">
	   </td>
    </tr>
	
	<TR>
    <td class="labelmedium" width="15%">Tree Customer:</b></td>
    <TD width="85%">
		<cfquery name="GetMission" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM 	Ref_Mission
			WHERE	MissionStatus = 1
		</cfquery>
		<select name="treeCustomer" id="treeCustomer" class="regularxl">
			<option value="">
			<cfloop query="GetMission">
				<option value="#mission#"<cfif get.treeCustomer eq mission>selected</cfif>>#mission# - #MissionName#
			</cfloop>
		</select>
	   </td>
    </tr>	
		
	<tr><td height="5"></td></tr>
	
	<tr><td colspan="2" class="line" ></td></tr>
	
	<tr><td height="5"></td></tr>
	
	<tr><td colspan="2" align="center">
	
	<cfinput type="Submit" 
	       class="button10g" 
		   style="width:140"
		   value="Save"
	       name="Update" 
		   onclick="if (confirm('Changing this parameters will affect the functioning of the system, do you want to continue ?')) { return true } return false">
	</td></tr>
	
	<tr><td height="5"></td></tr>	
			
	</table>
	
   </CFFORM>
	
</cfoutput>	

<cfset ajaxonload("doCalendar")>