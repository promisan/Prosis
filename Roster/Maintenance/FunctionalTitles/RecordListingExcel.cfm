
<cfparam name="url.filter" default="">

<cfset condition = replace(url.filter,"|","'","ALL")>  

<cf_droptable dbname="appsQuery" tblname="vwListingFunction#SESSION.acc#">
<cf_droptable dbname="appsQuery" tblname="vwListingFunctionGrade#SESSION.acc#">

<cfquery name="SearchResult"
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT R.GradeDeployment, 
			   R.Description as GradeDeploymentDescription,  
			   R.ListingOrder, 
			   F.*, 		    
			   O.Description, 
			   (SELECT count(*) 
						 FROM   FunctionOrganization FO, Ref_SubmissionEdition S  
						 WHERE  FO.SubmissionEdition = S.SubmissionEdition 
						 AND    S.EnableAsRoster = 1 AND F.FunctionNo = FO.FunctionNo) as Bucket	
		INTO   userQuery.dbo.vwListingFunctionGrade#SESSION.acc#						 		
			   
		FROM   #CLIENT.LanPrefix#FunctionTitle F INNER JOIN
               #CLIENT.LanPrefix#OccGroup O ON F.OccupationalGroup = O.OccupationalGroup INNER JOIN
               FunctionTitleGrade G ON F.FunctionNo = G.FunctionNo INNER JOIN Ref_GradeDeployment R ON G.GradeDeployment = R.GradeDeployment
		
		WHERE 1=1 		
				
			#preserveSingleQuotes(Client.condition)#
			<cfif SESSION.isAdministrator eq "No">
			AND F.FunctionClass IN (SELECT FunctionClass
			                      FROM Organization.dbo.OrganizationAuthorization A, Ref_FunctionClass R
							      WHERE R.Owner = A.ClassParameter
							      AND   A.Role = 'FunctionAdmin' 
							      AND   A.UserAccount = '#SESSION.acc#')
			</cfif>	
			
		ORDER BY O.OccupationalGroup, 
		         R.ListingOrder, 
				 R.GradeDeployment, 
				 F.FunctionDescription
				 
</cfquery>
 		   	
<cfquery name="SearchResult"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT O.Description,
	       F.*,  
		     (SELECT count(*) 
					 FROM   FunctionOrganization FO, Ref_SubmissionEdition S  
					 WHERE  FO.SubmissionEdition = S.SubmissionEdition 
					 AND    S.EnableAsRoster = 1 AND F.FunctionNo = FO.FunctionNo) as Bucket		
	INTO   userQuery.dbo.vwListingFunction#SESSION.acc#				 		  
	FROM   #CLIENT.LanPrefix#OccGroup O, 
		   #CLIENT.LanPrefix#FunctionTitle F
	WHERE  O.OccupationalGroup = F.OccupationalGroup
			
		#PreserveSingleQuotes(condition)#
		
		<cfif SESSION.isAdministrator eq "No">
		AND FunctionClass IN (SELECT FunctionClass
		                      FROM   Organization.dbo.OrganizationAuthorization A, Ref_FunctionClass R
						      WHERE  R.Owner = A.ClassParameter
						      AND    A.Role = 'FunctionAdmin' 
						      AND    A.UserAccount = '#SESSION.acc#'
							 )
		</cfif>		
						
	ORDER BY O.OccupationalGroup, F.FunctionDescription
</cfquery>

<cfset table1   = "vwListingFunction#SESSION.acc#">	
<cfset table2   = "vwListingFunctionGrade#SESSION.acc#">	