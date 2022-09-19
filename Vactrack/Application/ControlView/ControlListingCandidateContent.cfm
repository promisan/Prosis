
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

<cfoutput>
<cfsavecontent variable="SelectTracks">
	   
	   SELECT * 
	   FROM (  
	       	
				SELECT  *
				FROM    (#preservesingleQuotes(session.selectedcandidates)#) as V
				WHERE   1=1		
				
			) as D
							
		WHERE 1=1
						
		<cfif url.mode eq "country">
		AND     ISOCODE2 = '#url.filter#' 
		<cfelseif url.mode eq "gender">
		AND     Gender = '#url.filter#'
		<cfelseif url.mode eq "countrygroup">
		AND     CountryGroup = '#url.filter#' 		
		<cfelseif url.mode eq "postgrade">
		AND     PostGradeBudget  = '#url.filter#' 		
		</cfif>
				
		--condition
	
</cfsavecontent>
</cfoutput>


<cfset itm = 0>
		
<cfset fields=ArrayNew(1)>

<cfset itm = itm + 1>	
<cf_tl id="Track" var = "1">					
<cfset fields[itm] = {label          = "#lt_Text#", 					
					  field          = "DocumentNo",										
					  search         = "text"}>	
					  
<cfset itm = itm + 1>	
<cf_tl id="Status" var = "1">					
<cfset fields[itm] = {labelfilter    = "#lt_Text#", 	
                      label          = "S",				
					  field          = "Status"}>	
					  
					  					  
<cfset itm = itm + 1>	
<cf_tl id="Type" var = "1">						
<cfset fields[itm] = {label          = "#lt_text#", 					
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
<cf_tl id="Grade" var = "1">						  
<cfset fields[itm] = {label          = "#lt_text#",                  					
					  field          = "PostGrade",		
					  fieldsort      = "PostGradeOrder",	
					  column         = "common",					  			
					  search         = "text",
					  filtermode     = "3"}>		

<!---					  
<cfset itm = itm + 1>					  
<cfset fields[itm] = {label          = "OrgUnit",                  					
					  field          = "OrgUnitNameShort",					  			
					  search         = "text",
					  filtermode     = "3"}>	
--->					  

					  			  
<cfset itm = itm + 1>						
<cfset fields[itm] = {label          = "Title",                     
					  field          = "FunctionalTitle", 													
					  search         = "text", 
					  filtermode     = "2"}>	
					  
<cfset itm = itm + 1>						
<cfset fields[itm] = {label          = "S",                     
                      labelfilter    = "Gender",     
					  field          = "Gender", 
					  column         = "common",														
					  search         = "text", 
					  filtermode     = "2"}>		

<cfif url.mode eq "countrygroup">

<cfset itm = itm + 1>						
<cfset fields[itm] = {label          = "N",                     
                      labelfilter    = "Nationality",     
					  field          = "Nationality", 													
					  search         = "text", 
					  filtermode     = "3"}>	

<cfelse>
					  
<cfset itm = itm + 1>						
<cfset fields[itm] = {label          = "Country",                     
                      labelfilter    = "Country group",     
					  field          = "CountryGroup", 		
					  column         = "common",												
					  search         = "text", 
					  filtermode     = "3"}>		
					  
</cfif>					  
					  
<cfset itm = itm + 1>						
<cfset fields[itm] = {label          = "LastName",                     
					  field          = "LastName", 													
					  search         = "text"}>	
					  
<cfset itm = itm + 1>						
<cfset fields[itm] = {label          = "FirstName",                     
					  field          = "FirstName", 													
					  search         = "text"}>			
					  
<cfset itm = itm + 1>						
<cfset fields[itm] = {label          = "IndexNo",                     
					  field          = "IndexNo", 													
					  search         = "text"}>			
					  
<cfset itm = itm + 1>						
<cfset fields[itm] = {label          = "Selected",                     
                      labelfilter    = "Selected",  
					  display        = "No",    
					  aggregate      = "sum",
					  field          = "Selected"}>						  				  			  					  				  				  

<!---
					  
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
<cf_tl id="Expected" var = "1">		
<cfset fields[itm] = {label          = "#lt_text#",                    
     				labelfilter      = "Expected onboarding",
					field            = "DueDate",	
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

--->
					
	
<cfif url.mode neq "status">
		<cfset fil = "Hide">
<cfelse>
        <cfset fil = "Yes">
</cfif>	

<!--- embed|window|dialogajax|dialog|standard --->
			
<cf_listing header  = "VacancyCandidateDrill"
    box             = "vacancycandidate_#url.mission#"
	link            = "#SESSION.root#/Vactrack/Application/ControlView/ControlListingCandidateContent.cfm?mode=#url.mode#&condition=#url.condition#&filter=#url.filter#&systemfunctionid=#url.systemfunctionid#&mission=#url.mission#"
    html            = "No"		
	datasource      = "AppsVacancy"
	listquery       = "#selecttracks#"
	listorder       = "SourcePostNumber"
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



	