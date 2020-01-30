
<!--- check role --->

<cfparam name="Attributes.Parameter"        default="">
<cfparam name="Attributes.LevelOverwrite"   default="1">
<cfparam name="Attributes.Group"            default="">
<cfparam name="Attributes.ListingOrder"     default="0">
<cfparam name="Attributes.GrantAllTrees"    default="0">
<cfparam name="Attributes.Memo"             default="">
<cfparam name="Attributes.Owner"            default="All">
<cfparam name="Attributes.AccessLevels"     default="3">
<cfparam name="Attributes.AccessLevelLabel" default="READ,EDIT (1),ALL (2)">

<cfquery name="Check" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_AuthorizationRoleOwner 
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_AuthorizationRoleOwner
	       (Code, 
		    Description)
	VALUES ('SysAdmin',
	        'System Administrator')
	</cfquery>
	
</cfif>

<cfquery name="Check" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_AuthorizationRole
	WHERE  Role = '#Attributes.Role#' 
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO Ref_AuthorizationRole
		       (Role, 
			    SystemModule, 
				SystemFunction,
				Area, 
				OrgUnitLevel, 
				Parameter,
				ParameterGroup,
				Description,
				RoleMemo,
				ListingOrder,
				GrantAllTrees,
				AccessLevels,
				AccessLevelLabelList,
				RoleClass)
		VALUES ('#Attributes.Role#',
		        '#Attributes.SystemModule#',
				'#Attributes.SystemFunction#',
				'#Attributes.Area#',
				'#Attributes.OrgUnitLevel#',
				'#Attributes.Parameter#',
				'#Attributes.Group#',
				'#Attributes.Description#',
				'#Attributes.Memo#',
				'#Attributes.ListingOrder#',
				'#Attributes.GrantAllTrees#',
				'#Attributes.AccessLevels#',
				'#Attributes.AccessLevelLabel#',
				'System'
			   ) 
	</cfquery>
	
<cfelse>

<cfquery name="Update" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_AuthorizationRole
	SET    SystemModule         = '#Attributes.SystemModule#', 
		   SystemFunction       = '#Attributes.SystemFunction#', 
	       Area                 = '#Attributes.Area#',
		   <cfif attributes.leveloverwrite eq "1">
	       OrgUnitLevel         = '#Attributes.OrgUnitLevel#',
		   </cfif>
		   Parameter            = '#Attributes.Parameter#',
		   ParameterGroup       = '#Attributes.Group#',		
		   Description          = '#Attributes.Description#',
		   RoleMemo             = '#Attributes.Memo#',
		   ListingOrder         = '#Attributes.ListingOrder#',
		   AccessLevels         = '#Attributes.AccessLevels#',
		   <cfif Attributes.AccessLevels neq check.AccessLevels>
    	   AccessLevelLabelList = '#Attributes.AccessLevelLabel#',
		   </cfif>
		   RoleClass            = 'System',
		   GrantAllTrees        = '#Attributes.GrantAllTrees#',
		   <cfif Attributes.Owner eq "Default">
		     <!--- do nothing --->
		   <cfelseif Attributes.Owner eq "All">	 
		   RoleOwner = NULL
		   <cfelse>
		   RoleOwner = '#Attributes.Owner#'
		   </cfif>
 	WHERE  Role = '#Attributes.Role#'
	</cfquery>	

</cfif>