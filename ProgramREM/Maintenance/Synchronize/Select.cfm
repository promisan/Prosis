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
<cf_divscroll>

<cfset Page         = "0">
<cfset add          = "0">
<cfinclude template = "../HeaderMaintain.cfm"> 	

<table width="99%" align="center" cellspacing="0" cellpadding="0" >

<tr>

<td>

<script language="JavaScript">
	function process(nme,mis,man,per) {
	
		window.open(nme+"?mission="+mis+"&mandateno="+man+"&period="+per, "process", "unadorned:yes; edge:raised; status:yes; dialogHeight:700px; dialogWidth:800px; help:no; scroll:no; center:yes; resizable:no");
				
	}  
</script>

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

	<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<tr class="linedotted"><td colspan="2" class="labellarge"><b>Utility</b></td></tr>
	
	<tr>
		<td width="15%" class="labellarge" align="right">Function:</td>
		<td>This utility will allow you to synchronise the program indicator for one or more Target units with a Selected template unit.</td>
	</tr>
	
	<tr><td height="10px"></td></tr>
	
	<tr valign="top">
		<td class="labellarge" align="right">Purpose:</td>
		<td>This function should only be used in an environment where new org units or new program components have been added to an implementation were program components are used to show progress for a set of common indicators</td>
	</tr>
	
	<tr><td height="10px"></td></tr>
	
	<tr valign="top"><td class="labellarge" align="right">Steps:</td>
		<td>
		The interface has 3 input parameters
		<br>
		1. Select the <b>tree</b> and <b>period</b> (below)
		<br>
		2. Select the template unit and one or more <b>destination</b> units
		<br>
		3. Select one or more <b>program components</b> that should be synchronised
		</td>
	</tr>
	
	<tr><td height="10px"></td></tr>
	
	<cfquery name="Period" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_MissionPeriod 
	WHERE Mission IN (SELECT Mission FROM Ref_MissionModule WHERE SystemModule = 'Program')
	</cfquery>
	
	<tr valign="top"><td class="labellarge" align="right">Tree period:</td>
		<td>
		<table cellspacing="0" cellpadding="0">
		<cfset columns = 4>
		<cfset cont = 0>
		<cfoutput query="Period">
		
			<cfif cont eq 0>
				<tr class="linedotted">
			</cfif>
	
			<td>
			<cf_img icon="open" onclick="process('Sync.cfm','#Mission#','#MandateNo#','#Period#')">
			</td>
			<td>&nbsp;&nbsp;</td>
			<td><a href="javascript:process('Sync.cfm','#Mission#','#MandateNo#','#Period#')">#Mission#</a></td>
			<td>&nbsp;&nbsp;</td>
			<td><a href="javascript:process('Sync.cfm','#Mission#','#MandateNo#','#Period#')">#Period#</a></td>
			<td style="padding-right:40px;">&nbsp;&nbsp;</td>
			
			<cfset cont = cont + 1>
			<cfif cont eq columns>
				<cfset cont = 0>
				</tr>
				<tr><td height="5px"></td></tr>
			</cfif>
	
		</cfoutput>
		</table>
		
		</td>
	</tr>
	
	<tr><td height="30px"></td></tr>
	
	<tr>
	   <td colspan="2" align="center" class="labelit">
	   		<b><font color="FF0000">Attention:</font></b>The utility will remove any exisiting programs under the target unit which can NOT be reversed.
		</td>
	</tr>
	
	
	</table>

</td>

</tr>

</table>

</cf_divscroll>