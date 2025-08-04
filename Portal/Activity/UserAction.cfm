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
<cf_screentop height="100%" scroll="Yes" html="No" jQuery="yes" systemmodule="system" functionclass="portal" functionname="userstatus">

<cf_PresentationScript>
<cf_dialogStaffing>

<cfparam name="URL.View"  default="Hide">
<cfparam name="URL.Group" default="LastName">

<cfoutput>

<script language="JavaScript">

function reloadForm(view,tpe,cls) {
   document.getElementById('mode').value = view
   Prosis.busy('yes')
   if (cls == 'action') {
      ptoken.navigate('UserActionContent.cfm?systemfunctionid=#url.systemfunctionid#&mode='+view+'&scope='+tpe+'&filter=','content')   
   } else {
      ptoken.navigate('UserErrorContent.cfm?systemfunctionid=#url.systemfunctionid#&mode='+view+'&scope='+tpe+'&filter=','content') 
   }
}  

function expiresession(box,id) {       
	ptoken.navigate('setSessionExpiry.cfm?id='+id+'&box='+box,box+'_ajax')		
}

function portal() {
	ptoken.location("../Portal.cfm");
}   

function refresh() {
    Prosis.busy('yes')
	history.go()
}  

</script>

</cfoutput>

<cfif getAdministrator("*") eq "1">

	<cfset Drill.recordcount = "1">
	
<cfelse>

	<cfquery name="Drill" 
	datasource="AppsOrganization">
		SELECT  *
		FROM    OrganizationAuthorization
		WHERE   UserAccount = '#SESSION.acc#'
		AND     Role = 'AdminUser'
	</cfquery>

</cfif>

<cfset day = DateAdd("n", "-1440", "#now()#")>	

<cfquery name="Logon" 
datasource="AppsSystem">
	DELETE  FROM  UserStatus  
	WHERE   ActionTimeStamp < #day#
</cfquery>

<cf_listingscript>

<cfset diff = DateAdd("n", "-#CLIENT.Timeout#", "#now()#")>

<table width="98%" align="center" style="height:100%">

<tr>
    <td valign="top" style="height:5px;padding-left:10px">   
	<cfinclude template="UserActionHeader.cfm">	
    </td>
</tr>
	
<tr>	
	<td style="padding-left:15px;height:100%;min-height:100%" valign="top">	
		<cf_securediv id="content" style="height:100%" bind="url:UserActionContent.cfm?systemfunctionid=#url.systemfunctionid#&mode=current&filter=">        	
	</td>	
</tr>	
	
</table>

