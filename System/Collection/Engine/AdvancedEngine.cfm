
<cfinclude template="AdvancedEngineFunctions.cfm">


<cfset start = now()>

<!--- Loop through element classes --->

<cfquery name = "GetClasses" 
datasource = "AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT DISTINCT SearchClass 
	FROM   CollectionLogCriteria
	WHERE  SearchId = '#URL.searchid#' 
	AND Layout != '3'
</cfquery>

<cfset yr = year(now())>	
<cfset mt = month(now())>	
<cfset da = day(now())>	
 
<cfset dateto = dateformat(DateAdd("d", +1,now()),"DD/MM/YYYY")>

<cfset date = CreateDate(yr, mt, da)>
 		
<cfif url.time eq "month">	 
  <cfset date = DateAdd("m", -1,date)> 	   
<cfelseif url.time eq "week">	 
   <cfset date = DateAdd("d", -7,date)> 		
<cfelseif url.time eq "day">	 
   <cfset date = DateAdd("d", -1,date)> 	
</cfif>	
 
<cfset datefrom = dateformat(date,"DD/MM/YYYY")>

<cfset vSearched = 0 > 

<cfset Answer   = "t#SESSION.acc#_Element_#client.sessionno#">
<cf_dropTable dbName="AppsQuery" tblName="#Answer#">
	
<cfquery name = "qCreate" 
datasource = "AppsQuery">
	CREATE TABLE t#SESSION.acc#_Element_#client.sessionno# (
		[ElementClass] [varchar](10) NULL,
		[ElementId] uniqueidentifier NULL,
		[Context] [varchar](300) NULL,
		[Show] [varchar] (1) NULL
	)
</cfquery>

<cfloop query="GetClasses">
	
	<cfset vCondition  = ArrayNew(1)>
	<cfset dataSource  = "">
	<cfset table	   = "">
	<cfset queryLayout = 0>
	<cfset i		   = 0>
	
	<cfquery name="GetCriteria" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   CollectionLogCriteria
		WHERE  SearchId    = '#URL.searchid#'
		AND    SearchClass = '#SearchClass#'
		AND    Layout != '3'
		ORDER BY SearchField
	</cfquery>
	
	<!----                               --->
	<!----    1. Get  conditions         ---> 
	<!----                               --->
		
	<cfloop query="GetCriteria">
		
		<cfset queryLayout = layout>
		<cfset dataSource  = "#SearchDataSource#">
		<cfset table       = "#SearchTable#">
		<cfset i		   = i + 1>
		
		<cfif SearchClass eq 'Person'> <!--- Person --->
						
			<cfset tempCondition = getConditionPerson(SearchFieldType,Operator,SearchField,ListValue,Condition1,Condition2)>
			
			<cfset  ArrayAppend(vCondition, tempCondition)>
			
		<cfelse> <!--- Rest of the classes --->
		
			<cfset tempCondition = getConditionElement(SearchFieldType,Operator,SearchField,ListValue,Condition1,Condition2)>
			<cfset  ArrayAppend(vCondition, tempCondition)>
		
		</cfif>
	
	</cfloop>
	

	<!----               		           			   --->
	<!----    2. Build queries and generates data      ---> 
	<!----                           			       --->
	<cfoutput>

		<cfif SearchClass eq 'Person'>
			#generatePersonData(dataSource,answer,vCondition)#
		<cfelse>
			#generateElementData(dataSource,SearchClass,Answer,vCondition)#
		</cfif>

	</cfoutput>
	
	<cfquery name = "qCount" datasource = "AppsQuery">
		SELECT COUNT(1) as Total
		FROM #Answer#
	</cfquery>
	
	<cfset vSearched = qCount.Total + vSearched> 

</cfloop>
              			  								

<!--- Filter elements based on the ClaimType and ClaimClass (if any) --->

<cfquery name="GetCriteria" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   CollectionLogCriteria
	WHERE  SearchId    = '#URL.searchid#'
	AND    Layout      = '3'
</cfquery>


<cfif GetCriteria.Condition1 neq "" or GetCriteria.Condition2 neq "">

	<cfquery name="CleanAnswer" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM UserQuery.dbo.#answer#
		WHERE ElementId NOT IN
		(
			SELECT CE.ElementId FROM CaseFile.dbo.ClaimElement CE
			INNER JOIN CaseFile.dbo.Claim C ON C.ClaimId = CE.ClaimId
			WHERE 1=1
			<cfif GetCriteria.Condition1 neq "">
				AND C.ClaimType = '#GetCriteria.Condition1#'
			</cfif>
		
			<cfif GetCriteria.Condition2 neq "">
				AND C.ClaimTypeClass = '#GetCriteria.Condition2#'
			</cfif>
		)
	</cfquery>
	
</cfif>

<cfset RELATIONSHIPS_ANSWER = "t#SESSION.acc#_Relationship_#client.sessionno#">

<cf_dropTable dbName="AppsQuery" tblName="#RELATIONSHIPS_ANSWER#">

<!----                       			 						 		--->
<!----    Retrieve all the relationships of elements gotten in (2)   	---> 
<!----                                                                  --->

<cfquery name = "getRelationships" 
datasource = "AppsQuery"
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT R.Code, 
	       R.Description, 
	       R.ElementClassFrom, 
		   ER.ElementId, 
		   R.ElementClassTo, 		
		   ER.ElementIdChild,  		 		  
		   ' ' as Custom1
	INTO   dbo.#RELATIONSHIPS_ANSWER#
	FROM   CaseFile.dbo.Element E INNER JOIN CaseFile.dbo.ElementRelation ER ON
           E.ElementId = ER.ElementId INNER JOIN CaseFile.dbo.Ref_ElementRelation R ON R.Code = ER.RelationCode
	WHERE  ER.ElementId      in (SELECT ElementId FROM #answer# WHERE ElementId = ER.ElementId)
           OR
		   ER.ElementIdChild in (SELECT ElementId FROM #answer# WHERE ElementId = ER.ElementIdChild)		 	   	
		
</cfquery> 

<!--- REMOVE THE RELATIONSHIPS for classes that are not included in the search classes --->

<cfif getClasses.recordcount gte "2">
	
	<cfquery name = "qCleansing1" 
			datasource = "AppsQuery"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
	
			DELETE #RELATIONSHIPS_ANSWER#
			FROM   #RELATIONSHIPS_ANSWER# M
			WHERE  ElementClassFrom NOT IN (#QuotedValueList(GetClasses.searchClass)#)		
		           OR
			       ElementClassTo NOT IN (#QuotedValueList(GetClasses.searchClass)#)	
				
	</cfquery> 
	
<cfelse>

		<cfquery name = "qCleansing1" 
			datasource = "AppsQuery"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
	
			UPDATE #answer#
			SET Show = '1'
				
	</cfquery> 
	

</cfif>

<!---REMOVE ELEMENTS WITHOUT RELATIONSHIPS --->

<cfquery  name = "qCleansing2" 
datasource = "AppsQuery"
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	DELETE #Answer#
	FROM   #Answer# M
	WHERE  M.ElementId NOT IN (SELECT ElementId 
	                           FROM   #RELATIONSHIPS_ANSWER# 
							   WHERE  ElementId = M.ElementId)		
    AND    M.ElementId NOT IN (SELECT ElementIdChild 
	                           FROM   #RELATIONSHIPS_ANSWER# 
							   WHERE  ElementIdChild = M.ElementId)	
				
</cfquery> 

<!--- NOW RAW DATA has been prepared --->   


<!--- MAPPING ROUTINE --->

   <cfquery name = "Potential" 
        datasource = "AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   #Answer#
	</cfquery>	
	
	<cfloop query="Potential">	
	  	
	    <cfif show eq "0">
	
			<cfset elements = "'#elementid#'">
									
			<cfquery name = "GetOtherClass" 
				datasource = "AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT DISTINCT SearchClass 
				FROM   CollectionLogCriteria
				WHERE  SearchId     = '#URL.searchid#' 
				AND    SearchClass != '#ElementClass#'
				AND	   Layout!='3'
			</cfquery>
			
			<cfset stop = "0">
		
			<cfloop query="GetOtherClass">
			
			     <cfif stop eq "0">
			     																						
				 <cfquery name = "CheckClasses" 
			        datasource = "AppsQuery" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT ElementClassFrom, ElementClassTo, ElementIdChild as Element
					FROM   #RELATIONSHIPS_ANSWER#
					WHERE  ElementId IN (#preserveSingleQuotes(elements)#) 
															
					SELECT ElementClassFrom, ElementClassTo, ElementId as Element
					FROM   #RELATIONSHIPS_ANSWER#
					WHERE  ElementIdChild IN (#preserveSingleQuotes(elements)#)
															
				</cfquery>
							
			    <!--- check if we can find a relation ship for any of the N classes in getClass from this element 
			
			    	if all N classes as represented in the result we are done and we go to the next element
					if 1 - N-1 classes are found then we check if any of then found elements then have a relationship that results in all 
				
					   if resultset N : good
					   if resultset 1 - N-1 and larger than prior 'so we gain' then we repeat this again but only if this makes sense.
				
				if 0 Classes are found we tag the element as 0
					
				--->
						
			    <cfquery name="CheckClass" dbtype="query">
                   SELECT DISTINCT ElementClassFrom as ElementClass
				   FROM   CheckClasses
				   UNION
				   SELECT DISTINCT ElementClassTo as ElementClass
				   FROM   CheckClasses				   
				</cfquery>
									
								
				<cfif checkClass.recordcount eq getclasses.recordcount>
								
					 <cfset elements = "#elements#,#quotedvaluelist(CheckClasses.Element)#">
				
					 <cfquery name = "Update" 
				        datasource = "AppsQuery" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						UPDATE #Answer#
						SET    Show = 1 
						WHERE  ElementId IN (#preserveSingleQuotes(elements)#) 	<!--- all elements will benefit --->									
					</cfquery>
					
				<cfelseif checkClass.recordcount lt getclasses.recordcount and checkClass.recordcount gte "1">	
												
					  <cfset elements = "#elements#,#quotedvaluelist(CheckClasses.Element)#">
				
					  <!--- keep the existing elements and go to the class and check the same  --->
					 					
				<cfelse>
				
					<!--- next element --->		
				
					<cfset stop = "1">				
				
				</cfif>		
				
				</cfif>
										
			</cfloop>
		
		</cfif>
			
	</cfloop>
	
<!--- Store categories found --->
<cfquery name = "AdvancedResultCategories" 
datasource = "AppsQuery"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
     SELECT   DISTINCT ElementClass as Category
	 FROM	  #ANSWER#  
</cfquery>

<cfif url.category neq "">

	<cfquery name = "CleanAnswer" 
	datasource = "AppsQuery"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    	 DELETE   
		 FROM	  #ANSWER#  
		 WHERE    ElementClass != '#url.category#'
	</cfquery>
	
</cfif>

	
<!--- GETTING SEARCH RESULT VARIABLE TO CORRESPOND THE VARIABLE AS COMING FROM THE COLLECTION --->

<cfquery name = "SearchResult" 
datasource = "AppsQuery"
username="#SESSION.login#" 
password="#SESSION.dbpw#">

     SELECT    E.OfficerUserId as Author, 
	           E.ElementClass AS Category, 
			   ' ' AS CategoryTree, 
			   Reference AS Title,
			   ' ' AS Context, 
			   E.ElementClass AS Custom1, 
			   E.OfficerUserId AS Custom2, 
			   ' ' AS Custom3, 
               ' ' AS Custom4, 
			   E.ElementId AS [Key], 
			   '1' AS Rank, 
			   '#vSearched#' AS RecordSearched, 
			   '0' AS Score, 
			   '0' AS Size, 
			   ' ' AS Summary, 
			   'text/x-empty' AS Type, 
               ' ' AS URL
FROM         #ANSWER# INNER JOIN
                      CaseFile.dbo.Element E ON #ANSWER#.ElementId = E.ElementId
WHERE Show = '1'					  
</cfquery>


<cfquery name="searchTotal" dbtype="query">
    SELECT count(*) as Total FROM SearchResult
</cfquery>

<cfif searchTotal.total eq "">
     <cfset counted = 0>
<cfelse>
 	 <cfset counted = SearchTotal.total>
</cfif>	 

<!--- logging of the search --->

<cfset end = now()>

<cfset time = DateDiff("s","#end#","#start#")> 
								
<cfquery name="updateLogging" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE CollectionLog
	SET   SearchCriteria = '[detail]',
	      SearchResults  = '#counted#',
		  SearchBase     = '#vSearched#', 
		  SearchTime     = '#time*1000#'
	WHERE SearchId = '#url.searchid#'		
</cfquery>

 <cfloop query="searchresult">
	 
	 <cftry>
	 <cfquery name="LoggingResult" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO CollectionLogResult
			(SearchId,Category,RecordKey)
		VALUES
			('#url.searchid#','#category#','#key#')  
	 </cfquery>
	 
	 <cfcatch></cfcatch>
	 
	 </cftry>
	 
 </cfloop>

<cfset rowguid = url.searchid>
	
<cf_PageCountN count="#counted#">
<cfset last = counted>	

<cfif counted eq "0">
<table width="100%"><tr><td align="center" height="50"><font face="Verdana" size="4" color="808080"><cf_tl id="No matching elements were found"> !</font></td></tr></table>
<cfabort>

</cfif>