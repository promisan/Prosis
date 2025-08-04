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
			  label="Service Class" 			
			  scroll="Yes" 
			  layout="webapp" 
			  banner="blue" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<CFFORM action="RecordSubmit.cfm" method="post" name="dialog">

<!--- Entry form --->

<table width="95%" align="center" class="formpadding formspacing">

    <tr><td></td></tr>
   <!--- Field: Id --->
    <TR>
    <TD class="labelmedium2">Code:</TD>
    <TD>
		<cfinput type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="10" maxlength="10"
		class="regularxxl">
	</TD>
	</TR>
	
	   <!--- Field: Description --->
    <TR valign="top">
    <TD class="labelmedium2">Description:</TD>
    <TD>
		<cf_LanguageInput
			TableCode		= "ServiceItem"
			Mode            = "Edit"
			Name            = "Description"
			Id              = "Description"
			Type            = "Input"
			Value			= ""
			Required        = "Yes"
			Message         = "Please enter a description"
			MaxLength       = "100"
			Size            = "30"
			Class           = "regularxxl">
	</TD>
	</TR>		 		 	 
	
	   <!--- Field: Listing Order --->
    <TR>
    <TD class="labelmedium2">Listing Order:</TD>
    <TD>
		<cfinput type="Text" name="ListingOrder" value="" message="Please enter numeric Listing Order" required="Yes" size="2" 
		  maxlength="2" validate="integer" class="regularxxl">
	</TD>
	</TR>
	
	 <!--- Field: Operational --->
    <tr class="labelmedium2">
		<td>Operational:&nbsp;</td>
		<td colspan="3">
		<input type="radio" class="radiol" name="operational" id="operational" value="0">No
		<input type="radio" class="radiol" name="operational" id="operational" value="1" checked>Yes
		</td>
	</tr>	
		
	<tr><td height="3"></td></tr>
	
	<tr><td colspan="2" class="line"></td></tr>
	<tr>	
		<td align="center" colspan="2" height="30">
		<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
		<input class="button10g" type="submit" name="Insert" id="Insert" value=" Save ">
		</td>
	</tr>
	    
</TABLE>

</CFFORM>
