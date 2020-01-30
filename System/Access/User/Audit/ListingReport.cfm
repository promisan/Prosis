
<cf_listingscript>
<cf_screentop html="No" jquery="Yes">
<!--- clear attachments if no longer needed as recorded in the database --->

<cfset No = round(Rand()*10)>

<!--- check only once in a while --->

<cfif No eq "1">
	
	<cfdirectory action="LIST"
	       directory="#SESSION.rootDocumentPath#\CFReports\#SESSION.acc#"
	       name="GetFiles"
	       type="file"
	       listinfo="name">
				 
	<cfloop query="getfiles">
		
		<cfset distrib = "">
					
		<cfset row = 0>		
		<cfloop index="itm" list="#name#" delimiters=".">
		    
			<cfif row eq "0">
				<cfset distrib = "#itm#">			
			</cfif>
			<cfset row = 1>
			
		</cfloop>
		
		<cfif distrib neq "">
		
			<cftry>
		
			<cfquery name="Check" 
			 datasource="AppsSystem"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT * 
			 FROM   UserReportDistribution
			 WHERE  DistributionId = '#distrib#'		 
			 </cfquery>
			 
			 <cfif check.recordcount eq "0">
		
		   		<cffile action="DELETE" 
		           file="#SESSION.rootDocumentPath#\CFReports\#SESSION.acc#\#name#">
				   
			 </cfif>	
			 
			 <cfcatch>
			 
				 <cffile action="DELETE" 
			        file="#SESSION.rootDocumentPath#\CFReports\#SESSION.acc#\#name#">
			 
			 </cfcatch>
			 
			 </cftry>
		 
		 </cfif>   
	
	</cfloop>			 

</cfif>

<!--- configuration file --->

<cfoutput>

<cfsavecontent variable="myquery">
	SELECT   TOP 200 Created,
	         DistributionEMail, 
			 DistributionSubject,
			 DistributionCategory, 
			 LayoutName,
			 FileFormat,
			 DATEDIFF(ms, PreparationStart, PreparationEnd) AS Duration,
			 OfficerUserId,
			 OfficerFirstName+' '+OfficerLastName as Contact,
			 DistributionId
	FROM     UserReportDistribution
	WHERE    Account = '#url.id#' 	
	AND      Created > getDate()-30 
	ORDER BY Created DESC				 		
</cfsavecontent>

<cfset fields=ArrayNew(1)>

<cfset fields[1] = {label      = "Date",    					
					field      = "Created",
					formatted  = "dateformat(Created,CLIENT.DateFormatShow)",
					search     = "date"}>
					
<cfset fields[2] = {label      = "Time",    					
					field      = "Created",
					formatted  = "timeformat(Created,'HH:MM')"}>			

<cfset fields[3] = {label       = "MS",                     
					field       = "Duration",
					search      = "number",
					searchfield = "DATEDIFF(ms, PreparationStart, PreparationEnd)"}>
					
<cfset fields[4] = {label   = "Layout",                    
					field   = "LayoutName",
					search  = "text"}>
					
<cfset fields[5] = {label   = "Format", 					
					field   = "FileFormat",
					search  = "text"}>
					
<cfset fields[6] = {label   = "Address", 					
					field   = "DistributionEMail",
					search  = "text"}>
					
<cfset fields[7] = {label   = "Mode", 					
					field   = "DistributionCategory",
					search  = "text"}>						
									
<cf_listing
    header        = "Report Distribution"
    box           = "userdetail"
	link          = "#SESSION.root#/System/Access/User/Audit/ListingReport.cfm?id=#url.id#"
    html          = "No"	
	tablewidth    = "100%"
	tableheight   = "100%"
	listquery     = "#myquery#"
	listkey       = "account"
	listgroup     = "LayoutName"	
	listorder     = "Created"
	listorderdir  = "DESC"
	headercolor   = "ffffff"
	allowgrouping = "No"
	listlayout    = "#fields#"
	filtershow    = "Hide"
	excelshow     = "Yes"
	drillmode     = "window"
	drillargument = "900;900;false;false"	
	drilltemplate = "System/Access/User/Audit/ListingReportDetail.cfm?drillid="
	drillkey      = "DistributionId"
	deletetable   = "UserReportDistribution">
	
</cfoutput>	
