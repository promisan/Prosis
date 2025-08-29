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
<!--- 
Validation Rule :  R15
Name			:  Checking obviously incorrect itinerary/DSA data 
Creation Date	:  22 March 2009
Created         :  FDT
This validation is created because in very cases claims with inconsistent data were submitted:
- Detailed Claim without time in the intinerary 
- Detailed Claim with DSA lines but no rate (and therefore incorrectly 0 amount)
---->


<cfquery name="IncompleteITN" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	Select *
	from claim C
 	inner join claimevent CE on C.claimid = CE.Claimid
 	inner join claimeventtrip CET on CE.claimeventid = CET.claimeventid
	where 
 	C.claimid = '#URL.claimid#'
 	AND C.claimasis = 0
 	AND CET.actionstatus = 0
</cfquery>	

<cfquery name="IncompleteDSALine" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	Select *
	from claimlinedsa CD
	 inner join CLAIM C on C.claimid = CD.Claimid
	where 
 	 		C.claimid = '#URL.claimid#'
	 AND 	C.claimasis = 0
 	 AND 	Rate IS NULL AND LocationCode IS NOT NULL
</cfquery> 
<!--- FDT 23/03/2009: the only valid case where there is no rate for a detailed claim is a trip of less than 10 hours 
In these cases, in the current programs, the Location Code is NULL too in these cases so we use the condition
"LocationCode IS NOT NULL" to exclude these short trips. 
Ideally there would indicators in the Claim table to recognize 1) same day trip 2) trip of less than 10 hours.  --->

<cfif #IncompleteITN.recordcount# gt 0 OR #IncompleteDSALine.recordcount# gt 0>

		 <cf_ValidationInsert
	    	ClaimId        = "#URL.ClaimId#"
			ClaimLineNo    = ""
			CalculationId  = "#rowguid#"
			ValidationCode = "#code#"
			ValidationMemo = "#Description#"
			Mission        = "#ClaimRequest.Mission#">

</cfif>	


		