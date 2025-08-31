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
<cf_screentop html="No" jquery="Yes" title="Submit Position">

<!--- clean feature --->

<cfquery name="Parameter" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT *
    FROM Parameter
</cfquery>	

<cfparam name="form.classified"         default="0">
<cfparam name="form.VacancyActionClass" default="">
<cfparam name="form.ApprovalReference"  default="">
<cfparam name="Form.PostGrade"          default="">
<cfparam name="Form.Remarks"            default="">
<cfparam name="Form.OrgUnit1"           default="">
<cfparam name="Form.OrgUnit2"           default="">

<cfif Form.PostGrade eq "">

	<cf_alert message = "No post grade has been selected. Operation not allowed." return = "back">
	<cfabort>

</cfif>
			
<cfif ParameterExists(Form.Delete)> 

		<cfquery name="checkEvent" 
		     datasource="AppsEmployee" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 SELECT * 
			 FROM   PersonEvent
			 WHERE  PositionNo = '#Form.PositionNo#' 
		</cfquery>	
		
		<cfif checkEvent.recordcount gte "1">
		
			<cf_alert message = "There is a person event with this positionNo (#Form.PositionNo#), Contact your administrator. Operation not allowed." return = "back">
			<cfabort>
		
		</cfif>
			
		<cfquery name="Check" 
		     datasource="AppsEmployee" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
				 SELECT *
				 FROM   Position
				 WHERE  PositionParentId = '#Form.PositionParentId#' 
		</cfquery>	
		
		<cfif Check.recordcount eq "1">
		
			<cfquery name="Position" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
					 DELETE FROM Position
					 WHERE  PositionNo = '#Form.PositionNo#' 
			</cfquery>	
			
			<cfquery name="Position" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
					 DELETE FROM PositionRelation
					 WHERE  PositionNoRelation = '#Form.PositionNo#' 
			</cfquery>	
		
			<cfquery name="Parent" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
					 DELETE FROM PositionParent
					 WHERE  PositionParentId = '#Form.PositionParentId#' 
			</cfquery>		
			
			<!---		
			
			<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
			  		         	 action="Delete"
								 datasource = "AppsEmployee" 
								 contenttype="scalar"
								 content="PositionParentId:#Form.PositionParentId#">
								 
			 --->
				
		<cfelse>
		
			<cfquery name="Position" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
					 DELETE FROM Position
					 WHERE  PositionNo = '#Form.PositionNo#' 
			</cfquery>	
			
			<cfquery name="Position" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
					 DELETE FROM PositionRelation
					 WHERE  PositionNoRelation = '#Form.PositionNo#' 
			</cfquery>	
			
			<!---	
		
			<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
			  		         	 action="Delete"
								 datasource = "AppsEmployee" 
								 contenttype="scalar"
								 content="PositionParentId:#Form.PositionParentId#">
								 
			 --->
		
		</cfif>
		
		<cfoutput>
		
		<!--- refresh if needed --->
		
		<script LANGUAGE = "JavaScript">								 
			  returnValue = ""
			  window.close();										
		</script>
		
		</cfoutput>

<cfelseif ParameterExists(Form.Submit)> 

    <cftransaction>

	<cfquery name="Get" 
       datasource="AppsEmployee" 
       username="#SESSION.login#" 
       password="#SESSION.dbpw#">
       SELECT * 
	   FROM   PositionParent
	   WHERE  PositionParentId   = '#Form.PositionParentId#'
    </cfquery>	
	
	<cfparam name="Form.Fund"     default="#Get.Fund#">
	<cfparam name="Form.PostType" default="#Get.PostType#">
	
	<cfquery name="Check" 
       datasource="AppsEmployee" 
       username="#SESSION.login#" 
       password="#SESSION.dbpw#">
       SELECT * 
	   FROM   Ref_PostType
	   WHERE  PostType   = '#Form.PostType#'
    </cfquery>	
	
	<cfif Check.recordcount eq "0">
	    <script>parent.Prosis.busy('no')</script> 
		 <cf_alert message = "You have not identified a valid post type."
		  return = "back">
		 
		  <cfabort>
	</cfif>
		
	<cfif Form.OrgUnit eq "">
	     <script>parent.Prosis.busy('no')</script> 
		 <cf_alert message = "You have not identified a valid orgunit."
		  return = "back">
		  <cfabort>
	</cfif>
	
	<cfif Len(Form.Remarks) gt 600>
		<script>parent.Prosis.busy('no')</script> 
		 <cf_alert message = "You entered remarks that exceeded the allowed length of 600 characters."
		  return = "back">
		  <cfabort>
	</cfif>	
	
	<!--- all reference changes --->
			 		 		  
    <cfquery name="UpdateParent" 
       datasource="AppsEmployee" 
       username="#SESSION.login#" 
       password="#SESSION.dbpw#">
       UPDATE PositionParent
	   SET    <cfif Form.Classified eq "0">
			  ApprovalPostGrade  = '',
			  <cfelse>
			  ApprovalPostGrade  = '#Form.ApprovalPostGrade#',
			  </cfif>
			  ApprovalReference  = '#Form.ApprovalReference#',
			  Fund               = '#Form.Fund#'
   	   WHERE  PositionParentId   = '#Form.PositionParentId#'
    </cfquery>	
	
	<cfquery name="PositionParent" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 SELECT *
		 FROM   PositionParent
		 WHERE  PositionParentId = '#Form.PositionParentId#' 
	</cfquery>	
		
	<cfquery name="ParamMission" 
    	datasource="AppsEmployee" 
	    username="#SESSION.login#" 
    	password="#SESSION.dbpw#">
	    SELECT *
    	FROM   Ref_ParameterMission
		WHERE  Mission = '#PositionParent.Mission#'
	</cfquery>	
		
	<cfif ParameterExists(Form.LocationCode)> 
	  <cfset loc = "#Form.LocationCode#">
	<cfelse>   
	  <cfset loc = "">
	</cfif>   
	
	<cfset dateValue = "">
	<CF_DateConvert Value="#Form.DateEffective#">
	<cfset STR = dateValue>
	
	<cfif STR lt PositionParent.DateEffective>
	    <script>parent.Prosis.busy('no')</script> 
	   	<cf_alert message = "You selected a start date #dateformat(STR,CLIENT.DateFormatShow)# that lies before the parent effective date #dateformat(PositionParent.dateeffective,CLIENT.DateFormatShow)#. Operation not allowed." 
		return = "back">
		<cfabort>
	</cfif>	
	
	<cfif STR gt PositionParent.DateExpiration>
		<script>parent.Prosis.busy('no')</script> 
	   	<cf_alert message = "You selected a start date that lies after the parent expiration date. Operation not allowed." 
		return = "back">
		<cfabort>
	</cfif>		
		
	<cfset dateValue = "">
	<cfif Form.DateExpiration neq ''>
	    <CF_DateConvert Value="#Form.DateExpiration#">
	    <cfset END = dateValue>
	<cfelse>
	    <cfset END = 'NULL'>
	</cfif>	
	
	<cfif END gt PositionParent.DateExpiration>
		<script>parent.Prosis.busy('no')</script> 
	   	<cf_alert message = "You selected an expiration date that lies after the parent expiration date (#dateformat(PositionParent.DateExpiration,client.dateformatshow)#).\n\nOperation not allowed." 
		return = "back">
		<cfabort>
	</cfif>	
	
	<cfif STR lt PositionParent.DateEffective>
	    <script>parent.Prosis.busy('no')</script> 
	   	<cf_alert message = "You selected an effective date that lies before the parent effective date.\n\nOperation not allowed." 
		return = "back">
		<cfabort>
	</cfif>	
	
	<cfif END lt STR>
	    <cfset END = STR>
	</cfif>		
	
	<cfif END lte STR>
		<script>parent.Prosis.busy('no')</script> 
	   	<cf_alert message = "You selected a one day period. This operation not allowed." 
		return = "back">
		<cfabort>
	</cfif>		
	
	<cfset generate = "0">
	
	<!--- Loaning to other mission will enforce a correct period for the postion to be returned for the reaminder --->
		
	<cfif Form.MissionOperational neq Form.MissionParent>
	
			<cfquery name="NewMission" 
			  datasource="AppsEmployee" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				      SELECT *
				      FROM   Organization.dbo.Ref_Mandate
				   	  WHERE  Mission = '#Form.MissionOperational#' 
					  AND    DateEffective  <= #STR#
					  AND    DateExpiration >= #STR# 
					  AND    Operational = 1  
			 </cfquery> 
			 
			 <cfif NewMission.DateEffective gt STR>
			 
			 	<cfset dateValue = "">
				<CF_DateConvert Value="#DateFormat(NewMission.DateEffective,CLIENT.DateFormatShow)#">
				<cfset STR = dateValue>
			 
			 </cfif>
			 		 	 
			 <cfif NewMission.DateExpiration lt END>
			 
			 	<cfset dateValue = "">
				<CF_DateConvert 
				   Value="#DateFormat(NewMission.DateExpiration,CLIENT.DateFormatShow)#">
				
				<cfset generate = "1">
				
				<!--- generate entry for complete period returning to the borrower as otherwise 
				we would miss something here --->
					
				<cfset PEND = END>	
				<cfset PSTR = "#DateFormat(dateValue+1,client.dateSQL)#">
				<cfset END  = dateValue>
																	
			 </cfif>
	
	</cfif>
			
	<!--- save the position grouping on the parent level --->
	
	
	
	<cfquery name="Topic" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM  Ref_PositionParentGroup
		WHERE Code IN (SELECT GroupCode 
		               FROM   Ref_PositionParentGroupList)
	    AND  Code IN  (SELECT GroupCode 
		               FROM   Ref_PositionParentGroupMission
			           WHERE  Mission = '#PositionParent.Mission#' )    
	</cfquery>			   
		  
	<cfloop query="topic">
	
			
	     <cfparam name="Form.ListCode_#Code#" default="">
		 <cfparam name="Form.ListCodeSub_#Code#" default="">		        
		 
	     <cfset ListCode     = Evaluate("Form.ListCode_#Code#")>
		 <cfset ListCodeSub  = Evaluate("Form.ListCodeSub_#Code#")>
		 
		 <cfif ListCode neq "">
		 		 
			 <cfquery name="CheckGroup" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
					 SELECT *
					 FROM  PositionParentGroup
					 WHERE PositionParentId = '#Form.PositionParentId#' 					
					 AND   GroupCode = '#Code#'
			</cfquery>			 
			 
			<cfif CheckGroup.recordcount eq "0">
			
			   <cftry>
						  
				   <cfquery name="Insert" 
					 datasource="AppsEmployee" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					 INSERT INTO PositionParentGroup
						 (PositionParentId,
						  GroupCode,
						  GroupListCode, 
						  <cfif ListCodeSub neq "">
						  GroupListCodeSub,
						  </cfif>
						  OfficerUserId,
						  OfficerLastName,
						  OfficerFirstName)
					 VALUES
						 ('#Form.PositionParentId#', 
						  '#Code#', 
						  '#ListCode#', 
						  <cfif ListCodeSub neq "">
						  '#ListCodeSub#',
						  </cfif>
						  '#SESSION.acc#', 
						  '#SESSION.last#', 
						  '#SESSION.first#')
					</cfquery>
				
					<cfcatch></cfcatch>
				
				</cftry>
				
			 <cfelse>
			 
			    <cfif CheckGroup.GroupListCode neq ListCode or CheckGroup.GroupListCodeSub neq ListCodeSub>
			 
				    <cfquery name="Update" 
						 datasource="AppsEmployee" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						 UPDATE PositionParentGroup
						 SET   GroupListCode = '#ListCode#',
						       <cfif ListCodeSub neq "">
							   GroupListCodeSub = '#ListCodeSub#',
							   </cfif>
							   OfficerUserId    = '#SESSION.acc#',
							   OfficerLastName  = '#SESSION.last#',
							   OfficerFirstName = '#SESSION.first#',
							   Created = getDate()
						 WHERE PositionParentId = '#Form.PositionParentId#' 					
					     AND   GroupCode = '#Code#'	 
					  </cfquery>
					  
				 </cfif>	  
				
			 </cfif>	
			
		</cfif>	
		   
	</cfloop>	
	
	<!--- external linkage IMIS, SA-IT etc. --->
	
	<cfif ParamMission.EnableSourcePost eq "1">
	
		<cfif Parameter.SourcePostNumber eq "PositionParent">
			
			<cfif Form.SourcePostNumber neq "">
			
				<cfquery name="Check" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					 SELECT  *
					 FROM    PositionParent
					 WHERE   SourcePostNumber   = '#Form.SourcePostNumber#'
					 AND     Mission            = '#Form.Mission#'
					 AND     MandateNo          = '#Form.MandateNo#'
					 AND     PositionParentId  != '#Form.PositionParentId#' 
				</cfquery>	
				
				<cfif Check.recordcount gte "1">
				  <cf_alert message = "Parent Position : You are trying to register a Position cross reference Number [#Form.SourcePostNumber#] which is already in use.\n\nOperation not allowed (Parent Mode)."
			       return = "back">
			      <cfabort>
				</cfif>
			
			</cfif>
		
		<cfelse>
			
			<cfif Form.SourcePostNumber neq "">
			
				<cfquery name="Check" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					 SELECT *
					 FROM   Position
					 WHERE  SourcePostNumber  = '#Form.SourcePostNumber#'
					 AND    Mission           = '#Form.Mission#'
					 AND    MandateNo         = '#Form.MandateNo#'
					 AND    PositionNo       != '#Form.PositionNo#'
					 AND    PositionParentId != '#Form.PositionParentId#'
					 AND    DateEffective    >= #STR#
					 AND    DateExpiration   <= #END#					  
				</cfquery>	
				
				<cfif Check.recordcount gte "1">
				  <cf_alert message = "Position : You are trying to register a Position cross reference Number [#Form.SourcePostNumber#] which is already in use.\n\nOperation not allowed (Postition Mode)."
			       return = "back">
			      <cfabort>
				</cfif>
			
			</cfif>
		
		</cfif>
	
	</cfif>		
	
	
	<!--- we check if this position has a prior instance recorded for the selected dates  --->
			
	<cfquery name="PriorInstance" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 SELECT TOP 1 *
		 FROM   Position
		 WHERE  PositionNo      != '#Form.PositionNo#'
		 AND    PositionParentId = '#Form.PositionParentId#'
		 AND    DateEffective  <= #END#
		 AND    DateExpiration >= #STR#  
		 ORDER BY DateEffective DESC
	</cfquery>	
			
	<cfif PriorInstance.recordcount gte "1">
	
    	<!--- now we check if the predecessor has an assignment against it which ends after the proposed new effective date --->
	
		<cfquery name="AssignmentCheck" 
		     datasource="AppsEmployee" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 SELECT TOP 1 *
			 FROM     PersonAssignment
			 WHERE    PositionNo       = '#PriorInstance.PositionNo#'
			 AND      AssignmentStatus IN ('0','1')
			 ORDER BY DateExpiration DESC			
		</cfquery>	
		
		<cfif AssignmentCheck.dateExpiration gte STR>
		
			  <cf_alert message = "You have tried to update a position record with a proposed effective period\n\n #dateformat(str,CLIENT.DateFormatShow)# - #dateformat(end,CLIENT.DateFormatShow)#\n\nwhich conflicts with other positions. This is not allowed!"
		       return = "back">
		      <cfabort>
		  
		<cfelse>
		
			<cfset new = dateadd("D",-1,STR)>
		
			<cfquery name="UpdatePrior" 
		     datasource="AppsEmployee" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			      UPDATE Position
			      SET     DateExpiration = #new#
			      WHERE  PositionNo = '#priorInstance.PositionNo#'			
			</cfquery>		  
		
		</cfif>
	
	</cfif>
	
	<cfif Parameter.SourcePostNumber eq "Position">
	
			<cfquery name="CheckPost" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 SELECT *
				 FROM   Position
				 WHERE  SourcePostNumber = '#Form.SourcePostNumber#'
				 AND    Mission          = '#PositionParent.Mission#'
				 AND    PositionNo      != '#Form.PositionNo#'
				 AND    MandateNo        = '#Form.MandateNo#'
				 AND    (
				         (DateExpiration   <= #END# AND DateExpiration >= #STR#)  
						                     OR
				 		 (DateEffective    <= #END# AND DateEffective  >= #STR#)
						) 
			</cfquery>	
			
			<cfif CheckPost.recordcount gte "1"  and Form.SourcePostNumber neq "">
			  <cf_alert message = "You are trying to register an external post Number [#Form.SourcePostNumber#] which is already in use. Operation not allowed."
		       return = "back">
		      <cfabort>
			</cfif>
	
	</cfif>
	
	<!--- ------------------------------------------- --->
	<!--- verify new period versus actual assignments --->
	<!--- ------------------------------------------- --->
		
	<cfquery name="Check" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 SELECT *
		 FROM   Position
		 WHERE  PositionNo = '#Form.PositionNo#'
	</cfquery>	
	
	<!--- in case operational unit, grade or function has changed THEN if mandate is operational and effective date has changed then
	then a transaction is made to create a new position and related assignment --->
	
	<cfparam name="form.ForceAmend" default="0">	
	
	<cfquery name="Assignment" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 SELECT   *
		 FROM     PersonAssignment
		 WHERE    PositionNo = '#Form.PositionNo#'
		 <!--- the below are the new dates and the system needs to know if it needs
		  to change the incumbency --->
		 AND      DateEffective  <= #END# 
		 AND      DateExpiration >= #STR#
		 AND      AssignmentStatus IN ('0','1') 
		 ORDER BY DateExpiration DESC
	</cfquery>		
		
		<cfif Check.PositionStatus eq "1" and form.ForceAmend eq "0">	
			
		    <!--- 1 --->		
						
			<cfif Check.OrgUnitOperational neq Form.OrgUnit 
			      OR Check.LocationCode    neq loc  
				   
				   <!--- OR Check.PostGrade neq Form.PostGrade OR Check.LocationCode neq loc OR  Check.PostClass neq Form.PostClass) --->
				   
				  OR Form.DateEffective    neq Form.DateEffectiveOld 
				  OR Form.DateExpiration   neq Form.DateExpirationOld>
				 								
				  <cfif Assignment.DateExpiration gt END>
					 <cf_alert message = "Problem : The assignment enddate (#dateformat(Assignment.DateExpiration,CLIENT.DateFormatShow)#) exceeds the period expiration: #dateformat(END,CLIENT.DateFormatShow)# for the entity that will accomodate this position. You first have to adjust the assignment end date before you can make this amendment." return = "back">
		 		     <cfabort>
				  </cfif>		
				  
				   <cfif Assignment.DateEffective gt END>
					 <cf_alert message = "Problem : The assignment effective (#dateformat(Assignment.DateEffective,CLIENT.DateFormatShow)#) exceeds the period expiration: #dateformat(END,CLIENT.DateFormatShow)# for the entity that will accomodate this position. You first have to adjust the assignment end date before you can make this amendment." return = "back">
		 		     <cfabort>
				  </cfif>				
				  																	 
			      <!--- in case operational unit or function has changed and the effective date changed THEN transaction of
				  mandate has status 1 = approved --->										 
										 			 			   
				    <cfquery name="InsertPosition" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     INSERT INTO Position 
						         (PositionParentId,
								 Mission,
								 MandateNo,
								 PositionStatus, 
								 MissionOperational,
								 OrgUnitOperational,
								 OrgUnitAdministrative,
								 OrgUnitFunctional,
								 <cfif loc neq "">
								 LocationCode,
								 </cfif>
								 FunctionNo,
								 FunctionDescription,
								 PostGrade,
								 PostType,
								 PostClass,
								 PostAuthorised,
								 VacancyActionClass,					
								 DateEffective,
								 DateExpiration,
								 <cfif Parameter.SourcePostNumber eq "Position">
								 	SourcePostNumber,
								 </cfif>
								 SourcePositionNo,
								 OfficerUserId,
								 OfficerLastName,
								 OfficerFirstName,	
								 Remarks)
				      VALUES ('#Form.PositionParentId#',
						      '#PositionParent.Mission#',
					          '#Form.MandateNo#',
							  '1',
							  '#Form.MissionOperational#',
							  '#Form.OrgUnit#',
							  '#Form.OrgUnit1#',
							  '#Form.OrgUnit2#', 
							  <cfif loc neq "">
							  '#loc#',
							  </cfif>
							  '#Form.FunctionNo#',
							  '#Form.FunctionDescription#',
							  '#Form.PostGrade#',
							  '#Form.PostType#',
							  '#Form.PostClass#',
							  '#Form.PostAuthorised#',
							  <cfif Form.VacancyActionClass neq "">
							  '#Form.VacancyActionClass#',
							  <cfelse>
							  NULL,
							  </cfif>
							  #STR#,
							  #END#,
							  <cfif Parameter.SourcePostNumber eq "Position">
							 	'#Form.SourcePostNumber#',
							  </cfif>
							  '#Form.PositionNo#',
							  '#SESSION.acc#',
					    	  '#SESSION.last#',		  
						  	  '#SESSION.first#',
							  '#Form.Remarks#') 		
							  						  
				    </cfquery>
					
					 <cfquery name="Last" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					 	 SELECT   TOP 1 * 
						 FROM     Position
						 WHERE    PositionParentId = '#Form.PositionParentId#'
						 ORDER BY Created DESC
					 </cfquery>
					 
					<!--- process the workschedule of the position - remove it or carry it over to the new effective date/position ---> 
					 
					<cfinvoke component = "Service.Process.Employee.PositionAction"  
						   method           = "PositionWorkschedule" 
						   PositionNo       = "#Last.PositionNo#">	  
					
					<!--- also inherit the last position group added 11/11/2012 --->			
					
					<cfquery name="InsertPositionGroup" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					 
					       INSERT INTO PositionGroup 
						           (PositionNo,
							   	    PositionGroup,
								    Status,						
								    OfficerUserId,
								    OfficerLastName,
								    OfficerFirstName)
									
						   SELECT  '#Last.PositionNo#',
						            PositionGroup,
								    Status,						
								    OfficerUserId,
								    OfficerLastName,
								    OfficerFirstName	
										 
						   FROM     PositionGroup
						   
						   WHERE    Positionno = '#Form.PositionNo#'	
						   					   	   			    						  
				    </cfquery>				
					
					<cfoutput>
					
						<script language="JavaScript">	
						    try {			
							parent.opener.document.getElementById("curpos").value = "#last.PositionNo#"
							} catch(e) {}
						</script> 				
		
						<cfset url.id2 = Last.PositionNo>
									
					</cfoutput>
												
					<script>parent.Prosis.busy('no')</script> 
									
					<cfif generate eq "1">
					
						<cfquery name="InsertRemaining" 
					     datasource="AppsEmployee" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
					     INSERT INTO Position
						         (PositionParentId,
								 Mission,
								 MandateNo,
								 PositionStatus, 
								 MissionOperational, 
								 OrgUnitOperational,
								 OrgUnitAdministrative,
								 OrgUnitFunctional,
								 <cfif loc neq "">
								 LocationCode,
								 </cfif>
								 FunctionNo,
								 FunctionDescription,
								 PostGrade,
								 PostType,
								 PostClass,
								 PostAuthorised,
								 VacancyActionClass,
								 DateEffective,
								 DateExpiration,
								 <cfif Parameter.SourcePostNumber eq "Position">
								 	SourcePostNumber,
								 </cfif>
								 SourcePositionNo,
								 OfficerUserId,
								 OfficerLastName,
								 OfficerFirstName,	
								 Remarks)
					      VALUES ('#Form.PositionParentId#',
							      '#PositionParent.Mission#',
						          '#PositionParent.MandateNo#', 
								  '1',
								  '#PositionParent.Mission#',
								  '#PositionParent.OrgUnitOperational#',
								  '#Form.OrgUnit1#',
								  '#Form.OrgUnit2#',
								  <cfif loc neq "">
								  '#loc#',
								  </cfif>
								  '#Form.FunctionNo#',
								  '#Form.FunctionDescription#',
								  '#Form.PostGrade#',
								  '#Form.PostType#',
								  '#Form.PostClass#',
								  '#Form.PostAuthorised#',
								  <cfif Form.VacancyActionClass neq "">
							  		'#Form.VacancyActionClass#',
								  <cfelse>
								    NULL,
								  </cfif>
								  '#PSTR#', 
								  #PEND#,
								  <cfif Parameter.SourcePostNumber eq "Position">
								  	'#Form.SourcePostNumber#', 
								  </cfif>
								  '#Form.PositionNo#',
								  '#SESSION.acc#',
						    	  '#SESSION.last#',		  
							  	  '#SESSION.first#',
								  'Generated')
					    </cfquery>
						
						 <cfquery name="Last" 
					     datasource="AppsEmployee" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
						 	 SELECT TOP 1 * 
							 FROM   Position
							 WHERE  PositionParentId = '#Form.PositionParentId#'
							 ORDER BY Created DESC
						 </cfquery>
												
						<cfinvoke component = "Service.Process.Employee.PositionAction"  
						   method           = "PositionWorkschedule" 
						   PositionNo       = "#Last.PositionNo#">	   
				
					</cfif>
					
					<!--- correct the assignments for the position so they nicely map  --->
					
					<cfquery name="NewPosition" 
			         datasource="AppsEmployee" 
			         username="#SESSION.login#" 
			         password="#SESSION.dbpw#">
				    	 SELECT   PositionNo
						 FROM     Position
						 WHERE    PositionParentId = '#Form.PositionParentId#'
						 ORDER BY PositionNo DESC
			    	</cfquery>	
				
					<cfloop query="Assignment">
					
						<!--- create new assignments if the assignments fall into the new period --->	
						
						<cfset dateValue = "">
						<CF_DateConvert Value="#dateformat(DateEffective,CLIENT.DateFormatShow)#">
						<cfset ASTR = dateValue>
											
						<cfset dateValue = "">
						<CF_DateConvert Value="#dateformat(DateExpiration,CLIENT.DateFormatShow)#">
						<cfset AEND = dateValue>
						
						<cfif ASTR lt STR>
							<cfset ASTR = STR>
						</cfif>		
						
						<cfif AEND gt END>
							<cfset AEND = END>
						</cfif>				
						
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
							  ActionReference, 
							  Source, 
							  SourceId, 
							  SourcePersonNo, 							
							  Remarks,
							  OfficerUserId,
							  OfficerLastName,
							  OfficerFirstName)
						 SELECT PersonNo, 
								  '#NewPosition.PositionNo#', 
								  #ASTR#,
								  #AEND#,
								  '#Form.OrgUnit#', 
								  '#loc#', 
								  FunctionNo, 
								  FunctionDescription,
								  <!---
								  '#Form.FunctionNo#',
								  '#Form.FunctionDescription#',
								  --->
								  AssignmentStatus, 
								  AssignmentClass, 
				                  AssignmentType, 
								  Incumbency, 
								  ActionReference, 
								  Source, 
								  SourceId, 
								  SourcePersonNo, 
								  Remarks,
								  '#SESSION.acc#',
								  '#SESSION.last#',
								  '#SESSION.first#'
							FROM PersonAssignment
							WHERE AssignmentNo = '#Assignment.AssignmentNo#'  
					    </cfquery>
					
					</cfloop>
					
					<!--- update assignment --->
				 				
					<cfquery name="UpdateAssignment" 
				         datasource="AppsEmployee" 
				         username="#SESSION.login#" 
				         password="#SESSION.dbpw#">
				    	 UPDATE PersonAssignment
				    	 SET    DateExpiration = #STR#-1
				    	 WHERE  PositionNo     = '#Form.PositionNo#'
						 AND    DateExpiration >= #STR#
				    </cfquery>	
									
					<cfquery name="CleanAssignment" 
				         datasource="AppsEmployee" 
				         username="#SESSION.login#" 
				         password="#SESSION.dbpw#">
				    	 DELETE FROM PersonAssignment
				    	 WHERE  PositionNo     = '#Form.PositionNo#' 
						 AND    DateEffective > DateExpiration
				    </cfquery>					
					
					<!--- correction of the old position record or even to remove it --->
					
					<cfquery name="UpdatePosition" 
				         datasource="AppsEmployee" 
				         username="#SESSION.login#" 
				         password="#SESSION.dbpw#">
				    	 UPDATE Position
				    	 SET    DateExpiration = #STR#-1
				    	 WHERE  PositionNo = '#Form.PositionNo#' 
				    </cfquery>		
					
					<!--- reset possible link to events and clear invalid positions --->
					
					<cfquery name="getPosition" 
				         datasource="AppsEmployee" 
				         username="#SESSION.login#" 
				         password="#SESSION.dbpw#">
				    	 SELECT PositionNo 
						 FROM   Position
				    	 WHERE  PositionParentId = '#Get.PositionParentid#'
						 AND    DateExpiration < '#dateformat(get.DateEffective,client.datesql)#'  
				    </cfquery>		
					
					<cfloop query="getPosition">	
					
						<cfquery name="resetEvent" 
					         datasource="AppsEmployee" 
					         username="#SESSION.login#" 
					         password="#SESSION.dbpw#">
					    		UPDATE PersonEvent
							 	SET    PositionNo = '#NewPosition.PositionNo#'
							 	WHERE  PositionNo = '#PositionNo#'					
					    </cfquery>		
																
						<cfquery name="ClearPosition" 
					         datasource="AppsEmployee" 
					         username="#SESSION.login#" 
					         password="#SESSION.dbpw#">
					    	 DELETE FROM Position
					    	 WHERE  PositionNo = '#PositionNo#'					 
					    </cfquery>	
					
					</cfloop>					
																
																    
			<cfelse>		
					
			   <cfif Form.action eq "Loan" and 
			       Check.FunctionNo eq Form.FunctionNo AND
				   Check.OrgUnitOperational eq Form.OrgUnit AND
				   Check.LocationCode eq loc>
				 			 				   
			   	  <cf_alert message = "You have not loaned this position to different unit or function.\n\nOperation not supported."
				  return = "back">
				  <script>parent.Prosis.busy('no')</script> 
				  <cfabort>
			   
			   <!---  	
			   <cfelseif #Assignment.recordcount# gte '2'> 
			   
			   	  <cf_message message = "You are not allowed to make changes as there are currently two assignment registered for the period."
						  return = "back">
						  <cfabort>
			   --->
			   
			   <cfelse>
			   				   
			        <cfif STR lt END>
											
			   		<cfinclude template="PositionEditSubmitStandard.cfm">
					
					<cfelse>
					
						  <cf_alert message = "Effective date lies after the expiration date.\n\nOperation not supported.">
						  <script>parent.Prosis.busy('no')</script> 
						  <cfabort>
					
					</cfif>
			   
			   </cfif>
			
			</cfif>	 			
								
			<cfinclude template="PositionEditSubmitGroup.cfm">
			
				<!--- verify is position can be relinked --->
				
				<cfquery name="Check0" 
				    datasource="AppsEmployee" 
				    username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT   *
					FROM     Position
					WHERE    PositionParentId = '#Form.PositionParentId#' 		
					ORDER BY DateEffective
				</cfquery>
				
				<cfquery name="Check1" 
				    datasource="AppsEmployee" 
				    username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT   DISTINCT PositionParentId,
							 Mission,
							 MandateNo,
							 PositionStatus, 
							 MissionOperational,
							 OrgUnitOperational,
							 OrgUnitAdministrative,
							 OrgUnitFunctional,
							 LocationCode,
							 FunctionNo,
							 FunctionDescription,
							 PostGrade,
							 PostType,
							 PostClass,
							 PostAuthorised,
							 SourcePostNumber,
							 MIN(DateEffective) as DateEffective,
							 MAX(DateExpiration) as DateExpiration
					FROM     Position
					WHERE    PositionParentId = '#Form.PositionParentId#' 		
					GROUP BY PositionParentId,
							 Mission,
							 MandateNo,
							 PositionStatus, 
							 MissionOperational,
							 OrgUnitOperational,
							 OrgUnitAdministrative,
							 OrgUnitFunctional,
							 LocationCode,
							 FunctionNo,
							 FunctionDescription, 
							 PostGrade,
							 PostType,
							 PostClass,
							 PostAuthorised,
							 SourcePostNumber
				</cfquery>
										
				<cfif Check0.recordcount eq "2" and Check1.recordcount eq "1">
				
					<cfloop query="Check0">
					   <cfset "pos#CurrentRow#" = "#PositionNo#">
					</cfloop>
					
					<!--- effort to merge positions if really all is the same --->
								
					<cfquery name="Position" 
					    datasource="AppsEmployee" 
					    username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						UPDATE Position
						SET    DateEffective  = '#DateFormat(Check1.DateEffective,client.dateSQL)#',
						       DateExpiration = '#DateFormat(Check1.DateExpiration,client.dateSQL)#'
						WHERE  PositionNo = '#pos1#' 
					</cfquery>
					
					<cfquery name="Assignment" 
					    datasource="AppsEmployee" 
					    username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						UPDATE PersonAssignment
						SET    PositionNo = '#Pos1#'
						WHERE  PositionNo = '#pos2#'
					</cfquery>
															
					<cfquery name="Position" 
					    datasource="AppsEmployee" 
					    username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						DELETE Position
						WHERE  PositionNo = '#pos2#' 
					</cfquery>
					
					<cfset url.id2 = pos1>				
																		
				</cfif>	
						
			<cfoutput>	
			
			<cfif Parameter.SourcePostNumber eq "PositionParent">
			
					<cfquery name="UpdateParent" 
				         datasource="AppsEmployee" 
				         username="#SESSION.login#" 
				         password="#SESSION.dbpw#">
				    	 UPDATE PositionParent
				    	 SET    SourcePostNumber   = '#Form.SourcePostNumber#'
						 WHERE  PositionParentId   = '#Check.PositionParentId#' 
				    </cfquery>	
					
			</cfif>				
							
			<script>	
			     
				  try { 			    
				    parent.parent.opener.document.getElementById("reloadpos").value = '#url.id2#' 							  		 				
					parent.parent.opener.document.getElementById("refresh_#url.box#").click() 							
				  } catch(e) { parent.opener.history.go() }	
				  						
			</script>
						
			</cfoutput>		
												
		<cfelseif Check.PositionStatus eq "0" or form.forceamend eq "1">  <!--- changed to allow to make some changes --->
		
				<!--- NOTE : Dev correction for evelyn only to allow changes on the position
					
		        <cfif (Check.FunctionNo eq Form.FunctionNo OR
			       	   Check.OrgUnitOperational eq Form.OrgUnit OR
					   Check.PostGrade eq Form.PostGrade OR
					   Check.LocationCode eq loc OR
					   Check.PostClass eq Form.PostClass) 
						         OR
				  (Form.DateEffective eq Form.DateEffectiveOld 
				      OR Form.DateExpiration eq Form.DateExpirationOld)>
					 
					  <cfset allowed = "1">
					  
				--->	
				
				<cfif  (Form.DateEffective eq Form.DateEffectiveOld 
				      AND Form.DateExpiration eq Form.DateExpirationOld)>
					 
					  <!--- if period is the same we allow for changes --->
					  <cfset allowed = "1">  
					  
				<cfelse>
				
						<!--- if the last assignment enddate fals before WE
						ALLOW THIS NOW AS WELL 	4/5/2013 --->
				
					<cfif END gte Assignment.DateExpiration>					
					
						<!--- if the last assignment enddate lte new position enddaTE WE
						ALLOW THIS NOW AS WELL 	4/5/2013 --->
						 <cfset allowed = "1">  
						 
					<cfelse>	 
										
					  <cfset allowed = "0">
					  
				    </cfif>
				
				</cfif>	  
				
				<!--- in case of one assignment its is always allowed --->
							
				<cfif allowed eq "1">					
				 		 
				  <!--- all changes are considered changes on the inital entry --->
				 		 		  
				  <cfquery name="UpdateParent" 
				         datasource="AppsEmployee" 
				         username="#SESSION.login#" 
				         password="#SESSION.dbpw#">
	
				    	 UPDATE PositionParent
				    	 SET <!--- added by Dev to prevent resets --->
						 <cfif form.mission eq form.missionoperational>
						 	 OrgUnitOperational    = '#Form.OrgUnit#',  
							 </cfif>
						     OrgUnitAdministrative = '#Form.OrgUnit1#',
							 OrgUnitFunctional     = '#Form.OrgUnit2#',
						     PostGrade             = '#Form.PostGrade#',
							 <cfif Form.Classified eq "0">
								 ApprovalPostGrade     = '',
							 <cfelse>
								 ApprovalPostGrade     = '#Form.ApprovalPostGrade#',
							 </cfif>
							 ApprovalReference     = '#Form.ApprovalReference#',
							 FunctionNo            = '#Form.FunctionNo#',
							 FunctionDescription   = '#Form.FunctionDescription#',
							 PostType              = '#Form.PostType#',
							 <cfif Parameter.SourcePostNumber eq "PositionParent">
							 SourcePostNumber      = '#Form.SourcePostNumber#',
							 </cfif>
							 
							 <cfif PriorInstance.recordcount eq "0">  <!--- we are no rewriting it if there is a prior instance --->
							 DateEffective         = #STR#,
							 </cfif>
							 DateExpiration        = #END#
							 
				    	 WHERE PositionParentId = '#Check.PositionParentId#'
				    </cfquery>	
					
					<cfquery name="UpdateAssignment" 
			         datasource="AppsEmployee" 
			         username="#SESSION.login#" 
			         password="#SESSION.dbpw#">
				    	 UPDATE PersonAssignment
				    	 SET   <cfif form.mission eq form.missionoperational>
						        OrgUnit               = '#Form.OrgUnit#',
								</cfif>
						        FunctionNo            = '#Form.FunctionNo#',
							    FunctionDescription   = '#Form.FunctionDescription#'		    
						 WHERE  PositionNo = '#Form.PositionNo#'
						 
						 <!--- disabled as this code cause the full history of the assignments to be overwritten
						 26/10/2018 : Dev
				    	 WHERE PositionNo IN (SELECT PositionNo 
						                      FROM   Position 
											  WHERE  PositionParentId = '#Form.PositionParentId#')
						 --->
						 		  
				    </cfquery>	
					
					<!--- update the position --->					  
				    <cfinclude template="PositionEditSubmitStandard.cfm">
					<!--- update the group info --->
					<cfinclude template="PositionEditSubmitGroup.cfm">
					
					<cfoutput>
					
						<script>						     
							 	
							   try { 			    
							    parent.parent.opener.document.getElementById("reloadpos").value = '#url.id2#' 							  		 				
								parent.parent.opener.document.getElementById("refresh_#url.box#").click() 							
							  } catch(e) { parent.opener.history.go() }							  					  	
							 						  						  
						</script>
					
					</cfoutput>
									
				<cfelse>
							 
			 		  <cf_alert message = "You are not allowed to make changes as there are #Assignment.recordcount# assignments for this period.\n\nThis would mean you would implicitly also adjust the prior assignment information, try updating the parent position instead."
				 		 return = "back">
							  
			   			<cfabort>
						
				</cfif>		
		
			</cfif>
			
			</cftransaction>
			
	</cfif>	
		
	<cfoutput>

	<script>
		parent.ptoken.location('PositionEdit.cfm?id=#url.id#&id1=#url.id1#&id2=#url.id2#&mode=read')	
		parent.Prosis.busy('no')
	</script> 
	
	</cfoutput>

