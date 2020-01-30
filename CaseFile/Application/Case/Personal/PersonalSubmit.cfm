
<cfquery name="Check" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  ClaimPerson
		WHERE ClaimId = '#url.Claimid#'	
</cfquery>

<cfif Check.recordcount eq "0">
	
	   <cfquery name="InsertClaim" 
     datasource="AppsCaseFile" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO ClaimPerson
         (ClaimId,
		 #url.field#,		
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName)
      VALUES ('#URL.ClaimId#',
          '#url.value#',
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#')
	  </cfquery>	

<cfelse>

		 <cfquery name="UpdateClaim" 
	     datasource="AppsCaseFile" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 UPDATE ClaimPerson
		 SET    #url.field#= '#url.value#'
	     WHERE  ClaimId = '#URL.ClaimID#' 
	     </cfquery>
	
</cfif>	


<cfoutput>
Saved on #timeformat(now(),"HH:MM:SS")#
</cfoutput>
	