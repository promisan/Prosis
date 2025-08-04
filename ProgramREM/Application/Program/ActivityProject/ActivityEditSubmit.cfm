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

<!--- check output --->

<cfif Len(Form.ActivityDescription) gt 400>
	 <cf_alert message = "You entered a description that exceeded the allowed size of 400 characters."
	  return = "back">
	  <cfabort>
</cfif>

<cfparam name="form.activityweight" default="">

<!--- check if we have targets defined fro the activity to report on --->

<cfquery name="targetlist" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     ProgramTarget
	WHERE    ProgramCode = '#url.programcode#'
	AND      Period      = '#url.period#'												
	AND      RecordStatus != '9' 
	ORDER BY ListingOrder 
</cfquery>		

<cfset hasOutput = "0">
			
<cfloop query="targetlist">

	<cfparam name="form.Target_#left(targetId,8)#" default="">			  
	<cfset target = evaluate("form.Target_#left(targetId,8)#")>	
		
	<cfif isvalid("GUID",target)>	
		<cfset hasOutput = "1">		
	</cfif>	

</cfloop>

<cfif hasOutput eq "0">
	
	<cfquery name="Output" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   ProgramActivityOutput
		WHERE  ActivityId = '#URL.ActivityId#'		
		AND    TargetId is NULL
		AND    RecordStatus != '9'  
	</cfquery>		
	
	<cfif output.recordcount eq "0">
	
	  <cf_alert message = "PROBLEM\n\n\You must set one or more outputs for an activity.\n\nOperation not allowed." 
	            return = "back">
	  <cfabort>
	
	</cfif>

</cfif>

<cfoutput>

<!--- check if activity has been completed already --->

<cfquery name="Parameter" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_ParameterMission
		WHERE  Mission = '#URL.Mission#'
</cfquery>
	
<cfset completed = "1">
	
<cfquery name="Output" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT OutputId
	    FROM   ProgramActivityOutput
		WHERE  ActivityId = '#url.ActivityId#'
</cfquery>

<cfif Output.recordcount eq "0">

	<cfset completed = "0">
	
<cfelse>	
		
	<cfloop query = "Output">
		
		<cfquery name="Progress" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT   TOP 1 *
		    FROM     ProgramActivityProgress
			WHERE    Outputid = '#OutputId#'
			AND      RecordStatus != '9'
			ORDER BY Created DESC
		</cfquery>
					
		<cfif Progress.ProgressStatus neq Parameter.ProgressCompleted>
					
			<cfset completed = "0">
			
		</cfif>
			
	</cfloop>

</cfif>
	

<cfif ParameterExists(Form.Update) or ParameterExists(Form.UpdateNext)> 
			
		<!--- if activity is completed, leave it alone --->
		
				
				
		<cfif completed eq "0">		
		
				
			<!--- 1. update parent relationship --->
			
			<cfparam Name="Form.parent" default="">
			
				<!--- reset all dependencies of that action --->
			
				<cfquery name="RemoveDependency"
			     datasource="AppsProgram" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
					DELETE FROM ProgramActivityParent
					WHERE  ActivityId  = '#URL.ActivityID#'
					AND    ProgramCode = '#URL.ProgramCode#'
				</cfquery>
				
				<!--- record all entered dependencies of this action --->
			
				<cfif Form.parent neq "">
						
					<cfloop index="Itm" 
					        list="#Form.Parent#" 
					        delimiters="' ,">
							
						<cfparam name="Form.StartAfter#itm#" default="Completion">
						<cfparam name="Form.StartAfterDays#itm#" default="1">
						
						<cfset sa = evaluate("Form.StartAfter#itm#")>
						<cfset sd = evaluate("Form.StartAfterDays#itm#")>
						
						<cfif url.activityid neq itm>
						 									
						  <cfquery name="InsertClass" 
						     datasource="AppsProgram" 
						     username="#SESSION.login#" 
						     password="#SESSION.dbpw#">
						     INSERT INTO ProgramActivityParent
								 	   (ProgramCode,
										ActivityPeriod,
										ActivityId,
										ActivityParent,
										StartAfter,
										StartAfterDays,
										OfficerUserId,
										OfficerLastName, 
										OfficerFirstName)
							VALUES (
							        '#URL.ProgramCode#',
							     	'#URL.Period#',
									'#URL.ActivityID#',
									'#Itm#',
									'#sa#',
									'#sd#',	
									'#SESSION.acc#',
							    	'#SESSION.last#',		  
								  	'#SESSION.first#')
							</cfquery> 							
							
						</cfif>	
							
					</cfloop> 
				
			    </cfif>				
			
			<!--- ---------------------------- --->	
			<!--- 2. update child relationship --->
			<!--- ---------------------------- --->
			
			<cfparam Name="Form.children" default="">
			
				<cfquery name="RemoveChildren"
			     datasource="AppsProgram" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
					DELETE FROM ProgramActivityParent
					WHERE  ActivityParent = '#URL.ActivityID#'
					AND    ProgramCode    = '#URL.ProgramCode#'
				</cfquery>
			
				<cfif Form.children neq "">
				
				    <!--- we do not accidentally remove dependencies --->
						
					<cfloop index="Itm" 
					        list="#Form.Children#" 
					        delimiters="' ,">
					
					  <cfquery name="InsertChildren" 
					     datasource="AppsProgram" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
					     INSERT INTO ProgramActivityParent
						 	(ProgramCode,
							ActivityPeriod,
							ActivityId,
							ActivityParent,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName,
							Created)
						Values (
					        '#URL.ProgramCode#',
					     	'#URL.Period#',
							'#Itm#',
							'#URL.ActivityID#',
							'#SESSION.acc#',
					    	'#SESSION.last#',		  
						  	'#SESSION.first#',
							'#DateFormat(Now(),CLIENT.dateSQL)#')
						</cfquery> 
							
					</cfloop> 
				
				</cfif>	
								
				 <cfset dateValue = "">
				 <CF_DateConvert Value="#Form.ActivityDateStart#">
				 <cfset ActDateStart = dateValue>					 
								 
				 <cfif Form.Selectme eq "Duration">
				 
				     <cfset actdate = DateAdd("d", Form.ActivityDays, ActDateStart)>
				 
				 <cfelse>
				 
					 <cfset dateValue = "">
					 <CF_DateConvert Value="#Form.ActivityDate#">
					 <cfset ActDate = dateValue>
					 
					 <cfif ActDate lt ActDateStart>
					  
						  <cf_alert message = "You must define an enddate that lies after : #Form.ActivityDateStart#"
						  return = "back">
		
						  <cfabort>
					 
					 </cfif>
					 
					  <cfset Form.ActivityDays = DateDiff("d", ActDateStart,ActDate)>
				 					 					 				 
				 </cfif> 
				
				 <!--- revist dependencies based on new changes but only if indeed changed the start and duration 
				 tools/Program/ActivityProcess
				 ---> 		
				 			
												
				<cf_ActivityProcess 
					 ProgramCode  = "#Form.ProgramCode#"
					 ActivityId   = "#URL.ActivityId#"
					 DateStart    = "#dateformat(ActDateStart,CLIENT.DateFormatShow)#"
					 Duration     = "#Form.ActivityDays#">
				 
			<cfelse>
			
			    <!--- completed is 1 --->
							
				<cfquery name="Activity" 
			     datasource="AppsProgram" 
		    	 username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			    	 SELECT *
					 FROM   ProgramActivity		        
					 WHERE   ActivityID = '#URL.ActivityID#'
				</cfquery>
			
				<cf_ActivityProcess 
				 ProgramCode  = "#Form.ProgramCode#"
				 ActivityId   = "#URL.ActivityId#"
				 DateEnd      = "#dateformat(Activity.ActivityDate,CLIENT.DateFormatShow)#">
			 
			</cfif>		
			
			<cfparam name="Form.LocationCode" default="">	
									  	 
			<cfquery name="UpdateActivity" 
			     datasource="AppsProgram" 
		    	 username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			    	 UPDATE ProgramActivity
				     SET    ProgramCode              = '#Form.ProgramCode#',
					        ActivityPeriod           = '#Form.Period#',
						    ActivityDescription      = '#Form.ActivityDescription#',
							ActivityDescriptionShort = '#Form.ActivityDescriptionShort#',
							ActivityOutline          = '#Form.ActivityOutline#',
							<cfif url.ActivityClusterId neq "">
							ActivityClusterId        =  '#url.ActivityClusterId#',
							<cfelse>
							ActivityClusterId        =  NULL,
							</cfif>		
							<cfif Form.ActivityWeight neq "">			 
				  			ActivityWeight           = '#Form.ActivityWeight#',
							</cfif>
						 	Reference                = '#Form.Reference#',
						    OrgUnit                  = '#Form.OrgUnit#',
							RecordStatus             = '1',
							<cfif Form.LocationCode neq "">
						    LocationCode             = '#Form.LocationCode#',
							<cfelse>
							LocationCode             = NULL,
							</cfif>
						    OfficerUserId		     = '#SESSION.acc#',
							OfficerLastName	         = '#SESSION.last#',
							OfficerFirstName	     = '#SESSION.first#'
					  WHERE ActivityID               = '#URL.ActivityID#'
			</cfquery>
			
			<!--- defined location --->
			
			<cfquery name="clear" 
				     datasource="AppsProgram" 
			    	 username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				    	 DELETE FROM ProgramActivityLocation					    
						 WHERE ActivityID = '#URL.ActivityID#'
				</cfquery>
			
			<cfloop index="loc" list="#Form.LocationCode#">
			
				<cfquery name="AddLocation" 
				     datasource="AppsProgram" 
			    	 username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				    	 INSERT INTO ProgramActivityLocation
						 (ProgramCode, 
						  ActivityPeriod, 
						  ActivityId, 
						  LocationCode, 
						  OfficerUserId, 
						  OfficerLastName, 
						  OfficerFirstName)
						 VALUES (
						 '#Form.ProgramCode#',
						 '#Form.Period#',	
						 '#url.activityid#',						    
						 '#loc#',
						 '#SESSION.acc#',
						 '#SESSION.last#',
						 '#SESSION.first#' )
				</cfquery>
			
			</cfloop>
			
				
			<!--- defined outputs --->
				
			<cfquery name="UpdateOutputManual" 
			     datasource="AppsProgram" 
		    	 username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			    	 UPDATE ProgramActivityOutput
			         SET    ActivityOutputDate  = PA.ActivityDate
					 FROM   ProgramActivity PA, ProgramActivityOutput PO
					 WHERE  PA.ProgramCode   = '#Form.ProgramCode#'
					   AND  PA.ActivityId    = PO.ActivityId
					   AND  PA.ProgramCode   = PO.ProgramCode
					   AND  (
					         (PA.ActivityDate < PO.ActivityOutputDate)
					                OR
						     (PA.ActivityDateStart > PO.ActivityOutputDate)
						    )
					   AND	ActivityOutputDefault = 0
			</cfquery>
				
			<cfquery name="UpdateOutputDefault" 
			   datasource="AppsProgram" 
		       username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			    	 UPDATE ProgramActivityOutput
			         SET    ActivityOutputDate  = PA.ActivityDate
					 FROM   ProgramActivity PA, ProgramActivityOutput PO
					 WHERE  PA.ProgramCode           = '#Form.ProgramCode#'
					   AND  PA.ActivityId            = PO.ActivityId
					   AND  PA.ProgramCode           = PO.ProgramCode
					   AND  PA.ActivityDate !        = PO.ActivityOutputDate
					   AND  PO.ActivityOutputDefault = 1
			</cfquery>
							   
			<!--- delete all activitiesclasses for this activity --->
			
			<cfquery name="RemoveClasses"
		     datasource="AppsProgram" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
				DELETE FROM ProgramActivityParent
				WHERE ProgramCode  = '#Form.ProgramCode#'
				AND   ActivityID = ActivityParent
			</cfquery>
		
			<cfquery name="RemoveClasses"
		     datasource="AppsProgram" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
				DELETE FROM ProgramActivityClass
				WHERE ActivityID = '#URL.ActivityID#'
			</cfquery>
		
			<!--- If classes to add, loop through Activity class elelments and add to Activity Class table --->
		
			<cfparam Name="Form.ActivityClass" Default="">
		
			<cfif Form.ActivityClass neq "">
					
				<cfloop index="Item" 
				        list="#Form.ActivityClass#" 
				        delimiters="' ,">
				
					  <cfquery name="InsertClass" 
					     datasource="AppsProgram" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
					     INSERT INTO ProgramActivityClass
						 	(ProgramCode,
							ActivityPeriod,
							ActivityId,
							ActivityClass,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName,
							Created)
						Values (
					        '#Form.ProgramCode#',
					     	'#Form.Period#',
							'#URL.ActivityID#',
							'#Item#',
							'#SESSION.acc#',
					    	'#SESSION.last#',		  
						  	'#SESSION.first#',
							'#DateFormat(now(),CLIENT.dateSQL)#')
						</cfquery> 
						
				</cfloop> 
			
			</cfif>
			
			<!--- ----------------------------  --->	
			<!--- 5. update target associations --->
			<!--- ---------------------------- ---->
			
			<cfquery name="RemoveClass"
		     datasource="AppsProgram" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
				UPDATE ProgramActivityOutput
				SET    RecordStatus = '9'
				WHERE  ActivityID   = '#URL.ActivityID#'
				AND    TargetId     IS NOT NULL
				AND    RecordStatus != '9'  
				
			</cfquery>
			
			<cfparam name="Form.Targetid" default="">
			
			<cfquery name="targetlist" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   *
				FROM     ProgramTarget T
				WHERE    ProgramCode = '#form.programcode#'
				AND      Period      = '#form.period#'												
				AND      RecordStatus != '9'
				ORDER BY ListingOrder 
			</cfquery>		
			
			<cfloop query="targetlist">
			
			  <cfparam name="form.Target_#left(targetId,8)#" default="">
			  
			  <cfset target = evaluate("form.Target_#left(targetId,8)#")>
			  
			  <cfif target neq "">
							
				    <cfquery name="get" 
					  datasource="AppsProgram" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					    SELECT   * 
						FROM     ProgramActivityOutput
						WHERE    ProgramCode     = '#form.programcode#'
						AND      ActivityPeriod  = '#form.period#'	
						AND      ActivityId  = '#URL.ActivityID#'
					    AND      TargetId = '#target#'					
				    </cfquery> 			
				
					<cfif get.recordcount eq "1">
					
						 <cfquery name="set" 
						   datasource="AppsProgram" 
						    username="#SESSION.login#" 
						    password="#SESSION.dbpw#">
						     UPDATE ProgramActivityOutput
							 SET    RecordStatus = '1' 
							 WHERE  ProgramCode    = '#form.programcode#'
							 AND    ActivityPeriod = '#form.period#'	
							 AND    ActivityId     = '#URL.ActivityID#'
							 AND    TargetId       = '#target#'						
						</cfquery> 	
					
					<cfelse>
					
						 <cfquery name="InsertTarget" 
							     datasource="AppsProgram" 
							     username="#SESSION.login#" 
							     password="#SESSION.dbpw#">
							     INSERT INTO ProgramActivityOutput
								 	(ProgramCode,							
									ActivityPeriod,
									ActivityId,
									TargetId,							
									OfficerUserId,
									OfficerLastName,
									OfficerFirstName)
								VALUES (
							        '#Form.ProgramCode#',
							     	'#Form.Period#',
									'#URL.ActivityID#',
									'#target#',							
									'#SESSION.acc#',
							    	'#SESSION.last#',		  
								  	'#SESSION.first#')
							</cfquery> 
					
					</cfif>			
					
			  </cfif>	
							
	   </cfloop>			
										
</cfif>
	
<cfif ParameterExists(Form.UpdateNext)> 
	
	<script language = "JavaScript">	    
	    
		try { opener.document.getElementById('progressrefresh').click();
		 } catch(e) {  }		
		ColdFusion.navigate('ActivityEdit.cfm?programcode=#url.programcode#&period=#url.period#&programaccess=ALL&ajax=1&activityid=','contentbox1')		 
	</script>	

<cfelse>

	<script language = "JavaScript">	
		try { opener.document.getElementById('progressrefresh').click(); } catch(e) {  }
		window.close()			
	</script>	

</cfif>
	
</cfoutput>	   
	

