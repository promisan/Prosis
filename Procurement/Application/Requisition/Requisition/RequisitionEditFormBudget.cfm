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

<!--- budget definition 

steps

1. define if budget needs to be shown

Budget NO
2.0 i Clean possible entries
2.1 hide entry screen

Budget YES
3.0  determine if same edition, if not clean as well
3.1  show entry screen

--->

<cfquery name="Budget" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_ParameterMissionEntryClass
	WHERE   Mission = '#url.mission#' 
	AND 	Period = '#url.period#' 
	AND     EntryClass IN
                     (SELECT   entryClass
                      FROM     ItemMaster
                       WHERE   Code = '#url.itemmaster#')
</cfquery>			
 			
<cfif Budget.EditionId eq "">

	<!--- no budget required --->
	
	<cfquery name="Budget" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM RequisitionLineBudget
		WHERE  RequisitionNo = '#URL.RequisitionNo#'
	</cfquery>
	
	<script>
	
		document.getElementById("budgetentry1").className = "hide"
		document.getElementById("budgetentry2").className = "hide"
	
	</script>
	
<cfelse>

	<cfquery name="Clean" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM RequisitionLineBudget
		WHERE  RequisitionNo = '#URL.RequisitionNo#'
		AND    EditionId    <> '#Budget.EditionId#'
	</cfquery>
	
	<cfoutput>
		<input type="hidden" name="editionid" id="editionid" value="#Budget.EditionId#">
	</cfoutput>
	
	<script>
		document.getElementById("budgetentry1").className = "regular"
		document.getElementById("budgetentry2").className = "regular"
		budget()
	</script>
	
</cfif>
