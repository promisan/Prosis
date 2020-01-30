
<cfsavecontent variable="myquery">		
	SELECT  ApplicationServer, 
	        Owner,
			ServerLocation, 
		    ServerRole, 
			HostName, 
			NodeIP, 
			VersionDate, 
			DistributionEMail, 
          	ReplicaPath, 
			Created, 
			CASE Operational
		    WHEN 1 THEN 'Yes'
			        ELSE 'No'
			END as Active,
			CASE EnableCodeEncryption
		    WHEN 1 THEN 'Yes'
			        ELSE 'No'
			END as EnableCodeEncryption
	FROM    ParameterSite
	ORDER BY ServerLocation
</cfsavecontent>

<cfset itm = 0>

<cfset fields = ArrayNew(1)>

<cfset itm = itm+1>         
<cfset fields[itm] = {label   = "Name",                                                  
                     field   = "ApplicationServer",                                                                                                  
                     search  = "text"}>          
					 
<cfset itm = itm+1>         
<cfset fields[itm] = {label   = "Location",                                            
                     field   = "ServerLocation", 
					 filtermode = "2",                                                                                 
                     search  = "text"}>          					 

<cfset itm = itm+1>         
<cfset fields[itm] = {label   = "Owner",                                            
                     field   = "Owner", 
					 filtermode = "2",                                                                                 
                     search  = "text"}>          
    
<cfset itm = itm+1>         
<cfset fields[itm] = {label   = "Role",  
					 filtermode = "2",    
					 search  = "text",                                       
                     field   = "ServerRole"}>         

<cfset itm = itm+1>         
<cfset fields[itm] = {label   = "Host",                                      
                     field   = "NodeIP"}>                         

<cfset itm = itm+1>         
<cfset fields[itm] = {label   = "Encrypt",                                      
                     field    = "EnableCodeEncryption"}>    					 
					 
<cfset itm = itm+1>         
<cfset fields[itm] = {label   = "Version",                                      
                     field    = "VersionDate",               
                     display  = "No",                                                                
			         formatted  = "DateFormat(VersionDate,CLIENT.DateFormatShow)",
                     search  = "date"}>     					 
					                                                                    
<cfset itm = itm+1>         
<cfset fields[itm] = {label   = "Contact",                                               
                     field = "DistributionEmail"}>                                                                                                                                                                             

<cfset itm = itm+1>         
<cfset fields[itm] = {label   = "Local Replica Path",                                    
                     field   = "ReplicaPath"}>         
   
<cfset itm = itm+1>         
<cfset fields[itm] = {label   = "Active",                                      
                     field    = "Active"}>          

   
<cfset menu=ArrayNew(1)>	
<cf_tl id="Add Site" var="1">					 
<cfset menu[1] = {label = "#lt_text#", script = "recordadd()"}>								                                                                                      
          
<cf_listing
	header        = "Installation Site"
	box           = "linedetail"
	link          = "#SESSION.root#/System/Parameter/Site/RecordListingContent.cfm?systemfunctionid=#url.systemfunctionid#"
	html          = "No"         
	menu          = "#menu#"                  
	tableheight   = "100%"
	tablewidth    = "100%"
	datasource    = "AppsControl"
	listquery     = "#myquery#"
	listgroup     = "ServerLocation"
	listgroupdir  = "ASC"
	listorderfield = "Created"
	listorder      = "Created"
	listorderdir   = "ASC"
	headercolor   = "ffffff"
	show          = "35"               
	showrows      = "2"    
	filtershow    = "Hide"
	excelshow     = "Yes"                       
	listlayout    = "#fields#"
	allowgrouping = "No"
	drillmode      = "window" 
	drillargument  = "#client.height-200#;850;true;true"                                       
	drilltemplate  = "System/Parameter/Site/RecordEdit.cfm?idmenu=#url.systemfunctionid#&id1="
	drillkey       = "applicationserver"
	drillbox       = "addcasefile">
