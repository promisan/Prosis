
<cfparam name="Form.Operational"        default="0">
<cfparam name="Form.SkillCode"          default="">
<cfparam name="Form.SkillDescription"   default="">
<cfparam name="Form.ListOrder"          default="">
<cfparam name="Form.Owner"              default="">

<cfif URL.SkillCode neq "new">

	 <cfquery name="Update" 
		  datasource="AppsSelection" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE Ref_Assessment
		  SET    Operational         = '#Form.Operational#',
 		         SkillDescription    = '#FORM.SkillDescription#',
				 ListingOrder        = '#Form.ListingOrder#'
		  WHERE  SkillCode           = '#URL.SkillCode#'
		   AND   Owner               = '#URL.Owner#' 		   
		   AND   AssessmentCategory  = '#URL.Code#' 
	</cfquery>
		
	<cfset url.skillcode = "">
				
<cfelse>
			
	<cfquery name="Exist" 
	    datasource="AppsSelection" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT  *
		  FROM  Ref_Assessment 
		 WHERE  SkillCode            = '#Form.SkillCode#'
		   AND  Owner               = '#Form.Owner#' 		   
		   AND  AssessmentCategory  = '#URL.Code#' 
		
	</cfquery>
	
	<cfif Exist.recordCount eq "0">
		
			<cfquery name="Insert" 
			     datasource="AppsSelection" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO Ref_Assessment
			         (AssessmentCategory,
					 SkillCode,
					 SkillDescription,
					 Owner,					
					 ListingOrder,
					 Operational)
			      VALUES ('#URL.Code#',
				      '#Form.SkillCode#',
					  '#Form.SkillDescription#',
					  '#Form.Owner#',
					  '#Form.ListingOrder#',
			      	  '#Form.Operational#')
			</cfquery>
			
	<cfelse>
			
		<script>
		<cfoutput>
		alert("Sorry, but #Form.SkillCode#/#Form.Owner# already exists")
		</cfoutput>
		</script>
				
	</cfif>		
	
	<cfset url.skillcode = "new">
			   	
</cfif>

<cfoutput>
  <script>
  	ColdFusion.navigate('RecordListingDelete.cfm?code=#url.code#','del_#url.code#')
    ColdFusion.navigate('List.cfm?Code=#URL.Code#&skillcode=#url.skillcode#','#url.code#_list')	
  </script>	
</cfoutput>

