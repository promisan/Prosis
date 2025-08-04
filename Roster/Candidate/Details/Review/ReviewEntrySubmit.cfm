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

<cfquery name="OwnerParam" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_ParameterOwner
	WHERE     Owner   = '#URL.Owner#' 
</cfquery>

<cfquery name="Verify" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      ApplicantReview
	WHERE     PersonNo   = '#URL.ID#' 
	AND       Owner      = '#URL.Owner#' 
	AND       ReviewCode = '#URL.ID1#' 
	AND       Status = '0'
</cfquery>
		
<CFIF Verify.recordCount eq 0 or OwnerParam.AddReviewPointer eq "1">  
	
	<cf_assignId>
		
	<cfquery name="InsertRequest" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO ApplicantReview
			 (ReviewId,
		      PersonNo, 
	          ReviewCode, 
			  Status, 
			  Owner,
			  ReviewRemarks, 
			  OfficerUserId, 
	   		  OfficerLastName, 
			  OfficerFirstName)
		VALUES  ('#rowguid#',
		         '#URL.ID#', 
		         '#URL.ID1#', 
				 '0', 
				 '#URL.Owner#',
				 'Requested', 
				 '#SESSION.acc#', 
				 '#SESSION.last#', 
				 '#SESSION.first#')
	</cfquery>
	
	<cfset id = rowguid>	
	
<cfelse>

	<cfset id = verify.reviewid>	
					
</CFIF>

<!--- check the roster status --->
<cfinvoke component = "Service.RosterStatus"  
   method           = "RosterSet" 
   personno         = "#Verify.PersonNo#" 
   owner            = "#url.Owner#"
   returnvariable   = "rosterstatus">	
		
<cflocation url="../General.cfm?Owner=#URL.Owner#&ID=#URL.ID#&section=general&topic=review&ID1=#URL.ID1#&reviewid=#id#" addtoken="No">