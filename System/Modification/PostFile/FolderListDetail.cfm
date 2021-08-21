
<!--- configuration file --->

<cfoutput>
	
	<cfset fields=ArrayNew(1)>
	
	<cfset fields[1] = {label   = "Name",   
						field   = "Name",
						search  = "default"}>
	
	<cfset fields[2] = {label   = "Size",                
						field   = "Size"}>					
						
	<cfset fields[3] = {label   = "Type",                  
						field   = "Type"}>							
	
	<cfset fields[4] = {label      = "Date", 					
						field      = "DateLastModified",
						formatted  = "dateformat(DateLastModified,CLIENT.DateFormatShow)",
						search     = "date"}>
						
	<cfset fields[5] = {label      = "Time",    					
						field      = "DateLastModified",
						formatted  = "timeformat(DateLastModified,'HH:MM')"}>			
	
	<cfset dir = replace(url.dir, "\", "\\", "ALL")>
	
	
	<cfset key = replace(url.key, "\", "\\", "ALL")>
	
										
	<cf_listing
	    header         = "<font size='2'>Files Stored in directory: #key#</font>"
	    box            = "myfileslisting"
		link           = "#SESSION.root#/System/Modification/PostFile/FolderListDetail.cfm?dir=#dir#&key=#key#&systemfunctionid=#url.systemfunctionid#"
	    html           = "No"	
		tablewidth     = "99.5%"
		tableheight    = "100%"
		listtype       = "directory"
		listpath       = "#dir#"
		listquery      = "#key#"
		listkey        = "Name"
		listorder      = "DateLastModified"
		listorderdir   = "DESC"
		headercolor    = "ffffff"
		listlayout     = "#fields#"
		drillmode      = "tab"
		drillargument  = "680;860;false;false"	
		drilltemplate  = ""
		drillkey       = ""
		deletetable    = "">
		
</cfoutput>	
