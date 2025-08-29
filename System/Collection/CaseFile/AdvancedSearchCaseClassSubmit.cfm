<!--
    Copyright © 2025 Promisan B.V.

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
