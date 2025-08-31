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
<!--- determine input parameter --->

<cfquery name="Action" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT  *
	 FROM    Applicant.dbo.ApplicantReview
	 WHERE   ReviewId = '#Object.ObjectKeyValue4#'	
</cfquery>

<cfquery name="setAction" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 UPDATE  Applicant.dbo.ApplicantReview
	 SET     Status = '1'
	 WHERE   ReviewId = '#Object.ObjectKeyValue4#'
</cfquery>

<!--- determine roster status --->

<cfinvoke component = "Service.RosterStatus"  
	      method   = "RosterSet" 
	      PersonNo = "#Action.PersonNo#"
		  Owner    = "#Action.Owner#">
	