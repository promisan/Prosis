<!--- Prosis template framework --->
<cfsilent>
 <proUsr>administrator</proUsr>
 <proOwn>Ken Ward</proOwn>
 <proDes>Program Updating</proDes>
 <!--- specific comments for the current change, may be overwritten --->
 <proCom>Added field size check on ProgramName</proCom>
</cfsilent>
<!--- End Prosis template framework --->
<!--- 30/04/04 removed updating of record creation information --->

<cfparam name="URL.ProgramCode"               default="">
<cfparam name="URL.Action"                    default="">
<cfparam name="Form.ServiceClass"             default="">
<cfparam name="Form.ProgramNameShort"         default="">
<cfparam name="Form.setimplementer"           default="0">
<cfparam name="Form.ProgramStatus"            default="">
<cfparam name="Form.ListingOrder"             default="0">
<cfparam name="Form.isServiceParent"          default="1">
<cfparam name="Form.isProjectParent"          default="1">
<cfparam name="Form.status"              	  default="0">

<cfparam name="Form.PeriodDescription"        default="">
<cfparam name="Form.PeriodObjective"          default="">
<cfparam name="Form.PeriodGoal"               default="">
<cfparam name="Form.PeriodProblem"           default="">

<cfparam name="Form.ReferenceBudget"    	  default="">
<cfparam name="Form.ReferenceBudget1"         default="">
<cfparam name="Form.ReferenceBudget2"         default="">
<cfparam name="Form.ReferenceBudget3"         default="">
<cfparam name="Form.ReferenceBudget4"         default="">
<cfparam name="Form.ReferenceBudget5"         default="">
<cfparam name="Form.ReferenceBudget6"         default="">
<cfparam name="Form.Presentation"             default="1">
<cfparam name="Form.ProgramAllotment"         default="1">
<cfparam name="Form.ProgramAllocation"        default="0">
<cfparam name="Form.EnforceAllotmentRequest"  default="0">
<cfparam name="Form.ProgramWeight"            default="0">
<cfparam name="Form.ProgramCode"              default="#URL.ProgramCode#">
<cfparam name="Form.OrgUnit"                  default="">

<cfif url.action eq "delete">

	 <cfquery name="Prior" 
     datasource="AppsProgram" 
   	 username="#SESSION.login#" 
     password="#SESSION.dbpw#">
		 SELECT * 
		 FROM   ProgramPeriod
		 WHERE  ProgramCode = '#URL.ProgramCode#'	 
		 AND    Period      = '#Form.Period#'
	 </cfquery> 

	 <cfquery name="Delete" 
     datasource="AppsProgram" 
   	 username="#SESSION.login#" 
     password="#SESSION.dbpw#">
		 DELETE FROM Program 
		 WHERE  ProgramCode = '#URL.ProgramCode#'	 
	 </cfquery> 

	 <cfoutput>
     <script>
	     returnValue = '#prior.programid#'		 		
		 try {
	     window.close()					 						
		 opener.right.history.go() }
		 catch(e) { window.close()
		 			opener.history.go() }
	 </script>		
	</cfoutput>
	
	<cfabort>		
	
</cfif>
	

<cfif Len(Form.ProgramName) eq 0>

 <cf_alert message = "You didn't enter a program name." return = "back">

	<cfabort>

</cfif>

<cfif Len(Form.ProgramName) gt 400>

	 <cf_alert message = "Your entered a Program/Component name that exceeded the allowed size of 400 characters."
	  return = "back">
	  <cfabort>
	  
</cfif>


<cfif Len(Form.PeriodDescription) gt 30000>

	 <cf_alert message = "You entered a description that exceeded the allowed size of 30000 characters."
	  return = "back">
	  <cfabort>

</cfif>

<cfif Len(Form.PeriodObjective) gt 30000>

 <cf_alert message = "You entered an objective that exceeded the allowed size of 30000 characters."
  return = "back">
  <cfabort>

</cfif>

<cfif Len(Form.Memo) gt 600>

 <cf_alert message = "You entered a memo that exceeded the allowed size of 600 characters."
  return = "back">
  <cfabort>

</cfif>

<script>	 
	Prosis.busy("yes")	
</script>

<cfparam name="Form.OrgUnitParent" default="">

<cfif Form.ProgramScope eq "Global">
		
     <cfquery name="Mandate" 
     datasource="AppsOrganization" 
   	 username="#SESSION.login#" 
     password="#SESSION.dbpw#">
		 SELECT Mission,MandateNo
		 FROM   Organization
		 WHERE  OrgUnit = '#Form.OrgUnitParent#'
	 </cfquery> 

	<cfquery name="TreeUnit" 
     datasource="AppsOrganization" 
   	 username="#SESSION.login#" 
     password="#SESSION.dbpw#">
		 SELECT OrgUnit
		 FROM   Organization
		 WHERE  Mission   = '#Mandate.Mission#'
		 AND    MandateNo = '#Mandate.MandateNo#'
		 AND    TreeUnit = 1
     </cfquery>
	 
	 <cfif TreeUnit.OrgUnit neq "">
	 	 <cfset globalunit = TreeUnit.OrgUnit>
	 <cfelse>
	     <cfset globalunit = Form.OrgUnitParent>
	 </cfif>	 

</cfif>	 


<cfif URL.ProgramCode neq "">			<!--- Updating existing Program --->

	<cfset ProgramCode = Form.ProgramCode>
      
	<!--- Remove quotes from Program Name (can affect tree view)--->
		<cfset ProgName=Replace(Form.ProgramName,'"','','ALL')>
		<cfset ProgName=Replace(ProgName,"'","",'ALL')>
		
		<cfquery name="getProgram" 
	   	 datasource="AppsProgram" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			 SELECT * 
			 FROM   Program 
			 WHERE  ProgramCode = '#Form.ProgramCode#'
		</cfquery>		
		
		<cfparam name="Form.ProgramDate" default="#dateformat(now(),client.dateformatshow)#">
		<CF_DateConvert Value="#Form.ProgramDate#">
		<cfset dte = dateValue>
						
		<cfquery name="UpdateProgram" 
	   	 datasource="AppsProgram" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 
	     UPDATE Program
 	        SET	 ProgramName             = '#ProgName#',
			     ProgramNameShort        = '#form.ProgramNameShort#',  
							
				 <cfif Form.ServiceClass neq "">
				 ServiceClass            = '#Form.ServiceClass#',				
				 </cfif>		
				 ProgramDate             = #dte#,	 				 
				 ListingOrder            = '#Form.ListingOrder#',				
				 ProgramAllotment        = '#Form.ProgramAllotment#',
				 ProgramAllocation       = '#Form.ProgramAllocation#', 
				 EnforceAllotmentRequest = '#Form.EnforceAllotmentRequest#',				
				 isServiceParent         = '#form.isServiceParent#',
				 isProjectParent         = '#form.isProjectParent#',
				 ProgramWeight           = '#Form.ProgramWeight#',		
				 ProgramMemo             = '#Form.Memo#',
				 ProgramScope            = '#Form.ProgramScope#'
				 				 
		  WHERE  ProgramCode             = '#Form.ProgramCode#'
				  		  
		</cfquery>		
								
		<cfquery name="get" 
	   	 datasource="AppsProgram" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		     SELECT  * 
			 FROM    Program			 
			 WHERE   ProgramCode             = '#Form.ProgramCode#'
	   </cfquery>	
	   
	     <!--- adjust hierarchy of program + children as well as language entries --->
			 
	   <cfinvoke component="Service.Access"  <!--- get access levels based on top Program--->
			Method         = "budget"
			Mission        = "#getProgram.Mission#"
			Period         = "#Form.Period#"				
			Role           = "'BudgetManager'"
			ReturnVariable = "BudgetAccess"> 
				
	   
	   <cftransaction>
		
	   <cfif get.ProgramClass eq "Project">	
			
		   <cfset ProgramCode = form.ProgramCode>
		   <cfset Mission     = get.Mission>
	       <cfinclude template = "ProjectEntryStatusSubmit.cfm">		   
		   <cfinclude template = "ProjectEntryEventSubmit.cfm">
		   
		   <cfif url.header eq "1">
			   <cfinclude template = "ProjectEntryFinancialSubmit.cfm">
			   <cfinclude template = "../Category/CategoryEntrySubmit.cfm">	
		   </cfif>
		   
		    <cfquery name="clear" 
		   	 datasource="AppsProgram" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			     DELETE FROM  ProgramPeriodOrgUnit 
				 WHERE   ProgramCode  = '#Form.ProgramCode#'
				 AND     Period  = '#Form.Period#'
		    </cfquery>	
			
			<cfquery name="clear" 
		   	 datasource="AppsProgram" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			     DELETE FROM  ProgramPeriodSource 
				 WHERE   ProgramCode  = '#Form.ProgramCode#'
				 AND     Period  = '#Form.Period#'
		    </cfquery>	
			
			<cfloop index="itm" from="1" to="14">
			
				<cfparam name="Form.Source#itm#" default="">
				<cfset val = evaluate("Form.Source#itm#")>
				
				<cfif val neq "">
							
					<cfquery name="insert" 
				   	 datasource="AppsProgram" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					     INSERT INTO ProgramPeriodSource 
						 (ProgramCode,Period,Source,SourceNo,OfficerUserId,OfficerLastName,OfficerFirstName)
						 VALUES
						 ('#Form.ProgramCode#','#Form.Period#','Manual','#val#','#session.acc#','#session.last#','#session.first#')				 
				    </cfquery>	
					
				</cfif>
						
			</cfloop>
		   			
	   </cfif>				
		
		<cfquery name="Check" 
	   	 datasource="AppsProgram" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		     SELECT * 
			 FROM   ProgramPeriod
	 	     WHERE  ProgramCode       = '#FORM.ProgramCode#'
			 AND    Period            = '#FORM.Period#' 
		</cfquery>		
		
		<!--- check if program reference is used within the same mission and period --->
	
		<cfif form.reference neq "">
			
			 <cfquery name="Check" 
			    datasource="AppsProgram" 
			  	 username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				 SELECT *
				 FROM   ProgramPeriod
				 WHERE  ProgramCode IN (SELECT ProgramCode 
				                        FROM   Program 
										WHERE  Mission = '#getProgram.Mission#')
				 AND    Reference    = '#trim(Form.Reference)#'
				 AND    Period       = '#Form.Period#'
				 AND    ProgramCode != '#Form.ProgramCode#'
			 </cfquery>
		 
			 <cfif check.recordcount gte "1">
			 
			   <cf_alert message = "Reference code : #Form.Reference# already exists for this entity and period. Operation not allowed!"
			       return = "back">
				   								   
					<script>	 
						parent.Prosis.busy("no")	
					</script>

		    	   <cfabort>				
		 
			 </cfif>
		 
	   </cfif>	
	  					
	   <cfquery name="UpdatePeriod" 
	   	 datasource="AppsProgram" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     UPDATE ProgramPeriod
 	        SET ProgramManager    = '#FORM.ProgramManager#',
			    OrgUnitImplement  = '#FORM.OrgUnit1#',
				<cfif Form.OrgUnit0 neq "">
				OrgUnitRequest    = '#Form.OrgUnit0#',
				</cfif>
				<cfswitch expression="#Form.ProgramScope#">
					<cfcase value="Global">
						OrgUnit = '#GlobalUnit#',
					</cfcase>
					<cfcase value="Parent">
					    OrgUnit = '#Form.OrgUnitParent#',
					</cfcase>
					<cfcase value="Unit">
					    <cfif form.setimplementer eq "1">
						OrgUnit = '#Form.OrgUnit1#',
						<cfelse>
						OrgUnit = '#Form.OrgUnit#', 
						</cfif>
					</cfcase>
				</cfswitch>
				
				PeriodParentCode     = '#Form.ParentCode#',
				
				PeriodDescription    = '#Form.PeriodDescription#',		
				PeriodGoal           = '#Form.PeriodGoal#',	
				PeriodObjective      = '#Form.PeriodObjective#',
				PeriodProblem        = '#form.PeriodProblem#',	
				
				ReferenceBudget      = '#Form.ReferenceBudget#',
				Reference            = '#trim(Form.Reference)#',
				Status               = '#Form.Status#',
				<cfif BudgetAccess eq "EDIT" or BudgetAccess eq "ALL">
					ReferenceBudget1     = '#Form.ReferenceBudget1#',
					ReferenceBudget2     = '#Form.ReferenceBudget2#',
					ReferenceBudget3     = '#Form.ReferenceBudget3#',
					ReferenceBudget4     = '#Form.ReferenceBudget4#',
					ReferenceBudget5     = '#Form.ReferenceBudget5#',
					ReferenceBudget6     = '#Form.ReferenceBudget6#',
				</cfif>
				Presentation         = '#form.Presentation#',				
			    RecordStatus         = 1,
				RecordStatusDate     = getDate(),
				RecordStatusOfficer  = '#SESSION.acc#'
				<!---,
			    OfficerLastName      = '#SESSION.last#',
			    OfficerFirstName     = '#SESSION.first#',
			    Created              = '#DateFormat(Now(),CLIENT.dateSQL)#'
				--->
		  WHERE ProgramCode          = '#FORM.ProgramCode#'
		  	AND Period               = '#FORM.Period#' 
			
		</cfquery>		
		
		<!--- attention we can save the description, objective and goal language sensitive, but we dont --->
						
		<cfif ProgramScope eq "Unit">
			<cf_programHierarchy programcode = "#Form.ProgramCode#" period="#form.period#">
		</cfif>		
				
		<cfloop index="itm" from="1" to="4">
		
			<cfquery name="delete"
				datasource="AppsProgram"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">				
				    DELETE FROM ProgramPeriodOrgUnit
					WHERE ProgramCode          = '#FORM.ProgramCode#'
			  	    AND   Period               = '#FORM.Period#' 
					AND   ListingOrder         = '#itm#'
			</cfquery>	
		
			<cfparam name="form.orgunitpartner#itm#" default="">
			<cfset org = evaluate("form.orgunitpartner#itm#")>
			
			<cfif org neq "">
					
				<cfquery name="Insert"
				datasource="AppsProgram"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">				
				    INSERT INTO ProgramPeriodOrgUnit
						(ProgramCode,Period,OrgUnit,ListingOrder,OfficerUserId,OfficerLastName,OfficerfirstName)
					VALUES
						('#FORM.ProgramCode#',
						 '#Form.Period#',
						 '#org#',
						 '#itm#',
						 '#SESSION.acc#',
						 '#SESSION.last#',
						 '#SESSION.first#')				
				</cfquery>	
			
			</cfif>
	
	    </cfloop> 
			
		<!--- update orgunit of children as well --->
		
		<cfif Form.ProgramScope eq "Unit" AND Check.OrgUnit neq Form.OrgUnit>
				
			<cfquery name="Period" 
		   	 datasource="AppsProgram" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			     SELECT * 
				 FROM   ProgramPeriod
				 WHERE  ProgramCode  = '#Form.ProgramCode#'
				 AND    Period       = '#Form.Period#'
			</cfquery>
			
			<cfquery name="UpdateActivities" 
		   	 datasource="AppsProgram" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			     UPDATE ProgramActivity
		 	     SET    OrgUnit = '#Form.OrgUnitParent#'
			     WHERE  ProgramCode     = '#FORM.ProgramCode#'
			  	 AND    ActivityPeriod  = '#FORM.Period#'
				 AND    OrgUnit         = '#Check.OrgUnit#' 
			</cfquery>		
			
			<cfquery name="Mission" 
		   	 datasource="AppsProgram" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			     SELECT *
				 FROM   Organization.dbo.Organization
				 WHERE  OrgUnit = '#Check.OrgUnit#' 
	 	    </cfquery>		
			
			<!--- define children --->
						
			<cfquery name="UpdateUnitChildren" 
		   	 datasource="AppsProgram" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			     UPDATE ProgramPeriod
		 	     SET    OrgUnit = '#Form.OrgUnit#'
				 WHERE  ProgramCode IN (SELECT ProgramCode 
				                        FROM   Program 
										WHERE  Mission = '#mission.mission#')
				  AND   Period          = '#FORM.Period#'
				  AND   PeriodHierarchy LIKE '#Period.PeriodHierarchy#.%'  
				  <!--- remove 17/8/2015 
				  AND   OrgUnit IN (SELECT OrgUnit FROM Organization.dbo.Organization WHERE Mission = '#Mission.Mission#')
				  --->
			</cfquery>				
			
			<cfquery name="UpdateActivitiesChildren" 
		   	 datasource="AppsProgram" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     UPDATE ProgramActivity
	 	      SET   OrgUnit = '#Form.OrgUnit#'
		     WHERE  ProgramCode IN (SELECT ProgramCode 
			                        FROM   ProgramPeriod
									WHERE  Period = '#Form.Period#'
									AND    PeriodHierarchy LIKE '#Period.PeriodHierarchy#.%')
			   AND  ActivityPeriod   = '#FORM.Period#'
			   AND  OrgUnit          = '#Check.OrgUnit#' 
			   AND  OrgUnit IN (SELECT OrgUnit 
			                    FROM   Organization.dbo.Organization 
								WHERE  Mission = '#Mission.Mission#')
			</cfquery>		
			
		</cfif>
	  	    
		<!--- If updating forms program code, make sure children update their parent code --->
							  
		<cfif URL.ProgramCode neq Form.ProgramCode>
		
		    <cfquery name="UpdateProgram" 
		   	 datasource="AppsProgram" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     UPDATE Program
	 	        SET ParentCode = '#Form.ProgramCode#'
			  WHERE ParentCode = '#URL.ProgramCode#'
			 </cfquery> 
												 
		</cfif>
		
		</cftransaction>			 
				
		<!--- makes language entry --->

		<cf_LanguageInput
				TableCode      = "Program" 
				Mode           = "Save"
				Lines          = "1"
				Name1          = "ProgramName"
				Key1Value      = "#Form.ProgramCode#">
				
		<!--- makes language entry --->

		<cf_LanguageInput
				TableCode      = "ProgramPeriod" 
				Mode           = "Save"
				Lines          = "3"				
				Name1          = "PeriodDescription"
				Name2          = "PeriodGoal"
				Name3          = "PeriodObjective"
				Key1Value      = "#Form.ProgramCode#"
				Key2Value      = "#Form.Period#">		
										
<CFOUTPUT>

<cfquery name="Prior" 
     datasource="AppsProgram" 
   	 username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 SELECT * 
	 FROM   ProgramPeriod
	 WHERE  ProgramCode = '#URL.ProgramCode#'	 
	 AND    Period      = '#Form.Period#'
 </cfquery> 
 
 <cfparam name="url.header" default="1">
    	
 <cfif url.header eq "1"> 
 
 	<!--- loaded from the main screen as a dialog --->

	 <script>   
	 	 	        		    			
			<cfif prior.programid neq ''>	
			     // call refresh on the parent listing page 
				 try {	    		     				 
				 opener.refreshdata('ref','#prior.programid#')				 
				 opener.refreshdata('nme','#prior.programid#')
				 } catch(e) {				 
				   opener.history.go()	
				 }
			<cfelse>
			      opener.history.go()				 
		    </cfif>			
			window.close()
	  </script>	
	  
 <cfelse>
  	
	<cfquery name="Parameter" 
	 datasource="AppsProgram" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 	SELECT *
		FROM   Ref_ParameterMission
		WHERE  Mission = '#getProgram.Mission#'
	</cfquery>		
	 
	<cfswitch expression="#getProgram.ProgramClass#">
			
		<cfcase value="Program">
		
			<script LANGUAGE = "JavaScript"> 
				window.location = "../ProgramViewTop.cfm?ProgramCode=#form.ProgramCode#&mission=#getProgram.Mission#&&Period=#form.Period#"		
			</script>
			  
		</cfcase>
		
		<cfcase value="Component">
		
		    <cfif Parameter.DefaultOpenProgram eq "Activity">
			
			  	  <script LANGUAGE = "JavaScript"> 
					  window.location = "../Activity/Progress/ActivityView.cfm?ProgramCode=#form.ProgramCode#&Mission=#getProgram.Mission#&Period=#form.Period#"
				  </script>
			  						  
			<cfelse>
											   
				  <cfif Parameter.EnableIndicator eq "1">
					  <script LANGUAGE = "JavaScript"> 
							window.location = "../Indicator/TargetView.cfm?ProgramCode=#form.ProgramCode#&Mission=#getProgram.Mission#&Period=#form.Period#"
					  </script>
				  <cfelse>
					  <script LANGUAGE = "JavaScript"> 
						    window.location = "../ActivityProgram/ActivityView.cfm?ProgramCode=#form.ProgramCode#&Mission=#getProgram.Mission#&Period=#form.Period#"
				   	  </script>
				  </cfif>
								
			</cfif>
			
		</cfcase>
					
		<cfcase value="Project">
										
				<cfif Parameter.EnableGANTT eq "1">		
					<script LANGUAGE = "JavaScript"> 					   
						window.location = "../../Activity/Progress/ActivityView.cfm?ProgramCode=#form.ProgramCode#&Mission=#getProgram.Mission#&Period=#form.Period#&output=1"
					</script>
				<cfelse>	
				    <script LANGUAGE = "JavaScript"> 		
				  		window.location = "../Events/EventsView.cfm?ProgramCode=Mission=#form.ProgramCode#&Mission=#getProgram.Mission#&Period=#form.Period#"
					</script>
				</cfif>			
						
		</cfcase>			
	
	</cfswitch>
		 
 </cfif>	  

</CFOUTPUT>		 	
 		
</cfif>	

