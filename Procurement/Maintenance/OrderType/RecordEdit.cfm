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

<cfparam name="url.idmenu" default="">
 
<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  banner="gray" 
			  label="Purchase Order Type" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
 
<cfquery name="Get" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_OrderType
	WHERE Code = '#URL.ID1#'
</cfquery>

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<table width="92%" align="center" class="formpadding formspacing">

	<tr><td height="5"></td></tr>
		
    <cfoutput>
	<!--- Field: Code--->
	 <TR>
	 <TD class="labelmedium2" width="15%" width="150">Code:</TD>  
	 <TD>
	 	<input type="Text" name="Code" id="Code" value="#get.Code#" size="20" maxlength="20" class="regularxxl">
		<input type="hidden" name="CodeOld" id="CodeOld" value="#get.Code#" size="20" maxlength="20"class="regularxl">
	 </TD>
	 </TR>
	  
	 	
	<!--- Field: Description --->
    <TR>
    <TD class="labelmedium2">Description:</TD>
    <TD>
  	  	<input type="Text" name="Description" id="Description" value="#get.Description#" message="Please enter a description" required="Yes" size="30" maxlength="50" class="regularxxl">
				
    </TD>
	</TR>
	
	<tr><td></td><td colspan="1" class="labelit"><font color="808080">For this purchase order type a delivery tracking dialog will be available for the RI unit to update (mostly used for oversees delivery tracking)</td></tr>	
			
	<!--- Field: Enable Finance Flow--->
	<TR>
    <td class="labelmedium2">Finance flow:</td>
	<td class="labelmedium2">
  	  <input type="radio" class="radiol" name="EnableFinanceFlow" id="EnableFinanceFlow" value="1" <cfif Get.EnableFinanceFlow eq "1">checked</cfif>>Yes
	  <input type="radio" class="radiol" name="EnableFinanceFlow" id="EnableFinanceFlow" value="0" <cfif Get.EnableFinanceFlow eq "0">checked</cfif>>No
    </TD>
	</TR>
	
	<tr><td height="1" colspan="2" class="linedotted"></td></tr>

	
	<!--- Field: Tracking --->	
	<TR>
    <td class="labelmedium">Purchase clause:</td>
	<td>
	
		<cfquery name="Clause"
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *, (Select ClauseCode 
			           FROM Ref_OrderTypeClause
					   WHERE ClauseCode = L.Code
					   AND OrderType = '#URL.ID1#') as Selected 
			FROM   Ref_Clause L	
			WHERE  Operational = 1 
		</cfquery>
		
		<table cellspacing="0" cellpadding="0" class="labelmedium formpadding">
		<cfset row = 0>
		<cfloop query="Clause">
		<cfset row = row+1>
		<cfif row eq "1"><tr class="labelmedium"><cfelse><td>&nbsp;</td></cfif>				
		<td style="padding-left:10px" class="labelmedium">#Code#.&nbsp;</td>
		<td class="labeit" style="padding-right:4px">#ClauseName#</td>
		<td style="padding-right:10px"><input type="checkbox" class="radiol" name="ClauseSelect" id="ClauseSelect" value="#Code#" <cfif selected neq "">checked</cfif>></td>
		<cfif row eq "2"></tr><cfset row = 0></cfif>
		</cfloop>
		</table>	
	
  	</TD>
	</TR>
	
	<tr><td height="1" colspan="2" class="linedotted"></td></tr>

	<!--- Field: Invoice Only--->
	<TR>
    <td class="labelmedium">Invoice Mode:</td>
	<td class="labelmedium">
  	  <input type="radio" class="radiol" name="invoiceworkflow" id="invoiceworkflow" value="1" <cfif Get.invoiceworkflow eq "1">checked</cfif>>Yes, with workflow
	  <input type="radio" class="radiol" name="invoiceworkflow" id="invoiceworkflow" value="0" <cfif Get.invoiceworkflow eq "0">checked</cfif>>Yes, but no workflow
	  <input type="radio" class="radiol" name="invoiceworkflow" id="invoiceworkflow" value="9" <cfif Get.invoiceworkflow eq "9">checked</cfif>>Disabled, only receipt
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
	
	<tr><td></td><td colspan="1" class="labelmedium"><font color="808080">You MUST ! enable this option in case the option receipt (below)
	is set to [No] which indicates a so-called INVOICE only mode.</td></tr>
	
	<tr><td height="1" colspan="2" class="linedotted"></td></tr>
	
	
	<!--- Field: Tracking --->	
	<TR>
    <td class="labelmedium">Delivery tracking:</td>
	<td class="labelmedium">
  	  <input type="radio" class="radiol" name="Tracking" id="Tracking" value="1" <cfif Get.Tracking eq "1">checked</cfif>>Yes
	  <input type="radio" class="radiol" name="Tracking" id="Tracking" value="0" <cfif Get.Tracking eq "0">checked</cfif>>No
    </TD>
	</TR>
		

	
	<!--- Field: Tracking --->	
	<TR>
    <td class="labelmedium" width="25%">Receipt mode:</td>
	<td class="labelmedium">
	  <input type="radio" class="radiol" name="receiptentry" id="receiptentry" value="0" <cfif Get.ReceiptEntry eq "0">checked</cfif> onclick="document.getElementById('receiptdetail').className='hide';document.getElementById('receipt').className='regular'">Default RI
  	  <input type="radio" class="radiol" name="receiptentry" id="receiptentry" value="1" <cfif Get.ReceiptEntry eq "1">checked</cfif> onclick="document.getElementById('receiptdetail').className='regular';document.getElementById('receipt').className='regular'">Receipt entry form	  
	  <input type="radio" class="radiol" name="receiptentry" id="receiptentry" value="9" <cfif Get.ReceiptEntry eq "9">checked</cfif> onclick="toggle('9');document.getElementById('receiptdetail').className='hide';document.getElementById('receipt').className='hide'">No Receipt Registration (invoice only)
    </TD>
	</TR>
	
	<cfif Get.ReceiptEntry eq "1">
	  <cfset cl = "regular">
	<cfelse>
	  <cfset cl = "hide">
	</cfif>  
	
	<!--- Field: Tracking --->	
	<TR id="receiptdetail" class="#cl#">
    <td valign="top" style="padding-top:3px" class="labelmedium">Receipt Detail:</td>
	<td>
	<table cellspacing="0" cellpadding="0" class="formpadding">
 	<tr>
	<td class="labelmedium" style="padding-left:6px">Layout:</td>
	<td style="padding-left:3px">
		 <select name="receiptentryform" style="width:100px" id="receiptentryform" class="regularxl">
			  <option value="" <cfif get.ReceiptEntryForm eq "">selected</cfif>>No further details</option>
			  <option value="Fabric"  <cfif get.ReceiptEntryForm eq "Fabric">selected</cfif>>Fabric</option>			  
			  <option value="Standard"  <cfif get.ReceiptEntryForm eq "Standard">selected</cfif>>Standard</option>
			  <option value="Fuel"  <cfif get.ReceiptEntryForm eq "Fuel">selected</cfif>>Fuel</option>
		 </select>
	</td>	
		
	<td class="labelmedium" style="padding-left:6px">Entry Rows:</td> 
		 
	<td style="padding-left:3px">
  	  
		 <select name="receiptentrylines" style="width:100px" id="receiptentrylines" class="regularxl">
		 <cfloop index="itm" from="0" to="10">
			 <option value="#itm#" <cfif get.ReceiptEntryLines eq itm>selected</cfif>>#itm#</option>
		 </cfloop>
		 </select>
		 
	</td></tr>
	
	<tr>
	
	<td class="labelmedium" style="padding-left:6px">Financials:</td> 
		 
	<td style="padding-left:3px">
	
	     <select name="receiptprice" style="width:100px" id="receiptprice" class="regularxl">			 
			  <option value="0"  <cfif get.ReceiptPrice eq "0">selected</cfif>>Hide</option>
			  <option value="1"  <cfif get.ReceiptPrice eq "1">selected</cfif>>Show</option>
		 </select>
  	  
		 
	</td>
	
	<td class="labelmedium" style="padding-left:6px">Receipt time:</td> 
		 
	<td style="padding-left:3px">
	
	     <select name="ReceiptDeliveryTime" id="ReceiptDeliveryTime" style="width:100px" class="regularxl">			 
			  <option value="0"  <cfif get.ReceiptDeliveryTime eq "0">selected</cfif>>Hide</option>
			  <option value="1"  <cfif get.ReceiptDeliveryTime eq "1">selected</cfif>>Show</option>
		 </select>
  	  
		 
	</td></tr>
	
	</table>
	
    </TD>
	</TR>
		
	<tr><td></td><td colspan="1" class="labelit"><font color="808080">Enforce: For this purchase order type the R&I must add receipts against a purchase line value. Mostly used for -open- contracts. Default: If not selected the R&I records receipts against the purchase line quantity.</td></tr>
	
	<tr><td height="1" colspan="2" class="linedotted"></td></tr>
		
	<cfif Get.ReceiptEntry neq "9">
	  <cfset cl = "regular">
	<cfelse>
	  <cfset cl = "hide">
	</cfif>  
	
	<!--- Field: Enable Finance Flow--->
	<TR class="#cl#" id="receipt">
    <td class="labelmedium">Receipt value validation:</td>
	<td class="labelmedium">
		
  	  <input type="radio" class="radiol" name="ReceiptValueValidate" id="ReceiptValueValidate" value="1" <cfif Get.ReceiptValueValidate eq "1">checked</cfif>>Enabled
	  <input type="radio" class="radiol" name="ReceiptValueValidate" id="ReceiptValueValidate" value="0" <cfif Get.ReceiptValueValidate neq "1">checked</cfif>>Disabled, only quantity based receipt validation for default RI
    </TD>
	</TR>
	
	<TR class="#cl#" id="receipt">
    <td class="labelmedium">Receipt threshold:</td>
	<td class="labelmedium">
  	  <input type="input" class="regularxl" style="padding-right:7px;width:45px;text-align:right" maxlength="3" name="ReceiptValueThreshold" id="ReceiptValueThreshold" value="#Get.ReceiptValueThreshold#">&nbsp;%
    </TD>
	</TR>
		
	<TR class="#cl#" id="receipt">
    <td class="labelmedium">Receipt completion threshold:</td>
	<td class="labelmedium">
  	  <input type="input" class="regularxl" style="padding-right:7px;width:45px;text-align:right" maxlength="3" name="ReceiptValueComplete" id="ReceiptValueComplete" value="#Get.ReceiptValueComplete#">&nbsp;%
    </TD>
	</TR>
		
	<!--- Field: Missions --->	
	<TR>
    <td valign="top" style="padding-top:6px" class="labelmedium">Enabled for:</td>
	
	<td style="padding-left:0px">
  	  	<cfquery name="MissionList" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT 	P.*,
						(SELECT Mission 
						 FROM   Ref_OrderTypeMission 
						 WHERE  Code = '#get.code#' 
						 AND    Mission = P.Mission) as Selected
				FROM  	Ref_ParameterMission P
				WHERE Mission IN (SELECT Mission FROM Organization.dbo.Ref_MissionModule WHERE SystemModule = 'Procurement')
		</cfquery>
		
		<table cellspacing="0" cellpadding="0">
			<tr>
				<cfset cnt = 0>
				<cfset colNum = 5>
				<cfloop query="MissionList">
					<cfset cnt = cnt + 1>
					<cfset formattedMission = replace(mission,"-","","ALL")>
					<cfset formattedMission = replace(formattedMission," ","","ALL")>
					<td style="padding-left:10px" class="labelit">
						<input type="checkbox" name="mission_#formattedMission#" id="mission_#formattedMission#" <cfif selected eq mission>checked</cfif>>
					</td>
					<td class="labelit" style="padding-left:4px">#Mission#</td>
					<cfif cnt eq colNum>
						<cfset cnt = 0>
						</tr>
						<tr>
					</cfif>
				</cfloop>
			</tr>
		</table>
    </TD>
	</TR>
		
	</cfoutput>
	
		<cf_dialogBottom option="Edit" delete="Order Type">
	  	
</TABLE>

</CFFORM>

<cf_screenbottom layout="innerbox">
	