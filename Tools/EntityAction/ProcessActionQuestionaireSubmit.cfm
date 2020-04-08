<!--- saving --->

<cfquery name="check" 
     datasource="AppsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT * 
		 FROM   OrganizationObjectQuestion
		 WHERE  ObjectId = '#url.objectid#'
		 AND    ActionCode = '#url.actioncode#'
		 AND    QuestionId = '#url.questionid#'	
</cfquery>

<cfif check.recordcount eq "0">
	
	<cfquery name="check" 
	     datasource="AppsOrganization" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 INSERT INTO OrganizationObjectQuestion
		        (ObjectId,ActionCode,QuestionId,OfficerUserId,OfficerLastName,OfficerFirstName)
		 VALUES
		        ('#url.objectid#','#url.actioncode#','#url.questionid#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')	
	</cfquery>

</cfif>

<cfif url.field eq "score">

    <cfparam name="form.#url.formfield#" default="0">	
	<cfset score = evaluate("form.#url.formfield#")>	
		
	<cfquery name="check" 
	     datasource="AppsOrganization" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 UPDATE  OrganizationObjectQuestion
		 SET     QuestionScore = '#score#'
		 WHERE   ObjectId      = '#url.objectid#'
		 AND     ActionCode    = '#url.actioncode#'
		 AND     QuestionId    = '#url.questionid#'	 
	</cfquery>

<cfelseif url.field eq "memo">
	
	<cfparam name="form.#url.formfield#" default="">
	
	<cfset memo = evaluate("form.#url.formfield#")>
		
	<cfquery name="check" 
	     datasource="AppsOrganization" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 UPDATE  OrganizationObjectQuestion
		 SET     QuestionMemo = '#memo#'
		 WHERE   ObjectId     = '#url.objectid#'
		 AND     ActionCode   = '#url.actioncode#'
		 AND     QuestionId   = '#url.questionid#'	
	</cfquery>

</cfif>