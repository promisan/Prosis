<cfparam name="Form.CustomDialog" default="">
		
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