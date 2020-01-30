
<!--- initiates workflows for various entities --->
<!--- trigger procurement invoices for workflow --->

<!--- set status of the workflow object --->

<cftransaction>
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
			 AND     DateEvent <= getDate()	
			 
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
			 FROM Invoice
			 WHERE InvoiceId NOT IN (SELECT ObjectKeyValue4 
			                         FROM Organization.dbo.OrganizationObject
									 WHERE EntityCode = 'ProcInvoice')
			 AND   WorkflowDate >= getDate() 						 
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