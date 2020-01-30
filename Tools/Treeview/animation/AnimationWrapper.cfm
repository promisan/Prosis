<cfparam name="url.opacity" default="0">

<cfset vOpacity = "">
<cfif url.opacity eq 1>
	<cfset vOpacity = "opacity:0.25; filter:alpha(opacity=25); -ms-filter:'progid:DXImageTransform.Microsoft.Alpha(Opacity=25)';">
</cfif>

<cfquery name="Init" 
	datasource="AppsInit">
	SELECT * 
	FROM   Parameter
	WHERE  HostName = '#cgi.http_host#'		
</cfquery>
    

<style type="text/css">

      #divAnimation { height: 100%; margin: 0px; padding: 0px; background: url('<cfoutput>#SESSION.root#</cfoutput>/Images/modules.jpg'); background-size: cover; background-position: right; }

</style>

<cfoutput>
<div style="margin:0;padding:0;height:100%;text-align:right;">
</div>
</cfoutput>