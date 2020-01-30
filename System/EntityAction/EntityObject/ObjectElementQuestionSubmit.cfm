<cfparam name="Form.CustomDialog" default="">
		
<cfif ParameterExists(Form.Save)>	

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
			InputValuePass,
            EnableInputMemo,
            EnableInputAttachment,
            OfficerUserId,
            OfficerLastName,
            OfficerFirstName
			)
		   
     VALUES
           ('#Form.documentId#',
           '#Form.questionId#',
           #Form.listingOrder#,
           '#Form.questionCode#',
           '#Form.questionLabel#',
           <cfif trim(Form.questionMemo) neq "">'#Form.QuestionMemo#',</cfif>
           '#Form.inputMode#',
		   '#Form.inputValuePass#',
           #Form.EnableInputMemo#,
           #Form.EnableInputAttachment#,
           '#SESSION.acc#',
		   '#SESSION.last#',
		   '#SESSION.first#'         
		   )		
	</cfquery>
	
	<cf_LanguageInput
			TableCode       = "Questionaire" 
			Mode            = "Save"
			Key1Value       = "#Form.questionId#"
			Lines           = "2"
			Name1           = "questionLabel"
			Name2           = "questionMemo">
	
	<script language="JavaScript">   
	     parent.parent.questionrefresh()
		 parent.parent.ColdFusion.Window.destroy('myeditquestion',true)	    	          
	</script>				
	
</cfif>

<cfif ParameterExists(Form.Update)>			
	
	<cfquery name="Update" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE 	Ref_EntityDocumentQuestion
	SET    	ListingOrder           	= #Form.listingOrder#,
           	QuestionCode           	= '#Form.questionCode#',
           	QuestionLabel   		= '#Form.questionLabel#',
          	QuestionMemo 			= <cfif trim(Form.questionMemo) eq "">null<cfelse>'#Form.QuestionMemo#'</cfif>,
           	InputMode       		= '#Form.inputMode#',
			InputValuePass          = '#Form.InputValuePass#',
           	EnableInputMemo 		= #Form.EnableInputMemo#,
           	EnableInputAttachment 	= #Form.EnableInputAttachment#
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
	
	<script language="JavaScript">   
	     parent.parent.questionrefresh()
		 parent.parent.ColdFusion.Window.destroy('myeditquestion',true)	    	          
	</script>			

</cfif>	

<cfif ParameterExists(Form.Delete)>			

	<cfquery name="verifyDelete"
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT TOP 1 *
		FROM	OrganizationObjectQuestion
		WHERE 	questionId = '#Form.questionId#'
	</cfquery>
	<cfif verifyDelete.recordCount eq 0>

		<cfquery name="Delete" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Ref_EntityDocumentQuestion
			WHERE 	documentId = '#Form.documentId#'
			AND 	questionId = '#Form.questionId#'
		</cfquery>
		
	</cfif>
	
	<script language="JavaScript">   
	     parent.parent.questionrefresh()
		 parent.parent.ColdFusion.Window.destroy('myeditquestion',true)	    	          
	</script>		
	
</cfif>