<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<cfoutput>

<cfparam name="SESSION.welcome" default="Prosis">

<html>
<head>
	<title>Travel Claim Portal (TCP)</title>
</head>

<cf_dialogStaffing>

<cfif URL.home eq "Portal" and URL.mycl eq "">

	<script language="JavaScript">

	function home() {
	    parent.window.location = "../ClaimView/ClaimView.cfm?ID=travelclaim&PersonNo=#URL.PersonNo#"
	 }
 
   </script>
   
<cfelse>   

	<script language="JavaScript">
	function home() {
     parent.window.close() 
	}
	 
	</script>
 
</cfif> 

<cfparam name="URL.ID" default="TravelClaim">

<body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0">

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#</cfoutput>/<cfoutput>#client.style#</cfoutput>"> 

<cfif url.home neq "close">

	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr><td><cf_logintopbanner functionName="TravelClaim"></td></tr>
    <tr><td>
	<cfinclude template="../ClaimView/ClaimViewBanner.cfm">
    </td></tr>
	</table>
<cfelse>
	
	<cfquery name="System" 
	datasource="AppsSystem">
		SELECT *
		FROM Ref_ModuleControl
		WHERE SystemModule = 'Portal'
		AND   FunctionClass = 'SelfService'
		AND   FunctionName = '#URL.ID#'
	</cfquery>
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr><td bgcolor="black">
		
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr>
			<td width="86%" height="23">
			<font face="Verdana" color="white"><b>&nbsp;<cfif URL.home eq "Portal">Prepare my </cfif>Travel Claim</b></font></td>
			<td align="center">
			<b>
			 <cf_helpfile 	
			 	code = "TravelClaim" 
				id   = "0">
			</b>
			</td>
			<td align="center"><a href="javascript:home()" title="Return to portal">
			<font color="white" face="Verdana"><b><cfif URL.home eq "Portal" and URL.mycl eq "">Home<cfelse>Exit</cfif></b></a>
			</td>
		</tr>
		
		<tr><td colspan="3" valign="top">
				<cfinclude template="ClaimRequest.cfm">
			</td>
		</tr>
		
		</table>
	
	</td>
	<td></td>
	</tr>
	
	</table>
	
</cfif>	

</cfoutput>

</body>
</html>
