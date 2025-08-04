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

<cfset condition = "">

<cfquery name="SearchResult" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT     Job.*, RequisitionLine.*
FROM         RequisitionLine INNER JOIN
                      Job ON RequisitionLine.JobNo = Job.JobNo
WHERE     (RequisitionLine.RequisitionNo NOT IN
                          (SELECT     RequisitionNo
                            FROM          PurchaseLine))
#preserveSingleQuotes(condition)#  
ORDER BY  Job.Created		
</cfquery>

<cflocation url="JobViewListing.cfm?Period=#URL.Period#&Mission=#URL.Mission#&ID=#URL.ID#&ID1=#URL.ID1#" addtoken="No">