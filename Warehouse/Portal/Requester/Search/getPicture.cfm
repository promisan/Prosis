<cfset vPhoto = "#session.rootdocument#/warehouse/pictures/#vName#.jpg">
<cfif not FileExists('#session.rootdocument#/warehouse/pictures/#vName#.jpg')>
	<cfset vPhoto = "#session.root#/images/noPicture.jpg">
</cfif>