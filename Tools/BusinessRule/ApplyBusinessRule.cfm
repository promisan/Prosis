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
<cfparam name="attributes.Datasource"   default="appsMaterials">
<cfparam name="attributes.TriggerGroup" default="Request">
<cfparam name="attributes.Mission"      default="Promisan">
<cfparam name="attributes.ConditionId"  default="">
<cfparam name="attributes.SourceId"     default="">
<cfparam name="attributes.SourceValue"  default="0">

<cfquery name="Validation" 
	datasource="#attributes.datasource#"
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_BusinessRule
	WHERE     Operational = 1 
	AND       Code IN
                  (SELECT    ValidationCode
                   FROM      Ref_MissionBusinessRule
                   WHERE     Mission = '#attributes.mission#')
	AND       TriggerGroup = '#attributes.triggergroup#'
</cfquery>

<cfset vStop = "no">

<cfloop query="validation">

	<cf_assignid>
	
	<cfset validationid = rowguid>

	<!--- apply the validation --->
	<cfinclude template="../../#validationpath#/#validationtemplate#">
	
	<!--- check result --->
			
	<cfquery name="getResult" 
		datasource="#attributes.datasource#"
		username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT    *
		FROM      ValidationAction V, ValidationActionSource VS
		WHERE     V.ValidationLogId      = VS.ValidationLogId
		AND       V.ValidationLogId     = '#validationid#'
		AND       VS.ValidationSourceId = '#attributes.SourceId#'	
	</cfquery>
	
	<cfif getResult.ValidationResult eq "9" and RuleClass eq "Stopper">
	
	    <cfif getResult.validationmemo neq "">
		
			<cfoutput>
				<script>
					alert("#getResult.validationmemo#")
				</script>
			</cfoutput>
			
		<cfelse>
		
			<cfoutput>
				<script>
					alert("Business Validation does not allow you to proceed")
				</script>
			</cfoutput>		
		
		</cfif>
		
		<cfset vStop = "yes">
		
		<!--- <cfabort> --->
		
	<cfelseif getResult.ValidationResult eq "9" and RuleClass eq "Alert">
	
		<cfif getResult.validationmemo neq "">
		
			<cfoutput>
			
				<script>
					alert("Alert: #getResult.validationmemo#")
				</script>
			
			</cfoutput>	
		
		</cfif>			
	
	</cfif>		

</cfloop>

<cfset caller._ValidationStopper = vStop>		

<!--- -------------------------------------- --->
<!--- check on the results of the validation --->
<!--- -------------------------------------- --->
