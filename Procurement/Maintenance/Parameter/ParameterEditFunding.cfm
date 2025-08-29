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
<cfquery name="Get" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_ParameterMission
	WHERE Mission = '#URL.Mission#' 
</cfquery>

<cfform action="ParameterSubmitFunding.cfm?mission=#URL.mission#"
        method="POST" 
		target="process"
        name="request">	
		
<cfoutput query="Get">

<table width="97%" class="formpadding formspacing" align="center">
		
	<tr><td height="8"></td></tr>
	<tr class="line"><td colspan="2" class="labellarge" style="font-weight:200;height:40px;font-size:25px"><cf_tl id="Requisition Funding Settings"></td></tr>
			
	<cfquery name="Period" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_MissionPeriod
		WHERE  Mission = '#URL.Mission#' 
	</cfquery>
		
	<TR>
    <td style="padding-left:10px" class="labelmedium" width="180">Default Period:</b></td>
    <TD width="70%"><select name="defaultperiod" id="defaultperiod" class="regularxl">
	    <cfloop query="Period">
		<option value="#Period#" <cfif period eq get.Defaultperiod>selected</cfif>>#Period#</option>
		</cfloop>
	    </select>
		<cfif Period.recordcount eq "0">
		<font color="FF0000">&nbsp; Please check entity : Program Management / Maintenance / Planning Period</font>
		</cfif>
  	</TD>
	</TR>
			
	<TR>
    <td style="padding-left:10px;padding-top:4px" VALIGN="TOP" class="labelmedium">Funding Entry:</td>
    <TD>
	
		<table cellspacing="0" cellpadding="0" class="formpadding">
		<tr><td class="labelmedium">
		<input type="radio" class="radiol" name="FundingByReviewer" id="FundingByReviewer" <cfif FundingByReviewer eq "1">checked</cfif> value="1"></td><td style="padding-left:4px" class="labelmedium">Any actor prior to Obligation (Purchase Order)
		</td></tr>
		<tr><td class="labelmedium">
		<input type="radio" class="radiol" name="FundingByReviewer" id="FundingByReviewer" <cfif FundingByReviewer eq "1e">checked</cfif> value="1e"></td><td style="padding-left:4px"  class="labelmedium">As above but validate after Requisition Review (Funder, Certifier, Supervisor) 
		</td></tr>
		<tr><td class="labelmedium">
		<input type="radio" class="radiol" name="FundingByReviewer" id="FundingByReviewer" <cfif FundingByReviewer eq "2">checked</cfif> value="2"></td><td style="padding-left:4px"  class="labelmedium">Any actor after Requisition Review (Funder, Certifier, Supervisor) 
		</td></tr>
		<tr><td class="labelmedium">
		<input type="radio" class="radiol" name="FundingByReviewer" id="FundingByReviewer" <cfif FundingByReviewer eq "0">checked</cfif> value="0"></td><td style="padding-left:4px"  class="labelmedium">Only Requisitioner	
		</td>
		</tr>
		</table>
	
    </td>
    </tr>	
				
	<TR>
    <td style="padding-left:10px" class="labelmedium">Funding Selection:</b></td>
    <TD>
	
	<table cellspacing="0" cellpadding="0" class="formpadding">
	<tr>
	<td><input type="radio" class="radiol" onclick="funddialog('show')" name="EnforceProgramBudget" id="EnforceProgramBudget" <cfif EnforceProgramBudget eq "1">checked</cfif> value="1"></td>
	<td class="labelmedium" style="padding-left:4px">Allotment Edition in Program Management / Maintenance / Planning Period </td>	
	<td style="padding-left:9px"><input type="radio" class="radiol" onclick="funddialog('hide')" name="EnforceProgramBudget" id="EnforceProgramBudget" <cfif EnforceProgramBudget eq "0">checked</cfif> value="0"></td>
	<td style="padding-left:4px" class="labelmedium">Manual</td>
	</tr>
	</table>
	
    </td>
    </tr>
			
	<TR>
    <td style="padding-left:10px" width="200" class="labelmedium">Allow entry of additional funding info:</td>
    <TD>
	<table cellspacing="0" cellpadding="0" class="formpadding">
			<tr>
				<td><input class="radiol" type="radio" name="FundingDetail" id="FundingDetail" <cfif FundingDetail eq "1">checked</cfif> value="1"></td>
				<td style="padding-left:4px" class="labelmedium">Yes</td>
				<td style="padding-left:4px"><input class="radiol" type="radio" name="FundingDetail" id="FundingDetail" <cfif FundingDetail eq "0">checked</cfif> value="0"></td>
				<td style="padding-left:4px" class="labelmedium">No</td>
			</tr>
	</table>			
    </td>
    </tr>
			
	<cfif EnforceProgramBudget eq "0">
		 <cfset cl  = "hide">	
		 <cfset cla  = "regular">	
	<cfelse>
		 <cfset cl  = "regular"> 
		 <cfset cla = "hide">		 
	</cfif>
	
	<cfquery name="Usage" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_ObjectUsage	
	</cfquery>
	
	<TR id="funddialog7" class="regular">
    <td style="padding-left:10px" class="labelmedium">Object Usage:</td>
    <TD height="20" class="labelmedium">
	<table><tr>
	<cfloop query="Usage">
		<td><input class="radiol" type="radio" type="radio" name="ObjectUsage" id="ObjectUsage" <cfif Code eq get.ObjectUsage>checked</cfif> value="#code#"></td><td class="labelmedium" style="padding-left:4px;padding-right:5px;">#Code#</td>
	</cfloop>
	</tr>
	</table>
	</td>
    </tr>
	
	<TR id="funddialog0" class="#cl#">
    <td style="padding-left:10px" class="labelmedium">Fund Selection Mode:</td>
    <TD>
	<table cellspacing="0" cellpadding="0" class="formpadding"><tr>
	<td class="labelmedium">
	<input class="radiol" type="radio" name="FundingOnProgram" id="FundingOnProgram" <cfif FundingOnProgram eq "1">checked</cfif> value="1"></td>
	<td style="padding-left:4px" class="labelmedium">List ONLY allotted programs/projects<br></td><td>
	<input type="radio" class="radiol" name="FundingOnProgram" id="FundingOnProgram" <cfif FundingOnProgram eq "0">checked</cfif> value="0"></td>
	<td style="padding-left:4px" class="labelmedium">List ALL programs/projects
	</td></tr>
	</table>
    </td>
    </tr>	
	
	<tr class="line"><td colspan="2" valign="bottom" style="font-weight:200;padding-bottom:4px;height:50px;font-size:25px" class="labellarge">Fund Sufficiency and Validation Settings</td></tr>
				
	<TR id="funddialog1" class="#cl#">
    <td style="height:30px;padding-left:10px" class="labelmedium">Enable Validation:</td>
    <TD>
		<table cellspacing="0" cellpadding="0">
			<tr>
				<td><input class="radiol" type="radio" onclick="fundingvalidation()" name="EnableFundingCheck" id="EnableFundingCheck" <cfif EnableFundingCheck eq "1">checked</cfif> value="1"></td>
				<td style="padding-left:4px" class="labelmedium">Yes</td>
				<td style="padding-left:9px"><input class="radiol" type="radio" onclick="fundingvalidation()" name="EnableFundingCheck" id="EnableFundingCheck" <cfif EnableFundingCheck eq "0">checked</cfif> value="0">
				</td>
				<td style="padding-left:4px" class="labelmedium">No</td>
				<td style="width:40"></td>
				<td class="labelmedium" width="60">Tolerance:</td>			    
				<td><input class="regularxl" type="text" style="width:50px;text-align:right" name="FundingCheckTolerance" <cfif EnableFundingCheck eq "0">disabled</cfif> style="width:50" value="#FundingCheckTolerance#"></td>
				<td class="labelmedium" style="padding-left:5px">#APPLICATION.BaseCurrency#</td>
			</tr>		
	
		</table>
	</td>
	</tr>	
	
	<tr id="funddialog6" class="#cl#">	
    <td class="labelmedium" style="padding-left:20px"><cf_UIToolTip  tooltip="Considers only amounts that have been cleared">Validate against CLEARED Budget:</cf_UIToolTip></td>
	<td>
		<table cellspacing="0" cellpadding="0">
			<tr>
			    <td><input <cfif EnableFundingCheck eq "0">disabled</cfif> class="radiol" type="radio" name="FundingCheckCleared" id="FundingCheckCleared" <cfif FundingCheckCleared eq "1">checked</cfif> value="1"></td>
				<td style="padding-left:4px" class="labelmedium">Yes</td>
				<td style="padding-left:9px"><input <cfif EnableFundingCheck eq "0">disabled</cfif> class="radiol" type="radio" name="FundingCheckCleared" id="FundingCheckCleared" <cfif FundingCheckCleared eq "0">checked</cfif> value="0"></td>
				<td class="labelmedium" style="padding-left:4px">No</td>
			</tr>
		</table>
	</td>
	</tr>	
	
	<tr id="funddialog4" class="#cl#">	
    <td class="labelmedium" style="padding-left:20px"><cf_UIToolTip  tooltip="Considers all program and project alloted amounts that can be associated to the unit that raised the obligation">Validate on accumulated UNIT funds:</cf_UIToolTip></td>
	<td>
		<table cellspacing="0" cellpadding="0">
			<tr>
			    <TD><input <cfif EnableFundingCheck eq "0">disabled</cfif> class="radiol" type="radio" name="FundingClearRollup" id="FundingClearRollup" <cfif FundingClearRollup eq "1">checked</cfif> value="1"></td>
				<td style="padding-left:4px;padding-right:5px;" class="labelmedium">Yes, same unit</td>
				<TD style="padding-left:9px"><input <cfif EnableFundingCheck eq "0">disabled</cfif> class="radiol" type="radio" name="FundingClearRollup" id="FundingClearRollup" <cfif FundingClearRollup eq "2">checked</cfif> value="2"></td>
				<td style="padding-left:4px;padding-right:5px" class="labelmedium">Yes, parent unit</td>
				<td style="padding-left:9px"><input <cfif EnableFundingCheck eq "0">disabled</cfif> class="radiol" type="radio" name="FundingClearRollup" id="FundingClearRollup" <cfif FundingClearRollup eq "0">checked</cfif> value="0"></td>
				<td style="padding-left:4px" class="labelmedium">No, per project/program</td>
			</tr>
		</table>
	</td>
	</tr>	
	
	<tr id="funddialog8" class="#cl#">	
    <td class="labelmedium" style="padding-left:20px"><cf_UIToolTip  tooltip="Considers all object codes under the same resource">Validation Object Scope:</cf_UIToolTip></td>
	<td>
		<table cellspacing="0" cellpadding="0">
			<tr>
			    <td><input <cfif EnableFundingCheck eq "0">disabled</cfif> class="radiol" type="radio" name="FundingClearResource" id="FundingClearResource" <cfif FundingClearResource eq "0">checked</cfif> value="0"></td>
				<td style="padding-left:4px" class="labelmedium">Program/Object</td>
			    <TD style="padding-left:9px"><input <cfif EnableFundingCheck eq "0">disabled</cfif> class="radiol" type="radio" name="FundingClearResource" id="FundingClearResource" <cfif FundingClearResource eq "1">checked</cfif> value="1"></td>
				<td style="padding-left:4px" class="labelmedium">Program/Resource</td>
				<td style="padding-left:9px"><input <cfif EnableFundingCheck eq "0">disabled</cfif> class="radiol" type="radio" name="FundingClearResource" id="FundingClearResource" <cfif FundingClearResource eq "2">checked</cfif> value="2"></td>
				<td style="padding-left:4px" class="labelmedium">Program</td>
			</tr>
		</table>
	</td>
	</tr>	
	
	<tr id="funddialog9" class="#cl#">	
    <td style="padding-left:10px" class="labelmedium"><cf_UIToolTip  tooltip="Considers all object codes under the same resource">Transaction Scope:</cf_UIToolTip></td>
	<td>
		<table cellspacing="0" cellpadding="0">
			<tr>
			    <td><input <cfif EnableFundingCheck eq "0">disabled</cfif> class="radiol" type="radio" name="FundingClearTransaction" id="FundingClearTransaction" <cfif FundingClearTransaction eq "0">checked</cfif> value="0"></td>
				<td style="padding-left:4px" class="labelmedium">Obligation</td>
			    <TD style="padding-left:9px"><input <cfif EnableFundingCheck eq "0">disabled</cfif> class="radiol" type="radio" name="FundingClearTransaction" id="FundingClearTransaction" <cfif FundingClearTransaction eq "1">checked</cfif> value="1"></td>
				<td class="labelmedium" style="padding-left:4px">Unliquidated Obligation and Invoices</td>		
			</tr>
		</table>
	</td>
	</tr>	
			
	<tr id="funddialog5" class="#cl#">		
	   <td width="300" class="labelmedium" style="padding-left:10px">Processing after step FUNDING:</td>
	   <td>
		<table cellspacing="0" cellpadding="0">
			<tr>
			    <TD><input <cfif EnableFundingCheck eq "0">disabled</cfif> type="radio" class="radiol" name="FundingCheckPointer" id="FundingCheckPointer" <cfif FundingCheckPointer eq "1">checked</cfif> value="1"></td>
				<td style="padding-left:4px" class="labelmedium">Disable Sufficiency Check</td>
				<td style="padding-left:9px"><input <cfif EnableFundingCheck eq "0">disabled</cfif> class="radiol" type="radio" name="FundingCheckPointer" id="FundingCheckPointer" <cfif FundingCheckPointer eq "9">checked</cfif> value="9"></td>
				<td style="padding-left:4px" class="labelmedium">Return Requisition with insufficient funds to Funder</td>
				<td style="padding-left:9px"><input <cfif EnableFundingCheck eq "0">disabled</cfif> class="radiol" type="radio" name="FundingCheckPointer" id="FundingCheckPointer" <cfif FundingCheckPointer eq "0">checked</cfif> value="0"></td>
				<td style="padding-left:4px" class="labelmedium">Default</td>			   
		    </tr>			
		</table>
		</td>
	</tr>	
	
	<TR id="funddialog3" class="#cl#">
    <td style="padding-left:10px" class="labelmedium">Limit item master to these used for requirements:</b></td>
    <TD>	
	<table cellspacing="0" cellpadding="0">
			<tr>
			    <TD><input type="radio" class="radiol" name="FilterItemMaster" id="FilterItemMaster" <cfif FilterItemMaster eq "1">checked</cfif> value="1"></td>
				<td style="padding-left:4px" class="labelmedium">Yes</td>
				<td style="padding-left:9px"><input type="radio" class="radiol" name="FilterItemMaster" id="FilterItemMaster" <cfif FilterItemMaster eq "0">checked</cfif> value="0"></td>
				<td style="padding-left:4px" class="labelmedium">No	
			</tr>
	</table>			
    </td>
    </tr>		
	
	<TR id="funddialog2" class="#cl#">
    <td style="padding-left:10px" class="labelmedium">Sufficiency Notification:</b></td>
    <TD>	
	<table cellspacing="0" cellpadding="0">
			<tr>
			    <TD><input type="radio" class="radiol" name="EnableEMail" id="EnableEMail" <cfif EnableEMail eq "1">checked</cfif> value="1"></td>
				<td class="labelmedium" style="padding-left:4px">Yes</td>
				<td style="padding-left:9px"><input class="radiol" type="radio" name="EnableEMail" id="EnableEMail" <cfif EnableEMail eq "0">checked</cfif> value="0"></td>
				<td style="padding-left:4px" class="labelmedium">No	
			</tr>
	</table>					
    </td>
    </tr>			
		
	<TR>
    <td style="padding-left:10px" class="labelmedium" style="cursor:pointer"><cf_UIToolTip  tooltip="Limit requisitioner to select object of expenditure for funding based on the selected Procurement Class">Select Object Code for funding:</cf_UIToolTip></b></td>
    <TD>
	<table cellspacing="0" cellpadding="0">
			<tr>
			    <TD><input type="radio" class="radiol" name="EnforceObject" id="EnforceObject" <cfif EnforceObject eq "1">checked</cfif> value="1" onclick="document.getElementById('resource').className='regular'"></td>
				<td style="padding-left:4px" class="labelmedium">Limited to Item Master & requested/allocated funds</td>
				<td style="padding-left:9px"><input type="radio" class="radiol" name="EnforceObject" id="EnforceObject" <cfif EnforceObject eq "0">checked</cfif> value="0" onclick="document.getElementById('resource').className='hide'"></td>
				<td style="padding-left:4px" class="labelmedium">Limited to requested/allocated funds</td>
				<td style="padding-left:9px"><input type="radio" class="radiol" name="EnforceObject" id="EnforceObject" <cfif EnforceObject eq "9">checked</cfif> value="9" onclick="document.getElementById('resource').className='hide'"></td>
				<td style="padding-left:4px" class="labelmedium">Disabled</td>
		    </tr>
	</table>
	</td>
	</tr>	
	
	<tr style="padding-left:10px" id="resource" class="<cfif EnforceObject neq "1">hide<cfelse>regular</cfif>">
		<td valign="top">
		<table cellspacing="0" cellpadding="0"><td style="padding-left:10px" class="labelmedium">
		Extend selection to all OoE under the same resource for the following entry classes:</td></tr></table>
		</td>
		<td>
			
		<!--- show only relevant class --->	
				
		<cfquery name="Class" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   Ref_ParameterMissionEntryClass R, 
				       Ref_EntryClass C
				WHERE  Mission    = '#URL.Mission#'
				AND    Period     = '#Period.Period#' 
				AND    R.EntryClass = C.Code 
				AND    R.EntryClass IN (
				                       SELECT DISTINCT EntryClass
				                       FROM   ItemMaster
		             			       WHERE  Operational = 1
				                       AND    (Mission = '#url.Mission#' or Mission is NULL ) 
									   )		
				ORDER BY Listingorder					   
									  
		</cfquery>
		
		<cfif Class.recordcount eq "0">
			
			<cfquery name="Class" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   Ref_ParameterMissionEntryClass R, 
					       Ref_EntryClass C
					WHERE  Mission    = '#URL.Mission#'
					AND    Period     = '#Period.Period#' 
					AND    R.EntryClass = C.Code 
					ORDER BY Listingorder			
			</cfquery>
		
		</cfif>		
		
		<table>
				
		<cfset cnt = 0>
		
		<cfloop query="Class">
		
		<cfset cnt = cnt+1>
		
		<cfif cnt eq "1"><tr></cfif>
				
			<td style="padding-left:10px;padding-right:4px" class="labelmedium2">#Description#:</td>			
			<td style="padding-right:10px"><input type="Checkbox" class="radiol" value="1" name="ItemMasterObjectExtend_#entryclass#" id="ItemMasterObjectExtend_#entryclass#" <cfif ItemMasterObjectExtend eq "1">checked</cfif>></td>
		<cfif cnt eq "3"></tr><cfset cnt = 0></cfif>				
		
		</cfloop>
		</table>
				
		</td>
		
	</tr>
	
	<tr><td style="padding-left:10px" valign="top" class="labelmedium2">Exceptions:</td>
	<td>
		
			<table cellspacing="0" cellpadding="0">
			<tr>
				<td class="labelmedium2"><font color="FF8000">Disable sufficiency check and Object filtering settings for the following Execution periods:</td>
			</tr>
			
			<tr><td>
			
			<cfquery name="FundingPeriod" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT DISTINCT Period
				FROM Ref_ParameterMissionEntryClass	
				WHERE Mission = '#url.mission#'
			</cfquery>
			
			<table>
			
			<cfset row = 1>
			
			<cfloop query="FundingPeriod">
			
				<cfquery name="Check" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT TOP 1 *
					FROM Ref_ParameterMissionEntryClass	
					WHERE Period = '#period#'
					AND   Mission = '#url.mission#'
				</cfquery>
			
			    <cfif row eq "1"><tr></cfif>
				
				<cfset row = row+1>
				
				<td style="padding-left:4px" class="labelmedium2">#Period#</td>
				<td style="padding-left:4px">
				<input name="b#currentrow#DisabledFundingCheck" id="b#currentrow#DisabledFundingCheck" type="checkbox" value="1" <cfif Check.DisableFundingCheck eq "1">checked</cfif>>				
				</td>
				
				 <cfif row eq "6"></tr><cfset row = "1"></cfif>			
		
			</cfloop>
			
			</table>
			
			<!---
			<font color="0080FF">&nbsp;&nbsp;This setting is a default setting and overruled by the setting for Budget control field [Enforce]</td></tr>
			--->
			</td>
			</tr>
			
			</table>
	</td>
	
	</tr>
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr><td colspan="2" align="center" height="34">
		
			<input type="submit" name="Save" id="Save" value="Apply" class="button10g">	
		
	</td></tr>
		
	</table>	
	
</cfoutput>	

</cfform>
	