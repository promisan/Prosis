
<cfif not isDefined("url.casetype")>
	<cfquery name = "GetClaim"  
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	
		SELECT Condition1, Condition2 
		FROM   CollectionLogCriteria
		WHERE  SearchId = '#url.searchid#'
		AND    Layout = '3'
	</cfquery>
	
	<cfset url.casetype  = GetClaim.Condition1>
	<cfset url.caseclass = GetClaim.Condition2>
	
</cfif>


<cfquery name = "CleanCase"  
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">	
	DELETE FROM CollectionLogCriteria
	WHERE  SearchId = '#url.searchid#'
	AND    Layout = '3'
</cfquery>


<cfquery name = "InsertCollectionLog"  
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">	

	INSERT INTO CollectionLogCriteria
          (SearchId,
          Layout,
          SearchDatabase,
          SearchDataSource,
	   	  SearchTable,
          SearchClass,
          SearchField,
          SearchFieldType,
          Operator
 	      <cfif url.casetype neq "Any">
          	 ,Condition1
		  </cfif>
	      <cfif url.caseclass neq "Any">
	     	 ,Condition2
 	      </cfif>
	      )
    VALUES
          ('#url.searchid#',
          '3',
          'CaseFile',
          'AppsCaseFile',
	      'Ref_ClaimTypeClass',
          'Claim',
          'ClaimType',
          'Text',
          '='
   	      <cfif url.casetype neq "Any">
		      ,'#url.casetype#'
		  </cfif>
 		  <cfif url.caseclass neq "Any">
          	 ,'#url.caseclass#'
		  </cfif>
	      )
	   
 </cfquery>
