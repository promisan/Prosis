
<!--- set selected attribut values --->

<cfparam name="url.passtru" default="">
<cfparam name="url.mission" default="">

<cfparam name="url.conditionfield" default="mission">
<cfparam name="url.conditionvalue" default="#url.mission#">

<cfloop index="itm" from="1" to="3">
	
	<cfparam name="url.conditionvalueattribute#itm#" default="">
		
	<cfset val = evaluate("url.conditionvalueattribute#itm#")>
	
	<cfif isValid("GUID",url.systemfunctionid)>
				
		<cfquery name="MissionList" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE   UserModuleCondition 
			SET      ConditionValueAttribute#itm# = '#val#'
			WHERE    Account            = '#SESSION.acc#'
			AND      SystemFunctionId   = '#url.SystemFunctionId#' 
			AND      ConditionField     = '#url.conditionfield#' 	
			AND      ConditionValue     = '#url.conditionvalue#'  		
			    
		</cfquery>
	
	</cfif>
	
</cfloop>

<cfif url.passtru neq "">
	<cfinclude template="#url.passtru#">
</cfif>	

