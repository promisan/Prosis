
<!--- configuration file --->
<cfoutput>

<cfsavecontent variable="myquery">
		SELECT  Created,
		        DistributionEMail, 
				DistributionSubject,
				DistributionCategory,
				FunctionName, 
				SystemModule,
				LayoutName,
				FileFormat,
				DATEDIFF(ms, PreparationStart, PreparationEnd) AS Duration,
				OfficerUserId,
				OfficerFirstName+' '+OfficerLastName as Contact,
				DistributionId
		FROM    UserReportDistribution
		WHERE   Account = '#SESSION.acc#' 	
		AND     DistributionStatus = '1'			 		
</cfsavecontent>

<cfset fields=ArrayNew(1)>

			
<cfset fields[1] = {label   = "Module",               
					field   = "SystemModule",
					search  = "text"}>
									
<cfset fields[2] = {label   = "Name",               
					field   = "FunctionName",
					search  = "text"}>

<cfset fields[3] = {label      = "Date",    					
					field      = "Created",
					formatted  = "dateformat(Created,CLIENT.DateFormatShow)",
					search     = "date"}>
					
<cfset fields[4] = {label      = "Time",   					
					field      = "Created",
					formatted  = "timeformat(Created,'HH:MM')"}>			

<cfset fields[5] = {label       = "MS",                    
					field       = "Duration",
					search      = "number",
					searchfield = "DATEDIFF(ms, PreparationStart, PreparationEnd)"}>

					
<cfset fields[6] = {label   = "Layout",               
					field   = "LayoutName",
					search  = "text"}>
					
<cfset fields[7] = {label   = "Format", 					
					field   = "FileFormat",
					filtermode="2",
					search  = "text"}>					
				
<cfset fields[8] = {label   = "Mode", 					
					field   = "DistributionCategory"}>		
														
<cf_listing
    header        = "<b><font size='2'>Report Distribution Log</font></b>"
    box           = "setting"
	link          = "#SESSION.root#/Portal/Preferences/ListingReport.cfm"
    html          = "No"	
	tablewidth    = "100%"	
	listquery     = "#myquery#"
	listkey       = "account"
	listorder     = "Created"
	listorderdir  = "DESC"
	filtershow    = "Yes"	
	headercolor   = "ffffff"
	listlayout    = "#fields#"
	drillmode     = "securewindow"
	drillargument = "910;1030;false;false"	
	drilltemplate = "System/Access/User/Audit/ListingReportDetail.cfm?drillid="
	drillkey      = "DistributionId"
	deletetable   = "UserReportDistribution">
	
	
	
</cfoutput>	
