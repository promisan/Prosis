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

<cfquery name="Get" 
datasource="appsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	Ref_Designation
	WHERE  	Code = '#URL.ID1#' 
</cfquery>

<cfquery name="CountRec" 
 datasource="appsPayroll" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 	SELECT 		Designation
 	FROM 		Ref_PayrollLocationDesignation
 	WHERE 		Designation  = '#URL.ID1#'
</cfquery>

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Edit" 
			  option="Maintain Designation #URL.ID1#" 
			  banner="yellow" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this record ?")) {	
	return true 	
	}	
	return false	
}	

</script>

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">


<!--- edit form --->

<table width="92%" cellspacing="0" cellpadding="0" align="center" class="formpsacing formpadding">

	<tr><td colspan="2" align="center" height="10"></tr>
	
    <cfoutput>
    <TR>
    <TD class="labelmedium">Code:</TD>
    <TD class="labelmedium">
  	   <cfif #CountRec.recordCount# eq 0>
	   		<cfinput type="text" name="Code" value="#get.Code#" message="please enter a code" required="Yes" size="5" maxlength="10" class="regularxl">
	   <cfelse>
	   		#get.Code#
	   </cfif>
	   <input type="hidden" name="Codeold" value="#get.Code#" size="20" maxlength="20"class="regular">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Description:</TD>
    <TD class="labelmedium">
  	   <cfinput type="text" name="Description" value="#get.Description#" message="please enter a description" required="No" size="30" maxlenght= "50" class= "regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Order:</TD>
    <TD class="labelmedium">
  	   <cfinput type="text" name="ListingOrder" value="#get.listingOrder#" message="Please enter a listing order" required="Yes" validate="integer" size="1" maxlength="10" class="regularxl" style="text-align:center;">
    </TD>
	</TR>
		
	</cfoutput>
		
	<tr><td colspan="2" align="center" height="6"></tr>
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" align="center" height="6"></tr>
	
	<tr><td align="center" colspan="2" height="40">	
    <cfif CountRec.recordCount eq 0><input class="button10g" type="submit" name="Delete" value=" Delete " onclick="return ask()"></cfif>
    <input class="button10g" type="submit" name="Update" value=" Update ">
	</td>	
	
	</tr>
	
</TABLE>
	
</CFFORM>

