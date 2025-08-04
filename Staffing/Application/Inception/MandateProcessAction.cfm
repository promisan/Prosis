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

<cfparam name="URL.Mission"    default="111">
<cfparam name="URL.MandateNo"  default="111">
<cfparam name="URL.Status"     default="0">

<cfquery name="ClearPrior" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">  
	DELETE FROM EmployeeAction
	WHERE MandateNo = '#URL.MandateNo#'
	  AND Mission   = '#URL.Mission#'
	  AND ActionPersonNo is NULL
</cfquery>

<cfquery name="Mandate" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">  
SELECT *
FROM   Ref_Mandate
WHERE  MandateNo = '#URL.MandateNo#'
  AND  Mission   = '#URL.Mission#'
</cfquery>

<cfquery name="MandateParent" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">  
SELECT *
FROM Ref_Mandate
WHERE MandateNo = '#Mandate.MandateParent#'
  AND Mission   = '#URL.Mission#'
</cfquery>

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#OnBoardPrevious"> 
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#OnBoardCurrent"> 
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#OnBoard"> 
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#OnBoardNew"> 

<cfquery name="OnBoardInPriorMandate" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">  
	SELECT DISTINCT 
	       P.PersonNo, 
	       Post.PositionNo, 	  
		   Post.SourcePostNumber, 
		   P.AssignmentNo, 
		   Post.PostType
	INTO   userQuery.dbo.#SESSION.acc#OnBoardPrevious
	FROM   Position Post, PersonAssignment P
	WHERE  Post.MandateNo = '#MandateParent.MandateNo#'
	  AND  Post.Mission   = '#URL.Mission#'
	  AND  P.DateExpiration >= '#DateFormat(MandateParent.DateExpiration,client.dateSQL)#'    
	  AND  P.AssignmentStatus IN ('0','1')
	  AND  Post.PositionNo = P.PositionNo
</cfquery>

<cfquery name="OnBoardInNewMandate" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">  
	SELECT Curr.*,
	       Post.SourcePositionNo,
	       Post.SourcePostNumber, 
		   Post.PostType
	INTO   userQuery.dbo.#SESSION.acc#OnBoardCurrent
	FROM   Position Post, 
	       PersonAssignment Curr
	WHERE  Post.MandateNo = '#URL.MandateNo#'
	  AND  Post.Mission   = '#URL.Mission#'
	  AND  Post.PositionNo = Curr.PositionNo
	  <!--- limit to valid records only --->
	  AND  Curr.AssignmentStatus IN ('0','1')
</cfquery>

<!--- Define the people onboard in the prior mandate
that might exist or no longer exist in the new mandate) 
--->

<cfquery name="OnBoardCarryOverPrioMandate" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">  
	SELECT Prev.PersonNo, 
	       Prev.PositionNo, 
		   Prev.SourcePostNumber, 	   
		   Prev.AssignmentNo, 
		   Prev.PostType,
	       Curr.AssignmentNo as CurrentNo, 
		   Curr.SourcePostNumber as CurrentPostNumber,
		   Curr.SourcePositionNo
	INTO   userQuery.dbo.#SESSION.acc#OnBoard
	FROM   userQuery.dbo.#SESSION.acc#OnBoardPrevious Prev LEFT OUTER JOIN
	       userQuery.dbo.#SESSION.acc#OnBoardCurrent Curr ON Prev.PersonNo = Curr.PersonNo
</cfquery>

<!--- NEWLY added in new mandate --->
<cfquery name="OnBoardNew" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">  
	SELECT Curr.PersonNo, 
	       Curr.PositionNo, 
		   Curr.SourcePostNumber, 
		   Curr.AssignmentNo, 
		   Curr.PostType, 
	       Prev.AssignmentNo as Prior, 
		   Curr.SourcePostNumber as CurrentPostNumber
	INTO   userQuery.dbo.#SESSION.acc#OnBoardNew
	FROM   userQuery.dbo.#SESSION.acc#OnBoardPrevious Prev RIGHT OUTER JOIN
	       userQuery.dbo.#SESSION.acc#OnBoardCurrent Curr ON Prev.PersonNo = Curr.PersonNo
</cfquery>

<cfquery name="Posttype" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">  
	SELECT DISTINCT PostType
	FROM   userQuery.dbo.#SESSION.acc#OnBoard
</cfquery>

<cftransaction action="BEGIN">

<cfloop query = "Posttype">
	
	<cfinclude template="../Assignment/ActionNo.cfm">
	
	<!--- ------------------------------- --->
	<!--- create transaction discontinued --->
	<!--- ------------------------------- --->
	 
	<cfquery name="InsertActivity" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     INSERT INTO EmployeeAction
			         (ActionDocumentNo,
					 ActionCode,		
					 ActionStatus,
					 ActionSource,		
					 ActionDescription,
					 Mission,
					 MandateNo,
					 Posttype,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName,
					 ActionDate)
	      VALUES (
		          #NoAct#,
				  '0001',			
				  '#URL.Status#',
				  'Assignment',			 
				  'Discontinued assignments',
				  '#URL.Mission#',
				  '#Mandate.MandateNo#',
				  '#Posttype.PostType#',
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#',
				  '#Mandate.DateEffective#'
				  )
		 </cfquery>
				
		<cfquery name="UpdateAssignment" 
	         datasource="AppsEmployee" 
	         username="#SESSION.login#" 
	         password="#SESSION.dbpw#">
	    	 UPDATE PersonAssignment
	   	     SET    ActionReference = #NoAct# 			 		
	    	 WHERE  AssignmentNo = ANY (SELECT AssignmentNo 
			                            FROM   userQuery.dbo.#SESSION.acc#OnBoard
			                            WHERE  CurrentNo is NULL 
									    AND    PostType = '#Posttype.PostType#') 
			 AND    AssignmentStatus IN ('0','1')							
		</cfquery>							   
				  
		<cfquery name="InsertLogging" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		     INSERT INTO EmployeeActionSource
		        (ActionDocumentNo, 
				 PersonNo,
				 ActionSource,
				 ActionSourceNo,
				 ActionStatus)
		       SELECT ActionReference, 
			          PersonNo, 
					  'Assignment', 
					  AssignmentNo, 
					  AssignmentStatus
			  FROM  PersonAssignment
		      WHERE ActionReference = #NoAct#	
	    </cfquery>
		
	<!--- -------------------------------- --->
	<!--- -------extended same post------- --->
	<!--- -------------------------------- --->
	
	<cfinclude template="../Assignment/ActionNo.cfm">
	
	<cfquery name="InsertActivity" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		     INSERT INTO EmployeeAction
		         (ActionDocumentNo,
				 ActionCode,		 
				 ActionStatus,
				 ActionSource,		
				 ActionDescription,
				 Mission,
				 MandateNo,
				 PostType,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName,
				 ActionDate)
		      VALUES (
		          #NoAct#,
				  '0004',		  
				  '#URL.Status#',
				  'Assignment',		 
				  'Extension on same Position',
				  '#URL.Mission#',
				  '#Mandate.MandateNo#',
				  '#Posttype.PostType#',
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#',
				  '#Mandate.DateEffective#')
		 </cfquery>
		
		<cfquery name="UpdateAssignment" 
		         datasource="AppsEmployee" 
		         username="#SESSION.login#" 
		         password="#SESSION.dbpw#">
		    	 UPDATE PersonAssignment
		   	     SET    ActionReference = #NoAct#				
		    	 WHERE  AssignmentNo IN    (SELECT AssignmentNo 
				                            FROM   userQuery.dbo.#SESSION.acc#OnBoard
				                            WHERE  CurrentNo IS NOT NULL  <!--- existed before --->
										    AND    (SourcePostNumber = CurrentPostNumber OR PositionNo = SourcePositionNo)
										    AND    PostType = '#Posttype.PostType#'
										  )
				 AND    AssignmentStatus IN ('0','1')																	
		</cfquery>	
					 
		<cfquery name="InsertLogging" 
		     datasource="AppsEmployee" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			     INSERT INTO EmployeeActionSource
			        (ActionDocumentNo, 
					 PersonNo,
					 ActionSource,
					 ActionSourceNo,
					 ActionStatus)
			       SELECT ActionReference, PersonNo, 'Assignment', AssignmentNo, AssignmentStatus
				  FROM  PersonAssignment
			      WHERE ActionReference = #NoAct#	
		    </cfquery>
	
	<!--- ------------------------------------- --->
	<!--- -----create different posts---------- --->
	<!--- ------------------------------------- --->
	
	<cfinclude template="../Assignment/ActionNo.cfm">
	
	<cfquery name="InsertActivity" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     INSERT INTO EmployeeAction
	         (ActionDocumentNo,
			 ActionCode,		
			 ActionStatus,
			 ActionSource,		
			 ActionDescription,
			 Mission,
			 MandateNo,
			 PostType,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName,
			 ActionDate)
	      VALUES (
	          #NoAct#,
			  '0004',		 
			  '#URL.Status#',
			  'Assignment',		 
			  'Extension on different post',
			  '#URL.Mission#',
			  '#Mandate.MandateNo#',
			  '#Posttype.PostType#',
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#',
			  '#Mandate.DateEffective#')
		 </cfquery>
		 
		 <!--- approved ---> 
		
		 <cfquery name="UpdateAssignment" 
		         datasource="AppsEmployee" 
		         username="#SESSION.login#" 
		         password="#SESSION.dbpw#">
		    	 UPDATE PersonAssignment
		   	     SET    ActionReference = #NoAct#				 
		    	 WHERE  AssignmentNo IN  (
				                            SELECT AssignmentNo 
				                            FROM   userQuery.dbo.#SESSION.acc#OnBoard
				                            WHERE  CurrentNo is not NULL  <!--- existed before --->
										    AND    (SourcePostNumber != CurrentPostNumber AND PositionNo != SourcePositionNo)
										    AND    PostType = '#Posttype.PostType#'
										 )
				 <!--- exclude already  cancelled transaction because of open and close behavior --->						  
				 AND AssignmentStatus IN ('0','1')						  
		 </cfquery>	
		
		 <cfquery name="InsertLogging" 
		     datasource="AppsEmployee" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO EmployeeActionSource
			        (ActionDocumentNo, 
					 PersonNo,
					 ActionSource,
					 ActionSourceNo,
					 ActionStatus)
		      SELECT ActionReference, PersonNo, 'Assignment', AssignmentNo, AssignmentStatus
			  FROM   PersonAssignment
		      WHERE  ActionReference = #NoAct#	
		 </cfquery>
	
</cfloop>
	
<!--- ------------------------------- --->
<!--- -----new assignments----------- --->
<!--- ------------------------------- --->

<cfquery name="Posttype" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">  
	SELECT DISTINCT PostType
	FROM   userQuery.dbo.#SESSION.acc#OnBoardNew
</cfquery>

<cfloop query="PostType">
	
	<cfinclude template="../Assignment/ActionNo.cfm">
	
	<cfquery name="InsertActivity" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     INSERT INTO EmployeeAction
	         (ActionDocumentNo,
			 ActionCode,		
			 ActionStatus,
			 ActionSource,		
			 ActionDescription,
			 Mission,
			 MandateNo,
			 PostType,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName,
			 ActionDate)
	      VALUES (
	          #NoAct#,
			  '0003',		 
			  '#URL.Status#',
			  'Assignment',		 
			  'New assignment',
			  '#URL.Mission#',
			  '#Mandate.MandateNo#',
			  '#PostType#',
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#',
			  '#Mandate.DateEffective#')
		 </cfquery>
		 
		 <cfquery name="UpdateAssignment" 
	         datasource="AppsEmployee" 
	         username="#SESSION.login#" 
	         password="#SESSION.dbpw#">
	    	 UPDATE PersonAssignment
	   	     SET    ActionReference = #NoAct#
	    	 WHERE  AssignmentNo = ANY (SELECT AssignmentNo FROM userQuery.dbo.#SESSION.acc#OnBoardNew
			                        WHERE Prior is NULL 
									  AND PostType = '#Posttype.PostType#')
	</cfquery>	
	
	
	<cfquery name="InsertLogging" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     INSERT INTO EmployeeActionSource
	        (ActionDocumentNo, 
			 PersonNo,
			 ActionSource,
			 ActionSourceNo,
			 ActionStatus)
	       SELECT ActionReference, PersonNo, 'Assignment', AssignmentNo, AssignmentStatus
		  FROM  PersonAssignment
	      WHERE ActionReference = #NoAct#	
	    </cfquery>	

</cfloop>

<!--- ---------------------------- --->
<!--- ----extended contract------- --->
<!--- ---------------------------- --->

<cfinclude template="../Assignment/ActionNo.cfm">

<cfquery name="InsertActivity" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO EmployeeAction
         (ActionDocumentNo,
		 ActionCode,		 
		 ActionStatus,
		 ActionSource,		
		 ActionDescription,
		 Mission,
		 MandateNo,		
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName,
		 ActionDate)
      VALUES (#NoAct#,
			  '3003',		  
			  '#URL.Status#',
			  'Contract',		 
			  'Contract Extension',
			  '#URL.Mission#',
			  '#Mandate.MandateNo#',		 
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#',
			  '#Mandate.DateEffective#')
</cfquery>
						 
<cfquery name="InsertLogging" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO EmployeeActionSource
	        (ActionDocumentNo, 
			 PersonNo,
			 ActionSource,
			 ActionSourceId,
			 ActionStatus)
     SELECT '#NoAct#', 
	        PersonNo, 
			'Contract', 
			ContractId, 
			ActionStatus
	 FROM   PersonContract
     WHERE  Mission    = '#URL.Mission#'	
	 AND    MandateNo  = '#Mandate.MandateNo#'
</cfquery>	
	
<cfif URL.Status eq "1">	<!--- approved , db-trigger will adjust tables as well !!!---> 
	
	<!--- limited log --->
	
	<cfquery name="UpdateMandate" 
	   datasource="AppsEmployee" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	    	 UPDATE Organization.dbo.Ref_Mandate
			 SET    MandateStatus        = '1',
			        MandateStatusDate    = getdate(),
			        MandateStatusOfficer = '#SESSION.acc#'
			 WHERE  MandateNo = '#URL.MandateNo#'
	         AND    Mission   = '#URL.Mission#'
	</cfquery>	
		
	<cfquery name="LogMandateAction" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Organization.dbo.Ref_MandateAction
	(Mission, MandateNo, MandateStatus, ActionSource, ActionDate, OfficerUserId, OfficerLastName, OfficerFirstName)
	VALUES
	('#url.Mission#','#url.mandateNo#','1','MANUAL',getdate(),'#SESSION.acc#','#SESSION.last#','#SESSION.first#')	
	</cfquery>		
	
	<cfquery name="UpdatePosition" 
	   datasource="AppsEmployee" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	    	 UPDATE Position
			 SET    PositionStatus = '1'
			 WHERE  PositionNo IN (SELECT PositionNo 
			                       FROM   Position		   
								   WHERE  MandateNo = '#URL.MandateNo#'
							       AND    Mission   = '#URL.Mission#')
	</cfquery>	
	
	<!--- Not needed as trigger should do this, but I think it was not working in NY 
	
	<cfquery name="UpdateAssignent" 
	   datasource="AppsEmployee" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	    	 UPDATE PersonAssignment
			 SET    AssignmentStatus  = '1'
			 WHERE  PositionNo IN (SELECT PositionNo 
			                       FROM   Position		   
								   WHERE  MandateNo = '#URL.MandateNo#'
							       AND    Mission   = '#URL.Mission#')
			 AND    AssignmentStatus IN ('0')						   
	</cfquery>	
	
	--->

</cfif>
	
</cftransaction>

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#OnBoardPrevious"> 
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#OnBoardCurrent"> 
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#OnBoard"> 
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#OnBoardNew"> 

<script language="JavaScript">
   parent.history.go() 
   parent.ProsisUI.closeWindow('mydialog',true)   
</script>
