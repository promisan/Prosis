<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Execution Queries">
	
	<cffunction name="ProcessNotification"
        access="public"
        returntype="any" >
								
			<cfargument name="mission" 				type="string" 	required="true" 	default="">
			<cfargument name="serviceItem" 			type="string" 	required="true" 	default="">	
			<cfargument name="Action" 				type="string" 	required="true" 	default="">	
			<cfargument name="Notification" 		type="string" 	required="true" 	default="">
			<cfargument name="PersonNo" 			type="string" 	required="false" 	default="">	
			<cfargument name="SerialNo" 			type="string" 	required="false" 	default="">					
			
			<cfquery name="getNotification" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
				SELECT *
				FROM Ref_ActionServiceItemNotification
				WHERE ServiceItem = '#serviceItem#'
				AND Action = '#Action#'
				AND Notification = '#Notification#'
				AND Operational = 1				
			</cfquery>		
			
			<cftry>
			
				<cfif getNotification.TemplatePath neq "">
					<cfinclude template="../../../#getNotification.TemplatePath#">
				</cfif>		
			
				<cfcatch>
				
					<script language="JavaScript">
						alert("Sorry we were not able to sent a notification to your account.")
					</script>
								
				</cfcatch>	
			
			</cftry>
			
	</cffunction>

</cfcomponent>	