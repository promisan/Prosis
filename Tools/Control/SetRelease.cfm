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