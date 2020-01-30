

<!--- Query returning search results --->
<cfquery name="SearchResult" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT   Post.*, 
           P.ViewOrder, 
		   P.Description as ParentDescription, 
		   G.PostGradeParent, 
		   G.PostOrder, 
		   Occ.OccupationalGroup, 
		   Occ.Description
  INTO     userQuery.dbo.#SESSION.acc#Post		 
  FROM     Position Post, 
           Applicant.dbo.Occgroup Occ, 
           Applicant.dbo.FunctionTitle F, 
	       Ref_PostGrade G,
	       Ref_PostGradeParent P
  WHERE    Occ.OccupationalGroup = F.OccupationalGroup
  AND      G.PostGrade   = Post.PostGrade
  AND      P.Code        = G.PostGradeParent
  AND      F.FunctionNo  = Post.FunctionNo  
  AND      Post.Mission   = '#URL.Mission#'	
  AND      Post.MandateNo = '#URL.Mandate#'
</cfquery>

<cfform>

<cf_MandateTreeData
	  mission="#URL.Mission#"	  
	  mandatedefault="#url.mandate#">	
						  
</cfform>

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Post"> 
