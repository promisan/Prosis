
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfif url.act eq "add"> 

		<cfquery name="Insert" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO ApplicantMission
		         (Applicantno,
					 Mission,
					 Status,
					 Source,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
		  VALUES ('#url.app#',
		          '#url.mis#', 
				  '1',
				   'Manual',
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')
		</cfquery>
	           
</cfif>

<cfif url.act eq "del"> 
		
	<cfquery name="Delete" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM ApplicantMission
		WHERE  ApplicantNo = '#url.app#'
		AND    Mission = '#url.mis#'		
	</cfquery>	
		
</cfif>	


<cfoutput>

<script language="JavaScript">
   
 	 window.location = "ApplicantMission.cfm?id=#url.id#&mode=edit"
        
</script>  

</cfoutput>
