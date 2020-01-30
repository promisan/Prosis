
 <cfquery name="Search" 
	    datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT * 
		FROM   RosterSearch
		WHERE  SearchId = '#url.ID#'		
</cfquery>

<cfparam name="Form.TopicStatus" type="any" default="AND">

    <cfquery name="Clean" 
	    datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        DELETE FROM RosterSearchLine
		WHERE  SearchId = '#URL.ID#'
		AND    (SearchClass = 'SelfAssessmentOperator' OR SearchClass = 'SelfAssessment')
	</cfquery>
		 
	<!--- ---------------------- ---> 		
	<!--- insert keyword entries --->
	<!--- ---------------------- --->
	
	<cfquery name="Master" 
	    datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT * FROM Ref_Topic		
		WHERE  ValueClass = 'List'  <!--- Parent = 'Miscellaneous' --->
		AND    Operational = 1
		AND    Topic IN (SELECT Topic FROM Ref_TopicOwner WHERE Owner = '#url.owner#' AND Operational = 1)		
	</cfquery>
		
	<cfloop query="Master">
	
	<cfparam name="FORM.value_#Topic#" default="">
    <cfset value     = Evaluate("FORM.value_" & #Topic#)>
		
		<cfif value neq "">
			 		
			<cfquery name="InsertExperience" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO RosterSearchline 
			         (Searchid,
					 SearchClass,
					 SelectId,
					 SelectParameter,
					 SelectDescription,
					 SearchStage)
			  VALUES ('#URL.id#', 
			          'SelfAssessment',
			          '#topic#',
			      	  '#value#',
					  '#Description# - #value#',
					  '5')
	    	  </cfquery>
				  
  		</cfif>			  
		
	</cfloop>	
		
<cfoutput>
<script>    
	ColdFusion.navigate('Topic/Topic.cfm?ID=#URL.ID#&owner=#url.owner#','topic')
	ColdFusion.Window.hide('topicdialog')	
</script>
</cfoutput>
