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
<!--- filter value ajax --->

<cfquery name="Report" 
	 datasource="AppsSystem" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT *
		 FROM   Ref_ReportControl
		 WHERE  ControlId    = '#url.controlid#' 	
</cfquery>

<cfif reportId eq "00000000-0000-0000-0000-000000000000">
	
	<cfquery name="Criteria" 
	 datasource="AppsSystem" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT *
		 FROM   Ref_ReportControlCriteria
		 WHERE  ControlId    = '#url.controlid#' 
		 AND    CriteriaName = '#url.criterianame#'			
	</cfquery>

<cfelse>

	<cfquery name="Criteria" 
	 datasource="AppsSystem" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT     R.CriteriaName, 
	            R.CriteriaNameParent,
		        U.CriteriaValue as CriteriaDefault, 
		        R.CriteriaDescription, 
				R.CriteriaMemo,
				R.CriteriaError,
				R.CriteriaOrder,
				R.CriteriaWidth, 
				R.CriteriaMask,
				R.CriteriaValidation,
				R.CriteriaPattern,
				R.CriteriaValues,
				R.CriteriaDatePeriod,
				R.CriteriaInterface,
				R.CriteriaDateRelative,
				R.CriteriaCluster,
				R.CriteriaRole,
				R.LookupTable,
				R.LookupUnitTree,
				R.LookupUnitParent,
				R.LookupDataSource, 
				R.LookupFieldValue, 
				R.LookupFieldDisplay,
				R.LookupFieldSorting,
				R.LookupFieldShow,  				
				R.LookupEnableAll,
				R.CriteriaType, 
				R.LookupMultiple, 
				R.CriteriaObligatory
	 FROM  		Ref_ReportControlCriteria R LEFT OUTER JOIN UserReportCriteria U
	     ON     R.CriteriaName   = U.CriteriaName
		  AND   U.ReportId       = '#url.reportId#'
	 WHERE  	R.ControlId      = '#url.ControlId#' 
	 AND        R.CriteriaName   = '#url.criterianame#'
	</cfquery>
			
</cfif>	

<cfparam name="url.class" default="regular">

<cfoutput>

<cfif url.cl eq "regular">
	 <script>
	  try { document.getElementById('#url.CriteriaName#_radio').click();  }
	  catch(e) { }
	 </script>
</cfif>

</cfoutput>

<cfloop query="Criteria">

	<cfset ajax   = 1>
	<cfset fldid  = "#url.fldid#">
	<cfset cl     = "#url.cl#">

	<cfinclude template="SelectFormParameter.cfm"> 	

</cfloop>



