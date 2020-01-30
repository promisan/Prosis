<!---
	  Travel/Application/Rules/SubmitProcessNext.cfm
	  
	  Process the action following the current action the candidate batch submit page.
	  
	  Called by: Travel/Application/Template/DocumentEditCandidateBatchSubmit.cfm
	
	  Params:
		  Action, ActionId, PersonCnt (see below for description)
--->

<cfparam name="Attributes.Action" default="0">   	<!--- this the DocumentNo --->
<cfparam name="Attributes.ActionId" default="0">	<!--- this the ActionId (actually the step following the one currently being processed by user --->
<cfparam name="Attributes.PersonCnt" default="0">	<!--- Number of nominees selected in batch submit page --->

--->
<link rel="stylesheet" type="text/css" href="../../../<cfoutput>#client.style#</cfoutput>">

<!--- Loop through each candidate in the batch submit page --->
<cfloop index="Rec" from="1" to="#Form.No#">

	<!--- create reference to checkbox control of current person in loop: Form.Select_n, where n is an integer --->
	<cfset field = "Form.Select_"&#Rec#>
	<cfparam name="#field#" default="0">

	<!--- evaluate if checkbox of current person --->
	<cfset x = Evaluate("Form.Select_" & #Rec#)>
	
	<!--- IF checkbox is checked --->
	<cfif #x# eq "1">

	   	<cfset Candidate = Evaluate("Form.PersonNo_" & #Rec#)>
   
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
      
	  		<!--- If a processing template is found ... --->
			<cfif #Rule.recordCount# eq 1>
   
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
   
   			<!--- If processing template (if any) ended in SUCCESS, update appropriate DocumentCandidateAction recs --->
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
	
		<cfelseif #Form.actionStatus# eq "2" >	
  			<!--- If user selected "Reset" in Activity Status drop list in batch submit page... --->
			
			<!--- Get the value of ActionId specified in ActionResetToOrder field for current workflow step --->
    		<cfquery name="Check" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
				SELECT ActionResetToOrder FROM DocumentFlow
				WHERE ActionId   = '#FORM.ActionId#'
		   		AND  DocumentNo  = '#FORM.DocumentNo#'
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
				WHERE DocumentNo    	= '#FORM.DocumentNo#'
				AND PersonNo        	= '#Candidate#'
				AND ActionOrder    		>= '#Check.ActionResetToOrder#'
			</cfquery>
	
		</cfif>	
 
		<!--- Execute ..Template/DocumentActionNo.cfm --->		
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
	      	'#Form.ActionId#',
    	  	#ActionNo#,
      		#DateAction#,
	      	'#Form.actionStatus#')
		</cfquery> 
   
	</cfif>  

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

<!--- Check if next step (to current workflow step) requires auto processing --->   
<cfquery name="ChkNextStep" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
   	SELECT * FROM FlowActionRule
   	WHERE ActionId  = '#FORM.ActionId#'
	AND   RuleTriggerClass = 'Next'
</cfquery>

<!--- This is where we call template to auto process the Request Medical Clearance (CPD), and Medically clear nominee (CPD/FGS) steps --->
<cfif #ChkNextStep# GT 0>
	<cfmodule template="#ChkNextStep.RuleTemplate#"
	   Action   = #Form.DocumentNo#
	   ActionId = #FORM.ActionId#
	   PersonCnt= #FORM.No#>
</cfif>

<script>
   window.close()
   opener.location.reload()
</script>