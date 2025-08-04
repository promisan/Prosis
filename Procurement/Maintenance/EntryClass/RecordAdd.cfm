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
			  label="Add Entry Class" 
			  scroll="Yes" 
			  layout="webapp" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- Entry form --->

<CFFORM action="RecordSubmit.cfm?idmenu=#url.idmenu#&fmission=&id1=" method="post" name="dialog">

<table width="92%" align="center" class="formpadding">

	  <tr><td height="8"></td></tr>
   <!--- Field: Id --->
    <TR>
    <TD class="labelmedium2">Code:</TD>
    <TD class="labelmedium2">
		<cfinput type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="10" maxlength="10"
		class="regularxxl">
	</TD>
	</TR>
	
	   <!--- Field: Description --->
    <TR>
    <TD class="labelmedium2">Description:</TD>
    <TD class="labelmedium2">
		<cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="30" maxlength="30"
		class="regularxxl">
	</TD>
	</TR>
		
	 <!--- Field: Listing Order --->
    <TR>
    <TD class="labelmedium2">Mode:</TD>
    <TD>
	   <table width="100%" cellspacing="0" cellpadding="0">
	   <tr class="labelmedium2">
	   <td>
		<input type="radio" class="radiol" name="CustomDialog" id="CustomDialog" value="Materials" checked>Warehouse/Asset to be received as Stock
		</td>
		</tr>
		<tr class="labelmedium2">
		<td>
		<input type="radio" class="radiol" name="CustomDialog" id="CustomDialog" value="Contract">Staffing Position to be funded
		</td>
		</tr>
		<tr class="labelmedium2">
		<td>
		<input type="radio" class="radiol" name="CustomDialog" id="CustomDialog" value="Travel">Travel and/or SSA initiation
		</td>
		</tr>
		<tr class="labelmedium2">
		<td>
		<input type="radio" class="radiol" name="CustomDialog" id="CustomDialog" value="">Other services and/or goods
		</td>
		</tr>
		</table>
	</TD>
	</TR>
	
	   <!--- Field: Listing Order --->
    <TR>
    <TD class="labelmedium2">Listing Order:</TD>
    <TD class="labelmedium2">
		<cfinput type="Text" name="ListingOrder" value="" message="Please enter Listing Order" required="Yes" size="2" maxlength="2"
		class="regularxxl">
	</TD>
	</TR>
			
	
	 <!--- Field: Listing Order --->
    <TR class="labelmedium2">
    <TD>Template:</TD>
    <TD>
  	  	<input type="Text" name="RequisitionTemplate" id="RequisitionTemplate" value="" message="Please enter a template name" size="40" maxlength="60" class="regularxxl">
				
    </TD>
	</TR>	
	
	<tr><td height="3"></td></tr>
	
	<tr><td colspan="2" class="line"></td></tr>
	<tr>	
		<td align="center" colspan="2" height="30">
		<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
		<input class="button10g" type="submit" name="Insert" id="Insert" value=" Submit ">
		</td>
	</tr>
	    
</TABLE>

</CFFORM>


<cf_screenbottom layout="innerbox">
