
<!--- limit to relevant set --->

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



