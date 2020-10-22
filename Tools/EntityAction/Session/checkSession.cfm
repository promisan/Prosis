
<cfparam name="id" default="">

<cfquery name="SessionAction" 
datasource="AppsOrganization">
	SELECT 	S.*
	FROM   	OrganizationObjectActionSession S	
	WHERE  	S.ActionSessionId = <cfqueryparam	value="#URL.ID#" cfsqltype="CF_SQL_IDSTAMP"> 	
</cfquery>

<cfif SessionAction.ActionId neq "">

	<cfset go = "1">
	
	<cfquery name="Action" 
		datasource="AppsOrganization">
			SELECT *
			FROM   OrganizationObjectAction		
			WHERE  ActionId = '#SessionAction.ActionId#'	
	</cfquery>
	
	<cfquery name="Object" 
	datasource="AppsOrganization">
		SELECT *
		FROM   OrganizationObject	
		WHERE  ObjectId = '#Action.ObjectId#'	
	</cfquery>

	<cfif Action.ActionStatus eq "0">
				
		<cfoutput>
			Your #Object.Mission# input form is not no longer active.
			<div class="subtitle">Please contact your administrator if you believe this is not correct.</div>
		</cfoutput>  
							
		<cfset go = "0">	
										
	<cfelseif now() lt SessionAction.SessionPlanStart and sessionAction.SessionPlanStart neq "">			
				
		<cfoutput>
			Your #Object.Mission# input form is not enabled yet.
			<div class="subtitle">It will be available starting #timeformat(SessionAction.SessionPlanStart,"HH:MM")# (#dateformat(SessionAction.SessionPlanStart,client.dateformatshow)#) local time.</div>	
		</cfoutput>  
									
		<cfset go = "0">			
	
	<cfelseif now() gt SessionAction.SessionPlanEnd and sessionAction.SessionPlanEnd neq "">	

		<cfoutput>
			Your #Object.Mission# input form is no longer available.
			<div class="subtitle">It expired #timeformat(SessionAction.SessionPlanEnd,"HH:MM")# (#dateformat(SessionAction.SessionPlanEnd,client.dateformatshow)#) local time.</div>	
		</cfoutput>  				
		<cfset go = "0">
		
	<cfelseif SessionAction.SessionIP neq CGI.Remote_Addr>

		<cfoutput>
			Your #Object.Mission# input form may not be accessed from different locations.
			<div class="subtitle">Please contact your administrator if you believe this is not correct.</div>
		</cfoutput>  
				
		<cfset go = "0">		
	
	</cfif>
	
	<cfif go eq "1">
								
		<cfinvoke component="Service.Process.System.Security" method="passtru" returnvariable="hashvalue"/>				
		<cflocation url="#SESSION.root#/#doc#?actionsessionid=#url.id#&#hashvalue#" addtoken="No"> 
					
	</cfif>

</cfif>
