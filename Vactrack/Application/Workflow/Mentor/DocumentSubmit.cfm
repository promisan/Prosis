
<!--- withdraw script --->

<cfparam name="Form.Mentor" default="">

<cfif Form.Mentor neq "">
	
	<cfquery name="reset" 
	 datasource="AppsSelection" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 DELETE FROM ApplicantMentor
		 WHERE DocumentNo = '#Form.Key1#'	
	</cfquery>
	
	<cfif Form.Mentor neq "">
	
		<cfquery name="Insert" 
			 datasource="AppsSelection" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 INSERT INTO ApplicantMentor
			 (Personno,MentorPersonNo,DateEffective,DocumentNo,OfficerUserid,OfficerLastName,OfficerFirstName)
			 VALUES
			 ('#Form.Key2#',
			  '#Form.Mentor#',
			  '#dateformat(now(),client.dateformatshow)#',
			  '#Form.Key1#',
			  '#session.acc#',
			  '#session.last#',
			  '#session.first#')	
			</cfquery>	
	
	</cfif>

</cfif>

