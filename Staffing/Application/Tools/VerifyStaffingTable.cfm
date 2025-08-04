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

<!--- Prosis template framework --->
<cfsilent>
 <proUsr>administrator</proUsr>
 <proOwn>Hanno van Pelt</proOwn>
 <proDes>Staffing Table validation</proDes>
 <!--- specific comments for the current change, may be overwritten --->
 <proCom>Added on request of PMSS</proCom>
</cfsilent>
<!--- End Prosis template framework --->

<cf_dialogPosition>

<cfoutput>
	
	<script>
		
	function validate() {
				
		mis = document.getElementById("mission").value;
		man = document.getElementById("mandateno").value	
		cur = document.getElementById("current").checked
		url = "VerifyStaffingTableResult.cfm?current="+cur+"&mission="+mis+"&mandateno="+man;
		ptoken.navigate(url,'result')	 
	}
	
	</script>

</cfoutput>

<cf_screentop height="100%" scroll="yes" html="No" jquery="Yes">

<cfparam name="URL.Mission" default="SAT">
<cfparam name="URL.MandateNo" default="P001">

<cfquery name="Mission" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_Mission
	WHERE  Mission IN (SELECT Mission 
                   FROM Ref_MissionModule 
				   WHERE SystemModule = 'Staffing')
	AND Operational = 1			   
</cfquery>

<!---
<cf_submenuLogo module="Staffing" selection="Maintenance">
--->

<cfset Page         = "0">
<cfset add          = "0">
<cfset save         = "0"> 

<table width="98%" align="center" height="100%" border="0">

<tr style="height:10px"><td><cfinclude template="../../Maintenance/HeaderMaintain.cfm"></td></tr>

<tr><td style="height:100%" valign="top">

<cfoutput>
<table width="95%" align="center" class="formpadding">
	
	<tr><td colspan="2" style="height:22px" class="labelmedium2">This function verifies a variety of staffing table inconsistencies (positions, contracts and assignments)</td></tr>
	<tr><td colspan="2" style="height:22px" class="labelmedium2" colspan="1"><font color="A0A0A0"><i>Results are logged in the table [Employee.dbo.AuditIncumbency]</i></td></tr>
	<tr><td height="5"></td></tr>	
	<tr><td colspan="2" height="1" class="line"></td></tr>
	<tr><td height="5"></td></tr>
	<tr><td valign="top">
	   <table cellspacing="0" cellpadding="0">
	    <tr><td height="4"></td></tr>
		<tr><td class="labelmedium2">&nbsp;&nbsp;<cf_tl id="Entity">:</td></tr>
    	</table>
	</td>
	<td width="80%" valign="top">
	    <table cellspacing="0" cellpadding="0">
			<tr><td valign="top" style="padding-top:3px">
			<select name="mission" id="mission" class="regularxxl">
				<cfloop query="mission">
					<option value="#Mission#">#Mission#</option>
				</cfloop>
			</select>
			</td>
			<td style="padding-left:10px"><cf_securediv bind="url:VerifyStaffingTableMandate.cfm?mission={mission}"></td>
			<td class="labelmedium2" style="padding-left:4px">Only current assignments</td>
			<td class="labelmedium2" style="padding-left:4px">		  
			<input type="checkbox" class="radiol" name="current" id="current" value="1" checked>
			</td>
			</tr>
		</table>
	</td>
	</tr>
		
	<tr><td height="5"></td></tr>
	<tr><td colspan="2" align="center" height="30">
		<input type="button" name="validate" id="validate" style="width:190;height:25" onclick="validate()" class="button10g" value="Validate Now">
	</td></tr>
   
	<tr><td colspan="2" height="1" class="line"></td></tr>
	<tr><td colspan="2" id="result"></td></tr>
	
</table>

</cfoutput>

</td>
</tr>

</table>