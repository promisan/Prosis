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

<!--- 
Validation Rule :  I15
Name			:  Prevent inconsisten travel request
Steps			:  Determine fund type of travel request and determine if fund/period is closed
Date			:  05 August 2007
Last date		:  05 October 2007
--->

	<cfquery name="Event" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
    FROM ClaimEvent C
    WHERE ClaimId = '#Claim.ClaimId#' 
	ORDER BY EventOrder, EventDateEffective
	</cfquery>	
	
	<cfoutput query="Event">
	<cfif currentrow eq "1">
	  <cfset pr = eventDateEffective>
	<cfelse>
		<cfif eventDateEffective lt pr>
		
			 <cfset submission = "0">
			 
			 <tr><td valign="top" bgcolor="C0C0C0"></td></tr>
			 <tr>
			  <td valign="top" bgcolor="FDDFDB">
			  <table width="94%" cellspacing="2" cellpadding="2" align="center">
			  <tr><td valign="top" height="30">
			      <font color="FF0000"><b>Problem</b></font> : You may NOT submit this claim.
			      <br>
				  <cfoutput>#MessagePerson#</cfoutput>
				  <br>
				  </td></tr>
			  </table>
			  </td>	  
		     </tr>   
					
		</cfif>
	</cfif>
	</cfoutput>	
	