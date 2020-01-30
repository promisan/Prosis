
<!--- 
   Name : /Component/Process/System/SystemError.cfc
   Description : Validation Functions  
   1.1.  TagSystemError
   1.2.  ...
   1.3.  ...
   1.4.  ...    
---> 

<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Validation Queries">
	
	<cffunction name="TagSystemError"
        access="public"
        returntype="string"
        displayname="Validate Threshold for WorkOrder Line">
		
		<cfargument name="ExecutionScope"  type="string" 	required="true"  default="Today">	 <!--- valid Scopes: Today, Yesterday, All --->
		<cfargument name="UserScope"       type="string" 	required="true"  default="">	
				
		<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#_ErrorDetail">
		<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#_ErrorDistinct">
					
		<cfif ExecutionScope eq "Today">
			<cfset vStartDate = DateFormat(now(),"YYYY-MM-DD")>	
		<cfelseif ExecutionScope eq "Yesterday">
			<cfset vStartDate = DateFormat(now()-1,"YYYY-MM-DD")>
		<cfelse>
			<cfset vStartDate = "">		
		</cfif>
		
		<cfset vEndDate = DateFormat(now(),"YYYY-MM-DD")>	

		<!--- Get the errors depending on the scope --->
		<cfquery name="GetErrors" 
		   	 	datasource="AppsQuery"
		 		username="#SESSION.login#" 
				password="#SESSION.dbpw#">
						
			SELECT 	ErrorNo,
					ErrorId, 
					Account,
					HostName,
					HostServer,
					NodeIp,
					ErrorTimeStamp,
					ErrorTemplate,
					ErrorContent,  
					system.dbo.ScrapeText(ErrorDiagnostics) as ErrorDiagnostics, 
					ErrorString,
					ErrorEmail
					
			INTO    UserQuery.dbo.#SESSION.acc#_ErrorDetail
			FROM    System.dbo.usererror

			WHERE   1=1
			<cfif ExecutionScope neq "All">
				AND ErrorTimeStamp BETWEEN 	'#DateFormat(vStartDate,"YYYY-MM-DD")# 00:00:00' AND '#DateFormat(vEndDate,"YYYY-MM-DD")# 23:59:59'
			</cfif>
			
			<cfif ExecutionScope neq "All">
			   AND Account = '#UserScope#'
			</cfif>			
			
		</cfquery>	

		<!--- Group the errors to clean duplicates --->		
		<cfquery name="GetDistinctErrors" 
		   	 	datasource="AppsQuery"
		 	 	username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			
				SELECT 	Account,
						HostName,
						HostServer,
						NodeIp,
						ErrorTemplate,
						system.dbo.ScrapeText(ErrorDiagnostics) as ErrorDiagnostics,					
						CONVERT(varchar,ErrorTimeStamp,103) as ErrorDate,
						MIN(ErrorString) AS ErrorString,
						MIN(ErrorNo) as ErrorNo,
						MIN(ErrorTimeStamp) as ErrorTimeStamp,
						COUNT(1) as ErrorCount
				INTO    UserQuery.dbo.#SESSION.acc#_ErrorDistinct
				FROM    UserQuery.dbo.#SESSION.acc#_ErrorDetail
				
				GROUP BY Account,
				         HostName,
						 HostServer,
						 NodeIp,
						 ErrorTemplate,
						 system.dbo.ScrapeText(ErrorDiagnostics),
						 CONVERT(varchar,ErrorTimeStamp,103)
				ORDER BY MIN(ErrorNo)
			
		</cfquery>	
		
		<!--- Disable the duplicated records for showing in the screen --->
		<cfquery name="UpdateDuplicated" 
		   	 	datasource="AppsSystem"
		 	 	username="#SESSION.login#" 
				password="#SESSION.dbpw#">			
				UPDATE   UserError
				SET      EnableProcess = 0
				FROM     UserError E
				WHERE    ErrorNo IN (
							SELECT ErrorNo
							FROM UserQuery.dbo.#SESSION.acc#_ErrorDetail WHERE ErrorNo = E.ErrorNo)
				AND      ErrorNo NOT IN (
							SELECT ErrorNo
							FROM  UserQuery.dbo.#SESSION.acc#_ErrorDistinct WHERE ErrorNo = E.ErrorNo)
		</cfquery>		
		
		<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#_ErrorDetail">
		<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#_ErrorDistinct">	

	</cffunction>	
</cfcomponent>			 