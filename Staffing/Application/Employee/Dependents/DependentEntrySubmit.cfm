
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cf_systemscript>

<!--- create temp variables --->

<!---								
<cfloop index="itm" list="Insurance,RateInsurance,Entitlement,Dependent,Housing">
--->
<cfloop index="itm" list="Insurance,RateInsurance,Entitlement,Dependent">

	<cfset tag = left(itm,1)>
	
	<!--- provision for 3 lines --->
	
	<cfloop index="line" from="1" to="3">

		<cfparam name="FORM.#tag#_#line#" default="0">	
		<cfparam name="FORM.SalaryTrigger#tag#_#line#" default="">
	
	</cfloop>
	
</cfloop>

<!--- verify if record exist --->

<cfquery name="Parameter" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
	    FROM     Parameter	
</cfquery>

<cfparam name="Form.Remarks" default="">

<cfif Len(Form.Remarks) gt 300>
  <cfset remarks = left(Form.Remarks,300)>
<cfelse>
  <cfset remarks = Form.Remarks>
</cfif>  

<cfset dateValue = "">
<cfif Form.BirthDate neq "">
    <CF_DateConvert Value="#Form.BirthDate#">
    <cfset DOB = dateValue>
<cfelse>
    <cfset DOB = 'NULL'>
</cfif>	

<cfif not isDate(dob)>
	 	
	<cf_alert message="Invalid Date of Birth.">		
	<cfabort>
	 
</cfif>

<cfset dateValue = "">
<cfif Form.DateEffective neq ''>
    <CF_DateConvert Value="#Form.DateEffective#">
    <cfset eff = dateValue>
<cfelse>
    <cfset eff = 'NULL'>
</cfif>	

<cf_verifyOperational 
         module    = "Payroll" 
		 Warning   = "No">
	
<cftry>	
	
	<cfquery name="Dependent" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   PersonDependent
		WHERE  PersonNo      = '#Form.PersonNo#' 
		AND    BirthDate     = #DOB# 
		AND    FirstName     = '#FORM.FirstName#'
		AND    ActionStatus != '9'
	</cfquery>
	
	<cfcatch>
	
		<cf_alert message="Invalid Date of Birth.">		
		<cfabort>
	
	</cfcatch>

</cftry>

<cfparam name="Dependent.RecordCount" default="0">

<cfif Dependent.recordCount gte 1> 

	<cf_tl id="A dependent with the same Name and Birth date was already registered" class="Message">	
	<cf_alert message="#lt_text#">	
	
<CFELSE>

<cfoutput>

<cftransaction>
	 
	 <cf_assignid>

     <cfquery name="InsertDependent" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     INSERT INTO PersonDependent
		         (PersonNo,
				 ActionCode,
				 DependentId,
				 DateEffective,
				 DependentPersonNo,
				 Beneficiary,
				 Housing,
				 LastName,
				 FirstName,
				 Gender,
				 Birthdate,
				 Relationship,
				 Remarks,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
	      VALUES ('#Form.PersonNo#',
			      '2000',
		    	  '#rowguid#',
				  #eff#,
				  <cfif form.employeeNo neq "">
				  '#Form.employeeno#',
				  <cfelse>
				  NULL,
				  </cfif>
				  '#Form.Beneficiary#',
				  '#Form.Housing#',
		     	  '#Form.LastName#',
				  '#Form.FirstName#',
				  '#Form.Gender#',
				  #DOB#,
				  '#Form.Relationship#',
				  '#Remarks#',
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')
    </cfquery>
			 
	<cfif operational eq "1" or Parameter.DependentEntitlement eq "1">  
				
		<!---								
		<cfloop index="itm" list="Insurance,RateInsurance,Entitlement,Dependent,Housing">
		--->
		<cfloop index="itm" list="Insurance,RateInsurance,Entitlement,Dependent">

			<cfset tag = left(itm,1)>
			
			<cfloop index="line" from="1" to="3">
			
				<cfparam name="FORM.#tag#" default="0">	
								
				<cfset sel = evaluate("FORM.#tag#")>
				<cfset trg = evaluate("FORM.SalaryTrigger#tag#_#line#")>
			
		  	    <cfif sel eq "1" and trg neq "">	
								
					<cfparam name="Form.EntitlementGroup#tag#_#line#" default="">
					<cfparam name="Form.EntitlementSubsidy#tag#_#line#" default="0">
				
					<cfset efe = evaluate("FORM.DateEffective#tag#_#line#")>
					<cfset exp = evaluate("FORM.DateExpiration#tag#_#line#")>
					<cfset mem = evaluate("FORM.Remarks#tag#_#line#")>
					<cfset grp = evaluate("FORM.EntitlementGroup#tag#_#line#")>
					<cfset sub = evaluate("FORM.EntitlementSubsidy#tag#_#line#")>
										
					<cfif efe neq "">
					 										
						<cfset dateValue = "">
						<CF_DateConvert Value="#efe#">
						<cfset STRM = dateValue>
						
						<cfset dateValue = "">
						<cfif exp neq ''>
						    <CF_DateConvert Value="#exp#">
						    <cfset ENDM = dateValue>
						<cfelse>
						    <cfset ENDM = 'NULL'>
						</cfif>	
						
						<cfquery name="CheckRelationship" 
						    datasource="AppsEmployee" 
						    username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT * 
							FROM   Payroll.dbo.Ref_PayrollTriggerRelationship
							WHERE  SalaryTrigger = '#trg#'
						</cfquery>
						
						<!--- this entitlement is contained by the relationship --->
						 
						<cfif CheckRelationship.recordcount gte "1">
						 
							 <cfquery name="CheckValid" 
							    datasource="AppsEmployee" 
							    username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								SELECT * 
								FROM   Payroll.dbo.Ref_PayrollTriggerRelationship
								WHERE  SalaryTrigger = '#trg#'
								AND    Relationship  =  '#Form.Relationship#'
								AND    Operational   = 1
							</cfquery>
							
							<cfif CheckValid.recordcount eq "0">
							
								<cfquery name="getTrigger" 
								    datasource="AppsEmployee" 
								    username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									SELECT * 
									FROM   Payroll.dbo.Ref_PayrollTrigger
									WHERE  SalaryTrigger = '#trg#'
								</cfquery>
								
								<cfquery name="getRelationship" 
								    datasource="AppsEmployee" 
								    username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									SELECT * 
									FROM   Ref_Relationship
									WHERE  Relationship = '#Form.Relationship#'
								</cfquery>
								
								<cf_alert message="Entitlement (#getTrigger.description#) is not allowed for a dependent under relationship: #getRelationship.Description#.">	
								
								<cfabort>
													
							</cfif>						 
						 
						</cfif>		
						 						 					    
				      <cfquery name="InsertEntitlement" 
					     datasource="AppsEmployee" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
					     INSERT INTO Payroll.dbo.PersonDependentEntitlement 
					         (PersonNo,
							 DependentId,
							 SalaryTrigger,
							 EntitlementGroup,
							 EntitlementSubsidy,
							 DateEffective,
							 DateExpiration,
							 Remarks,
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName)
					      VALUES ('#Form.PersonNo#',
					     	  '#rowguid#',
							  '#trg#',
							  '#grp#',
							  '#sub#', 
							  #STRM#,
							  #ENDM#,
							  '#mem#',
							  '#SESSION.acc#',
					    	  '#SESSION.last#',		  
						  	  '#SESSION.first#')
					  </cfquery>
					  
					 </cfif> 
				  
				  </cfif>
				  
			 </cfloop>	  
			  
		</cfloop>  
			  
	</cfif>	
		 
	 <!--- ----------------------------------- --->
	 <!--- define the mission to be associated --->
	 <!--- ----------------------------------- --->
	 
	 <cfquery name="Mission" 
		 datasource="AppsEmployee"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT   TOP 1 *
			 FROM     PersonContract
			 WHERE    PersonNo    = '#FORM.PersonNo#'
			 AND      ActionStatus != '9'					 
			 ORDER BY DateEffective DESC
	</cfquery>
	
	<cfif Mission.Mission eq "">
		 
		 <cfquery name="Mission" 
		 datasource="AppsEmployee"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT   TOP 1 P.*
			 FROM     PersonAssignment PA, Position P
			 WHERE    PersonNo = '#FORM.PersonNo#'
			 AND      PA.PositionNo = P.PositionNo		
			 AND      PA.AssignmentStatus IN ('0','1')
			 AND      PA.AssignmentClass = 'Regular'
			 AND      PA.AssignmentType  = 'Actual'
			 AND      PA.Incumbency      = '100' 
			 ORDER BY PA.DateExpiration DESC
		</cfquery>
	
	</cfif>	
	
	<!--- status 0 = open in the workflow, maybe be edited if user has access (and also deleted)
	      status 1 = may no longer be edited, need reset to 0 through wf to edit/delete
		  status 2 = no workflow needed, can be edited/deleted freely !	 
    ---> 
	
	</cftransaction> 
	
	<cfset NoAct = "">
		
	<cfif Mission.mission eq "">
	
		<!--- no mission found, hence clear the transaction immediately to status = 2 --->
						
		<cfset st = "2">
			
		<!--- --------------------------------------------- --->
		<!--- track action of the the insert new dependent --->
		<!--- -------------------------------------------- --->
		
		<!--- pending personnel action --->
						
		<cfquery name="PendingContract" 
		 datasource="AppsEmployee"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT   PC.*, ActionDocumentNo
			 FROM     PersonContract PC,  EmployeeAction PA
			 WHERE    PC.PersonNo    = '#FORM.PersonNo#'
			 AND      PC.Contractid  = PA.ActionSourceId 
			 AND      PC.ActionStatus = '0'					 
		</cfquery>
		
		<!--- determine the open action --->
		
		<cfset NoAct = "#PendingContract.ActionDocumentNo#">
			
	<cfelse>
	
		<cfquery name="CheckMission" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT   *
			 FROM     Ref_EntityMission 
			 WHERE    EntityCode     = 'Dependent'  
			 AND      Mission        = '#Mission.Mission#' 
		</cfquery>

		<!--- pending personnel action --->
						
		<cfquery name="PendingContract" 
		 datasource="AppsEmployee"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT   PC.*, ActionDocumentNo
			 FROM     PersonContract PC,  EmployeeAction PA
			 WHERE    PC.PersonNo         = '#FORM.PersonNo#'
			 AND      PC.Contractid       = PA.ActionSourceId 
			 AND      PC.ActionStatus     = '0'			
			 and      PC.HistoricContract = '0'		 
		</cfquery>
		
		<cfquery name="PendingContractAdjustment" 
		 datasource="AppsEmployee"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT   PC.*, ActionDocumentNo
			 FROM     PersonContractAdjustment PC,  EmployeeAction PA
			 WHERE    PC.PersonNo         = '#FORM.PersonNo#'
			 AND      PC.PostAdjustmentId = PA.ActionSourceId 
			 AND      PC.ActionStatus     = '0'						 
		</cfquery>
					
		<cfif PendingContract.recordcount gte "1">
		
			  <cfset st = "0">		
						  
			  <!--- determine the open action --->
			  
			  <cfset NoAct = "#PendingContract.ActionDocumentNo#">
			  
			  <!--- added by hanno on 31/3/2011 --->			  			  

			  <cfset dateValue = "">				
			  <CF_DateConvert Value="#dateformat(PendingContract.DateEffective,CLIENT.DateFormatShow)#">
			  <cfset eff = dateValue>
						  
			  <script>
			  alert("This dependent record is associated to the active appointment workflow.")			  
			  </script>
			  
			  <!--- no workflow --->			  
			  <!--- add source lines to the existing pending action --->		
			  
		<cfelseif PendingContractAdjustment.recordcount gte "1">	  
		
			   <cfset st = "0">		
						  
			  <!--- determine the open action --->
			  
			  <cfset NoAct = "#PendingContractAdjustment.ActionDocumentNo#">
			  
			  <!--- added by hanno on 31/3/2011 --->			  			  

			  <cfset dateValue = "">				
			  <CF_DateConvert Value="#dateformat(PendingContractAdjustment.DateEffective,CLIENT.DateFormatShow)#">
			  <cfset eff = dateValue>
						  
			  <script>
			  alert("This dependent record is associated to the active SPA workflow.")			  
			  </script>	
				
		
		<cfelseif CheckMission.WorkflowEnabled eq "0" and CheckMission.recordcount eq "1">
		        
			  <!--- no workflow, clear the transaction immediately to status = 2 --->
								 
			 <cfset st = "2">
							 
		<cfelse>
		
			 <!--- generate the a workflow, the workflow will put the status = 2 in its methods --->
			 				 		 
		     <cfset st = "0">
			 			 							
			 <cfquery name="Person" 
				 datasource="AppsEmployee" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					SELECT *
					FROM   Person
					WHERE  PersonNo = '#Form.PersonNo#' 
			 </cfquery>
		 
			 <cfset link = "Staffing/Application/Employee/Dependents/DependentEdit.cfm?id=#form.personno#&id1=#rowguid#">
			 
			  <cfquery name="wfclass" 
			 	datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">				
					SELECT  *
					FROM    Ref_Action
					WHERE   ActionCode = '2000' 
		 	  </cfquery>
														
			 <cf_ActionListing 
				    EntityCode       = "Dependent"
					EntityClass      = "#wfclass.EntityClass#"
					EntityGroup      = ""
					EntityStatus     = ""
					Mission          = "#Mission.Mission#"					
					PersonNo         = "#Form.PersonNo#"
					ObjectReference  = "#Form.Relationship#"
					ObjectReference2 = "#Form.FirstName# #Form.LastName#" 
					ObjectFilter     = "2000" 
				    ObjectKey1       = "#Form.PersonNo#"
					ObjectKey4       = "#rowguid#"					
					ObjectURL        = "#link#"
					Show             = "No">
																		
																				
		</cfif>	 
	
	</cfif> 	
	
	<!--- set the record status --->
	
	<cfquery name="Update" 
	   datasource="AppsEmployee" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   	  UPDATE PersonDependent
		  SET    ActionStatus = '#st#'
		  WHERE  PersonNo     = '#FORM.PersonNo#'  
	      AND    DependentId  = '#rowguid#' 	 
	</cfquery>
	
	<cfquery name="Update" 
	   datasource="AppsEmployee" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   	  UPDATE Payroll.dbo.PersonDependentEntitlement
		  SET    Status       = '#st#'
		  WHERE  PersonNo     = '#FORM.PersonNo#'  
	      AND    DependentId  = '#rowguid#' 	 
	</cfquery>
	
	<!--- pending to set the entitlements as well --->
	
	<!--- --------------------------------------------- --->
	<!--- track action of the the insert new dependent --->
	<!--- -------------------------------------------- --->		
					
	<cfinvoke component       = "Service.Process.Employee.PersonnelAction"  
		   method             = "ActionDocument" 
		   ActionDocumentNo   = "#NoAct#"
		   PersonNo           = "#Form.PersonNo#"
		   Mission            = "#Mission.Mission#"
		   ActionDate         = "#DateFormat(eff,CLIENT.DateFormatShow)#"
		   ActionCode         = "2000"
		   ActionSourceId     = "#rowguid#"	
		   ActionLink   	  = "Staffing/Application/Employee/Dependents/DependentEdit.cfm?ID=#form.personNo#&ID1="
		   ActionStatus       = "1">		
			
	<script>		   
	     parent.parent.dependentrefresh('#FORM.PersonNo#','#url.contractid#','#url.action#')			
		 parent.parent.ProsisUI.closeWindow('mydependent',true)	    
	</script>	
		 	 
</cfoutput>	 
	
</cfif>	

