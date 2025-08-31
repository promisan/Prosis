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
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Purchase Order Type" 
			  option="Add a purchase order type" 
			  banner="yellow" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- Entry form --->

<CFFORM action="RecordSubmit.cfm" method="post" name="dialog">

<table width="92%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">
	
	<tr><td height="5"></td></tr>
	
	<tr><td colspan="2" class="labelit"><font color="808080">Job groups are a means to classify jobs. 
	Groups will also be used for workflow allowing to define deifferent actors for each group although the workflow follows the same pattern (class)
	</font>
	</td></tr>
	
	<tr><td height="5"></td></tr>
	

	<!--- Field: Code--->
	 <TR>
	 <TD class="labelmedium" width="20%">Code:&nbsp;</TD>  
	 <TD>
		<cfinput type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="20" maxlength="20"
		class="regularxxl">

	 </TD>
	 </TR>
	 
	 <!---
	 
	 <cfquery name="Mis" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_ParameterMission
		WHERE Mission IN (SELECT Mission 
                  FROM Organization.dbo.Ref_MissionModule 
				  WHERE SystemModule = 'Procurement')
	</cfquery>
	 
	 <TR>
	 <TD width="150">Entity:&nbsp;</TD>  
	 <TD>
	 	<select name="Mission" id="Mission">
		<option value="" selected>[Apply to all]</option>
		<cfoutput query="Mis">
		<option value="#Mission#">#Mission#</option>
		</cfoutput>
		</select>
	 </TD>
	 </TR>
	 
	 --->
	 
	
	<!--- Field: Description --->
    <TR>
    <TD class="labelmedium">Description:&nbsp;</TD>
    <TD>
		<cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="50" maxlength="50"
		class="regularxxl">
				
    </TD>
	</TR>
	
	

	<!--- Field: Invoice Only--->
	<TR>
    <td class="labelmedium2">Workflow Clearance Mode:</td>
	<td>
	  <table>
	  <tr class="labelmedium2">
	  <td><input class="radiol" type="radio"  name="invoiceworkflow" id="invoiceworkflow" value="1"></td><td style="padding-left:3px">Yes</td>
	  <td style="padding-left:3px"><input class="radiol" type="radio"  name="invoiceworkflow" id="invoiceworkflow" value="0"></td><td style="padding-left:3px">No</td>
	  </tr>
	  </table>
    </TD>
	</TR>
	
	<script>
	 function toggle(val) {
	 
	  se = document.getElementsByName("invoiceworkflow")
	 	  
	  if (val == 9) {	    
	     if (se[0].checked == false) {
		 se[0].click()
		 alert("Workflow mode has been enabled")
		 }
		 } else {		
		 }
	  
	 }
	</script>
	
	<tr><td colspan="2" class="labelit"><font color="808080">You MUST ! enable this option in case the option receipt (below)
	is set to [Disabled] which indicates a so-called invoice only mode.</td></tr>
	<tr><td class="line" colspan="2"></td></tr>
	
	<!--- Field: Tracking --->	
	<TR>
    <td class="labelmedium2">Enable receipt registration:</td>
	<td class="labelmedium2">
	  <input class="radiol" type="radio" name="receiptentry" id="receiptentry" value="0" checked>Default
  	  <input class="radiol" type="radio" name="receiptentry" id="receiptentry" value="1">Form Based Entry	 
	  <input class="radiol" type="radio" name="receiptentry" id="receiptentry" value="9" onclick="toggle('9')">Disable Receipts
    </TD>
	</TR>
		
	<tr><td colspan="2" class="labelit"><font color="808080">Enforce: For this purchase order type the R&I must add receipts against a purchase line value. Mostly used for -open- contracts. Default: If not selected the R&I records receipts against the purchase line quantity.</td></tr>
	
	<!--- Field: Enable Finance Flow--->
	<TR id="receipt">
    <td class="labelmedium2">Receipt Value validation:</td>
	<td>
  	  <input class="radiol" type="radio" name="ReceiptValueValidate" id="ReceiptValueValidate" value="1" checked>Yes
	  <input class="radiol" type="radio" name="ReceiptValueValidate" id="ReceiptValueValidate" value="0">No
    </TD>
	</TR>
	
	<TR  id="receipt">
    <td class="labelmedium2">Receipt threshold:</td>
	<td class="labelmedium2">
  	  <input type="input" class="regularxxl" style="padding-right:7px;width:35px;text-align:right" maxlength="3" name="ReceiptValueThreshold" id="ReceiptValueThreshold" value="">&nbsp;%
    </TD>
	</TR>
	
	<TR class="#cl#" id="receipt">
    <td class="labelmedium2">Close purchase receipt threshold:<cf_space spaces="70"></td>
	<td class="labelmedium2">
  	  <input type="input" class="regularxxl" style="width:40px;text-align:right" maxlength="3" name="ReceiptValueComplete" id="ReceiptValueComplete" value="100">%
    </TD>
	</TR>
	
	<!--- Field: Enable Finance Flow--->
	<TR>
    <td class="labelmedium2">Finance Flow:&nbsp;</td>
	<td>
  	   <input type="checkbox" class="radiol" name="EnableFinanceFlow" id="EnableFinanceFlow" value="1">
    </TD>
	</TR>
	
	<tr><td colspan="2" class="labelmedium2">Future usage</td></tr>
	<tr><td class="line" colspan="2"></td></tr>
	

	<!--- Field: Tracking --->	
	<TR>
    <td class="labelmedium2">Delivery Tracking:&nbsp;</td>
	<td>
  	   <input type="checkbox" class="radiol" name="Tracking" id="Tracking" value="1">
    </TD>
	</TR>
	
	<tr><td colspan="2" class="labelit" >For this purchase order type a delivery tracking dialog will be available for the RI unit to update (mostly used for oversees delivery tracking).</td></tr>
	<tr><td class="line" colspan="2"></td></tr>
	
	
	<!--- Field: Tracking --->	
	<TR>
    <td class="labelmedium2">Default Clause:</td>
	<td>
	
	<cfquery name="Clause"
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   Ref_Clause	L	
		WHERE  Operational = 1 
	</cfquery>
		
		<table>
		<cfset row = 0>
		<cfoutput query="Clause">
			<cfset row = row+1>
			<cfif row eq "1"><tr class="labelmedium2"><cfelse><td>&nbsp;</td></cfif>				
			<td>#Code#.&nbsp;</td>
			<td>#ClauseName#&nbsp;</td>
			<td><input type="checkbox" class="radiol" name="ClauseSelect" id="ClauseSelect" value="#Code#"></td>
			<cfif row eq "2"></tr><cfset row = 0></cfif>
		</cfoutput>
		</table>
	
	
  	</TD>
	</TR>
	
	<tr><td class="linedotted" colspan="2"></td></tr>
	
	<!--- Field: Missions --->	
	<TR>
    <td class="labelmedium2">Enabled for:</td>
	</tr>
	<tr>
	<td colspan="2" style="padding-left:20px">
  	  	<cfquery name="MissionList" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT 	*
				FROM  	Ref_ParameterMission
		</cfquery>
		<table width="100%">
			<tr>
				<cfset cnt = 0>
				<cfset colNum = 4>
				<cfoutput query="MissionList">
					<cfset cnt = cnt + 1>
					<cfset formattedMission = replace(mission,"-","","ALL")>
					<cfset formattedMission = replace(formattedMission," ","","ALL")>
					<td width="#100/colNum#%" class="labelmedium2" style="height:20px">
						<label>
							<input type="checkbox" name="mission_#formattedMission#" id="mission_#formattedMission#"> #Mission#
						</label>
					</td>
					<cfif cnt eq colNum>
						<cfset cnt = 0>
						</tr>
						<tr>
					</cfif>
				</cfoutput>
			</tr>
		</table>
    </TD>
	</TR>
	
	<cf_dialogBottom option="Add" delete="Order Type">
				 
</table>

</CFFORM>

<cf_screenbottom layout="innerbox">
