
<!--- show titles for the selected grade deployment to reflect a current assignment --->

<cfquery name="Functions" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
	SELECT    FO.FunctionId,F.FunctionNo, F.FunctionDescription
	FROM      FunctionOrganization FO INNER JOIN
              FunctionTitle F ON FO.FunctionNo = F.FunctionNo
    WHERE     FO.GradeDeployment = '#url.gradedeployment#' 
	AND       FO.SubmissionEdition = '#url.submissionedition#' 
    AND       F.FunctionOperational = 1
	ORDER BY Functiondescription
</cfquery>

 <cfquery name="Selected" 
   datasource="AppsSelection" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
     
   SELECT     * 
           
   FROM       ApplicantFunction
   WHERE      ApplicantNo = '#url.applicantno#'
   AND        Source = 'Assignment'
   <cfif Functions.recordcount gte "1">
   AND        Functionid IN (#quotedvalueList(Functions.FunctionId)#) 
   </cfif>      
  
 </cfquery>

<table class="formpadding">
<cfoutput query="Functions">
	<tr class="labelmedium">
		<td><input type="radio" class="radiol" name="FunctionId" value="#FunctionId#" <cfif selected.functionid eq FunctionId>checked</cfif>></td>
		<td style="padding-left:20px;height:26px;font-size:17px"><font color="808080">#FunctionDescription#</td>
	</tr>
</cfoutput>	
</table>
