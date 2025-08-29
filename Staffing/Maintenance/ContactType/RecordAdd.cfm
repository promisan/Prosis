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
			  label="Contact Type" 			  
			  scroll="Yes" 
			  layout="webapp" 
			  banner="blue" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<CFFORM action="RecordSubmit.cfm" method="post" name="dialog">

<!--- Entry form --->

<table width="95%" align="center" class="formpadding formspacing">

   <!--- Field: Id --->
    <TR>
    <TD class="labelmedium2">Code:</TD>
    <TD>
		<cfinput type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="20" maxlength="20"
		class="regularxxl">
	</TD>
	</TR>
	
	 <!--- Field: Description --->
    <TR>
    <TD class="labelmedium2">Description:&nbsp;</TD>
    <TD>
  	  	<cfinput type="Text" name="description" value="" message="Please enter a description" required="Yes" size="50" maxlength="50" class="regularxxl">
				
    </TD>
	</TR>	

	 <!--- Field: Mask --->
    <TR>
    <TD class="labelmedium2">Mask:&nbsp;</TD>
    <TD>
  	  	<cfinput type="Text" name="CallSignMask" value="" message="Please enter a CallSignMask" size="20" maxlength="20" class="regularxxl">
				
    </TD>
	</TR>	
	<TR>
		<TD></TD>
		<TD>
			<TABLE Width = "100%" >
			<tr>
				<td class="labelit">
				<i>Examples : A = [A-Za-z], A9 = [A-Za-z0-9], 9 = [0-9],  ? = Any character</i>
				</td>	
			</tr>
			</TABLE>
		</TD>
	</TR>	

	 <!--- Field: Self-Service ? --->
    <TR>
    <TD class="labelmedium2">Self Service:&nbsp;</TD>
    <TD class="labelmedium2">
  	  	<cfinput type="Radio" name="SelfService" value="0" checked ="yes">No
  	  	<cfinput type="Radio" name="SelfService" value="1">Yes
				
    </TD>
	</TR>	
	
	 <!--- Field: Listing Order --->
    <TR>
    <TD class="labelmedium2">Order:&nbsp;</TD>
    <TD>
  	  	<cfinput type="Text" name="ListingOrder" value="0" message="Please enter a display order" required="Yes" size="2" maxlength="2" class="regularxxl">		
    </TD>
	</TR>	
		
		
	<tr><td height="3"></td></tr>
	
	<tr><td colspan="2" class="line"></td></tr>
	<tr>	
		<td align="center" colspan="2" height="30">
		<input class="button10g" type="button" name="Cancel" value="Cancel" onClick="window.close()">
		<input class="button10g" type="submit" name="Insert" value="Save">
		</td>
	</tr>
	    
</TABLE>

</CFFORM>
