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
	<cfquery name="UpdatePosition1" 
         datasource="AppsEmployee" 
         username="#SESSION.login#" 
         password="#SESSION.dbpw#">
    	 UPDATE Position
    	 SET   OrgUnitOperational    = '#Form.OrgUnit#',  
		       PostGrade             = '#Form.PostGrade#',
			   FunctionNo            = '#Form.FunctionNo#',
			   FunctionDescription   = '#Form.FunctionDescription#',
			   <cfif loc neq "">
			   LocationCode          = '#loc#',
			   </cfif>
			   MissionOperational    = '#Form.MissionOperational#', 
		       OrgUnitAdministrative = '#Form.OrgUnit1#',
			   OrgUnitFunctional     = '#Form.OrgUnit2#',
    		   PostType              = '#Form.PostType#',
			   PostClass             = '#Form.PostClass#',
			   PostAuthorised        = '#Form.PostAuthorised#',
		       VacancyActionClass    = '#Form.VacancyActionClass#', 
			   <cfif Parameter.SourcePostNumber eq "Position">
			   SourcePostNumber      = '#Form.SourcePostNumber#',
			   </cfif>
			   DateEffective         = #STR#,
			   DateExpiration        = #END#,
			   Remarks               = '#Form.Remarks#' 
    	 WHERE PositionNo = '#Form.PositionNo#'		
    </cfquery>	
			
	<!--- log the change --->
	
	<cfif Check.PostGrade          neq Form.PostGrade OR 
	      Check.LocationCode       neq loc OR 
		  Check.PostClass          neq Form.PostClass OR
		  Check.PostType           neq Form.PostType OR
		  Check.PostAuthorised     neq Form.PostAuthorised OR
		  Check.VacancyActionClass neq Form.VacancyActionClass OR
		  Check.SourcePostNumber   neq Form.SourcePostNumber OR
		  Check.FunctionNo         neq Form.FunctionNo>	
		
		<!--- init the position log or pass the serialno --->		  
		<cf_setPositionLog PositionNo="#Form.PositionNo#" mode="Prepare">
		
		<cfquery name="checkLog" 
	         datasource="AppsEmployee" 
	         username="#SESSION.login#" 
    	     password="#SESSION.dbpw#">
	    	 SELECT  *
			 FROM    PositionLog
			 WHERE   PositionNo = '#Form.PositionNo#'
			 AND     SerialNo   = '#serialno#'
    	</cfquery>	 	 
		
		<cfif checklog.recordcount eq "0">
										  
			<cfquery name="LogPosition" 
		         datasource="AppsEmployee" 
		         username="#SESSION.login#" 
		         password="#SESSION.dbpw#">
			    	 INSERT INTO PositionLog
						 (PositionNo,
						  SerialNo,
						  DateEffective,
						  DateExpiration,
						  PostGrade,
						  <cfif loc neq "">
						  LocationCode,
						  </cfif>
						  FunctionNo,
						  FunctionDescription,
						  PostType,
						  PostClass,
						  PostAuthorised,
						  VacancyActionClass,
						  SourcePostNumber,
						  OfficerUserId, 
						  OfficerLastName,
						  OfficerFirstName )
					 VALUES ('#Form.PositionNo#',
							 '#serialno#',
							 #STR#,
							 #END#,
							 '#Form.PostGrade#',
							 <cfif loc neq "">
							 '#loc#',
							 </cfif>
							 '#Form.FunctionNo#',
							 '#Form.FunctionDescription#',
							 '#Form.PostType#',
							 '#Form.PostClass#',
							 '#Form.PostAuthorised#',
							 '#Form.VacancyActionClass#',
							 '#Form.SourcePostNumber#',
							 '#SESSION.acc#',
							 '#SESSION.last#',
							 '#SESSION.first#' )		
		      </cfquery>	
		  
		  </cfif>	
		  		  
    </cfif>	
	
	<cfquery name="Mandate" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 SELECT *
		 FROM   Organization.dbo.Ref_Mandate
		 WHERE  Mission            = '#Form.Mission#'
		 AND    MandateNo          = '#Form.MandateNo#'
	</cfquery>
	
	<cfif Mandate.MandateStatus eq "0">
	
	  <!--- adjust also the assignment record for change in orgunit and function during mandate status = 0 --->
	  
	   <cfquery name="CheckAssignment" 
         datasource="AppsEmployee" 
         username="#SESSION.login#" 
         password="#SESSION.dbpw#">
    	 SELECT *
		 FROM PersonAssignment
    	 WHERE  PositionNo = '#Form.PositionNo#'
    </cfquery>	
	
	<cfif CheckAssignment.recordcount eq "1">
		
		 <cfquery name="UpdateAssignment" 
	         datasource="AppsEmployee" 
	         username="#SESSION.login#" 
	         password="#SESSION.dbpw#">
	    	 UPDATE PersonAssignment
	    	 SET    OrgUnit               = '#Form.OrgUnit#',
			        FunctionNo            = '#Form.FunctionNo#',
				    FunctionDescription   = '#Form.FunctionDescription#',
			        DateEffective         = #STR#,
				    DateExpiration        = #END# 
	    	 WHERE  PositionNo = '#Form.PositionNo#'
			 AND    (DateEffective < #STR#  OR DateExpiration > #END#)
	    </cfquery>	
	
	</cfif>
	
</cfif>
	