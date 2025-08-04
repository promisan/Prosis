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
	<!--- DOCTYPE ----->
	<cfif attributes.doctypeportal eq "Yes">
		<!DOCTYPE >
		<HEAD>
	<cfelse>

		<cfif attributes.doctype eq "HTML" or attributes.doctype eq "Quirks">		
			<cfset standardCSS = "standard.css">
			<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
			<HEAD>
			<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/images/css/#standardCSS#</cfoutput>">
			<script type="text/javascript" src = "<cfoutput>#SESSION.root#</cfoutput>/scripts/Prosis/ProsisScript.js"></script>
		<cfelseif attributes.doctype eq "HTML5">
			<!DOCTYPE HTML>	
			<HTML>
			<HEAD>
		<cfelse>
			<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
			<html xmlns="http://www.w3.org/1999/xhtml">
			<HEAD>
		</cfif>	
	</cfif>
	
	<!--- TITLE- --->
	
	<TITLE><cfoutput>#attributes.title#</cfoutput></TITLE>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />		

	<!--- FAVICON --->
	<cfif attributes.favicon eq "yes">
		<cfoutput>
			<LINK REL="SHORTCUT ICON" type="image/x-icon" HREF="#SESSION.root#/custom/logon/#Parameter.ApplicationServer#/favicon.ico">
		</cfoutput>	
	</cfif>

	<!--- CASCADE STYLESHEETS --->
	<cfoutput>	
	
	<cfif attributes.stylesheet eq "pkdb.css">	
		<link rel="stylesheet" type="text/css" href="#SESSION.root#/Portal/Logon/Bluegreen/pkdb.css"> 			
		<link rel="stylesheet" type="text/css" href="#SESSION.root#/print.css" media="print">
	<cfelseif attributes.stylesheet eq "prosis.css">		
		<link rel="stylesheet" type="text/css" href="#SESSION.root#/Portal/Logon/Bluegreen/prosis.css"> 			
		<link rel="stylesheet" type="text/css" href="#SESSION.root#/print.css" media="print">	
	<cfelse>
		<link rel="stylesheet" type="text/css" href="#SESSION.root#/#client.style#"> 			
		<link rel="stylesheet" type="text/css" href="#SESSION.root#/print.css" media="print">	
	</cfif>	
	</cfoutput>	

	<cfif find ("MSIE 10","#CGI.HTTP_USER_AGENT#")>
		<style>
			table {border-collapse:separate!important}
		</style>
	</cfif>

	<!---- JS SCRIPTS ----->
	
	<cfif attributes.jQuery eq "Yes">
	
		<cfoutput>
			<script type="text/javascript" src="#SESSION.root#/Scripts/jQuery/jquery.js"></script>
			<cf_UIGadgets TreeTemplate="#attributes.TreeTemplate#">
			<cf_tl id="Yes" var="lblYes">
			<cf_tl id="No" var="lblNo">
			<cf_tl id="Cancel" var="lblCancel">
			<cf_tl id="Ok" var="lblOk">
			<script>
				var hostname = "#client.root#";
				var __ProsisWelcome = '#session.welcome#';
				var __ProsisYes = '#lblYes#';
				var __ProsisNo = '#lblNo#';
				var __ProsisCancel = '#lblCancel#';
				var __ProsisOk = '#lblOk#';
			</script>

			<script type="text/javascript" src="#SESSION.root#/Scripts/jQuery/jquery.prosis.js"></script>
			<cfinclude template="ScreenTopProsisAlert.cfm">
			<cfinclude template="ScreenTopWebPrint.cfm">
			
			<cfif attributes.bootstrap eq "Yes">
				<link rel="stylesheet" href="#session.root#/scripts/mobile/resources/vendor/bootstrap/dist/css/bootstrap.css" />
				<script src="#session.root#/scripts/mobile/resources/vendor/bootstrap/dist/js/bootstrap.min.js"></script>
			</cfif>
			
		</cfoutput>
		<cfif attributes.Signature eq "Yes">
			<cf_UISignatureViewScript>
		</cfif>

	</cfif>

	<cfoutput>
		<script type="text/javascript">
			// Change cf's AJAX "loading" HTML
			_cf_loadingtexthtml="<img src='#SESSION.root#/images/#attributes.busy#'/>";
			
			<cfif attributes.onfocus neq "">
			
		    $( document ).ready(function() {
				  $(window).focus(function() {				      
					  #attributes.onfocus#()
					//do the needful here.
				});
			});
			
			</cfif>
			
			<cfif attributes.onclose neq "">
			
				 $( document ).ready(function() {
				      $(window).on("beforeunload", function() { 
						  alert('a')
						//do the needful here.
					});
				});
			
			</cfif>
						
		</script>
				
	</cfoutput>

	<!--- 20/10/2012 the below invisible button is used by the framework to trigger a closing of the screen --->
	<cfif attributes.mail eq "No">
	
	    <!--- we are now loading scripts --->
		
		<!--- base ajax handling support --->
		<cfajaximport>
		<cf_SystemScript>

		<!--- script for managing the session validation --->
											
		<cfif attributes.ValidateSession eq "Yes">
			<cf_SessionValidateScript>
		</cfif>	
	
		<cfif Parameter.EnableCM eq "0">
		
			<cfif find("rightclick",attributes.blockevent)>
	
				<script language="JavaScript">
					document.oncontextmenu=new Function("return false")
				</script>
	
				<cf_dropdown>	
	
			</cfif>
	
		</cfif>
	
		<cfif find("onkeyup",attributes.blockevent)>
	
			<script language="JavaScript">
				document.onkeyup=new Function("return false")
			</script>
	
		</cfif>
	
	</cfif>

		
</HEAD>

