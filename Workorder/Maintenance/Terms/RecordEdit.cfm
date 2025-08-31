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

<cfquery name="Get" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	select *
	from Ref_Terms
	WHERE code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this record ?")) {	
	return true 	
	}	
	return false	
}	

</script>

<cf_screentop height="100%" label="Terms" layout="webapp" user="No">

<!--- edit form --->

<cfform action="RecordSubmit.cfm" 
		method="POST" 
		enablecab="Yes" 
		name="dialog" 
		menuAccess="Yes" 
		systemfunctionid="#url.idmenu#">

<table width="92%" align="center" class="formpadding">

	<tr><td height="6"></td></tr>
    <cfoutput>
    <TR class="labelmedium2">
    <TD>Code:</TD>
    <TD>
		#get.code#
	   <input type="hidden" name="CodeOld" id="CodeOld" value="#get.code#" size="20" maxlength="20" readonly>
    </TD>
	</TR>
	
	 <TR class="labelmedium2">
    <TD>Description:</TD>
    <TD>
  	   <input type="text" name="Description" id="Description" value="#get.Description#" size="30" maxlength="20" class="regularxxl">
	   
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Payment days:</TD>
    <TD>
  	   <cfinput type="Text" name="paymentDays" value="#get.paymentDays#" message="Please enter a number as payment day" required="Yes" validate="integer" size="10" maxlength="3" class="regularxxl">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Discount:</TD>
    <TD>
  	   <cfinput type="Text" name="discount" value="#get.discount#" message="Please enter a decimal number as discount" required="Yes" validate="float" size="10" maxlength="6" class="regularxxl">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Discount days:</TD>
    <TD>
  	   <cfinput type="Text" name="discountDays" value="#get.discountDays#" message="Please enter a number as discount day" required="Yes" validate="integer" size="10" maxlength="3" class="regularxxl">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Operational:</TD>
    <TD>
		<SELECT class="regularxl" name="operational" id="operational">		
			<OPTION value="0" <cfif #get.operational# eq 0>selected</cfif>>No</OPTION>
			<OPTION value="1" <cfif #get.operational# eq 1>selected</cfif>>Yes </OPTION>	
		</SELECT>
    </TD>
	</TR>
			
	</cfoutput>
	
	<tr><td></td></tr>
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr>
		
	<td align="center" colspan="2" height="40">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value="Cancel" onClick="window.close()">
    <cfif URL.OC eq 0><input class="button10g" type="submit" name="Delete" id="Delete" value="Delete" onclick="return ask()"></cfif>
    <input class="button10g" type="submit" name="Update" id="Update" value="Update">
	</td>	
	
	</tr>
	
</CFFORM>
	
</TABLE>

<cf_screenbottom layout="webapp">
	