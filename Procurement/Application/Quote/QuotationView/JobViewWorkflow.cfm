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
<cfoutput>

<cfquery name="Job" 
	 datasource="AppsPurchase" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	   SELECT  J.*, R.Description as JobCategoryDescription
	   FROM    Job J LEFT OUTER JOIN Ref_JobCategory R ON  J.JobCategory = R.Code
	   WHERE   J.JobNo = '#url.ajaxid#'	 
</cfquery>

<cfset link = "Procurement/Application/Quote/QuotationView/JobViewGeneral.cfm?Period=#Job.Period#&ID1=#Job.JobNo#">

<!--- if status eq "9", do not initiate a workflow --->

<cfif Job.ActionStatus eq "9">
 <cfset hide = "Yes">
<cfelse>
 <cfset hide = "No">
</cfif> 
				   			   				
<cf_ActionListing 
    EntityCode       = "ProcJob"
	EntityClass      = "#Job.OrderClass#"
	EntityGroup      = "#Job.JobCategory#"
	EnforceWorkflow  = "No"
	EntityStatus     = ""	
	Mission          = "#Job.Mission#"
	OrgUnit          = ""
	HideCurrent      = "#hide#"
	ObjectReference  = "#Job.Description#"
	ObjectReference2 = "#Job.CaseNo#"
	ObjectKey1       = "#Job.Jobno#"	
  	ObjectURL        = "#link#"
	AjaxId           = "#URL.AjaxId#"
	Show             = "Yes"
	ActionMail       = "Yes"
	PersonNo         = ""
	PersonEMail      = ""
	TableWidth       = "99%"
	DocumentStatus   = "0">

</cfoutput>