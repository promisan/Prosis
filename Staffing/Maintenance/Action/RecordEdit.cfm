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
			  label="Edit Action" 
			  line="No"
			  banner="yellow" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	Ref_Action
	WHERE 	ActionCode = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this Action  ?")) {
		return true 	
	}	
	return false	
}	

</script>


<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<!--- edit form --->

<table width="89%" align="center" class="formpadding formspacing">

<tr><td height="8"></td></tr>

   <cfoutput>
	
	 <cfquery name="Src" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_ActionSource		
	</cfquery>
	 
	<TR>
	 <TD width="150" class="labelmedium2">Source:&nbsp;</TD>  
	 <TD>
	 	<select name="ActionSource" class="regularxxl" onchange="javascript: ColdFusion.navigate('EntityClass.cfm?ActionSource='+this.value+'&entityClass=','divWorkflow');">
		<cfloop query="Src">
			<option value="#ActionSource#" <cfif get.actionSource eq ActionSource>selected</cfif>>#ActionSource#</option>
		</cfloop>
		</select>
	 </TD>
	</TR>
	
    <TR>
    <TD class="labelmedium2">Code:</TD>
    <TD>
  	   <input type="text" name="ActionCode" value="#get.ActionCode#" size="10" maxlength="10" class="regularxxl">
	   <input type="hidden" name="ActionCodeOld" value="#get.ActionCode#" size="10" maxlength="10" readonly>
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2">Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="#get.description#" message="Please enter a description" required="Yes" size="30" maxlength="50" class="regularxxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2">Action Effective Mode:</TD>
    <TD class="labelmedium2" style="height:25px">
	   <table cellspacing="0" cellpadding="0">
	   <tr>
	   <td><input type="radio" class="radiol" name="ModeEffective" value="0" <cfif get.ModeEffective eq "0">checked</cfif>></td><td class="labelmedium2">Validate</td>
	   <td style="padding-left:10px"><input type="radio" class="radiol" name="ModeEffective" value="1" <cfif get.ModeEffective eq "1">checked</cfif>></td><td class="labelmedium2">Overlap</td>
	   <td style="padding-left:10px"><input type="radio" class="radiol" name="ModeEffective" value="9" <cfif get.ModeEffective eq "9">checked</cfif>></td><td class="labelmedium2">Disable edit</td>
	   </tr>
	   </table>
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2">Workflow:</TD>
    <TD class="labelmedium">
		<cfdiv id="divWorkflow" bind="url:EntityClass.cfm?ActionSource=#get.ActionSource#&entityClass=#get.EntityClass#">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2">Operational:</TD>
    <TD>
  	   <input type="checkbox" class="radiol" name="Operational" value="1" <cfif get.operational eq "1">checked</cfif>>
    </TD>
	</TR>
	
		
	<tr><td  colspan="2" class="linedotted"></td></tr>
	
	<tr><td align="center" colspan="2">
	
	<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Delete" value=" Delete " onclick="return ask()">
    <input class="button10g" type="submit" name="Update" value=" Update ">
	
	</td></tr>
		
	</cfoutput>
	
	
</TABLE>
	
</CFFORM>
