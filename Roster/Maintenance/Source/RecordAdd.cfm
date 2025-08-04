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
			  label="Add Submission Source" 
			  menuAccess="Yes" 
			  banner="gray"
			  systemfunctionid="#url.idmenu#">
			  

<!--- edit form --->
<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<table width="92%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">

	<tr><td height="7"></td></tr>
    <cfoutput>
    <TR>
    <TD class="labelmedium">Source:</TD>
    <TD>
	   <cfinput type="text" name="Source" id="Source" value="" size="15" maxlength="10" message="Please enter a code" required="Yes" class="regularxl" >
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" id="Description" value="" message="Please enter a description" required="Yes" size="30" maxlength="50" class="regularxl">
    </TD>
	</TR>	
			
	<TR>
    <TD class="labelmedium">Allow Edit:</TD>
    <TD>
	    <INPUT type="checkbox" class="radiol" name="AllowEdit" id="AllowEdit" value="1"> 
	</TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Allow Assessment:</TD>
    <TD>
	    <INPUT type="checkbox" class="radiol" name="AllowAssessment" id="AllowAssessment" value="1"> 
	</TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">PHP Mode:</TD>
    <TD>
	
		<cfquery name="Mode" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_PHPMode
		</cfquery>
			
		<cfselect name="PHPMode" id="PHPMode" class="regularxl">
			<cfloop query="Mode">
				<option value="#Mode#">#Mode#</option>
			</cfloop>
		</cfselect>
	
	</TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Enrollment flow:</TD>
    <TD>
	
	<cfquery name="Class" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_EntityClass
		WHERE  EntityCode = 'Candidate'
	</cfquery>
		
		<cfselect name="EntityClass" id="EntityClass" class="regularxl">
		    <option value=""></option>
			<cfloop query="Class">
				<option value="#EntityClass#">#EntityClassName#</option>
			</cfloop>
		</cfselect>
	
	</TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Operational:</TD>
    <TD>
	    <INPUT type="checkbox" class="radiol" name="Operational" id="Operational" value="1"> 
	</TD>
	</TR>
	
	
	</cfoutput>
	
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" align="center" height="30">
	
	<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" value="  Save  ">
	</td>	
	
	</tr>
	
</table>

</cfform>


