
<!--- set participation to a review --->

<cfif url.reviewid eq "">

	<cfquery name="getCycle"
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  *
			FROM    Ref_ReviewCycle
			WHERE   CycleId = '#url.Cycleid#'				
	</cfquery>		
	
	<cfset go = "1">
		
	<cfif getCycle.enableMultiple eq "0">
	
	<!--- we are first checking if the program has not already a cycle 
	defined --->
	
	<cfquery name="check"
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT     *
			FROM       ProgramPeriodReview
			WHERE      ProgramCode   = '#url.ProgramCode#'
			AND        Period        = '#url.period#'
			AND        ReviewCycleId = '#url.CycleId#'			
		</cfquery>
		
		<cfif check.recordcount gte "1">
		
				<cfset go = "0">
				
				<cfset url.reviewid = check.reviewId>	
		
		</cfif>
			
	</cfif>
	
	<cfif go eq "1">

		<cf_assignid>
			
		<cfquery name="InsertProgram" 
		  datasource="AppsProgram" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		     INSERT INTO ProgramPeriodReview
			        (ReviewId,
					 ProgramCode,
					 Period,
					 ReviewCycleId,
					 ActionStatus,
					 EntityClass,    	 
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
		   	 VALUES ('#rowguid#',
			         '#url.ProgramCode#',
				     '#url.Period#',
					 '#url.CycleId#',
					 '0',
					 '#getCycle.EntityClass#',
			    	 '#SESSION.acc#',
			  		 '#SESSION.last#',		  
				  	 '#SESSION.first#')
		</cfquery>
	
		<cfset url.reviewid = rowguid>	
		
	</cfif>	

<cfelseif url.status eq "1">

	<!--- reset status and remove workflow --->

	<cfquery name="resetdocument"
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE   ProgramPeriodReview
			SET      ActionStatus = '0'
			WHERE    ReviewId     = '#url.reviewid#'			
	</cfquery>
	
<cfelseif url.status eq "8">

	<!--- reset status and remove workflow --->

	<cfquery name="resetdocument"
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE   ProgramPeriodReview
			SET      ActionStatus = '8'
			WHERE    ReviewId     = '#url.reviewid#'						
	</cfquery>
	
	<cfquery name="resetworkflow"
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE   OrganizationObject
			SET      Operational = '0'
			WHERE    ObjectKeyValue4  = '#url.reviewid#'			
	</cfquery>
	
</cfif>

<cfquery name="getTopics"
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Ref_ReviewCycleProfile
		WHERE   CycleId = '#url.Cycleid#'
		AND     Operational = 1			
</cfquery>	

<cfloop query="getTopics">
	
	<cfquery name="check"
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     *
		FROM       ProgramPeriodReviewProfile
		WHERE      ReviewId     = '#url.reviewid#'
		AND        TextAreaCode = '#textareacode#'
	</cfquery>
	
	<cfif check.recordcount eq "0">
	
		<cfquery name="InsertProgram" 
	      datasource="AppsProgram" 
	      username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
		     INSERT INTO ProgramPeriodReviewProfile
			        (ReviewId,
					 TextAreaCode,					 	 
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
		   	 VALUES ('#url.reviewid#',
			         '#TextAreaCode#',				    
			    	 '#SESSION.acc#',
			  		 '#SESSION.last#',		  
				  	 '#SESSION.first#')
	    </cfquery>
		
	</cfif>

</cfloop>

<cfoutput>
<script>
   window.location = "ReviewCycleView.cfm?reviewid=#url.reviewid#&cycleid=#url.cycleid#"
</script>
</cfoutput>