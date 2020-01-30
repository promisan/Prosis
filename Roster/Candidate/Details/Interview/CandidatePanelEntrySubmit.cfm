<cftransaction>

    <cfquery name="DeletePanel" 
		datasource="appsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM ApplicantInterviewpanel
		WHERE InterviewId = '#URL.InterviewId#'
	</cfquery>
		
	<cfloop index="row" from="1" to="#Form.Row#">
	
		<cfparam name="FORM.PersonNo_#row#" default="">

		<cfset personNo  =   Evaluate("FORM.PersonNo_#row#")>
		<cfset memo      =   Evaluate("FORM.PanelMemo_#row#")>
		
		<cfif personNo neq "">
		
		     <cftry>
		
			 <cfquery name="InsertPanel" 
				datasource="appsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO ApplicantInterviewpanel
					 (PersonNo,
					  InterviewId,		  
					  PanelPersonno,
					  PanelMemo)
				  VALUES ('#URL.PersonNo#',		  
						  '#URL.InterviewId#',
						  '#personNo#',
						  '#memo#')
			</cfquery>
			
			<cfcatch></cfcatch>
			
			</cftry>
		
		</cfif>
		
	</cfloop>
			
</cftransaction>	
			
<script>
	window.close()
	opener.history.go()
</script>	
