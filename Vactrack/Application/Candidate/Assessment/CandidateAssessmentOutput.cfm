<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

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
		FROM    OrganizationObject OO INNER JOIN
		        Vacancy.dbo.[Document] ON OO.ObjectKeyValue1 = Vacancy.dbo.[Document].DocumentNo INNER JOIN
		        Applicant.dbo.FunctionOrganization FO ON Vacancy.dbo.[Document].DocumentNo = FO.DocumentNo
		WHERE   OO.ObjectId = '#Object.ObjectId#'
</cfquery>

<cfif get.recordcount eq "1">
    	
  <table style="width:100%">
	
	<tr><td style="height:4px"></td></tr>
	
	<cfoutput>
	
		<tr><td colspan="2" align="center" style="height:40px;font-size:30px">Assessment Report for Track : #Object.ObjectKeyValue1#</td></tr>	
		
		<tr><td style="height:10px;border-bottom:1px solid silver" colspan="2"></td></tr>
		
		<tr><td style="height:10px"></td></tr>
			
		<tr>
			<td style="font-size:20px">Job:</td>
			<td style="font-size:20px">#get.ReferenceNo# / #get.FunctionalTitle# #get.PostGrade#</td>
		</tr>
		<tr>
			<td style="font-size:20px">Unit:</td>
			<td style="font-size:20px">#get.Mission# / #get.OrganizationUnit#</td>
		</tr>
			
		<tr><td style="height:10px;border-bottom:1px solid silver" colspan="2"></td></tr>		
		<tr><td style="height:10px"></td></tr>
	
	</cfoutput>
	
	<cfquery name="Candidate" 
	 datasource="appsVacancy" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT  *
		FROM    DocumentCandidate DC 
			    INNER JOIN DocumentCandidateReview DCA ON DC.DocumentNo = DCA.DocumentNo AND DC.PersonNo = DCA.PersonNo
				INNER JOIN Applicant.dbo.Applicant AS A ON DCA.PersonNo = A.PersonNo
		WHERE   DC.DocumentNo  = '#Object.ObjectKeyValue1#' 		
		<cfif wParam neq "">
	    AND      DCA.ActionCode = '#wParam#'
	    </cfif>
		AND     Status IN ('1','2','2s','3')
	 </cfquery>
		
	<cfloop query="Candidate">	
	
	<cfoutput>			  	  
	<tr><td colspan="2" style="border-bottom:1px solid silver;font-size:25px">#FirstName# #LastName# <cfif reviewStatus gt "1">: <font color="008000"><b>RECOMMENDED</b></cfif></td></tr>
	<tr><td colspan="2" valign="top" style="background-color:f4f4f4;font-size:14px">#ReviewMemo#</td></tr>
	</cfoutput>
	
	   <cfquery name="Assessment" 
		 datasource="appsVacancy" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
	      SELECT    DCA.DocumentNo, 
		            DCA.PersonNo, 					
					DCA.OfficerUserId, 
					DCA.OfficerLastName, 
					DCA.OfficerFirstName, 
					DCA.ActionCode,
	                C.Description, 
					DCA.AssessmentScore, 
					DCA.AssessmentMemo, 
					C.ListingOrder, 
					DCA.Created
		  FROM      DocumentCandidateAssessment AS DCA INNER JOIN
	                Applicant.dbo.Ref_Competence AS C ON DCA.CompetenceId = C.CompetenceId
		  WHERE     DCA.DocumentNo = '#Object.ObjectKeyValue1#'
		  AND       DCA.PersonNo = '#PersonNo#'
		  <cfif wParam neq "">
		  AND       ActionCode = '#wParam#'
		  </cfif>
		  ORDER BY  DCA.DocumentNo, DCA.PersonNo, DCA.OfficerUserId, C.ListingOrder	
		  
		  	
		</cfquery>		
		 
		<cfoutput query="Assessment" group="OfficerUserId">
		 	  
		 <tr><td colspan="2" style="padding-left:40px;font-size:18px">Assessment by: <b>#OfficerFirstName# #OfficerLastName#</b> on #dateformat(Created,client.dateformatshow)# #timeformat(Created,"HH:MM")#</td></tr>
		 <tr><td style="height:10px;border-bottom:1px solid silver" colspan="2"></td></tr>  
		  	  
			<cfoutput>
			 
			 <tr><td style="padding-left:40px;border-bottom:1px solid silver;font-size:16px;width:200px">#Description#</td> <td style="border-bottom:1px solid silver;font-size:17px;font-weight:bold">
			 
			         <cfswitch expression="#AssessmentScore#">
						 <cfcase value="0"><cf_tl id="undefined"></cfcase>
						 <cfcase value="1"><font color="008000"><cf_tl id="Outstanding"></font></cfcase>
						 <cfcase value="2"><cf_tl id="Satisfactory"></cfcase>
						 <cfcase value="3"><cf_tl id="Partially satisfactory"></cfcase>
						 <cfcase value="4"><cf_tl id="Unsatisfactory"></cfcase>
					 </cfswitch>
			 
			 </td></tr>	 	 
			 <tr><td colspan="2" valign="top" style="padding:5px;padding-left:40px;height:40px;background-color:f4f4f4;font-size:14px">#AssessmentMemo#</td></tr>
			 
			</cfoutput>
			
		</cfoutput>
		  	 					
	</cfloop>		
	
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
	