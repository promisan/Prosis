
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

<cfform action="ParameterSubmitReceipt.cfm?mission=#URL.mission#"
        method="POST"
        name="receiptbox">	
		
<cfoutput query="Get">

<table width="92%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">
	
				
    <TR>
    <td width="190" class="labelmedium">Prefix/LastNo:</b></td>
    <TD>
 		<input type="text" class="regularxl" name="ReceiptPrefix" id="ReceiptPrefix" value="#ReceiptPrefix#" size="6" maxlength="4" style="text-align: right;">
		<input type="text" class="regularxl" name="ReceiptSerialNo" id="ReceiptSerialNo" value="#ReceiptSerialNo#" size="6" maxlength="6" style="text-align: right;">
    </TD>
	</TR>
	
	<TR>
    <td class="labelmedium">Print Template:</b></td>
    <TD>
  	    <cfinput class="regularxl" type="Text" name="ReceiptTemplate" value="#ReceiptTemplate#" message="Please enter a directory name" required="No" size="80" maxlength="80">
    </TD>
	</TR>
	
	<TR>
    <td class="labelmedium"><cf_UIToolTip tooltip="Turn off/on the workflow for procurement jobs">Receipt Workflow:</b></cf_UIToolTip></b></td>
   	
	 <TD width="80%">
		
		    <cfdiv bind="url:#SESSION.root#/system/entityAction/EntityFlow/EntityAction/EntityStatus.cfm?mission=#url.mission#&entitycode=ProcReceipt" 
			  id="wfProcReceipt">
		
			</td>
	 </tr>
	
		
	<TR>
    <td class="labelmedium"><cf_UIToolTip tooltip="Allow receipts prior to approval of the purchase order">Receipt Prior Approval:</cf_UIToolTip></b></td>
    <TD>
		<table>
			<tr>
			<td><input type="radio" class="radiol" name="ReceiptPriorApproval" id="ReceiptPriorApproval" <cfif #ReceiptPriorApproval# eq "1">checked</cfif> value="1"></td>
			<td style="padding-left:4px" class="labelmedium">Enabled</td>
			<td style="padding-left:9px"><input type="radio" class="radiol" name="ReceiptPriorApproval" id="ReceiptPriorApproval" <cfif #ReceiptPriorApproval# eq "0">checked</cfif> value="0"></td>
			<td style="padding-left:4px" class="labelmedium">Disabled</td>
			</tr>
		</table>
	</td>
    </tr>
	
	<TR>
    <td class="labelmedium">Label Custom Entry 1:</b></td>
    <TD>
	
	<input type="text" class="regularxl" name="ReceiptReference1" id="ReceiptReference1" value="#Ref.ReceiptReference1#" size="30" maxlength="30">
		
    </td>
    </tr>
	
	<TR>
    <td class="labelmedium">Label Custom Entry 2:</b></td>
    <TD>
	
	<input type="text" class="regularxl" name="ReceiptReference2" id="ReceiptReference2" value="#Ref.ReceiptReference2#" size="30" maxlength="30">
		
    </td>
    </tr>
	
	<TR>
    <td class="labelmedium">Label Custom Entry 3:</b></td>
    <TD>
	
	<input type="text"  class="regularxl" name="ReceiptReference3" id="ReceiptReference3" value="#Ref.ReceiptReference3#" size="30" maxlength="30">
		
    </td>
    </tr>
	
	
	<TR>
    <td class="labelmedium">Label Custom Entry 4:</b></td>
    <TD>
	
	<input type="text" class="regularxl" name="ReceiptReference4" id="ReceiptReference4" value="#Ref.ReceiptReference4#" size="30" maxlength="30">
		
    </td>
    </tr>
	
	<tr><td class="line" colspan="2"></td></tr>
	
	<tr><td colspan="2" align="center" height="34">
		
			<input type="submit" name="Save" id="Save" value="Apply" class="button10g">	
		
	</td></tr>
			
	</table>	

</cfoutput>	

</cfform>