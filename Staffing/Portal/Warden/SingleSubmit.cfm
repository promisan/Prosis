<cfquery name = "Init" 
	datasource= "AppsEmployee"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM PersonMedicalStatus
	WHERE PersonNo = '#Client.PersonNo#'
	AND   Topic    = '#URL.Code#'
</cfquery>


<cfquery name = "qTopicValue" 
	datasource = "AppsEmployee"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT RT.ListValue
	FROM Ref_TopicList RT 
	WHERE 
	RT.Code = '#URL.Code#'
	AND RT.ListCode = '#URL.ListCode#'
</cfquery>


<cfquery name = "PS" 
	datasource= "AppsEmployee"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO PersonMedicalStatus (
		PersonNo, 
		Topic, 
		ListCode, 
		TopicValue, 
		OfficerUserId, 
		OfficerLastName, 
		OfficerFirstName)
	VALUES 		
	('#CLIENT.PersonNo#',
	'#URL.Code#',
	'#URL.ListCode#',
	'#qTopicValue.ListValue#',
	'#SESSION.acc#',
	'#SESSION.last#',
	'#SESSION.first#')
</cfquery>


<cfquery name = "Update_PMA" 
	datasource= "AppsEmployee"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE PersonMedicalAction 
	SET DateExpiration = '#DateFormat(now(),CLIENT.DateSQL)#'
	WHERE PersonNo = '#Client.PersonNo#'
	AND   Topic    = '#URL.Code#'
</cfquery>


<cfquery name = "PMA"
	datasource= "AppsEmployee"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO PersonMedicalAction (
		PersonNo, 
		Topic, 
		ListCode, 
		TopicValue,
		DateEffective, 
		OfficerUserId, 
		OfficerLastName, 
		OfficerFirstName)
	VALUES 		
	('#CLIENT.PersonNo#',
	'#URL.Code#',
	'#URL.ListCode#',
	'#qTopicValue.ListValue#',
	'#DateFormat(now(),CLIENT.DateSQL)#',
	'#SESSION.acc#',
	'#SESSION.last#',
	'#SESSION.first#')
</cfquery>



