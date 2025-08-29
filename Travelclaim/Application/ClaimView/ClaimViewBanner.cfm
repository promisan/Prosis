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
<cfsilent>

<proUsr>administrator</proUsr>
<proOwn>Hanno van Pelt</proOwn>
<proDes></proDes>
<proCom></proCom>
<proCM></proCM>

<proInfo>
<table width="100%" cellspacing="0" cellpadding="0">
<tr><td>
This template shows the base information of the claimant like Indexno, Contract. The information is located and derrived from tables available to the Nova framework.
</td></tr>
</table>
</proInfo>

<proOwn>MKM </proOwn>
<proCom>21/11/2008: Org unit code from Stperson (IMIS current org of S/M) instead of Employee..PersonAssignment</proCom>

</cfsilent>

<cfoutput>

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#</cfoutput>/<cfoutput>#client.style#</cfoutput>"> 

<cfparam name="SESSION.welcome" default="Prosis">
<cfparam name="Mode" default="">
<cfparam name="URL.PersonNo" default="#client.personNo#">

<cf_dialogStaffing>

<script language="JavaScript">

function logoff() {
window.parent.location = "<cfoutput>#SESSION.root#</cfoutput>/Portal/selfservice/logon.cfm?id=travelclaim&mode=logon"
}

function password() {
window.parent.location = "<cfoutput>#SESSION.root#</cfoutput>/Portal/selfservice/logon.cfm?id=travelclaim&mode=password"
}

function setting() {
window.parent.location = "<cfoutput>#SESSION.root#</cfoutput>/Portal/selfservice/logon.cfm?id=travelclaim&entitycode=EntClaim&mode=setting"
}

function home() {
parent.window.location = "<cfoutput>#SESSION.root#</cfoutput>/TravelClaim/Application/ClaimView/ClaimView.cfm?ID=travelclaim&PersonNo=#URL.PersonNo#"
}
 
</script>

<cfparam name="URL.ID" default="TravelClaim">

<cfquery name="System" 
datasource="AppsSystem">
	SELECT *
	FROM Ref_ModuleControl
	WHERE SystemModule  = 'Portal'
	AND   FunctionClass = 'SelfService'
	AND   FunctionName  = '#URL.ID#'
</cfquery>

<table width="100%" cellspacing="0" cellpadding="0">
<tr>
	<td height="24" width="40%">&nbsp;<cf_MailServerLink name="EMail"></td>
	<td width="1"></td>
	<td align="right">		
	&nbsp;
	<a href="javascript:setting()" title="Preferences">
	<b>Preferences</b>
	</a>
	&nbsp;
	|
	&nbsp;
	<a href="javascript:password()" title="Set Password">
	<b>Password</b>
	</a>
	<cfif mode neq "Home">
		&nbsp;
		|	
		&nbsp;
		<a href="javascript:home()" title="Return to portal">
		<b>Home</b>
		</a>
	</cfif>
	&nbsp;
	|
	&nbsp;
	<a href="javascript:logoff()" title="Log-off and return to log-on screen">
	<b>Log-out</b>
	</a>
	&nbsp;
	
	</td>
</tr>

<tr><td colspan="3" bgcolor="5D5D5D"></td></tr>

<tr><td colspan="3" bgcolor="ffffff" valign="top">
	
	<cfoutput>
	
	<cfif url.claimId eq "">
	
	<cfquery name="Employee" 
	datasource="AppsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
	    FROM stPerson
	    WHERE PersonNo = '#URL.PersonNo#'
	</cfquery>
	
	<cfelse>
	
	<cfquery name="Claim" 
	datasource="AppsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
	    FROM Claim
	    WHERE ClaimId = '#URL.ClaimId#'
	</cfquery>
	
	<cfquery name="Employee" 
	datasource="AppsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
	    FROM stPerson
	    WHERE PersonNo = '#Claim.PersonNo#'
	</cfquery>
	
	</cfif>
	
	<cfset grade = employee.grade>
	
	<cfif grade eq "undefined">
	
		<cftry>
			
			<cfquery name="Contract" 
			datasource="WarehousePMSS" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   TOP 1 *
			FROM     StaffPALineGrade
			WHERE    IndexNo = '#Employee.IndexNo#'
			ORDER BY GradeEffectiveDate DESC
			</cfquery>
		
			<cfset grade = Contract.Grade>
			
				<cfcatch>
					<cfset grade = "undefined">	
				</cfcatch>
		
		</cftry>	
		
	</cfif>	
<!---	 MKM 19-Nov-2008  
Changed this query to use IMIS data instead. The PersonAssignment table in Employee isn't always upto date.

	<cfquery name="Unit" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT TOP 1 *
    FROM  PersonAssignment P, 
	      Organization.dbo.Organization O
    WHERE P.OrgUnit = O.OrgUnit
	AND   P.PersonNo = '#URL.PersonNo#' 
	AND   P.AssignmentStatus IN ('0','1')
	AND   P.DateExpiration > getDate()
	ORDER BY P.DateEffective DESC 
	</cfquery>
--->	

	<cfquery name="Unit" 
	datasource="AppsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT TOP 1 *
    FROM  stPerson P, 
	      Organization.dbo.Organization O
    WHERE P.StaffMemberOrg = O.OrgUnitCode
	AND   P.PersonNo = '#URL.PersonNo#' 
	ORDER BY O.TreeOrder DESC 
	</cfquery>

	
	
	<cfparam name="CLIENT.Category" default="">

	<!--- claim owner --->
	<table width="790" align="center" cellspacing="0" cellpadding="0">
		
		<tr>
		   <td>
		   <table width="97%" align="center" border="0" cellspacing="1" cellpadding="1">
			   <tr>
			  
			   <td height="20" width="50"><b>Name:</b></td>
			   <td>
			   <A HREF ="javascript:EditPerson('#Employee.PersonNo#')" title="Profile">#Employee.FirstName# #Employee.LastName#</a>
			   </td>
			   <td width="60"><b>Index No:</b></td>
			   <td>#Employee.IndexNo#</td>
			   <!--- 
			   <td><b>Type:</td>
			   <td>#client.category#&nbsp;</td>
			   --->
			   <td width="90"><b>Category/Level:</td>
			   <td>#grade#&nbsp;</td>
			   <td width="70"><b>Office:</td>
			   <td><cfif Unit.OrgUnitName eq "">-<cfelse>#Unit.Mission#&nbsp;-&nbsp;#Unit.OrgUnitNameShort#</cfif>&nbsp;</td>
			  
			   </tr>
		   </table>
		   </td>
		</tr>
		
	</table>
	
</td></tr>

<tr><td bgcolor="C0C0C0" colspan="3"></td></tr>

</cfoutput>
	
</table>

</cfoutput>



