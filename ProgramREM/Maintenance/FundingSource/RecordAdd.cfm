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

<cfquery name="FundType" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_FundType
</cfquery>

<cfquery name="Currency" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Accounting.dbo.Currency
</cfquery>

<cf_screentop height="100%" 
			  label="Record Fund" 
			  layout="webapp" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- Entry form --->

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<table width="92%" align="center" class="formspacing formpadding">

	<tr><td height="5"></td></tr>
    <TR class="labelmedium2">
    <td width="80">Code:</td>
    <TD>
  	   <cfinput type="text" name="code" value="" message="Please enter a code" required="Yes" size="4" maxlength="4" class="regularxxl">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Fund Type:</TD>
    <TD><select name="FundType" class="regularxxl">	  
	  	<cfoutput query="FundType">
		   <option value="#Code#">#Description#</option>
		</cfoutput>
		</select>
	</TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Description:</TD>
    <TD>
  	   <cfinput type="text" name="Description" value="" message="Please enter a description" required="Yes" size="30" maxlength="50" class="regularxxl">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Order listing:</TD>
    <TD>
  	   <cfinput type="Text" name="ListingOrder" message="Please enter a numeric value" validate="integer" required="Yes" size="2" maxlength="2" class="regularxxl">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Enforce availability:</TD>
    <TD>
	  <input type="checkbox" class="radiol" name="VerifyAvailability" value="1" checked>
	</TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Display in Statistics:</TD>
    <TD>
	  <input type="checkbox" class="radiol" name="ControlView" value="0" checked>
	</TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Enforce currency:</TD>
    <TD><select name="Currency" class="regularxl">
	    <option value="" selected>No</option>
	  	<cfoutput query="Currency">
		   <option value="#Currency#">#Currency#</option>
		</cfoutput>
		</select>
	</TD>
	</TR>
			
	<TR class="labelmedium2">
    <TD>Funding mode:</TD>
    <TD>
	    <INPUT type="radio" class="radiol" name="FundingMode" value="Envelope" checked>Envelope
		<INPUT type="radio" class="radiol" name="FundingMode" value="Donor">Donor
		<INPUT type="radio" class="radiol" name="FundingMode" value="">N/A
	</TD>
	</TR>
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr>	
	<td colspan="2" align="center" height="30" valign="bottom">	
		
	<input class="button10g" type="button" name="Cancel" value="Cancel" onClick="window.close()">
    <input class="button10g"  type="submit" name="Insert" value="Submit">
	
	</td>	
	
	</tr>
		
</TABLE>

</CFFORM>

