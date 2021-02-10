<cfif SESSION.isAdministrator eq "No">
 
	<cfquery name="SystemModules" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	    SELECT    R.Code, R.Description, M.SystemModule, M.Description AS ModuleDescription, M.Hint, M.MenuOrder
		FROM      Ref_ApplicationModule RM INNER JOIN
                  Ref_Application R ON RM.Code = R.Code INNER JOIN
                  Ref_SystemModule M ON RM.SystemModule = M.SystemModule INNER JOIN
				  Organization.dbo.OrganizationAuthorization A ON  A.ClassParameter = M.RoleOwner AND A.UserAccount = '#SESSION.acc#' AND  A.Role = 'AdminSystem'				  
		WHERE     RM.Code IN ('AD', 'FI', 'PR', 'OP', 'HR')
		AND       M.Operational = 1		       
		ORDER BY R.ListingOrder, M.MenuOrder
	
	</cfquery>

<cfelse>

	<cfquery name="SystemModules" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT    R.Code, R.Description, M.SystemModule, M.Description AS ModuleDescription, M.Hint, M.MenuOrder
		FROM      Ref_ApplicationModule RM INNER JOIN
                  Ref_Application R ON RM.Code = R.Code INNER JOIN
                  Ref_SystemModule M ON RM.SystemModule = M.SystemModule
		WHERE     RM.Code IN ('AD', 'FI', 'PR', 'OP', 'HR')
		AND       M.Operational = 1
		ORDER BY R.ListingOrder, M.MenuOrder
		 		
	</cfquery> 

</cfif>

<cfif SystemModules.recordcount eq "0">

	<font color="FF0000">No access granted</font>

<cfelse>
	
	<cf_UITree id="Root"
			title="<span style='font-size:16px;color:gray;padding-bottom:3px'>Modules</span>"
			expand="yes"
			Root="No">
	   				
			<cfoutput query="systemmodules" group="Code">
			
			  <cf_UITreeitem value="#Code#"
		        display="<span style='font-weight:bold;font-size:18px;padding-top:10px;padding-bottom:6px'>#Description#</span>"
				parent="Root"
		        expand="Yes">					
						
			<cfoutput>
			
			 <cf_UITreeitem value="#systemmodule#"
		        display="<span style='font-size:15px;'>#ModuleDescription#</span>"
				parent="#code#"
				href="javascript:editfunction('#systemModule#')"										
		        expand="No">	
			
			<cfif systemmodule eq "selfservice">
			
				<cf_UITreeitem value="#systemModule#_selfservice"
				        display="<span style='font-size:14px;'>Instances</span>"
						img="#SESSION.root#/Images/select.png"
						parent="#systemmodule#"
						href="javascript:more('#systemModule#','1','Selfservice','')"														
				        expand="No">		
						
			<cfelseif systemmodule eq "PMobile">
			
				<cf_UITreeitem value="#systemModule#_selfservice"
				        display="<span style='font-size:14px;'>Applications</span>"
						img="#SESSION.root#/Images/select.png"
						parent="#systemmodule#"
						href="javascript:more('#systemModule#','1','PMobile','')"														
				        expand="No">						
									
			<cfelse>	
			
				<cfif systemmodule eq "Portal">
				
					<cfset list = "1">
					<cfset label = "Top Menus">
				
				<cfelse>
				
					<cfset list = "1,0">
					<cfset label = "Main Menu">
				
				</cfif>		
													
				<cfloop index="itm" list="#list#" delimiters=",">
				
				<cfif itm eq "1">
													
					  <cf_UITreeitem value="#systemmodule#_#itm#"
			        	display="<span style='font-size:14px;'>#label#</span>"
						parent="#systemmodule#"
			        	expand="No">
				
				<cfelse>
				
					  <cf_UITreeitem value="#systemmodule#_#itm#"
			        	display="<span style='font-size:14px;'>Context Menu</span>"
						parent="#systemmodule#"
			        	expand="No">
				
				</cfif>					
								
				<cfif SESSION.isAdministrator eq "No">  
					 
						<cfquery name="Class" 
						datasource="AppsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT  DISTINCT M.FunctionClass
							FROM  xl#client.languageId#_Ref_ModuleControl M, 
							      Ref_SystemModule S
							WHERE M.SystemModule = S.SystemModule
							AND   S.RoleOwner IN (SELECT ClassParameter 
							                      FROM   Organization.dbo.OrganizationAuthorization
												  WHERE  UserAccount = '#SESSION.acc#'
												  AND    Role = 'AdminSystem')
							AND   M.SystemModule = '#SystemModule#'
							AND   M.FunctionClass != 'PDF'
							AND   M.MainMenuItem = '#itm#'										
						</cfquery>
					
					<cfelse>
					
						 <cfif systemmodule eq "portal">
						 
						 <cfquery name="Class" 
							datasource="AppsSystem" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT DISTINCT R.FunctionClass, S.MenuOrder
							FROM   Ref_ModuleControl AS R INNER JOIN
			                       Ref_SystemModule AS S ON R.SystemModule = S.SystemModule
							WHERE   (R.SystemModule = '#SystemModule#') AND (R.FunctionClass NOT IN ('Portal', 'Custom', 'Selfservice'))
							GROUP BY R.FunctionClass, S.MenuOrder
							ORDER BY S.MenuOrder
						 </cfquery>	
						 
						 <cfelse>
														
							<cfquery name="Class" 
							datasource="AppsSystem" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT  DISTINCT FunctionClass
								FROM     xl#client.languageId#_Ref_ModuleControl
								WHERE    SystemModule = '#SystemModule#'
								AND      FunctionClass != 'PDF'	
								AND      MainMenuItem = '#itm#'
							</cfquery>
							
						  </cfif>	
																	
					</cfif>
													
					<cfloop query="Class">
						
						<cf_UITreeitem value="#SystemModules.SystemModule#_#itm#_#FunctionClass#"
					        display="<span style='font-size:13px;'>&nbsp;#FunctionClass#</span>"
							img="#SESSION.root#/Images/select.png"
							parent="#SystemModules.SystemModule#_#itm#"
							href="javascript:more('#SystemModules.SystemModule#','#itm#','#FunctionClass#','')"														
					        expand="yes">	
										
					</cfloop>	
										
				</cfloop>		
			
			  <cfif systemmodule neq "portal">							
			 			
				  <cf_UITreeitem value="#systemmodule#_help"
			        display="<span style='font-size:14px;'>Help Topics</span>" parent="#systemmodule#" expand="No">					
					
					<cfquery name="Class"
						datasource="AppsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT   DISTINCT PC.TopicClass
						FROM     HelpProject P INNER JOIN
					             HelpProjectClass PC ON P.ProjectCode = PC.ProjectCode
						WHERE    P.SystemModule = '#SystemModule#'										
					</cfquery>
							
					<cfloop query="Class">
						
						<cf_UITreeitem value="#SystemModules.SystemModule#_#topicClass#"
					        display="<span style='font-size:14px;'>#TopicClass#</span>"
							img="#SESSION.root#/Images/select.png"
							parent="#SystemModules.SystemModule#_help"
							href="javascript:help('#SystemModules.SystemModule#','#topicclass#')"														
					        expand="yes">	
										
					</cfloop>	
				
				</cfif>
						
			</cfif>	
					
            </cfoutput>	
			
					
		</cfoutput>
		
		
	</cf_UITree>


</cfif>   