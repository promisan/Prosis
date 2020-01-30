
<cfsavecontent variable="myquery">		
  SELECT *
  FROM (
    SELECT   R.* , 
	         S.Description as MenuName, 
			 S.MenuOrder	       
	FROM     Ref_AuthorizationRole R, System.dbo.Ref_SystemModule S
	WHERE    R.SystemModule = S.SystemModule
	AND      S.Operational = 1	
	) as S
	
	WHERE 1=1
	
	-- condition
	
</cfsavecontent>
	
<cfparam name="client.header" default="">

<cfset fields=ArrayNew(1)>
				
<cfset fields[1] = {label         = "Module",                  
					field         = "MenuName",
					fieldsort     = "MenuOrder",										
					filtermode    = "2",
					searchalias   = "S",		
					displayfilter = "Yes",				
					searchfield   = "MenuName",
					search        = "text"}>		
				
<cfset fields[2] = {label         = "Role",                  
					field         = "Description",		
					alias         = "S",	
					searchalias   = "S",	
					searchfield   = "Description",						
					search        = "text"}>	
									
<cfset fields[3] = {label       = "Code",                  
					field       = "Role",
					filtermode  = "0",
					search      = "text"}>					

<cfset fields[4] = {label       = "Area",                  
					field       = "Area",
					filtermode  = "2"}>	
					
<cfset fields[5] = {label       = "Function",                  
					field       = "SystemFunction",
					filtermode  = "0"}>								
						
<cfset fields[6] = {label       = "Scope",                  
					field       = "OrgUnitLevel",
					filtermode  = "2",
					search      = "text"}>				
					
<cfset fields[7] = {label       = "Parameter",                  
					field       = "Parameter",
					filtermode  = "2"}>		
					
<cfset fields[8] = {label       = "Owner",                  
					field       = "RoleOwner",
					alias       = "S",	
					searchalias = "S",	
					filtermode  = "2",
					search      = "text"}>		
					
<cfset fields[9] = {label       = "Class",                  
					field       = "RoleClass",
					filtermode  = "2",
					search      = "text"}>			
					

<cfinvoke component = "Service.Access"  
    method          = "system"        
    returnvariable  = "access">	
																							
<cfif access eq "ALL" or access eq "EDIT">	
    <cfset template = "/System/Access/Role/RecordEdit.cfm?drillid=">
	<cfset mode     = "window">
<cfelse>
    <cfset template = "">
	<cfset mode     = "">
</cfif>

<cfinvoke component = "Service.Access"  
    method          = "system"        
    returnvariable  = "access">	
	
<cf_tl id="Add Role" var="1">			
 
<cfset menu=ArrayNew(1)>		
<cfif access eq "ALL">	
  <cfset menu[1] = {label = "#lt_text#", script = "recordadd()"}>		  
</cfif>   

	
<cf_listing
    header         = "Role"		
    box            = "role"
	link           = "#SESSION.root#/System/Access/Role/RecordListingContent.cfm?systemfunctionid=#url.systemfunctionid#"
    html           = "No"
	menu           = "#menu#"
	show           = "200"	
	width          = "99%"
	datasource     = "AppsOrganization"
	listquery      = "#myquery#"
	listkey        = "Role"
	
	listgroup      = "MenuOrder"
	listgroupfield = "MenuName"
	listgroupalias = "S"
	listgroupdir   = "ASC"	
	
	listorder      = "ListingOrder"	
	listorderalias = "S"
		
	listlayout     = "#fields#"
	filterShow     = "Yes"
	excelShow      = "Yes"
	drillmode      = "#mode#"	
	drillargument  = "600;700;true;true"	
	drilltemplate  = "#template#"
	drillkey       = "Role">