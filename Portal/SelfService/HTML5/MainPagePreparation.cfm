
<cfquery name="Main" 
	datasource="AppsSystem">
		SELECT 	*
		FROM	Ref_ModuleControl
		WHERE	SystemModule	= 'SelfService'
		AND		FunctionClass 	= 'SelfService'
		AND		FunctionName	= '#url.id#'
</cfquery>

<cfquery name="SystemParameter" 
	datasource="AppsInit">
		SELECT 	* 
		FROM 	Parameter
		WHERE 	HostName = '#CGI.HTTP_HOST#'
</cfquery> 

<cfquery name="AccessToPortal" 
	datasource="AppsSystem">
		SELECT *
		FROM   UserModule
		WHERE  Account           = '#SESSION.acc#'
		<cfif Main.recordCount gt 0>
			AND    SystemFunctionId  = '#Main.SystemFunctionId#'
		<cfelse>
			AND    1=0
		</cfif>
</cfquery>


<cfif url.mode eq "default">
	<cfinclude template="PortalAccessValidation.cfm">
</cfif>


<!--- ---------------------------------------------- --->
<!--- -------------- SET LANGUAGE ------------------ --->
<!--- ---------------------------------------------- --->

<!--- we obtain the default language within the scope of what is enabled --->

<cfquery name="BaseLanguage" 
	 datasource="AppsSystem">
		 SELECT  *
		 FROM    Ref_SystemLanguage
		 WHERE   Operational IN  ('1','2') 		 
		 AND 	SystemDefault = '1'
</cfquery>

<cfset BaseLanguage = BaseLanguage.code>

<cfquery name="ApplyLanguage" 
	 datasource="AppsSystem">
		 SELECT  *
		 FROM    Ref_SystemLanguage
		 WHERE   Operational IN  ('1','2') 
		 AND     Code IN (SELECT LanguageCode
		                  FROM   Ref_ModuleControl_Language
	        		      WHERE  Operational = 1  
				          AND    SystemFunctionId = '#Main.SystemFunctionId#')
		 AND 	SystemDefault = '1'
</cfquery>

<!--- if we do not find the base language within the enabled language scope for the functionid we apply
the first 9random) value of the enabled scope languages for the portal instead as the default --->

<cfif ApplyLanguage.recordcount eq "0">
	
	<cfquery name="ApplyLanguage" 
		 datasource="AppsSystem">
			 SELECT  TOP 1 *
			 FROM    Ref_SystemLanguage
			 WHERE   Operational IN  ('1','2') 	
			 AND     Code IN (SELECT LanguageCode
		                      FROM   Ref_ModuleControl_Language
	        		          WHERE  Operational = 1  
				              AND    SystemFunctionId = '#Main.SystemFunctionId#')				 
	</cfquery>
	
</cfif>

<!--- this one has the base language that contains the text in the normal tables --->

<cfset ApplyLanguage = ApplyLanguage.Code>

<!--- ------ now we obtain the language variables that are used for the query --- --->
<cfquery name="Language" 
	 datasource="AppsSystem">
		 SELECT  *
		 FROM    Ref_SystemLanguage
		 WHERE   Operational IN  ('1','2') 
		 AND     Code IN (SELECT LanguageCode
		                  FROM   Ref_ModuleControl_Language
	        		      WHERE  Operational = 1  
				          AND    SystemFunctionId = '#Main.SystemFunctionId#') 
		 ORDER BY SystemDefault DESC				  		  
</cfquery>

<!--- --------- We initiatialised the query language prefix ------- --->

<cfset CLIENT.LanPrefix = "">
<cfset found = 0>

<cfloop query="Language">	
	<cfif Code eq CLIENT.Languageid> <!--- user selected language that matches one of the languages of the portal --->	    
		<cfif Code neq BaseLanguage> 
			  <cfset CLIENT.LanPrefix     = "xl#Code#_"> <!--- drives the query from the database, if base then it takes standard --->
		</cfif>
		<cfset found = 1>
	</cfif> 
</cfloop>

<cfif found eq "0">  

	<!--- no prior user preference is found and/or was not matched with valid languages for this function/portal; 
		     so we set it based on the first found scoped language in value applyLanguge --->
			 
	<cfset CLIENT.Languageid = ApplyLanguage>
	<cfif ApplyLanguage eq BaseLanguage OR ApplyLanguage eq "">
		<cfset CLIENT.LanPrefix = "">	
	<cfelse>
		<cfset CLIENT.LanPrefix     = "xl#ApplyLanguage#_">
	</cfif>	
	
</cfif>

<!--- ------------------------------------ --->
<!--- ------------------------------------ --->
<!--- ------------------------------------ --->

<cfif isDefined("client.mission")>
	<cfif trim(client.mission) eq "">
		<cfset vDel = StructDelete(client,"mission")>
	</cfif>
</cfif>

<cfif isDefined("url.mission") and trim(url.mission) neq "">
	<cfset client.mission = url.mission>
</cfif>

<cfquery name="Portal" 
	datasource="AppsSystem">
		SELECT 	*
		FROM	#CLIENT.LanPrefix#Ref_ModuleControl
		WHERE	SystemModule	= 'SelfService'
		AND		FunctionClass 	= 'SelfService'
		AND		FunctionName	= '#url.id#'
</cfquery>

<cfquery name="MainMenu" 
	datasource="AppsSystem">
		SELECT 	*
		FROM	#CLIENT.LanPrefix#Ref_ModuleControl
		WHERE	SystemModule	= 'SelfService'
		AND		FunctionClass	= '#url.id#'
		AND		MenuClass		= '#url.menuClass#'
		AND		Operational		= 1
		<cfif url.public eq "External">
		AND     MenuOrder != '0'
		</cfif>
		ORDER BY MenuOrder ASC
</cfquery>

<cfquery name="ProcessPrivate" 
	datasource="AppsSystem">
		SELECT 	COUNT(*) AS Total
		FROM	#CLIENT.LanPrefix#Ref_ModuleControl
		WHERE	SystemModule	= 'SelfService'
		AND		FunctionClass	= '#url.id#'
		AND		MenuClass		= 'Process'
		AND		Operational		= 1
</cfquery>

<cfquery name="qLogo" 
	datasource="AppsSystem">
		SELECT 	*
		FROM	Ref_ModuleControl
		WHERE	SystemModule	= 'SelfService'
		AND		FunctionClass	= '#url.id#'
		AND		MenuClass		= 'Layout'
		AND		FunctionName	= 'Logo'
		AND		Operational		= 1
</cfquery>

<cfquery name="qLogoDark" 
	datasource="AppsSystem">
		SELECT 	*
		FROM	Ref_ModuleControl
		WHERE	SystemModule	= 'SelfService'
		AND		FunctionClass	= '#url.id#'
		AND		MenuClass		= 'Layout'
		AND		FunctionName	= 'LogoDark'
		AND		Operational		= 1
</cfquery>

<cfquery name="qBrandLogo" 
	datasource="AppsSystem">
		SELECT 	*
		FROM	Ref_ModuleControl
		WHERE	SystemModule	= 'SelfService'
		AND		FunctionClass	= '#url.id#'
		AND		MenuClass		= 'Layout'
		AND		FunctionName	= 'BrandLogo'
		AND		Operational		= 1
</cfquery>

<cfquery name="qFavIcon" 
	datasource="AppsSystem">
		SELECT 	*
		FROM	Ref_ModuleControl
		WHERE	SystemModule	= 'SelfService'
		AND		FunctionClass	= '#url.id#'
		AND		MenuClass		= 'Layout'
		AND		FunctionName	= 'FavIcon'
		AND		Operational		= 1
</cfquery>

<cfquery name="qCustomCSS" 
	datasource="AppsSystem">
		SELECT 	*
		FROM	Ref_ModuleControl
		WHERE	SystemModule	= 'SelfService'
		AND		FunctionClass	= '#url.id#'
		AND		MenuClass		= 'Function'
		AND		FunctionName	= 'CustomCSS'
		AND		Operational		= 1
</cfquery>

<cfquery name="qAutohideMenu" 
	datasource="AppsSystem">
		SELECT 	*
		FROM	Ref_ModuleControl
		WHERE	SystemModule	= 'SelfService'
		AND		FunctionClass	= '#url.id#'
		AND		MenuClass		= 'Function'
		AND		FunctionName	= 'AutohideMenu'
		AND		Operational		= 1
</cfquery>

<cfquery name="qPreferences" 
	datasource="AppsSystem">
		SELECT 	*
		FROM	Ref_ModuleControl
		WHERE	SystemModule	= 'SelfService'
		AND		FunctionClass	= '#url.id#'
		AND		MenuClass		= 'Function'
		AND		FunctionName	= 'Preferences'
</cfquery>

<cfquery name="qClearances" 
	datasource="AppsSystem">
		SELECT 	*
		FROM	Ref_ModuleControl
		WHERE	SystemModule	= 'SelfService'
		AND		FunctionClass	= '#url.id#'
		AND		MenuClass		= 'Function'
		AND		FunctionName	= 'Clearances'
</cfquery>

<cfquery name="qShowSupportMenu" 
	datasource="AppsSystem">
		SELECT 	*
		FROM	Ref_ModuleControl
		WHERE	SystemModule	= 'SelfService'
		AND		FunctionClass	= '#url.id#'
		AND		MenuClass		= 'Function'
		AND		FunctionName	= 'ShowSupportMenu'
		AND		Operational		= 1
</cfquery>

<cfquery name="qShowConfigurations" 
	datasource="AppsSystem">
		SELECT 	*
		FROM	Ref_ModuleControl
		WHERE	SystemModule	= 'SelfService'
		AND		FunctionClass	= '#url.id#'
		AND		MenuClass		= 'Function'
		AND		FunctionName	= 'Configurations'
</cfquery>

<cfquery name="qGetSupport" 
	datasource="AppsOrganization">
		SELECT  *
		FROM   	OrganizationAuthorization
		WHERE   Role = 'Support'
		AND     UserAccount = '#session.acc#'
		AND 	RecordStatus != '9'
</cfquery>

<cfquery name="qPreferencesPassword" 
	datasource="AppsSystem">
		SELECT 	*
		FROM	Ref_ModuleControl
		WHERE	SystemModule	= 'SelfService'
		AND		FunctionClass	= '#url.id#'
		AND		MenuClass		= 'Function'
		AND		FunctionName	= 'PreferencesPassword'
</cfquery>

<cfquery name="qPreferencesFeatures" 
	datasource="AppsSystem">
		SELECT 	*
		FROM	Ref_ModuleControl
		WHERE	SystemModule	= 'SelfService'
		AND		FunctionClass	= '#url.id#'
		AND		MenuClass		= 'Function'
		AND		FunctionName	= 'PreferencesFeatures'
</cfquery>

<cfquery name="qPreferencesAnnotations" 
	datasource="AppsSystem">
		SELECT 	*
		FROM	Ref_ModuleControl
		WHERE	SystemModule	= 'SelfService'
		AND		FunctionClass	= '#url.id#'
		AND		MenuClass		= 'Function'
		AND		FunctionName	= 'PreferencesAnnotations'
</cfquery>

<cfquery name="qPreferencesLDAPMailbox" 
	datasource="AppsSystem">
		SELECT 	*
		FROM	Ref_ModuleControl
		WHERE	SystemModule	= 'SelfService'
		AND		FunctionClass	= '#url.id#'
		AND		MenuClass		= 'Function'
		AND		FunctionName	= 'PreferencesLDAPMailbox'
</cfquery>

<cfquery name="qInformationEntity" 
	datasource="AppsSystem">
		SELECT 	*
		FROM	Ref_ModuleControl
		WHERE	SystemModule	= 'SelfService'
		AND		FunctionClass	= '#url.id#'
		AND		MenuClass		= 'Function'
		AND		FunctionName	= 'InformationEntity'
</cfquery>

<cfquery name="qInitShowMenu" 
	datasource="AppsSystem">
		SELECT 	*
		FROM	Ref_ModuleControl
		WHERE	SystemModule	= 'SelfService'
		AND		FunctionClass	= '#url.id#'
		AND		MenuClass		= 'Function'
		AND		FunctionName	= 'InitShowMenu'
</cfquery>

<cfquery name="qRequestAccess" 
	datasource="AppsSystem">
		SELECT 	*
		FROM	Ref_ModuleControl
		WHERE	SystemModule	= 'SelfService'
		AND		FunctionClass	= '#url.id#'
		AND		MenuClass		= 'Function'
		AND		FunctionName	= 'RequestAccess'
		AND		Operational		= 1
</cfquery>

<cfquery name="qForgotPassword" 
	datasource="AppsSystem">
		SELECT 	*
		FROM	Ref_ModuleControl
		WHERE	SystemModule	= 'SelfService'
		AND		FunctionClass	= '#url.id#'
		AND		MenuClass		= 'Function'
		AND		FunctionName	= 'ForgotPassword'
		AND		Operational		= 1
</cfquery>

<cfquery name="qForgotUser" 
	datasource="AppsSystem">
		SELECT 	*
		FROM	Ref_ModuleControl
		WHERE	SystemModule	= 'SelfService'
		AND		FunctionClass	= '#url.id#'
		AND		MenuClass		= 'Function'
		AND		FunctionName	= 'ForgotUsername'
		AND		Operational		= 1
</cfquery>

<cfquery name="qLanguageTopMenu" 
	datasource="AppsSystem">
		SELECT 	*
		FROM	Ref_ModuleControl
		WHERE	SystemModule	= 'SelfService'
		AND		FunctionClass	= '#url.id#'
		AND		MenuClass		= 'Function'
		AND		FunctionName	= 'LanguageTopMenu'
		AND		Operational		= 1
</cfquery>

<cfquery name="qShowPublicPreferences" 
	datasource="AppsSystem">
		SELECT 	*
		FROM	Ref_ModuleControl
		WHERE	SystemModule	= 'SelfService'
		AND		FunctionClass	= '#url.id#'
		AND		MenuClass		= 'Function'
		AND		FunctionName	= 'ShowPublicPreferences'
		AND		Operational		= 1
</cfquery>

<cfquery name="qShowPublicInformation" 
	datasource="AppsSystem">
		SELECT 	*
		FROM	Ref_ModuleControl
		WHERE	SystemModule	= 'SelfService'
		AND		FunctionClass	= '#url.id#'
		AND		MenuClass		= 'Function'
		AND		FunctionName	= 'ShowPublicInformation'
</cfquery>

<cfquery name="qShowPrivateInformation" 
	datasource="AppsSystem">
		SELECT 	*
		FROM	Ref_ModuleControl
		WHERE	SystemModule	= 'SelfService'
		AND		FunctionClass	= '#url.id#'
		AND		MenuClass		= 'Function'
		AND		FunctionName	= 'ShowPrivateInformation'
</cfquery>

<cfquery name="qShowMenuInfo" 
	datasource="AppsSystem">
		SELECT 	*
		FROM	Ref_ModuleControl
		WHERE	SystemModule	= 'SelfService'
		AND		FunctionClass	= '#url.id#'
		AND		MenuClass		= 'Function'
		AND		FunctionName	= 'ShowMenuInfo'
</cfquery>

<cfquery name="qShowLanguageFlag" 
	datasource="AppsSystem">
		SELECT 	*
		FROM	Ref_ModuleControl
		WHERE	SystemModule	= 'SelfService'
		AND		FunctionClass	= '#url.id#'
		AND		MenuClass		= 'Function'
		AND		FunctionName	= 'ShowLanguageFlag'
</cfquery>

<cfquery name="qIconSet" 
	datasource="AppsSystem">
		SELECT 	*
		FROM	Ref_ModuleControl
		WHERE	SystemModule	= 'SelfService'
		AND		FunctionClass	= '#url.id#'
		AND		MenuClass		= 'Function'
		AND		FunctionName	= 'IconSet'
</cfquery>

<cfquery name="qShowLoginOnInit" 
	datasource="AppsSystem">
		SELECT 	*
		FROM	Ref_ModuleControl
		WHERE	SystemModule	= 'SelfService'
		AND		FunctionClass	= '#url.id#'
		AND		MenuClass		= 'Function'
		AND		FunctionName	= 'ShowLoginOnInit'
		AND		Operational		= 1
</cfquery>

<cfif Main.MenuClass eq "Mission">

	<cfquery name="thisMission" 
		datasource="#Main.AccessDatasource#">
			SELECT 	PM.*,
					M.MissionName
			FROM 	Ref_ParameterMission PM
					INNER JOIN Organization.dbo.Ref_Mission M
						ON PM.Mission = M.Mission
			<cfif isDefined("client.mission")>
				WHERE 	PM.Mission = '#client.mission#'
			<cfelse>
				WHERE 	1=0
			</cfif>
	</cfquery>
	
	<cfquery name="MissionList" 
		datasource="#Main.AccessDatasource#">
			SELECT 	PM.*,
					M.MissionName
			FROM 	Ref_ParameterMission PM
					INNER JOIN Organization.dbo.Ref_Mission M
						ON PM.Mission = M.Mission
			ORDER BY M.MissionName
	</cfquery>

<cfelse>

	<cfquery name="thisMission" 
		datasource="AppsSystem">
			SELECT 	DISTINCT M.*
			FROM 	Organization.dbo.Ref_Mission M
					LEFT OUTER JOIN UserNames U
						ON M.Mission = U.AccountMission
			WHERE	1=1
			<!--- <cfif isDefined("client.mission")>
				AND 	M.Mission = '#client.mission#'
			<cfelse>
				<cfif isDefined("client.acc") and trim(client.acc) neq "">
					AND 	U.Account = '#client.acc#'
				</cfif>
			</cfif> --->
	</cfquery>
	
	<cfset MissionList = thisMission>

</cfif>

<cfif Main.MenuClass eq "Mission" and (not isDefined("client.mission") or trim(client.mission) eq "")>
	<cf_getDefaultMission>
	<cfset vThisMission = Mission>
<cfelse>
	<cfset vThisMission = thisMission.Mission>
	<cfif isDefined("client.mission")>
		<cfif trim(client.mission) neq "">
			<cfset vThisMission = client.mission>
		</cfif>
	</cfif>
</cfif>

<cfset url.mission = vThisMission>

<cfset parameterIconSet = "White">
<cfif qIconSet.recordCount eq 1>
	<cfset vTempIconSetFunctionInfo = trim(qIconSet.FunctionInfo)>
	<cfif vTempIconSetFunctionInfo neq "">
		<cfset parameterIconSet = vTempIconSetFunctionInfo>
	</cfif>
</cfif>

<cfset imageDirectory             = "#session.root#/Images/HTML5/#parameterIconSet#">
<cfset parameterImgLogo           = "#session.root#/#qLogo.FunctionDirectory#/#qLogo.FunctionPath#">
<cfset parameterImgLogoTitle      = "#qLogo.FunctionMemo#">
<cfset parameterImgLogoName       = "#qLogo.FunctionName#">

<cfset parameterImgLogoDark       = "#session.root#/#qLogoDark.FunctionDirectory#/#qLogoDark.FunctionPath#">
<cfset parameterImgLogoDarkTitle  = "#qLogoDark.FunctionMemo#">
<cfset parameterImgLogoDarkName   = "#qLogoDark.FunctionName#">

<cfset parameterImgBrandLogo      = "#session.root#/#qBrandLogo.FunctionDirectory#/#qBrandLogo.FunctionPath#">
<cfset parameterImgBrandLogoTitle = "#qBrandLogo.FunctionMemo#">
<cfset parameterImgBrandLogoName  = "#qBrandLogo.FunctionName#">

<cfset parameterImgFavIcon        = "#session.root#/#qFavIcon.FunctionDirectory#/#qFavIcon.FunctionPath#">

<cfset parameterSplash            = "#session.root#/tools/treeView/treeViewInit.cfm?opacity=1">


<cfquery name="qOnFinishPreparation" 
	datasource="AppsSystem">
		SELECT 	*
		FROM	Ref_ModuleControl
		WHERE	SystemModule	= 'SelfService'
		AND		FunctionClass	= '#url.id#'
		AND		MenuClass		= 'Function'
		AND		FunctionName	= 'OnFinishPreparation'
		AND		Operational		= 1
</cfquery>

<cfif qOnFinishPreparation.recordCount gt 0>
	<cfif trim(qOnFinishPreparation.FunctionPath) neq "">
		<cfinclude template="../../../#qOnFinishPreparation.FunctionDirectory##qOnFinishPreparation.FunctionPath#">
	</cfif>
</cfif>