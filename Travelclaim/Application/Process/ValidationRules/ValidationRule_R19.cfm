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
Validation Rule :  R19
Name			:  Checking whether The Travel Involved Heiti Travel and the Traveller Indicated Accomadation Provided
Creation Date	:  21-Apr-2010
Created         :  JG3
This validation is created  of the Circular from OHRM on Haiti Condition and to provide them with 100 %  DSA. Since this is a 
temporary arrangement we are just creating a validation which will trigger such condition and set it as incomplete and then 
accounts would manually change the amount depending on the situation and approve it.

---->
<!---
JG Find out whether Location the S/M has travelled involves HAI
--->
<cfquery name="IncompleteDSAHAI" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
select * from Claim C inner join ClaimlineDSA DSA  on C.claimid =DSA.claimid
where C.claimid ='#URL.claimid#'
and  DSA.LocationCode like 'HAI%'
</cfquery>

<cfif #IncompleteDSAHAI.recordcount# gt 0 OR #IncompleteDSAHAI.recordcount# gt 0>
		<!---
		JG IF HAI is involved check whether Accomdation provided Indicator is ON (Chosen by the Traveller)

		According to theEmail from Benny dated 20-04-2010 
 		"Can the portal be configured to always create "unapproved claim" 
 		when there is a travel to Haiti and the traveler indicates "accommodation provided" 
 		This is enforced
 		--->
	<cfquery name="ITNACCO" 
 		datasource="appsTravelClaim" 
 		username="#SESSION.login#" 
 		password="#SESSION.dbpw#">
 			select *
            from     claimlinedateindicator b
            where indicatorcode ='T03' and 
            claimid='#URL.Claimid#'
	</cfquery>
	<cfif #ITNACCO.recordcount# gt 0 OR #ITNACCO.recordcount# gt 0>
		<cf_ValidationInsert
	    	ClaimId        = "#URL.ClaimId#"
			ClaimLineNo    = ""
			CalculationId  = "#rowguid#"
			ValidationCode = "#code#"
			ValidationMemo = "#Description#"
			Mission        = "#ClaimRequest.Mission#">
	
	</cfif>
	
</cfif>








		