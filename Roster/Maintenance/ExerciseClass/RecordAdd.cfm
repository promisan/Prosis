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
			  label="Add Roster Class" 
			  menuAccess="Yes"
			  banner="gray"
			  jquery="Yes"
			  line="No"
			  systemfunctionid="#url.idmenu#">

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<table width="90%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<tr><td height="6"></td></tr>	

    <TR>
    <TD class="labelit">Code:</TD>
    <TD class="labelit">
  	   <cfinput type="Text" name="ExcerciseClass" id="ExcerciseClass" value="" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxl enterastab">
    </TD>
	</TR>
		
	<TR>
    <TD class="labelit">Description:</TD>
    <TD class="labelit">
  	   <cfinput type="Text" name="Description" id="Description" value="" message="Please enter a description" required="Yes" size="30" maxlength="30" class="regularxl enterastab">
    </TD>
	</TR>
			
	<TR>
    <TD class="labelmedium">Roster search:</TD>
    <TD class="labelmedium">
	    <INPUT type="radio" class="enterastab radiol" name="Roster" id="Roster" value="0" checked> Disabled
		<INPUT type="radio" class="enterastab radiol" name="Roster" id="Roster" value="1"> Enabled
	</TD>
	</TR>
	
	
	<TR>
    <TD class="labelmedium">Publish to:</TD>
    <TD class="labelmedium">
	
	<cfquery name="Entity" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_Mission
		WHERE  MissionStatus = '1' and Operational = 1
	</cfquery>

		<select name="TreePublish" id="TreePublish" class="regularxl">
			<option value="">n/a</option>
			<cfoutput query="Entity">
				<option value="#Mission#">#Mission#</option>
			</cfoutput>
		</select>
	
	</TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Default source:</TD>
    <TD class="labelmedium">
	
	<cfquery name="Source" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_Source
		WHERE  Operational = 1
	</cfquery>

		<select name="DefaultSource" id="DefaultSource" class="regularxl">
			<cfoutput query="Source">
				<option value="#Source#">#Description#</option>
			</cfoutput>
		</select>
	
	</TD>
	</TR>
	
	
	<tr>
	<td class="labelmedium"> Unit Class: </td>
	<td class="labelmedium">	
		<cf_securediv bind="url:getOrgUnitClass.cfm?mission={TreePublish}" id="div_OrgUnitClass"/>	
	</td>
	</tr>
	
	<tr>
	<td class="labelmedium"> Workflow: </td>
	<td class="labelmedium">
	
		<cfquery name="Workflow" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_EntityClass
			WHERE  EntityCode = 'VacDocument'
		</cfquery>
	
		<select name="EntityClass" id="EntityClass" class="regularxl">
			<cfoutput query="Workflow">
				<option value="#EntityClass#">#EntityClassName#</option>
			</cfoutput>
		</select>
	
	</td>
	</tr>
	
	<tr><td colspan="2" class="linedotted"></td></tr>
	
	<tr><td colspan="2" align="center" height="30">
		
	<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" value=" Submit ">
	
	</td>	
	
	</tr>
	
</TABLE>

</cfform>
