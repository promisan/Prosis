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

<!--- from workflow --->
<cfparam name="Object.ObjectKeyValue4" default="">

<cfparam name="attributes.reviewId" default="#Object.ObjectKeyValue4#">

<!--- apply project review cancellation --->

<!--- set actionstatus = 9 --->

	<cfquery name="get" 
	  datasource="AppsProgram" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	     SELECT * FROM ProgramPeriodReview		 
		 WHERE  ReviewId = '#attributes.ReviewId#'		
	</cfquery>

	<cfquery name="resetProgram" 
	  datasource="AppsProgram" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	     UPDATE ProgramPeriodReview
		 SET    ActionStatus = '9'
		 WHERE  ReviewId = '#attributes.ReviewId#'		
	</cfquery>

<!--- make a full snapshot --->	

  <cftransaction>
	
	<cfinvoke component = "Service.Process.Program.ProgramAllotment"  
	   method           = "RequirementSnapshot" 
	   ProgramCode      = "#get.ProgramCode#" 
	   Period           = "#get.Period#">	   

	<!--- we cancel transaction that are not partially allotted yet --->

	<cfquery name="getRequirements" 
	  datasource="AppsProgram" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	     SELECT RequirementId 
		 FROM   ProgramAllotmentRequest B		
		 WHERE  ProgramCode = '#get.ProgramCode#'	
		 AND    Period      = '#get.Period#'
		 AND    ActionStatus = '1'
		 AND    RequirementId NOT IN (SELECT RequirementId 
		                              FROM   ProgramAllotmentDetailRequest R, ProgramAllotmentDetail D 	
		                              WHERE  R.TransactionId = D.TransactionId
									  AND    R.Status = '1'
									  AND    R.RequirementId = B.RequirementId)
	</cfquery>
		
	<cfloop query="getRequirements">
	
		<cfinvoke component = "Service.Process.Program.ProgramAllotment"  
		   method           = "RequirementSnapshot" 
		   RequirementId    = "#RequirementId#" 
		   ReviewId         = "#attributes.reviewId#">	   
	
	</cfloop>
	
	<!--- apply new status --->

	<cfquery name="resetRequirements" 
	  datasource="AppsProgram" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	     UPDATE ProgramAllotmentRequest
		 SET    ActionStatus        = '9',
		        ActionStatusDate    = getDate(),
				ActionStatusOfficer = '#session.acc#'
		 FROM   ProgramAllotmentRequest B		
		 WHERE  ProgramCode = '#get.ProgramCode#'	
		 AND    Period      = '#get.Period#'
		 AND    ActionStatus = '1'
		 AND    RequirementId NOT IN (SELECT RequirementId 
		                              FROM   ProgramAllotmentDetailRequest R, ProgramAllotmentDetail D 	
		                              WHERE  R.TransactionId = D.TransactionId
									  AND    R.Status = '1'
									  AND    R.RequirementId = B.RequirementId)
	</cfquery>
	
	<!--- log the new status as it was set by this review action --->
	
		
 </cftransaction>


	  