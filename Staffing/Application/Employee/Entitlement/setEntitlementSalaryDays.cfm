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
<cfquery name="get" 
datasource="AppsPayroll"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT * FROM PersonEntitlement 
  WHERE    PersonNo      = '#url.id#' 
  AND      EntitlementId = '#url.id1#'
</cfquery> 

<cfif get.EntitlementSalaryDays eq "">
	
	<cfquery name="Schedule" 
	datasource="AppsPayroll"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   UPDATE  PersonEntitlement
	  SET      EntitlementSalaryDays = '1'
	  WHERE    PersonNo      = '#url.id#' 
	  AND      EntitlementId = '#url.id1#' 
	</cfquery> 
	
	<cf_tl id="Net days"> 

<cfelse>

		
	<cfquery name="Schedule" 
	datasource="AppsPayroll"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  UPDATE  PersonEntitlement
	  SET      EntitlementSalaryDays = NULL
	  WHERE    PersonNo      = '#url.id#' 
	  AND      EntitlementId = '#url.id1#' 
	</cfquery>  
	
	<cf_tl id="Default">


</cfif>