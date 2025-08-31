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
<cfquery name="Update" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	UPDATE RequisitionLineQuote
	SET    Award           = NULL,
	       AwardRemarks    = NULL,
	       Selected        = 0
	WHERE  JobNo = '#URL.ID1#'
	AND    RequisitionNo IN (SELECT RequisitionNo 
	                         FROM   RequisitionLine 
							 WHERE  ActionStatus IN ('2k','2q'))
</cfquery>

<cfquery name="Job" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT * 
	FROM   Job 
	WHERE  JobNo ='#URL.Id1#'
</cfquery>

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM Ref_ParameterMission
		WHERE Mission = '#Job.Mission#' 
</cfquery>

<cfquery name="Update" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	UPDATE RequisitionLineQuote
	SET    Award           = '#Parameter.AwardLowestBid#',
	       Selected        = 1
	WHERE  JobNo = '#URL.ID1#'
	  AND  OrgUnitVendor = '#URL.OrgUnit#'
</cfquery>

<cfoutput>

<cfinclude template="JobViewVendor.cfm">

<script>
   if (document.getElementById('fundingstatus')) {
	ptoken.navigate('JobFundingSufficient.cfm?id1=#url.id1#','fundingstatus')
	}
</script>

</cfoutput>
