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
			  label="Edit Contract Type"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_ContractType
WHERE ContractType = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

	function ask() {
		if (confirm("Do you want to remove this Contract Type ?")) {
		return true 
		}
		return false	
	}

	function hlMission(mis,cl) {
		var control = document.getElementById('mission_'+mis);
		if (control.checked) {
			document.getElementById('td_'+mis).style.backgroundColor = cl;
		}else{
			document.getElementById('td_'+mis).style.backgroundColor = '';
		}
	}

</script>

<!--- edit form --->

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<table width="94%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<tr><td height="7"></td></tr>
	
    <cfoutput>
    <TR>
    <TD class="labelmedium2">Code:</TD>
    <TD>
  	   <input type="text" name="ContractType" value="#get.ContractType#" size="15" maxlength="20" class="regularxxl">
	   <input type="hidden" name="ContractTypeOld" value="#get.ContractType#" size="15" maxlength="20" readonly>
    </TD>
	</TR>
		
	<TR>
    <TD class="labelmedium2">Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="#get.description#" message="Please enter a description" required="Yes" size="40" maxlength="40" class="regularxxl">
    </TD>
	</TR>
	
	<cfquery name="Type" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_AppointmentType		
		ORDER BY ListingOrder
	</cfquery>
	
	<tr>
	<td class="labelmedium2">Appointment type:</td>
	<td>
		
		<select name="AppointmentType" class="regularxxl">
		   
			<cfloop query="Type">
				<option value="#AppointmentType#" <cfif get.AppointmentType eq AppointmentType>selected</cfif>>#Description#</option>
			</cfloop>		
		</select>		
		
	</td>
	
	</tr>
	
				
	<cfquery name="Workflow" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_EntityClass
		WHERE  EntityCode = 'PersonContract'
	</cfquery>
	
	<tr>
	<td class="labelmedium2">Workflow Class:</td>
	<td>
		
		<select name="Workflow" class="regularxxl">
		    <option value="">N/A</option>
			<cfloop query="WorkFlow">
				<option value="#EntityClass#" <cfif get.EntityClass eq EntityClass>selected</cfif>>#EntityClassName#</option>
			</cfloop>		
		</select>		
		
	</td>
	
	</tr>
	
	<TR>
    <TD valign="top" class="labelmedium2" style="padding-top:4px;">Enabled for:</TD>
    <TD>
		<cfdiv id="divMission" bind="url:RecordMission.cfm?code=#get.ContractType#">
    </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
		
	</cfoutput>
	
	<tr><td colspan="2" class="line"></td></tr>
	<tr>	
	<td align="center" height="30" colspan="2">
	<input class="button10g" style="width:90px" type="button" name="Cancel" value="Cancel" onClick="window.close()">
    <input class="button10g" style="width:90px" type="submit" name="Delete" value="Delete" onclick="return ask()">
    <input class="button10g" style="width:90px" type="submit" name="Update" value="Update">
	</td>	
	</tr>
		
</TABLE>

</CFFORM>
	
<cf_screenbottom layout="innerbox">	