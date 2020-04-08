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

<!--- with result we do several evaluations --->

<cfquery name="config" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  * 
	FROM  	Ref_EntityDocumentQuestion	
	WHERE 	QuestionId  			= '#url.questionId#'
</cfquery>

<cfquery name="get" 
	     datasource="AppsOrganization" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT * FROM OrganizationObjectQuestion		 
		 WHERE   ObjectId     = '#url.objectid#'
		 AND     ActionCode   = '#url.actioncode#'
		 AND     QuestionId   = '#url.questionid#'	
</cfquery>

<cfif config.InputMemoInstruction neq "">
    <cf_tl id="#config.InputMemoInstruction#" var="1">
<cfelse>
	<cf_tl id="Please provide explanation" var="1">
</cfif>

<cfoutput>

<cfif config.EnableInputMemo eq "2" and get.QuestionMemo eq "">
	<font color="FF0000">#lt_text#</font>	
<cfelseif config.EnableInputMemo eq "3" and get.QuestionMemo eq "" and config.InputValuePass neq get.QuestionScore>		
	<font color="FF0000">#lt_text#</font>	
<cfelseif config.EnableInputMemo eq "4" and get.QuestionMemo eq "" and config.InputValuePass eq get.QuestionScore>
    <font color="FF0000">#lt_text#</font>		
<cfelse>
    <!--- nada --->	
</cfif>

</cfoutput>