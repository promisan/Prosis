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
			  label="Edit Fund" 
			  layout="webapp" 
			  menuAccess="Yes"
			  banner="gray" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_Fund
WHERE Code = '#URL.ID1#'
</cfquery>

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

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this Fund?")) {
	return true 
	}	
	return false	
}	
</script>

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">
	
<table width="92%" align="center" class="formspacing formpadding">

	<tr><td height="5"></td></tr>
	
    <cfoutput>
    <TR class="labelmedium2">
    <td width="80">Code:</td>
    <TD>
		
	 <cfquery name="CountRec" 
      datasource="AppsProgram" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT Fund
      FROM Ref_AllotmentEditionFund
      WHERE Fund = '#get.Code#' 
     </cfquery>
	
	 <cfif CountRec.recordCount eq 0>
  	   <input type="text" name="Code" value="#get.Code#" size="4" maxlength="4" class="regularxxl">	  
	 <cfelse>   
	   <input type="text" name="Code" value="#get.Code#" size="4" maxlength="4" class="regularxxl" READONLY>
	 </cfif>	 
	 <input type="hidden" name="Codeold" value="#get.Code#" size="4" maxlength="4"class="regularxl">
	 
    </TD>
	</TR>
	
	
	<TR class="labelmedium2">
    <TD>Fund Type:</TD>
    <TD><select name="FundType" class="regularxxl">	  
	  	<cfloop query="FundType">
		   <option value="#Code#" <cfif code eq get.fundtype>selected</cfif>>#Description#</option>
		</cfloop>
		</select>
	</TD>
	</TR>
	
	
	<TR class="labelmedium2">
    <TD>Description:</TD>
    <TD>
  	   <cfinput type="text" name="Description" value="#get.Description#" message="please enter a description" requerided=  "yes" size="30" 
	   maxlenght = "50" class= "regularxxl">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Order listing:</TD>
    <TD>
  	   <cfinput type="Text" class="regularxxl" name="ListingOrder" value="#get.ListingOrder#"  message="Please enter a numeric value" validate="integer" required="Yes" size="2" maxlength="4">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Enforce funds availability:</TD>
    <TD>
	<input type="checkbox" class="radiol" name="VerifyAvailability" value="1" <cfif #get.VerifyAvailability# eq '1'>checked</cfif>>
	</TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Display in Statistics:</TD>
    <TD>
	<input type="checkbox" class="radiol" name="ControlView" value="1" <cfif #get.ControlView# eq '1'>checked</cfif>>
	</TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Enforce currency:</TD>
    <TD>
	    <select name="Currency"  class="regularxxl">
	    <option value="" selected>No</option>
	  	<cfloop query="Currency">
		   <option value="#Currency#" <cfif get.Currency eq Currency.Currency>selected</cfif>>#Currency#</option>
		</cfloop>
		</select>
		
	</TD>
	</TR>
		
	
	<TR class="labelmedium2">
    <TD>Funding mode:</TD>
    <TD>
	    <INPUT type="radio" class="radiol" name="FundingMode" value="Envelope" <cfif #get.FundingMode# eq 'Envelope'>checked</cfif>>Envelope
		<INPUT type="radio" class="radiol" name="FundingMode" value="Donor" <cfif #get.FundingMode# eq 'Donor'>checked</cfif>>Donor
		<INPUT type="radio" class="radiol" name="FundingMode" value="" <cfif #get.FundingMode# eq ''>checked</cfif>>N/A
	</TD>
	</TR>		
	
	</cfoutput>	
	
	<tr><td colspan="2" class="line"></td></tr>
	<tr>	
		<td colspan="2" align="center" height="30">
		<input class="button10g" type="button" name="Cancel" value="Cancel" onClick="window.close()">
		
		<cfquery name="get" 
	      datasource="AppsProgram" 
	      username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
	      SELECT TOP 1 Fund
	      FROM ProgramAllotmentDetail
	      WHERE Fund  = '#get.code#' 
	    </cfquery>
		
		<cfif get.recordcount eq "0">
	    <input class="button10g" type="submit" name="Delete" value="Delete" onclick="return ask()">
		</cfif>
    	<input class="button10g" type="submit" name="Update" value="Update">
		</td>	
	</tr>
				
</TABLE>

</CFFORM>


	