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
<cf_screentop height="100%" scroll="no" html="no" line="no">

<cfquery name="Item" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Category 
	WHERE  Category = '#URL.ID1#' 
</cfquery>
 
<cfquery name="Ledger" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_AreaGledger
	ORDER BY ListingOrder
</cfquery>

<cfform action="RecordSubmit.cfm?idMenu=#url.idmenu#" method="POST" style="height:100%" name="category">

<cfoutput>

<cf_tl id = "Yes" var = "vYes">
<cf_tl id = "No" var = "vNo">

<cf_divscroll>

<table width="95%" align="center" class="formpadding">

    <!--- Field: Id --->
      
    <TR>
    <TD class="labelmedium2" width="350"><cf_space spaces="60"><cf_tl id="Id">:</TD>
    <TD class="labelmedium2">
	    <cfoutput>
		<input type="text" class="regularxxl" name="Category" id="Category" value="#URL.ID1#" size="20" maxlength="20" readonly>
		</cfoutput>
	</TD>
	</TR>
		
	<TR>
		<TD class="labelmedium2"><cf_tl id="Acronym">:&nbsp;</TD>  
		<TD class="labelmedium2">
		<cfinput type="Text" name="Acronym" value="#Item.Acronym#" message="Please enter a valid acronym" required="No" size="5" maxlength="2" class="regularxxl">
		</TD>
	</TR>
	
	   <!--- Field: Description --->
    <TR>
    <TD class="labelmedium2" valign="top" style="padding-top:5px"><cf_tl id="Description">:</TD>
    <TD class="labelmedium2">
			
	<cf_LanguageInput
			TableCode       = "Ref_Category" 
			Mode            = "Edit"
			Name            = "Description"
			Type            = "Input"
			Required        = "Yes"
			Value           = "#Item.Description#"
			Key1Value       = "#Item.Category#"
			Message         = "Please enter a description"
			MaxLength       = "40"
			Size            = "50"
			Class           = "regularxxl">
			
	    </TD>
	</TR>
		
	<tr><td height="4"></td></tr>
	<tr>
		<td colspan="2" class="labellarge"><cf_tl id="Supply Control Settings"></b></td>
	</tr>
	<tr><td colspan="3" class="line" height="1"></td></tr>
	<tr><td height="3"></td></tr>
		
	<TR>
    <TD valign="top" style="padding-left:10px;padding-top:6px" class="labelmedium2"><cf_tl id="Stock Management Mode">: </font> </TD>
    <TD class="labelmedium2" style="height:28">
		<table cellspacing="0" cellpadding="0" class="formpadding">
			<tr><td><input type="radio" class="radiol" name="StockControlMode" id="StockControlMode" value="Stock" <cfif Item.StockControlMode eq "Stock">checked</cfif>></td>
			    <td style="padding-left:4px" class="labelmedium2"><cf_tl id="Accumulated stock"> <font color="808080">[<cf_tl id="Warehouse">|<cf_tl id="Location">|<cf_tl id="Item">|<cf_tl id="UoM">|<cf_tl id="Lot">]</td></tr>
			<tr><td><input type="radio" class="radiol" name="StockControlMode" id="StockControlMode" value="Individual" <cfif Item.StockControlMode eq "Individual">checked</cfif>></td>
			    <td style="padding-left:4px" class="labelmedium2"><cf_tl id="Individual"></td></tr>
			<tr><td colspan="2" class="labelit"><font color="808080">Receipt transaction is used incrementally, which allows you to track individual stock, example a roll which is used subsequentlly</td></tr>
		</table>
	</TD>
	</TR>	
	
	<TR>
    <TD class="labelmedium2" style="padding-left:10px;"><cf_tl id="Finished Product"> (<cf_tl id="WorkOrder">): </font> </TD>
    <TD class="labelmedium2" style="height:28">
	<table cellspacing="0" cellpadding="0" class="formpadding">
		<tr>
		<td style="padding-left:3px"><input type="radio" class="radiol" name="FinishedProduct" id="FinishedProduct" value="0" <cfif Item.FinishedProduct eq "0" or Item.FinishedProduct eq "">checked</cfif>></td><td style="padding-left:4px" class="labelmedium2"><cf_tl id="No"></td>
		<td style="padding-left:13px"><input type="radio" class="radiol" name="FinishedProduct" id="FinishedProduct" value="1" <cfif Item.FinishedProduct eq "1">checked</cfif>></td><td style="padding-left:4px" class="labelmedium2"><cf_tl id="Yes"></td>
		</tr></table>
	</TD>
	</TR>
	 		
	<!--- Field: This is a special field for the transfer to show more or less fields to be recorded --->
	
	<cfquery name="Val" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     *
		FROM       Ref_Valuation
		WHERE      Operational = 1
	</cfquery>
	
	<!--- Field: This is a special field to define the standard valuation code for new items created
	under this category --->
		
	<TR>
    <td class="labelmedium2" style="padding-left:10px;"><cf_tl id="Default COGS Calculation">: <font color="FF0000">*</font></td>
    <TD>
	<select name="ValuationCode" id="ValuationCode" class="regularxxl">
	<cfloop query="Val">
	<option value="#Code#" <cfif Item.ValuationCode eq Code>selected</cfif>>#Description#</option>
	</cfloop>
	</select>
    </td>
    </tr>
	 
	<tr>
		<td class="labelmedium2" style="padding-left:10px;"><cf_tl id="Transaction Mode">:</td>
		<td class="labelmedium2">
			<select name="DistributionMode" id="DistributionMode" class="regularxxl">
				<option value="Standard" <cfif lcase(Item.DistributionMode) eq "standard">selected</cfif>><cf_tl id="Standard">
				<option value="Meter" <cfif lcase(Item.DistributionMode) eq "meter">selected</cfif>><cf_tl id="Show Meter">				
			</select>
		</td>
	</tr>
	
	
	<!--- Field: This is a special search filter (Fuel) to limit issuances of stock for items 
	that belong to this category only to asset items that are enabled for the issueing warehouse --->
	
    <TR>
    <TD style="padding-right:10px;padding-left:10px" class="labelmedium2"><cf_tl id="Issuance (Fuel Management) to Facility assigned assets">:</TD>
    <TD class="labelmedium2" style="height:28">
	<table cellspacing="0" cellpadding="0" class="formpadding">
		<tr>
		<td style="padding-left:3px"><input type="radio" class="radiol" name="DistributionFilter" id="DistributionFilter" value="0" <cfif Item.DistributionFilter eq "0" or Item.DistributionFilter eq "">checked</cfif>></td><td style="padding-left:4px" class="labelmedium2">#vNo#</td>
		<td style="padding-left:3px"><input type="radio" class="radiol" name="DistributionFilter" id="DistributionFilter" value="1" <cfif Item.DistributionFilter eq "1">checked</cfif>></td><td style="padding-left:4px" class="labelmedium2">#vYes#</td>
		</tr></table>
	</TD>
	</TR>
	
	<tr><td height="12"></td></tr>
	<tr>
		<td colspan="2" class="labellarge"><cf_tl id="Asset and Miscellaneous Settings"></b></td>
	</tr>
	<tr><td colspan="3" class="line" height="1"></td></tr>
 
    <!--- Field: Initial review --->
    <TR>
    <TD class="labelmedium2" style="padding-left:10px;"><cf_tl id="Initial review Request"> (<cf_tl id="Pickticket">):</TD>
    <TD class="labelmedium2" style="height:28">
	    <table cellspacing="0" cellpadding="0" class="formpadding">
		<tr>
		<td style="padding-left:3px"><input type="radio" class="radiol" name="InitialReview" id="InitialReview" value="0" <cfif Item.InitialReview eq "0" or Item.InitialReview eq "">checked</cfif>></td><td style="padding-left:4px" class="labelmedium2">#vNo#</td>
		<td style="padding-left:13px"><input type="radio" class="radiol" name="InitialReview" id="InitialReview" value="1" <cfif Item.InitialReview eq "1">checked</cfif>></td><td style="padding-left:4px" class="labelmedium2">#vYes#</td>
		</tr></table>
	</TD>
	</TR>	
	
	<!--- Field: Commision Management --->
    <TR>
    <TD style="padding-right:10px;padding-left:10px" class="labelmedium2"><cf_tl id="Commission Mode"> (<cf_tl id="Sale">):</TD>
    <TD class="labelmedium2" style="height:28">
	<table cellspacing="0" cellpadding="0" class="formpadding">
		<tr>
		<td style="padding-left:3px"><input type="radio" class="radiol" name="CommissionMode" id="CommissionMode" value="0" <cfif Item.CommissionMode eq "0" or Item.VolumeManagement eq "">checked</cfif>></td><td style="padding-left:4px" class="labelmedium2">#vNo#</td>
		<td style="padding-left:13px"><input type="radio" class="radiol" name="CommissionMode" id="CommissionMode" value="1" <cfif Item.CommissionMode eq "1">checked</cfif>></td><td style="padding-left:4px" class="labelmedium2">#vYes#</td>
		</tr>
	</table>
	</TD>
	</TR>
	
	<!--- Field: Volume Management --->
    <TR>
    <TD style="padding-right:10px;padding-left:10px" class="labelmedium2"><cf_tl id="Enable Volume Management">:</TD>
    <TD class="labelmedium2" style="height:28">
	<table cellspacing="0" cellpadding="0" class="formpadding">
		<tr>
		<td style="padding-left:3px"><input type="radio" class="radiol" name="VolumeManagement" id="VolumeManagement" value="0" <cfif Item.VolumeManagement eq "0" or Item.VolumeManagement eq "">checked</cfif>></td><td style="padding-left:4px" class="labelmedium2">#vNo#</td>
		<td style="padding-left:13px"><input type="radio" class="radiol" name="VolumeManagement" id="VolumeManagement" value="1" <cfif Item.VolumeManagement eq "1">checked</cfif>></td><td style="padding-left:4px" class="labelmedium2">#vYes#</td>
		</tr></table>
	</TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2" style="padding-left:10px;"><cf_tl id="Equipment sensitivity Level"> (<cf_tl id="Access">): </font> </TD>
    <TD class="labelmedium2" style="height:28">
	<table cellspacing="0" cellpadding="0" class="formpadding">
		<tr>
		<td style="padding-left:3px"><input type="radio" class="radiol" name="SensitivityLevel" id="SensitivityLevel" value="0" <cfif Item.SensitivityLevel eq "0" or Item.SensitivityLevel eq "">checked</cfif>></td><td style="padding-left:4px" class="labelmedium2"><cf_tl id="Low"></td>
		<td style="padding-left:6px"><input type="radio" class="radiol" name="SensitivityLevel" id="SensitivityLevel" value="1" <cfif Item.SensitivityLevel eq "1">checked</cfif>></td><td style="padding-left:4px" class="labelmedium2"><cf_tl id="High"></td>
		</tr></table>
	</TD>
	</TR>
	
	 <!--- Field: tabOrder --->
	 <TR>
		 <TD class="labelmedium2" style="padding-left:10px;"><cf_tl id="Tab Order">:</TD>  
		 <TD class="labelmedium2">
		 	<cfinput type="Text" name="tabOrder" value="#Item.tabOrder#" message="Please enter a numeric Tab Order" style="text-align:center" validate="integer" required="No" size="2" maxlength="3" class="regularxxl">
		 </TD>
	 </TR>
	 
	 <!--- Field: icon --->
	 <TR>
		 <TD class="labelmedium2" style="padding-left:10px;"><cf_tl id="Image">:</TD>  
		 <TD class="labelmedium2">
		   <table cellspacing="0" cellpadding="0"><tr><td class="labelmedium2">
		    #SESSION.root#/Custom/
			</td>
		 	<cfset iconDirectory = "Custom/">
			<td style="padding-left:4px">
		 	<cfinput type="Text" 
				name="tabIcon" 
				value="#Item.tabIcon#" 
				message="Please enter a Tab Icon" 
				onblur= "ptoken.navigate('CollectionTemplate.cfm?template=#iconDirectory#'+this.value+'&container=iconValidationDiv&resultField=validateIcon','iconValidationDiv')"
				required="No" 
				size="60" 
				maxlength="60" 
				class="regularxxl">										
			</td>
			<td style="padding-left:4px">
		 	<cf_securediv id="iconValidationDiv" bind="url:CollectionTemplate.cfm?template=#iconDirectory##Item.tabIcon#&container=iconValidationDiv&resultField=validateIcon">				
			</td></tr></table>
		 </td>
	</TR>
	
	<!--- Field: icon --->
	 <TR>
		 <TD class="labelmedium2" style="padding-left:10px;"><cf_tl id="Image">:</TD>  
		 <TD class="labelmedium2">
		   <table cellspacing="0" cellpadding="0"><tr><td class="labelmedium2">
		    #SESSION.root#/Custom/
			</td>
		 	<cfset iconDirectory = "Custom/">
			<td style="padding-left:4px">
		 	<cfinput type="Text" 
				name="Image" 
				value="#Item.Image#" 
				message="Please enter a Tab Icon" 
				onblur= "ptoken.navigate('CollectionTemplate.cfm?template=#iconDirectory#'+this.value+'&container=iconValidationDiv&resultField=validateIcon','iconValidationDiv')"
				required="No" 
				size="60" 
				maxlength="60" 
				class="regularxxl">										
			</td>
			<td style="padding-left:4px">
		 	<cf_securediv id="iconValidationDiv" bind="url:CollectionTemplate.cfm?template=#iconDirectory##Item.tabIcon#&container=iconValidationDiv&resultField=validateIcon">				
			</td></tr></table>
		 </td>
	</TR>
	
	<tr><td colspan="3" class="line"></td></tr>
		
	<tr>
		<td colspan="3" align="center" height="25">
			<input type="submit" class="button10g" style="width:150;height:25"name="Update" id="Update" value=" Save " onclick="return validateFileFields();">
		</td>
	</tr>

</TABLE>

</cf_divscroll>

</cfoutput>

</CFFORM>