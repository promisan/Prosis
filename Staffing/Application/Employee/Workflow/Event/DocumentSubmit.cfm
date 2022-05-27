

<cftransaction>

<cfquery name="Event" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM   PersonEvent
WHERE    EventId    = '#Object.ObjectKeyvalue4#'
</cfquery>

	<cfif event.recordcount eq "1">
	
	    <cfparam name="Form.DateExpiration100" default="01/01/2000">
	
		<cfset dateValue = "">
		<CF_DateConvert Value="#Form.DateExpiration100#">
		<cfset END = dateValue>
	
	<!--- Identify the 100% record : last record and 
	    we check for the last record and then see if it matches the position & person --->
			
		<cfquery name="get" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		  	 SELECT   TOP 1 *
			 FROM     PersonAssignment PA INNER JOIN Position P ON PA.PositionNo = P.PositionNo
			 WHERE    PersonNo = '#event.PersonNo#'
			 AND      MissionOperational  = '#event.Mission#'		 
			 AND      AssignmentStatus IN ('0','1')
			 AND      Incumbency = '100'
		  	 ORDER BY PA.DateEffective DESC
		</cfquery>		
	
		<cfif get.PositionNo eq event.PositionNo AND get.DateExpiration lt end>
			
			<cfquery name="UpdateAssignment" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			  	 UPDATE PersonAssignment
			  	 SET    DateExpiration  = #END#		
			  	 WHERE  AssignmentNo    = '#get.AssignmentNo#'
			</cfquery>	
					
		    <!--- update the table PersonAssignmentAction --->
			
			<cfset maction = "Assignment extension from: #dateformat(get.DateExpiration,client.dateformatshow)# to: #dateformat(end,client.dateformatshow)#">	
			
			<cfquery name="setdata" 
			   datasource="AppsEmployee" 
		       username="#SESSION.login#" 
		       password="#SESSION.dbpw#">
			   INSERT INTO PersonAssignmentAction	
			          (PersonNo, 
					   PositionNo, 
					   AssignmentNo, 
					   EventId,
					   ActionCode, 
					   ActionMemo, 
					   OfficerUserId, OfficerLastName, OfficerFirstName)
					   
			   VALUES ('#get.PersonNo#',
			           '#get.PositionNo#',
					   '#get.AssignmentNo#',					   
					   '#Object.ObjectKeyvalue4#',
					   'Event',
					   '#maction#',
	     			   '#session.acc#',
					   '#session.last#',
					   '#session.first#')	       
			</cfquery> 		  
		
		</cfif>	
		
		
	    <cfparam name="Form.DateExpiration0" default="01/01/2000">
		
		<cfset dateValue = "">
		<CF_DateConvert Value="#Form.DateExpiration0#">
		<cfset END = dateValue>
		
		<cfquery name="get" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		  	 SELECT   TOP 1 *
			 FROM     PersonAssignment
			 WHERE    PersonNo = '#event.PersonNo#'
			 AND      AssignmentStatus IN ('0','1')
			 AND      DateExpiration > getDate()
			 AND      Incumbency = '0'
		  	 ORDER BY DateEffective DESC
		</cfquery>	
		
		<cfif get.DateExpiration gte now() AND get.DateExpiration lt end>	
		
			<cfquery name="UpdateAssignment" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			  	 UPDATE PersonAssignment
			  	 SET    DateExpiration  = #END#		
			  	 WHERE  AssignmentNo    = '#get.AssignmentNo#'
			</cfquery>	
			
			<cfset maction = "Contract extension event #dateformat(end,client.dateformatshow)#">	
					
			<!--- update the table PersonAssignmentAction --->
			
			<cfquery name="setdata" 
			   datasource="AppsEmployee" 
		       username="#SESSION.login#" 
		       password="#SESSION.dbpw#">
			   INSERT INTO PersonAssignmentAction	
			          (PersonNo, 
					   PositionNo, 
					   AssignmentNo, 
					   EventId,
					   ActionCode, 
					   ActionMemo, 
					   OfficerUserId, OfficerLastName, OfficerFirstName)
					   
			   VALUES ('#get.PersonNo#',
			           '#get.PositionNo#',
					   '#get.AssignmentNo#',					   
					   '#Object.ObjectKeyvalue4#',
					   'Event',
					   '#maction#',
	     			   '#session.acc#',
					   '#session.last#',
					   '#session.first#')	       
			</cfquery> 	
		
		</cfif>
		
	</cfif>	

</cftransaction>
   