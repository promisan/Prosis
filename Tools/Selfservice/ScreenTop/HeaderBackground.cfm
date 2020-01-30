<!--- To be reviewed by Kristhian --->

<cfset vTakeBackgroundColorCriteria = 0>

<cfif (isDefined("SystemFunctionId") or isDefined("idMenu")) and attributes.bannerForce eq "No">
												
	<cfif isDefined("idMenu")>
		<cfif idMenu neq "">
			<cfset SystemFunctionId = idMenu>
		</cfif>	
	</cfif>	
							
	<cfif isValid("GUID",SystemFunctionId)>
		
		<cfquery name="get" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT DISTINCT  
						A.Code, 
						A.Description, 
						A.ListingOrder
				FROM    Ref_Application A 
						INNER JOIN Ref_ApplicationModule M ON A.Code = M.Code AND A.Usage = 'System'	 													 
				WHERE	M.SystemModule IN (SELECT SystemModule FROM Ref_ModuleControl WHERE SystemFunctionId = '#SystemFunctionId#')
				AND		A.Operational = '1'	AND M.Operational = '1'
		</cfquery>
		
		<cfif get.recordCount gt 0>
									
			<cfif get.code eq "AD">
			
				<cfset background = "Images/Logos/Banners/AdministrationGray.jpg">
				<cfset attributes.textColorLabel  = "333333">
				<cfset attributes.textColorName   = "333333">
				<cfset attributes.textColorClose  = "white">
				<cfset attributes.textColorOption = "white">
				
			<cfelseif get.code eq "HR">	
			
				<cfset background = "Images/Logos/Banners/HumanResourcesYellow.jpg">
				<cfset attributes.textColorLabel = "523900">
				<cfset attributes.textColorName = "523900">
				<cfset attributes.textColorClose = "523900">
				<cfset attributes.textColorOption = "000000">	
				
			<cfelseif get.code eq "FI">	
						
				<cfset background = "Images/Logos/Banners/FinancialsGreen.jpg">
				<cfset attributes.textColorLabel = "FFFFFF">
				<cfset attributes.textColorName = "white">
				<cfset attributes.textColorClose = "white">
				<cfset attributes.textColorOption = "white">
								
			<cfelseif get.code eq "PR">	
			
				<cfset background = "Images/Logos/Banners/ProgramRed.jpg">
				<cfset attributes.textColorLabel = "FFFFFF">
				<cfset attributes.textColorName = "FFFFFF">
				<cfset attributes.textColorClose = "FFFFFF">
				<cfset attributes.textColorOption = "FFFFFF">
				
			<cfelseif get.code eq "OP">	
				
				<cfset background = "Images/Logos/Banners/OperationsBlue.jpg">
				<cfset attributes.textColorLabel = "FFFFFF">
				<cfset attributes.textColorName = "FFFFFF">
				<cfset attributes.textColorClose = "FFFFFF">
				<cfset attributes.textColorOption = "FFFFFF">			
				
			<cfelse>
				<cfset background = "Images/Logos/Banners/OperationsBlue.jpg">
				<cfset attributes.textColorLabel = "FFFFFF">
				<cfset attributes.textColorName = "FFFFFF">
				<cfset attributes.textColorClose = "FFFFFF">
				<cfset attributes.textColorOption = "FFFFFF">
			</cfif>
			
		<cfelse>
			
			<cfset vTakeBackgroundColorCriteria = 1>
			
		</cfif>
	
	<cfelse>
		
		<cfset vTakeBackgroundColorCriteria = 1>
	
	</cfif>
	
<cfelse>
	
	<cfset vTakeBackgroundColorCriteria = 1>
	
</cfif>


<cfif vTakeBackgroundColorCriteria eq 1>
	
	<cfif attributes.banner eq "blank">
		<cfset bg = "">
		<cfset background = "">
	<cfelseif attributes.banner eq "gray">
		<cfset background = "Images/logos/Banners/AdministrationGray.jpg">	
		<cfset attributes.textColorLabel = "white">
		<cfset attributes.textColorName = "white">
		<cfset attributes.textColorClose = "white">
		<cfset attributes.textColorOption = "white">		
	<cfelseif attributes.banner eq "yellow">	
		<cfset background = "Images/logos/Banners/HumanResourcesYellow.jpg">
		<cfset attributes.textColorLabel = "523900">	
		<cfset attributes.textColorName = "523900">
		<cfset attributes.textColorClose = "523900">
		<cfset attributes.textColorOption = "000000">
	<cfelseif attributes.banner eq "green">	
		<cfset background = "Images/logos/Banners/FinancialsGreen.jpg">
		<cfset attributes.textColorLabel = "FFFFFF">
		<cfset attributes.textColorName = "FFFFFF">
		<cfset attributes.textColorClose = "FFFFFF">
		<cfset attributes.textColorOption = "FFFFFF">
		
	<cfelseif attributes.banner eq "red">	
		<cfset background = "Images/logos/Banners/ProgramRed.jpg">
		<cfset attributes.textColorLabel = "FFFFFF">
		<cfset attributes.textColorName = "FFFFFF">
		<cfset attributes.textColorClose = "FFFFFF">
		<cfset attributes.textColorOption = "FFFFFF">
		
	<cfelseif attributes.banner eq "blue" or attributes.background eq "linesBlue">	
		<cfset background = "Images/logos/Banners/OperationsBlue.jpg">
		<cfset attributes.textColorLabel = "FFFFFF">
		<cfset attributes.textColorName = "FFFFFF">
		<cfset attributes.textColorClose = "FFFFFF">
		<cfset attributes.textColorOption = "FFFFFF">		
	<cfelse>	
		<cfset background = "Images/logos/Banners/OperationsBlue.jpg">
		<cfset attributes.textColorLabel = "FFFFFF">
		<cfset attributes.textColorName = "FFFFFF">
		<cfset attributes.textColorClose = "ffffff">
		<cfset attributes.textColorOption = "000000">
	</cfif>
	
</cfif>
