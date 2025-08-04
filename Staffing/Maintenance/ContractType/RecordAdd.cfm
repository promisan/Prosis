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
			  label="Add Contract Type"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
			  
<script>
	function hlMission(mis,cl) {
		var control = document.getElementById('mission_'+mis);
		if (control.checked) {
			document.getElementById('td_'+mis).style.backgroundColor = cl;
		}else{
			document.getElementById('td_'+mis).style.backgroundColor = '';
		}
	}
</script>

<!--- Entry form --->

<table width="94%" align="center" class="formpadding">
	
	<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">
	
	<tr><td height="7"></td></tr>

    <TR>
    <TD class="labelmedium2">Code:</TD>
    <TD class="labelmedium2">
  	   <cfinput type="Text" name="ContractType" value="" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2">Description:</TD>
    <TD class="labelmedium2">
  	   <cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="40" maxlength="40" class="regularxxl">
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
		   
			<cfoutput query="Type">
				<option value="#AppointmentType#">#Description#</option>
			</cfoutput>		
		</select>		
		
	</td>
	
	</tr>
	
				
	<cfquery name="Workflow" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_EntityClass
		WHERE EntityCode = 'PersonContract'
	</cfquery>
	
	<td class="labelmedium2">Workflow Class:</td>
	<td>
		
		<select name="Workflow" class="regularxxl">
		    <option value="">N/A</option>
			<cfoutput query="WorkFlow">
				<option value="#EntityClass#">#EntityClassName#</option>
			</cfoutput>		
		</select>		
		
	</td>
	
	</tr>
	
	<TR>
    <TD valign="top" class="labelmedium2" style="padding-top:4px;">Enabled for:</TD>
    <TD>
		<cfdiv id="divMission" bind="url:RecordMission.cfm?code=">
    </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
	<tr><td colspan="2" class="line"></td></tr>
	<tr>	
	<td align="center" height="30" colspan="2">
		
	<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" value=" Submit ">
	
	</td>	
	
	</tr>
		
	</CFFORM>
	
</TABLE>


<cf_screenbottom layout="innerbox">	