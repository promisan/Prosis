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

<!--- set status --->

<cfquery name="get" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT  *
    FROM    PersonMiscellaneous P, Ref_PayrollItem R
	WHERE   P.PayrollItem = R.PayrollItem	
	AND     CostId   = '#URL.ajaxid#'
</cfquery>

<cfif     get.Status eq "2"><font color="008000">Cleared
<cfelseif get.Status eq "3"><font color="008000">Cleared
<cfelseif get.Status eq "5"><font color="008000">Paid
<cfelse>Pending</cfif>
