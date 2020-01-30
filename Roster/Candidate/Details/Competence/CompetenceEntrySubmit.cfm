
<cfparam name="FORM.FieldId" default="">

<cfinclude template="../SubmissionSubmit.cfm">

<cfquery name="Clear" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">	
	DELETE FROM ApplicantCompetence
	WHERE ApplicantNo = '#appno#'
</cfquery>

<!--- add background fields level, geo, exp after identifying the assigned serialNo --->
 
<cfloop index="Item" 
        list="#Form.FieldId#" 
        delimiters="' ,">
		
	<cfquery name="InsertCompetence" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO dbo.[ApplicantCompetence] 
	         (ApplicantNo,
			 CompetenceId,
			 Status,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName,
	    	 Created)
	  VALUES ('#AppNo#', 
	          '#Item#',
			  '0',
			  '#SESSION.acc#',
			  '#SESSION.last#',
			  '#SESSION.first#', 
			  getdate())
     </cfquery>
		  
</cfloop>	


<!--- no needed 

<cfoutput>
	<script language="JavaScript">		    
		ptoken.location("../General.cfm?source=#url.source#&ID=#PersonNo#&ID2=#URL.ID2#&Topic=#URL.Topic#")		  
	</script>	
</cfoutput>  

--->

