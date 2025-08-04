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

<cfparam name="url.id" default="Insurance">
<cfparam name="SESSION.welcome" default="Prosis">
<cfparam name="URL.PersonNo" default="#client.personNo#">
<cfparam name="URL.Layout" default="standard">

<cfquery name="System" 
datasource="AppsSystem">
	SELECT *
	FROM   Ref_ModuleControl
	WHERE  SystemModule   = 'SelfService'
	AND    FunctionClass  IN ('SelfService','Portal')
	AND    FunctionName   = '#URL.ID#' 
</cfquery>

<script language="JavaScript">

function logoff() {
	window.location = "<cfoutput>#SESSION.root#</cfoutput>/Portal/selfservice/Basic/Logon.cfm?id=#id#&mode=logon&layout=#URL.Layout#"
}

function password() {
	window.location = "<cfoutput>#SESSION.root#</cfoutput>/Portal/selfservice/Basic/Logon.cfm?id=#id#&mode=password"
}

function setting() {
	window.location = "<cfoutput>#SESSION.root#</cfoutput>/Portal/selfservice/Basic/Logon.cfm?id=#id#&entitycode=EntClaim&mode=setting"
}
 
</script>

<table width="100%" cellspacing="0" cellpadding="0" bgcolor="white">
<tr>
	
	<td height="25" colspan="2" align="right">

		<table>
		
		<tr>
		
		<cfif len(system.functioninfo) gt "30">
			<td>
				<img src="#SESSION.root#/images/information.gif"  style="cursor:pointer" alt="Submission info" border="0" onclick="info()">	
			</td>
		</cfif>
		
		<script>
		 function info() {
		  
		  se = document.getElementById("infobox")
		  
		  if (se.className == "hide") {
		     se.className = "regular" 
		  } else {
		     se.className = "hide" 
		  }
		  }
		 
		</script>
				
		<td width="1"></td>
		
		<td>&nbsp;&nbsp;|&nbsp;&nbsp;</td>	
		
		 <td align="right"><font color="white" face="Verdana">
		
		 <cf_tl id="Preferences" var="1">
		 <cfset tPref = "#Lt_text#">		 		
		 <a href="javascript:setting()" title="#tPref#"><b>#tPref#</b></a>
		 </td>
		 
		 <td>&nbsp;&nbsp;|&nbsp;&nbsp;</td>	
		
		 <cf_tl id="Password" var="1">
		 <cfset tPwd = "#Lt_text#">
		
		 <cf_tl id="Set Password" var="1">
		 <cfset tSPwd = "#Lt_text#">
	
		<td>
		<font color="white" face="Verdana">
		<a href="javascript:password()" title="#tSPwd#"><b>#tPwd#</b></a></td>
				
		<td>&nbsp;&nbsp;|&nbsp;&nbsp;</td>	
		
		 <cf_tl id="Return to portal" var="1">
		 <cfset tPortal = "#Lt_text#">
		
		 <cf_tl id="Log-out" var="1">
		 <cfset tLogOut = "#Lt_text#">
			
		<td>
		<font color="white" face="Verdana">
		<a href="javascript:logoff()" title="#tPortal#"><b>#tLogOut#</b></a></td>
				
		</tr>
		</table>	
	</td>	
</tr>

<tr><td colspan="3" bgcolor="5D5D5D"></td></tr>

<tr><td colspan="3" bgcolor="ffffff">
	
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
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT TOP 1 *
	    FROM  UserMission U, Organization.dbo.Organization O
		WHERE U.OrgUnit = O.OrgUnit
		AND   U.Account = '#SESSION.acc#'   
	</cfquery>
	
	<cfquery name="Parent" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
    FROM  Organization 
	WHERE OrgUnitCode = '#Unit.ParentOrgUnit#'  
	AND   Mission     = '#Unit.Mission#'
	AND   MandateNo   = '#Unit.MandateNo#'
	</cfquery>
	
	<cfparam name="CLIENT.Category" default="">

	<!--- claim owner --->
	<table width="790" align="center" cellspacing="0" cellpadding="0">
		
		<tr>
		   <td>
		   <table width="97%" align="center" cellspacing="0" cellpadding="0" class="formpadding">
			   <tr>			  
				   <td height="20" width="60"><b><font color="808080"><cf_tl id="Name">:</b></td>
				   <td>#User.FirstName# #User.LastName#</td>
				   <cfif user.PersonNo neq "">
				   <td width="100"><b><font color="808080"><cf_tl id="Employee No">:</b></td>
				   <td>#User.PersonNo#</td>
				   <cfelse>
				   <td></td><td></td>
				   </cfif>
				   <td><b><font color="808080"><cf_tl id="E-Mail">:</td>
				   <td>#User.EMailAddress#</td>
				   <td><b><font color="808080"><cf_tl id="Organization">:</td>
				   <td>
				   
				   <cfif Unit.OrgUnitName eq "">Internal
				   <cfelseif Parent.OrgUnitName neq "">
				   #Parent.OrgUnitName#
				   <cfelse>			   
				   #Unit.OrgUnitName#</cfif>&nbsp;
				   </td>			  
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
