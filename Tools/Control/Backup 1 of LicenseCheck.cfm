<cfparam name="Attributes.Module"    default="">	
<cfparam name="Attributes.Mission"   default="'ALL'">	
<cfparam name="Attributes.Message"   default="Yes">	
<cfparam name="Attributes.LicenseId" default="">	
<cfparam name="Attributes.Mode"      default="">	

<!--- Instatiating license object--->
<cfset oLicense = CreateObject("component","Service.Process.System.License")/>

<cfset caller.license  = "0">
<cfset caller.vyear    = "">
<cfset caller.vquarter = "">

<cfquery name="Parameter" 
    datasource="appsSystem">
     SELECT TOP 1 
	 	    DatabaseServer, 
		    DatabaseServerLicenseId
	 FROM   Parameter
</cfquery>

<cfif NOT IsDefined("SESSION.SystemHost")>

	<!---- Due to a compatibilty issue on CFMX 10, now, Getting password from CF Administrator pwd from database should fill a CLIENT.ServerName ---->

	<cfquery name="Init" 
	   datasource="AppsInit">
		SELECT * 
		FROM   Parameter
		WHERE  HostName = '#CGI.HTTP_HOST#'
	</cfquery>

	<cfquery name="qPwd" 
	datasource="AppsInit">
		SELECT CFAdminUser, CFAdminPassword
		FROM   Parameter 
		WHERE  ApplicationServer = '#Init.ApplicationServer#'
	</cfquery>

	<cfset vUser = "#qPWd.CFAdminUser#" >
	
	<cftry>

		<cf_decrypt text = "#qPWd.CFAdminPassword#">
		<cfset vPass = "#Decrypted#">

	<cfcatch>
			<cf_message Message = "Please Upgrade your server License  - 1041, contact your network administrator" return="no">		
			<cfabort>
	</cfcatch>	

	</cftry>
	
	<!--- Getting database server from the the datasources, it has to be the same --->
	
	<cfinvoke component="CFIDE.adminapi.administrator" method="login">
		<cfinvokeargument name="adminUserId"   value="#vUser#"/>
		<cfinvokeargument name="adminPassword" value="#vPass#"/>
	</cfinvoke>
		
	<cftry>
		<cfinvoke component="CFIDE.adminapi.datasource" method="getDatasources" returnvariable="getDatasourcesRet"/>
	<cfcatch>
		<cf_message Message = "Please Upgrade your server License  - 1042, contact your network administrator" return="no">			
		<cfabort>
	</cfcatch>	
	</cftry>	
				
	<cfset SESSION.SystemHost = "#getDataSourcesRet['AppsSystem']['urlmap']['host']#">		
	
</cfif>

<cfset vHost = SESSION.SystemHost>		

<cfset _ALLOW_DB_SERVER = FALSE>

<cfif vHost eq Parameter.DatabaseServer>

	<!---- Now, checking for the database server License --->
	<cfloop index="yr" from="#Year(now())#" to="#Year(now())+3#" step="1">
	
		 <cfset from = 1>
		 <cfif yr eq year(now())>
		 	<cfset from = quarter(now())>
		 </cfif>
	
		  <cfloop index="q" from="#from#" to="4" step="1">
				<cfset dbLicense = oLicense.getDatabaseLicense("#vHost#", yr, q)>
				
				<cfif dbLicense eq Parameter.DatabaseServerLicenseId>
				
					<cfif attributes.mode eq "Server">
						 <cfset caller.license  = "1">
						 <cfset caller.vyear    = yr>					 
						 <cfset caller.vquarter = q>							 					 
						 <cfexit>
					<cfelse>
						 <cfset _ALLOW_DB_SERVER = TRUE>
						 <cfbreak>
					</cfif>
				</cfif>			 
		  </cfloop>
	</cfloop>
	
<cfelse>

	<cf_message Message = "Please Upgrade your server License  - 1043, contact your network administrator" return="no">		
			
</cfif>
	
<cfif _ALLOW_DB_SERVER>
	
	<!---- only do this portion if and only if the database engine is licensed ---->
			
	<cfquery name="SystemModule" 
	    datasource="appsSystem">
	     SELECT   * 
		 FROM     Ref_SystemModule
		 WHERE    SystemModule = #preserveSingleQuotes(Attributes.Module)# 
	</cfquery>
	
	<cfset caller.license = "0">

	 <cfloop index="yr" from="#Year(now())#" to="#Year(now())+3#" step="1">
		     
		 <cfset sq = 1>
		 <cfif yr eq year(now())>
		 	<cfset sq = quarter(now())>
		 </cfif>
		 
		 <cfif caller.license eq "0">
	
			  <cfloop index="qr" from="#sq#" to="4">
			  		  		  			
		 	 		<cfset serialNo = oLicense.GetSerialNo(SystemModule.SystemModule, Attributes.Mission, yr, qr)>
					<cfset serialNo_ALL = oLicense.GetSerialNo(SystemModule.SystemModule, "'ALL'", yr, qr)>	
									 
					<cfif Attributes.LicenseId eq "">
													
						 <cfif (serialNo eq SystemModule.LicenseId and SystemModule.LicenseId neq "") or (serialNo_ALL eq SystemModule.Licenseid)>
						 
							 <cfset caller.license  = "1">
							 <cfset caller.vyear    = yr>					 
							 <cfset caller.vquarter = qr>													 					 
							 <cfbreak>
							 
						 <cfelse>					 
						 					 
							<cfquery name="qMissionModule" 
					         datasource="appsOrganization">
					         SELECT Mission,LicenseId 
							 FROM   Ref_MissionModule
							 WHERE  SystemModule = #preserveSingleQuotes(Attributes.Module)#
							 AND    LicenseId IS NOT NULL
							 <cfif Attributes.Mission neq "'ALL'">
								 AND Mission = #preserveSingleQuotes(Attributes.Mission)# 							 
							 </cfif>
							</cfquery>
																										
							<cfloop query = "qMissionModule">											
																				 				 	
								 <cfset serialNo = oLicense.GetSerialNo(SystemModule.SystemModule, qMissionModule.Mission, yr, qr)>
								 
								 <cfif LicenseId eq serialNo>
								 	<!--- if there is a single mission that is enabled, then I should return yes ---->
									 <cfset caller.license  = "1">
									 <cfset caller.vyear    = yr>					 
									 <cfset caller.vquarter = qr>								 				 							 								
									 <cfbreak>
								 </cfif>
								 
							</cfloop>			
												 		 
						 </cfif>
						 
					<cfelse>
					
						 <cfif ((serialNo eq Attributes.LicenseId) or (serialNo_ALL eq Attributes.LicenseId)) and (Attributes.Mission eq "'ALL'")>
						 
							 <cfset caller.license  = "1">
							 <cfset caller.vyear    = yr>					 
							 <cfset caller.vquarter = qr>												 
							 <cfbreak>
							 
						 <cfelseif Attributes.Mission neq "'ALL'">
						 
							<cfquery name="qMissionModule" 
					         datasource="appsOrganization">
					         SELECT Mission,LicenseId 
							 FROM   Ref_MissionModule
							 WHERE  SystemModule = #preserveSingleQuotes(Attributes.Module)#
							 AND    LicenseId IS NOT NULL
							 <cfif Attributes.Mission neq "'ALL'">
								 AND Mission = #preserveSingleQuotes(Attributes.Mission)# 
							 </cfif>
							</cfquery>
							
							<cfloop query = "qMissionModule">
		 				 		 <cfset serialNo = oLicense.GetSerialNo(SystemModule.SystemModule, qMissionModule.Mission, yr, qr)>
								 <cfif Attributes.LicenseId eq serialNo>
									 <cfset caller.license  = "1">
									 <cfset caller.vyear    = yr>					 
									 <cfset caller.vquarter = qr>														 							 
									 <cfbreak>
								 </cfif>
							</cfloop>							 
						 </cfif>
						 
					</cfif>
					 
			  </cfloop>
			  
		<cfelse>
		
			 <cfbreak>	  
			  
		</cfif>	  
		 		 
	</cfloop>

<cfelse>

	<cfset caller.license = "0">
	
</cfif>
	
<cfif caller.license eq "0" and Attributes.Message eq "Yes">

	<cf_message Message = "License for: <b>#Attributes.Module#</b> has expired. <p></p>Please contact your Promisan representative." return="no">

</cfif>
