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
<table width="100%"      
       border="0"
       cellspacing="0"
       cellpadding="0"
	   class="formpadding">

<tr><td valign="top">

	<table width="92%"  align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">
				
		  <tr><td class="labelmedium">
		  	
		<cfquery name="Line" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   RequisitionLineQuote Q, 
			       Organization.dbo.Organization O
			WHERE  Q.OrgUnitVendor = O.OrgUnit
			AND    QuotationId = '#URL.ID#'
		</cfquery>
		
		<cfquery name="Job" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   Job Q
		WHERE  JobNo         = '#Line.JobNo#'  		
	</cfquery>
	
		<cfoutput>#Line.OrgUnitName#</cfoutput>
	
	</td>
	
	</tr>
	
	<cfquery name="Contract" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   RequisitionLineQuote Q
		WHERE  JobNo         = '#Line.JobNo#'  
		AND    OrgUnitVendor = '#Line.OrgUnitVendor#'
	    AND    Selected      = 1
	</cfquery>
	
	<cfif contract.recordcount gte "1">
	
	<cfoutput>
	<tr><td height="1"></td></tr>
	<tr><td class="labelmedium"><a href="../Insurance/Insurance.cfm?jobno=#line.jobno#&orgunit=#line.orgunitvendor#" target="right"><font color="2894FF">Contract Details</a></td></tr>
	<tr><td height="2"></td></tr>
	</cfoutput>
	
	</cfif>
	  
	<cfquery name="Quote" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT DISTINCT RequestDescription, Q.QuotationId
	    FROM   RequisitionLine R, RequisitionLineQuote Q
		WHERE  R.JobNo = Q.JobNo
		AND    R.RequisitionNo = Q.RequisitionNo
		AND    Q.OrgUnitVendor = '#Line.OrgUnitVendor#'
		AND    R.JobNo = '#Line.JobNo#' 
		AND    R.ActionStatus != '9' 
		AND    R.Mission = '#Job.Mission#'
	</cfquery>
			
	<cfoutput query="Quote">
		
		<tr><td style="padding-left:8px;word-wrap: break-word; word-break: normal;" class="labelmedium">			
			<a target="right" href="QuotationEdit.cfm?Mode=#URL.Mode#&ID=#QuotationId#"><font color="0080FF">#RequestDescription#</font></a>
		</td></tr>
	
	</cfoutput>
	  
	</table>	
	
</td></tr>
	
</table>
