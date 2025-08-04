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

<cfquery name="Get" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_ParameterMission
	WHERE Mission = '#URL.Mission#' 
</cfquery>

<cfform action="ParameterSubmitRequisition.cfm?mission=#URL.mission#"
        method="POST"
		target="process"
        name="funding">	
		
<cfoutput query="Get">

	<table width="94%" align="center" cellspacing="0" cellpadding="0"><tr><td>

	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
				
		<cfquery name="Period" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM Ref_MissionPeriod
			WHERE Mission = '#URL.Mission#' 
		</cfquery>
		
		<tr><td></td></tr>		
		<tr><td  style="height:40px;font-size:22px">Parameters</td></tr>
		<tr><td class="line" colspan="2"></td></tr>			
		
	    <TR>
	    <td width="240" class="labelmedium">Prefix / LastNo:</b></td>
	    <TD>		    
	  		<input type="text" class="regularxl" name="RequisitionPrefix" id="RequisitionPrefix" value="#RequisitionPrefix#" size="4" maxlength="4" style="text-align: right;">
	  		<input type="text" class="regularxl" name="RequisitionSerialNo" id="RequisitionSerialNo" value="#RequisitionSerialNo#" size="6" maxlength="6" style="text-align: right;">
		</TD>
		</TR>				
					
		<TR>
	    <td class="labelmedium"><cf_UIToolTip  tooltip="Send eMail as per defined template above to requisitioner upon denial">Enable Denial Mail:</cf_UIToolTip></b></td>
	    <TD>
		<table cellspacing="0" cellpadding="0">
		<tr>
		<td style="padding-left:0px"><input type="radio" class="radiol" name="EnableDenyMail" id="EnableDenyMail" <cfif EnableDenyMail eq "1">checked</cfif> value="1"></td><td style="padding-left:4px" class="labelmedium">Yes</td>
		<td style="padding-left:4px"><input type="radio" class="radiol" name="EnableDenyMail" id="EnableDenyMail" <cfif EnableDenyMail eq "0">checked</cfif> value="0"></td><td style="padding-left:4px" class="labelmedium">No</td>
		<td>&nbsp;</td>
		<td class="labelmedium">| &nbsp;Mail Template:</b></td>
		<td><cfinput class="regularxl" type="Text" name="TemplateEMail" value="#TemplateEMail#" message="Please enter a directory name" required="No" size="40" maxlength="50"></td>
		</tr>
		</table>	
	    </td>
	    </tr>
				
	    <TR>
	    <td class="labelmedium">Print Template:</b></td>
	    <TD>
	  	    <cfinput class="regularxl" type="Text" name="RequisitionTemplate" value="#RequisitionTemplate#" message="Please enter a directory name" required="No" size="60" maxlength="60">
	    </TD>
		</TR>
		
		<tr><td height="3"></td></tr>
		<tr><td  colspan="2" style="height:40px;font-size:22px">Standard Interface Settings</td></tr>
		<tr><td class="line" colspan="2"></td></tr>
			
		<TR>
		<cf_UIToolTip tooltip="Allow the requisitioner to submit a requisition date and due date. Requisition past the due date will be colored in Yellow.">
	    <td class="labelmedium">Request (Due) date:</b></td>
		</cf_UIToolTip>
	    <TD><table cellspacing="0" cellpadding="0">
		    <tr>
			<td><input type="radio" class="radiol" name="EnableDueDate" id="EnableDueDate" <cfif EnableDueDate eq "1">checked</cfif> value="1"></td><td class="labelmedium" style="padding-left:4px">Yes</td>
			<td style="padding-left:4px"><input type="radio" class="radiol" name="EnableDueDate" id="EnableDueDate" <cfif EnableDueDate eq "0">checked</cfif> value="0"></td><td class="labelmedium" style="padding-left:4px">No</td>
			</tr>
			</table>		
		</td>
	    </tr>
		
		<TR>
		<cf_UIToolTip tooltip="Allow the requisitioner to submit a requisition reference.">
	    <td class="labelmedium">Case No:</b></td>
		</cf_UIToolTip>
	    <TD><table cellspacing="0" cellpadding="0">
		    <tr>
			<td><input type="radio" class="radiol" name="EnableCaseNo" id="EnableCaseNo" <cfif EnableCaseNo eq "1">checked</cfif> value="1"></td><td class="labelmedium" style="padding-left:4px">Yes</td>
			<td style="padding-left:4px"><input type="radio" class="radiol" name="EnableCaseNo" id="EnableCaseNo" <cfif EnableCaseNo eq "0">checked</cfif> value="0"></td><td class="labelmedium" style="padding-left:4px">No</td>
			</tr>
			</table>	
		
		</td>
	    </tr>
					
		<TR>
		<cf_UIToolTip tooltip="Allow the requisitioner to raise his/her request in a different currency">
	    <td class="labelmedium" style="cursor: pointer;">Request Currency:</b></td>
		</cf_UIToolTip>
				
	    <TD>	
		
			<table>
				<tr valign="middle">
					<td class="labelmedium">
					
						<input type="radio" class="radiol"
							   name="EnableCurrency" 
							   onClick="document.getElementById('defaultCurrency_id').className='regular';"
							   id="EnableCurrency" <cfif EnableCurrency eq "1">checked</cfif> 
							   value="1">
							   
					</td>
					<td  style="padding-left:4px" class="labelmedium">Any</td>
					
					<td id="defaultCurrency_id">
					
					    <table cellspacing="0" cellpadding="0">
						<tr>
						<td class="labelmedium" style="padding-left:3px">						
						and use 						
						</td>
									
						<cfquery name="getCurrency" datasource="AppsLedger" username="#SESSION.login#" password="#SESSION.dbpw#">
							SELECT *
							FROM   Currency
							WHERE  EnableProcurement = 1
						</cfquery>
						
						<td style="padding-left:3px">			
						<select name="DefaultCurrency" class="regular">
							<cfloop query="getCurrency">
								<option value="#Currency#" <cfif Get.DefaultCurrency eq Currency>selected</cfif>> #Currency# </option>
							</cfloop>
						</select>
						</td>
						
						<td style="padding-left:3px" class="labelmedium">
						as the default
						</td>
						
						</tr></table>

					</td>
					<td style="padding-left:10px;" class="labelmedium">
						<input type="radio" class="radiol"
							   name="EnableCurrency" 
							   id="EnableCurrency" <cfif EnableCurrency neq "1" >checked</cfif> 
							   value="0"
   							   onClick="document.getElementById('defaultCurrency_id').className='hide';">
						</td>
						<td class="labelmedium" style="padding-left:4px">#APPLICATION.BaseCurrency# only</td>	
					</td>
				</tr>
			</table>
			
	    </td>
	    </tr>
		
		<TR>
	    <td class="labelmedium" style="cursor: pointer;"><cf_UIToolTip  tooltip="Allow requisitioner to select warehouse item based on item master or on item master object of expenditure">Filter Warehouse Item select on:</cf_UIToolTip></b></td>
	    <TD>
		
		<table cellspacing="0" cellpadding="0">
		    <tr>
			<td><input type="radio" class="radiol" name="ItemMasterObject" id="ItemMasterObject" <cfif ItemMasterObject eq "1">checked</cfif> value="1"></td><td class="labelmedium" style="padding-left:4px">Object of Expenditure</td>
			<td style="padding-left:10px"><input type="radio" class="radiol" name="ItemMasterObject" id="ItemMasterObject" <cfif ItemMasterObject eq "0">checked</cfif> value="0"></td><td class="labelmedium" style="padding-left:4px">Item Master</td>
			</tr>
			</table>		
	    </td>
	    </tr>
		
				
		<TR>
		<cf_UIToolTip tooltip="Allow the requisitioner to enter specification in HTML format">
	    <td class="labelmedium">Request Specifications:</b></td>
		</cf_UIToolTip>
	    <TD>	
		
		<table cellspacing="0" cellpadding="0">
		    <tr>
			<td><input type="radio" class="radiol" name="RequisitionTextMode" id="RequisitionTextMode" <cfif RequisitionTextMode eq "1">checked</cfif> value="1"></td><td class="labelmedium" style="padding-left:4px">HTML</td>
			<td><input type="radio" class="radiol" name="RequisitionTextMode" id="RequisitionTextMode" <cfif RequisitionTextMode eq "0">checked</cfif> value="0"></td><td class="labelmedium" style="padding-left:4px">Text</td>
			</tr>
		</table>	
				
	    </td>
	    </tr>
		
		<!--- Field: Prosis Document Root --->
	    <TR>
	    <td class="labelmedium">Attachment directory:</b></td>
	    <TD>
	  	    /<cfinput class="regularxl" type="Text" name="RequisitionLibrary" value="#RequisitionLibrary#" message="Please enter a directory name" required="Yes" size="30" maxlength="30">
	    </TD>
		</TR>
		
		
		<TR>
	    <td class="labelmedium" style="cursor:help">
		<cf_UIToolTip tooltip="Allow the requisitioner to financially tag the request amounts">
		Financial Tagging:</cf_UIToolTip></b></td>
	    <TD>	
		<table cellspacing="0" cellpadding="0">
			<tr>
			<td class="labelmedium">
			<table cellspacing="0" cellpadding="0">
			<tr>
			<td style="padding-left:0px"><input class="radiol" type="radio" name="EnableReqTag" id="EnableReqTag" onclick="document.getElementById('reqprogram').className='regular'" <cfif EnableReqTag eq "1">checked</cfif> value="1"></td>
			<td style="padding-left:4px" class="labelmedium">Enabled</td>
			
			<td style="padding-left:6px"><input type="radio" name="ReqTagMode" id="ReqTagMode" <cfif ReqTagMode eq "Single">checked</cfif> value="Single"></td>
			<td style="padding-left:4px" class="labelit">Single</td>
			
			<td style="padding-left:6px"><input type="radio" name="ReqTagMode" id="ReqTagMode" <cfif ReqTagMode eq "Multiple">checked</cfif> value="Multiple"></td>
			<td style="padding-left:4px" class="labelit">Multiple</td>
			
			<td style="padding-left:9px"><input class="radiol" type="radio" name="EnableReqTag" id="EnableReqTag" onclick="document.getElementById('reqprogram').className='hide'" <cfif EnableReqTag eq "0">checked</cfif> value="0"></td>
			<td style="padding-left:4px" class="labelmedium">Disabled</td>	
			</tr>
			</table>
			</td>		
			<cfif EnableReqTag eq "1">
			   <cfset cl = "regular">
			<cfelse>
			   <cfset cl = "hide">
			</cfif>
			<td id="reqprogram" class="#cl#" style="padding-left:14px">
			<table>
			<tr>
			<td style="padding-left:0px"><input class="radiol" type="radio" name="ReqTagActivity" id="ReqTagActivity" <cfif ReqTagActivity eq "1">checked</cfif> value="1"></td>
			<td style="padding-left:4px" class="labelmedium">Project/Program activity</td>
			<td style="padding-left:9px"><input class="radiol" type="radio" name="ReqTagActivity" id="ReqTagActivity" <cfif ReqTagActivity eq "0">checked</cfif> value="0"></td>
			<td style="padding-left:4px" class="labelmedium">Custom List (dbo.Ref_Category)</td>
			</tr>
			</table>
			</td>
			</tr>
		</table>
	    </td>
	    </tr>		
		
		<!---
				
		<TR>
		<cf_UIToolTip tooltip="Allow the requisitioner to financially tag the request amounts">
	    <td class="labelmedium" style="cursor: pointer;">Request Tagging:</b></td>
		</cf_UIToolTip>
	    <TD style="cursor: pointer;">	
		<table cellspacing="0" cellpadding="0">
		    <tr>
			<td  style="padding-left:0px"><input type="radio" class="radiol" name="EnableReqTag" id="EnableReqTag" <cfif EnableReqTag eq "1">checked</cfif> value="1"></td>
			<td class="labelmedium" style="padding-left:4px">Yes</td>
			<td  style="padding-left:4px"><input type="radio" class="radiol" name="EnableReqTag" id="EnableReqTag" <cfif EnableReqTag eq "0">checked</cfif> value="0"></td>
			<td class="labelmedium" style="padding-left:4px">No</td>
			</tr>
			</table>		
				
	    </td>
	    </tr>
		
		--->
		
		<TR>
	    <td class="labelmedium" style="cursor: pointer;"><cf_UIToolTip  tooltip="Allow requester to specificy the request in more details">Request Descriptive mode:</cf_UIToolTip></b></td>
	    <TD style="cursor: pointer;">
		
			<table cellspacing="0" cellpadding="0">
			<tr>			
			<td style="padding: 0px;">
			<input type="radio" class="radiol" onclick="document.getElementById('casecheck').className='hide'"
			   name="RequestDescriptionMode" id="RequestDescriptionMode" <cfif RequestDescriptionMode eq "0">checked</cfif> value="0"></td>
			   <td class="labelmedium" style="padding-left:4px">Default (disabled)</td>			
			<td  style="padding-left:4px"><input type="radio" class="radiol" onclick="document.getElementById('casecheck').className='hide'"
			     name="RequestDescriptionMode" id="RequestDescriptionMode" <cfif RequestDescriptionMode eq "1">checked</cfif> value="1"></td>
				 <td class="labelmedium" style="padding-left:4px"><cf_UIToolTip tooltip="Allow entry of detailed services, dates and amounts for a single requisition line">Service Line Item</cf_UIToolTip></td>
			<td  style="padding-left:4px"><input type="radio" class="radiol" onclick="document.getElementById('casecheck').className='regular'"
			name="RequestDescriptionMode" id="RequestDescriptionMode" <cfif RequestDescriptionMode eq "2">checked</cfif> value="2"></td>
			<td class="labelmedium" style="padding-left:4px"><cf_UIToolTip tooltip="Allow entry of more detailed listed specifications and amounts for a single requisition line and allow for entry of a caseNo">Specification Line Item</cf_UIToolTip></td>
						
			<cfif RequestDescriptionMode eq "2">
			   <cfset cl = "regular">
			<cfelse>
			   <cfset cl = "hide">   
			</cfif>
			
			</tr>
			</table>
			
		</td>	
		<tr class="#cl#" id="casecheck">
			<td></td>
				
		    <td style="cursor: pointer;">
			<table cellspacing="0" cellpadding="0">
			     
			        <tr>
					<td>&nbsp;&nbsp;</td>				
				    <TD>	
					<table cellspacing="0" cellpadding="0">
				    <tr>
					<td class="labelmedium">
					<font color="808080">Specification Mode only [Verify CaseNo] :</font>
					</td>
					<td style="padding-left:0px"><input class="radiol" type="radio" name="RequisitionCaseNoCheck" id="RequisitionCaseNoCheck" <cfif RequisitionCaseNoCheck eq "1">checked</cfif> value="1"></td>
					<td class="labelmedium" style="padding-left:4px">Yes</td>
					<td style="padding-left:4px"><input class="radiol" type="radio" name="RequisitionCaseNoCheck" id="RequisitionCaseNoCheck" <cfif RequisitionCaseNoCheck eq "0">checked</cfif> value="0"></td>
					<td class="labelmedium" style="padding-left:4px">No</td>
					</tr>
	     			</table>		
						
		    		</td>
					</tr>
			</table>		
		    </td>
			
	    </tr>
		
		
		
		<TR>
	    <td class="labelmedium" style="cursor: pointer;"><cf_UIToolTip  tooltip="Allow requisitioner to identify one or more beneficiaries">Record a Beneficiary Unit:</cf_UIToolTip></b></td>
	    <TD style="cursor: pointer;">
		<table cellspacing="0" cellpadding="0">
		    <tr>
			<td style="padding-left:0px"><input type="radio" class="radiol" name="EnableBeneficiary" id="EnableBeneficiary" <cfif EnableBeneficiary eq "1">checked</cfif> value="1"></td>
			<td class="labelmedium" style="padding-left:4px">Enabled</td>
			<td  style="padding-left:4px"><input type="radio" class="radiol" name="EnableBeneficiary" id="EnableBeneficiary" <cfif EnableBeneficiary eq "0">checked</cfif> value="0"></td>
			<td class="labelmedium" style="padding-left:4px">Disabled (default)</td>
			</tr>
			</table>		
	    </td>
	    </tr>		
		
		<TR>
		<cf_UIToolTip tooltip="Hide or Show the custom Request Description as entered by the Requester in the listings.">
	    <td class="labelmedium">Listing Descriptive:</b></td>
		</cf_UIToolTip>
	    <TD>
		<table cellspacing="0" cellpadding="0">
		    <tr>
			<td style="padding-left:0px" class="labelmedium"><input type="radio" class="radiol" name="RequisitionListingMode" id="RequisitionListingMode" <cfif RequisitionListingMode eq "1">checked</cfif> value="1"></td>
			<td class="labelmedium" style="padding-left:4px">Show</td>
			<td  style="padding-left:4px"><input type="radio" class="radiol" name="RequisitionListingMode" id="RequisitionListingMode" <cfif RequisitionListingMode eq "0">checked</cfif> value="0"></td>
			<td class="labelmedium" style="padding-left:4px">Hide</td>
			</tr>
		</table>						
		</td>
	    </tr>
		
		<tr><td height="3"></td></tr>
		<tr><td  style="height:40px;font-size:22px">Editing</td></tr>
		<tr><td class="linedotted" colspan="2"></td></tr>
			
		<TR>
		<cf_UIToolTip tooltip="Allow the technical reviewer to purge a requisition line">
	    <td class="labelmedium" style="cursor: pointer;">Allow Purge Requisition:</b></td>
		</cf_UIToolTip>
	    <TD>	
		<table cellspacing="0" cellpadding="0">
		    <tr>
			<td style="padding-left:0px"><input type="radio" class="radiol" name="RequestPurge" id="RequestPurge" <cfif RequestPurge eq "1">checked</cfif> value="1"></td><td class="labelmedium" style="padding-left:4px">Yes</td>
			<td style="padding-left:4px"><input type="radio" class="radiol" name="RequestPurge" id="RequestPurge" <cfif RequestPurge eq "0">checked</cfif> value="0"></td><td class="labelmedium" style="padding-left:4px">No</td>
			</tr>
			</table>	
				
	    </td>
	    </tr>
			
		<TR>
		  	<td style="padding-top:3px;cursor: pointer;" valign="top" class="labelmedium">
			<cf_UIToolTip tooltip="Allow a reviewer, funder or certifier to modify the requisition without sending it back in the review chain">
			Modify Requisition Line:
			</cf_UIToolTip>
		</td>
		
	    <TD>	
			<table cellspacing="0" cellpadding="0">
			<tr>
				<td style="padding: 0px;">
				<input type="radio" class="radiol" name="EnableRequisitionEdit" id="EnableRequisitionEdit" <cfif EnableRequisitionEdit eq "1">checked</cfif> value="1" onclick="EnableRequisitionEditMode1.disabled=false;EnableRequisitionEditMode2.disabled=true;">
				</td>
				<td style="padding: 0px;">
				<table cellspacing="0" cellpadding="0" class="formpadding">
					<tr>
						<td class="labelmedium" style="padding-left: 4px;">Yes</td>
						<td style="padding-left: 5px;" class="labelmedium">
							<input class="radiol" type="checkbox" <cfif EnableRequisitionEdit eq "0">disabled</cfif> name="EnableRequisitionEditMode1" id="EnableRequisitionEditMode1" <cfif EnableRequisitionEditMode eq "1">checked</cfif> value="1">
							</td>
							<td style="padding-left:4px" class="labelmedium">but this is limited to Role of Certifier
						</td>
						</td>
					</tr>
				</table>
				</td>
			</tr>		
			<tr>
				<td style="padding: 0px;">		
				<input type="radio" class="radiol" name="EnableRequisitionEdit" id="EnableRequisitionEdit" <cfif EnableRequisitionEdit eq "0">checked</cfif> value="#EnableRequisitionEdit#" onclick="EnableRequisitionEditMode1.disabled=true;EnableRequisitionEditMode2.disabled=false;">
				</td>
				<td style="padding-left:5px;">
				<table cellspacing="0" cellpadding="0">
					<tr><td class="labelmedium">No, any change will result in aa SEND BACK to Requester</td>			
					<td style="padding-left:9px;padding-right:4px" class="labelmedium">
						<!--- fixed issue with no saving JM ---->
						<input class="radiol" type="checkbox" <cfif EnableRequisitionEdit eq "1">disabled</cfif> name="EnableRequisitionEditMode2" id="EnableRequisitionEditMode2" <cfif EnableRequisitionEditMode eq "2">checked</cfif> value="2">
						</td>
						<td style="padding-left:4px"  class="labelmedium">but, allow the Descriptive to be changed</td>
				</tr>
				</table>
			</tr>
			</table>	
	    </td>
		
	    </tr>
		
		<tr><td class="linedotted" colspan="2"></td></tr>
		
		<tr><td colspan="2" align="center" height="34">		
			<input type="submit" name="Save" id="Save" value="Apply" style="width:160" class="button10g">			
		</td></tr>
				
		</table>
		
		</td></tr>
		</table>
		
	</cfoutput>			
	
</cfform>
	