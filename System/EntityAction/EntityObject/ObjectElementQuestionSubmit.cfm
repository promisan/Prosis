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
<cfparam name="Form.CustomDialog" default="">
<cfparam name="Form.InputMemoHTML" default="">
		
<cfif url.questionid eq "">	

	<cfquery name="Insert" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	INSERT INTO Ref_EntityDocumentQuestion
           (DocumentId,
            QuestionId,
            ListingOrder,
            QuestionCode,
            QuestionLabel,
            <cfif trim(Form.questionMemo) neq "">QuestionMemo,</cfif>
            InputMode,
			InputModeStringList,
			InputValuePass,
            EnableInputMemo,
			InputMemoInstruction,
			InputMemoHTML,
			InputMemoSize,
            EnableInputAttachment,
            OfficerUserId,
            OfficerLastName,
            OfficerFirstName )
		   
     VALUES
           ('#Form.documentId#',
            '#Form.questionId#',
             #Form.listingOrder#,
            '#Form.questionCode#',
             '#Form.questionLabel#',
            <cfif trim(Form.questionMemo) neq "">'#Form.QuestionMemo#',</cfif>
            '#Form.inputMode#',
		    '#Form.inputModeStringList#',
		    '#Form.inputValuePass#',
            '#Form.EnableInputMemo#',
			'#Form.InputMemoInstruction#',
			'#Form.InputMemoHTML#',
			<cfif Form.InputMemoSize eq "">
			NULL,
			<cfelse>
			'#Form.InputMemoSize#',
			</cfif>
             #Form.EnableInputAttachment#,
            '#SESSION.acc#',
		    '#SESSION.last#',
		    '#SESSION.first#')		
	</cfquery>
	
	<cf_LanguageInput
			TableCode       = "Questionaire" 
			Mode            = "Save"
			Key1Value       = "#Form.questionId#"
			Lines           = "2"
			Name1           = "questionLabel"
			Name2           = "questionMemo">
	
</cfif>

<cfif url.action eq "update">			
	
	<cfquery name="Update" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE 	Ref_EntityDocumentQuestion
		SET    	ListingOrder           	=  #Form.listingOrder#,
	           	QuestionCode           	= '#Form.questionCode#',
	           	QuestionLabel   		= '#Form.questionLabel#',
	          	QuestionMemo 			= <cfif trim(Form.questionMemo) eq "">null<cfelse>'#Form.QuestionMemo#'</cfif>,
	           	InputMode       		= '#Form.inputMode#',
				InputModeStringList     = '#Form.inputModeStringList#',
				InputValuePass          = '#Form.InputValuePass#',
				InputMemoHTML           = '#Form.InputMemoHTML#',
				<cfif Form.InputMemoSize eq "">
				InputMemoSize           = NULL,
				<cfelse>
				InputMemoSize           = '#Form.InputMemoSize#',
				</cfif>
	           	EnableInputMemo 		=  #Form.EnableInputMemo#,
				InputMemoInstruction    = '#Form.InputMemoInstruction#',
	           	EnableInputAttachment 	=  #Form.EnableInputAttachment#
		WHERE 	DocumentId  			= '#Form.documentId#'
		AND 	QuestionId  			= '#Form.questionId#'
	</cfquery>
	
	<cf_LanguageInput
		TableCode       = "Questionaire" 
		Mode            = "Save"
		Key1Value       = "#Form.questionId#"
		Lines           = "2"
		Name1           = "questionLabel"
		Name2           = "questionMemo">	

<cfelseif url.action eq "delete">	

	<cfquery name="verifyDelete"
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT TOP 1 *
		FROM	OrganizationObjectQuestion
		WHERE 	questionId = '#url.questionId#'
	</cfquery>
	
	<cfif verifyDelete.recordCount eq 0>

		<cfquery name="Delete" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Ref_EntityDocumentQuestion
			WHERE 	DocumentId = '#url.documentId#'
			AND 	QuestionId = '#url.questionId#'
		</cfquery>
		
	</cfif>		
	
</cfif>

<script language="JavaScript">   
     parent.questionrefresh()
	 parent.ProsisUI.closeWindow('myeditquestion',true)	    	          
</script>	