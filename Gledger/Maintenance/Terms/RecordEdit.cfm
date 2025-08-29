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
			  label="Edit Terms" 
			  scroll="Yes" 
			  layout="webapp" 
			  banner="gray"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_Terms
WHERE Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask()

{
	if (confirm("Do you want to remove this record ?")) {
	
	return true 
	
	}
	
	return false
	
}	

</script>

<CFFORM action="RecordSubmit.cfm" method="post">

<!--- Entry form --->

	<table width="92%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	    <tr><td></td></tr>
	 	<TR class="labelmedium">
	    <TD class="labelit">Description:</TD>
	    <TD>
	  	    <cfinput type="Text" class="regularxl" name="Description" value="#get.Description#" message="Please enter a description" required="Yes" size="30" maxlength="50">
		    <input type="hidden" name="Code" value="<cfoutput>#get.Code#</cfoutput>">
	     </TD>
		</TR>
		
		<TR class="labelmedium">
	    <TD class="labelit">Net days:</TD>
	    <TD>
	  	    <cfinput type="Text" class="regularxl" name="PaymentDays" value="#get.PaymentDays#" message="Please enter net days" validate="integer" required="Yes" size="10" maxlength="10" style="text-align: right;">
	    </TD>
		</TR>
		
		<TR class="labelmedium">
	    <TD class="labelit">Discount days:</TD>
	    <TD>
	  	    <cfinput type="Text" class="regularxl" name="DiscountDays" value="#get.DiscountDays#" message="Please enter discount days" validate="integer" required="Yes" size="10" maxlength="10" style="text-align: right;">
	    </TD>
		</TR>
		
		<TR>
	    <TD class="labelmedium">Discount:</TD>
	    <TD>
	  	    <cfinput type="Text" class="regularxl" name="Discount" value="#get.Discount*100#" message="Please enter a percentage" validate="float" required="Yes" size="10" maxlength="10" style="text-align: right;">%
	    </TD>
		</TR>
		
		<tr><td colspan="2" height="3"></td></tr>
		<tr><td colspan="2" class="linedotted"></td></tr>
		
		<tr><td colspan="2" height="35" align="center">
		
			<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
			<input class="button10g" type="submit" name="Delete" value=" Delete " onclick="return ask()">
			<input class="button10g" type="submit" name="Update" value=" Update ">
	
		</td>
		
	</TABLE>
	
</CFFORM>


</BODY></HTML>