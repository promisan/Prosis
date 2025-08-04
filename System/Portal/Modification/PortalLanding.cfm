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

<head>

<cf_menuscript>
<cf_listingscript>
<cf_dialogstaffing>

<cfoutput>
<cf_screentop html="no" scroll="no">

<script type="text/javascript">
  // Change cf's AJAX "loading" HTML
  _cf_loadingtexthtml="<div><img src='#SESSION.root#/images/busy5.gif'/>";
</script>

	<script>
	var mycallBack = function(){
        document.getElementById("dcomments").innerHTML = "<font size='2' face='calibri' color='green'><i>e-Mail was sent succesfully</i></font>";
	} 

	var myerrorhandler = function(errorCode,errorMessage){
        alert("[In Error Handler]" + "\n\n" + "Error Code: " + errorCode + "\n\n" + "Error Message: " + errorMessage);
	} 

	function ajaxemail(name,indexno,account,telephone,mailfrom,infoabout,cbody) {	
        ColdFusion.navigate('mail.cfm?id=#url.id#&name='+name+'&indexno='+indexno+'&account='+account+'&telephone='+telephone+'&mailfrom='+mailfrom+'&infoabout='+infoabout+'&cbody='+cbody,'dhidden',mycallBack,myerrorhandler); alert("Your request was sent, the ICT Services department will contact you shortly."); window.close();
	}
	
	function errorview(id) {
	    window.open("#SESSION.root#/System/Access/User/Audit/ListingErrorDetail.cfm?drillid="+id,"_blank", "left=20, top=20, width=800, height=800, menubar=no, status=yes, toolbar=no, scrollbars=no, resizable=yes")	  
	}
		
	</script>
	
</cfoutput>

	<style>
	input.fnormal {
		padding:1px; 
		height:18px; 
		width:200px;
		border:1px solid silver
		}
		
	td.fnormal {
		font:normal 12px verdana;
		color:gray;
		padding-right:30px;
		text-align:right;
		width:30%;
		height:22px;
		}
	td.finput {
		width:70%;
		height:22px;
		}
	</style>
	
	
</head>

<cfoutput>

<cfajaximport tags="cfchart">

<cfquery name="System" 
datasource="AppsSystem">
	SELECT *
	FROM   Ref_ModuleControl
	WHERE  SystemModule   = 'SelfService'
	AND    FunctionClass  IN ('SelfService','Portal')
	AND    FunctionName   = '#URL.ID#' 
</cfquery>

<cfparam name="URL.Label"    default="ICT">
<cfparam name="URL.PersonNo" default="#client.PersonNo#">

<!--- populate slide menu --->
<cfoutput>
<LINK REL=StyleSheet HREF="#SESSION.root#/Portal/selfservice/extended/style.css" TYPE="text/css">

<script language="JavaScript1.2" src="#SESSION.root#/Portal/selfservice/extended/script.js"></script>

<LINK REL=StyleSheet HREF="#SESSION.root#/Portal/Logon/Bluegreen/pkdb.css" TYPE="text/css">

</cfoutput>

<table width="100%" height="100%" align="center" border="0" cellspacing="0" cellpadding="0" bgcolor="transparent">

<tr><td bgcolor="transparent">

<table width="100%" height="100%" align="center" border="0" cellspacing="0" cellpadding="0" bgcolor="transparent">
	
<tr>
	<td height="45px" bgcolor="transparent" valign="bottom" style="padding-left:50px; background-image:url('<cfoutput>#SESSION.root#</cfoutput>/Portal/Selfservice/Extended/Images/menu/bar_bg2.png'); background-position:bottom; background-repeat:repeat-x">
		<cfinclude template="../../../Portal/SelfService/Extended/LogonProcessMenu.cfm">
	</td>
</tr>

<tr>
	<td id="menucontent" valign="top" bgcolor="white" style="padding-left:20px; padding-right:20px">
	    <!--- load content of the first menu item dynamically --->		
		<cfinclude template="../../../Portal/SelfService/PortalFunctionOpen.cfm">			
	</td>
</tr>	
	
</table>

</td></tr>

</table>

</cfoutput>	 

