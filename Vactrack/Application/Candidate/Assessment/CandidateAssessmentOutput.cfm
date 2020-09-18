
<!--- output this content in the workflow for the TOR recorded --->

<cfif url.wParam eq "">
	<cfset wParam = "VAD0032">
<cfelse>
	<cfset wParam = url.wParam>	
</cfif>

<cfquery name="get" 
	 datasource="appsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT  *
		FROM    OrganizationObject INNER JOIN
		        Vacancy.dbo.[Document] ON OrganizationObject.ObjectKeyValue1 = Vacancy.dbo.[Document].DocumentNo INNER JOIN
		        Applicant.dbo.FunctionOrganization ON Vacancy.dbo.[Document].DocumentNo = Applicant.dbo.FunctionOrganization.DocumentNo
		WHERE   OrganizationObject.ObjectId = '#Object.ObjectId#'
</cfquery>

<cfif get.recordcount eq "1">
  
  <cfquery name="Assessment" 
	 datasource="appsVacancy" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
      SELECT    DCA.DocumentNo, DCA.PersonNo, A.IndexNo, A.FirstName, A.LastName, A.FullName, DCA.OfficerUserId, DCA.OfficerLastName, DCA.OfficerFirstName, DCA.ActionCode,
                C.Description, DCA.AssessmentScore, DCA.AssessmentMemo, C.ListingOrder, DCA.Created
	  FROM      DocumentCandidateAssessment AS DCA INNER JOIN
                Applicant.dbo.Applicant AS A ON DCA.PersonNo = A.PersonNo INNER JOIN
                Applicant.dbo.Ref_Competence AS C ON DCA.CompetenceId = C.CompetenceId
	  WHERE     DCA.DocumentNo = '#Object.ObjectKeyValue1#'
	  <cfif wParam neq "">
	  AND       ActionCode = '#wParam#'
	  </cfif>
	  ORDER BY  DCA.DocumentNo, DCA.PersonNo, DCA.OfficerUserId, C.ListingOrder		
	</cfquery>	
  	
  <table style="width:100%">
	
	<tr><td style="height:4px"></td></tr>
	
	<cfoutput>
	
	<tr>
	<td colspan="2" align="center" style="height:40px;font-size:30px">Assessment Report</td>
	</tr>	
	
	<tr><td style="height:10px;border-bottom:1px solid silver" colspan="2"></td></tr>
	
	<tr><td style="height:10px"></td></tr>
	
	<tr>
	<td style="font-size:20px">Function:</td>
	<td style="font-size:20px">#get.FunctionalTitle# #get.PostGrade#</td>
	</tr>
	<tr>
	<td style="font-size:20px">Unit:</td>
	<td style="font-size:20px">#get.Mission# / #get.OrganizationUnit#</td>
	</tr>
		
	<tr><td style="height:10px;border-bottom:1px solid silver" colspan="2"></td></tr>
	
	<tr><td style="height:10px"></td></tr>
	
	</cfoutput>
		
	<cfoutput query="assessment" group="PersonNo">		
	
	<cfquery name="Final" 
	 datasource="appsVacancy" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT  *
		FROM    DocumentCandidateReview
		WHERE   DocumentNo = '#Documentno#' 
		AND     PersonNo   = '#PersonNo#'
		<cfif wParam neq "">
	    AND      ActionCode = '#wParam#'
	    </cfif>
	 </cfquery>
		  	  
	<tr><td colspan="2" style="border-bottom:1px solid silver;font-size:20px">#FirstName# #LastName# <cfif final.reviewStatus gt "1">: <font color="008000"><b>RECOMMENDED</b></cfif></td></tr>
	<tr><td colspan="2" valign="top" style="height:40px;background-color:f4f4f4;font-size:14px">#Final.ReviewMemo#</td></tr>
		 
	<cfoutput group="OfficerUserId">
	 
	  <tr><td style="height:10px" colspan="2"></td></tr> 
	 <tr><td colspan="2" style="font-size:18px">Assessment #OfficerFirstName# #OfficerLastName# on #dateformat(Created,client.dateformatshow)# #timeformat(Created,"HH:MM")#</td></tr>
	 <tr><td style="height:10px;border-bottom:1px solid silver" colspan="2"></td></tr>  
	  
	  
	<cfoutput>
	 
	 <tr><td style="border-bottom:1px solid silver;font-size:16px;width:200px">#Description#</td> <td style="border-bottom:1px solid silver;font-size:17px;font-weight:bold">
	 
	         <cfswitch expression="#AssessmentScore#">
				 <cfcase value="0"><cf_tl id="undefined"></cfcase>
				 <cfcase value="1"><font color="008000"><cf_tl id="Outstanding"></font></cfcase>
				 <cfcase value="2"><cf_tl id="Satisfactory"></cfcase>
				 <cfcase value="3"><cf_tl id="Partially satisfactory"></cfcase>
				 <cfcase value="4"><cf_tl id="Unsatisfactory"></cfcase>
			 </cfswitch>
	 
	 </td></tr>	 
	 
	 <tr><td colspan="2" valign="top" style="height:40px;background-color:f4f4f4;font-size:14px">#AssessmentMemo#</td></tr>
	 
	</cfoutput>
	</cfoutput>
		  	 					
	</cfoutput>		
	
	<cfoutput>
	
	<tr><td style="height:10px;border-bottom:1px solid silver" colspan="2"></td></tr>
	
	<tr><td style="height:10px"></td></tr>	
	<tr><td align="center" colspan="2" style="font-size:14px">#get.FunctionalTitle# #get.PostGrade#</td></tr>			
	<tr><td style="height:10px;border-bottom:1px solid silver" colspan="2"></td></tr>	
	
	</cfoutput>	
	
  </table>
  
<cfelse>
  
  No found
  
</cfif>  
	