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
              scroll="Yes" 
			  layout="webapp" 
			  label="Object Usage" 			  
			  banner="yellow"
  			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
	datasource="appsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_ObjectUsage
		WHERE 	Code = '#URL.ID1#'
</cfquery>

<cfquery name="CountRec" 
	datasource="appsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT TOP 1 ObjectUsage
		FROM 	Ref_Object
		WHERE 	ObjectUsage  = '#URL.ID1#' 
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this object usage?")) {	
	return true 	
	}	
	return false	
}	

</script>

<!--- edit form --->

<table width="95%" align="center" class="formpadding formspacing">
	
	<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

	<tr><td height="10"></td></tr>

    <cfoutput>
    <TR class="labelmedium2">
    <TD>Code:</TD>
    <TD>
		<cfif CountRec.recordCount eq 0>
  	   		<cfinput type="text" name="code" value="#get.Code#" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxxl">
		<cfelse>
		   <input type="hidden" name="Code" id="Code" value="#get.Code#">
			#get.Code#
		</cfif>
	   <input type="hidden" name="Codeold" id="Codeold" value="#get.Code#">
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD>Name:</TD>
    <TD>
	   <cfinput type="text" name="Description" value="#get.Description#" message="Please enter a description" required="Yes" size="35" maxlength="50" class="regularxxl">
    </TD>
	</TR>
		
	</cfoutput>
	
	<tr><td height="6"></td></tr>
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr><td height="6"></td></tr>	
			
	<tr>
		
	<td align="center" colspan="2">	
	
	<input class="button10g" type="button" name="Cancel" id="Cancel" value="Close" onClick="window.close()">
	<cfif CountRec.recordCount eq 0>
    <input class="button10g" type="submit" name="Delete" id="Delete" value="Delete" onclick="return ask()">
	</cfif>
    <input class="button10g" type="submit" name="Update" id="Update" value="Update">
	</td>	
	</tr>
	
	</CFFORM>
	
</TABLE>
	
<cf_screenbottom layout="innerbox">
