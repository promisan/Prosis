
<cfquery name="Mission"
	datasource="AppsOrganization"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Mission
	WHERE  Mission = '#url.mission#'
</cfquery>

<cfset itm = 0>
		
<cfset fields=ArrayNew(1)>

 <cfif URL.HierarchyCode eq "">
 
	  <cfset itm = itm + 1>					
   <cfset fields[itm] = {label      = "Entity", 					
					  field      = "ParentUnit",										
					  search     = "text",
					  filtermode = "3"}>	
 
 <cfelse>
 
 
   <cfset itm = itm + 1>					
   <cfset fields[itm] = {label      = "Unit", 					
					  field      = "OrgUnitNameShort",										
					  search     = "text",
					  filtermode = "3"}>	
 
 </cfif>

<cfset itm = itm + 1>					
<cfset fields[itm] = {label      = "Position", 					
					  field      = "SourcePostNumber",										
					  search     = "text"}>	
				  
<cfset itm = itm + 1>					
<cfset fields[itm] = {label      = "C", 	
                      labelfilter = "Post count",
					  align      = "center",				
					  field      = "PositionCount",
					  search     = "text",
					  filtermode = "3"}>				  
					  
<cfset itm = itm + 1>					  
<cfset fields[itm] = {label      = "Status",                  					
					  field      = "PostStatus",	
					  width      = "20",				
					  search     = "text",
					  filtermode = "2"}>	
					  
<cfset itm = itm + 1>						
<cfset fields[itm] = {label      = "Type", 					
					  field      = "PostType",		
					  column     = "common",											
					  search     = "text", 
					  filtermode = "3"}>							  				  

<cfset itm = itm + 1>					  
<cfset fields[itm] = {label      = "Grade",                  					
					  field      = "PostGradeBudget",		
					  fieldsort  = "PostOrderBudget",		
					  column     = "common",				  			
					  search     = "text",
					  filtermode = "3"}>					  					  
					  
<cfset itm = itm + 1>						
<cfset fields[itm] = {label      = "Title",                     
					  field      = "FunctionDescription", 													
					  search     = "text", 
					  filtermode = "2"}>	
					  
<cfset itm = itm + 1>						
<cfset fields[itm] = {label      = "Fund",                     
					  field      = "Fund", 													
					  search     = "text", 
					  filtermode = "3"}>	
					  
<cfset itm = itm + 1>						
<cfset fields[itm] = {label      = "FA",                     
					  field      = "FunctionalArea", 													
					  search     = "text", 
					  align      = "center",
					  filtermode = "3"}>						  					  
					  
<cfset itm = itm+1>						
<cfset fields[itm] = {label       = "I", 	
   	                LabelFilter   = "Has incumbent",				
					field         = "IncumbentStatus",					
					filtermode    = "3",    
					search        = "text",
					align         = "center",
					formatted     = "Rating",
					ratinglist    = "Vacant=White,Temporary=Blue,Owner=Green"}>	

<!---					
<cfset itm = itm+1>						
<cfset fields[itm] = {label       = "O", 	
   	                LabelFilter   = "Owner on post",				
					field         = "IncumbentOwner",					
					filtermode    = "3",    
					search        = "text",
					align         = "center",
					formatted     = "Rating",
					ratinglist    = "0=White,1=Green"}>		
					
--->									
					
<cfset itm = itm+1>						
<cfset fields[itm] = {label          = "L", 	
   	                 LabelFilter     = "has Lien",				
					 field           = "IncumbentLien",					
					 filtermode      = "3",    
					 search          = "text",
					 align           = "center",
					 formatted       = "Rating",
					 ratinglist      = "0=White,1=Green"}>		
					 
<cfset itm = itm+1>	
<cf_tl id="Vacant" var = "1">		
<cfset fields[itm] = {label          = "#lt_text#",                    
     				labelfilter      = "Vacancy start",
					field            = "DateVacant",	
					align            = "Center",	
					display          = "1",													
					formatted        = "dateformat(DateVacant,'#CLIENT.DateFormatShow#')",																																												
					search           = "date"}>						 										  
					  
<cfset itm = itm + 1>						
<cfset fields[itm] = {label          = "Track",                     
					  field          = "Reference", 	
					  functionscript = "showdocument",		
					  functionfield  = "DocumentNo",	
					  align          = "Center",	
					  width          = "10",						
					  search         = "text", 
					  filtermode     = "4"}>	
					  
<cfset itm = itm + 1>						
<cfset fields[itm] = {label      = "Type",                     
					  field      = "DocumentType", 			
					  column     = "common",	
					  align      = "Center",										
					  search     = "text", 
					  filtermode = "3"}>	

					  
  
<cfset itm = itm+1>	
<cf_tl id="Select" var = "1">		
<cfset fields[itm] = {label       = "S",                    
     				labelfilter   = "#lt_text#",
					field         = "TrackSelectedCandidate",	
					display       = "1",								
					align         = "center",
					rowlevel      = "1",
					Colspan       = "1"}>	
					
										
<cfset itm = itm+1>	
<cf_tl id="Expected" var = "1">		
<cfset fields[itm] = {label       = "#lt_text#",                    
     				labelfilter   = "Expected onboarding",
					field         = "ExpectedOnBoarding",	
					alert         = "ExpectedOnBoarding lt now()",
					align         = "Center",	
					display       = "1",													
					formatted     = "dateformat(ExpectedOnBoarding,'#CLIENT.DateFormatShow#')",																																												
					search        = "date"}>							
	 

										  
<cfset itm = itm+1>	
<cf_tl id="Remarks" var = "1">		
<cfset fields[itm] = {label       = "#lt_text#",                    
     				labelfilter   = "#lt_text#",
					field         = "Remarks",	
					display       = "1",	
					rowlevel      = "2",
					Colspan       = "8",																																																		
					search        = "text"}>	
					
<cfset itm = itm+1>	
<cf_tl id="Aging" var = "1">		
<cfset fields[itm] = {label       = "#lt_text#",                    
     				labelfilter   = "#lt_text#",
					field         = "TrackPostedDays",	
					display       = "1",	
					rowlevel      = "2",
					align         = "center",
					Colspan       = "1"}>						
					
<cfset itm = itm+1>	
<cf_tl id="Incumbent" var = "1">		
<cfset fields[itm] = {label       = "#lt_text#",                    
     				labelfilter   = "#lt_text#",
					field         = "IncumbentUserLastName",	
					functionscript = "EditPerson",		
					functionfield  = "IncumbentUserPersonNo",	
					align         = "right",
					display       = "1",	
					rowlevel      = "2",
					Colspan       = "3"}>							
					

<cfset itm = itm+1>	
<cf_tl id="Action" var = "1">		
<cfset fields[itm] = {label       = "#lt_text#",                    
     				labelfilter   = "#lt_text#",
					field         = "ActionDescription",	
					align         = "right",
					display       = "1",	
					rowlevel      = "2",
					Colspan       = "5"}>										
	

<!--- embed|window|dialogajax|dialog|standard --->
			
<cf_listing header  = "PositionTrackDetail"
    box             = "position_#url.mission#"
	link            = "#SESSION.root#/Vactrack/Application/ControlView/ControlListingPositionContent.cfm?systemfunctionid=#url.systemfunctionid#&mission=#url.mission#&hierarchycode=#url.hierarchyCode#"
    html            = "No"		
	datasource      = "AppsEmployee"
	listquery       = "#session.selecttracks#"
	listorder       = "SourcePostNumber"
	listorderalias  = ""
	listorderdir    = "DESC"
	headercolor     = "ffffff"				
	tablewidth      = "100%"
	listlayout      = "#fields#"
	FilterShow      = "Yes"
	ExcelShow       = "Yes"
	drillmode       = "tab" 
	drillargument   = "980;1100;true"	
	drilltemplate   = "Staffing/Application/Position/PositionParent/PositionView.cfm?drillid="
	drillkey        = "PositionNo">	

<cfset ajaxonload("doCalendar")>	


	