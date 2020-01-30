
<cfparam name="Form.Operational"        default="0">
<cfparam name="Form.Code"               default="">
<cfparam name="Form.Description"        default="">
<cfparam name="Form.ListingOrder"       default="0">

<cfif URL.Code neq "new">

	 <cfquery name="Update" 
		  datasource="AppsSelection" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE Ref_FunctionClassification
		  SET    Operational         = '#Form.Operational#',
 		         Description         = '#FORM.Description#',
				 ListingOrder        = '#Form.ListingOrder#'
		  WHERE  Code                = '#URL.Code#'		 	   
		   AND   ParentCode          = '#URL.ParentCode#' 
	</cfquery>
		
	<cfset url.code = "">
				
<cfelse>
			
	<cfquery name="Exist" 
	    datasource="AppsSelection" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT  *
		  FROM  Ref_FunctionClassification
		  WHERE  Code                = '#URL.Code#'		 	   
		   AND   ParentCode          = '#URL.ParentCode#' 
		
	</cfquery>
	
	<cfif Exist.recordCount eq "0">
		
			<cfquery name="Insert" 
			     datasource="AppsSelection" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO Ref_FunctionClassification
			         (ParentCode,
					 Code,
					 Description,
					 ListingOrder,
					 Operational)
			      VALUES (
				      '#URL.ParentCode#',
				      '#Form.Code#',
					  '#Form.Description#',					 
					  '#Form.ListingOrder#',
			      	  '#Form.Operational#'
					  )
			</cfquery>
			
	<cfelse>
			
		<script>
		<cfoutput>
		alert("Sorry, but #Form.Code# already exists")
		</cfoutput>
		</script>
				
	</cfif>		
	
	<cfset url.code = "new">
			   	
</cfif>


<cfoutput>
  <script>
    ColdFusion.navigate('RecordListingDelete.cfm?Code=#URL.ParentCode#','del_#url.parentcode#')	
    ColdFusion.navigate('List.cfm?ParentCode=#URL.ParentCode#&code=#url.code#','#url.parentcode#_list')	
  </script>	
</cfoutput>

