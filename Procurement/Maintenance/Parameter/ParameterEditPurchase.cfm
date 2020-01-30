
<cfquery name="Get" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_ParameterMission
	WHERE Mission = '#URL.Mission#' 
</cfquery>

<cfquery name="Ref" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_CustomFields
</cfquery>

<cfform action="ParameterSubmitPurchase.cfm?mission=#URL.mission#"
        method="POST"
        name="purchase">	
		
<cfoutput query="Get">

<table cellspacing="0" cellpadding="0" width="93%" align="center">

<tr><td>

<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
			
    <TR>
    <td width="180" class="labelmedium">Prefix/LastNo:</b></td>
    <TD>
 		<input type="text" class="regularxl" name="PurchasePrefix" id="PurchasePrefix" value="#PurchasePrefix#" size="4" maxlength="4" style="text-align: right;">
		<input type="text" class="regularxl" name="PurchaseSerialNo" id="PurchaseSerialNo" value="#PurchaseSerialNo#" size="4" maxlength="6" style="text-align: right;">
	</TD>
	</TR>
	
	<cfquery name="Tree" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_Mission
	WHERE     MissionStatus = '1'
	</cfquery>
	
	<TR>
    <td class="labelmedium">Vendor Tree:</b></td>
    <TD>
	<select name="TreeVendor" id="TreeVendor" class="regularxl">
	<option value="">-- select --</option>
	<cfloop query="Tree">
	<option value="#Mission#" <cfif get.TreeVendor eq mission>selected</cfif>>#Mission#</option>
	</cfloop>
	</select>
    </td>
    </tr>
	
	<TR>
    <td valign="top" style="padding-top:6px" class="labelmedium"><cf_UIToolTip tooltip="Payroll uploads will inherit this class">Payroll Obligation:</cf_UIToolTip></b></td>
    <TD>
		<table cellspacing="0" cellpadding="0" class="formpadding">
		
		<tr>
		<td class="labelmedium">Order class:</td>
		<td>
		<cfquery name="Class" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT     *
			FROM         Ref_OrderClass	  
			WHERE      Mission = '#URL.Mission#' or Mission is NULL   
		</cfquery>
		<select name="PayrollOrderClass" id="PayrollOrderClass" class="regularxl">
		<option value="">-- Select an order class --
		<cfloop query="Class">
		<option value="#Code#" <cfif get.PayrollOrderClass eq Code>selected</cfif>>#Description#</option>
		</cfloop>
		</select>
	    </td>
		</tr>
		<cfquery name="OrderType" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  *
			FROM    Ref_OrderType		
			WHERE   Mission = '#URL.Mission#' or Mission is NULL        
		</cfquery>
				
		<tr>
	    <td class="labelmedium"><cf_UIToolTip tooltip="Payroll uploads will inherit this class">Order Type:</cf_UIToolTip></b></td>
	    <TD>
		<select name="PayrollOrderType" id="PayrollOrderType" class="regularxl">
		<option value="">-- Select an order type --
		<cfloop query="OrderType">
		<option value="#Code#" <cfif get.PayrollOrderType eq Code>selected</cfif>>#Description#</option>
		</cfloop>
		</select>
	    </td>
	    </tr>
		
		</table>
	</td>
	</tr>
	
	<TR>
    <td class="labelmedium">Label Custom Entry Field 1:</b></td>
    <TD>
		<table cellspacing="0" cellpadding="0" style="formspacing">
		<tr><td>
			<input  class="regularxl" type="text" name="PurchaseReference1" id="PurchaseReference1" value="#Ref.PurchaseReference1#" size="20" maxlength="30">
		</td>
		<td>&nbsp;&nbsp;</td>
	    <td class="labelmedium">Label Custom Entry Field 2:</b></td>
		<td>&nbsp;&nbsp;</td>
	    <TD>
		
		   <input  class="regularxl" type="text" name="PurchaseReference2" id="PurchaseReference2" value="#Ref.PurchaseReference2#" size="20" maxlength="30">
			
	    </td>
	    </tr>
		</table>
	</td>
	</tr>
	
	<TR>
    <td class="labelmedium" >Label Custom Entry Field 3:</b></td>
    <TD>
	<table cellspacing="0" cellpadding="0" style="formspacing">
		<tr><td>
	
		<input  class="regularxl" type="text" name="PurchaseReference3" id="PurchaseReference3" value="#Ref.PurchaseReference3#" size="20" maxlength="30">
		
    	</td>
		<td>&nbsp;&nbsp;</td>
	    <td class="labelmedium">Label Custom Entry Field 4:</b></td>
		<td>&nbsp;&nbsp;</td>
	    <TD>
	
		<input class="regularxl" type="text" name="PurchaseReference4" id="PurchaseReference4" value="#Ref.PurchaseReference4#" size="20" maxlength="30">
		
	    </td>
    	</tr>
		
	</table>
	</td>
	</tr>	
	
	<TR>
    <td class="labelmedium">Default Custom field</td>
    <TD>
		<table>
		<tr>
		<td><input type="radio" class="radiol" regularxl name="PurchaseCustomField" id="PurchaseCustomField" <cfif PurchaseCustomField eq "">checked</cfif> value=""></td><td style="padding-left:4px">N/A</td>
		<td class="labelmedium" style="padding-left:4px"><input class="radiol" type="radio" name="PurchaseCustomField" id="PurchaseCustomField" <cfif PurchaseCustomField eq "1">checked</cfif> value="1"></td><td class="labelmedium" style="padding-left:4px">1</td>
		<td class="labelmedium" style="padding-left:4px"><input class="radiol" type="radio" name="PurchaseCustomField" id="PurchaseCustomField" <cfif PurchaseCustomField eq "2">checked</cfif> value="2"></td><td class="labelmedium" style="padding-left:4px">2</td>
		<td class="labelmedium" style="padding-left:4px"><input class="radiol" type="radio" name="PurchaseCustomField" id="PurchaseCustomField" <cfif PurchaseCustomField eq "3">checked</cfif> value="3"></td><td class="labelmedium" style="padding-left:4px">3</td>
		<td class="labelmedium" style="padding-left:4px"><input class="radiol" type="radio" name="PurchaseCustomField" id="PurchaseCustomField" <cfif PurchaseCustomField eq "4">checked</cfif> value="4"></td><td class="labelmedium" style="padding-left:4px">4</td>
		</tr>
		</table>
	</td>
    </tr>
	
	<TR>
    <td class="labelmedium" style="cursor: pointer;"><cf_UIToolTip  tooltip="Once enabled, you must nabled one or more Order classes">Express Purchase:</cf_UIToolTip></b></td>
    <TD class="labelmedium">
	<table cellspacing="0" cellpadding="0" class="formspacing">
	<tr>
	<td>
	<input type="radio" class="radiol" name="EnableExpressPurchase" id="EnableExpressPurchase" <cfif EnableExpressPurchase eq "1">checked</cfif> value="1"></td>
	<td class="labelmedium" style="padding-left:4px">Allow (define for Procurement Class)</td>
	</td>
	<td style="padding-left:7px">
	<input type="radio" class="radiol" name="EnableExpressPurchase" id="EnableExpressPurchase" <cfif EnableExpressPurchase eq "0">checked</cfif> value="0"></td>
	<td style="padding-left:4px" class="labelmedium">Disabled</td>
	</tr></table>
    </td>
    </tr>
	
	<TR>
    <td class="labelmedium" style="cursor: pointer;"><cf_UIToolTip  tooltip="Enforce purchase orders to be created that match the job vendor assignment">Purchase from single job:</cf_UIToolTip></b></td>
    <TD class="labelmedium">
	
		<table class="formspacing">
		<tr>
		<td><input type="radio" class="radiol" name="PurchaseFromSingleJob" id="PurchaseFromSingleJob" <cfif PurchaseFromSingleJob eq "1">checked</cfif> value="1"></td>
		<td class="labelmedium">Enforce</td>		
		<td style="padding-left:7px"><input type="radio" class="radiol" name="PurchaseFromSingleJob" id="PurchaseFromSingleJob" <cfif PurchaseFromSingleJob eq "0">checked</cfif> value="0"></td>
		<td class="labelmedium">Disabled</td>
		</tr>
		</table>
		
    </td>
    </tr>
			
	<TR>
    <td class="labelmedium" style="cursor: pointer;"><cf_UIToolTip  tooltip="TaxExemption will automatically deduct tax amounts from the purchase, invoice and receipt amounts recorded">Tax Exemption:</cf_UIToolTip></b></td>
    <TD class="labelmedium">
	<table class="formspacing">
		<tr>
		<td><input type="radio" class="radiol" name="TaxExemption" id="TaxExemption" <cfif TaxExemption eq "1">checked</cfif> value="1"></td>
		<td class="labelmedium">Yes</td>
		<td style="padding-left:7px"><input type="radio" class="radiol" name="TaxExemption" id="TaxExemption" <cfif TaxExemption eq "0">checked</cfif> value="0">
		<td class="labelmedium">No</td>
		</tr>
		</table>
    </td>
    </tr>
	
	<TR>
    <td class="labelmedium" valign="top" style="padding-top:3px">Add a Quoted Line <br>to a existing Purchase Order:</b></td>
    <TD style="padding:6px;border-left:1px solid gray">
	
		<table border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td class="labelmedium" style="padding-left:4px">Scope:</td>
		<td style="padding-left:4px"><input type="radio" class="radiol" name="AddToPurchaseMode" id="AddToPurchaseMode" <cfif AddToPurchaseMode eq "1">checked</cfif> value="1"></td>
		<td class="labelmedium" style="padding-left:4px">Issued by Same Buyer</td>
		<td style="padding-left:4px"><input type="radio" class="radiol" name="AddToPurchaseMode" id="AddToPurchaseMode" <cfif AddToPurchaseMode eq "0">checked</cfif> value="0"></td>
		<td class="labelmedium" style="padding-left:4px">Issued by Any Buyer</td>
	    </tr>	
		<TR>
		<td class="labelmedium" style="padding-left:4px">Status:</td>
	    <TD style="padding-left:4px">
			<input type="radio" class="radiol" name="AddToPurchaseAlways" id="AddToPurchaseAlways" <cfif AddToPurchaseAlways eq "1">checked</cfif> value="1"></td>
			<td class="labelmedium" style="padding-left:4px" style="padding-right:5px">Open and closed Purchase Orders</td>
		<td style="padding-left:4px">
	       <input type="radio" class="radiol" name="AddToPurchaseAlways" id="AddToPurchaseAlways" <cfif AddToPurchaseAlways eq "0">checked</cfif> value="0"></td>
		   <td class="labelmedium" style="padding-left:4px">Open Purchase Order only</td>
	   
	    </tr>
		<TR>
		<td class="labelmedium" style="padding-left:4px">Funding:</td>
	    <TD style="padding-left:4px">
			<input type="radio" class="radiol" name="AddToPurchaseFund" id="AddToPurchaseFund" <cfif AddToPurchaseFund eq "1">checked</cfif> value="1"></td>
			<td class="labelmedium" style="padding-left:4px">Same Object of Expenditure</td>
		<td style="padding-left:4px">
	       <input type="radio" class="radiol" name="AddToPurchaseFund" id="AddToPurchaseFund" <cfif AddToPurchaseFund eq "0">checked</cfif> value="0"></td>
		   <td class="labelmedium" style="padding-left:4px; padding-right:5px">Any Object Of Expenditure</td>   
	    </tr>	
		
		<TR>
		<td class="labelmedium" style="padding-left:4px">Period:</td>
	    <TD style="padding-left:4px">
			<input type="radio" class="radiol" name="AddToPurchasePeriod" id="AddToPurchasePeriod" <cfif AddToPurchasePeriod eq "1">checked</cfif> value="1"></td>
			<td class="labelmedium" style="padding-left:4px">Any Period</td>
		<td style="padding-left:4px">
	       <input type="radio" class="radiol" name="AddToPurchasePeriod" id="AddToPurchasePeriod" <cfif AddToPurchasePeriod eq "0">checked</cfif> value="0"></td>
		   <td class="labelmedium" style="padding-left:4px">Same Period</td>
	   
	    </tr>		
		</table>	
	
	</td>
	</tr>
	
	<tr><td height="5"></td></tr>	
	
	<TR>
    <td class="labelmedium">Edit Purchase Lines after Issuance:</b></td>
    <TD class="labelmedium">
		<table class="formspacing">
		<tr>
		<td><input type="radio" class="radiol" name="EditPurchaseAfterIssue" id="EditPurchaseAfterIssue" <cfif EditPurchaseAfterIssue eq "1">checked</cfif> value="1"></td>
    	<td class="labelmedium">Yes</td>	
		<td style="padding-left:7px"><input type="radio" class="radiol" name="EditPurchaseAfterIssue" id="EditPurchaseAfterIssue" <cfif EditPurchaseAfterIssue eq "0">checked</cfif> value="0"></td>
		<td class="labelmedium">No</td>
		</tr>
		</table>
    </td>
    </tr>
	
	<TR>
    <td class="labelmedium" style="cursor: pointer;"><cf_UIToolTip tooltip="Enable option to initiate a procurement execution request">Purchase Execution Request:</cf_UIToolTip></b></td>
    <TD class="labelmedium">
		<table class="formspacing">
		<tr>
		<td><input type="radio" class="radiol" name="EnableExecutionRequest" id="EnableExecutionRequest" <cfif EnableExecutionRequest eq "1">checked</cfif> value="1"></td>
		<td class="labelmedium">Yes</td>	
		<td style="padding-left:7px">
		<input type="radio" class="radiol" name="EnableExecutionRequest" id="EnableExecutionRequest" <cfif EnableExecutionRequest eq "0">checked</cfif> value="0"></td>
		<td class="labelmedium">No</td>
		</tr>
		</table>
    </td>
    </tr>
	
	<TR>
    <td class="labelmedium">Purchase Class Tracking:</b></td>
    <TD>
		<table class="formspacing">
		<tr>
		<td><input type="radio" class="radiol" name="EnablePurchaseClass" id="EnablePurchaseClass" <cfif EnablePurchaseClass eq "1">checked</cfif> value="1"></td>
		<td class="labelmedium">Yes</td>	
		<td style="padding-left:7px">
		<input type="radio" class="radiol" name="EnablePurchaseClass" id="EnablePurchaseClass" <cfif EnablePurchaseClass eq "0">checked</cfif> value="0">
		<td class="labelmedium">No</td>
		</tr>
		</table>	
    </td>
    </tr>
	
	<TR>
    <td class="labelmedium">Issued Purchase:</b></td>
    <TD class="labelmedium">
		may exceed requisition value by 
		<cfinput type="Text"
	       name="PurchaseExceed"
	       value="#PurchaseExceed#"
	       validate="float"
	       required="Yes"
	       visible="Yes"
		   style="text-align:center"
		   class="regularxl"
	       enabled="Yes"
	       size="2"
	       maxlength="6"> %
	</td>
    </tr>
				
	<!--- Field: Prosis Document Root --->
    <TR>
    <td class="labelmedium">Sub-Directory Attachment:</b></td>
    <TD>
  	    /<cfinput class="regularxl" type="Text" name="PurchaseLibrary" value="#PurchaseLibrary#" message="Please enter a directory name" required="Yes" size="30" maxlength="30">
    </TD>
	</TR>
	
   <TR>
    <td class="labelmedium">Default Print Template:</b></td>
    <TD>
  	    <cfinput class="regularxl" type="Text" name="PurchaseTemplate" value="#PurchaseTemplate#" message="Please enter a directory name" required="No" size="80" maxlength="90">
    </TD>
	</TR>	
	
	<cfquery name="Address" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     *
	FROM         Ref_AddressType	
	</cfquery>	
		
	<TR>
    <td class="labelmedium" height="30">Inherit Purchase Address:</b></td>
    <TD>
		<table cellspacing="0" cellpadding="0" class="formpadding">
		<tr>
			<cfloop index="itm" list="Invoice,Transport,Shipping" delimiters=",">
			<td>
			
			    <table>
				<tr><td class="labelmedium">&nbsp;#itm#:</td></tr>
				<tr><td>
					<select name="AddressType#itm#" id="AddressType#itm#" class="regularxl">
					<option value="">N/A</option>
					<cfloop query="Address">
					<option value="#Code#" <cfif evaluate("get.AddressType#itm#") eq Code>selected</cfif>>#Description#</option>
					</cfloop>
					</select>
				</td></tr>
				</table>
		    </td>
			</cfloop>
	    </tr>
		</table>
	</td>
	</tr>
	<tr><td class="linedotted" colspan="2"></td></tr>
	
	<tr><td colspan="2" align="center" height="34">
		
			<input type="submit" name="Save" id="Save" value="Apply" class="button10g">	
		
	</td></tr>
	
	</table>
	
</td></tr>

</table>	
		
</cfoutput>	

</cfform>