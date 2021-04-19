
<cfquery name="ParentList" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM Ref_ExperienceParent
		WHERE SearchEnable = 1
		AND Parent IN (SELECT Parent 
		               FROM Ref_ExperienceParent 
					   WHERE Area = '#URL.Area#')
		ORDER BY SearchOrder
</cfquery>
	
<cfloop query="ParentList">
	
	<cfquery name="Delete" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     DELETE FROM RosterSearchLine
	 WHERE SearchId = '#URL.ID#'
	  AND SearchClass IN ('#Parent#','#Parent#Operator')	 
    </cfquery>		
	
	<cfparam name="Form.#Parent#Status" type="any" default="">
	<cfset Status  = Evaluate("FORM."&#Parent#&"Status")>
			
	<cfquery name="Insert" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO RosterSearchLine
			     (SearchId,
				 SearchClass,
				 SelectId, SelectDescription, SearchStage)
	        VALUES ('#URL.ID#',
			       '#Parent#Operator', 
		          '#Status#','#Status#','5')
	 </cfquery>
	 
	<!--- insert keyword entries --->

    <cfparam name="Form.#Parent#FieldId" default="">
	
	<cfset FieldId = Evaluate("FORM.#Parent#FieldId")>
		
	<cfoutput>#fieldid#</cfoutput>	
			
	<cfloop index="Item" 
	        list="#FieldId#" 
	        delimiters="' ,">
			
			<cftry>
			
			<cfquery name="Insert" 
		     datasource="AppsSelection" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO RosterSearchLine
		         (SearchId,
				 SearchClass,
				 SelectId, SearchStage)
		      VALUES ('#URL.ID#',
			       '#Parent#', 
		          '#Item#','5')
		    </cfquery>
			
			<cfcatch></cfcatch>
			
			</cftry>
				
	</cfloop>	
		
	<!--- update from database --->
		
	<cfquery name="Update" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     UPDATE RosterSearchLine
		 SET    SelectDescription = S.Description
		 FROM   RosterSearchLine INNER JOIN Ref_Experience S ON RosterSearchLine.SelectId =  S.ExperienceFieldId 
		 WHERE  RosterSearchLine.SearchId = '#URL.ID#'
		 AND    RosterSearchLine.SearchClass = '#Parent#'
    </cfquery>
		
</cfloop>	

<cfoutput>
<script>    
	ptoken.navigate('Search4Detail.cfm?id=#url.id#','profile')
	ProsisUI.closeWindow('keyworddialog')	
</script>
</cfoutput>

