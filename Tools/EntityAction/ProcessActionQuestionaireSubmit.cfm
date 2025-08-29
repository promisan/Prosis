<!--
    Copyright © 2025 Promisan B.V.

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