
<!--- input 

list of positions
cutoff date
new unit
parameter : update parent position orgunit

1. loop through selected position and determine if the cutt-off date falls within its effective period (if not we ignore).

1b. We also ignore postion that have an instance that starts after the cutt-off date.
1c. we also ignore position with different missionOperation

2. if so we set the expiration date of the position as the cutto-ff date and copy data to a new position and update

effective date (cutt-off+1), expirations (old expiration date)
orgunit operational = selected unit
copy PositionCategory
copy PositionGroup

(subloop)

3. Then we do the same for the assignment to that position as in step 1 and 2.

3b. Another other assignments for that position starting after the cuttodate you update PositionNo of that assignment

copy AssignmentGroup
copy AssignmentTopic
--->

<!--- parameters ---->
<cfset positions  = FORM.Positions>

<cfparam name="FORM.transferDate"   default="">
<cfparam name="FORM.OrgUnit"        default="">
<cfparam name="FORM.updateParent"   default="">

<cfset dateValue  = "">
<cf_DateConvert 
     Value		  = "#Form.transferDate#">
<cfset seldate 	  = dateValue>

<cfset date =  dateadd('d',-1,seldate)>

<cfset newOrgUnit = FORM.OrgUnit>
<cfset operation  = FORM.updateParent>

<!--- validate unit --->
<cfif newOrgUnit eq "">
	<cf_alert message="Please select an OrgUnit.">
	<cfabort>
</cfif>

<cfif FORM.mandateStatus eq "locked">

	<!--- validate cut off date --->
	<cfquery name= "validateMandate" 
		datasource	 = "AppsOrganization" 
		username	 = "#SESSION.login#" 
		password	 = "#SESSION.dbpw#">
		
			SELECT *
			FROM   Ref_Mandate
			WHERE  Mission 	 = '#FORM.Mission#'
			AND    MandateNo = '#FORM.MandateNo#'
			AND    DateEffective <= #date# AND DateExpiration >= #date#
		
	</cfquery>

	<cfif validateMandate.recordcount eq 0>
		<cf_alert message="The date you entered falls outside the selected staffing period. Operation aborted.">
		<cfabort>
	</cfif>
	
	<cfquery name= "getPositions" 
	datasource	 = "AppsEmployee" 
	username	 = "#SESSION.login#" 
	password	 = "#SESSION.dbpw#">
		SELECT *
		FROM   Position P
		WHERE  PositionNo IN (#positions#)
		AND    DateExpiration > #seldate#
		
		<!--- does not already have a one or more successive position instances 
		that lie after the selection date  --->
		
		AND    NOT EXISTS (
				SELECT 'X'
				FROM   Position P2
				WHERE  P2.PositionParentId = P.PositionParentId
				AND    P2.DateEffective > #seldate#
		)		
		AND  P.Mission = P.MissionOperational <!--- no intermission loans --->
			
	</cfquery>	
	
	<cfif getPositions.recordcount eq 0>
		<cf_alert message="Move may not be completed as one or more selected positions have a instance which covers already the future. Operation aborted.">
		<cfabort>
	</cfif>
	
	<!--- check if assignments are pending cleanrance --->
	
	<cfquery name	 = "validateAssignment" 
		datasource	 = "AppsEmployee" 
		username	 = "#SESSION.login#" 
		password	 = "#SESSION.dbpw#">
			SELECT *
			FROM   PersonAssignment
			WHERE  PositionNo IN (#quotedvalueList(getPositions.PositionNo)#)			
			AND    AssignmentStatus = '0'
			AND    DateEffective < #seldate# AND DateExpiration > #seldate#		
	</cfquery>
	
	<cfif validateAssignment.recordcount gt 0>
		
		<cf_alert message="It was determined that there are assignments pending for approval for the positions selected. Operation aborted.">
		<cfabort>
		
	</cfif>	
	
	<!--- Transaction --->
	<cftransaction>
		
		<cfloop query="getPositions">		
		
		   <cfset newFunctionNo = Evaluate("Form.functionno_#PositionNo#")>
		   <cfset newFunctionDescription = Evaluate("Form.functiondescription_#PositionNo#")>
		
			<cfif operation eq "Transfer"> <!--- Then we need to update the position parent OrgUnit and Functional Title (if changed)--->
				
				<cfquery name = "UpdatePositionParent" 
				 datasource   = "AppsEmployee" 
				 username	  = "#SESSION.login#" 
				 password	  = "#SESSION.dbpw#">				 
				 	UPDATE   PositionParent
				    SET      OrgUnitOperational = '#newOrgUnit#'
					<cfif FunctionNo neq newFunctionNo>
						, FunctionNo          = '#newFunctionNo#'
						, FunctionDescription = '#newFunctionDescription#'
					</cfif>
				    WHERE    PositionParentId   = #PositionParentId#		  
				</cfquery>
				
			</cfif>
		
			<cfinvoke component = "Service.Process.System.Database"  
			   method           = "getTableFields" 
			   datasource	    = "AppsEmployee"	  
			   tableName        = "Position"
			   ignoreFields		= "'PositionNo','OrgUnitOperational','FunctionNo','FunctionDescription','DateEffective','DateExpiration','OfficerUserId','OfficerLastName','OfficerFirstName','Created'"
			   returnvariable   = "fields">	
		
				<!--- Insert new post --->
			   <cfquery name		= "InsertNewPost" 
					 datasource	= "AppsEmployee" 
					 username	= "#SESSION.login#" 
					 password	= "#SESSION.dbpw#">
					 
					 	INSERT INTO Position (
						  		  FunctionNo,
								  FunctionDescription,
								  OrgUnitOperational,
							      DateEffective,
								  DateExpiration,
								  OfficerUserId,
								  OfficerLastName,
								  OfficerFirstName,
								  Created,
								  #fields# )
						  
						SELECT 
							   '#newFunctionNo#',
							   '#newFunctionDescription#',
					           '#newOrgUnit#' AS OrgUnitOperational,
							    #dateadd('d',1,date)#,
								DateExpiration,
						       '#SESSION.Acc#'   AS OfficerUserId,
					      	   '#SESSION.Last#'  AS OfficerLastName,
					      	   '#SESSION.First#' AS OfficerFirstName,
					            getdate() AS Created,
								#fields#
								
					  FROM  Position
					  WHERE PositionNo = '#PositionNo#' 
			  
			</cfquery>		
						
			<!--- get the PositionNo generated for parent --->
			<cfquery name	= "queryNewPost" 
				 datasource	= "AppsEmployee" 
				 username	= "#SESSION.login#" 
				 password	= "#SESSION.dbpw#">
				 	SELECT    TOP 1 PositionNo as newPositionNo
					FROM      Position
					WHERE     Mission          = '#Form.Mission#'
					AND       MandateNo        = '#Form.MandateNo#'
					AND       PositionParentId = '#PositionParentId#'					
					ORDER BY  PositionNo DESC 
			</cfquery>
			
			<cfinvoke component = "Service.Process.Employee.PositionAction"  
				method           = "PositionWorkschedule" 
				PositionNo       = "#queryNewPost.newPositionNo#">	   
	
			<!--- Copy PositionCategory --->
			<cfinvoke component = "Service.Process.System.Database"  
			   method           = "getTableFields" 
			   datasource	    = "AppsEmployee"	  
			   tableName        = "PositionCategory"
			   ignoreFields		= "'PositionNo','OfficerUserId','OfficerLastName','OfficerFirstName','Created'"
			   returnvariable   = "fields">	
				
			<cfquery name	= "CopyCategory" 
				 datasource	= "AppsEmployee" 
				 username	= "#SESSION.login#" 
				 password	= "#SESSION.dbpw#">				 
				 	INSERT INTO PositionCategory (
						    PositionNo,
						    OfficerUserId,
						    OfficerLastName,
						    OfficerFirstName,
						    Created,
						    #fields# )
  					SELECT '#queryNewPost.newPositionNo#',
					       '#SESSION.Acc#'   AS OfficerUserId,
				      	   '#SESSION.Last#'  AS OfficerLastName,
			    	  	   '#SESSION.First#' AS OfficerFirstName,
					        getdate() AS Created,
							#fields#
					FROM  PositionCategory
					WHERE PositionNo = '#PositionNo#' 			  
			</cfquery>
				
			<!--- Copy PositionGroup  --->
			<cfinvoke component = "Service.Process.System.Database"  
			   method           = "getTableFields" 
			   datasource	    = "AppsEmployee"	  
			   tableName        = "PositionGroup"
			   ignoreFields		= "'PositionNo','OfficerUserId','OfficerLastName','OfficerFirstName','Created'"
			   returnvariable   = "fields">	
				
			<cfquery name		= "CopyCategory" 
					 datasource	= "AppsEmployee" 
					 username	= "#SESSION.login#" 
					 password	= "#SESSION.dbpw#">					 
					 	INSERT INTO PositionGroup (						  
								  PositionNo,
								  OfficerUserId,
								  OfficerLastName,
								  OfficerFirstName,
								  Created,
								  #fields#)						  
						SELECT  '#queryNewPost.newPositionNo#',
						        '#SESSION.Acc#'   AS OfficerUserId,
					      	    '#SESSION.Last#'  AS OfficerLastName,
					      	    '#SESSION.First#' AS OfficerFirstName,
					             getdate() AS Created,
							 	#fields#								
					  FROM      PositionGroup
					  WHERE     PositionNo = '#PositionNo#' 
			  
			</cfquery>
				
			<!--- Update expiration date  of the old post--->
			<cfquery name="UpdateOldPost" 
				 datasource="AppsEmployee" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">				 
				 	UPDATE Position
				    SET    DateExpiration = #date#
				    WHERE  PositionNo = '#PositionNo#' 		  
			</cfquery>
			
			<!---- Now get valid current assignments for the positions we are splitting --->
			<cfquery name="getAssignment" 
				 datasource="AppsEmployee" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 	SELECT *
					FROM   PersonAssignment
					WHERE  PositionNo       = '#PositionNo#'
					AND    AssignmentStatus = '1'
					AND    DateEffective < #date# AND DateExpiration > #date#					
			</cfquery>
				
			<cfloop query="getAssignment">	
	
				<!--- Generate personnel action --->
				<cfinclude template="../../../Assignment/ActionNo.cfm">
	
				<cfinvoke component = "Service.Process.System.Database"  
				   method           = "getTableFields" 
				   datasource	    = "AppsEmployee"	  
				   tableName        = "PersonAssignment"
				   ignoreFields		= "'AssignmentNo','DateExpiration','Created','ActionReference','ContractId'"
				   returnvariable   = "fields">	
				
				<!--- Insert new Assignment (left portion) under new position. Left portion attributes remain the same except for DateExpirtion --->
				
				<cfquery name	= "InsertNewAssignment" 
					 datasource	= "AppsEmployee" 
					 username	= "#SESSION.login#" 
					 password	= "#SESSION.dbpw#"
					 result		= "leftAssignment">
					 
					   INSERT INTO PersonAssignment 
					         ( DateExpiration,		
							   ActionReference,
							   #fields# )
						  
					   SELECT  #date#,
					   		   '#NoAct#',
							   #fields#
								
					   FROM   PersonAssignment
					   WHERE  PositionNo   = '#PositionNo#' 
					   AND    PersonNo     = '#getAssignment.PersonNo#'
					   AND    AssignmentNo = '#getAssignment.AssignmentNo#'
					  
					</cfquery>
					
					<!--- get the AssignmentNo recently generated --->	
					<cfset leftAssignmentNo = leftAssignment.generatedKey>
			
				<!--- Insert new Assignment (right portion) under new position. --->
				<cfinvoke component = "Service.Process.System.Database"  
				   method           = "getTableFields" 
				   datasource	    = "AppsEmployee"	  
				   tableName        = "PersonAssignment"
				   ignoreFields		= "'AssignmentNo','PositionNo','FunctionNo','FunctionDescription','DateEffective','DateExpiration','OrgUnit','ActionReference','ContractId','OfficerUserId','OfficerLastName','OfficerFirstName','Created'"
				   returnvariable   = "fields">	
				
				<cfquery name	= "InsertNewAssignment" 
					 datasource	= "AppsEmployee" 
					 username	= "#SESSION.login#" 
					 password	= "#SESSION.dbpw#" 
					 result		= "rightAssignment">
										 
					   INSERT INTO PersonAssignment 
					         ( PositionNo,
							   FunctionNo,
							   FunctionDescription,
							   DateEffective,
							   DateExpiration,
							   OrgUnit,      <!--- added by hanno --->
							   ActionReference,
							   OfficerUserId,
							   OfficerLastName,
							   OfficerFirstName,							 
							   #fields# )
						  
					  SELECT  '#queryNewPost.newPositionNo#',
					    	  '#newFunctionNo#',
							  '#newFunctionDescription#',
							  #dateadd('d',1,date)#,
							  DateExpiration,
							  '#newOrgUnit#',  <!--- added by hanno --->
							  '#NoAct#',
						      '#SESSION.Acc#'   AS OfficerUserId,
					      	  '#SESSION.Last#'  AS OfficerLastName,
					      	  '#SESSION.First#' AS OfficerFirstName,					            
							  #fields#
								
					  FROM   PersonAssignment
					  WHERE  PositionNo   = '#PositionNo#' 
					  AND    PersonNo     = '#getAssignment.PersonNo#'
					  AND    AssignmentNo = '#getAssignment.AssignmentNo#'
					  
					</cfquery>
				
					<!--- get the AssignmentNo recently generated --->
					<cfset rightAssignmentNo = rightAssignment.generatedKey>		
			
					<!--- Copy underlying tables for both assignments created --->
					<cfloop index="i" from="1" to="2" step="1">
				
							<cfif i eq 1 >
								<cfset targetAssignmentNo = leftAssignmentNo>
								<cfset postNo = PositionNo>
							<cfelse>
								<cfset targetAssignmentNo = rightAssignmentNo>
								<cfset postNo = queryNewPost.newPositionNo>
							</cfif>
					
							<!--- copy PersonAssignmentGroup --->
				
							<cfinvoke component = "Service.Process.System.Database"  
							   method           = "getTableFields" 
							   datasource	    = "AppsEmployee"	  
							   tableName        = "PersonAssignmentGroup"
							   ignoreFields		= "'AssignmentNo','PositionNo','OfficerUserId','OfficerLastName','OfficerFirstName','Created'"
							   returnvariable   = "fields">	
				
							<cfquery name		= "CopyAssignmentGroup" 
								 datasource		= "AppsEmployee" 
								 username		= "#SESSION.login#" 
								 password 		= "#SESSION.dbpw#">
								 
								 	INSERT INTO PersonAssignmentGroup (
									  AssignmentNo,
									  PositionNo,
									  OfficerUserId,
									  OfficerLastName,
									  OfficerFirstName,
									  Created,
									  #fields# )
									  
									SELECT '#targetAssignmentNo#',
									       '#postNo#',
									       '#SESSION.Acc#'   AS OfficerUserId,
								      	   '#SESSION.Last#'  AS OfficerLastName,
								      	   '#SESSION.First#' AS OfficerFirstName,
								            getdate() AS Created,
											#fields#
											
								  FROM  PersonAssignmentGroup
								  WHERE PositionNo   = '#PositionNo#' 
								  AND   PersonNo     = '#getAssignment.PersonNo#'
								  AND   AssignmentNo = '#getAssignment.AssignmentNo#'
								  
								</cfquery>
						
							<!--- copy PersonAssignmentTopic --->
							
							<cfinvoke component = "Service.Process.System.Database"  
							   method           = "getTableFields" 
							   datasource	    = "AppsEmployee"	  
							   tableName        = "PersonAssignmentTopic"
							   ignoreFields		= "'AssignmentNo','PositionNo','OfficerUserId','OfficerLastName','OfficerFirstName','Created'"
							   returnvariable   = "fields">	
				
							<cfquery name		= "CopyAssignmentTopic" 
								 datasource		= "AppsEmployee" 
								 username		= "#SESSION.login#" 
								 password 		= "#SESSION.dbpw#">					 
								 	INSERT INTO PersonAssignmentTopic (
											  AssignmentNo,
											  PositionNo,
											  OfficerUserId,
											  OfficerLastName,
											  OfficerFirstName,
											  Created,
											  #fields# )		
											  				  
									SELECT '#targetAssignmentNo#',
									       '#postNo#',
									       '#SESSION.Acc#'   AS OfficerUserId,
								      	   '#SESSION.Last#'  AS OfficerLastName,
								      	   '#SESSION.First#' AS OfficerFirstName,
								            getdate() AS Created,
											#fields#
											
								  FROM  PersonAssignmentTopic
								  WHERE PositionNo   = '#PositionNo#' 
								  AND   PersonNo     = '#getAssignment.PersonNo#'
								  AND   AssignmentNo = '#getAssignment.AssignmentNo#'
								  
								</cfquery>
					
					</cfloop>
						
					<!--- Deactivate source assignment --->	
					<cfquery name="DeleteAssignment" 
					 datasource="AppsEmployee" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
				    	 UPDATE PersonAssignment
						 SET    AssignmentStatus = '9',
						        ContractId = NULL  <!--- hanno we no longer want the contract workflow to be able to control these records onwards ---> 
					   	 WHERE  AssignmentNo = '#getAssignment.AssignmentNo#' 
					</cfquery>
						
					<cfset link = "Staffing/Application/Authorization/Staffing/TransactionViewDetail.cfm?ActionReference=#NoAct#">
					
					<cfquery name="Parameter" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT * 
					    FROM   Ref_ParameterMission
						WHERE  Mission = '#getPositions.MissionOperational#'  <!--- was the owning mission changed 1/11/2013 --->
					</cfquery>
					
					<cfif Parameter.AssignmentClear gte "1">
						<!--- requires clearance, so set to 0 --->
						<cfset clr = "0">
					<cfelse>	
					    <!--- does not requires clearance, so set to 1 immediately ---> 
					    <cfset clr = "1">
					</cfif>	
					
					<!--- Hanno 4/3/2018 : since this is a position action, we clear the assignment immediately --->
					
					<cfset clr = "1">
					
					<!--- Action type--->
					<cfset Action = "0008">
						   
				    <cfquery name="LogAction" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					     INSERT INTO EmployeeAction
						        (ActionDocumentNo,
								 ActionCode,
								 ActionPersonNo,
								 ActionSource,
								 ActionSourceNo,
								 ActionDescription,
								 Mission,
								 MandateNo,
								 Posttype,
								 ActionStatus,
								 OfficerUserId,
								 OfficerLastName,
								 OfficerFirstName,
								 ActionDate)
					      VALUES 
							    (#NoAct#,
								 '#Action#',
								 '#getAssignment.PersonNo#',
								 'Assignment',
								 '#rightAssignmentNo#',  <!--- main record which has the wf --->
								 '',
								 '#getPositions.MissionOperational#',
								 '#getPositions.MandateNo#', 
								 '#getPositions.PostType#',
								 '#clr#',
								 '#SESSION.acc#',
						    	 '#SESSION.last#',		  
							  	 '#SESSION.first#',
								 getdate())
					 </cfquery>
										
					<cfquery name="InsertDetails" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					      INSERT INTO EmployeeActionSource
						        (ActionDocumentNo, 
								 PersonNo,
								 ActionSource,
								 ActionSourceNo,
								 ActionStatus,
								 ActionLink)
					       SELECT #NoAct# AS ActionReference, 
						          PersonNo, 
								  'Assignment', 
								  AssignmentNo, 
								  AssignmentStatus,
								  '#link#'
						  FROM  PersonAssignment
					      WHERE ActionReference = #NoAct# OR  AssignmentNo = '#getAssignment.AssignmentNo#' 
				    </cfquery>

			</cfloop>
				
			<!---- Possible future assignments starting after cut-off date that already existed
			   , need be be update with the new PositionNo, which is unlikely to happen --->
			
			<cfquery name	= "updateAssignment" 
				 datasource	= "AppsEmployee" 
				 username	= "#SESSION.login#" 
				 password	= "#SESSION.dbpw#">
				 	UPDATE PersonAssignment
					SET    PositionNo          = '#queryNewPost.newPositionNo#',
						   OrgUnit	           = '#newOrgUnit#',
						   FunctionNo          = '#newFunctionNo#',
						   FunctionDescription = '#newFunctionDescription#'
					WHERE  PositionNo          = '#PositionNo#'
					AND    AssignmentStatus != '9'
					AND    DateEffective       > #date# 		
					
			</cfquery>			
		
		</cfloop>
	
	</cftransaction>

<cfelseif FORM.MandateStatus eq "draft">

	<cftransaction>

		<cfloop index="parent" list="#positions#" delimiters=",">
		
		 <cfquery name	= "UpdateParent" 
			 datasource	= "AppsEmployee" 
			 username	= "#SESSION.login#" 
			 password	= "#SESSION.dbpw#">
			 
			 	UPDATE  PositionParent
				SET     OrgUnitOperational = '#newOrgUnit#'
				WHERE   PositionParentId   = '#parent#'  
				
			 </cfquery>
			 
		 <cfquery name	= "UpdatePosition" 
			 datasource	= "AppsEmployee" 
			 username	= "#SESSION.login#" 
			 password	= "#SESSION.dbpw#">
			 
			 	UPDATE  Position
				SET     OrgUnitOperational = '#newOrgUnit#'
				WHERE   PositionParentId   = '#parent#' 
				
			</cfquery>
			 
		 <cfquery name	= "UpdateAssignment" 
			 datasource	= "AppsEmployee" 
			 username	= "#SESSION.login#" 
			 password	= "#SESSION.dbpw#">
			 
			 	UPDATE PersonAssignment
				SET    OrgUnit = '#newOrgUnit#'
				WHERE  PositionNo IN (SELECT PositionNo 
				                      FROM   Position 
									  WHERE  PositionParentId  = '#parent#')									  
			 </cfquery>
	
		 </cfloop>
	 
	 </cftransaction>
	 
</cfif>

<script>

	history.go();
	try { ProsisUI.closeWindow('mybox'); } catch(e) {}	
		
</script>