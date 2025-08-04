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

<cfform action="ParameterSubmitInvoice.cfm?mission=#URL.mission#"
        method="POST"
        name="receipt">	
		
<cfoutput query="Get">

<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<tr><td height="7px"></td></tr>
	<TR>
    <td class="labelmedium">Invoice Due default days:</b></td>
    <TD>	
	<table>
	    <tr>
		<td style="padding-left:0px"><input class="radiol" type="radio" name="InvoiceDueDays" id="InvoiceDueDays" <cfif InvoiceDueDays eq "7">checked</cfif> value="7"></td>
		<td class="labelmedium" style="padding-left:3px">7 days</td>
		<td style="padding-left:9px"><input type="radio" class="radiol" name="InvoiceDueDays" id="InvoiceDueDays" <cfif InvoiceDueDays eq "15">checked</cfif> value="15"></td>
		<td class="labelmedium" style="padding-left:3px">15 days</td>
		<td style="padding-left:9px"><input type="radio" class="radiol" name="InvoiceDueDays" id="InvoiceDueDays" <cfif InvoiceDueDays eq "21">checked</cfif> value="21"></td>
		<td class="labelmedium" style="padding-left:3px">21 days</td>
		<td style="padding-left:9px"><input type="radio" class="radiol" name="InvoiceDueDays" id="InvoiceDueDays" <cfif InvoiceDueDays eq "30">checked</cfif> value="30"></td>
		<td class="labelmedium" style="padding-left:3px">30 days</td>
		</tr>
	</table>
	</td>
    </tr>
	
	<TR>
    <td  class="labelmedium" style="cursor:help">
	<cf_UIToolTip tooltip="Do not permit entry of invoices in currency other than the submitted purchase Order">
	Invoice must be issued in Purchase Currency:</cf_UIToolTip></b></td>
    <TD>	
	<table>
		<tr>
		<td style="padding-left:0px"><input type="radio" class="radiol" name="EnforceCurrency" id="EnforceCurrency" <cfif EnforceCurrency eq "1">checked</cfif> value="1"></td>
		<td style="padding-left:4px" class="labelmedium">Yes</td>
		<td style="padding-left:9px"><input class="radiol" type="radio" name="EnforceCurrency" id="EnforceCurrency" <cfif EnforceCurrency eq "0">checked</cfif> value="0"></td>
		<td style="padding-left:4px" class="labelmedium">No</td>
		</tr>
	</table>
	</td>
    </tr>
	
	<TR>
    <td class="labelmedium" style="cursor:help">
	<cf_UIToolTip tooltip="Enables additional invoice tagging as defined in Tagging maintenance">
	Financial Tagging:</cf_UIToolTip></b></td>
    <TD>	
	<table cellspacing="0" cellpadding="0">
		<tr>
		<td class="labelmedium">
		<table cellspacing="0" cellpadding="0">
		<tr>
		
		<td style="padding-left:0px"><input class="radiol" type="radio" name="EnableInvTag" id="EnableInvTag" onclick="document.getElementById('invprogram').className='hide'" <cfif EnableInvTag eq "0">checked</cfif> value="0"></td>
		<td style="padding-left:4px" class="labelmedium">Disabled</td>	
		
		<td style="padding-left:9px"><input class="radiol" type="radio" name="EnableInvTag" id="EnableInvTag" onclick="document.getElementById('invprogram').className='regular'" <cfif EnableInvTag eq "1">checked</cfif> value="1"></td>
		<td style="padding-left:4px" class="labelmedium">Enabled</td>
		
		<td style="padding-left:6px"><input type="radio" name="InvTagMode" id="InvTagMode" <cfif InvTagMode eq "Single">checked</cfif> value="Single"></td>
		<td style="padding-left:4px" class="labelit">Single</td>
		
		<td style="padding-left:6px"><input type="radio" name="InvTagMode" id="InvTagMode" <cfif InvTagMode eq "Multiple">checked</cfif> value="Multiple"></td>
		<td style="padding-left:4px" class="labelit">Multiple</td>
		
		
		</tr>
		</table>
		</td>		
		<cfif EnableInvTag eq "1">
		   <cfset cl = "regular">
		<cfelse>
		   <cfset cl = "hide">
		</cfif>
		<td id="invprogram" class="#cl#" style="padding-left:14px">
		<table>
		<tr>
		<td style="padding-left:0px"><input class="radiol" type="radio" name="InvTagProgram" id="InvTagProgram" <cfif InvTagProgram eq "1">checked</cfif> value="1"></td>
		<td style="padding-left:4px" class="labelmedium">Project/Program</td>
		<td style="padding-left:9px"><input class="radiol" type="radio" name="InvTagProgram" id="InvTagProgram" <cfif InvTagProgram eq "0">checked</cfif> value="0"></td>
		<td style="padding-left:4px" class="labelmedium">Custom List (dbo.Ref_Category)</td>
		</tr>
		</table>
		</td>
		</tr>
	</table>
    </td>
    </tr>
	
	<TR>
    <td class="labelmedium" width="260" style="cursor:help">
	<cf_UIToolTip tooltip="Creates an on-hold payable for the mark down amount, does not apply if invoice itself is on hold">Generate New Payable after Markdown:</cf_UIToolTip></b></td>
    <TD>
		<table>
			<tr>
			<td style="padding-left:0px"><input type="radio" class="radiol" name="InvoiceLineCreate" id="InvoiceLineCreate" <cfif InvoiceLineCreate eq "1">checked</cfif> value="1"></td>
			<td style="padding-left:4px" class="labelmedium">Yes</td>
			<td style="padding-left:9px"><input class="radiol" type="radio" name="InvoiceLineCreate" id="InvoiceLineCreate" <cfif InvoiceLineCreate eq "0">checked</cfif> value="0"></td>
			<td style="padding-left:4px" class="labelmedium">No</td>
			</tr>
		</table>
    </td>
    </tr>
	
	<TR>
    <td width="260" valign="top">
	<table cellspacing="0" cellpadding="0"><tr><td height="2"></td></tr><tr><td  class="labelmedium">
	Invoice Association mode:</b>
	</td></tr>
	</table>
    <TD>
		<table>
			<tr>
			<td style="padding-left:0px"><input class="radiol" type="radio" name="InvoiceRequisition" id="InvoiceRequisition" <cfif InvoiceRequisition eq "0">checked</cfif> value="0"></td>
			<td style="padding-left:4px" class="labelmedium">Purchase Order (one or more)</td>						
			<td style="padding-left:14px"><input class="radiol" type="radio" name="InvoiceRequisition" id="InvoiceRequisition" <cfif InvoiceRequisition eq "1">checked</cfif> value="1"></td>
			<td style="padding-left:4px" class="labelmedium">Purchase LINE / Requisition (same Purchase)</td>
			</tr>
		</table>
    </td>
    </tr>
	
	<cf_verifyOperational module="Accounting" Warning="No">
		
	<cfif operational eq "1">
		
		<cfquery name="Acc" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_Account
			WHERE  GLAccount = '#AdvanceGLAccount#'
		</cfquery>
	
	<cf_dialogLedger>
	
	<TR>
    <td width="260" style="cursor:help"  class="labelmedium">
    <cf_UIToolTip tooltip="Allow recording of one advance to be paid for the Purchase Order, which will be automatically offset. Required Ledger module to be enabled.">
	Advance Payment:
	</cf_UIToolTip>
	</b></td>
    <TD>
	<table>
			<tr>
			<td style="padding-left:0px"><input class="radiol" type="radio" onclick="document.getElementById('advanceaccount').className='regular'" name="InvoiceAdvance" id="InvoiceAdvance" <cfif InvoiceAdvance eq "1">checked</cfif> value="1"></td>
			<td style="padding-left:4px" class="labelmedium">Enabled</td>
			
			<td style="padding-left:9px"><input class="radiol" type="radio" onclick="document.getElementById('advanceaccount').className='hide'" name="InvoiceAdvance" id="InvoiceAdvance" <cfif InvoiceAdvance eq "0">checked</cfif> value="0"></td>
			<td style="padding-left:4px" class="labelmedium">Disabled</td>
			
			
			</tr>
	</table>		
    </td>
    </tr>
	
	<cfif InvoiceAdvance eq "1">
	   <cfset cl = "regular">
	<cfelse>
	   <cfset cl = "hide">
	</cfif>
	
	<TR class="#cl#" id="advanceaccount">
    <td width="260" style="padding-left:30px" class="labelmedium">Advance Ledger GL Account:</b></td>
    <TD>	
	    <cfoutput>	 
		
			<table><tr>
		    <td>
			<img src="#SESSION.root#/Images/search.png" alt="GLAccount" name="img3" 
				  onMouseOver="document.img3.src='#SESSION.root#/Images/contract.gif'" 
				  onMouseOut="document.img3.src='#SESSION.root#/Images/search.png'"
				  style="cursor: pointer;" width="25" height="25" border="0" align="absmiddle" 
				  onClick="javascript:selectaccountgl('#URL.mission#', '', '', '', 'applyAdvanceAccount', '');">
		    <td>
			<td style="padding-left:2px">
			<input type="text" name="AdvanceGLAccount" id="AdvanceGLAccount" size="6" value="#AdvanceGLAccount#"  class="regularxl" readonly style="text-align: center;">
			</td>
			<td style="padding-left:2px">
		    <input type="text" name="AdvanceGLDescription" id="AdvanceGLDescription"  value="#acc.Description#"   class="regularxl" size="40" readonly style="text-align: center;">
			</td>
			
			</tr></table>
			
		</cfoutput>
	
    </td>
    </tr>
		
	<cfquery name="Rct" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM Ref_Account
			WHERE GLAccount = '#ReceiptGLAccount#'
	</cfquery>
		
	<TR id="receiptaccount">
    <td width="260" style="padding-left:30px" class="labelmedium">Receipt Ledger GL Account:</b></td>
    <TD>	
	    <cfoutput>	 
			<table><tr>
		    <td>
		    <img src="#SESSION.root#/Images/search.png" alt="Select item master" name="img31" 
				  onMouseOver="document.img31.src='#SESSION.root#/Images/contract.gif'" 
				  onMouseOut="document.img31.src='#SESSION.root#/Images/search.png'"
				  style="cursor: pointer;" width="25" height="25" border="0" align="absmiddle" 
				  onClick="javascript:selectaccountgl('#URL.mission#', '', '', '', 'applyReceiptAccount', '');">
			 <td>
			<td style="padding-left:2px">	  
		    <input type="text" name="ReceiptGLAccount"     id="ReceiptGLAccount" size="6"  value="#ReceiptGLAccount#"  class="regularxl" readonly style="text-align: center;">
			</td>
			<td style="padding-left:2px">
		    <input type="text" name="ReceiptGLDescription" id="ReceiptGLDescription"      value="#rct.Description#"   class="regularxl" size="40" readonly style="text-align: center;">
			</td>
			
			</tr></table>
		   </cfoutput>
	
    </td>
    </tr>		
	
	<cfelse>
	
		<input type="hidden" name="InvoiceAdvance"   id="InvoiceAdvance"    value="0">
		<input type="hidden" name="AdvanceGLAccount" id="AdvanceGLAccount"  value="">
		<input type="hidden" name="ReceiptGLAccount" id="ReceiptGLAccount"  value="">
	
	</cfif>	
	
	<tr><td class="labelmedium">When to record the Purchase payable</b></td></tr>
	<tr><td colspan="2" class="linedotted"></td></tr>
	
	<TR>
    <td class="labelit" width="260" style="padding-left:10px">Allow prior to PO approval:</b></td>
    <TD>
	<table>
			<tr>
			<td style="padding-left:0px"><input class="radiol" type="radio" name="InvoicePriorIssue" id="InvoicePriorIssue" <cfif InvoicePriorIssue eq "1">checked</cfif> value="1"></td>
			<td style="padding-left:4px" class="labelmedium">Yes</td>
			<td style="padding-left:9px"><input class="radiol" type="radio" name="InvoicePriorIssue" id="InvoicePriorIssue" <cfif InvoicePriorIssue eq "0">checked</cfif> value="0"></td>
			<td style="padding-left:4px" class="labelmedium">No</td>
			</tr>
	</table>			
	
    </td>
    </tr>
	
	<TR>
    <td class="labelit" width="260" style="padding-left:10px">Allow Prior to Receipt recording:</b></td>
    <TD class="labelmedium">
	<table>
			<tr>
			<td><input class="radiol" type="radio" name="InvoicePriorReceipt" id="InvoicePriorReceipt" <cfif InvoicePriorReceipt eq "1">checked</cfif> value="1"></td>
			<td style="padding-left:4px" class="labelmedium">Yes</td>
			<td style="padding-left:9px"><input class="radiol" type="radio" name="InvoicePriorReceipt" id="InvoicePriorReceipt" <cfif InvoicePriorReceipt eq "0">checked</cfif> value="0"></td>
			<td style="padding-left:4px" class="labelmedium">No [only applicable if receipt entry is enabled for purchase order type]</td>
			</tr>
	</table>	
    </td>
    </tr>
	
	<TR>
    <td class="labelit" valign="top" width="260" style="padding-top:3px;padding-left:10px">Budget Execution Posting:</b></td>
    <TD>
	
	<table>
			<tr>
			<td><input class="radiol" type="radio" name="InvoicePostingMode" id="InvoicePostingMode" <cfif InvoicePostingMode eq "0">checked</cfif> value="0"></td>
			<td style="padding-left:4px" class="labelmedium">Requisition funding</td>		
			<td style="padding-left:9px"><input class="radiol" type="radio" name="InvoicePostingMode" id="InvoicePostingMode" <cfif InvoicePostingMode eq "1">checked</cfif> value="1"></td>
			<td style="padding-left:4px" class="labelmedium">Invoice defined funding</td>
			</tr>
	</table>	
	
    </td>
    </tr>
	
	<TR>
    <td width="260" style="padding-top:3px" class="labelmedium" valign="top">
	<cf_UIToolTip tooltip="Use this feature if receipts usually are not recorded with the correct price or is not available at the moment of receipt.">
	Enable Invoice deviation from R&I value:</b>
	</cf_UIToolTip>
	</td>
    <TD>
		<table class="formpadding">
			<tr>
			<td style="padding-left:1px"><input class="radiol" type="radio" name="InvoiceMatchPriceActual" id="InvoiceMatchPriceActual" <cfif InvoiceMatchPriceActual eq "1">checked</cfif> value="1"></td>
			<td style="padding-left:4px" class="labelmedium">Yes, price</td>	
			</tr>
			<tr>	
			<td style="padding-left:1px"><input class="radiol" type="radio" name="InvoiceMatchPriceActual" id="InvoiceMatchPriceActual" <cfif InvoiceMatchPriceActual eq "2">checked</cfif> value="2"></td>
			<td style="padding-left:4px" class="labelmedium">Yes, amount</td>				
			</tr>
			<tr>
			<td style="padding-left:1px"><input class="radiol" type="radio" name="InvoiceMatchPriceActual" id="InvoiceMatchPriceActual" <cfif InvoiceMatchPriceActual eq "0">checked</cfif> value="0"></td>
			<td style="padding-left:4px" class="labelmedium">N/A</td>
			</tr>
		</table>	
	</td>
	</tr>
	
	<TR>
    <td width="260" style="padding-top:3px;padding-left:10px" class="labelit" valign="top">
	<cf_UIToolTip tooltip="Use this feature if receipts usually are not recorded with the correct price or is not available at the moment of receipt.">
	thresholds:</b>
	</cf_UIToolTip>
	</td>		
			
			<td id="vary">
			<table>
				<tr>
				
				<td style="padding-left:1px;padding-right:4px">			
						<cfinput type="Text"
					       name="InvoiceMatchDifference"
					       value="#InvoiceMatchDifference#"
					       validate="float"
					       required="Yes"
					       visible="Yes"
						   style="text-align:center;width:35px"
						   class="regularxl"
					       enabled="Yes"					   
					       size="3"
					       maxlength="6">
				</td>
				<td class="labelmedium">% and/or</td>
				<td style="padding-left:4px;padding-right:4px">			
						   
						   <cfinput type="Text"
					       name="InvoiceMatchDifferenceAmount"
					       value="#InvoiceMatchDifferenceAmount#"
					       validate="float"
					       required="Yes"
					       visible="Yes"
						   style="text-align:center"
						   class="regularxl"
					       enabled="Yes"
					       size="3"
					       maxlength="6"> </td> <td class="labelmedium">in value difference				   
						   
						</td>
						
						<TD style="padding-left:10px">	
						
						<cfquery name="Diff" 
							datasource="AppsLedger" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT *
								FROM Ref_Account
								WHERE GLAccount = '#DifferenceGLAccount#'
							</cfquery>
						
						<table><tr>
						    <td>
						    <img src="#SESSION.root#/Images/search.png" alt="Select item master" name="img39" 
								  onMouseOver="document.img39.src='#SESSION.root#/Images/contract.gif'" 
								  onMouseOut="document.img39.src='#SESSION.root#/Images/search.png'"
								  style="cursor: pointer;" width="25" height="25" border="0" align="absmiddle" 
								  onClick="javascript:selectaccountgl('#URL.mission#', '', '', '', 'applyDiffAccount', '');">
								  
							 <td>
							<td style="padding-left:2px">		  
						    <input type="text" name="DifferenceGLAccount"     id="DifferenceGLAccount"      size="6"  value="#DifferenceGLAccount#"  class="regularxl" readonly style="text-align: center;">
							 <td>
							<td style="padding-left:2px">	
						    <input type="text" name="DifferenceGLDescription" id="DifferenceGLDescription"  value="#diff.Description#"   class="regularxl" size="40" readonly style="text-align: center;">
							
							</td></tr>
							</table>
								
						    </td>
				
						
				</tr>
			</table>
	</td>		
	</tr>		
		
	<TR>
    <td class="labelmedium">Print Template:</b></td>
    <TD>
  	    <cfinput class="regularxl" 
		         type="Text" 
				 name="InvoiceTemplate" 
				 value="#InvoiceTemplate#" 
				 message="Please enter a directory name" 
				 required="No" 
				 size="80" 
				 maxlength="80">
    </TD>
	</TR>
	
	<tr><td height="5" id="tdSubmit"></td></tr>
	
	<tr><td colspan="2" class="line"></td></tr>	
	
	<tr><td colspan="2" align="center" height="34">		
			<input type="submit" name="Save" id="Save" value="Apply" class="button10g" style="width:150px">			
	</td></tr>
			
	</table>
	
</cfoutput>	

</cfform>
	