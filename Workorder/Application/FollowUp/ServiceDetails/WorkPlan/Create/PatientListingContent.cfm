<cfparam name="url.date" default="#DateFormat(now(), CLIENT.DateFormatShow)#">  
	
<cfoutput>
<cfsavecontent variable="myquery">

    SELECT TOP 30 *
	FROM (

	SELECT   A.PersonNo, 
	         CustomerId,
	         EmployeeNo, 
			 IndexNo, 
			 LoginAccount, 
			 Salutation, 
			 CASE WHEN LastName2 is NULL THEN LastName ELSE LastName+' '+LastName2 END as LastName,						
			 MaidenName, 
			 CASE WHEN MiddleName is NULL THEN FirstName ELSE FirstName+' '+MiddleName END as FirstName,

			 (
			 	LTRIM(RTRIM(ISNULL(LastName,'') + ' ' + ISNULL(LastName2,'') + ' ' + ISNULL(MaidenName,''))) 
			 	+ ', ' 
			 	+ LTRIM(RTRIM(ISNULL(FirstName,'') + ' ' + ISNULL(MiddleName,'') + ' ' + ISNULL(MiddleName2,'')))
			 ) as FullName,	

			 MiddleName2, 
			 BirthCity, 
			 BirthNationality, 
             DOB, 
			 Gender, 
			 Nationality, 
			 A.EmailAddress,
			 C.CustomerName, 
			 ISNULL(C.Reference,'C/F')Reference,
			  (
			  SELECT   MAX(WLA.DateTimePlanning) AS LastSchedule
			  FROM     Workorder.dbo.WorkOrder W INNER JOIN
                       Workorder.dbo.WorkOrderLineAction WLA ON W.WorkOrderId = WLA.WorkOrderId INNER JOIN
                       Workorder.dbo.WorkPlanDetail WPD ON WLA.WorkActionId = WPD.WorkActionId
			  WHERE    W.ActionStatus <> '9' 
			  AND      WLA.ActionStatus <> '9'
			  AND      W.CustomerId = C.CustomerId ) as lastAppointment,			  
			 Source, 
			 SourceKey, 
			 DocumentReference,
			 C.Created
			  
	
	<!----  
	FROM     Applicant A, Workorder.dbo.Customer C	
	WHERE    A.PersonNo = C.PersonNo
	------>
	FROM     Applicant A
			 INNER JOIN Workorder.dbo.Customer C
				ON    A.PersonNo = C.PersonNo
				AND   C.Mission = '#url.mission#'
				AND   A.LastName > ''
				
	
	<!---  AND      A.ApplicantClass = '3' --->
	
	) as D
	WHERE 1=1
	-- condition
</cfsavecontent>
</cfoutput>

<cfset itm = 0>

<cfset fields=ArrayNew(1)>
		
	   <cf_tl id="Name" var="1">		
		<cfset itm = itm + 1>						
		<cfset fields[itm] = {label        	= "#lt_text#", 					
						     field         	= "FullName",											
						     display       	= "Yes",
							 functionscript	= "ShowCandidate",
							 functionfield 	= "PersonNo",
						     search        	= "text",
							 filtermode     = "4"}>	
			
		<cf_tl id="Gender" var="1">				
	    <cfset itm = itm + 1>		
		<cfset fields[itm] = {labelfilter   = "#lt_text#", 					
							 label      	= "S",
						     field          = "Gender",											
						     display        = "Yes",
							 width          = "7",
						     search         = "text",
							 filtermode     = "3"}>		
						 
		<cf_tl id="Nationality" var="1">				
	    <cfset itm = itm + 1>		
		<cfset fields[itm] = {labelfilter  	= "#lt_text#", 	
						 	label           = "CT", 				
						     field          = "Nationality",											
						     display        = "Yes",
							 width          = "10",
						     search         = "text",
							 filtermode     = "2"}>			
						 
		<cf_tl id="PersonId" var="1">				
	    <cfset itm = itm + 1>		
		<cfset fields[itm] = {label         = "#lt_text#", 					
						     field          = "PersonNo",		
							 width          = "10",									
						     display        = "Yes",
						     search         = "text"}>		
						 
		<cf_tl id="File" var="1">				
	    <cfset itm = itm + 1>		
		<cfset fields[itm] = {label       = "#lt_text#", 					
					     field            = "DocumentReference",											
					     display          = "Yes",
					     search           = "text",
						 filtermode       = "4"}>						 				 						 					 
				

		<cf_tl id="DOB" var="1">								
		<cfset itm = itm + 1>					
		<cfset fields[itm] = {label       = "#lt_text#", 					
					     field            = "DOB",											
					     display          = "Yes",
						 formatted        = "dateformat(dob,CLIENT.DateFormatShow)"}>		
						 
		<cf_tl id="Action" var="1">								
		<cfset itm = itm + 1>					
		<cfset fields[itm] = {label       = "#lt_text#", 					
					     field            = "LastAppointment",											
					     display          = "Yes",
						 formatted        = "dateformat(LastAppointment,CLIENT.DateFormatShow)"}>		
						 					 	
		<cf_tl id="Tax ID" var="1">								
		<cfset itm = itm + 1>					
		<cfset fields[itm] = {label       = "#lt_text#", 					
					     field            = "Reference",											
					     display          = "Yes",
						 search           = "text",
						 filtermode       = "4"}>	

		<cf_tl id="Invoiced to" var="1">								
		<cfset itm = itm + 1>					
		<cfset fields[itm] = {label       = "#lt_text#", 					
					     field            = "CustomerName",											
					     display          = "Yes",
						 search           = "text",
						 filtermode       = "4"}>	
	
<cfset menu=ArrayNew(1)>	
	
<cfinvoke component = "Service.Access"  
	   method           = "WorkorderProcessor" 	   
	   returnvariable   = "access"
	   Mission          = "#url.mission#">	     
	
<cfif access eq "ALL">		
																					
	<cf_tl id="Add Patient" var="1">
	<cfset menu[1] = {label = "#lt_text#",icon = "insert.gif",	script = "patientadd('#url.mission#','#url.orgunit#','#url.personno#','#url.date#')"}>		
					
<cfelse>	
	
	<cfset menu = "">					  
				
</cfif>		
	
<cfset sorting = "LastName"> 
	
<!--- embed|window|dialogajax|dialog|standard --->
<cf_listing
	    header        = "patient"
	    box           = "patient"
		link          = "#SESSION.root#/WorkOrder/Application/Medical/ServiceDetails/Workplan/Create/PatientListingContent.cfm?mission=#url.mission#&orgunit=#url.orgunit#&personno=#url.personno#&date=#url.date#&customerid="
	    html          = "No"		
		tableheight   = "100%"
		tablewidth    = "100%"
		datasource    = "AppsSelection"
		listquery     = "#myquery#"
		listorderfield = "#sorting#"
		listorder      = "#sorting#"
		listorderdir   = "ASC"
		headercolor   = "ffffff"
		show          = "30"		
		menu          = "#menu#"
		filtershow    = "Yes"
		excelshow     = "Yes" 		
		listlayout    = "#fields#"
		drillmode     = "top" 
		drillargument = "#client.height-90#;#client.widthfull-50#;false;false"	
		drilltemplate = "WorkOrder/Application/WorkOrder/Create/WorkOrderAdd.cfm?context=schedule&mission=#url.mission#&orgunit=#url.orgunit#&personno=#url.personno#&date=#url.date#&customerid="
		drillkey      = "CustomerId"
		drillbox      = "addpatient"
		allowgrouping = "No">	
		
		
