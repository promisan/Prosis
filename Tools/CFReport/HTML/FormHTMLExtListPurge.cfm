
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
 