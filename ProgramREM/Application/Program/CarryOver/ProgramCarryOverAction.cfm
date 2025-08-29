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
<cfquery name="CurrentPeriod" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT   *
	 FROM     Ref_Period
	 WHERE    Period = '#URL.PeriodCurrent#'
</cfquery>

<cfquery name="PriorPeriod" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT   *
	 FROM     Ref_Period
	 WHERE    Period = '#URL.Period#'
</cfquery>

<!--- we select the prior value --->

 <cfquery name="Prior" 
	datasource="AppsProgram"
	username="#SESSION.login#" 
    password="#SESSION.dbpw#" >
	SELECT *
    FROM   UserQuery.dbo.#SESSION.acc#ProgramPeriod Pe
	WHERE  Pe.ProgramCode = '#prg#' 
	AND    Pe.Period      = '#URL.Period#'		
 </cfquery>
 
 <!--- check of orgunit exists for ProgramPeriod --->
  
 <cfquery name="Check" 
	datasource="AppsProgram"
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	 SELECT * 
	 FROM   Organization.dbo.Organization
	 WHERE  OrgUnit = '#prior.orgunit#'	
 </cfquery>
  
 <cfif check.recordcount eq "1">
	  
    <cfquery name="Check" 
		datasource="AppsProgram"
		username="#SESSION.login#" 
	    password="#SESSION.dbpw#" >
		SELECT *
	    FROM  ProgramPeriod Pe
		WHERE Pe.ProgramCode = '#prg#' 
		AND   Pe.Period      = '#URL.PeriodCurrent#'
	</cfquery>
	
	<cfif Check.recordcount eq "1">
		
		 <!--- if exists set record status to "1" and update entry date/name --->
		
			<cfquery name="Update" 
				datasource="AppsProgram"
				username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				UPDATE ProgramPeriod 
				SET    RecordStatus = '1'
				WHERE  ProgramCode  = '#prg#' 
				AND    Period       = '#URL.PeriodCurrent#'
			</cfquery>
			
	<cfelse>	
				
			<!--- this is a candidate to be recorded but first we check if we need to create a new
			programcode for this instance --->
				
			<cfparam name="Form.selected_#prg#" default="">
			
			<cfset changeparent = evaluate("Form.selected_#prg#")>
			
			<cfif changeparent neq "">
			
			    <!--- overruleling parent code --->
			    <cfset parentcode = changeparent>
				
			<cfelse>
			
			  <cfquery name="get" 
				datasource="AppsProgram"
				username="#SESSION.login#" 
			    password="#SESSION.dbpw#" >
					SELECT *
				    FROM   ProgramPeriod
					WHERE  ProgramCode = '#prg#' 	
					AND    Period      = '#URL.Period#'		
			  </cfquery>		
			  
			  <cfif get.PeriodParentCode neq "">
			  
			  	<cfset parentcode =  get.PeriodParentCode>
			  
			  <cfelse>
			  
			  	<cfset parentcode = "">
			  
			  </cfif>
						
				<!--- we determine that we need to update the parent structure --->		
			
			</cfif>
			
		    <!--- we reset the program hierarchy here --->
					
			<cfquery name="InsertProgramPeriod" 
			     datasource="AppsProgram" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				   INSERT INTO ProgramPeriod
			 	   	        (ProgramCode,
							 Period,
							 PeriodParentCode,
							 PeriodDescription,
							 PeriodGoal,
							 PeriodObjective,
							 ProgramManager,
						     Reference,
							 Source,
							 OrgUnit,
							 OrgUnitImplement,		
							 RecordStatus,
							 RecordStatusDate,
							 RecordStatusOfficer,	
							 Status,											 
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName,
							 Created)
				   VALUES ('#prg#',
						   '#URL.PeriodCurrent#',
						    '#parentcode#',
							'#Prior.PeriodDescription#',
							'#Prior.PeriodGoal#',
							'#Prior.PeriodObjective#',							
						    '',
						    '#Prior.Reference#',
						    'Carryover',
						    '#Prior.OrgUnit#',
						    '#Prior.OrgUnitImplement#',
							'1',
							getDate(),
							'#SESSION.acc#',
							'1',
						    '#SESSION.acc#',
				   		    '#SESSION.last#',
						    '#SESSION.first#',
						    getDate())
			</cfquery>	
			
			<cfif changeparent neq "">		
			
				<cf_programhierarchy programcode="#parentcode#" period="#URL.PeriodCurrent#">
						
			</cfif>
			
			<cfif Parameter.CarryOverMode neq "Limited">					
					
				<cfquery name="FromEdition" 
				    datasource="AppsProgram" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
				      SELECT  Period, EditionId
					  FROM    Ref_AllotmentEdition 
					  WHERE   EditionId = '#url.edition#'					 					       			
				</cfquery>		
												
				<cfloop query="FromEdition">
					 
					<!--- set the from edition ---> 
					
					<cfset edifrom = EditionId>		
					 
					<cfif Period eq "">
					 
					     <!--- period is null so we take move to the same edition for the new plan period --->				 
						 <cfset edito =  EditionId>		
					 
					<cfelse>
					 										 
						 <cfquery name="ToEdition" 
					     datasource="AppsProgram" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
						      SELECT EditionId
							  FROM   Ref_AllotmentEdition 
							  WHERE  Mission      = '#url.Mission#'
							  AND    Period       = '#CurrentPeriod.Period#'
							   AND   EditionClass = 'Budget'
							  <!--- period belong to the same period class --->
							  AND    Period IN (SELECT Period 
							                    FROM   Ref_Period 
												WHERE  PeriodClass = '#PriorPeriod.PeriodClass#') 
						 </cfquery>		
					 	
						 <cfset edito = ToEdition.EditionId>									


					</cfif>															
						 
				  <!--- amendments 4/1/2010------------------------------------------------------ --->		 
				  <!--- Add program budget amounts to ProgramAllotment and ProgramAllotmentDetail 
				  but only those editions that lie later !!! or are meant for all periods         --->				  	
				  	
						<cfinvoke component	= "Service.Process.Program.CarryOver"
						      Method		= "ProgramEditionCarryOver"
							  ProgramCode	= "#prg#"
							  FromPeriod	= "#URL.Period#"
							  FromEdition	= "#edifrom#"
							  ToPeriod		= "#URL.PeriodCurrent#"
							  ToEdition		= "#edito#">				  			 			  
											
				</cfloop>		
				 					 
				  <!--- activities --->
					
					<cfquery name="Activity" 
					 datasource="AppsProgram" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#"> 
					 SELECT   ActivityId,ActivityDescription
					 FROM     ProgramActivity A
		             WHERE    ProgramCode = '#prg#' 
					 AND      ActivityPeriod = '#URL.Period#'
					 AND      RecordStatus != '9'
					 AND      ProgramCode IN (SELECT ProgramCode 
					                          FROM   Program 
											  WHERE  ProgramCode = A.ProgramCode
											  AND    ProgramClass != 'Project')
					</cfquery>	
					
					<cfloop query="Activity">
					
					    <cfset act = ActivityId>
						
						<cfquery name="Parameter" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
							SELECT *
						    FROM Parameter
						</cfquery>
					
						<cfset No = Parameter.ActivityNo+1>
						<cfif No lt 10000>
						     <cfset No = 10000+No>
						</cfif>
								
						<cfquery name="Update" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    UPDATE Parameter
							SET    ActivityNo = '#No#' 
						</cfquery>
								
						<cfquery name="Insert" 
						 datasource="AppsProgram" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#"> 
							 INSERT INTO ProgramActivity
				                       (ProgramCode, ActivityPeriod, ActivityId, ActivityDate, ActivityDescription, OrgUnit, LocationCode, Reference,
							           OfficerUserId, OfficerLastName, OfficerFirstName)
				             SELECT    ProgramCode, '#URL.PeriodCurrent#', '#No#', getDate(), ActivityDescription, '#Prior.OrgUnit#', LocationCode, Reference,
								       '#SESSION.acc#', '#SESSION.last#', '#SESSION.first#'
				             FROM      ProgramActivity
				             WHERE     ProgramCode    = '#prg#' 
							 AND       ActivityPeriod = '#URL.Period#'
							 AND       ActivityId     = '#Act#'
						</cfquery>	
						
						<cf_languagecopy
							datasource="AppsProgram"
							tablecode="ProgramActivity"
							key1="#prg#"
							key2="#URL.PeriodCurrent#"
							key3="#No#"
							key1Old="#prg#"
							key2Old="#URL.Period#"
							key3Old="#Activity.ActivityId#">					
					
					</cfloop>
				
			</cfif>
			
	</cfif>	  
	
<cfelse>

	<cf_alert message="Program [#prg#-#URL.Period#] with an invalid unit [#Prior.OrgUnit#] found.">	
	<cfabort>	

</cfif>	