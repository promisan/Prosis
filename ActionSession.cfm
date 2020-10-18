
<cftry>
	
	<cfquery name="SessionAction" 
	 datasource="AppsOrganization">
		 SELECT *
		 FROM   OrganizationObjectActionSession 		
		 WHERE  ActionSessionId = <cfqueryparam	value="#URL.ID#" cfsqltype="CF_SQL_IDSTAMP"> 	
	</cfquery>
	
	<!---
	<cfif SessionAction.recordcount eq "1" and SessionAction.SessionDocumentId neq "">
	--->
	
							
	<cfif SessionAction.recordcount eq "1">
	
		<cfquery name="Entity" 
		 datasource="AppsOrganization">
		 	 SELECT *
			 FROM   Ref_Entity
			 WHERE  EntityCode = '#SessionAction.EntityCode#'	 
		</cfquery>		
		
		
		<cfquery name="Document" 
		 datasource="AppsOrganization">
		 	 SELECT *
			 FROM   Ref_EntityDocument
			 WHERE  DocumentId = '#SessionAction.SessionDocumentId#'	 
		</cfquery>	
		
		<cfset doc = Document.DocumentTemplate>
							
		<cfset go = "1">	
		 		
		<cfif SessionAction.ActionId neq "">
						
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
			
			<!--- set the IP --->
			
			<cfif SessionAction.SessionIP eq "">
			
				<cfquery name="SessionAction" 
				 datasource="AppsOrganization">
					 UPDATE  OrganizationObjectActionSession 		
					 SET     SessionIP = '#CGI.Remote_Addr#', SessionActualStart = getDate()				 
					 WHERE   ActionSessionId = <cfqueryparam	value="#URL.ID#" cfsqltype="CF_SQL_IDSTAMP"> 	
				</cfquery>		
			
			</cfif>
			
			<cf_publicinit>
						
			<table width="90%" cellspacing="2" cellpadding="2">
			
			<cfif Action.ActionStatus neq "0">
							
				<tr><td align="center" style="padding-top:40px;color:red;font-size:23px" class="labelmedium">
				<cfoutput>
				  Your #Object.Mission# Input form is not no longer active. <br><font size="2" color="0A72AF">Please contact your administrator if you believe this is not correct</p>.	
				</cfoutput>  
				</td></tr>
				
				<cfset go = "0">	
								
			<cfelseif now() lt SessionAction.SessionPlanStart and sessionAction.SessionPlanStart neq "">			
				
					<tr>
					<td align="center" style="padding-top:40px;color:red;font-size:25px" class="labelmedium">
					<cfoutput>					
					Your #Object.Mission# Input form is not enabled yet. <br><font size="3" color="0A72AF">It will be available starting #timeformat(SessionAction.SessionPlanStart,"HH:MM")# (#dateformat(SessionAction.SessionPlanStart,client.dateformatshow)#) Local time</p>.	
					</cfoutput>
					</td>
					</tr>				
				
				<cfset go = "0">			
			
			<cfelseif now() gt SessionAction.SessionPlanEnd and sessionAction.SessionPlanEnd neq "">	
			    	
					<tr>
					<td align="center" style="padding-top:40px;color:red;font-size:25px" class="labelmedium">
					<cfoutput>					
					Your #Object.Mission# Input form is no longer available. <br><font size="3" color="0A72AF">It expired #timeformat(SessionAction.SessionPlanEnd,"HH:MM")# (#dateformat(SessionAction.SessionPlanEnd,client.dateformatshow)#) Local time</p>.	
					</cfoutput>
					</td>
					</tr>				
				
				<cfset go = "0">
				
			<cfelseif SessionAction.SessionIP neq CGI.Remote_Addr>
						
			    <tr><td align="center" style="padding-top:40px;color:red;font-size:23px" class="labelmedium">
				 <cfoutput>
				  Your #Object.Mission# Input form may not be accessed from different locations. <br><font size="2" color="0A72AF">Please contact your administrator if you believe this is not correct</p>.	
				 </cfoutput>  
				</td></tr>	
				
				<cfset go = "0">		
			
			</cfif>
									
			</table>
					
		</cfif>
		
		<cfif go eq "1">
					
			<cfinvoke component="Service.Process.System.Security" method="passtru" returnvariable="hashvalue"/>				
			<cflocation url="#SESSION.root#/#doc#?actionsessionid=#url.id#&#hashvalue#" addtoken="No"> 
			
		</cfif>
					
	<cfelse>
		
		<cf_screentop html="No" title="Problem">
		
		<table width="90%" height="90" class="formpadding">
			<tr>
			<td align="center" style="font-size:20px" class="labelmedium">			
		  		<b>Attention:</b> Requested document has been processed already or does not longer exist.					
			</td>
			</tr>
		</table>
		
	</cfif>
	
	
	<cfcatch>

	<cf_screentop html="No" title="Problem">
	
	<table width="90%" cellspacing="2" cellpadding="2">
	<tr><td align="center" style="padding-top:40px;color:red;font-size:23px" class="labelmedium">
	  Form could not be retrieved. <br><font size="2" color="0A72AF">Please contact your focal point if the problem persists</p>.	
	</td></tr>
	</table>
	
	</cfcatch>

</cftry>


