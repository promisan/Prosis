<!---
	RotationListingBatchSubmit.cfm
	
	Process the submit action the RotationListingBatch page.
	
	Hidden fields in calling template:
	documentno 	= #URL.DocumentNo#
    actionid   	= #URL.ActionId#"
    no			= #SearchResult.recordCount# (no of candidates who have completed workflow step prior to current step 
	
	Called by: RotationListingSubmit.cfm
	
	Modification History:

--->
<link rel="stylesheet" type="text/css" href="../../../<cfoutput>#client.style#</cfoutput>">

<!--- to control URL value depending on current module VACANCY or TRAVEL --->
<cfquery name="WhichModule" datasource="#CLIENT.Datasource#"
 username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT TOP 1 DocumentLibrary AS Name
    FROM Parameter
</cfquery>

<!--- Loop through each rotating personnel in the RotationListing page --->
<cfloop index="Rec" from="1" to="#Form.No#">

	<!--- create reference to checkbox control of current person in loop: Form.Select_n, where n is an integer --->
	<cfset field = "Form.Select_"&#Rec#>
	<cfparam name="#field#" default="0">

	<!--- evaluate if checkbox of current person --->
	<cfset x = Evaluate("Form.Select_" & #Rec#)>
	
	<!--- IF checkbox is checked --->
	<cfif #x# eq "1">

	   	<cfset Candidate = Evaluate("Form.AssignmentNo_" & #Rec#)>
   
	   	<cfset dateValue = "">
	   	<CF_DateConvert Value="#FORM.ActionDateActual#">
	   	<cfset DateAction = #dateValue#>

		
		<cfif #Form.actionStatus# EQ "6">
			<!--- If user selected "No further action" in Activity Status drop list in batch submit page... --->
			<!--- Mark each nominee selected in Batch submit page with status 6 --->
			<cfquery name="Update" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
			    UPDATE DocumentCandidate
			    SET   Status      = '6'
			    WHERE DocumentNo  = '#FORM.DocumentNo#'
				AND PersonNo      = '#Candidate#'
			</cfquery>
  
		<cfelseif #Form.actionStatus# eq "9"> <!--- withdrawn ---> 
  			<!--- If user selected "Revoked" in Activity Status drop list in batch submit page... --->
			<!--- Mark each nominee selected in Batch submit page with status 9 --->			
		    <cfquery name="UpdateDocument" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
				UPDATE DocumentCandidate
				SET Status          = '9'
      			WHERE 	DocumentNo	= '#Form.DocumentNo#'	
      			AND 	PersonNo	= '#Candidate#'
     		</cfquery>

		<cfelseif #Form.ActionStatus# eq "2" >	
  			<!--- If user selected "Reset" in Activity Status drop list in batch submit page... --->
			
			<!--- Get the value of ActionId specified in ActionResetToOrder field for current workflow step --->
    		<cfquery name="Check" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
				SELECT ActionResetToOrder FROM DocumentFlow
				WHERE 	ActionId   	= '#FORM.ActionId#'
		   		AND  	DocumentNo  = '#FORM.DocumentNo#'
     		</cfquery>
		   
			<!--- Change status back to "Pending" for all DocumentCandidateActions steps from the specified "reset" step onwards --->
    	 	<cfquery name="Update" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
				UPDATE DocumentCandidateAction
				SET ActionStatus    	= '0',
					ActionDateActual    = NULL,
					ActionUserId        = '#SESSION.acc#',
					ActionLastName      = '#SESSION.last#',
					ActionFirstName     = '#SESSION.first#',	
					ActionDate          = #now()#,
					ActionMemo          = '#Form.ActionMemo#'	
				WHERE 	DocumentNo    	= '#FORM.DocumentNo#'
				AND 	PersonNo        = '#Candidate#'
				AND 	ActionOrder   	>= '#Check.ActionResetToOrder#'
			</cfquery>
			    
		<cfelseif #Form.actionStatus# EQ "1" OR #Form.actionStatus# EQ "7" OR #Form.actionStatus# EQ "8">
   			<!--- If user selected "Completed", "Bypassed", or "N/A" in Activity Status drop list in batch submit page... --->
			<cfset dateValue = "">
			<CF_DateConvert Value="#FORM.ActionDateActual#">
			<cfset DateAction = #dateValue#>
      
		   	<!--- Get name of (submit) processing template to use from FlowActionRule table --->   
			<cfquery name="Rule" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
			   	SELECT * FROM FlowActionRule
			   	WHERE ActionId  = '#FORM.ActionId#'
				AND  RuleTriggerClass = 'Submit'
			</cfquery>
      
	  		<!--- If a processing template (such as SubmitIndexNo.cfm or SubmitFinal.cfm is found ... --->
			<cfif #Rule.RecordCount# EQ 1>   
   				<!--- execute the processing template --->
				<cfmodule template="#Rule.RuleTemplate#"
				   Action   = #Form.DocumentNo#
				   Person   = #Candidate#
				   ActionId = #FORM.ActionId#>
	  
   				<!--- if completion status is ZERO (not successful), 
				      display informational message, refresh Request Details page, and exit this template --->
				<cfif #go# eq "0">			
					<cfoutput>
						<script language="JavaScript">
				    		alert("#message#");
						 	window.close();
        		     		opener.location.reload();
						</script>
					</cfoutput>
					<cfexit method="EXITTEMPLATE">
				</cfif>				
			</cfif>   	
   
   			<!--- If processing template (if any) was SUCCESSFUL, update appropriate DocumentCandidateAction recs --->
			<cfquery name="Update" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    			UPDATE DocumentCandidateAction
    			SET 
				ActionStatus    	= '#Form.actionStatus#',
				ActionDateActual    = #DateAction#,
				ActionUserId        = '#SESSION.acc#',
				ActionLastName      = '#SESSION.last#',
				ActionFirstName     = '#SESSION.first#',	
				ActionDate          = #now()#,	
				ActionMemo          = '#Form.ActionMemo#',
				ActionReference     = '#Form.ActionReference#'
    			WHERE DocumentNo    = '#FORM.DocumentNo#'
				AND PersonNo 		= '#Candidate#'
				AND ActionId 		= '#FORM.ActionId#'
	    	</cfquery>

		</cfif>	

		<!--- User action logging --->
	
		<!--- Execute ..Template/DocumentActionNo.cfm (write to user action to log --->
		<cf_DocumentActionNo 
   		   	ActionRemarks="" 
   			ActionCode="ACT">  
	   
		<!--- current user session (UserActionNo) is aggregated in Parameter and value is then returned --->
		<cfset ActionNo = #UserActionNo#>

		<!--- Log action for this candidate into DocumentActionAction (for ActionHistory display) --->
    	<cfquery name="DocumentActionAction" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
				INSERT INTO  DocumentActionAction
	    	  	(DocumentNo,
		  		PersonNo,
    	  		ActionId, 
		      	UserActionNo, 
    		  	ActionDateActual,
	  			ActionStatus)
		    	VALUES 
    		  	('#Form.DocumentNo#',
	  			'#Candidate#',
	    	  	'#Form.ActionId#',
    	  		#ActionNo#,
	      		#DateAction#,
		      	'#Form.actionStatus#')
		</cfquery> 
		
		<!--- End of User Action Logging --->
		
		<!--- ****** 01May04 New code to handle AUTO-PROCESSING of step(s) following current workflow step being processed ******* --->
		<!--- Check if action is Completed, By-Passed, or N/A, check if next step(s) to current workflow step requires auto processing. 
			  Note that the next ActionId is stored in RuleTemplate field (not really for this use but works! --->				
  		<cfif #WhichModule.Name# EQ "travel">		<!--- added 14June04 --->
		  <cfif #Form.actionStatus# EQ "1" OR #Form.actionStatus# EQ "7" OR #Form.actionStatus# EQ "8">
			<cfquery name="ChkNextStep" datasource="#CLIENT.Datasource#" 
			 username="#SESSION.login#" password="#SESSION.dbpw#">
		   		SELECT ActionId, RuleTemplate AS NextActionId FROM FlowActionRule
			   	WHERE ActionId  = '#Form.ActionId#'
				AND   RuleTriggerClass = 'Next'
			</cfquery>		

			<!--- If current step indicates need to auto-process following step, set following step to "In-Process" --->
			<cfif #ChkNextStep.RecordCount# GT 0>

				<cfquery name="Update" datasource="#CLIENT.Datasource#" 
				 username="#SESSION.login#" password="#SESSION.dbpw#">
    				UPDATE DocumentCandidateAction
    				SET 
					ActionStatus    	= '7',
					ActionDateActual    = #DateAction#,
					ActionUserId        = '#SESSION.acc#',
					ActionLastName      = '#SESSION.last#',
					ActionFirstName     = '#SESSION.first#',	
					ActionDate          = #now()#,	
					ActionMemo          = '#Form.ActionMemo#',
					ActionReference     = '#Form.ActionReference#'
    				WHERE DocumentNo    = '#FORM.DocumentNo#'
					AND PersonNo 		= '#Candidate#'
					AND ActionId 		= '#ChkNextStep.NextActionId#'
		    	</cfquery>
			
				<!--- Log action via ..Template/DocumentActionNo.cfm --->
				<cf_DocumentActionNo 
    			   	ActionRemarks="" 
	   	   			ActionCode="ACT">  
		   
				<!--- current user session (UserActionNo) is aggregated in Parameter and value is then returned --->
				<cfset ActionNo = #UserActionNo#>
	
				<!--- Log action for this candidate into DocumentActionAction --->
	    		<cfquery name="DocumentActionAction" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
					INSERT INTO  DocumentActionAction
		    	  	(DocumentNo,
			  		PersonNo,
	      			ActionId, 
		    	  	UserActionNo, 
	    	  		ActionDateActual,
			  		ActionStatus)
			    	VALUES 
    			  	('#Form.DocumentNo#',
	  				'#Candidate#',
	    		  	'#ChkNextStep.NextActionId#',
	    		  	#ActionNo#,
    	  			#DateAction#,
			      	'7')
				</cfquery> 
			</cfif>  <!--- ChkNextStep.Recordcount --->
		  </cfif>   <!--- Form.ActionStatus --->
	  	</cfif>	  <!--- WhichModule.Name --->
		<!--- ******************* End of 1May04 / 14June04 modification ********************* --->
		
	</cfif>		<!--- #x# --->

</cfloop>  


<!--- audit trail --->
<!--- Log through each person in batch submit page --->
<cfloop index="Rec1" from="1" to="#Form.No#">

	<cfif isDefined("Form.Select_"&#Rec1#)> 

	   	<cfset Candidate = Evaluate("Form.PersonNo_" & #Rec1#)>

   		<CF_RegisterAction 
	   	SystemFunctionId="1101" 
	   	ActionClass="Document" 
   		ActionType="Update Candidate" 
	   	ActionReference="#FORM.DocumentNo# #Candidate#" 
	   	ActionScript="">  
   
   		<!--- now check the overall candidate status --->
   
   		<!--- Check if there are DocumentCandidateAction recs that are pending, bypassed, or revoked --->
	   	<cfquery name="GetStatus" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
		    SELECT DISTINCT DocumentNo FROM DocumentCandidateAction V
	    	WHERE (V.ActionStatus  	= '0' or V.ActionStatus = '7' or V.ActionStatus = '9')
			AND PersonNo         	= '#Candidate#'
			AND DocumentNo       	= '#Form.DocumentNo#'
	   	</cfquery>
     
	 	<!--- IF there are none, mark this Candidate as "Selected" (not really applicable in PM TRAVEL) --->	
  		<cfif GetStatus.recordCount EQ "0">	  
	  		<cfquery name="UpdateDocument" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
				UPDATE DocumentCandidate
   				SET Status       = '3'
		   		WHERE DocumentNo = '#Form.DocumentNo#'	
   				AND PersonNo     = '#Candidate#'
			</cfquery>  
		</cfif>
  
	</cfif>   
   
</cfloop>   

<script>
   window.close()
   opener.location.reload()
</script>