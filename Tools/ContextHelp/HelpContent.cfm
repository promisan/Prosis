
<!--- help content --->

<cfquery name="HelpId" 
datasource="AppsSystem"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM  HelpProjectTopic
	WHERE TopicId       = '#url.topicid#'  	
</cfquery>

<cfoutput>
<table width="100%" height="100%" bgcolor="E6E6E6">
<cfif len(HelpId.UITextHeader) gte "10">
	<tr><td class="labelmedium" style="padding:10px">#HelpId.UITextHeader#</td></tr>
</cfif>
	<tr><td class="labelmedium" style="padding:10px">#HelpId.UITextAnswer#</td></tr>
</table>
</cfoutput>