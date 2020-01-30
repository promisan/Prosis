
<!--- configuration file --->
<cfoutput>

<cfsavecontent variable="myquery">
	SELECT  TOP 8 Created,
	        DistributionEMail, 
			DistributionSubject,
			DistributionCategory, 
			LayoutName,
			FileFormat,
			HostName,
			DATEDIFF(ms, PreparationStart, PreparationEnd) AS Duration,
			OfficerUserId,
			OfficerFirstName+' '+OfficerLastName as Contact,
			DistributionId
	FROM    UserReportDistribution
	WHERE   ReportId = '#url.id#'				 				
</cfsavecontent>

<cfset fields=ArrayNew(1)>

<cfset fields[1] = {label       = "Date",    
					width       = "10%", 
					field       = "Created",
					formatted   = "dateformat(Created,CLIENT.DateFormatShow)",
					search      = "date"}>
					
<cfset fields[2] = {label       = "Time",    
					width       = "8%", 
					field       = "Created",
					search      = "date",
					formatted   = "timeformat(Created,'HH:MM')"}>			

<cfset fields[3] = {label       = "MS", 
                    width       = "5%", 
					field       = "Duration",
					search      = "number",
					searchfield = "DATEDIFF(ms, PreparationStart, PreparationEnd)"}>
					
<cfset fields[4] = {label       = "HostName", 
                    width       = "30%", 
					field       = "HostName",
					search      = "text"}>
					
<cfset fields[5] = {label       = "Format", 
					width       = "8%", 
					field       = "FileFormat",
					search      = "text"}>
					
<cfset fields[6] = {label       = "Address", 
					width       = "26%", 
					field       = "DistributionEMail",
					search      = "text"}>
					
<cfset fields[7] = {label       = "Mode", 
					width       = "20%", 
					field       = "DistributionCategory",
					search      = "text"}>						

<cf_listing
    headershow    = "No"
	header        = ""
    box           = "i#url.row#"
	link          = "#SESSION.root#/System/Modules/Subscription/ListingDistributionDetail.cfm?row=#url.row#&id=#url.id#"
    html          = "No"	
	tablewidth    = "98%"
	listquery     = "#myquery#"
	listkey       = "account"
	listorder     = "Created"
	listorderdir  = "DESC"
	headercolor   = "ffffff"
	filtershow    = "No"
	allowgrouping = "No"
	listlayout    = "#fields#"
	drillmode     = "window"
	drillargument = "890;#client.widthfull-90#;false;false"	
	drilltemplate = "System/Access/User/Audit/ListingReportDetail.cfm?drillid="
	drillkey      = "DistributionId"
	datasource    = "appsSystem"
	deletetable   = "System.dbo.UserReportDistribution">
		
</cfoutput>	