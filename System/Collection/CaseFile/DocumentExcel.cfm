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

<cfquery name="TopicList" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT    R.*, S.PresentationMode
	     FROM      Ref_Topic R INNER JOIN Ref_TopicElementClass S ON R.Code = S.Code
		 WHERE     ElementClass = '#url.category#'	
		 AND       Operational = 1		 		
		 ORDER BY  S.ListingOrder,R.ListingOrder
</cfquery>

<!--- excel result --->

<cf_droptable dbname="AppsQuery" tblname="Collection#session.sessionid#">
		
<cfquery name="Detail" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT  E.ElementId,
	        E.Reference,  
			
			<cfif url.category eq "Person">
			
			    A.PersonNo,
				A.IndexNo,
				(A.LastName+' '+A.LastName2) as LastName,
				(A.FirstName+' '+A.MiddleName) as FirstName,
				A.DOB,
				A.Gender,				
			
			</cfif> 
							
			<cfloop query="TopicList">			
				<cfset fld = replace(description," ","","ALL")>
				<cfset fld = replace(fld,".","","ALL")>
				<cfset fld = replace(fld,",","","ALL")>
				 <cfif TopicClass neq "Person">
					(SELECT TopicValue 
					 FROM   ElementTopic 
					 WHERE  ElementId = E.ElementId 
					 AND    Topic = '#code#') as #fld#,						
				 </cfif>	 
			</cfloop>		
			
		    E.Created		
			
	INTO    userquery.dbo.Collection#session.sessionid#					
	FROM    Element E 
	<cfif url.category eq "Person">
				LEFT OUTER JOIN Applicant.dbo.Applicant A ON E.PersonNo = A.PersonNo			
			</cfif>	 	
	WHERE   E.ElementClass = '#url.category#'	
		    AND ElementId IN (SELECT RecordKey 
			                  FROM   System.dbo.CollectionLogResult 
							  WHERE  Category = '#url.category#' 
							  AND    Searchid = '#url.searchid#')    
			
	
				
		
</cfquery>
	
<cfset client.table1   = "Collection#session.sessionid#">	