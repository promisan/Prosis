
<!--- candidate recommendation --->

<cfquery name="get" 
	datasource="appsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	      SELECT   A.*, DC.Status			   
		   FROM    DocumentCandidate DC INNER JOIN
                   Applicant.dbo.Applicant A ON DC.PersonNo = A.PersonNo INNER JOIN
                   Ref_Status S ON DC.Status = S.Status    				   	   
		  WHERE    DC.DocumentNo = '#url.documentNo#'		 
		  AND      DC.PersonNo = '#url.personno#'		 
</cfquery>

<cfoutput>

<form name="recommendation" id="recommendation">
	
	<table width="96%" height="100%" align="center">
	
	<tr><td id="myprocess"></td></tr>
	
	<tr class="labelmedium line">
	<td style="height:30px;font-size:18px"><cf_tl id="Candidate"></td>
	<td style="width:80%;;font-size:18px"><cfoutput>#get.LastName#, #get.FirstName#</cfoutput></td>
	</tr>
	
	<tr class="labelmedium line">
	<td style="height:30px;font-size:18px"><cf_tl id="Recommend candidate"></td>
	<td style="width:80%">
		<input class = "Radiol" 
		       style = "height:21px;width:21px" 
			   type  = "checkbox" 
			   name  = "ReviewStatus" id="ReviewStatus" 
			   value = "#url.wFinal#" <cfif get.Status gte url.wFinal>checked</cfif> style="cursor:pointer">					
	</td>
	</tr>
	
	<tr><td style="height:2px"></td></tr>
	
	<tr class="labelmedium" style="height:80%">
	<td colspan="2" valign="top">
	
	 <cfquery name="Check" 
	 datasource="AppsVacancy" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT *
		FROM  DocumentCandidateReview
		WHERE DocumentNo = '#url.documentno#'
		AND   PersonNo   = '#url.personno#'	 
		AND   ActionCode = '#url.ActionCode#'  
	 </cfquery>	
	
	 <cf_textarea name="ReviewMemo"           		 
				 init="Yes"							
				 color="ffffff"	 
				 resize="false"		
				 border="0" 
				 toolbar="Mini"
				 height="80%"
				 width="100%">#Check.ReviewMemo#</cf_textarea>
	</td>
	</tr>
	
	<tr><td colspan="2" align="center">
		<table class="formspacing">
		<tr>
		<td><input type="button" value="Close" name="Close"   class="button10g" 
		     onclick="ProsisUI.closeWindow('decisionbox')"></td>
		<td><input type="button" value="Submit" name="Submit" class="button10g" 
		     onclick="updateTextArea();ptoken.navigate('#SESSION.root#/Vactrack/Application/Candidate/CandidateRecommendationSubmit.cfm?wparam=#url.wparam#&documentno=#url.documentNo#&personno=#url.personno#&actioncode=#url.actioncode#&wfinal=#url.wfinal#','myprocess','','','POST','recommendation')"></td>
		</tr>
		</table>
	</td></tr>
	
	</table>

</form>

</cfoutput>

<cfset ajaxonload("initTextArea")>