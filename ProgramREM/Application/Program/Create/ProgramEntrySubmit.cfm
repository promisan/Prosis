<!--- Prosis template framework --->
<cfsilent>
<proUsr>administrator</proUsr>
<proOwn>Hanno van Pelt</proOwn>
<proDes>Program Creation Sumbit</proDes>
<!--- specific comments for the current change, may be overwritten --->
<proCom>Added field size check on ProgramName</proCom>
</cfsilent>
<!--- End Prosis template framework --->

<cfparam name="Form.ProgramDescription"      default="">
<cfparam name="Form.ProgramNameShort"        default="">
<cfparam name="Form.ServiceClass"            default="">
<cfparam name="Form.isServiceParent"         default="1">
<cfparam name="Form.isProjectParent"         default="1">
<cfparam name="Form.status"                  default="0">
<cfparam name="Form.PeriodProblem"           default="">
<cfparam name="Form.PeriodGoal"              default="">
<cfparam name="Form.ReferenceBudget"         default="">
<cfparam name="Form.ReferenceBudget1"        default="">
<cfparam name="Form.ReferenceBudget2"        default="">
<cfparam name="Form.ReferenceBudget3"        default="">
<cfparam name="Form.ReferenceBudget4"        default="">
<cfparam name="Form.ReferenceBudget5"        default="">
<cfparam name="Form.ReferenceBudget6"        default="">
<cfparam name="Form.ProgramStatus"           default="">
<cfparam name="Form.Presentation"            default="1">
<cfparam name="Form.StatusUrgency"           default="">
<cfparam name="Form.StatusNecessity"         default="">
<cfparam name="Form.StatusImportancy"        default="">
<cfparam name="Form.ProgramAllotment"        default="1">
<cfparam name="Form.ProgramAllocation"       default="0">
<cfparam name="Form.ProgramWeight"           default="0">
<cfparam name="Form.OrgUnit"                 default="">
<cfparam name="Form.OrgUnit0"                default="">
<cfparam name="Form.EnforceAllotmentRequest" default="0">
<cfparam name="Form.PeriodDescription"      default="">
<cfparam name="Form.PeriodObjective"      default="">

<cfif Form.ProgramScope eq "Parent">
	 		 
	 <cfif Form.OrgUnitParent eq "">
	  
		  <cf_alert message = "You must must define a managing unit."
		  return = "back">
		  <script>
			Prosis.busy('no')
			</script>
		  <cfabort>
	  
	 </cfif>
 
</cfif>

<cfif Len(Form.ProgramName) gt 400>
   <cf_alert message = "Your entered a Program/Component name that exceeded the allowed size of 400 chars." return = "back">	
    <cfabort>
</cfif>

<cfif Len(Form.Memo) gt 600>
	 <cf_alert message = "Your entered a memo that exceeded the allowed size of 600 characters." return = "back">	 
	 <cfabort>
</cfif>

<!--- ProgramPeriod level --->

<cfif Len(Form.PeriodGoal) gt 30000>
    <cf_alert message = "You entered a goal that exceeded the allowed size of 30000 chars." return = "back">  
    <cfabort>
</cfif>

<cfif Len(Form.PeriodProblem) gt 2000>
    <cf_alert message = "Your entered a problem that exceeded the allowed size of 2000 characters." return = "back">	
    <cfabort>
</cfif>

<cfif Len(Form.PeriodDescription) gt 30000>
    <cf_alert message = "Your entered a description that exceeded the allowed size of 30000 characters." return = "back">	
    <cfabort>
</cfif>

<cfif Len(Form.PeriodObjective) gt 30000>
	 <cf_alert message = "Your entered an objective that exceeded the allowed size of 30000 characters." return = "back">	 
	 <cfabort>
</cfif>

<!--- verify if programrecord exist --->

<cftry>
	
	<cfquery name="ProgramPeriod" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT ProgramCode, ProgramId, RecordStatus
		FROM   ProgramPeriod PP
		WHERE  PP.ProgramCode = '#Form.ProgramCode#'
		  AND  PP.Period      = '#Form.Period#'
	</cfquery>

	<cfcatch>
		
		<cfparam name="ProgramPeriod.RecordCount" default="0">
	
	</cfcatch>

</cftry>

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

<cfif ProgramPeriod.recordCount neq 0>	<!--- Program exists --->

	<cfif ProgramPeriod.RecordStatus neq "9">        <!--- not deleted so alert to error --->
		  
	      <cf_alert message = "A program/component #Form.ProgramCode# : #Form.ProgramName# was already registered ! Operation not allowed." return = "back">
		  
	      <cfabort>
	
	<cfelse>
	    
		<!--- program exists but deleted, undelete and update --->
	
		<cftransaction action="BEGIN">
	
		<cfset ProgName=Replace(Form.ProgramName,'"','','ALL')>
		<cfset ProgName=Replace(ProgName,"'","",'ALL')>
		
		<cfparam name="Form.ProgramDate" default="#dateformat(now(),client.dateformatshow)#">
		<CF_DateConvert Value="#Form.ProgramDate#">
		<cfset dte = dateValue>
		
		 <cfquery name="get" 
	   	 datasource="AppsProgram" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		     SELECT  * 
			 FROM    Program			 
			 WHERE   ProgramCode             = '#Form.ProgramCode#'
	    </cfquery>	
		
	    <cfquery name="UpdateProgram" 
	   	 datasource="AppsProgram" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		      UPDATE Program
			  SET	 Mission                 = '#Form.Mission#',
				     ListingOrder            = '#Form.ListingOrder#',
					 ProgramDate             = #dte#,
					 ProgramNameShort        = '#form.ProgramNameShort#',  				     
					 ProgramScope            = '#Form.ProgramScope#', 
					 ProgramMemo             = '#Form.Memo#',
					 ProgramName             = '#ProgName#',
					 <cfif Form.ServiceClass neq "">
					 ServiceClass            = '#Form.ServiceClass#',
					 <cfelse>
					 ServiceClass            = NULL, 
					 </cfif>
										 
					 ProgramAllotment        = '#Form.ProgramAllotment#',
					 ProgramAllocation       = '#Form.ProgramAllocation#',
					 EnforceAllotmentRequest = '#Form.EnforceAllotmentRequest#',
					 ProgramWeight           = '#Form.ProgramWeight#',					
					 isServiceParent         = '#form.isServiceParent#',
					 isProjectParent         = '#form.isProjectParent#',
				     OfficerUserId           = '#SESSION.acc#',
				     OfficerLastName         = '#SESSION.last#',
				     OfficerFirstName        = '#SESSION.first#',
				     Created                 = '#DateFormat(Now(),CLIENT.dateSQL)#'
			 WHERE   ProgramCode             = '#Form.ProgramCode#'
	    </cfquery>
		
	   <cfif get.ProgramClass eq "Project">
	   
	       <cfset ProgramCode = Form.ProgramCode>
		   <cfset Mission     = get.Mission>	
		   <cfset url.Period  = Form.Period>			  
		  		   
	       <cfinclude template="ProjectEntryStatusSubmit.cfm">
		   <cfinclude template="ProjectEntryEventSubmit.cfm">
		   <cfinclude template="ProjectEntryFinancialSubmit.cfm">
		   <cfinclude template="../Category/CategoryEntrySubmit.cfm">
						
		</cfif>
		
		<!--- check if program reference is used within the same mission and period --->
		
		<cfif form.reference neq "">
			
			 <cfquery name="Check" 
			    datasource="AppsProgram" 
			  	 username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				 SELECT *
				 FROM   ProgramPeriod
				 WHERE  ProgramCode IN (SELECT ProgramCode FROM Program WHERE Mission = '#FORM.Mission#')
				 AND    Reference = '#trim(Form.Reference)#'
				 AND    Period = '#Form.Period#'
				 AND    ProgramCode != '#Form.ProgramCode#'
			 </cfquery>
		 
		 <cfif check.recordcount gte "1">
		 
		   <cf_alert message = "Reference code : #Form.Reference# already exists for this entity and period. Operation not allowed!" return = "back">
			   			 
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
						OrgUnit = '#globalunit#',
					</cfcase>
					<cfcase value="Parent">
					    OrgUnit = '#Form.OrgUnitParent#',   
					</cfcase>
					<cfcase value="Unit">
						OrgUnit = '#Form.OrgUnit#',
					</cfcase>
				</cfswitch>
				
				PeriodDescription = '#Form.PeriodDescription#',		
				PeriodGoal        = '#Form.PeriodGoal#',	
				PeriodObjective   = '#Form.PeriodObjective#',	
				PeriodProblem     = '#Form.PeriodProblem#',
				
				ReferenceBudget   = '#Form.ReferenceBudget#',
				Reference         = '#trim(Form.Reference)#',
			    RecordStatus      = 1,
				Presentation      = '#Form.Presentation#', 
				Status            = '#Form.Status#',
			    OfficerUserId     = '#SESSION.acc#',
			    OfficerLastName   = '#SESSION.last#', 
			    OfficerFirstName  = '#SESSION.first#',
			    Created           = '#DateFormat(Now(),CLIENT.dateSQL)#'
		  WHERE ProgramCode       = '#FORM.ProgramCode#'
		  	AND Period            = '#FORM.Period#' 
		</cfquery>		
		
		<cfset link = ProgramPeriod.ProgramId>
	
		</cftransaction>
		
	</cfif>

<cfelse>		

	<!--- NEW program, program component or project --->

  	<cfquery name="AssignNo" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     UPDATE Parameter SET ProgramNo = ProgramNo+1 
     </cfquery>

<cfquery name="LastNo" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT *
     FROM Parameter
</cfquery>
 
<cfquery name="Parameter" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT *
     FROM Ref_ParameterMission
	 WHERE Mission = '#Form.Mission#'
</cfquery>
 
<cfif Form.ProgramClass eq "Program">
   	 <cfset cde = Parameter.ProgramPrefix&LastNo.ProgramNo>
<cfelse>
   	 <cfset cde = Parameter.ComponentPrefix&LastNo.ProgramNo>
</cfif>

<!--- Remove quotes from Program Name (can affect tree view)--->

    <cfparam name="Form.ProgramCode"         default="#cde#">
	<cfset ProgName=Replace(Form.ProgramName,'"','','ALL')>
	<cfset ProgName=Replace(ProgName,"'","",'ALL')>
	
	<cfparam name="Form.ProgramDate" default="#dateformat(now(),client.dateformatshow)#">
	<CF_DateConvert Value="#Form.ProgramDate#">
	<cfset dte = dateValue>
			
    <cfquery name="InsertProgram" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     INSERT INTO Program
		        (Mission,
				 ProgramCode,
				 ProgramDate,			 
				 ProgramName,			
				 ProgramClass,
				 ProgramWeight,		
				 ProgramAllotment,		
				 ProgramMemo,
				 ProgramScope,			 
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
	   	 VALUES ( '#Form.Mission#',
			      '#cde#',
				  #dte#,			  
				  '#ProgName#',			  
				  '#Form.ProgramClass#',
				  '#Form.ProgramWeight#',	
				  '#Form.ProgramAllotment#',		 
				  '#Form.Memo#',
				  '#Form.ProgramScope#',			  
				  '#SESSION.acc#',
		  		  '#SESSION.last#',		  
			  	  '#SESSION.first#')
    </cfquery>
	 		
	<cfif Form.ProgramClass eq "Project">
	
		  <!--- grant access to the owner of the project --->
		
		  <cfloop index="role" list="ProgramOfficer,BudgetOfficer,ProgressOfficer">
		
				<cfquery name="Employee" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO ProgramAccessAuthorization
					    (ProgramCode,UserAccount,Role,OfficerUserId,OfficerLastName,OfficerFirstName)
					VALUES(	
					'#cde#',
					'#SESSION.acc#',
					'#Role#',
					'#SESSION.acc#',
					'#SESSION.last#',
					'#SESSION.first#') 
				</cfquery>
		
		   </cfloop>		
		  
		   <cfset ProgramCode     = cde>
		   <cfset Mission         = form.Mission>
		   <cfset url.programcode = programcode>		   
		   <cfset url.Period      = Form.Period>	
			
	       <cfinclude template="ProjectEntryStatusSubmit.cfm">
		   <cfinclude template="ProjectEntryEventSubmit.cfm">
		   <cfinclude template="../Category/CategoryEntrySubmit.cfm">			
			
	</cfif>	
	
	<!--- -------------------------------------------------- --->
    <!--- assign a unit and reference if this is left blank  --->
	<!--- -------------------------------------------------- --->
   
    <cfswitch expression="#Form.ProgramScope#">
		<cfcase value="Global">
		    <cfset orgunit = globalunit>
		</cfcase>
		<cfcase value="Parent">
		   <cfset orgunit = Form.OrgUnitParent>
		</cfcase>
		<cfcase value="Unit">
			<cfset orgunit = Form.OrgUnit> 
		</cfcase>
   </cfswitch>
   		
   <!--- -------------------------------------------------- --->
   <!--- assign a reference-------------------------------- --->
   <!--- -------------------------------------------------- --->
   
   <cfif Form.reference neq "">		
   
	   	<cfset ref = Form.reference>	
		
		<!--- check if program reference is used within the same mission and period --->
	
		<cfif form.reference neq "">
			
			 <cfquery name="Check" 
			    datasource="AppsProgram" 
			  	 username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				 SELECT *
				 FROM   ProgramPeriod
				 WHERE  ProgramCode IN (SELECT ProgramCode FROM Program WHERE Mission = '#FORM.Mission#')
				 AND    Reference = '#Form.Reference#'
				 AND    Period = '#Form.Period#'
				 AND    ProgramCode != '#Form.ProgramCode#'
			 </cfquery>
		 
		 <cfif check.recordcount gte "1">
		 
		   <cf_alert message = "Reference code : #Form.Reference# already exists for this entity and period. Operation not allowed!" return = "back">
			  
	    	   <cfabort>
	 
		 </cfif>
		 
	   </cfif>	 
   
   <cfelse>
   
   		<cfquery name="Org" 
		     datasource="AppsProgram" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT *
		     FROM   Organization.dbo.Organization
			 WHERE  OrgUnit = '#OrgUnit#'
	  </cfquery>
   
	   <cfquery name="Count" 
		     datasource="AppsProgram" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 SELECT *
			 FROM   Program
			 WHERE  Mission = '#Form.Mission#'				 
			 AND    ProgramCode IN (SELECT ProgramCode 
			                        FROM   ProgramPeriod 
									WHERE  OrgUnit = '#orgUnit#' 
							          AND  Period = '#Form.Period#') 
	   </cfquery>
   
	   <cfset cnt = count.recordcount>
			   
	   <cfif len(cnt) eq "1">
	        <cfset cnt = "00#cnt#">
	   <cfelseif len(cnt) eq "2">
	        <cfset cnt = "0#cnt#">	  			  
	   </cfif>
	   
	   <cfset ref = "">
	   			 
	   <cfif Form.ProgramClass eq "Program">			 
			
			 <cfif len(Org.OrgUnitNameShort) lte 10>
				 <cfset ref = "#Org.OrgUnitNameShort#-P-#cnt#">
			 </cfif>
			 
	   <cfelse>			 
		 	
			 <cfif len(Org.OrgUnitNameShort) lte 10>
			    <cfset ref = "#Org.OrgUnitNameShort#-S-#cnt#">		 
			 </cfif>
			 
	   </cfif>			
					
   </cfif>	
   
   <!--- apply groups from the parent --->
   
   <cfquery name="InsertGroup" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">	 
	     INSERT INTO ProgramGroup		 
		        (ProgramCode,
				 ProgramGroup,	
				 Status,		
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)				 
		 SELECT '#cde#',
		        ProgramGroup,
				'1',
		        '#SESSION.acc#',
				'#SESSION.last#',
				'#SESSION.first#'				
		 FROM   ProgramGroup
		 WHERE  ProgramCode = '#Form.ParentCode#' 	 
    </cfquery>
	
	<!--- obtain status --->
	
	<cfquery name="getStatus" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 SELECT *			
	 FROM   Ref_ProgramGroup
	 WHERE  Code IN (SELECT ProgramGroup 
	                 FROM   ProgramGroup 
					 WHERE  ProgramCode = '#Form.ParentCode#') 
	</cfquery>	
  
   <cfquery name="InsertProgramPeriod" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO ProgramPeriod
	        (ProgramCode,
			 Period,
			 ProgramManager,
			 PeriodParentCode,			 
			 PeriodDescription,		
			 PeriodProblem,
			 PeriodGoal,	
			 PeriodObjective,			 	
			 OrgUnitImplement,			
			 OrgUnitRequest,
			 OrgUnit,
			 Reference,
			 Status,
			 ReferenceBudget1,
			 ReferenceBudget2,
			 ReferenceBudget3,
			 ReferenceBudget4,
			 ReferenceBudget5,
			 ReferenceBudget6,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName)
   	 VALUES ( '#cde#',
			  '#Form.Period#',
			  '#Form.ProgramManager#',
			  '#Form.ParentCode#',			  
			  '#Form.PeriodDescription#',		
			  '#Form.PeriodProblem#',
			  '#Form.PeriodGoal#',	
			  '#Form.PeriodObjective#',			 
			  <cfif form.OrgUnit1 neq "">
			  '#Form.OrgUnit1#',
			  <cfelse>
			  NULL,
			  </cfif>
			  <cfif form.OrgUnit0 neq "">
			  '#Form.OrgUnit0#',
			  <cfelse>
			  NULL,
			  </cfif>
			  '#OrgUnit#',
			  '#ref#', 
			  <cfif getStatus.recordcount gte "1">
			  '#getStatus.DefaultStatus#',
			  <cfelse>
			  '#Form.Status#',
			  </cfif>
			  '#Form.ReferenceBudget1#',
			  '#Form.ReferenceBudget2#',
			  '#Form.ReferenceBudget3#',
			  '#Form.ReferenceBudget4#',
			  '#Form.ReferenceBudget5#',
			  '#Form.ReferenceBudget6#',
			  '#SESSION.acc#',
  		 	  '#SESSION.last#',
		  	  '#SESSION.first#')
			  </cfquery>
	</cfif>	
	
	
	<cfparam name="Form.PersonNo" default="">	
	
		<cfquery name="getPeriod" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_Period
		    WHERE  Period = '#form.Period#'	  
		</cfquery>
	
	<cfif Form.PersonNo neq "">
			
		<cfquery name="Insert" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO ProgramPeriodOfficer 
		         (ProgramCode, 
				  Period,
				  PersonNo,			 
				  Remarks,
				  DateEffective,
				  DateExpiration,
				  OfficerUserId,
				  OfficerLastName,
				  OfficerFirstName)
		  VALUES ('#cde#', 
		  		  '#Form.Period#',
				  '#Form.PersonNo#',			 
				  'Project Manager',
				  '#dateformat(getPeriod.DateEffective,client.dateSQL)#',
				  '#dateformat(getPeriod.DateExpiration,client.dateSQL)#',
				  '#SESSION.acc#',
				  '#SESSION.last#',
				  '#SESSION.first#')
		</cfquery>		
	
	</cfif>
	
	<!--- create a workflow for the instance --->
	
	<cfquery name="getProgram" 
		 datasource="AppsProgram"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT   *
			 FROM     ProgramPeriod
			 WHERE    ProgramCode    = '#cde#'  
			 AND      Period         = '#Form.Period#' 
	</cfquery>	
			
	<cfquery name="CheckMission" 
		 datasource="AppsEmployee"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT   *
			 FROM     Organization.dbo.Ref_EntityMission 
			 WHERE    EntityCode     = 'EntProgram'  
			 AND      Mission        = '#Form.Mission#' 
	</cfquery>	
	
	<cfif Form.ProgramAllotment eq "1">
	
		<!--- we create allotment records to be inherited from the Parent --->
		
		<!--- verify if header program allotment record exists for the edition --->
		  
		  <cfquery name="getParentAllotmentData" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT     *
				FROM       ProgramAllotment
				WHERE      ProgramCode = '#Form.ParentCode#'	
				AND        Period      = '#Form.period#' 
				  			
		  </cfquery>
		  
		  <cfloop query="getParentAllotmentData">
		  
			      <cfquery name="Insert" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO ProgramAllotment
						   (ProgramCode, 
						    Period, 
							EditionId,
							Fund,
							FundEnforce,
							OfficerUserId, 
							OfficerLastName, 
							OfficerFirstName)
					values ('#cde#', 
					        '#period#', 
							'#EditionId#', 
							<cfif fund neq "">
							'#Fund#',
							<cfelse>
						    NULL,
							</cfif>
							'#FundEnforce#',
							'#SESSION.acc#', 
							'#SESSION.last#', 
							'#SESSION.first#')
				  </cfquery>  
		  
		  </cfloop>
	
	</cfif>	
		
	<!--- record partners --->
	
	<cfloop index="itm" from="1" to="4">
	
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
				('#cde#','#Form.Period#','#org#','#itm#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')				
			</cfquery>	
		
		</cfif>
	
	</cfloop> 	
		
	<cfquery name="Selected" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 SELECT   top 1 *
	 FROM     ProgramPeriod
	 WHERE    OfficerUserId = '#SESSION.acc#'
	 ORDER BY ProgramId DESC
	</cfquery> 
		
	<cfset link = selected.programid>
		
	<!--- makes language entry --->

	<cf_LanguageInput
		TableCode      = "Program" 
		Mode           = "Save"
		Lines          = "1"
		Name1          = "ProgramName"
		Key1Value      = "#cde#">
				
	<!--- makes language entry --->

	<cf_LanguageInput
		TableCode      = "ProgramPeriod" 
		Mode           = "Save"
		Lines          = "3"				
		Name1          = "PeriodDescription"
		Name2          = "PeriodGoal"
		Name3          = "PeriodObjective"
		Key1Value      = "#cde#"
		Key2Value      = "#Form.Period#">		
		
	<!--- hierarchy --->

	<cf_programHierarchy programcode = "#cde#" period="#Form.Period#">	
  
	<cfoutput>
			 	
		<script LANGUAGE = "JavaScript">	  
		   opener.document.getElementById('findlocate').click()
		   // opener.history.go()			   				
		   Prosis.busy('no')
		</script>
				
		<cfif CheckMission.workflowEnabled eq "1" and Form.ProgramClass neq "Program">
					
			<cfquery name="Program" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  *
				FROM    Program P,ProgramPeriod Pe
				WHERE   P.ProgramCode = Pe.ProgramCode
				AND     Pe.ProgramId = '#getProgram.ProgramId#'   	
			</cfquery>
			
			<cfif CGI.HTTPS eq "off">
			    <cfset protocol = "http">
			<cfelse> 
			  	<cfset protocol = "https">
			</cfif>
			
			<cfset link = "ProgramREM/Application/Program/Indicator/TargetView.cfm?id=#getProgram.ProgramId#">
			
			<cf_ActionListing 
			    EntityCode       = "EntProgram"
				EntityClass      = "#Program.ProgramClass#"
				EntityGroup      = ""
				EntityStatus     = ""			
				Mission          = "#Program.Mission#"
				OrgUnit          = "#Program.OrgUnit#"
				ObjectReference  = "#Program.ProgramName#"
				ObjectReference2 = "#Program.Reference#"
			    ObjectKey1       = "#Program.ProgramCode#"
				ObjectKey2       = "#Program.Period#"
				ObjectURL        = "#link#"
				Show             = "No">
		
		</cfif>	
			
		<cfif form.ProgramId eq "add">
		
		  <cfif form.ProgramClass eq "Project">
		
				<script LANGUAGE = "JavaScript">			  
				   ptoken.open(root + "/ProgramREM/Application/Program/ProgramView.cfm?ProgramId=#selected.programid#", "_top");						
				</script>	
		  
		  <cfelse>
		  
			    <script LANGUAGE = "JavaScript">						 
				   ptoken.open(root + "/ProgramREM/Application/Program/ProgramView.cfm?ProgramId=#selected.programid#", "_top");				       
				</script>
		  
		  </cfif>
					
		<cfelse>
		
			<script LANGUAGE = "JavaScript">		   
			   ptoken.open(root + "/ProgramREM/Application/Program/ProgramView.cfm?ProgramId=#selected.programid#", "_top");		
			</script>	
			
		</cfif>		

	</cfoutput>