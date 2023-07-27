<cfparam name="attributes.appId"	default="">
<cfparam name="url.mission"			default="">

<cfquery name="getApplication" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		 
		SELECT  *
		FROM    #client.lanPrefix#Ref_ModuleControl	 
		WHERE	SystemModule = 'PMobile'
		AND		FunctionClass = 'PMobile'
		AND		FunctionName = '#attributes.appId#'
		AND		Operational = 1
</cfquery>

<cfquery name="getMenu" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		 
		SELECT  *
		FROM    #client.lanPrefix#Ref_ModuleControl	 
		WHERE	SystemModule = 'PMobile'
		AND		FunctionClass = '#attributes.appId#'
		AND		(FunctionTarget IS NULL OR FunctionTarget = '')
		AND		Operational = 1
		ORDER BY MenuOrder ASC 
</cfquery>


<cf_mobileMenu>

	<cfoutput query="getMenu">
		
		<cfif trim(FunctionDirectory) eq "" and trim(FunctionPath) eq "">
		
			<cf_mobileMenuItem parent="1" description="#FunctionMemo#">
			
				<cf_mobileMenu id="#FunctionName#" sublevel="1">
					
					<cfquery name="getSubMenu" 
						datasource="AppsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">		 
							SELECT  *
							FROM    #client.lanPrefix#Ref_ModuleControl	 
							WHERE	SystemModule = 'PMobile'
							AND		FunctionClass = '#attributes.appId#'
							AND		FunctionTarget = '#FunctionName#'
							AND		Operational = 1
							ORDER BY MenuOrder ASC
					</cfquery>

					<cfloop query="getSubMenu">
					
						<cfif trim(getSubMenu.FunctionDirectory) eq "" and trim(getSubMenu.FunctionPath) eq "">
						
							<cf_mobileMenuItem parent="1" description="#FunctionMemo#">
							
								<cf_mobileMenu id="#getSubmenu.FunctionName#" sublevel="2">
								
									<cfquery name="getSubMenu2"
											datasource="AppsSystem"
											username="#SESSION.login#"
											password="#SESSION.dbpw#">
										SELECT  *
										FROM    #client.lanPrefix#Ref_ModuleControl
										WHERE	SystemModule = 'PMobile'
										AND		FunctionClass = '#attributes.appId#'
										AND		FunctionTarget = '#getSubmenu.FunctionName#'
										AND		Operational = 1
										ORDER BY MenuOrder ASC
									</cfquery>

									<cfloop query="getSubMenu2">
									
										<cf_MobileProsisMenuItem
												AppId = "#attributes.appId#"
												FunctionId = "#GetSubMenu2.SystemFunctionId#"
												Mission = "#url.mission#">

									</cfloop>

								</cf_mobileMenu>
								
							</cf_mobileMenuItem>
							
						<cfelse>
							<cf_MobileProsisMenuItem
									AppId = "#attributes.appId#"
									FunctionId = "#SystemFunctionId#"
									Mission = "#url.mission#">

						</cfif>

					</cfloop>
					
				</cf_mobileMenu>
			</cf_mobileMenuItem>
			
		<cfelse>
		
			<cf_MobileProsisMenuItem
				AppId = "#attributes.appId#"
				FunctionId = "#SystemFunctionId#"
				Mission = "#url.mission#">
			
		</cfif>
		
	</cfoutput>

</cf_mobileMenu>