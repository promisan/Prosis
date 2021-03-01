
<cfparam name="url.id"   default="">
<cfparam name="url.mode" default="init">

<cfquery name="SessionAction" 
datasource="AppsOrganization">
	SELECT 	S.*
	FROM   	OrganizationObjectActionSession S	
	WHERE  	S.ActionSessionId = <cfqueryparam	value="#URL.ID#" cfsqltype="CF_SQL_IDSTAMP"> 	
</cfquery>

<cfif SessionAction.ActionId neq "">

	
	<cfif url.mode eq "init">	

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
								
			<cfif Action.ActionStatus neq "0">
						
				<cfoutput>
					Your #Object.Mission# input form is no longer active.
					<div class="subtitle">Please contact your administrator if you believe this is not correct.</div>
				</cfoutput>  
									
				<cfset go = "0">	
												
			<cfelseif now() lt SessionAction.SessionPlanStart and sessionAction.SessionPlanStart neq "">	
			
										
				<cfif dateformat(now(),client.dateformatshow) eq dateformat(SessionAction.SessionPlanStart,client.dateformatshow)>
					
					<cfset min = "1">		
													
								
					<cfset min = dateDiff("n",  now(), SessionAction.SessionPlanStart)>			
					
					<cfoutput>
						Your session is not available yet.
						<div class="subtitle">It will start in 
						<cfif min gte "2">
						<span style="font-size:30px">#min#</span>&nbsp;minutes
						<cfelse>
						<span style="color:red;font-size:30px">#min#</span>&nbsp;minute
						</cfif> 
						[local time: #timeformat(now(),"HH:MM")#]</div>	
					</cfoutput>  
							
				
				<cfelse>
					
				
					<cfoutput>
						Your #Object.Mission# request action is not accessible yet.
						
						<div class="subtitle">						
						It will be available starting #timeformat(SessionAction.SessionPlanStart,"HH:MM")#
						 (#dateformat(SessionAction.SessionPlanStart,client.dateformatshow)#) 						
						<br>local time: #dateformat(now(),client.dateformatshow)# #timeformat(now(),"HH:MM")#
						
						</div>	
				</cfoutput>  
					
				
				</cfif>		
				
													
				<cfset go = "0">			
			
			<cfelseif now() gt SessionAction.SessionPlanEnd and sessionAction.SessionPlanEnd neq "">	
			
		
				<cfoutput>
					Your #Object.Mission# input form is no longer available.
					<div class="subtitle">It has expired at #timeformat(SessionAction.SessionPlanEnd,"HH:MM")# (#dateformat(SessionAction.SessionPlanEnd,client.dateformatshow)#) 
					local time: #timeformat(now(),"HH:MM")#</div>	
				</cfoutput>  				
				
				<cfset go = "0">
				
			<cfelseif SessionAction.SessionIP neq CGI.Remote_Addr>
			
				<cfoutput>
					Your #Object.Mission# input form may not be accessed from different locations.
					<div class="subtitle">Please contact your administrator if you believe this is not correct.</div>
				</cfoutput>  
										
				<cfset go = "0">		
			
			</cfif>
						
			<cfquery name="Document" 
			datasource="AppsOrganization">
				SELECT *
				FROM   Ref_EntityDocument
				WHERE  DocumentId = '#SessionAction.SessionDocumentId#'	 
			</cfquery>	
			
			<cfset doc = Document.DocumentTemplate>
			
			<cfif go eq "1">									
				
				<cfoutput>
				<script>
				  ptoken.location('#SESSION.root#/Tools/EntityAction/Session/ActionSessionContent.cfm?actionsessionid=#url.id#')
				</script>	
				</cfoutput>
									
			</cfif>
			
	<cfelse>
	
	     <cfif now() lt SessionAction.SessionPlanEnd and sessionAction.SessionPlanEnd neq "">			
													
			<cfset min = dateDiff("n",  now(), SessionAction.SessionPlanEnd)>	
			<cfset sec = dateDiff("s",  now(), SessionAction.SessionPlanEnd)>	
			<cfset sec = sec - min*60>	
			<cfif sec lt 10>
				<cfset sec = "0#sec#">
			</cfif>
			
			<cfoutput>
				Expiry in 
				<div class="subtitle">
				<cfif min gte "2">
				<span style="font-size:30px">#min#</span>&nbsp;minutes
				<cfelse>
				<span style="color:red;font-size:30px">#min#</span><span style="color:red;font-size:20px">:#sec#</span>
				</cfif> 
				</div>	
			</cfoutput>  				
			
		<cfelse>
		
			<cfoutput>
				<script>
				  ptoken.location('#SESSION.root#/ActionSession.cfm?id=#url.id#')
				</script>	
			</cfoutput>
			
		</cfif>			

	</cfif>
	
			
</cfif>


