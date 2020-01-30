
<cfquery name="update" 
     datasource="AppsCaseFile">
	 UPDATE stQuestionaireContent 
	 SET     TopicValue = '#url.value#', 
	         OfficerUserId = '#SESSION.acc#',
		     OfficerLastName = '#SESSION.last#',
		     OfficerFirstName = '#SESSION.first#',
		     Created = getDate()		 
	 WHERE   TopicId = '#url.topicId#'
</cfquery>
		
<!--- saving --->