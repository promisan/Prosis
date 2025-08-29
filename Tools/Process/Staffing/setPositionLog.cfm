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
<cfparam name="attributes.PositionNo" default="">
<cfparam name="attributes.Mode"       default="Prepare">
<cfparam name="attributes.serialno"   default="0">

<cfswitch expression="#attributes.Mode#">

	<cfcase value="Prepare">
	
		<cfquery name="Last" 
	         datasource="AppsEmployee" 
	         username="#SESSION.login#" 
	   	     password="#SESSION.dbpw#">
	    	 SELECT SerialNo 
			 FROM   PositionLog
			 WHERE  PositionNo = '#attributes.PositionNo#'
			 ORDER BY SerialNo DESC
	   	</cfquery>	 	  
		
		<cfif last.SerialNo eq "">
		
			<cfquery name="getPosition" 
	         datasource="AppsEmployee" 
	         username="#SESSION.login#" 
	   	     password="#SESSION.dbpw#">
	    	 SELECT * 
			 FROM   Position
			 WHERE  PositionNo = '#attributes.PositionNo#'
			</cfquery>
				
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
				  LocationCode,		
				  FunctionNo,
				  FunctionDescription,
				  PostType,
				  PostClass,
				  PostAuthorised,
				  VacancyActionClass,
				  SourcePostNumber,
				  DisableLoan,
				  OfficerUserId, 
				  OfficerLastName,
				  OfficerFirstName,
				  Created
				  )
				 VALUES 
				 (
				 '#attributes.PositionNo#',
				 '1',
				 '#getPosition.DateEffective#',
				 '#getPosition.DateExpiration#',
				 '#getPosition.PostGrade#',
				 '#getPosition.LocationCode#',
				 '#getPosition.FunctionNo#',
				 '#getPosition.FunctionDescription#',
				 '#getPosition.PostType#',
				 '#getPosition.PostClass#',
				 '#getPosition.PostAuthorised#',
				 '#getPosition.VacancyActionClass#',
				 '#getPosition.SourcePostNumber#',
				 '#getPosition.DisableLoan#',
				 '#getPosition.OfficerUserId#',
				 '#getPosition.OfficerLastName#',
				 '#getPosition.OfficerFirstName#', 
				 '#getPosition.created#'
				 )		
	        </cfquery>	
		  		
		    <cfset no = 2>
		   
		<cfelse>
		
		   <cfset no = last.serialno+1>
		   
		</cfif>
		
		<CFSET Caller.serialno = no>	
		
	</cfcase>

	<cfcase value="Log">
	
		<cfquery name="getPosition" 
         datasource="AppsEmployee" 
         username="#SESSION.login#" 
   	     password="#SESSION.dbpw#">
    	 SELECT * 
		 FROM   Position
		 WHERE  PositionNo = '#attributes.PositionNo#'
		</cfquery>
		
		<cfquery name="checkLog" 
	         datasource="AppsEmployee" 
	         username="#SESSION.login#" 
    	     password="#SESSION.dbpw#">
	    	 SELECT  *
			 FROM    PositionLog
			 WHERE   PositionNo = '#attributes.PositionNo#'
			 AND     SerialNo   = '#attributes.SerialNo#'
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
				  LocationCode,		
				  FunctionNo,
				  FunctionDescription,
				  PostType,
				  PostClass,
				  PostAuthorised,
				  VacancyActionClass,
				  SourcePostNumber,
				  DisableLoan,
				  OfficerUserId, 
				  OfficerLastName,
				  OfficerFirstName
				  )
				 VALUES 
				 (
				 '#attributes.PositionNo#',
				 '#attributes.SerialNo#',
				 '#getPosition.DateEffective#',
				 '#getPosition.DateExpiration#',
				 '#getPosition.PostGrade#',
				 '#getPosition.LocationCode#',
				 '#getPosition.FunctionNo#',
				 '#getPosition.FunctionDescription#',
				 '#getPosition.PostType#',
				 '#getPosition.PostClass#',
				 '#getPosition.PostAuthorised#',
				 '#getPosition.VacancyActionClass#',
				 '#getPosition.SourcePostNumber#',
				 '#getPosition.DisableLoan#',				 
				 '#SESSION.acc#',
				 '#SESSION.last#',
				 '#SESSION.first#'
				 )		
	        </cfquery>	
			
		</cfif>	
				
	</cfcase>

</cfswitch>



