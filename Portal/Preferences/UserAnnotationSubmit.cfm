
<cfparam name="Form.Operational"    default="0">
<cfparam name="Form.Description"    default="">
<cfparam name="Form.ListingOrder"   default="">
<cfparam name="Form.Color"          default="white">



<cfif URL.ID2 neq "new">

	 <cfquery name="Update" 
		  datasource="appsSystem" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE UserAnnotation
		  SET    Operational         = '#Form.Operational#',
 		         Description         = '#Form.Description#',
				 ListingOrder        = '#Form.ListingOrder#',
				 Color               = '#Form.Color#' 
		  WHERE  AnnotationId = '#URL.ID2#'
		   AND   Account = '#SESSION.acc#' 
	</cfquery>
		
	<cfset url.id2 = "">
				
<cfelse>
			
	<cfquery name="Insert" 
	     datasource="appsSystem" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     INSERT INTO UserAnnotation
	         (Account,
			 ListingOrder,
			 Description,						
			 Color,
			 Operational)
	      VALUES ('#SESSION.acc#',
		      '#Form.ListingOrder#',
			  '#Form.Description#',					
			  '#Form.Color#', 
	      	  '#Form.Operational#')
	</cfquery>
								
		
	<cfset url.id2 = "new">
			   	
</cfif>

<cfoutput>

 <cfinclude template="UserAnnotation.cfm">
  
</cfoutput>

