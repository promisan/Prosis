
<cfparam name="client.logoncredential"          default="#session.acc#">
<cfparam name="url.mission" 					default="">
<cfparam name="url.mode" 						default="default">
<cfparam name="url.menuClass" 					default="process">
<cfparam name="url.showNavigationOnFirstPage" 	default="0">
<cfparam name="url.showReload" 					default="1">
<cfparam name="url.showLogin" 					default="0">
<cfparam name="url.public"   					default="internal">
<cfparam name="url.tab" 		                default="">

<cfset vPortalMode = url.mode>

<cfinclude template="MainPagePreparation.cfm">
<cfinclude template="MainPageBody.cfm">
