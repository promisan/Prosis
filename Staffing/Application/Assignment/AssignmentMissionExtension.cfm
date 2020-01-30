
<cfparam name="Form.Extension" default="0">

   <cfif Form.Extension eq "1">

	<cfset dateValue = "">
	<cfif Form.DateExtension neq ''>
		<CF_DateConvert Value="#Form.DateExtension#">
		<cfset EXT = dateValue>
	<cfelse>
	    <cfset EXT = 'NULL'>	
	</cfif>		
			
	<cfif EXT gt MEND and END eq MEND>
	
		<cfquery name="CheckExtension" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM   PersonExtension 
			WHERE  PersonNo     = '#Form.PersonNo#'
			AND    Mission      = '#Form.Mission#' 
			AND    MandateNo    = '#Form.MandateNo#'
		</cfquery>
		
		<cfif CheckExtension.recordcount eq "0">
			
			<cfquery name="InsertExtension" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO PersonExtension 
				(PersonNo, 
				 Mission,
				 MandateNo,
				 ActionStatus,
				 DateExtension,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
				VALUES('#Form.PersonNo#',
				       '#Form.Mission#',
					   '#Form.MandateNo#',
					   '1',
					   #EXT#,
					   '#SESSION.acc#',
					   '#SESSION.last#',
					   '#SESSION.first#')
				</cfquery>
			
		<cfelse>
		
			<cfquery name="Update" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				UPDATE PersonExtension 
				SET DateExtension = #EXT#
				WHERE PersonNo     = '#Form.PersonNo#'
				AND   Mission      = '#Form.Mission#' 
				AND   MandateNo    = '#Form.MandateNo#'
			</cfquery>
		
		</cfif>	
	
	<cfelse>
	
		<cfquery name="CheckExtension" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM PersonExtension 
			WHERE PersonNo     = '#Form.PersonNo#'
			AND   Mission      = '#Form.Mission#' 
			AND   MandateNo    = '#Form.MandateNo#'
		</cfquery>
	
	</cfif>
	
	<cfelse>
	
	<cfquery name="CheckExtension" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM PersonExtension 
			WHERE PersonNo     = '#Form.PersonNo#'
			AND   Mission      = '#Form.Mission#' 
			AND   MandateNo    = '#Form.MandateNo#'
		</cfquery>
	  
 </cfif>