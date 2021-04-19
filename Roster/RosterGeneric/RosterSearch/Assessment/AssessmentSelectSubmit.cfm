
 <cfquery name="Search" 
	    datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT * 
		FROM   RosterSearch
		WHERE  SearchId = '#url.ID#'		
	</cfquery>

<cfif url.source neq "">

<cfparam name="Form.Assessed#URL.source#Status" type="any" default="AND">

    <cfquery name="Clean" 
	    datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        DELETE FROM RosterSearchLine
		WHERE  SearchId = '#URL.ID#'
		AND    SearchClass IN ('Assessed#URL.Source#','Assessed#URL.Source#Operator')
	</cfquery>

	<!--- removed 22/8/2009 
	
		<cfparam name="Form.AssessedSkillStatus" type="any" default="AND">
		<cfset Status  = Evaluate("FORM.Assessed#URL.source#Status")>
		
		<!--- operator --->
			
		<cfquery name="Insert" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO RosterSearchLine
			     (SearchId,
				 SearchClass,
				 SelectId, SelectDescription, SearchStage) 
		    VALUES ('#URL.ID#',
			       'Assessed#URL.source#Operator', 
		          '#Status#','#Status#','5')
		 </cfquery>
	 
	 
	--->
	 		
	<!--- insert keyword entries --->

    <cfparam name="Form.FieldId" default="">
	
	<cfset FieldId     = Evaluate("FORM.FieldId")>
		
	<cfloop index="Item" 
	        list="#FieldId#" 
	        delimiters="' ,">
						
		<cfquery name="Check" 
	     datasource="AppsSelection" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT * 
		 FROM   RosterSearchLine
		 WHERE  SearchId = '#URL.ID#'
		  AND   SearchClass = 'Assessed#URL.source#'
		  AND   SelectId = '#Item#' 
	    </cfquery>
		
		<cfquery name="Description" 
	     datasource="AppsSelection" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT * 
		 FROM   Ref_Assessment
		 WHERE  Owner = '#Search.Owner#'
		  AND   SkillCode = '#item#'		
	    </cfquery>
		
		<cfif Check.recordcount eq "0">
		
					<cfquery name="Insert" 
		     datasource="AppsSelection" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO RosterSearchLine
		         (SearchId,
				 SearchClass,
				 SelectId, SelectDescription, SearchStage)
		      VALUES ('#URL.ID#',
			       'Assessed#URL.source#', 
		          '#Item#',
				  '#Description.skilldescription#',
				  '5')
		    </cfquery>
			
		<cfelse>
		
		 	<cfquery name="Update" 
			 datasource="AppsSelection" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
		     UPDATE RosterSearchLine
			 SET    SearchStage  = '5'
			 WHERE  SearchId   = '#URL.ID#'
			 AND    SearchClass  = 'Assessed#URL.source#'
			 AND    SelectId     = '#Item#'
			</cfquery>
					
		</cfif>
	
	</cfloop>	
	
</cfif>

<cfoutput>
<script>    
	ptoken.navigate('Assessment/Assessment.cfm?ID=#URL.ID#','skill')
	ProsisUI.closeWindow('assessmentdialog')	
</script>
</cfoutput>
