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
 

<cfquery name="Line" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM RequisitionLineQuote Q, Organization.dbo.Organization O
	WHERE Q.OrgUnitVendor = O.OrgUnit
	AND  QuotationId = '#URL.ID#'
</cfquery>
  
['<cfoutput>#Line.OrgUnitName#</cfoutput>',null, 

<cfquery name="Quote" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT R.*, Q.QuotationId
    FROM RequisitionLine R, RequisitionLineQuote Q
	WHERE R.JobNo = Q.JobNo
	AND   R.RequisitionNo = Q.RequisitionNo
	AND   Q.OrgUnitVendor = '#Line.OrgUnitVendor#'
	AND   R.JobNo = '#Line.JobNo#' 
	AND R.ActionStatus != '9' 
</cfquery>

<cfoutput query="Quote">

['#RequestDescription#','QuotationEdit.cfm?Mode=#URL.Mode#&ID=#QuotationId#'], 

</cfoutput>
 
]


