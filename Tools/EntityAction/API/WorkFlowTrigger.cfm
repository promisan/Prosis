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

<!--- initiates workflows for various entities --->
<!--- trigger procurement invoices for workflow --->

<!--- set status of the workflow object --->

<cftransaction>


<!--- initiates workflows for various entities 
status = 1 completed, status 0 there is a pending action step --->

<cfquery name="SetStatus1" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    UPDATE OrganizationObject
	SET    ObjectStatus = 1
	WHERE  ObjectStatus = 0				 
</cfquery>

<cfquery name="SetStatus0" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE OrganizationObject
	SET ObjectStatus = 0
	WHERE ObjectId IN (SELECT    ObjectId
					   FROM      OrganizationObjectAction OA
					   WHERE     ActionStatus = '0')					   
</cfquery>	
</cftransaction>	

<!--- program event trigger --->

<cf_verifyOperational 
         module    = "Program" 
		 Warning   = "No">
		 
<cfif operational eq "1">		

		<cfquery name="getEvents" 
		     datasource="AppsProgram" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 
			 SELECT  P.Mission AS Mission, P.ProgramName,
			         Pe.*, Ref_ProgramEvent.Description as EventName
			 
			 FROM    ProgramEvent Pe INNER JOIN
                     Program P ON Pe.ProgramCode = P.ProgramCode INNER JOIN
                     Ref_ProgramEvent ON Pe.ProgramEvent = Ref_ProgramEvent.Code			 
			
             WHERE   Pe.EntityClass IN
                           (SELECT   EntityClass
                            FROM     Organization.dbo.Ref_EntityClass
                            WHERE    EntityCode = 'EntProjectEvent')		
			 <!--- is indeed due for action --->				
			 AND     DateEvent <= getDate()+7	
			 
			 <!--- is not recorded already as an action for workflow --->
			 AND     Pe.ProgramCode NOT IN (
			                                SELECT ProgramCode
			                                FROM   ProgramEventAction PL
											WHERE  PL.ProgramCode  = Pe.ProgramCode
											AND    PL.ProgramEvent = Pe.ProgramEvent
											AND    PL.EventDate    = Pe.DateEvent
										   ) 			 
		</cfquery> 
		
		<cfloop query="getEvents">
		
				<cfquery name="Check" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   *
					FROM     ProgramEventAction
					WHERE    ProgramCode  = '#ProgramCode#'
					AND      ProgramEvent = '#ProgramEvent#'
					ORDER BY EventDate DESC				
				</cfquery>
				
				<cfset no = check.recordcount+1>
						
			    <cf_assignid> 
						
				<cfset id = rowguid>	
		
				<cfquery name="Insert" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO ProgramEventAction
					( ProgramCode, 
					  ProgramEvent, 
					  EventId, 
					  EventDate, 
					  EventReference, 
					  OfficerUserId, 
					  OfficerLastName, 
					  OfficerFirstName)
					VALUES
					('#ProgramCode#',
					 '#ProgramEvent#',
					 '#id#',
					 '#dateformat(dateevent,client.dateSQL)#',
					 '#programcode#-#No#',
					 '#SESSION.acc#',
					 '#SESSION.last#',
					 '#SESSION.first#')									
				</cfquery>
																
				<cfset wflink = "ProgramREM/Application/Program/Events/EventsView.cfm?eventid=#id#">								
					
				<cf_ActionListing 
				    EntityCode       = "EntProjectEvent"
					EntityClass      = "#EntityClass#"
					EntityGroup      = "" 
					EntityStatus     = ""
					Mission          = "#Mission#"							
					ObjectReference  = "#ProgramName#"
					ObjectReference2 = "#EventName#"	
				    ObjectKey1       = "#ProgramCode#"
					ObjectKey2       = "#ProgramEvent#"
					ObjectKey4       = "#id#"							
					Show             = "No"							
					ObjectURL        = "#wflink#"> 		  
			  
				
		</cfloop>

</cfif>

<cf_verifyOperational 
         module    = "Procurement" 
		 Warning   = "No">
		 
<cfif operational eq "1">
	
	<cfquery name="Invoice" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT *
			 FROM   Invoice
			 WHERE  InvoiceId NOT IN (SELECT ObjectKeyValue4 
			                          FROM   Organization.dbo.OrganizationObject
									  WHERE  EntityCode = 'ProcInvoice')
			 AND    WorkflowDate <= getDate()+7 						 
	</cfquery>
	
	<cfloop query="Invoice">
	
		<cfset link = "Procurement/Application/Invoice/Matching/InvoiceMatch.cfm?id=#InvoiceId#">
			
		  <cfquery name="OrgUnit" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT * 
			 FROM    Organization.dbo.Organization
			 WHERE   OrgUnit = '#Invoice.OrgUnitOwner#'
		  </cfquery>
			 					
		  <cf_ActionListing 
			    EntityCode       = "ProcInvoice"
				EntityClass      = "#EntityClass#"
				EntityGroup      = "#OrderType#"
				EntityStatus     = ""
				CompleteFirst    = "No"
				OrgUnit          = "#OrgUnitOwner#"
				ObjectReference  = "#InvoiceNo#"
				ObjectReference2 = "#OrgUnit.OrgUnitName#"
				ObjectKey4       = "#InvoiceId#"
			  	ObjectURL        = "#link#"
				Show             = "No"  
				DocumentStatus   = "0">
	
	</cfloop>

</cfif>

<!--- cost actions that lie in the future --->

<cf_verifyOperational 
         module    = "Payroll" 
		 Warning   = "No">		 
		 
<cfif operational eq "1">

	<cfquery name="Cost" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			 
			SELECT  *
			FROM    PersonMiscellaneous
			WHERE   Status <> '9' 
			AND     EntityClass is not NULL <!--- needs a workflow --->
			AND     CostId NOT IN ( SELECT  ObjectKeyValue4
                                    FROM    Organization.dbo.OrganizationObject
									WHERE   EntityCode = 'EntCost' )
            AND     DateEffective <= GETDATE() + 30 
						
	</cfquery>
	
	<cfloop query="Cost">
	
		 <cfquery name="Person" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   Person
				WHERE  PersonNo = '#PersonNo#' 
		  </cfquery>
		  
		  <cfset link = "Staffing/Application/Employee/Cost/MiscellaneousView.cfm?id=#personno#&id1=#costid#">
							
			<cf_ActionListing 
			    EntityCode       = "EntCost"
				EntityClass      = "#EntityClass#"
				EntityGroup      = ""
				EntityStatus     = ""
				Mission 		 = "#Mission#"
				PersonNo         = "#PersonNo#"
				ObjectReference  = "#PayrollItem#"
				ObjectReference2 = "#Person.FirstName# #Person.LastName#" 
				ObjectKey1       = "#PersonNo#"
				ObjectKey4       = "#costid#"
				ObjectURL        = "#link#"										
				Show             = "No"
				CompleteFirst    = "No">
				
				<!---
				
				FlyActor         = "#Pactor[1]#"
				FlyActorAction   = "#Paction[1]#"
				FlyActor2        = "#Pactor[2]#"
				FlyActor2Action  = "#Paction[2]#"	
				FlyActor3        = "#Pactor[3]#"
				FlyActor3Action  = "#Paction[3]#"			
				
				--->
	
		
	
	</cfloop>

</cfif>

		 