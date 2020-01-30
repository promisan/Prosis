
<cfparam name="Form.Operational"        default="0">
<cfparam name="Form.action"               default="0">
<cfparam name="Form.Description"        default="">

<cfif URL.action eq "new">
			
	<cfquery name="Verify" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_ClaimTypeMission
		WHERE ClaimType = '#Form.ClaimType#' 
		AND Mission = '#Form.Mission#' 
	</cfquery>

    <cfif #Verify.recordCount# is 1>
   
	   <script language="JavaScript">
	   
	     alert("An record with this code has been registered already!")
	     
	   </script>  
  
   <cfelse>
   
		<cfquery name="Insert" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO Ref_ClaimTypeMission
			         (ClaimType,
					 Mission,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName,	
					 Created)
			  VALUES ('#Form.ClaimType#',  
			          '#Form.Mission#',
			   	      '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				      '#SESSION.first#',
				       getDate())
		  </cfquery>
		  
	</cfif>	  
		   	
</cfif>

<cfset url.id1 = "#Form.ClaimType#">
<cfset url.action = "view">
<cfinclude template="RecordMissionListingDetail.cfm">
