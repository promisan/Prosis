
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
<cf_systemscript>

<cfif ParameterExists(Form.Delete)> 

    <!--- no validation needed --->

<cfelse>

	<cfinclude template="DependentEntitlementValidation.cfm">
	
</cfif>	

<cf_verifyOperational 
     module    = "Payroll" 
	 Warning   = "No">
		
<cfquery name="Parameter" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
	    FROM     Parameter	
</cfquery>
			 			 
<cfif ParameterExists(Form.Delete)> 

		<!--- ----------------------------- --->	
		<!--- Check if there is a PA log -- --->
		<!--- ----------------------------- --->
				
		<cfquery name="Check" 
		   datasource="AppsEmployee" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
	    	  SELECT * 
			  FROM   PersonDependent 		    
		      WHERE  PersonNo     = '#PersonNo#' 
			  AND    DependentId  = '#Form.DependentId#'  
		</cfquery>		
		
		<cf_dependentEditSubmitRevert dependentid="#Form.DependentId#" qAction="Purge">
						 
		 <!--- track a removal action for PA function if record is cleared already --->
			
		 <cfif check.actionStatus eq "2">	 	
		 		 
			 <cfinvoke component   = "Service.Process.Employee.PersonnelAction"  
					   method           = "ActionDocument" 
					   PersonNo         = "#Form.PersonNo#"
					   ActionCode       = "2003"				  
					   ActionSourceId   = "#FORM.DependentId#"	
					   ActionLink   	= "Staffing/Application/Employee/Dependents/DependentEdit.cfm?ID=#form.personNo#&ID1="
					   ActionStatus     = "1">	
					   
		 <cfelse>
		 		 
			 <cfquery name="delete" 
			   datasource="AppsEmployee" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
		    	  DELETE 
				  FROM   Payroll.dbo.PersonDependentEntitlement 		    
			      WHERE  PersonNo     = '#PersonNo#' 
				  AND    DependentId  = '#Form.DependentId#'  
			</cfquery>		
			
			<cfquery name="delete" 
			   datasource="AppsEmployee" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
		    	  DELETE 
				  FROM   PersonDependent 		    
			      WHERE  PersonNo     = '#PersonNo#' 
				  AND    DependentId  = '#Form.DependentId#'  
			</cfquery>			 			   
					   
		 </cfif>				   	
					
	<cfoutput>
			
	<cfif url.action eq "person">	
				
		<script>					
			ptoken.location("EmployeeDependent.cfm?action=person&id=#Form.PersonNo#","parent.window");
		</script>
	
	<cfelse>
	
		<script language = "JavaScript">				
			parent.parent.parent.right.dependentrefresh('#FORM.PersonNo#','#Form.Contractid#','#url.action#')		
			parent.parent.ColdFusion.Window.destroy('mydependent',true)	
		</script>	
		
	</cfif>	
	
	</cfoutput>
	
<cfelseif ParameterExists(Form.Submit)> 

	<cfparam name="FORM.ActionCode"        default="2001">
	<cfparam name="FORM.DateEffective"     default="">
		
	<cfquery name="Check" 
		   datasource="AppsEmployee" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
	    	  SELECT * 
			  FROM   PersonDependent 		    
		      WHERE  PersonNo     = '#PersonNo#'
			  AND    DependentId  = '#Form.DependentId#'  
		</cfquery>	
	
	<cfif Len(Form.Remarks) gt 400>
	  <cfset remarks = left(Form.Remarks,400)>
	<cfelse>
	  <cfset remarks = Form.Remarks>
	</cfif>  
	
	<cfset dateValue = "">
	<cfif Form.BirthDate neq ''>
	    <CF_DateConvert Value="#Form.BirthDate#">
	    <cfset DOB = dateValue>
	<cfelse>
	    <cfset DOB = 'NULL'>
	</cfif>	
	
	<cfset dateValue = "">
	<cfif Form.DateEffective neq ''>
	    <CF_DateConvert Value="#Form.DateEffective#">
	    <cfset eff = dateValue>
	<cfelse>
	    <cfset eff = 'NULL'>
	</cfif>	
				
	<cfquery name="Current" 
	  datasource="AppsEmployee" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT  * 
	    FROM  PersonDependent	     	
		WHERE PersonNo    = '#FORM.PersonNo#' 
		  AND DependentId = '#FORM.DependentId#' 	 
	</cfquery>
	
	<!--- -------------------------------------------------------- --->
	<!--- determine of a substantive change is made to the records --->
	<!--- -------------------------------------------------------- --->
	
	<cfset change = "0">
				
	<cfif Current.actionStatus eq "0" or Current.actionStatus eq "1">
	
			<!--- fully clear entitlements --->			
			<cfset rowguid = FORM.DependentId>		
					
			<cfquery name="UpdateDependent" 
			  datasource="AppsEmployee" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  UPDATE  PersonDependent
			     SET  ActionCode          = '#Form.ActionCode#',
					  <cfif Form.DependentPersonNo neq "">
			  		  DependentPersonNo   = '#Form.DependentPersonNo#', 
					  <cfelse>
					  DependentPersonNo   = NULL, 
					  </cfif>				     
					  LastName            = '#Form.LastName#',
					  FirstName           = '#Form.FirstName#',
					  Gender              = '#Form.Gender#',
					  Birthdate           = #DOB#,
					  Beneficiary         = '#Form.Beneficiary#',
					  Housing             = '#Form.Housing#',
					  DateEffective       = #eff#,
					  Relationship        = '#Form.Relationship#',
					  Operational         = '#Form.Operational#',
					  Remarks             = '#Remarks#'		
				WHERE PersonNo            = '#FORM.PersonNo#' 
				  AND DependentId         = '#FORM.DependentId#' 	 
			</cfquery>	
			
			<cfif form.DateEffective neq "" 
			      AND form.DateEffective neq dateformat(current.dateeffective,CLIENT.DateFormatShow)>
		
			    <!--- effective date was changed, 
				  also change the EmployeeAction table --->
				
				<cfquery name="UpdateDependent" 
				  datasource="AppsEmployee" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  	  UPDATE  EmployeeAction
					  SET     ActionDate      = #eff#, 
					          ActionCode      = '#Form.ActionCode#'				 
					  WHERE   ActionSourceId  = '#FORM.DependentId#' 	 
				</cfquery>	
					
		    </cfif>
			
			<cfif operational eq "1" or Parameter.DependentEntitlement eq "1">
									
				<cfinclude template="DependentEditEntitlementCheck.cfm">	
			
				<cfif change eq "2">
				
					<cfquery name="UpdateDependent" 
					  datasource="AppsPayroll" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
						  DELETE FROM Payroll.dbo.PersonDependentEntitlement
						  WHERE  PersonNo     = '#FORM.PersonNo#' 
						  AND    DependentId  = '#FORM.DependentId#' 	 
					</cfquery>		
				
					<!--- fully clear entitlements --->																										
					<cfinclude template="DependentEditEntitlementSubmit.cfm">			
					<cfset change = "0">
					
				<cfelse>
				
				 <cfquery name="ArchiveOld" 
		          datasource="AppsEmployee" 
		          username="#SESSION.login#" 
		          password="#SESSION.dbpw#">
			     	  UPDATE Payroll.dbo.PersonDependentEntitlement 
					  SET    Remarks = '#Remarks#'
					  WHERE  PersonNo      = '#FORM.PersonNo#' 
			            AND  DependentId   = '#FORM.DependentId#' 			   
			      </cfquery>						
					
				</cfif>	
			
			</cfif>		
			
	<cfelse>	
			
		<cftransaction>
		
		<cf_assignId>	
		
		<cfset change = "0">
				
		<!--- define value for change = 2 --->		
		
		<cfinclude template="DependentEditEntitlementCheck.cfm">		
		
							    		
		<cfif form.lastName       neq check.lastName  or 
		      form.firstName      neq check.firstname or 
			  form.housing        neq check.housing   or 
			  form.operational    neq check.operational   or 
			  form.DependentPersonNo    neq check.DependentPersonNo   or
			  change eq "2">			 
								
				<cfif change eq "0">
				
					<cfset change = 1>
					
				</cfif>								
							
			<!--- if you cancel a last dependent make sure the
			workflow is closed as well otherwise it will still show --->
			
			<cf_wfActive entitycode="Dependent" 
				objectkeyvalue4="#FORM.DependentId#" 
				datasource="AppsEmployee">	
	
				<cfif wfstatus eq "open">
				
					<cfquery name="ArchiveFlow" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							UPDATE Organization.dbo.OrganizationObjectAction
							SET    ActionStatus     = '2',
							       ActionMemo       = 'Closed by agent due to dependent amendment action causing a cancellation',
							       OfficerUserId    = 'administrator',
								   OfficerLastName  = 'Agent',
								   OfficerFirstName = 'System',									   
								   OfficerDate      = getDate()					   		
							WHERE  ObjectId IN (SELECT ObjectId 
							                    FROM   Organization.dbo.OrganizationObject 
												WHERE  ObjectKeyValue4 = '#FORM.DependentId#')
							AND    ActionStatus = '0'			
					</cfquery>	
				
				</cfif>
				
				<cftransaction>
				
				<!--- terminate existing record --->
				
				<cfquery name="UpdateDependent" 
				  datasource="AppsEmployee" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  UPDATE  PersonDependent 
				  SET     ActionStatus = '9'		
				  WHERE   PersonNo     = '#FORM.PersonNo#' 
				  AND     DependentId  = '#FORM.DependentId#' 	 				  
				</cfquery>
					
				<cfquery name="InsertDependent" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 
				  INSERT INTO PersonDependent
				  
					       (PersonNo,
							 DependentId,
							 DateEffective,
							 ActionCode,
							 GroupCode,
							 GroupListCode,
							 DependentPersonNo,
							 Beneficiary,
							 Housing,
							 LastName,
							 FirstName,
							 Gender,
							 Birthdate,
							 Relationship,
							 Remarks,
							 Source,
							 SourceId,
							 Operational,
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName)
							 
				      VALUES ('#Form.PersonNo#',
					    	  '#rowguid#',
							  #eff#,
							  '#form.ActionCode#',
							   <cfif form.groupCode neq "">
								 '#Form.GroupCode#',
								 '#Form.GroupListCode#',
							  <cfelse>
								 NULL,
								 NULL,
							  </cfif>							 
							  <cfif form.DependentPersonNo neq "">
							  '#Form.DependentPersonNo#',
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
							  'MANUAL',
							  '#Form.DependentId#',
							  '#Form.Operational#',
							  '#SESSION.acc#',
					    	  '#SESSION.last#',		  
						  	  '#SESSION.first#' )
							  
			    </cfquery>
				
				<!--- cancel record and create new for new dependent --->		
				
				<cfinclude template="DependentEditEntitlementSubmit.cfm">			
				
				
				</cftransaction>
							
				<!--- --------------------------------------- --->
			    <!--- -substantive change, record the action- --->
				<!--- --------------------------------------- 
				
				<cfif change eq "1">				
					<cfset actioncode = "2001">				
				<cfelse>				
					<cfset actioncode = "2002">						
				</cfif>		
				
				--->
				
				<!--- -------------------------------------- --->
				<!--- pending personnel action for contracts --->
				<!--- -------------------------------------- --->
						
				<cfquery name="PendingContract" 
				 datasource="AppsEmployee"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					 SELECT   PC.*, ActionDocumentNo
					 FROM     PersonContract PC,  EmployeeAction PA
					 WHERE    PC.PersonNo          = '#Form.PersonNo#'
					 AND      PC.Contractid        = PA.ActionSourceId 
					 AND      PC.ActionStatus      = '0'		
					 AND      PC.HistoricContract  = '0'					 
				</cfquery>	
				
				<cfquery name="PendingSPA" 
				 datasource="AppsEmployee"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					 SELECT   SPA.*, ActionDocumentNo
					 FROM     PersonContractAdjustment SPA,  EmployeeAction PA
					 WHERE    SPA.PersonNo         = '#FORM.PersonNo#'
					 AND      SPA.PostAdjustmentId = PA.ActionSourceId 
					 AND      SPA.ActionStatus     = '0'						 
				</cfquery>
				
				<cfif PendingContract.recordcount gte "1">	
																					
					<cfinvoke component    = "Service.Process.Employee.PersonnelAction"  
						  method           = "ActionDocument" 
						  ActionDocumentNo = "#PendingContract.ActionDocumentNo#"
						  PersonNo         = "#Form.PersonNo#"
						  ActionDate       = "#dateformat(PendingContract.DateEffective,CLIENT.DateFormatShow)#"
						  ActionCode       = "#form.actioncode#"
						  ActionSourceId   = "#rowguid#"	
						  ActionLink       = "Staffing/Application/Employee/Dependents/DependentEdit.cfm?ID=#form.personNo#&ID1="					  
						  ActionStatus     = "1"
						  ripple9          = "#FORM.DependentId#">		
						  
				<cfelseif PendingSPA.recordcount gte "1">	
																									
					<cfinvoke component    = "Service.Process.Employee.PersonnelAction"  
						  method           = "ActionDocument" 
						  ActionDocumentNo = "#PendingSPA.ActionDocumentNo#"
						  PersonNo         = "#Form.PersonNo#"
						  ActionDate       = "#dateformat(PendingContract.DateEffective,CLIENT.DateFormatShow)#"
						  ActionCode       = "#form.actioncode#"
						  ActionSourceId   = "#rowguid#"	
						  ActionLink       = "Staffing/Application/Employee/Dependents/DependentEdit.cfm?ID=#form.personNo#&ID1="					  
						  ActionStatus     = "1"
						  ripple9          = "#FORM.DependentId#">				  
					  
				<cfelse>
								
						<cfinvoke component  = "Service.Process.Employee.PersonnelAction"  
						  method             = "ActionDocument" 
						  ActionDocumentNo   = ""   <!--- will be assigned --->
						  PersonNo           = "#Form.PersonNo#"
						  ActionDate         = "#Form.DateEffective#"
						  ActionCode         = "#form.actioncode#"
						  ActionSourceId     = "#rowguid#"	
						  ActionLink         = "Staffing/Application/Employee/Dependents/DependentEdit.cfm?ID=#form.personNo#&ID1="					  
						  ActionStatus       = "1"
						  ripple9            = "#FORM.DependentId#">		
				
				</cfif>	  										
						
		<cfelse>
		
		    <!--- ------------------------------------------------------- --->
		    <!--- no substantive changes detected, just update the record --->
			<!--- ------------------------------------------------------- --->
			
			<cfset change = "0">
			
			<cfparam name="form.actioncode" default="">
			
			<cfquery name="UpdateDependent" 
			  datasource="AppsEmployee" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  
			  UPDATE  PersonDependent
			     SET  LastName            = '#Form.LastName#',
					  FirstName           = '#Form.FirstName#',
					   <cfif Form.DependentPersonNo neq "">
			  		  DependentPersonNo   = '#Form.DependentPersonNo#', 
					  <cfelse>
					  DependentPersonNo   = NULL, 
					  </cfif>	
					  Gender              = '#Form.Gender#',
					  Birthdate           = #DOB#,
					  Relationship        = '#Form.Relationship#',
					  <cfif form.actioncode neq "">
						  ActionCode          = '#Form.ActionCode#',
						  <cfif form.groupCode neq "">
							  GroupCode      = '#Form.GroupCode#',
							  GroupListCode  = '#Form.GroupListCode#',
						  <cfelse>
							  GroupCode      = NULL,
							  GroupListCode  = NULL,
						  </cfif>
					  </cfif>
					  Operational         = '#Form.Operational#',
					  Remarks             = '#Remarks#'		
				WHERE PersonNo            = '#FORM.PersonNo#' 
				  AND DependentId         = '#FORM.DependentId#' 	 
			</cfquery>		
			
						
			<cfset id = FORM.DependentId>
			
		</cfif>	
		
		</cftransaction>	   
		
	</cfif>	
				
	
	<!--- status 0 = open in the workflow, maybe be edited if user has access (and also deleted)
	      status 1 = may no longer be edited, need reset to 0 through wf to edit/delete
		  status 2 = no workflow needed, can be edited/deleted freely, should be the final stage of wf as well	 
    ---> 
						
	<cfif change neq "0">
		
		 <!--- ---------------------------- --->
		 <!--- workflow or direct recording --->
		 <!--- ---------------------------- --->
		 
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
					
		<cfif Mission.Mission eq "">
			
				<!--- no mission, clear the transaction immediately to status = 2 and no workflow --->
										
				<cfquery name="UpdateDependent" 
				  datasource="AppsEmployee" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  UPDATE  PersonDependent
				     SET  ActionStatus = '2'
					WHERE PersonNo     = '#FORM.PersonNo#' 
					  AND DependentId  = '#rowguid#' 	 
				</cfquery>		
						
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
					 SELECT  PC.*, ActionDocumentNo
					 FROM    PersonContract PC INNER JOIN EmployeeAction PA ON PC.Contractid = PA.ActionSourceId 
					 WHERE   PC.PersonNo           = '#FORM.PersonNo#'					
					 AND     PC.ActionStatus       = '0'		
					 AND     PC.HistoricContract   = '0'			 
					 ORDER BY DateEffective DESC
				</cfquery>
				
				<cfquery name="PendingSPA" 
				 datasource="AppsEmployee"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					 SELECT   SPA.*, ActionDocumentNo
					 FROM     PersonContractAdjustment SPA INNER JOIN EmployeeAction PA ON SPA.PostAdjustmentId = PA.ActionSourceId
					 WHERE    SPA.PersonNo         = '#FORM.PersonNo#'					 
					 AND      SPA.ActionStatus     = '0'	
					 ORDER BY DateEffective DESC					 
				</cfquery>
				
				<cfif PendingContract.recordcount gte "1" or PendingSPA.recordcount gte "1">
								
					    <!--- there is a pending contract or spa which will be used 
						for the association of the dependent record  --->
										
						<cfquery name="UpdateDependent" 
						  datasource="AppsEmployee" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
						  UPDATE  PersonDependent
						  SET     ActionStatus = '1' <!--- this will allow payroll to run against the old data --->
						  WHERE   PersonNo     = '#FORM.PersonNo#' 
						  AND     DependentId  = '#rowguid#' 	 
						</cfquery>							
								
				<cfelseif CheckMission.WorkflowEnabled eq "0" and CheckMission.recordcount eq "1">
				       						
						<!-- no workflow enabled for this mission and object, 
						clear the transaction immediately to status = 2
						annotation : this mode will be less and less important --->
										
						<cfquery name="UpdateDependent" 
						  datasource="AppsEmployee" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
						  UPDATE  PersonDependent
						  SET     ActionStatus = '2'
						  WHERE   PersonNo     = '#FORM.PersonNo#' 
						  AND     DependentId  = '#rowguid#' 	 
						</cfquery>								
						
				<cfelse>
				
				     <!--- --------------------------- --->
					 <!--- create a dependent workflow --->
					 <!--- --------------------------- --->
					 		 
				     <cfset st = "0">
						
					 <cfquery name="Person" 
						 datasource="AppsEmployee" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
							SELECT *
							FROM   Person
							WHERE  PersonNo = '#Form.PersonNo#' 
					 </cfquery>
					 
					  <cfquery name="wfclass" 
					 	datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">				
							SELECT *
							FROM   Ref_Action
							WHERE  ActionCode = '2002' 
				 	  </cfquery>
				 
					 <cfset link = "Staffing/Application/Employee/Dependents/DependentEdit.cfm?id=#form.personno#&id1=#rowguid#">
						
					 <cf_ActionListing 
						 EntityCode       = "Dependent"
						 EntityClass      = "#wfclass.EntityClass#"
						 EntityGroup      = ""
						 EntityStatus     = ""
						 Mission          = "#Mission.Mission#"							
						 PersonNo         = "#Form.PersonNo#"
						 ObjectReference  = "#Form.Relationship#"
						 ObjectReference2 = "#Form.FirstName# #Form.LastName#" 
						 ObjectFilter     = "2002" 
						 ObjectKey1       = "#Form.PersonNo#"
						 ObjectKey4       = "#rowguid#"					
						 ObjectURL        = "#link#"
						 Show             = "No">
							
				</cfif>	 
			
			</cfif> 			
			
	</cfif>	
				
	<cfoutput>
				
	<cfif url.action eq "person">
		
		<script>						    
		    ptoken.location("EmployeeDependent.cfm?action=person&id=#Form.PersonNo#&id1=#rowguid#","parent.window")
		</script>
		
	<cfelseif url.action eq "entitlement">	
	
	   <script>
	      history.go(-1)
	   </script>
	
	<cfelse>
	
		<script>				
			parent.parent.parent.right.dependentrefresh('#FORM.PersonNo#','#Form.Contractid#','#url.action#')		
			parent.parent.ProsisUI.closeWindow('mydependent',true)	
		</script>	
		
	</cfif>	
	
	</cfoutput>
	
</cfif>		
