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
	  scroll="Yes" 
	  layout="webapp" 
	  label="Edit" 
	  menuAccess="Yes" 
	  systemfunctionid="#url.idmenu#">

<cfquery name="Get" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ReportMenuClass
	WHERE  MenuClass    = '#URL.ID1#' 
	AND    SystemModule = '#url.id#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this Menu Class?")) {	
	return true 	
	}	
	return false	
}	

</script>

<cfform action="RecordSubmit.cfm?id=#url.id#" method="POST" name="dialog" target="process">

<!--- edit form --->

<table width="92%" class="formpadding" cellspacing="0" cellpadding="0" align="center">

    <tr><td height="8"></td></tr>
	
	<tr class="hide"><td><iframe name="process" id="process"></iframe></td></tr>

    <cfoutput>
    <TR>
    <TD class="labelit">Code:</TD>
    <TD>
  	   <input type="text" name="MenuClass" id="MenuClass" value="#get.MenuClass#" size="10" maxlength="10" class="regularxl">
	   <input type="hidden" name="MenuClassOld" id="MenuClassOld" value="#get.MenuClass#" size="10" maxlength="10" class="regular">
	   
    </TD>
	</TR>
	
	  <TR>
    <TD class="labelit">Name:</TD>
    <TD>
  	   <cfinput type="text" name="description" value="#get.description#" message="Please enter a name" required="Yes" size="30" maxlength="50" class="regularxl">
    </TD>
	</TR>
		
	<TR>
    <TD class="labelit">Listing Order:</TD>
    <TD>
  	   <cfinput type="Text"
	       name="ListingOrder"
	       value="#get.ListingOrder#"
	       validate="integer"
	       required="No"
	       visible="Yes"
	       enabled="Yes"
	       size="1"
	       maxlength="2"
	       class="regularxl">
	  
    </TD>
	</TR>
			
	</cfoutput>
	
	<tr><td height="3"></td></tr>	
	<tr><td height="1" colspan="2" class="linedotted"></td></tr>	
	<tr><td height="3"></td></tr>
	
	<tr>	
		
		<td colspan="2" height="30" align="center">
		<input class="button10g" style="width:100" type="button" name="Cancel" id="Cancel" value="Close" onClick="window.close()">
		
		<cfquery name="CountRec" 
	      datasource="AppsSystem" 
	      username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
	      SELECT *
	      FROM  Ref_ReportControl
	      WHERE SystemModule  = '#url.id#' 
		  AND MenuClass = '#url.id1#'
	    </cfquery>
	
	    <cfif CountRec.recordCount eq 0>
		
		    <input class="button10g" style="width:100" type="submit" name="Delete" id="Delete" value="Delete" onclick="return ask()">
		
		</cfif>
		
	    <input class="button10g" style="width:100" type="submit" name="Update" id="Update" value="Update">
		
		</td>	
	
	</tr>
	
</TABLE>
	
</CFFORM>

<cf_screenbottom layout="innerbox">
