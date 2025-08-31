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
<cfparam name="attributes.ActionDocumentNo" default="0">
<cfparam name="attributes.Action"           default="">
<cfparam name="attributes.Clean"            default="No">

<cfset documentNo = attributes.ActionDocumentNo>

 <cfquery name="Check" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT *
	 FROM   EmployeeAction
	 WHERE  ActionDocumentNo = '#documentNo#' 	
</cfquery>

<!--- ------------------------------------------------------------ --->
<!--- 20/7/2010 to make very sure the action is not a batch action --->
<!--- ------------------------------------------------------------ --->

<cfif Check.ActionPersonNo neq "">

	<cfif attributes.action eq "Confirm">
	
		<cftransaction action="BEGIN">
	
		 <cfquery name="Update0" 
		 datasource="AppsEmployee" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 UPDATE PersonAssignment 
		 SET    AssignmentStatus = '1'
		 WHERE  AssignmentNo IN (SELECT ActionSourceNo 
		                         FROM   EmployeeActionSource 
								 WHERE  ActionDocumentNo = '#documentNo#'
								 AND    ActionSource = 'Assignment')
		   AND  AssignmentStatus = '0'
		 </cfquery>
		 
		<!--- set status in action table --->
		 
		<cfquery name="UpdateStatusAction" 
		 datasource="AppsEmployee" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 UPDATE EmployeeAction
			 SET    ActionStatus = '1'
			 WHERE  ActionDocumentNo = '#documentNo#' 
		 </cfquery>
		 
		</cftransaction> 
	
	<cfelseif attributes.action eq "Revert">
	
		<cftransaction action="BEGIN">
		
		<cfquery name="Update0" 
			 datasource="AppsEmployee" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			   UPDATE PersonAssignment 
			   SET    AssignmentStatus = '8'
			   WHERE  AssignmentNo IN (SELECT convert(integer,ActionSourceNo) 
			                         FROM   EmployeeActionSource 
									 WHERE  ActionDocumentNo = '#documentNo#'
									 AND    ActionSource = 'Assignment')
			   AND  AssignmentStatus IN ('0','1') 
			</cfquery>
			
			<cfquery name="Update9" 
			 datasource="AppsEmployee" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			   UPDATE PersonAssignment 
			   SET    AssignmentStatus = '1'
			   WHERE  AssignmentNo IN (SELECT convert(integer,ActionSourceNo)  
			                         FROM   EmployeeActionSource 
									 WHERE  ActionDocumentNo = '#documentNo#'
									 AND    ActionSource = 'Assignment')
			   AND    AssignmentStatus = '9'
			</cfquery>
			 
			 <!--- In case of movement action, we also try to revert the position --->
			 <cfif Check.ActionCode eq '0008'>
			 
			 	<!--- Get assignment that got re-instated --->
				<cfquery name="getAssignment" 
				 datasource="AppsEmployee" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					 SELECT  TOP 1 *
					 FROM    PersonAssignment 
					 WHERE   AssignmentNo IN (SELECT convert(integer,ActionSourceNo)  
			                         FROM   EmployeeActionSource 
									 WHERE  ActionDocumentNo = '#documentNo#'
									 AND    ActionSource = 'Assignment')
					 AND     AssignmentStatus = '1'
			 	</cfquery>
				
				<!--- Make sure that the position holding the re-instated assignment has the correct expiration date--->
				<cfquery name="fixPostDateExp" 
				 datasource="AppsEmployee" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					 UPDATE Position
					 SET    DateExpiration = '#getAssignment.DateExpiration#'
					 WHERE  PositionNo = '#getAssignment.PositionNo#' AND DateExpiration < '#getAssignment.DateExpiration#'
			 	</cfquery>
				
				<!--- Also, re-instate position's parent org unit, in case the movement was a full transfer --->
				<cfquery name="fixParent" 
				 datasource="AppsEmployee" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					 UPDATE PP
					 SET    PP.OrgUnitOperational = P.OrgUnitOperational
					 FROM   Position P
					 		INNER JOIN PositionParent PP
								ON P.PositionParentId = PP.PositionParentId
					 WHERE  PositionNo = '#getAssignment.PositionNo#' 
					 AND    P.OrgUnitOperational != PP.OrgUnitOperational
			 	</cfquery>
				
				<!---Finally, delete position created due to the movement, which at this point will be associated to an assignmentstatus 8 --->
				<cfquery name="fixParent" 
				 datasource="AppsEmployee" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 	DELETE FROM Position
					WHERE  PositionNo IN(
						 SELECT PositionNo
						 FROM   PersonAssignment
						 WHERE  AssignmentNo IN (SELECT convert(integer,ActionSourceNo) 
					                         FROM   EmployeeActionSource 
											 WHERE  ActionDocumentNo = '#documentNo#'
											 AND    ActionSource = 'Assignment')
					   	 AND  AssignmentStatus = '8' 
						 AND  PositionNo!='#getAssignment.PositionNo#' <!--- Except for the position no for which the assignment got re-instated --->
					)  
				 </cfquery>
				
			 </cfif>
			 
			<!--- set status in action table --->
			
			<cfif attributes.clean eq "No">
			 
				<cfquery name="UpdateStatusAction" 
				 datasource="AppsEmployee" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 UPDATE EmployeeAction
				 SET    ActionStatus = '9'
				 WHERE  ActionDocumentNo = '#documentNo#' 
				</cfquery>
			
			<cfelse>
			
				<cfquery name="DeleteAssignment" 
			         datasource="AppsEmployee" 
			         username="#SESSION.login#" 
			         password="#SESSION.dbpw#">
			    	 DELETE PersonAssignment
				   	 WHERE  AssignmentNo IN (SELECT convert(integer,ActionSourceNo) 
					                         FROM   EmployeeActionSource 
											 WHERE  ActionDocumentNo = '#documentNo#' 
											 AND    ActionSource = 'Assignment')
					 AND    AssignmentStatus = '8'						 
				</cfquery>
				
				<!--- removes action and actionsource records --->
				
				<cfquery name="DeleteAction" 
			         datasource="AppsEmployee" 
			         username="#SESSION.login#" 
			         password="#SESSION.dbpw#">
			    	 DELETE EmployeeActionSource
				   	 WHERE  ActionDocumentNo = '#documentNo#' 
				</cfquery>
				
				<cfquery name="DeleteAction" 
			         datasource="AppsEmployee" 
			         username="#SESSION.login#" 
			         password="#SESSION.dbpw#">
			    	 DELETE EmployeeAction
				   	 WHERE  ActionDocumentNo = '#documentNo#' 
				</cfquery>
					
			</cfif>
			
		</cftransaction>	
		
	</cfif>	

</cfif>