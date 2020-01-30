
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfif url.id1 eq ""> 
	
	<cfquery name="Verify" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_AddressType
		WHERE  Code  = '#Form.Code#' 
	</cfquery>

   <cfif Verify.recordCount eq "1">
   
	   <script language="JavaScript">   
		     alert("A record with this code has been registered already!")     
	   </script>  
  
   <cfelse>
	   
		<cfquery name="Insert" 
		datasource="appsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  INSERT INTO Ref_AddressType
		          (Code,
				   Description,
				   Selfservice,
				   ListingOrder,
				   OfficerUserId,
				   OfficerLastName,
				   OfficerFirstName)
		  VALUES  ('#Form.Code#',
		           '#Form.Description#', 
				   <cfif isDefined("Form.Selfservice")>1<cfelse>0</cfif>,
				   #Form.ListingOrder#,
				   '#SESSION.acc#',
		    	   '#SESSION.last#',		  
			  	   '#SESSION.first#')
		</cfquery>
		 
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
		                     action="Insert" 
							 content="#form#">
							 
		<script>
		    window.close()
			opener.location.reload()
		</script> 
		  
    </cfif>		  
           
<cfelse>
	
	<cfquery name="Update" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE 	Ref_AddressType
		SET   	Description = '#Form.Description#',
				Selfservice =  <cfif isDefined("Form.Selfservice")>1<cfelse>0</cfif>,
				ListingOrder = #Form.ListingOrder# 
		WHERE 	Code         = '#url.id1#'
	</cfquery>
	
	<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                     action="Update" 
						 content="#form#">
						 
						 
	<cfinclude template="AddressTypeMissionSubmit.cfm">
						 
	<script>
	    window.close()
		opener.location.reload()
	</script>  

</cfif>	
