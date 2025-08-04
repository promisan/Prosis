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

<cfquery name="Mission" 
     datasource="AppsProgram" 
  	 username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT *
     FROM   Ref_ParameterMission
     WHERE  EnableDonor = 1   
</cfquery>	

<!--- we first create an object mapping table on the parent level as we map in principle
on the parent level only --->

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Ref_Object">	

<cfquery name="getObject" 
     datasource="AppsProgram" 
  	 username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT   Code, Resource, ParentCode, Description, HierarchyCode
	 INTO     userQuery.dbo.#SESSION.acc#Ref_Object
	 FROM     Ref_Object	
</cfquery>	

<cfquery name="setObjectParent" 
     datasource="AppsProgram" 
  	 username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     UPDATE userQuery.dbo.#SESSION.acc#Ref_Object
	 SET    ParentCode = Code
	 WHERE  ParentCode is NULL or ParentCode NOT IN (SELECT Code FROM Ref_Object)	
</cfquery>	

<cfloop query="Mission">

	<!--- --------------------------------------------------------------------- --->
	<!--- Stage 1 we review the mappings with the latest updates from load----- --->
	<!--- --------------------------------------------------------------------- --->
		
	<!--- Meta code
	
	Define only missions that have donor enabled
	Limit the journal to the journal as recorded Ref_ParameterMission
	
	0 - Only transactions that are not tagged yet ContributionLineId.
	1-  Consider transactions for ProgramCodes that have at least one contribution defined
	2.  Loop through transactions
	 
	     ProgramCode
		 Fund
		 OE
		 Date
		 Amount
		 
		 Then we define if we have a contribution for that project/fund with an effective - expiration within
		 and that still has enough monies left
		 
		 If just one we take it
		 
		 If > 1 we add the OE
		 
		 If just one we take it
		 
		 If > 1 we take the earliest expiration date
		 
	--->
	
	<!--- --------------------------------------------------------------------------------------- --->
	<!--- we are retrieving the financials lines that are 
	       NOT associated to a contribution yet so we can determine if we can indeed map these--- --->
	<!--- --------------------------------------------------------------------------------------- --->
		
	<cfquery name="getLines" 
	     datasource="AppsLedger" 
	  	 username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		  SELECT     L.Journal, 
		             L.JournalSerialNo, 
					 L.TransactionLineId,
					 H.TransactionDate, 
					 H.JournalBatchDate,
					 L.Fund, 
					 L.ProgramCode, 
					 L.ProgramPeriod, 
					 O.ParentCode as ObjectCode, <!--- we use the parent code for mapping --->
	                 L.AmountBaseDebit - L.AmountBaseCredit AS Amount					
					 					 
		  FROM       TransactionHeader AS H INNER JOIN
	                 TransactionLine AS L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo INNER JOIN
					 userQuery.dbo.#SESSION.acc#Ref_Object O ON O.Code = L.ObjectCode
		  WHERE      H.Mission = '#mission#' 
		  
		  AND        H.Journal IN (SELECT Journal 
		                           FROM   Journal 
								   WHERE  Mission = '#Mission.Mission#' 
								   AND    SystemJournal = 'Contribution') 
								   
		  AND        L.TransactionSerialNo > 0  <!--- exclude the contra-transactions --->
		  
		  <!--- not tagged yet --->
		  
		  AND        (
			             L.ContributionLineid is NULL 
						 OR
			             L.ContributionLineId NOT IN (SELECT ContributionLineid 
						                              FROM   Program.dbo.ContributionLine 
													  WHERE  ContributionLineId = L.ContributionLineId)
					 )		
					 
		 		  		   			 
		  <!--- has been contribution allotted --->
		  		  	 
		  AND        L.ProgramCode IN
	                          (SELECT    PD.ProgramCode
	                            FROM     Program.dbo.ProgramAllotmentDetail AS PD INNER JOIN
	                                     Program.dbo.ProgramAllotmentDetailContribution AS PDC ON PD.TransactionId = PDC.TransactionId
	                            WHERE    PD.ProgramCode = L.ProgramCode
								AND      PD.Period      = L.ProgramPeriod)
							
					
		  ORDER BY   L.ProgramCode, 
		  			 L.ProgramPeriod,
		             L.Fund, 					  
					 H.JournalBatchDate, <!--- reflects the trigger date of the original document : obligation --->
					 H.TransactionDate	
										  					 
					 
	</cfquery>		
	
	<cf_ScheduleLogInsert
		   	ScheduleRunId  = "#schedulelogid#"
			Description    = "Started #Mission.mission# for #getLines.recordcount# lines"
			StepStatus     = "1">
			
	<cfset cnt = 0>		
	<cfset trb = 0>		 
	
	<!---
	
	<cfoutput query="getLines" group="ProgramCode">	    
	
		<cfoutput group="ProgramPeriod">
						
			<cfquery name="getPeriod" 
			     datasource="AppsProgram" 
			  	 username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 SELECT *
				 FROM   Organization.dbo.Ref_MissionPeriod
				 WHERE  Mission  = '#Mission.Mission#'
				 AND    Period   = '#ProgramPeriod#'		<!--- execution period --->		 
			</cfquery>		
		
			<cfquery name="allotment" 
			     datasource="AppsProgram" 
			  	 username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 SELECT *
				 FROM   ProgramAllotment
				 WHERE  ProgramCode = '#ProgramCode#'
				 AND    Period      = '#getPeriod.PlanningPeriod#'
				 AND    EditionId   = '#getPeriod.EditionId#'
			</cfquery>	
		
			<cfset supportaccount = allotment.SupportObjectCode>
			<cfset modemapping    = allotment.ModeMappingTransaction>
			<cfset hasContribution = "0">
		   			
			<cfoutput>
			
				<cfset cnt = cnt +1>
					
				<cfif cnt eq "200">
							
					<cf_ScheduleLogInsert
					   	ScheduleRunId  = "#schedulelogid#"
						Description    = "Process Execution #Mission.mission#: #currentrow#/#getLines.recordcount#"
						StepStatus     = "1">	
			
					<cfset cnt = 0>
					
			    </cfif>		
				
				<!--- we map contributions only if we indeed find 
				budget contribution for this program/project --->
				 			
				<cfinclude template="batchMappingTransactionProcess.cfm">
							
			</cfoutput>
			
			<!--- now we check if we missed any but only if for this project
			we have any allotment contributions --->
			
						
				<cfquery name="get" 
					     datasource="AppsLedger" 
					  	 username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
						  SELECT     L.Journal, 
						             L.JournalSerialNo, 
									 L.TransactionLineId,
									 H.TransactionDate, 
									 H.JournalBatchDate,
									 L.Fund, 
									 L.ProgramCode, 
									 L.ProgramPeriod, 
									 O.ParentCode as ObjectCode, <!--- we use the parent code for mapping --->
					                 L.AmountBaseDebit - L.AmountBaseCredit AS Amount
						  FROM       TransactionHeader AS H INNER JOIN
					                 TransactionLine AS L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo INNER JOIN
									 userQuery.dbo.#SESSION.acc#Ref_Object O ON O.Code = L.ObjectCode
						  WHERE      H.Mission = '#Mission.mission#' 
						  
						  <!---     only transactions of journal that we tagged as such --->
						  AND        H.Journal IN (SELECT Journal 
						                           FROM   Journal 
												   WHERE  Mission = '#Mission.Mission#' 
												   AND    SystemJournal = 'Contribution') 
												   
						  AND        L.TransactionSerialNo > 0  <!--- exclude the contra-transactions --->
						  
						  <!--- not tagged yet --->
						  
						  AND        (
							             L.ContributionLineid is NULL 
										 OR
							             L.ContributionLineId NOT IN (SELECT ContributionLineid 
										                              FROM   Program.dbo.ContributionLine 
																	  WHERE  ContributionLineId = L.ContributionLineId)
									 )		
									 
						  <!--- and also has been funded by one or more contributions --->		 			 
								  	 
						  AND        L.ProgramCode = '#ProgramCode#'
						  AND        L.ProgramPeriod = '#ProgramPeriod#'
								  												
									
						  ORDER BY   L.ProgramCode, 
						  			 L.ProgramPeriod,
						             L.Fund, 					  
									 H.JournalBatchDate, <!--- reflects the trigger date of the original document : obligation --->
									 H.TransactionDate					 					 
									 
					</cfquery>
				
					<!--- sometime the amounts are negative whih then frees up the data, but in case of obligations as they are reloaded it means they are never
					used. --->
					
					<cfif get.recordcount gte "1">
					
						<cfloop query="get">
						
							<cfinclude template="batchMappingTransactionProcess.cfm">
										
						</cfloop>
									
					</cfif>		
			
		
			<!--- now we check the ProgramSupportCosts to be associated based on the contribution associations --->
				
			<cfinvoke component = "Service.Process.Program.ProgramAllotment"  
				   method            = "generateSupportCost" 
				   ProgramCode       = "#ProgramCode#" 
				   Period            = "#ProgramPeriod#">	
		   
	   </cfoutput>	   
		
	</cfoutput>
	
	--->
	
	<cf_ScheduleLogInsert
	   	ScheduleRunId  = "#schedulelogid#"
		Description    = "#mission.mission# mapping completed"
		StepStatus     = "1">	
	
	<!--- --------------------------------------------------------------------- --->
	<!--- Stage 2 we review the support calculations with the new mappings----- --->
	<!--- --------------------------------------------------------------------- --->
			
	<cfquery name="getProgramPeriod" 
	     datasource="AppsLedger" 
	  	 username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		  SELECT     DISTINCT 
		             H.Mission,		              
					 L.ProgramCode, 
					 L.ProgramPeriod 					
		  FROM       TransactionHeader AS H INNER JOIN
	                 TransactionLine AS L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo
		  WHERE      H.Mission = '#mission#' 
		  
		  <!---     only if transactions are present in journal that we tagged as such --->
		  AND        H.Journal IN (SELECT Journal 
		                           FROM   Journal 
								   WHERE  Mission = '#Mission.Mission#' 
								   AND    SystemJournal = 'Contribution') 
								   
		  AND        L.TransactionSerialNo > 0     <!--- exclude the contra-transactions --->	  
		  
		  AND        L.ProgramCode IN (SELECT ProgramCode 
		                               FROM   Program.dbo.Program 
									   WHERE  ProgramCode = L.ProgramCode) 
									   
         		 
							 
	</cfquery>		
	
	<cf_ScheduleLogInsert
	   	ScheduleRunId  = "#schedulelogid#"
		Description    = "#mission.mission# PSC calculation for #getProgramPeriod.recordcount# records"
		StepStatus     = "1">		
		
	<cfset cnt = "0">
			
	<cfloop query="getProgramPeriod">	
	
		<cfquery name="getPeriod" 
	     datasource="AppsLedger" 
	  	 username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			 SELECT * 
			 FROM   Organization.dbo.Ref_MissionPeriod
			 WHERE  Mission = '#Mission#'
			 AND    Period  = '#ProgramPeriod#'
		 </cfquery>		 
	
		<cfinvoke component = "Service.Process.Program.ProgramAllotment"  
		   method            = "generateSupportCost" 
		   ProgramCode       = "#programcode#" 
		   Period            = "#ProgramPeriod#"		   
		   EditionId         = "#getPeriod.editionid#">	
		   
		 <cfset cnt = cnt +1>
							
		 <cfif cnt eq "20">
							
			<cf_ScheduleLogInsert
		   	ScheduleRunId  = "#schedulelogid#"
			Description    = "Process #Mission.mission#: #currentrow#/#getProgramPeriod.recordcount#"
			StepStatus     = "1">	
	
			<cfset cnt = 0>
			
	    </cfif>		
	
	</cfloop>
				
	<cf_ScheduleLogInsert
	   	ScheduleRunId  = "#schedulelogid#"
		Description    = "#mission.mission# completed"
		StepStatus     = "1">	

</cfloop>