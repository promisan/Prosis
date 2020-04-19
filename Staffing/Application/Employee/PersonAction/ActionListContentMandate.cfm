
<cfset itm = "0">
<cfset fields=ArrayNew(1)>

<cfset itm = itm+1>
<cfset fields[itm] = {label    = "No",                   	
					  field      = "ActionDocumentNo",	
					  width      = "8",					
					  search     = ""}>
			
<cfset itm = itm+1>						
<cfset fields[itm] = {label         = "Name", 					
					  field         = "Name",											
					  filtermode    = "0",
					  search        = "text"}>												

<cfset itm = itm+1>						
<cfset fields[itm] = {label           = "Index", 					
					  field           = "IndexNo",	
					  functionscript  = "EditPerson",
					  functionfield   = "PersonNo",						
					  filtermode      = "0",
					  search          = "text"}>	
					
<cfset itm = itm+1>								
<cfset fields[itm] = {label           = "Personnel Action", 					
					  field           = "ActionCode",											
					  filtermode      = "3",
					  display         = "0",
					  search          = "text"}>						
										
<cfset itm = itm+1>								
<cfset fields[itm] = {label      = "Personnel Action", 					
					  field      = "PersonnelAction"}>						
	
<cfset itm = itm+1>						
<cfset fields[itm] = {label      = "Reason", 					
					  field      = "ActionReason",											
					  filtermode = "3",
					  display    = "0",
					  search     = "text"}>	

<!---		
<cfset itm = itm+1>								
<cfset fields[itm] = {label      = "Status", 					
					field      = "ActionStatus",	
					filtermode = "2",	
					search     = "text",								
					alias      = ""}>		
					
					--->										

<cfset itm = itm+1>					
<cfset fields[itm] = {label     = "Effective",    					
					field       = "ActionDate",					
					formatted   = "dateformat(ActionDate,CLIENT.DateFormatShow)",
					search      = "date"}>	

<!---					
<cfset itm = itm+1>					
<cfset fields[itm] = {label     = "Expiration",    					
					field       = "ActionExpiration",					
					formatted   = "dateformat(ActionExpiration,CLIENT.DateFormatShow)",
					search      = ""}>										
--->					
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label     = "Raised by", 					
					field       = "OfficerLastName",	
					width       = "32",									
					filtermode  = "3"}>			
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label     = "Raised by", 					
					field       = "Officer",										
					filtermode  = "2",
					display    = "0",
					search      = "text"}>												
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label     = "Recorded",    					
					field       = "Created",	
					search      = "date",				
					formatted   = "dateformat(Created,CLIENT.DateFormatShow)"}>	
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label     = "Processed",  
                    labelfilter = "Last Processed",   					
					field       = "LastProcessed",					
					formatted   = "dateformat(Lastprocessed,CLIENT.DateFormatShow)",
					search      = "date"}>	
					
<cfset itm = itm+1>						
<cfset fields[itm] = {label       = "F", 	
                    LabelFilter   = "Workflow status",				
					field         = "workflow",					
					filtermode    = "3",    
					search        = "text",
					align         = "center",
					formatted     = "Rating",
					ratinglist    = "In Process=Yellow,Completed=Green,9=Red"}>							
		
										
<cfset itm = itm+1>		
<cfset fields[itm] = {label      = "No",                   
					Display    = "0",				
					field      = "ActionId"}>					
	

<!--- embed|window|dialogajax|dialog|standard --->
	
	<cf_listing header  = "PersonnelAction"
	    box           = "actiondetail"
		link          = "#SESSION.root#/Staffing/Application/Employee/PersonAction/ActionListContent.cfm?init=0&id1=#url.id1#&systemfunctionid=#url.systemfunctionid#&mode=#url.mode#&mission=#url.mission#&mandateno=#url.mandateno#"
	    html          = "No"		
		datasource    = "AppsQuery"
		listquery     = "#myquery#"
		listorder     = "ActionDocumentNo"
		listorderdir  = "DESC"
		headercolor   = "ffffff"				
		tablewidth    = "100%"
		listlayout    = "#fields#"
		FilterShow    = "Yes"
		ExcelShow     = "Yes"
		drillmode     = "tab" 
		drillargument = "900;990"	
		drilltemplate = "Staffing/Application/Employee/PersonAction/ActionDialog.cfm?drillid="
		drillkey      = "ActionDocumentNo">			
		
		
		
