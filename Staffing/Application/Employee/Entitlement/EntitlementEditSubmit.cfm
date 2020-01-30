
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfset mode = "personal">

<cfif Len(Form.Remarks) gt 800>
  <cfset remarks = left(Form.Remarks,800)>
<cfelse>
  <cfset remarks = Form.Remarks>
</cfif>  

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateEffective#">
<cfset STR = dateValue>

<cfset dateValue = "">
<cfif Form.DateExpiration neq ''>
    <CF_DateConvert Value="#Form.DateExpiration#">
    <cfset END = dateValue>
<cfelse>
    <cfset END = 'NULL'>
</cfif>	

<!--- verify if record exist --->

<cfquery name="Entitlement" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   PersonEntitlement
	WHERE  PersonNo      = '#Form.PersonNo#' 
	AND    EntitlementId = '#Form.EntitlementId#'
</cfquery>

<!--- check for overlap --->

<cfquery name="Allow" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_PayrollItem 
	WHERE  PayrollItem    = '#Form.Entitlement#' 
</cfquery>

<cfif Allow.AllowOverLap eq "0"> 
	
	<cfquery name="Check" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   PersonEntitlement
		WHERE  PersonNo       = '#Form.PersonNo#' 
		AND    PayrollItem    = '#Form.Entitlement#' 
		AND    PayrollItem IN (SELECT PayrollItem FROM Ref_PayrollItem WHERE AllowOverlap = 0)
		AND    DateEffective <= #END# 
		AND    Status        != '9'
		AND    EntitlementId != '#Form.EntitlementId#'
	</cfquery>
	
	<cfif check.recordcount gte "1">
		<cf_message message="Problem, entitlement dates may not overlap with other entitlements for the same payroll item" return="back">
		<cfabort>
	</cfif>

</cfif>

<cfparam name="Entitlement.RecordCount" default="0">
<cfparam name="Form.DependentId" default="">

<cfset entid = Form.EntitlementId>

<cfif Entitlement.recordCount eq 1> 

	<cfif Entitlement.status lte "1">
		
		<cfquery name="EditEntitlement" 
		   datasource="AppsPayroll" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			   UPDATE PersonEntitlement 
			   SET   DateEffective    = #STR#,
					 DateExpiration   = #END#,
					 PayrollItem      = '#Form.Entitlement#',
					 SalarySchedule   = '#Form.SalarySchedule#',
					 <cfif form.dependentid neq "">
					 DependentId      = '#Form.DependentId#', 
					 <cfelse>
					 DependentId      = NULL,
					 </cfif>
					 Currency         = '#Form.Currency#',
					 Amount           = '#Form.Amount#',
					 Period           = '#Form.Period#',
					 Remarks          = '#Remarks#'
			   WHERE PersonNo         = '#Form.PersonNo#' 
			   AND   EntitlementId    = '#Form.EntitlementId#' 
		   </cfquery>
	
	<cfelse>
	
		<cfquery name="EditEntitlement" 
		   datasource="AppsPayroll" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			   UPDATE PersonEntitlement 
			   SET    Period           = '#Form.Period#',
			   		  <cfif form.dependentid neq "">
					  DependentId      = '#Form.DependentId#', 
					  <cfelse>
					  DependentId      = NULL,
					  </cfif>
					  Remarks          = '#Remarks#'
			   WHERE  PersonNo         = '#Form.PersonNo#' 
			   AND    EntitlementId    = '#Form.EntitlementId#' 
		   </cfquery>
	
		<cfif Form.DateExpiration neq DateFormat(Entitlement.DateExpiration,CLIENT.DateFormatShow)
		    or Form.DateEffective neq DateFormat(Entitlement.DateEffective,CLIENT.DateFormatShow)
		    or Form.Amount neq Entitlement.Amount>
			
			<!--- additional check if the period overlaps the old period 
			
			<cfset dateValue = "">
			<CF_DateConvert Value="#Form.DateEffective#">
			<cfset EFFN = dateValue>
			
			<cfset dateValue = "">
			<CF_DateConvert Value="#DateFormat(Entitlement.DateEffective,CLIENT.DateFormatShow)#">
			<cfset EFF = dateValue>
			
			<cfset dateValue = "">
			<CF_DateConvert Value="#Form.DateExpiration#">
			<cfif form.dateExpiration neq "">		
				<CF_DateConvert Value="#Form.DateExpiration#">					
			<cfelse>
				<CF_DateConvert Value="31/12/9999">			    
			</cfif>
			<cfset EXPN = dateValue>
			
			<cfset dateValue = "">			
			<cfif Entitlement.DateExpiration neq "">			
				<CF_DateConvert Value="#DateFormat(Entitlement.DateExpiration,CLIENT.DateFormatShow)#">
			<cfelse>		
				<CF_DateConvert Value="31/12/9999">					
			</cfif>
			<cfset EXP = dateValue>
			
			
			<cfif EFFN gt EXP or EXPN lt EFF>
			
				<cf_message message="Problem, it does not appear you are recording an amendment for this record but a new record. Please contact your administrator" return="back">
				<cfabort>
			
			</cfif>
			
			--->			
			
			<cftransaction>
				   
		     <cfquery name="EditEntitlement" 
		      datasource="AppsPayroll" 
		      username="#SESSION.login#" 
		      password="#SESSION.dbpw#">
			      UPDATE PersonEntitlement 
			      SET    Status           = '9'
			      WHERE  PersonNo        = '#Form.PersonNo#' 
				  AND    EntitlementId   = '#Form.EntitlementId#' 
		     </cfquery>
						
			 <cf_assignId>
			 <cfset entid = rowguid>					
					 
		     <cfquery name="InsertEntitlement" 
		     datasource="AppsPayroll" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO PersonEntitlement 
			         (   PersonNo,
					     EntitlementId,
						 DateEffective,
						 DateExpiration,
						 DependentId,
						 SalarySchedule,
						 DocumentReference,
						 EntitlementClass,
						 PayrollItem,
						 Currency,
						 Amount,
						 Period,
						 Remarks,						
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName )
		      VALUES (   '#Form.PersonNo#',
			             '#entid#',
					      #STR#,
						  #END#,
						  <cfif form.dependentId neq "">
						  '#Form.dependentId#',
						  <cfelse>
						  NULL,
						  </cfif>
						  '#Form.SalarySchedule#',
						  '#Form.DocumentReference#',
						  'Amount',
						  '#Form.Entitlement#',
						  '#Form.Currency#',
						  '#Form.Amount#',
						  '#Form.Period#',
						  '#Remarks#',						 
						  '#SESSION.acc#',
				    	  '#SESSION.last#',		  
					  	  '#SESSION.first#'
					  )
		    </cfquery>			
						
			<cfquery name="Person" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   Employee.dbo.Person
				WHERE  PersonNo = '#Form.PersonNo#' 
			</cfquery>
			
			<cfquery name="OnBoard" 
			  datasource="AppsPayroll" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				SELECT TOP 1 *
				FROM      Employee.dbo.PersonAssignment
				WHERE     PersonNo = '#Form.PersonNo#' 
				AND       DateEffective < #STR#
				AND       DateExpiration >= #STR#
				AND       AssignmentStatus IN ('0','1') 
				ORDER BY  DateExpiration DESC
			</cfquery>
			
			<cfquery name="currentContract" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT TOP 1 L.*, 
			           R.Description as ContractDescription, 
				       A.Description as AppointmentDescription
			    FROM   Employee.dbo.PersonContract L, 
				       Employee.dbo.Ref_ContractType R,
					   Employee.dbo.Ref_AppointmentStatus A
				WHERE  L.PersonNo = '#Form.PersonNo#'
				AND    L.ContractType = R.ContractType
				AND    L.AppointmentStatus = A.Code
				AND    L.ActionStatus != '9'
				ORDER BY L.DateEffective DESC 
			</cfquery>		
			
			<cfset action = "3062">			
			<cfinclude template="EntitlementActionSubmit.cfm">
			
			</cftransaction>
			
			<cfset link = "Staffing/Application/Employee/Entitlement/EntitlementEdit.cfm?ID=#Form.PersonNo#&ID1=#entid#">

			<cf_ActionListing 
			    EntityCode       = "EntEntitlement"
				EntityClass      = "Standard"
				EntityGroup      = "Individual"
				EntityStatus     = ""
				Mission			 = "#currentContract.Mission#"		
				OrgUnit          = "#OnBoard.OrgUnit#"
				PersonNo         = "#Person.PersonNo#"
				ObjectReference  = "#Form.Entitlement#"
				ObjectReference2 = "#Person.FirstName# #Person.LastName#"
			    ObjectKey1       = "#Form.PersonNo#"
				ObjectKey4       = "#entid#"
				ObjectURL        = "#link#"
				Show             = "No"		
				CompleteFirst    = "No">
			
		</cfif>
		
	</cfif>	

</cfif>
	  
<cfoutput>
	
	<cf_SystemScript>
	
	 <script language = "JavaScript">
		 ptoken.location("EntitlementEdit.cfm?ID=#Form.PersonNo#&ID1=#entid#");
	 </script>	
  
</cfoutput>	   

