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
	<cfquery name="Assignment" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			 SELECT  *
			 FROM   PersonAssignment
			 WHERE  AssignmentNo = '#Form.ExtendAssignment#'										
	</cfquery>	
	
	<!--- takes all assignments of this person under the same class --->

						
	<cfquery name="Position" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			 SELECT * 
			 FROM   Position
			 WHERE  PositionNo IN (SELECT PositionNo 
		    	                   FROM   PersonAssignment 
								   WHERE  AssignmentNo = '#Form.ExtendAssignment#')																	 
	</cfquery>	
	
	<cfquery name="Mandate" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			 SELECT * 
			 FROM   Organization.dbo.Ref_Mandate
			 WHERE  Mission   = '#Position.Mission#'
			 AND    MandateNo = '#Position.MandateNo#'			 														 
	</cfquery>	
	
	<!--- define the maximum extension date dictated by the position --->
	
		
	<cfif Position.DateExpiration lt end>
	    <cfif Mandate.DateExpiration gte end>
			<cfset d = dateformat(Position.DateExpiration,client.dateformatshow)>
			<cf_message message="You may not extend an assignment if the extension would exceed the position expiration date (#d#)./n/nOperation aborted" return="back">
		    <cfabort>
		<cfelse> 
			<cfset assend = Position.DateExpiration>
		</cfif>
	<cfelse>
	    <cfset assend = dateformat(end,client.datesql)>
	</cfif>		
	
   <!--- check if the new to construct assignment will still have a valid start date --->
	
   <cfif Assignment.dateEffective gt assend>
	
		<cf_message message="You may not shorten an assignment which will also affect a prior assignment on a different position./n/nOperation aborted" 
		    return="back">
		<cfabort>
	
   </cfif>		
	
   <!--- --------------------------------------------------- --->
   <!--- check if contract assignment record already exisits --->
   <!--- --------------------------------------------------- --->
	
   <cfquery name="Check" 
   datasource="AppsEmployee" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
      SELECT * 
	  FROM   PersonAssignment 		    
	  WHERE  PersonNo    = '#Form.PersonNo#'
      AND    ContractId  = '#Form.ContractId#'  
   </cfquery>	
	
   <cfif check.recordcount eq "1">
   
       <!--- validate --->
	   
	   	<cfquery name="CheckExtension" 
		     datasource="AppsEmployee" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 SELECT * 
			 FROM   PersonAssignment
			 WHERE  AssignmentStatus IN ('0','1')                    <!--- valid --->
			 AND    AssignmentNo   != '#Form.ExtendAssignment#'      <!--- exclude this assignment --->										
			 AND    PositionNo      = '#Assignment.PositionNo#'      <!--- same position --->
			 AND    AssignmentType  = 'Actual'
			 AND    AssignmentClass = '#Assignment.AssignmentClass#' <!--- same assignment class as we allow different classes to overlap : added 19/4/2019 --->
			 AND    DateEffective  <= '#assend#'                     <!--- does not lie in this period --->
			 AND    DateExpiration >= '#assend#'								 
		</cfquery>		
			
		<cfif CheckExtension.recordcount gte "1">
			
			<cf_message message="Reappointment / extension not permitted as the position is already occupied for the request period. Please try to extend the assignment manually or contact your administrator." return="back">
			<cfabort>
											
		</cfif>
		
		<!--- NOTE this might be going wrong if there is also a transaction for the contract in a next mandate --->
	 
		<cfquery name="UpdatesValues" 
		   datasource="AppsEmployee" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		      UPDATE PersonAssignment 		    
			  SET    DateExpiration = '#assend#', 
			         DateDeparture  = #end#							  
			  WHERE  PersonNo       = '#Check.PersonNo#'
		      AND    ContractId     = '#Form.ContractId#' 
	    </cfquery>	
	
	<cfelse>		
					
		<!--- retrieve the mandate from the selected assignment --->
		
		<cfquery name="GetMandate" 
		     datasource="AppsEmployee" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 SELECT M.Mission,
			        M.MandateNo,
					M.DateEffective, 
					Pos.PositionNo 
			 FROM   PersonAssignment Pa, 
			        Position Pos, 
					Organization.dbo.Ref_Mandate M
			 WHERE  PA.PositionNo   = Pos.PositionNo
			 AND    Pos.Mission     = M.Mission
			 AND    Pos.MandateNo   = M.MandateNo
			 AND    PA.AssignmentNo = '#Form.ExtendAssignment#'										
		</cfquery>		
		
		<!--- check if there is a next mandate already --->							
		
		<cfquery name="NextMandate" 
		     datasource="AppsEmployee" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 SELECT *
			 FROM   Organization.dbo.Ref_Mandate
			 WHERE  Mission       = '#GetMandate.Mission#'
			 AND    DateEffective > '#GetMandate.DateEffective#'										
		</cfquery>		
		
		<!--- ----------------------------------------------------------------- --->					
		<!--- make an entry in the next mandate once this is already LOCKED !! AND 
		    proposed expir lies beyond the effective date --->
		<!--- ----------------------------------------------------------------- --->	
																
		<cfif NextMandate.MandateStatus eq "1" and NextMandate.dateEffective lte end>
		
		    <!--- determine if the positionNo in the NEXT mandate --->
			
			<cfquery name="PositionExist" 
		     datasource="AppsEmployee" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
				 SELECT *
				 FROM   Position
				 WHERE  Mission          = '#NextMandate.Mission#'
				 AND    MandateNo        = '#NextMandate.MandateNo#'										
				 AND    SourcePositionNo = '#GetMandate.PositionNo#'								
		    </cfquery>	
			
			<cfif PositionExist.Recordcount eq "0">
			
				<cf_message message="Reappointment and Assignment Extension not allowed as the position in the new mandate could not be determined. Please extend the assignment manually" return="back">
				<cfabort>	
				
			<cfelse>
			
				<cfif end gt PositionExist.DateExpiration>
					<cfset assend = PositionExist.DateExpiration>
				<cfelse>
				    <cfset assend = dateformat(end,client.datesql)>
				</cfif>		
							
			</cfif>
			
			<cfquery name="PositionUsed" 
		     datasource="AppsEmployee" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
				 SELECT *
				 FROM   Position
				 WHERE  Mission          = '#NextMandate.Mission#'
				 AND    MandateNo        = '#NextMandate.MandateNo#'										
				 AND    SourcePositionNo = '#GetMandate.PositionNo#'
				 AND    PositionNo IN (SELECT PositionNo 
				                       FROM   PersonAssignment 
									   WHERE  AssignmentStatus IN ('0','1'))
		    </cfquery>	
			
			<cfif PositionUsed.recordcount gte "1">
			
				<cf_message message="Reappointment and Assignment Extension is not allowed as the position is already occupied. Please extend the assignment manually" return="back">
				<cfabort>
											
			</cfif>
																	
			<cfquery name="InsertAssignment" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">  
				INSERT INTO PersonAssignment
					  (PersonNo, 
					   PositionNo, 
					   OrgUnit, 
					   FunctionNo, 
					   FunctionDescription, 
					   LocationCode, 
					   DateEffective, 
					   DateExpiration, 
					   AssignmentStatus, 
					   AssignmentClass,
					   AssignmentType, 
					   Incumbency, 
					   Source,		
					   ContractId,						 								  
					   DateDeparture,
					   OfficerUserId, 
					   OfficerLastName, 
					   OfficerFirstName, 
					   Created)
				SELECT A.PersonNo,
				       '#PositionExist.PositionNo#',
					   '#PositionExist.OrgUnitOperational#', 
				       A.FunctionNo,
					   A.FunctionDescription,
					   A.LocationCode,
					   '#PositionExist.dateEffective#', 
				  	   '#assend#',
					  '0',
					   A.AssignmentClass,
					   A.AssignmentType,
					   A.Incumbency,
			           'Appointment Extension',		
					   '#Form.Contractid#',						 
					   #end#,
					   '#SESSION.acc#', 
					   '#SESSION.last#', 
					   '#SESSION.first#',
					   getDate()
				FROM  PersonAssignment A 									     
				WHERE A.AssignmentNo = 	'#Form.ExtendAssignment#'								
			 </cfquery>															
		
		<cfelse>	
		
			<!--- check if the extension of the period in the same mandate can indeed be made --->
			
			<cfquery name="CheckExtension" 
		     datasource="AppsEmployee" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
				 SELECT * 
				 FROM   PersonAssignment
				 WHERE  AssignmentStatus IN ('0','1')                <!--- valid --->
				 AND    AssignmentNo   != '#Form.ExtendAssignment#'  <!--- exclude this assignment --->										
				 AND    PositionNo      = '#Assignment.PositionNo#'  <!--- same position --->
				 AND    DateEffective  <= '#assend#'                 <!--- does not lie in this period --->
				 AND    DateExpiration >= '#assend#'								 
		    </cfquery>		
			
			<cfif CheckExtension.recordcount gte "1">
			
				<cfif Position.SourcePostNumber neq "">			
					<cf_message message="Reappointment and extension is not allowed as the position: #Position.SourcePostNumber# is (partially) occupied for the requested contract period. Please verify your records or contact your administrator" return="back">
                <cfelse>
			   		<cf_message message="Reappointment and extension is not allowed as the position: #Position.PositionParentId# is (partially) occupied for the requested contract period. Please verify your records or contact your administrator" return="back">           
				</cfif>					
				<cfabort>
											
			</cfif>
			
			<cfif Assignment.AssignmentStatus eq "0">
			
				<!--- the assignment is OPEN, we simply update the expiration to an earlier or laster date 
				all the rest remains the same so the workflow remains active and this change acts as if
				this was made on the level of the assignment. Cancelling will not affect this assignment
				for that you have the workflow still of the assignment --->
				
				<cfquery name="ResetOpenAssignment" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
					 UPDATE PersonAssignment
					 SET    DateExpiration = '#assend#'
					 WHERE  AssignmentNo = '#Form.ExtendAssignment#'										
			    </cfquery>		
							
			<cfelse>
										
				<cfquery name="RevertExistAssignment" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
					 UPDATE PersonAssignment
					 SET    AssignmentStatus = '9'
					 WHERE  AssignmentNo = '#Form.ExtendAssignment#'										
			    </cfquery>		
				
				<!--- add new assignment --->
			
				<cfquery name="InsertAssignment" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO PersonAssignment
				         (PersonNo,
						 PositionNo,
						 DateEffective,
						 DateExpiration,
						 OrgUnit,
						 LocationCode,
						 FunctionNo,
						 FunctionDescription,
						 AssignmentStatus,
						 AssignmentClass,
						 AssignmentType,
						 Incumbency,
						 ContractId,
						 Source,
						 SourceId,								 							
						 Remarks,
						 DateArrival,
						 DateDeparture,
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName)
				  SELECT  PersonNo,
						  PositionNo,
						  DateEffective,
						  '#assend#',   
						  OrgUnit,
						  LocationCode,
						  FunctionNo,
						  FunctionDescription,
						  '0',
						  AssignmentClass,
						  AssignmentType,
						  Incumbency,
						  '#Form.ContractId#',
						  'Contract Amendment',
						  '#Form.ExtendAssignment#',																								
						  Remarks,
						  DateArrival,
						  #end#,
						  '#SESSION.acc#',
				    	  '#SESSION.last#',		  
					  	  '#SESSION.first#'
				  FROM    PersonAssignment
				  WHERE   AssignmentNo = '#Form.ExtendAssignment#'		  		 				      
			  </cfquery>		
			
			</cfif>
							  				  				  
	  		
									
	</cfif>						
	
  </cfif>			  