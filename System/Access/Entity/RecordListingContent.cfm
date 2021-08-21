
<cfsavecontent variable="myquery">		
  SELECT *
  FROM (
    SELECT   S.*, (SELECT count(*) 
	              FROM MissionProfileUser        
				  WHERE ProfileId = S.ProfileId) as Users, (SELECT count(*) 
	              FROM MissionProfileGroup      
				  WHERE ProfileId = S.ProfileId) as Groups
	FROM     MissionProfile S	
	) as S
	
	WHERE 1=1
	
	-- condition
	
</cfsavecontent>
	
<cfparam name="client.header" default="">

<cfset fields=ArrayNew(1)>

<cfset itm = 1>				
<cfset fields[itm] = {label       = "Mission",                  
					field         = "Mission",												
					filtermode    = "3",
					search        = "text",
					searchalias   = "S",		
					displayfilter = "Yes"}>		

<cfset itm = itm+1>				
<cfset fields[itm] = {label       = "Function",                  
					field         = "FunctionName",		
					alias         = "S",	
					searchalias   = "S",	
					searchfield   = "FunctionName",						
					search        = "text"}>	
					
<cfset itm = itm+1>									
<cfset fields[itm] = {label       = "Groups",                  
                    labelfilter   = "Groups",
					field         = "Groups",					
					search        = "amount"}>						
					
<cfset itm = itm+1>									
<cfset fields[itm] = {label       = "Users",                  
                    labelfilter   = "Users",
					field         = "Users",					
					search        = "amount"}>	
					
<cfset itm = itm+1>	
<cf_tl id="Officer" var="1">
<cfset fields[itm] = {label       = "#lt_text#",    					
					field         = "OfficerLastName",		
					fieldentry    = "1",					
					labelfilter   = "#lt_text#"}>	
					
<cfset itm = itm+1>	
<cf_tl id="Created" var="1">
<cfset fields[itm] = {label       = "#lt_text#",    					
					field         = "Created",		
					fieldentry    = "1",					
					labelfilter   = "#lt_text#",						
					formatted     = "dateformat(Created,CLIENT.DateFormatShow)"}>								
					
<cfset itm = itm+1>						
<cfset fields[itm] = {label       = "S", 	
                    LabelFilter   = "Operational",				
					field         = "Operational",					
					filtermode    = "3",    
					search        = "text",
					align         = "center",
					formatted     = "Rating",
					ratinglist    = "0=Yellow,1=Green,9=Red"}>													


<cfinvoke component = "Service.Access"  
    method          = "system"        
    returnvariable  = "access">	
																							
<cfif access eq "ALL" or access eq "EDIT">	
    <cfset template = "/System/Access/Entity/FunctionEdit.cfm?id1=">
	<cfset mode     = "window">
<cfelse>
    <cfset template = "">
	<cfset mode     = "">
</cfif>

<cfinvoke component = "Service.Access"  
    method          = "system"        
    returnvariable  = "access">	
	
<cf_tl id="Add Function" var="1">			
 
<cfset menu=ArrayNew(1)>		
<cfif access eq "ALL">	
  <cfset menu[1] = {label = "#lt_text#", script = "recordadd()"}>		  
</cfif>   
	
<cf_listing
    header         = "MissionFunction"		
    box            = "MissionFunction"
	link           = "#SESSION.root#/System/Access/Entity/RecordListingContent.cfm?systemfunctionid=#url.systemfunctionid#"
    html           = "No"
	menu           = "#menu#"
	show           = "200"	
	width          = "100%"
	datasource     = "AppsOrganization"
	listquery      = "#myquery#"
	listkey        = "ProfileId"
	
	listgroup      = "Mission"
	listgroupfield = "Mission"
	listgroupalias = "S"
	listgroupdir   = "ASC"	
	
	listorder      = "ListingOrder"	
	listorderalias = "S"
		
	listlayout     = "#fields#"
	filterShow     = "Yes"
	excelShow      = "Yes"
	drillmode      = "#mode#"	
	drillargument  = "500;900;true;true"	
	drilltemplate  = "#template#"
	drillkey       = "ProfileId">