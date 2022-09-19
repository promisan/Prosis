
<cfparam name="url.mode"      default="">
<cfparam name="url.condition" default="">
<cfparam name="url.filter"    default="">

<cfquery name="Mission"
	datasource="AppsOrganization"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Mission
	WHERE  Mission = '#url.mission#'
</cfquery>

<cfset pre = mission.missionPrefix>

<cfquery name="agingBase"
	datasource="AppsVacancy"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     stAging
		ORDER BY ListingOrder
</cfquery>

<cfset qryvar = evaluate("session.selectedtracks_#pre#")>

<cfsavecontent variable="myTrack">

	   <cfoutput>	
	   SELECT * --,duedate,created, dateposted
	   FROM (  
	       	<cfloop query="AgingBase">
				SELECT  *,
				        '#Description#'         as Aging, 
						'#ListingOrder#'        as AgingOrder
				FROM    (#preservesingleQuotes(qryvar)#) as D
				WHERE   1=1									
				AND     #Condition# <!--- only tracks without selection --->				
				<cfif recordcount neq currentrow>
				UNION ALL
				</cfif>
			</cfloop>
			) as D
							
		WHERE 1=1
		
		<cfif url.mode eq "status">
		AND     ActionDescription = '#url.filter#' 
		<cfelseif url.mode eq "aging" and url.condition eq "0">
		AND     Aging = '#url.filter#' 
		
		AND     DatePosted is not NULL
		<!--- no selected candidate yet --->
		AND     D.DocumentNo NOT IN (SELECT DocumentNo FROM Vacancy.dbo.DocumentCandidate WHERE Status IN ('2s','3'))
		
		<cfelseif url.mode eq "postgrade">
		AND     PostGradeBudget  = '#url.filter#' 
		<cfelseif url.mode eq "aging">
		AND     Aging = '#url.filter#'	
		</cfif>
		
		</cfoutput>
		--condition
	
</cfsavecontent>

<cfset itm = 0>
		
<cfset fields=ArrayNew(1)>

<cfset itm = itm + 1>	
<cf_tl id="Track" var = "1">					
<cfset fields[itm] = {label          = "#lt_Text#", 					
					  field          = "DocumentNo",										
					  search         = "text"}>	
					  
<cfset itm = itm + 1>					
<cfset fields[itm] = {label          = "Type", 					
					  field          = "DocumentType",										
					  search         = "text",
					  column         = "common",	
					  filtermode     = "3"}>						  
				  
<cfset itm = itm+1>	
<cf_tl id="Reference" var = "1">		
<cfset fields[itm] = {label          = "#lt_text#",                    
     				labelfilter      = "#lt_text#",
					field            = "ReferenceNoExternal",	
					display          = "1",																																																									
					search           = "text"}>		  
					  
<cfset itm = itm + 1>					  
<cfset fields[itm] = {label          = "Grade",                  					
					  field          = "PostGrade",		
					  fieldsort      = "PostGrade",	
					  column         = "common",					  			
					  search         = "text",
					  filtermode     = "3"}>		
					  
<cfset itm = itm + 1>					  
<cfset fields[itm] = {label          = "OrgUnit",                  					
					  field          = "OrgUnitNameShort",					  			
					  search         = "text",
					  filtermode     = "3"}>	
					  			  
<cfset itm = itm + 1>						
<cfset fields[itm] = {label          = "Title",                     
					  field          = "FunctionalTitle", 													
					  search         = "text", 
					  filtermode     = "2"}>	
					  
<cfset itm = itm+1>	
<cf_tl id="Vacant" var = "1">		
<cfset fields[itm] = {label          = "#lt_text#",                    
     				 labelfilter     = "Vacancy start",
					 field           = "DateVacant",	
					 align           = "Center",	
					 display         = "1",													
					 formatted       = "dateformat(DateVacant,'#CLIENT.DateFormatShow#')"}>							  

<cfif (url.mode is "status" and url.filter eq "") or url.mode eq "All" or url.mode eq "Aging">
						  					  
	<cfset itm = itm + 1>					  
	<cfset fields[itm] = {label          = "Action",                  					
						  field          = "ActionDescription",					  			
						  search         = "text",
						  column         = "common",	
						  filtermode     = "3"}>				  					  
					  
<cfelse>					  
					  
	<cfset itm = itm + 1>					  
	<cfset fields[itm] = {label          = "Officer",                  					
						  field          = "OfficerUserLastName",
						  search         = "text",
						  filtermode     = "3"}>	
						  
</cfif>		  
			  					  
					  
<cfset itm = itm + 1>					  
<cfset fields[itm] = {label          = "Created",                  					
					  field          = "Created",	
					  align          = "Center",
					  column         = "month",				
					  formatted      = "dateformat(Created,'#CLIENT.DateFormatShow#')"}>			
					  
<cfset itm = itm + 1>					  
<cfset fields[itm] = {label          = "Posted",                  					
					  field          = "DatePosted",	
					  align          = "Center",
					  column         = "month",				
					  formatted      = "dateformat(DatePosted,'#CLIENT.DateFormatShow#')"}>		
					  
<cfset itm = itm+1>	
<cf_tl id="Aging" var = "1">		
<cfset fields[itm] = {label          = "#lt_text#",                    
     				labelfilter      = "#lt_text#",
					field            = "Aging",	
					column           = "common",	
					display          = "1",	
					align            = "center",																																																								
					search           = "text"}>						  
					  
<cfset itm = itm + 1>					  
<cfset fields[itm] = {label          = "C",                  					
					  field          = "CandidateCount",	
					  functionscript = "details",		
					  functionfield  = "FunctionId",					
					  align          = "center"}>						  					  			  	
					
<cfset itm = itm+1>	
<cf_tl id="Expected" var = "1">		
<cfset fields[itm] = {label          = "#lt_text#",                    
     				labelfilter      = "Expected onboarding",
					field            = "DueDate",	
					alert            = "Duedate lte now()",
					align            = "Center",	
					column           = "month",		
					display          = "1",													
					formatted        = "dateformat(Duedate,'#CLIENT.DateFormatShow#')",																																												
					search           = "date"}>								 
<!---
					  
<cfset itm = itm+1>	
<cf_tl id="Remarks" var = "1">		
<cfset fields[itm] = {label       = "#lt_text#",                    
     				labelfilter   = "#lt_text#",
					field         = "Remarks",	
					display       = "1",	
					rowlevel      = "2",
					Colspan       = "9",																																																		
					search        = "text"}>	
					
										
--->
	
<cfif url.mode neq "status">
		<cfset fil = "Hide">
<cfelse>
        <cfset fil = "Yes">
</cfif>	

<!--- embed|window|dialogajax|dialog|standard --->
			
<cf_listing header  = "VacancyTrackDrill"
    box             = "vacancydrill_#url.mission#"
	link            = "#SESSION.root#/Vactrack/Application/ControlView/ControlListingTrackContent.cfm?mode=#url.mode#&condition=#url.condition#&filter=#url.filter#&systemfunctionid=#url.systemfunctionid#&mission=#url.mission#"
    html            = "No"		
	datasource      = "AppsEmployee"
	listquery       = "#mytrack#"
	listorder       = "DocumentNo"
	listorderalias  = ""
	listorderdir    = "DESC"
	headercolor     = "ffffff"				
	tablewidth      = "98%"
	listlayout      = "#fields#"
	FilterShow      = "#fil#"
	ExcelShow       = "Yes"
	drillmode       = "tab" 
	drillargument   = "980;1100;true"	
	drilltemplate   = "Vactrack/Application/Document/DocumentEdit.cfm?id="
	drillkey        = "DocumentNo">	

<cfset ajaxonload("doCalendar")>	


	