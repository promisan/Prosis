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
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_TransactionClass
	WHERE  Code = '#URL.ID1#'
</cfquery>

<cfquery name="CountRec" 
      datasource="AppsMaterials" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT 	TransactionClass
      FROM  	Ref_TransactionType
      WHERE 	TransactionClass  = '#URL.ID1#' 
	  UNION
	  SELECT 	TransactionClass
      FROM  	ItemWarehouseLocationLoss
      WHERE 	TransactionClass  = '#URL.ID1#'	  
    </cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this record ?")) {	
	return true 	
	}	
	return false	
}	

</script>

<cf_screentop height="100%" 
			  label="Transaction Class" 			  
			  scroll="Yes" 
			  layout="webapp" 
			  banner="yellow" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- edit form --->

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#" method="POST" enablecab="Yes" name="dialog">

<table width="91%" align="center" class="formpadding formspacing">

	<tr><td height="6"></td></tr>
    <cfoutput>
    <TR>
    <TD class="labelmedium2" width="30%">Code:</TD>
    <TD class="labelmedium2">
	   <!--- <cfif CountRec.recordcount eq "0">	
		   	<cfinput type="Text" name="Code" value="#get.Code#" message="Please enter a code" required="Yes" size="10" maxlength="20" class="regular">
	   <cfelse> --->
	   		#get.Code#
			<input type="hidden" name="Code" id="Code" value="#get.Code#">
	   <!--- </cfif> --->
	   <input type="hidden" name="Codeold" id="Codeold" value="#get.Code#">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD  class="labelmedium2">Description:</TD>
    <TD>
	   <cfinput type="Text" name="Description" value="#get.Description#" message="Please enter a description" required="Yes" size="30" maxlength="50" class="regularxxl">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Negative:</TD>
    <TD>
  	    <input type="radio" class="radiol" name="QuantityNegative" id="QuantityNegative" <cfif get.QuantityNegative eq 1>checked</cfif> value="1">Yes
		<input type="radio" class="radiol" name="QuantityNegative" id="QuantityNegative" <cfif get.QuantityNegative eq 0>checked</cfif> value="0">No
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Order:</TD>
    <TD>
  	   <cfinput type="Text" name="listingOrder" value="#get.listingOrder#" message="Please enter a numeric listing order" 
	      required="Yes" size="1" validate="integer" maxlength="3" class="regularxxl" style="text-align:center;">
    </TD>
	</TR>
			
	</cfoutput>
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr>
		
	<td align="center" colspan="2" height="40">
	<!--- <cfif CountRec.recordcount eq "0"><input class="button10g" type="submit" style="width:80" name="Delete" value="Delete" onclick="return ask()"></cfif> --->	
    <input class="button10g" type="submit" style="width:100" name="Update" id="Update" value="Update">
	</td>	
	
	</tr>	
	
</TABLE>

</CFFORM>

<cf_screenbottom layout="webapp">
	