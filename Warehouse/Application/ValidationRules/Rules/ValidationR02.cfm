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
<!--- -----Rule ItemLocation :
      ---  Ensure the meter reading matches the total ----------------------------- --->
<!--- ----------------------------------------------------------------------------- --->


<!--- I decided to add this to the view instead --->

<cfquery name="get"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
		FROM     ItemWarehouseLocation 	
		WHERE    ItemLocationId  = '#attributes.sourceid#'				
</cfquery>	

<cfif get.readingClosing eq "" or get.ReadingOpening eq "">

<cfelse>
				
	<cfset actual = get.readingClosing - get.ReadingOpening>
			
	<cfif actual neq "">
				
			<cfset diff = actual-abs(attributes.sourcevalue)>
			
			<cfif abs(diff) gte 0.5>
			
				 <cf_ApplyBusinessRuleResult
				    ValidationId     = "#rowguid#"
				    Datasource       = "#attributes.datasource#"
					Source           = "#TriggerGroup#"
					SourceId         = "#attributes.sourceid#"
					BusinessRule     = "#Code#"	
					Result           = "9"			
					ValidationMemo   = "The increment of the meter (closing-opening) does not match the quatity of the batch transactions : [#actual#] versus [#attributes.sourcevalue#]">
					
			</cfif>
						
	</cfif>

</cfif>

<!--- ------------------------------ --->
<!--- --------- end of query-------- --->
<!--- ------------------------------ --->
