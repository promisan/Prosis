
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
