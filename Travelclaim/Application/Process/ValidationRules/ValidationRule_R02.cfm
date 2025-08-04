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
Validation Rule :  R02
Name			:  Travel under a DSA code different from the default DSA requires review
Steps			:  Determine if DSA code for a travel city is different from its default
Date			:  05 April 2006
Last date		:  15 June 2006
--->

<!--- query trip info for status 1 --->


<cfquery name="Default" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   DSA.LocationCode 
    FROM     ClaimLineDSA DSA INNER JOIN
             Ref_CountryCityLocation Def 
			  ON DSA.CountryCityId = Def.CountryCityId 
			 AND DSA.LocationCode = Def.LocationCode
    WHERE    ClaimId = '#URL.ClaimId#'
    AND      Def.LocationDefault = 1								
</cfquery> 

<cfquery name="Check" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
    SELECT DISTINCT LocationCode 
    FROM   ClaimLineDSA 
    WHERE  ClaimId = '#URL.ClaimId#' 
	AND    LocationCode is not NULL
</cfquery>	


<cfif Check.recordcount gt Default.recordcount and Check.recordcount gte "1">

	 <cf_ValidationInsert
    	ClaimId        = "#URL.ClaimId#"
		ClaimLineNo    = ""
		CalculationId  = "#rowguid#"
		ValidationCode = "#code#"
		ValidationMemo = "#Description#"
		Mission        = "#ClaimRequest.Mission#">
		
</cfif>	 		
		


