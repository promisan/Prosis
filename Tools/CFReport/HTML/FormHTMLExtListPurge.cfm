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
<cfparam name="url.pk" default="">

	<cfquery name="PK" 
	  datasource="AppsSystem" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT * 
	  FROM  Ref_ReportControlCriteria
	  WHERE ControlId    = '#URL.ControlId#'
	  AND   CriteriaName = '#URL.CriteriaName#'
	 </cfquery>
	 
	 <cfquery name="Fields" 
	  datasource="AppsSystem" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT *
	  FROM  Ref_ReportControlCriteriaField 
	  WHERE ControlId    = '#URL.ControlId#'
	  AND   CriteriaName = '#URL.CriteriaName#'
	  AND   Operational = '1'
	 </cfquery>
	 
	 <cfquery name="Table" 
	  datasource="#PK.LookupDataSource#" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  DELETE FROM userQuery.dbo.#SESSION.acc#_crit_#URL.CriteriaName#
	  <cfif url.pk neq "">
	  WHERE PK IN ('#preserveSingleQuotes(url.pk)#') 	  
	  </cfif>
	 </cfquery>
 
 <cfset url.init = "0">
 
 <cfinclude template="FormHTMLExtList.cfm">
 