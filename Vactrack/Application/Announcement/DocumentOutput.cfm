
<!--- output this content in the workflow for the TOR recorded --->

<cfquery name="get" 
	 datasource="appsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT    *
		FROM      OrganizationObject INNER JOIN
		          Vacancy.dbo.[Document] ON OrganizationObject.ObjectKeyValue1 = Vacancy.dbo.[Document].DocumentNo INNER JOIN
		          Applicant.dbo.FunctionOrganization ON Vacancy.dbo.[Document].DocumentNo = Applicant.dbo.FunctionOrganization.DocumentNo
		WHERE     OrganizationObject.ObjectId = '#Object.ObjectId#'
</cfquery>

<cfif get.recordcount eq "1">

  <cfquery name="Document" 
	 datasource="appsSelection" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
			SELECT *
			FROM FunctionOrganizationNotes N, Ref_TextArea R
			WHERE FunctionId = '#get.FunctionId#'
			AND N.TextAreaCode = R.Code
			ORDER BY ListingOrder			
  </cfquery>
	
  <table style="width:100%">
	
	<tr><td style="height:4px"></td></tr>
	
	<cfoutput>
	
	<tr>
	<td colspan="2" align="center" style="height:40px;font-size:30px">Terms or Reference</td>
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
		
	<cfloop query="document">		
	 
	 <tr><td colspan="2" style="font-size:20px">#Description#</td></tr>
	 <tr><td colspan="2" style="padding-bottom:10px">#ProfileNotes#</td></tr>	
	  	 					
	</cfloop>		
	
	<tr><td style="height:10px;border-bottom:1px solid silver" colspan="2"></td></tr>
	
	<tr><td style="height:10px"></td></tr>
	
	<tr>	
	<td align="center" colspan="2" style="font-size:14px">#get.FunctionalTitle# #get.PostGrade#</td>
	</tr>
			
	<tr><td style="height:10px;border-bottom:1px solid silver" colspan="2"></td></tr>	
	
	</cfoutput>	
	
  </table>
  
<cfelse>
  
  No found
  
</cfif>  
	