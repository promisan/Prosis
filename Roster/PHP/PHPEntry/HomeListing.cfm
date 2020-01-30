
<cfquery name="Submission" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT APPS.*, (SELECT TOP 1 Updated 
	                FROM      ApplicantBackground 
				    WHERE     ApplicantNo = Apps.ApplicantNo
				    ORDER BY  Updated DESC) as LastUpdated
    FROM   ApplicantSubmission AS APPS	
    WHERE  APPS.PersonNo = '#URL.PersonNo#' 
	<!--- hardcoded by hanno --->
	AND    APPS.Source IN ('Inspira','Galaxy')
</cfquery>


<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center" class="formpadding">
		
     <tr><td>
			 
			 <table border="0" cellpadding="0" cellspacing="0" width="100%" class="navigation_table">
			
			  <TR class="labelmedium linedotted">
			  	  <td></td>
				 
				  <td height="19" ><cf_tl id="Date submission"></td>
				  <td height="19" ><cf_tl id="JO/TJO"></td>
				  <TD><cf_tl id="Our Reference"></TD>
				  <TD><cf_tl id="Source"></TD>					  			  
				  <TD><cf_tl id="SourceKey"></TD>					  			  				  
			  	  <TD><cf_tl id="Last updated"></TD>				  
				  <TD align="left"></TD>				
		      </TR>
			  
			  <cfoutput query="Submission">		

			     <cfif url.applicantno eq applicantNo>
			       <tr bgcolor="FFFBC7" class="labelmedium">	
				    <td colspan="1" style="padding-left:7px">
					  <cf_portalTab mode="GoTo" id="#url.id#" functionname="Profile" icon="select" reload="true">
					</td>			  
			     <cfelse>
			   	   <tr class="labelmedium navigation_row">					
				   <td style="padding-left:7px"><cf_img icon="edit" onclick="reload('#applicantno#')"></td>				    
			     </cfif>	
					 				  	 
					  <td style="height:23px;padding-left:3px">#DateFormat(SubmissionDate, CLIENT.DateFormatShow)#</td>
					  <td>#SubmissionReference#</td>
					  <td>#ApplicantNo#</td>
					  <td>#Source#</td>										 					  
  					  <td>#SourceOrigin#</td>		
					  <td><cfif LastUpdated eq "">n/a<cfelse>#DateFormat(LastUpdated, CLIENT.DateFormatShow)#</cfif></td>					  
					  <td align="right" style="padding-right:4px">
					  
					  	<cf_RosterPHP 
							DisplayType = "HLink"
							Image       = "#SESSION.root#/Images/pdf_small.gif"
							DisplayText = ""
							style       = "height:14;width:16"
							Script      = "#currentrow#"
							RosterList  = "#ApplicantNo#"
							Format      = "Document">
					 					  
					  </td>
					 
				 </tr>
				 				 
			  </cfoutput>
			 
			 </table>
	 </td></tr>
			 	      	   
</table>

<cfset ajaxonload("doHighlight")>
		 