
<!--- configuration file --->
<cfoutput>
	
	<cfsavecontent variable="myquery">
			SELECT  DistributionId,
			        Created,
			        DistributionEMail, 
					DistributionSubject,
					DistributionCategory, 
					LayoutName,
					FileFormat,
					DATEDIFF(ms, PreparationStart, PreparationEnd) AS Duration,
					OfficerUserId,
					OfficerFirstName+' '+OfficerLastName as Contact
			FROM    UserReportDistribution
			WHERE   ( 
			          (ReportId = '#url.reportId#' AND ReportId != '{00000000-0000-0000-0000-000000000000}')
				       OR    
				      (ControlId = '#url.ControlId#' AND Account = '#SESSION.acc#' 
					  -- AND ReportId = '{00000000-0000-0000-0000-000000000000}'
					  ) 
					)
			AND    DistributionStatus = '1'			 
						 			 		
	</cfsavecontent>
	
	
	
	<cfset fields=ArrayNew(1)>
	
	<cfset fields[1] = {label      = "Date",    					
						field      = "Created",
						formatted  = "dateformat(Created,CLIENT.DateFormatShow)",
						search     = "date"}>
						
	<cfset fields[2] = {label      = "Time",   						
						field      = "Created",
						formatted  = "timeformat(Created,'HH:MM')"}>			
	
	<cfset fields[3] = {label   = "MS", 	                 
						field   = "Duration",						
						search  = "text"}>
						
	<cfset fields[4] = {label   = "Layout", 	                  
						field   = "LayoutName",
						search  = "text"}>
						
	<cfset fields[5] = {label   = "Format", 
						filtermode = "2",
						field   = "FileFormat",
						search  = "text"}>
						
	<cfset fields[6] = {label   = "Address", 						
						field   = "DistributionEMail",
						search  = "text"}>
						
	<cfset fields[7] = {label   = "Mode", 						
						filtermode = "2",
						field   = "DistributionCategory",
						search  = "text"}>							
	
	<cfif client.height gt 768>
		 <cfset show = 39>
	<cfelse>
		 <cfset show = 25> 
	</cfif>		
									
												
	<cf_listing
	    header        = "lsReport"		
	    box           = "lsReport"
		link          = "#SESSION.root#/Tools/CFReport/HTML/FormHTMLLog.cfm?controlid=#url.controlid#&reportid=#url.reportid#"
	    html          = "No"
		show          = "#show#"
		tablewidth    = "98%"
		height        = "95%"
		listquery     = "#myquery#"
		listkey       = "account"
		listorder     = "Created"
		listorderdir  = "DESC"
		headercolor   = "ffffff"
		filtershow    = "Yes"
		ajax          = "1"
		ExcelShow     = "Yes"
		allowgrouping = "No"
		listlayout    = "#fields#"
		drillmode     = "tab"
		drillargument = "960;1030;false;true"	
		drilltemplate = "System/Access/User/Audit/ListingReportDetail.cfm?drillid="
		drillkey      = "DistributionId"
		deletetable   = "UserReportDistribution">
	
</cfoutput>	

