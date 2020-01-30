
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