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

<cfparam name="url.period" default="#get.DefaultPeriod#">

<cfoutput query="Get">


<cfform action="ParameterSubmitJob.cfm?mission=#URL.mission#&period=#url.period#"
        method="POST"
        name="job">	

		
<table width="94%" border="0" cellspacing="0" align="center" class="formspacing formpadding">
					
    <TR class="labelmedium2">
    <td width="180">Prefix/LastNo:</b></td>
    <TD>
 		<input type="text" class="regularxl" name="QuotationPrefix" id="QuotationPrefix" value="#QuotationPrefix#" size="6" maxlength="4" style="text-align: right;">
		<input type="text" class="regularxl" name="QuotationSerialNo" id="QuotationSerialNo" value="#QuotationSerialNo#" size="6" maxlength="6" style="text-align: right;">	
    </TD>
	</TR>
		
    <TR class="labelmedium2">
    <td>Attachment Path:</b></td>
    <TD>
  	    <cfinput class="regularxl" type="Text" name="QuotationLibrary" value="#QuotationLibrary#" message="Please enter a directory name" required="Yes" size="30" maxlength="30">
    </TD>
	</TR>	
		
	<TR class="labelmedium2">
    <td>Print Template:</b></td>
    <TD>
  	    <cfinput class="regularxl" type="Text" name="QuotationTemplate" value="#QuotationTemplate#" message="Please enter a directory name" required="No" size="80" maxlength="90">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <td><cf_UIToolTip tooltip="Turn off/on the workflow for procurement jobs">Job Workflow:</b></cf_UIToolTip></b></td>
	<TD width="80%" class="labelmedium2">		
		<cfdiv bind="url:#SESSION.root#/system/entityAction/EntityFlow/EntityAction/EntityStatus.cfm?mission=#url.mission#&entitycode=procjob" id="wfprocjob">		
	</td>
	</tr>
		
	<TR class="labelmedium2">
    <td><cf_tl id="Vendor Roster"></td>
    <TD>
	<table>
	    <tr>
		<td><input type="radio" class="radiol" name="EnableVendorRoster" id="EnableVendorRoster" <cfif #EnableVendorRoster# eq "1">checked</cfif> value="1"></td><td class="labelmedium2" style="padding-left:3px">Yes</td>
		<td style="padding-left:4px"><input type="radio" class="radiol" name="EnableVendorRoster" id="EnableVendorRoster" <cfif #EnableVendorRoster# eq "0">checked</cfif> value="0"></td><td class="labelmedium2" style="padding-left:3px">No</td>
		</tr>
	</table>
    </td>
    </tr>
	
	
	<TR class="labelmedium2">
    <td><cf_UIToolTip tooltip="Inherit the requisition costprice/value when selecting a vendor a quote">Quick Quote:</cf_UIToolTip></b></td>
   	<TD>
	<table>
	    <tr class="labelmedium2">
		<td><input type="radio" class="radiol" name="EnableQuickQuote" id="EnableQuickQuote" <cfif EnableQuickQuote eq "1">checked</cfif> value="1"></td>
		<td class="labelmedium2" style="padding-left:3px">Yes</td>
		<td style="padding-left:4px"><input type="radio" class="radiol" name="EnableQuickQuote" id="EnableQuickQuote" <cfif EnableQuickQuote eq "0">checked</cfif> value="0"></td>
		<td class="labelmedium2" style="padding-left:3px">No</td>
		</tr>
	</table>	
    </td>
    </tr>
	
	<TR class="labelmedium2">
    <td>Default Tax:</b></td>
    <TD>
		<input type="Text"
	       name="TaxDefault"
	       id="TaxDefault"
	       value="#TaxDefault*100#"
	       validate="float"
	       required="Yes"
	       visible="Yes"
		   style="text-align:center"
		   class="regularxl"
	       enabled="Yes"
	       size="4"
	       maxlength="6"> %
	</td>
    </tr>
	
	<TR class="labelmedium2">
    <td><cf_UIToolTip tooltip="Default setting when recording quotes">Tax Included in Quote:</cf_UIToolTip></b></td>
    <TD><table>
	    <tr class="labelmedium2">
		<td><input type="radio" class="radiol" name="DefaultTaxIncluded" id="DefaultTaxIncluded" <cfif DefaultTaxIncluded eq "1">checked</cfif> value="1"></td><td class="labelmedium2" style="padding-left:3px">Yes</td>
		<td style="padding-left:4px"><input type="radio" class="radiol" name="DefaultTaxIncluded" id="DefaultTaxIncluded" <cfif DefaultTaxIncluded eq "0">checked</cfif> value="0"></td><td class="labelmedium2" style="padding-left:3px">No</td>
		</tr>
	</table>	
    </td>
    </td>
    </tr>	
			
	<TR class="labelmedium2">
    <td>Buyer Label:</b></td>
    <TD>
	    <input class="regularxl" type="Text" name="BuyerDescription" id="BuyerDescription" value="<cfif BuyerDescription eq "">Buyer<cfelse>#BuyerDescription#</cfif>" size="30" maxlength="30">
     </td>
    </tr>
	
	<TR class="labelmedium2">
    <td>Job Reference Name:</b></td>
    <TD>
	    <input class="regularxl" type="Text" name="JobReferenceName" id="JobReferenceName" value="<cfif JobReferenceName eq "">CaseNo<cfelse>#JobReferenceName#</cfif>" size="15" maxlength="15">
     </td>
    </tr>
	
	<cfquery name="Address" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     *
		FROM         Ref_AddressType	
	</cfquery>	
		
	<TR class="labelmedium2">
    <td>RFQ Mailing address:</b></td>
    <TD>		
		<select name="AddressTypeRFQ" id="AddressTypeRFQ" class="regularxl">
			<option value="">N/A</option>
			<cfloop query="Address">
				<option value="#Code#" <cfif evaluate("get.AddressTypeRFQ") eq Code>selected</cfif>>#Description#</option>
			</cfloop>
		</select>
				
	</td>
	</tr>		
	
	<tr class="labelmedium2">
	<td style="padding-top:6px" valign="top">
	<cf_UIToolTip tooltip="<b>Attention:</b><br>Adding a user account will mean that a requisition after it has been reviewed <br> will go straight to the buyer for Job processing and will skip the buyer assignment process.">
	Default Buyer
	</cf_UIToolTip>
	</td>
	<cfif url.period neq "">
		<td>
			<cfinclude template="ParameterEditJobEntryClass.cfm">
		</td>
	<cfelse>
		<td style="color:red">
			<cf_tl id="Alert: a default period has not been defined for entity ">#url.mission#.
		</td>
	</cfif>
	</tr>
			
	<cfquery name="Award" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     *
		FROM       Ref_Award	
	</cfquery>
	
	<TR class="labelmedium2">
	<cf_UIToolTip tooltip="Default code used for by the system determined lowest bid.">
	<td class="labelmedium2"><cf_tl id="Lowest Bid"></td>
	</cf_UIToolTip>
    <TD class="labelmedium2">
	<select name="AwardLowestBid" id="AwardLowestBid" class="regularxl">
	<cfloop query="Award">
	<option value="#Code#" <cfif get.AwardLowestBid eq Code>selected</cfif>>#Code#: #Description#</option>
	</cfloop>
	</select>
    </td>
    </tr>
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr><td colspan="2" align="center" height="34">
			<input type="submit" name="Save" id="Save" value="Apply" class="button10g" style="width:140px">			
	</td></tr>
					
	</table>	
			
	</cfform>	
		
</cfoutput>

