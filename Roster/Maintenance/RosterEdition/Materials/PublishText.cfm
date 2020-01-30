<cfparam name="Object.ObjectKeyValue1" default="">
<cfparam name="url.submissionedition" default="#Object.ObjectKeyValue1#">

<cfquery name="defaultLanguage"
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   TOP 1 * 
	FROM     Ref_SystemLanguage
	WHERE    LanguageCode != ''
	AND      SystemDefault = 1
</cfquery>

<cfparam name="URL.languagecode" default="#defaultLanguage.LanguageCode#">

<cfparam name="Action.ActionId" default="00000000-0000-0000-0000-000000000000">
<cfparam name="URL.ActionId" default="#Action.ActionId#">

<cfoutput>
	
	<cf_divscroll>
	
		<cfform action="#session.root#/Roster/Maintenance/RosterEdition/Materials/PublishTextSubmit.cfm?submissionedition=#url.submissionedition#&languagecode=#url.languagecode#&actionid=#url.actionid#&nocache=yes" name="profile#url.languagecode#">
	
			<cfinclude template="PublishTextContent.cfm">
	
		</cfform>	
	
	</cf_divscroll>

</cfoutput>
