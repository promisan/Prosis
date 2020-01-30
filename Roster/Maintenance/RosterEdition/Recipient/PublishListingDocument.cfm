<cfquery name="get" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_SubmissionEditionPublishMail
		WHERE  RecipientId= '#URL.RecipientId#' 
</cfquery>

<table width="94%" align="center">

<tr><td class="labellarge">Generated documents</td></tr>

<tr><td style="padding-left:20px;padding-right:20px">
	
	<cf_filelibraryN
		DocumentPath="Broadcast/#get.BroadcastId#"
		SubDirectory="#get.orgunit#" 
		Filter=""
		Presentation="all"
		Insert="no"
		Remove="no"
		width="100%"	
		Loadscript="no"				
		border="1">	
	
</td></tr>	
	
</table>	
		
