<!--
    Copyright © 2025 Promisan

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

<cf_screentop jquery="Yes" html="No" scroll="No">

<cfoutput>

<cftransaction action="begin"> 

	<!--- tasks --->			
		
	<cfquery name="Init" 
     datasource="AppsEPAS" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     DELETE FROM ContractEvaluationActivity
		 WHERE  EvaluationId = '#URL.EvaluationId#'
	</cfquery>
	
	<cfquery name="Detail" 
	datasource="AppsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     ContractActivity
		WHERE    ContractId   = '#URL.ContractId#'
		 AND     RecordStatus = '#url.recordstatus#'	 
		ORDER BY ActivityOrder
	</cfquery>
				
	<!--- Tasks --->

	<cfloop query="Detail">
	
	     <cfparam name="FORM.Activity_Score_#ActivityOrder#" default="">
		 <cfparam name="FORM.Activity_Remarks_#ActivityOrder#" default="">
		 <cfparam name="FORM.Activity_Remarks1_#ActivityOrder#" default="">
		 <cfparam name="FORM.Activity_Remarks2_#ActivityOrder#" default="">		 
								
		 <cfset Score     = Evaluate("FORM.Activity_Score_" & #ActivityOrder#)>
		 <cfset Remarks   = Evaluate("FORM.Activity_Remarks_" & #ActivityOrder#)>
		 <cfset Remarks1  = Evaluate("FORM.Activity_Remarks1_" & #ActivityOrder#)>
		 <cfset Remarks2  = Evaluate("FORM.Activity_Remarks2_" & #ActivityOrder#)>
		 
		 <cfif len(Remarks1) gt "500">
		 	<cfset remarks1 = left(remarks1,500)>		 
		 </cfif>
		 
		 <cfif len(Remarks2) gt "500">
		 	<cfset remarks2 = left(remarks2,500)>		 
		 </cfif>			 
			 
		 <cfparam name="FORM.Training_#ActivityOrder#" default="0">
		 <cfset Training    = Evaluate("FORM.Training_" & #ActivityOrder#)>
		 		 		     
		 <cfif Training eq "1">
			
			<cfset Reason      = Evaluate("FORM.TrainingReason_" & #ActivityOrder#)>
		   	<cfset Descrip     = Evaluate("FORM.TrainingDescription_" & #ActivityOrder#)>
		    <cfset Target      = Evaluate("FORM.TrainingTarget_" & #ActivityOrder#)>
		    <cfset Reference   = Evaluate("FORM.TrainingReference_" & #ActivityOrder#)>
		    <CF_DateConvert Value="#Target#">
			<cfset Target = dateValue>
		 		 
		 </cfif>
		 
		 <cfif Score neq "">
		 
			 <cfquery name="InsertScore" 
			     datasource="AppsEPAS" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 
			     INSERT INTO ContractEvaluationActivity
			         (EvaluationId,
					 ContractId,
					 ActivityId,
					 EvaluationScore,
					 EvaluationRemarks,
					 EvaluationRemarks1,
					 EvaluationRemarks2,
					 <cfif Training eq "1">
						 TrainingReason,  
				         TrainingDescription,
					     TrainingTarget,
					     TrainingReference,
					 </cfif>
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
			      VALUES (
			          '#URL.EvaluationId#',
					  '#ContractId#',
					  '#ActivityId#',
					  '#Score#',
					  '#Remarks#',
					  '#Remarks1#',
					  '#Remarks2#',
					   <cfif Training eq "1">
					 	 '#Reason#', 
			         	 '#Descrip#',
				     	 '#DateFormat(Target,CLIENT.dateSQL)#',
				     	 '#Reference#',
					  </cfif>
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#')
										
			  </cfquery>
			  
			  <cfloop index="itm" list="score,remarks,remarks1,remarks2">
			  
			  	   <cfset val = evaluate(itm)>
				   
				   <cfquery name="get" 
				     datasource="AppsEPAS" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					 SELECT  TOP 1 *
					 FROM    ContractEvaluationLog
					 WHERE   EvaluationId = '#url.evaluationid#'
					 AND     RecordId = '#ActivityId#'
					 AND     Topic = '#itm#'
					 ORDER BY AuditNo DESC   				 		 
				  </cfquery>
				  
				  <cfset prior = get.topicvalue>
				  
				  <cfif prior neq val>		
				  
				  	  <cftry>		   	
			  		  			  
					  <cfquery name="InsertScoreLog" 
					     datasource="AppsEPAS" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
						 INSERT INTO ContractEvaluationLog
						 (EvaluationId, RecordId, Topic, TopicValue, OfficerUserId,OfficerLastName, OfficerFirstName)
						 VALUES (
							 '#URL.EvaluationId#',
							 '#ActivityId#',
							 '#itm#',
							 '#val#',
							 '#SESSION.acc#',
					    	 '#SESSION.last#',		  
							 '#SESSION.first#'	)			
						 		 
					  </cfquery>	
					  
					  <cfcatch></cfcatch>
					  
					  </cftry>
				  
				  </cfif>		  
			  
			  </cfloop>
		  
		  </cfif>
				
	</cfloop>
	
	<cfquery name="Contract" 
	datasource="AppsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Contract
		WHERE    ContractId = '#URL.ContractId#'
	</cfquery>
	
	<!--- behavor --->	
	
	<cfquery name="Init" 
     datasource="AppsEPAS" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     DELETE FROM ContractEvaluationBehavior
		 WHERE EvaluationId = '#URL.EvaluationId#'
	</cfquery>
	
	<cfquery name="Detail" 
	datasource="AppsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     ContractBehavior
		WHERE    ContractId = '#URL.ContractId#'
	</cfquery>
				
	<!--- Behavior --->

	<cfloop query="Detail">
	
	     <cfparam name="FORM.Behavior_Score_#BehaviorCode#" default="">
		 <cfparam name="FORM.Behavior_Remarks1_#BehaviorCode#" default="">
		 <cfparam name="FORM.Behavior_Remarks2_#BehaviorCode#" default="">
	
		 <cfset Score     = Evaluate("FORM.Behavior_Score_" & #BehaviorCode#)>
		 <cfset Remarks1  = Evaluate("FORM.Behavior_Remarks1_" & #BehaviorCode#)>
		 <cfset Remarks2  = Evaluate("FORM.Behavior_Remarks2_" & #BehaviorCode#)>
		 
		 <cfparam name="FORM.Training_#BehaviorCode#" default="0">
		 <cfset Training    = Evaluate("FORM.Training_" & #BehaviorCode#)>
		 		 		     
		 <cfif Training eq "1">
			
			<cfset Reason      = Evaluate("FORM.TrainingReason_" & #BehaviorCode#)>
		   	<cfset Descrip     = Evaluate("FORM.TrainingDescription_" & #BehaviorCode#)>
		    <cfset Target      = Evaluate("FORM.TrainingTarget_" & #BehaviorCode#)>
		    <cfset Reference   = Evaluate("FORM.TrainingReference_" & #BehaviorCode#)>
		    <CF_DateConvert Value="#Target#">
			<cfset Target = dateValue>
		 		 
		 </cfif>
		 
		 <cfif Score neq "">
		 
			 <cfquery name="InsertScore" 
			     datasource="AppsEPAS" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO ContractEvaluationBehavior
			         (EvaluationId,
					 ContractId,
					 BehaviorCode,
					 EvaluationScore,
					 EvaluationRemarks1,
					 EvaluationRemarks2,
					 <cfif Training eq "1">
							 TrainingReason,  
					         TrainingDescription,
						     TrainingTarget,
						     TrainingReference,
					 </cfif>
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
			      VALUES (
			          '#URL.EvaluationId#',
					  '#ContractId#',
					  '#BehaviorCode#',
					  '#Score#',
					  '#Remarks1#',
					  '#Remarks2#',
					   <cfif Training eq "1">
						 	 '#Reason#', 
				         	 '#Descrip#',
					     	 '#DateFormat(Target,CLIENT.dateSQL)#',
					     	 '#Reference#',
					   </cfif>
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#')
			  </cfquery>
			  
			  <!--- logging --->
			  
			  <cfloop index="itm" list="score,remarks1,remarks2">
			  
			  	   <cfset val = evaluate(itm)>
				   
				   <cfquery name="get" 
				     datasource="AppsEPAS" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					 SELECT  TOP 1 *
					 FROM    ContractEvaluationLog
					 WHERE   EvaluationId = '#url.evaluationid#'
					 AND     RecordId = '#BehaviorCode#'
					 AND     Topic = '#itm#'
					 ORDER BY AuditNo DESC   				 		 
				  </cfquery>
				  
				  <cfset prior = get.topicvalue>
				  
				  <cfif prior neq val>				   	
			  		  			  
					  <cfquery name="InsertScoreLog" 
					     datasource="AppsEPAS" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
						 INSERT INTO ContractEvaluationLog
						 (EvaluationId, RecordId, Topic, TopicValue, OfficerUserId,OfficerLastName, OfficerFirstName)
						 VALUES (
							 '#URL.EvaluationId#',
							 '#BehaviorCode#',
							 '#itm#',
							 '#val#',
							 '#SESSION.acc#',
					    	 '#SESSION.last#',		  
							 '#SESSION.first#'	)			
						 		 
					  </cfquery>	
				  
				  </cfif>		  
			  
			  </cfloop>
		  
		  </cfif>
				
	</cfloop>
  
</cftransaction> 

<!--- process workflow --->

<cfset link = "ProgramREM/Portal/Workplan/PAS/PASView.cfm?contractid=#URL.ContractId#">
			 	 	 
<cfquery name="Employee" 
	datasource="appsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Person
		WHERE  PersonNo = '#Contract.PersonNo#'
</cfquery>	

<cfquery name="Evaluate" 
datasource="AppsEPAS" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   UPDATE ContractEvaluation
   SET   ActionStatus = '0p'
   WHERE EvaluationId  = '#URL.EvaluationId#'  
   AND   ActionStatus = '0'
</cfquery>

<!--- disabled

<cfif Evaluate.actionstatus gte "1">
	
	<cfquery name="Reset" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    UPDATE  OrganizationObject
		SET     Operational = 0
		WHERE   ObjectKeyValue4 = '#URL.EvaluationId#'	
	</cfquery>

</cfif>

--->

						 
<cf_ActionListing 
		EntityCode       = "EntPASEvaluation"
		EntityClass      = "#url.type#" 
		EntityGroup      = ""
		EntityStatus     = ""
		OrgUnit          = "#Contract.orgunit#"
		PersonNo         = "#Contract.PersonNo#" 
		ObjectReference  = "Approve PAS"
		ObjectReference2 = "#Employee.FirstName# #Employee.LastName#"
		ObjectKey4       = "#URL.EvaluationId#"
		ObjectURL        = "#link#"
		Show             = "No"
		Toolbar          = "No"
		CompleteFirst    = "yes"
		Framecolor       = "ECF5FF">			

<cfquery name="Evaluate" 
	datasource="AppsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     ContractEvaluation
		WHERE    EvaluationId = '#URL.EvaluationId#'
	</cfquery>
	
<cfquery name="Actor" 
	datasource="AppsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     ContractActor
		WHERE    ContractId   = '#URL.ContractId#'
		 AND     Role         = 'Evaluation'	 
		 AND     ActionStatus = '1'		
	</cfquery>	
	
<cfloop query = "Actor">	
	
	<cfset per = personno>	
	<cfinclude template="../PASView/CreateEvaluationAccessWorkflow.cfm">		
	
</cfloop>	

<script>
	ptoken.location('Evaluate.cfm?ContractId=#URL.ContractId#&EvaluationID=#url.EvaluationID#&type=#url.type#&Code=#URL.Code#&Section=#URL.Section#&recordstatus=#url.recordstatus#&mode=#url.mode#')	
</script>
		
</cfoutput>	   
	

