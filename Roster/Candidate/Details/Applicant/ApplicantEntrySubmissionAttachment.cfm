
<cfparam name = "url.submissionedition" default="">
<cfparam name = "url.rowguid" default="">

<cfquery name="GetEdition" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  	SELECT   *
	FROM     Ref_SubmissionEdition
    WHERE    SubmissionEdition = '#url.submissionedition#'			  
</cfquery>

<!---
<cfif GetEdition.EntityClass eq "">
--->

	<tr> 
    <TD colspan="4" style="padding-left:10px;padding-right:10px">

	 <cf_filelibraryN
			DocumentPath="Submission"
			SubDirectory="#url.rowguid#" 			
			Insert="yes"
			Filter=""	
			LoadScript="No"
			Box="submission"
			Remove="yes"
			ShowSize="yes">
			
     </TD>
    </TR>	
	
<!---			
</cfif>
--->	