
<cfparam name="attributes.version" default="7">
<cfparam name="attributes.release" default="v20151231">

<cfquery name="Get" 
 datasource="AppsSystem">
	 SELECT * 
	 FROM   Parameter 
	 WHERE  Version = '#Attributes.Version#'
</cfquery>

<cfif Get.recordcount eq "0">

	<cfquery name="System" 
	 datasource="AppsSystem">
	 	UPDATE Parameter  SET Version = '#Attributes.Version#'
	</cfquery>

</cfif>

<cfparam name="SESSION.acc"   default="">
<cfif SESSION.acc eq Get.AnonymousUserId>
   <cfset SESSION.acc = "">
</cfif>
<cfset CLIENT.LogAttachment = Get.LogAttachment>
<cfset CLIENT.Version       = attributes.version>

<cfquery name="Release" 
 datasource="AppsInit">
 	SELECT * 
	 FROM   Parameter 
	 WHERE  ApplicationRelease = '#Attributes.release#'
	 AND    HostName = '#CGI.HTTP_HOST#'
</cfquery>

<cfif Release.recordcount eq "0">

	<cfquery name="System" 
	 datasource="AppsInit">
	 UPDATE Parameter 
	 SET    ApplicationRelease = '#Attributes.release#'
	 WHERE  HostName = '#CGI.HTTP_HOST#'
	</cfquery>

</cfif>

<cfset CLIENT.release      = attributes.release>