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
			  label="Edit Group"
			  banner="gray"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ProgramGroup
	WHERE  Code = '#URL.ID1#'
</cfquery>

<cfquery name="QPeriod" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Period
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this grouping?")) {	
	return true 	
	}	
	return false
	
}	

</script>

<table width="100%" align="center">
<tr><td>

<cfform action="RecordSubmit.cfm" method="POST">

<!--- edit form --->

<table width="96%" align="center" class="formpadding formspacing">

	<tr><td height="5"></td></tr>
	
    <cfoutput>
    <TR class="labelmedium2">
    <TD>Code:</TD>
    <TD>
  	   <input type="text" name="Code" value="#get.Code#" size="20" maxlength="20"class="regularxxl">
	   <input type="hidden" name="Codeold" value="#get.Code#" size="20" maxlength="20"class="regular">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Description:</TD>
    <TD>
  	   <cfinput type="text" name="Description" value="#get.Description#" message="please enter a description" requerided=  "yes" size="30" 
	   maxlenght = "40" class= "regularxxl">
    </TD>
	</TR>
			
	<cfquery name="MissionList" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_ParameterMission
	</cfquery>
	
	<TR class="labelmedium2">
    <TD>Entity:</TD>
    <TD>
	<cfoutput>
		<select name="Mission" class="regularxxl">
        	<option value="0" selected>All entities</option>
     	   <cfloop query="MissionList">
        	<option value="#Mission#" <cfif Get.Mission eq mission>selected</cfif>>#Mission#</option>
         	</cfloop>
	    </select>
	</cfoutput>		
    </TD>
	</TR>		

	<TR class="labelmedium2">
    <TD>Period:</TD>
    <TD>
		<select name="Period"  class="regularxxl">
        	<option value="0" >All periods</option>
     	   <cfloop query="QPeriod">
        	<option value="#QPeriod.Period#" <cfif #Get.Period# eq "#QPeriod.Period#">selected</cfif>>#QPeriod.Description#
			</option>
         	</cfloop>
	    </select>
    </TD>
	</TR>	
	
	<TR class="labelmedium2">
    <TD>Order:</TD>
    <TD>
  	   <cfinput type="text" name="ListingOrder" value="#get.listingOrder#" size="2" maxlength="20" class="regularxxl" validate="integer">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Color:</TD>
    <TD>
  	   <input type="text" name="ViewColor" value="#get.ViewColor#" size="20"  maxlenght = "20" class= "regularxxl">
    </TD>
	</TR>
	
	</cfoutput>
		
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr>	
		<td colspan="2" align="center">
		<input class="button10g" type="button" name="Cancel" value="Cancel" onClick="window.close()">
	    <input class="button10g" type="submit" name="Delete" value="Delete" onclick="return ask()">
    	<input class="button10g" type="submit" name="Update" value="Update">
		</td>	
	</tr>
	
</TABLE>
	
</CFFORM>

</td></tr></table>
