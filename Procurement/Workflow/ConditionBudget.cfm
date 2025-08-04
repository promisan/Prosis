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

<!--- -------------------------------------------------------- --->
<!--- validation condition script for budget sufficiency check --->
<!--- -------------------------------------------------------- --->

<cfquery name="Check" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 SELECT     P.*
	 FROM       ItemMaster IM INNER JOIN
                RequisitionLine L ON IM.Code = L.ItemMaster INNER JOIN
                Ref_ParameterMissionEntryClass P ON IM.EntryClass = P.EntryClass 
			AND L.Mission = P.Mission 
			AND L.Period = P.Period
	 WHERE      L.RequisitionNo = '#Object.ObjectKeyValue1#' 
</cfquery>	

<cfset Funds = "No">

<cfif Check.EntityClass neq "" and Check.EditionId neq "">

	   	<CF_RequisitionFundingCheck 
		     RequisitionNo = "'#Object.ObjectKeyValue1#'" 
			 editionid     = "#check.editionid#">
			 
		<!--- method will set the variable funds --->
		
</cfif>
