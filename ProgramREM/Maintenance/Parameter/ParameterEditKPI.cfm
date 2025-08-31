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
<cfajaximport tags="cfform">

<cfquery name="Get" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_ParameterMission
		WHERE Mission = '#URL.Mission#' 
</cfquery>

<cfoutput query="get">

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<tr><td height="12"></td></tr>		
	
		<script language="JavaScript">
		
		   function kpi(sh,box) {
		   
			   se = document.getElementById(box)		  
			   if (sh == "1") {			   
			      ColdFusion.Layout.showTab('modules','kpi')
			   } else { 			      
			      ColdFusion.Layout.hideTab('modules','kpi')
  			   }			   
		   }
		   	
		</script>
		
		<cfform method="POST" name="parameterkpi" action="ParameterSubmitKPI.cfm?idmenu=#URL.Idmenu#&mission=#URL.mission#">
			  
		<tr id="targetcolor">
		
		<td></td>
	    <td colspan="3">
		<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
			<TR>
	   		<td width="150" style="cursor: pointer;">
			<cf_UIToolTip  tooltip="If workflow is enabled, the option to enter progress reports per indicator <br> will be limited through workflow processing only">
			Indicator Audit Workflow:
			</cf_UIToolTip>
			</b></td>
		    <TD colspan="3">
				<input type="radio" name="IndicatorAuditWorkflow" value="1" <cfif IndicatorAuditWorkflow eq "1">checked</cfif>>Enabled
				<input type="radio" name="IndicatorAuditWorkflow" value="0" <cfif IndicatorAuditWorkflow eq "0">checked</cfif>>Disabled
		    </TD>
			</TR>	
			<tr>
			<td style="cursor: pointer;">
			<cf_UIToolTip  tooltip="Target description for graphs">
			Target Label:
			</cf_UIToolTip>
			</b></td>
		    <TD colspan="3">
				<cfinput class="regular" type="Text" name="IndicatorLabelTarget" value="#IndicatorLabelTarget#" message="Please enter a label for the indicator" required="Yes" size="10" maxlength="15">
		    </TD>
			<td style="cursor: pointer;">
			<cf_UIToolTip  tooltip="Default target line color">
			Graph Color
			</cf_UIToolTip>
			</td>
			<TD colspan="1">
				<cfinput class="regular" type="Text" name="ProgramColorTarget" value="#ProgramColorTarget#" message="Please enter a color" required="Yes" size="20" maxlength="20">
		    </TD>
			</tr>
			<tr>
			<td style="cursor: pointer;">
			<cf_UIToolTip  tooltip="Manual entry description for graphs">
			Manually recorded Progress Label:</b>
			</cf_UIToolTip>
			</td>
		    <TD colspan="3">
				<cfinput class="regular" type="Text" name="IndicatorLabelManual" value="#IndicatorLabelManual#" message="Please enter a label for the indicator" required="Yes" size="10" maxlength="15">
		    </TD>
			<td style="cursor: pointer;">
			<cf_UIToolTip  tooltip="Default manual entry line color">
			Graph Color
			</cf_UIToolTip>
			</td>
			<TD>
				<cfinput class="regular" type="Text" name="ProgramColorActual" value="#ProgramColorActual#" message="Please enter a color" required="Yes" size="20" maxlength="20">
		    </TD>
			</tr>
			<tr>
			<td>Indicator OLAP Analysis Template:</b></td>
		    <TD colspan="3">
				<cfinput class="regular" type="Text" name="IndicatorOLAPTemplate" value="#IndicatorOLAPTemplate#" message="Please enter a label for the indicator" size="25" maxlength="80">
		    </TD>
			</tr>			
						
			
		</table>
		</td>
				
		</tr>
		
		<tr><td height="10"></td></tr>	
		<tr><td height="1" colspan="4"  class="line"></td></tr>	
						
		<tr><td height="40" colspan="4" align="center">	
			<input type="Submit" name="Save" value="Update" class="button10g">
		</td></tr>
		
		</cfform>
	
	</table>
	
</cfoutput>	