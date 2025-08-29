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
              scroll="No" 
			  layout="webapp" 
			  label="Edit Incoterm" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
 
<cfquery name="Get" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_incoterm
	WHERE Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this record ?")) {
		return true 
	}
	return false
}	

</script>

<CFFORM action="RecordSubmit.cfm" method="post" name="dialog">

<!--- edit form --->

<table width="91%" class="formpadding formspacing" align="center">

	 <cfoutput>
	 <tr><td height="7"></td></tr>
	 <TR>
	 <TD style="height:29" class="labelmedium2">Code:</TD>  
	 <TD>
	 	<input type="Text" name="Code" id="Code" value="#get.Code#" size="20" maxlength="20"class="regularxxl">
		<input type="hidden" name="CodeOld" id="CodeOld" value="#get.Code#" size="20" maxlength="20">
	 </TD>
	 </TR>
	 
	 <!--- Field: Description --->
    <TR>
    <TD style="height:29" class="labelmedium2">Description:</TD>
    <TD>
  	  	<input type="Text" name="Description" id="Description" value="#get.Description#" message="Please enter a description" required="Yes" size="40" maxlength="50" class="regularxxl">
				
    </TD>
	</TR>
		
	<tr><td colspan="2" class="line"></td></tr>
		
	<tr><td colspan="2" align="center">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
	<input class="button10g" type="submit" name="Delete" id="Delete" value=" Delete " onclick="return ask()">
	<input class="button10g" type="submit" name="Update" id="Update" value=" Update ">
	</td></tr>
	
</cfoutput>
    	
</TABLE>

</CFFORM>


