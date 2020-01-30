<CF_LISTINGSCRIPT>
<!--- get overtime that had my involvement --->

<cf_wfpending entityCode="EntOvertime" table="#SESSION.acc#wfOvertime">

<cfoutput>
<cfsavecontent variable="myquery">
SELECT     P.PersonNo, 
           P.IndexNo, 
		   P.LastName, 
		   P.FirstName, 
		   P.MiddleName, 
		   P.Gender, 
		   P.Nationality, 
		   (SELECT ActionDescriptionDue V
		    FROM   UserQuery.dbo.#SESSION.acc#wfOvertime V WHERE V.ObjectkeyValue4 = OT.OvertimeId) as ActionDue,
		   OT.OvertimePeriodStart, 
		   OT.OvertimePeriodEnd, 
		   <!--- format the time --->
           LTRIM(CASE WHEN OvertimeMinutes < '10' THEN STR(OT.OvertimeHours) + ':0' + LTRIM(STR(OvertimeMinutes)) ELSE STR(OT.OvertimeHours) 
                      + ':' + LTRIM(STR(OvertimeMinutes)) END) AS Overtime, 
		   OT.Status
FROM       PersonOvertime OT INNER JOIN
                      Employee.dbo.Person P ON OT.PersonNo = P.PersonNo
					  
<!--- only invoice that had my involvement --->					  
WHERE     (OT.OvertimeId IN
                (SELECT  ObjectKeyValue4
                 FROM    Organization.dbo.OrganizationObject O, Organization.dbo.OrganizationObjectAction OA
                 WHERE   O.ObjectId = OA.ObjectId AND OA.OfficerUserId = '#SESSION.acc#' AND O.ObjectKeyValue4 = OT.OvertimeId)				 
)
</cfsavecontent>
</cfoutput>
	
<cfparam name="client.header" default="">

<cfset fields=ArrayNew(1)>
				
<cfset fields[1] = {label   = "Last name",                  
					field   = "LastName",
					filtermode = "0",
					search  = "text"}>				
					
<cfset fields[2] = {label   = "First name",                  
					field   = "FirstName",
					filtermode = "0",
					search  = "text"}>					

<cfset fields[3] = {label   = "IndexNo",                  
					field   = "IndexNo",
					search  = "text"}>		
						
<cfset fields[4] = {label   = "Sex", 					
					field   = "Gender",					
					filtermode = "2",    
					align = "center",
					search  = "text"}>		
					
<cfset fields[5] = {label      = "Nat",  					
					field      = "Nationality",
					filtermode = "2",					
					search     = "text"}>								
							
<cfset fields[6] = {label      = "Action", 					
					field      = "ActionDue",
					search     = "text"}>					
									
<cfset fields[7] = {label      = "Period From",					
					field      = "OvertimePeriodStart",
					search     = "date",
					align = "center",
					formatted  = "dateformat(OvertimePeriodStart,'#CLIENT.DateFormatShow#')"}>	
					
<cfset fields[8] = {label      = "Period Until",  					
					field      = "OvertimePeriodEnd",
					align = "center",
					formatted  = "dateformat(OvertimePeriodEnd,'#CLIENT.DateFormatShow#')"}>		
					
<cfset fields[9] = {label      = "Time [HH:MM]",  					
					field      = "Overtime",
					align      = "center",
					formatted  = "dateformat(OvertimePeriodEnd,'#CLIENT.DateFormatShow#')"}>	
			

<cf_listing
    header        = "Overtime"
    box           = "overtime"
	link          = "#SESSION.root#/Payroll/Application/Overtime/OvertimeListingAction.cfm"
    html          = "No"
	show          = "40"
	datasource    = "AppsPayroll"
	listquery     = "#myquery#"
	listkey       = "personNo"
	listorder     = "LastName"
	listorderdir  = "ASC"
	headercolor   = "ffffff"
	listlayout    = "#fields#"
	filterShow    = "Yes"
	excelShow     = "Yes"
	drillmode     = "window"
	drillargument = "540;600;false;false"	
	drilltemplate = "Staffing/Application/Employee/PersonView.cfm?id="
	drillkey      = "PersonNo">