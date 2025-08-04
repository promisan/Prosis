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
<cfoutput>

<cfparam name="home" default="no">
<cfparam name="URL.PersonNo" default="#client.personNo#">

<cfquery name="System" 
datasource="AppsSystem">
	SELECT *
	FROM Ref_ModuleControl
	WHERE SystemModule  = 'Selfservice'
	AND   FunctionClass = 'SelfService'
	AND   FunctionName  = '#URL.ID#' 
</cfquery>

<script language="JavaScript">

function logoff() {
window.location = "<cfoutput>#SESSION.root#</cfoutput>/Portal/selfservice/Logon.cfm?id=#id#&mode=logon"
}

function password() {
window.location = "<cfoutput>#SESSION.root#</cfoutput>/Portal/selfservice/Logon.cfm?id=#id#&mode=password"
}

function setting() {
window.location = "<cfoutput>#SESSION.root#</cfoutput>/Portal/selfservice/Logon.cfm?id=#id#&entitycode=EntClaim&mode=setting"
}
	
function home() {

	window.location = "#SESSION.root#/#System.FunctionDirectory#/#System.FunctionPath#?ID=#URL.ID#"
}
 
</script>


<body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0">

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#</cfoutput>/<cfoutput>#client.style#</cfoutput>"> 

<table width="100%" cellspacing="0" cellpadding="0" bgcolor="white">
<tr>
	<td height="24" width="60%"><b></b></font></td>
	<td width="1"></td>
	<td align="right">
	<font color="white" face="Verdana">
	|
	<a href="javascript:setting()" title="Preferences">
	<b><cf_tl id="Preferences"></b>
	</a>
	|
	<a href="javascript:password()" title="Set Password">
	<b><cf_tl id="Password"></b>
	</a>
	|
	<a href="javascript:logoff()" title="Return to portal">
	<b><cf_tl id="Log-out"></b>
	</a>
	
	</td>
</tr>

<tr><td colspan="3" bgcolor="5D5D5D"></td></tr>

<tr><td colspan="3" bgcolor="ffffff" valign="top">
	
	<cfoutput>
	
	<cfquery name="User" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
	    FROM UserNames
	    WHERE Account = '#SESSION.acc#'
	</cfquery>
	
	<cfquery name="Unit" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT TOP 1 *
    FROM  Organization 
	WHERE UserAccount = '#SESSION.acc#'   
	</cfquery>
	
	<cfparam name="CLIENT.Category" default="">

	<!--- claim owner --->
	<table width="790" align="center" cellspacing="0" cellpadding="0">
		
		<tr>
		   <td>
		   <table width="97%" align="center" cellspacing="0" cellpadding="0" class="formpadding">
			   <tr>
			  
			   <td height="20" width="60"><b><cf_tl id="Name">:</b></td>
			   <td>#User.FirstName# #User.LastName#</td>
			
			   <td width="80"><b><cf_tl id="Employee No">:</b></td>
			   <td width="100"><cfif User.IndexNo eq "">N/A<cfelse>#User.Indexno#</cfif></td>
			   <td width="50"><b><cf_tl id="E-Mail">:</td>
			   <td>#User.EMailAddress#</td>
			   <td width="85"><b><cf_tl id="Organization">:</td>
			   <td><cfif Unit.OrgUnitName eq ""><cf_tl id="Internal"><cfelse>#Unit.OrgUnitName#</cfif>&nbsp;</td>
			  
			   </tr>
		   </table>
		   </td>
		</tr>
		
	</table>
	
</td></tr>
</cfoutput>

</table>

</cfoutput>

</body>
</html>
