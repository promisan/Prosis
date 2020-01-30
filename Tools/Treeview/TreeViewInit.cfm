<cfparam name="url.opacity" 		default="0">
<cfparam name="attributes.opacity" 	default="#url.opacity#">

<cf_screenTop html="no" jquery="no">

<cfquery name="Init" 
	datasource="AppsInit">
	SELECT * 
	FROM   Parameter
	WHERE  HostName = '#cgi.http_host#'		
</cfquery>

<cfdiv id="divAnimation" bind="url:#session.root#/#Init.TreeAnimationPath#/AnimationWrapper.cfm?opacity=#attributes.opacity#">
