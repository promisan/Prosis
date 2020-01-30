<cfquery name="Mis" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_ParameterMission		
	WHERE  Mission IN (SELECT Mission FROM Organization.dbo.Ref_MissionModule WHERE SystemModule = 'WorkOrder')
</cfquery>

<cfloop query="Mis">

	 <cfquery name="getMission" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   ServiceItemMission
		WHERE  ServiceItem = '#url.id1#'	
		AND    Mission = '#mission#'
	</cfquery>
	
	<cfparam name="Form.#Mission#_Journal"               default="">
	<cfparam name="Form.#Mission#_DateChargesCalculate"  default="">
	<cfparam name="Form.#Mission#_DatePostingStart"      default="">
	<cfparam name="Form.#Mission#_DatePostingCalculate"  default="">
	<cfparam name="Form.#Mission#_DatePortalProcessing"  default="">
	
	<cfset ope = 0>
	<cfif isDefined("Form.#Mission#_Operational")>
		<cfset ope = 1>
	</cfif>
	
	<cfset showExp = 0>
	<cfif isDefined("Form.#Mission#_ShowExpiredLines")>
		<cfset showExp = 1>
	</cfif>
	
	<cfset jrn = evaluate("Form.#Mission#_Journal")>
	<cfset expDays = evaluate("Form.#Mission#_DaysExpiration")>
	<cfif expDays eq "">
	  <cfset expDays = "0">
	</cfif>
	
	<cfset chg  = evaluate("Form.#Mission#_DateChargesCalculate")>
	<cfset posS = evaluate("Form.#Mission#_DatePostingStart")>
	<cfset posC = evaluate("Form.#Mission#_DatePostingCalculate")>
	<cfset por  = evaluate("Form.#Mission#_DatePortalProcessing")>
	
	<cfset dateValue = "">
	<cf_DateConvert Value="#chg#">
	<cfset vCharges = dateValue>
	
	<cfset dateValue = "">
	<cf_DateConvert Value="#posS#">
	<cfset vPostingStart = dateValue>
	
	<cfset dateValue = "">
	<cf_DateConvert Value="#posC#">
	<cfset vPostingCalculate = dateValue>
	
	<cfset dateValue = "">
	<cf_DateConvert Value="#por#">
	<cfset vPortal = dateValue>
	
	<cfif getMission.recordcount eq "0" and ope eq "1">
	
	   <cfquery name="insertMission" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO ServiceItemMission
				(ServiceItem,
				Mission, 
				<!---
				Journal, 
				--->
				<cfif chg neq "">DateChargesCalculate, </cfif>
				<cfif posS neq "">DatePostingStart, </cfif>
				<cfif posC neq "">DatePostingCalculate, </cfif>
				<cfif por neq "">DatePortalProcessing, </cfif>
				SettingDaysExpiration,
				SettingShowExpiredLines,
				Operational, 
				officerUserId,
				OfficerLastName,
				OfficerFirstName)
			VALUES
				('#url.id1#',
				'#mission#',
				<!---
				'#jrn#', 
				--->
				<cfif chg neq "">#vCharges#, </cfif>
				<cfif posS neq "">#vPostingStart#, </cfif>
				<cfif posC neq "">#vPostingCalculate#, </cfif>
				<cfif por neq "">#vPortal#, </cfif>
				'#expDays#',
				'#showExp#',
				'#ope#',
				'#SESSION.acc#',
				'#SESSION.last#',
				'#SESSION.first#')
		</cfquery>
		
	<cfelseif ope eq "0">
	
		 <cfquery name="getMission" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE  ServiceItemMission		
			WHERE 	ServiceItem = '#url.id1#'	
			AND   	Mission = '#mission#'
		</cfquery>
		
	</cfif>
	
	 <cfquery name="getMission" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE 	ServiceItemMission
		SET 	Operational = #ope#,
				SettingShowExpiredLines = #showExp#,
				DateChargesCalculate = <cfif chg neq "">#vCharges#<cfelse>null</cfif>,
				DatePostingStart = <cfif posS neq "">#vPostingStart#<cfelse>null</cfif>,
				DatePostingCalculate = <cfif posC neq "">#vPostingCalculate#<cfelse>null</cfif>,
				DatePortalProcessing = <cfif por neq "">#vPortal#<cfelse>null</cfif>,
				<!--- Journal = '#jrn#', --->
				SettingDaysExpiration = #expDays#
		WHERE 	ServiceItem = '#url.id1#'	
		AND   	Mission = '#mission#'
	</cfquery>

</cfloop>

<cfoutput>
	<script>
		ColdFusion.navigate('FinancialsListing.cfm?id1=#url.id1#','contentbox2');
	</script>
</cfoutput>