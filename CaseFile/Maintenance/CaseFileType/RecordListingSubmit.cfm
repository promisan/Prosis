
<cfparam name="Form.Operational"        default="0">
<cfparam name="Form.Code"               default="0">
<cfparam name="Form.Description"        default="">

<cfif URL.code neq "new">

	 <cfquery name="Update" 
		  datasource="AppsCaseFile" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE Ref_ClaimType
		  SET    Operational         = '#Form.Operational#',
 		         Description         = '#Form.Description#' 
		  WHERE  Code = '#URL.code#'
	</cfquery>
				
<cfelse>
			
	<cfquery name="Exist" 
	    datasource="AppsCaseFile" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT  *
		FROM    Ref_ClaimType
		WHERE   Code = '#Form.Code#'  
	</cfquery>
	
	<cfif Exist.recordCount eq "0">
		
			<cfquery name="Insert" 
			     datasource="AppsCaseFile" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO Ref_ClaimType
			         (Code,
				     Description,
					 Operational,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
			      VALUES ('#Form.Code#',
					  '#Form.Description#',
			      	  '#Form.Operational#',
					  '#SESSION.acc#',
					  '#SESSION.last#',
					  '#SESSION.first#')
			</cfquery>
			
	<cfelse>
			
		<script>
		<cfoutput>
		<cf_tl id = "Sorry, but" var = "1">
		<cfset vSorry = lt_text>

		<cf_tl id = "already exists" var = "1">
		<cf_tl vAlready = "already exists" var = "1">
		
		alert("#vSorry# #Form.Code# #vAlready#")
		</cfoutput>
		</script>
				
	</cfif>		
		   	
</cfif>

<cfset url.code = "">
<cfinclude template="RecordListingDetail.cfm">
