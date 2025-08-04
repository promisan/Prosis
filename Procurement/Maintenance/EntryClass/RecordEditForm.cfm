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
	FROM   Ref_EntryClass
	WHERE  Code = '#URL.ID1#'
</cfquery>

<cfquery name="CountRec" 
    datasource="AppsPurchase" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT    *
    FROM     ItemMaster
    WHERE    EntryClass = '#URL.ID1#'
 </cfquery>

<!--- edit form --->

<CFFORM action="RecordSubmit.cfm?idmenu=#url.idmenu#&fmission=#url.fmission#&id1=#url.id1#" method="post" name="dialog">

<table width="94%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

    <tr><td height="8"></td></tr>

	<cfoutput>
	<TR class="labelmedium">
	 <TD>Code:</TD>  
	 <TD>
	 	<input type="Text" name="Code" id="Code" value="#get.Code#" size="20" maxlength="10" class="regularxl">
		<input type="hidden" name="CodeOld" id="CodeOld" value="#get.Code#" size="20" maxlength="10" class="regular">
	 </TD>
	</TR>
	 
	 <!--- Field: Description --->
    <TR class="labelmedium">
    <TD>Description:</TD>
    <TD>
  	  	<input type="Text" name="Description" id="Description" value="#get.Description#" message="Please enter a description" required="Yes" size="40" maxlength="50" class="regularxl">				
    </TD>
	</TR>
	
	 <!--- Field: Listing Order --->
    <TR class="labelmedium">
    <TD>Listing Order:</TD>
    <TD>
  	  	<input type="Text" name="ListingOrder" id="ListingOrder" style="text-align:center" value="#get.ListingOrder#" message="Please enter a Listing Order" required="Yes" size="2" maxlength="2" class="regularxl">				
    </TD>
	</TR>	
	
	 <!--- Field: Listing Order --->
    <tr class="labelmedium">
    <TD valign="top"  style="padding-top:6px">Mode:</TD>
    <TD>
	   <table width="100%" cellspacing="0" cellpadding="0">
	   <tr><td class="labelmedium">
		<input type="radio" class="radiol" name="CustomDialog" id="CustomDialog" value="Materials" <cfif get.customdialog eq "Materials">checked</cfif>></td><td style="padding-left:4px">Warehouse/Asset to be received as Stock
		</td></tr>
		<tr><td class="labelmedium">
		<input type="radio" class="radiol" name="CustomDialog" id="CustomDialog" value="Contract" <cfif get.customdialog eq "Contract">checked</cfif>></td><td style="padding-left:4px">Staffing Position to be funded
		</td></tr>
		<tr><td class="labelmedium">
		<input type="radio" class="radiol" name="CustomDialog" id="CustomDialog" value="Travel" <cfif get.customdialog eq "Travel">checked</cfif>></td><td style="padding-left:4px">Consultant and/or Travel initiation
		</td></tr>
		<tr><td class="labelmedium">
		<input type="radio" class="radiol" name="CustomDialog" id="CustomDialog" value="" <cfif get.customdialog eq "">checked</cfif>></td><td style="padding-left:4px">Other services and/or goods
		</td>
		</tr>
		</table>
	</TD>
	</TR>
	
	 <!--- Field: Listing Order --->
    <TR>
    <TD class="labelit"><cf_UIToolTip  tooltip="Path/File name for the print template">Template:</cf_UIToolTip>&nbsp;</TD>
    <TD>
  	  	<input type="Text" name="RequisitionTemplate" id="RequisitionTemplate" value="#get.RequisitionTemplate#" message="Please enter a template name" size="40" maxlength="60" class="regularxl">				
    </TD>
	</TR>	
	
	<tr><td></td></tr>
	
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" align="center" height="30">
	<cfif CountRec.recordCount eq 0>
		<cfoutput>
			<input class="button10g" type="button" name="Delete" id="Delete" value=" Delete " onclick="purgeEntryClass('#url.id1#');">
		</cfoutput>
	</cfif>
	<input class="button10g" type="submit" name="Update" id="Update" value=" Save ">
	</td></tr>
	
</cfoutput>
    	
</TABLE>
</CFFORM>