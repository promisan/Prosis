
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

<table width="98%" align="center" style="height:100%" class="formpadding formspacing">

<tr class="linedotted">
    <td valign="top" style="height:10px">   
	<cfinclude template="UserActionHeader.cfm">	
    </td>
</tr>
	
<tr>	
	<td style="height:100%;min-height:100%" valign="top">	
		<cf_securediv id="content" style="height:100%" bind="url:UserActionContent.cfm?systemfunctionid=#url.systemfunctionid#&mode=current&filter=">        	
	</td>	
</tr>	
	
</table>

