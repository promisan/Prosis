
<cfparam name="Form.Operational"        default="0">
<cfparam name="Form.TopicId"            default="">
<cfparam name="Form.TopicPhrase"        default="">

<cfif URL.TopicId neq "new">

	 <cfquery name="Update" 
		  datasource="AppsSelection" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE FunctionOrganizationTopic
		  SET    Operational         = '#Form.Operational#',
 		         TopicPhrase         = '#Form.TopicPhrase#',
				 TopicOrder          = '#Form.TopicOrder#',
				 Parent              = '#Form.Parent#'
		  WHERE  TopicId    = '#URL.topicid#'
		  AND    FunctionId = '#URL.IdFunction#'
	</cfquery>
				
<cfelse>
			
			<cf_assignid>
		
			<cfquery name="Insert" 
			     datasource="AppsSelection" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO  FunctionOrganizationTopic
			         (FunctionId,TopicId,
				     TopicPhrase,
					 TopicOrder,
					 Parent,
					 Operational,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
			      VALUES ('#url.idfunction#',
				      '#rowguid#',
					  '#Form.TopicPhrase#',
					  '#Form.TopicOrder#',
					  '#Form.Parent#',
			      	  '#Form.Operational#',
					  '#SESSION.acc#',
					  '#SESSION.last#',
					  '#SESSION.first#')
			</cfquery>
					   	
</cfif>

<cfset url.topicid = "">
<cfinclude template="RecordListingDetail.cfm">
