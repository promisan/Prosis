
<cfif Len(Form.Remarks) gt 200>
    <cfset rem = left(Form.Remarks,200)>
<cfelse>
 	<cfset rem = Form.Remarks>	
</cfif>

<cfquery name="Save" 
datasource="AppsSystem"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	INSERT INTO   HelpProjectTopicFeedback
		(TopicId, Rating, Remarks, OfficerUserId, OfficerLastName, OfficerFirstName)
	VALUES
		('#URL.TopicId#', '#URL.Rating#', '#rem#', '#SESSION.acc#', '#SESSION.last#', '#SESSION.first#')
</cfquery>

<cfoutput>
<script>
	ColdFusion.navigate('HelpDialogFeedback.cfm?status=1&topicid=#URL.topicid#','feedback')	
</script>
</cfoutput>