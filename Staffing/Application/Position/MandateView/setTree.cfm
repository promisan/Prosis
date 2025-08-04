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
