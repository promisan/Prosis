<!--- get a list [accesslist] with all units from the tree to which a user has been granted access  
this list also includes parent records in case the user has access to the child only in order to select from a tree listing correctly --->

<cf_treeunitList 
   mission="#mission#"    
   role="'CaseFileManager'">
   
<cf_tl id="Organization" var="1">						

<cftreeitem value="organization"
        display="<td class='labelmedium'>#lt_text#"		
		href     = "javascript:list('ORG','')"			
		expand="No" 
		parent="standard">	
		      
   <cfquery name="listUnit" 
    datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT DISTINCT TreeOrder, 
	                OrgUnitName, 
					OrgUnit,  
					OrgUnitCode, 
					HierarchyCode,
					MissionOrgUnitId 
	FROM   #CLIENT.LanPrefix#Organization
	WHERE  Mission = '#Mission#'
	<!--- only the parent units to be selected here --->
   	AND   (ParentOrgUnit is NULL OR ParentOrgUnit = '' OR Autonomous = 1)
	
	<!--- only relevant units to be shown for which access is defined --->
	
	AND   CONVERT(varchar(38), MissionOrgUnitId) + '_' + MandateNo IN (
	
				SELECT    CONVERT(varchar(38), MissionOrgUnitId) + '_' + MAX(MandateNo)
				FROM      Organization
				WHERE     Mission = '#Mission#'
				<cfif accesslist neq "full">
				AND       OrgUnit IN (#preserveSingleQuotes(accesslist)#)	  	
				<cfelseif accesslevel neq "ALL"> 
				AND    1=0  	
				</cfif>
				GROUP BY MissionOrgUnitId				
   		
			)
	ORDER BY HierarchyCode		
	</cfquery>			
		
	<cfloop query="listUnit">
		  
		 	<cftreeitem value="#orgunit#"
	        display  = "#OrgUnitName#"
			parent   = "organization"					
			expand   =  "No"
			href     = "javascript:list('ORG','#OrgUnit#')">	
			 
	</cfloop>
	
	
