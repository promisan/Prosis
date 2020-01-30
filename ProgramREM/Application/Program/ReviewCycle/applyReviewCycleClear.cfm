
<!--- from workflow --->
<cfparam name="Object.ObjectKeyValue4" default="">

<cfparam name="attributes.reviewId" default="#Object.ObjectKeyValue4#">

<!--- apply project review cancellation --->

<!--- set actionstatus = 9 --->

	<cfquery name="get" 
	  datasource="AppsProgram" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	     SELECT * FROM ProgramPeriodReview		 
		 WHERE  ReviewId = '#attributes.ReviewId#'		
	</cfquery>

	<cfquery name="resetProgram" 
	  datasource="AppsProgram" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	     UPDATE ProgramPeriodReview
		 SET    ActionStatus = '3'
		 WHERE  ReviewId = '#attributes.ReviewId#'		
	</cfquery>

	<!--- make a full snapshot --->	
	
	<cfinvoke component = "Service.Process.Program.ProgramAllotment"  
	   method           = "RequirementSnapshot" 
	   ReviewId         = "#attributes.reviewId#">	   
		
	

	  