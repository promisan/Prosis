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
			
	<cfquery name="Review" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  ApplicantReview 
		WHERE ReviewId = '#URL.ajaxid#'	
	</cfquery>
	
	<cfquery name="Topic" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     *
		FROM       Ref_ReviewClass
		WHERE      Code = '#Review.ReviewCode#'
	</cfquery>
	
	<cfquery name="TopicOwner" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     EntityClass
		FROM       Ref_ReviewClassOwner
		WHERE      Code  = '#Review.ReviewCode#'
		AND        Owner = '#Review.owner#' 
	</cfquery>	
	
	<cfif TopicOwner.recordcount eq 0>
		<cfset vEntityClass = "Standard">
	<cfelse>
		<cfset vEntityClass = TopicOwner.EntityClass>
	</cfif>
	
	<cfquery name="Candidate" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  Applicant
		WHERE PersonNo = '#Review.PersonNo#'	
	</cfquery>
	
	<cfif review.recordcount eq "1">
	
	<cfset link = "Roster/Candidate/Details/General.cfm?ID=#Review.PersonNo#&section=general&topic=review&owner=#review.owner#&Id1=#Review.ReviewCode#">
		
	<cf_ActionListing 
	    EntityCode       = "Rev#Review.ReviewCode#"
		EntityClass      = "#vEntityClass#"
		EntityGroup      = "#Review.Owner#"
		EntityStatus     = ""
		OrgUnit          = ""
		AjaxId           = "#URL.AjaxId#"		 
		ObjectReference  = "#Topic.Description#"
		ObjectReference2 = "#Candidate.LastName#, #Candidate.FirstName#"
	    ObjectKey1       = "#Review.PersonNo#"
		ObjectKey4       = "#Review.ReviewId#"
		ObjectURL        = "#link#"
		Show             = "Yes"
		CompleteFirst    = "No">		
		
	</cfif>	
		