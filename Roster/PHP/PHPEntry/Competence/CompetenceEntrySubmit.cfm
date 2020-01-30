<TITLE>Submit Experience</TITLE>
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<!--- verify if a submission record exists --->

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
		  #now()#)</cfquery>
		  
</cfloop>	

<cfoutput>
	<script language="JavaScript">
	<cf_tl id="Competencies have been saved" var="1">
	alert("#lt_text#.")
	window.location =  "../General.cfm?ID=#PersonNo#&ID2=#URL.ID2#&Topic=#URL.Topic#"		  
	</script>	
</cfoutput>  

