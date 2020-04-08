
<!--- output this content in the workflow for the TOR recorded --->

<cfquery name="get" 
	 datasource="appsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT    Vacancy.dbo.[Document].FunctionId
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
	
  <table>
	
	<tr><td style="height:10px"></td></tr>
	
	<tr><td align="center" style="border-bottom:1px solid silver;font-size:25px">Terms for Reference</td></tr>	
		
	<cfoutput query="document">		
	 
	 <tr><td style="font-size:20px">#Description#</td></tr>
	 <tr><td style="padding-bottom:10px">#ProfileNotes#</td></tr>	
	  	 					
	</cfoutput>			
	
  </table>
  
<cfelse>
  
  No found
  
</cfif>  
	