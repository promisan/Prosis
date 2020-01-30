

<cfoutput>

<cfparam name="url.mode" default="current">

<!--- all action --->

	<!--- the table by design WorkOrderLineSchedulePosition only reflects the current situation onwards --->
	
	
	<CF_DateConvert Value="#dateformat(now(),client.dateformatshow)#">
	<cfset DTE = dateValue>	

	<cfsavecontent variable="myquery">	
	
	      SELECT   O.OrgUnitCode, 
		           O.OrgUnit, 
				   O.OrgUnitName, 
				   Pos.FunctionNo,
				   Pos.SourcePostNumber,
				   Pos.FunctionDescription,
				   Pos.PostGrade,
				   Pos.PositionNo,
				   Pos.OrgUnitOperational,
				   WS.Code, 
				   WS.Description, 
				   PA.DateEffective, 
				   PA.DateExpiration, 
				   P.PersonNo, 
				   P.IndexNo, 
				   P.FullName,
				   
				   
				   <!--- atttention I should also validate if the line is valid --->
				   
				   (SELECT count(*) 
				    FROM   WorkOrder.dbo.WorkOrderLineSchedulePosition WP
					WHERE  ScheduleId IN (SELECT ScheduleId 
					                      FROM   WorkOrder.dbo.WorkOrderLineSchedule 
										  WHERE  ScheduleId = WP.ScheduleId 
										  AND    WorkOrderId = '#url.workorderid#' 
										  AND    ActionStatus = '1')
					AND    PositionNo = Pos.PositionNo) as Tasks,
					
					<!--- atttention I should also validate if the line is valid --->
				   
				   (SELECT count(*) 
				    FROM   PositionWorkOrder PW
					WHERE  PW.PositionNo = Pos.PositionNo
					AND    PW.WorkOrderId = '#url.workorderid#' 
					) as SupportStaff,
					
				   MIN(CalendarDate) as CalendarDate             
				   
		  FROM     Person AS P INNER JOIN
                   PersonAssignment AS PA ON P.PersonNo = PA.PersonNo RIGHT OUTER JOIN
                   WorkSchedulePosition AS WSP INNER JOIN
                   WorkSchedule AS WS ON WSP.WorkSchedule = WS.Code INNER JOIN
                   Position AS Pos ON WSP.PositionNo = Pos.PositionNo INNER JOIN
                   Organization.dbo.Organization AS O ON Pos.OrgUnitOperational = O.OrgUnit ON PA.PositionNo = WSP.PositionNo AND PA.AssignmentStatus IN ('0', '1') AND 
                   PA.Incumbency > 0 AND PA.DateEffective <= #dte# AND PA.DateExpiration >= #dte#      
		 
		  WHERE    WSP.CalendarDate >= #dte# and WSP.CalendarDate <= #dte#+30
		  
			AND    Pos.OrgUnitOperational IN
                          (SELECT   OrgUnit
                            FROM    WorkOrder.dbo.WorkOrderImplementer
                            WHERE   OrgUnit     = OrgUnitOperational
							AND     WorkOrderId = '#url.workorderid#')
							
		 GROUP BY  O.OrgUnitCode, 
		           O.OrgUnit, 
				   O.OrgUnitName, 
				   Pos.FunctionNo,
				   Pos.SourcePostNumber,
				   Pos.FunctionDescription,
				   Pos.PostGrade,
				   Pos.PositionNo,
				   Pos.OrgUnitOperational,
				   WS.Code, 
				   WS.Description, 
				   PA.DateEffective, 
				   PA.DateExpiration, 
				   P.PersonNo, 
				   P.IndexNo, 
				   P.FullName  			
		
	</cfsavecontent>	
	
</cfoutput>				
		
<cfparam name="client.header" default="">

<cfset fields=ArrayNew(1)>
				
<cfset fields[1] = {label           = "OrgUnit",                  
					field           = "OrgUnitName",
					filtermode      = "2",
					search          = "text"}>				
					
<cfset fields[2] = {label           = "Position",                  
					field           = "SourcePostNumber",					
					display         = "Yes",
					search          = "text"}>					

<cfset fields[3] = {label           = "Function",                  
					field           = "FunctionDescription",
					alias           = "Pos",
					searchfield     = "FunctionDescription",
					searchalias     = "Pos",	
					filtermode      = "2",
					search          = "text"}>						
					
<cfset fields[4] = {label           = "Grade",  					
					field           = "PostGrade",
					filtermode      = "2",
					search          = "text"}>														
						
<cfset fields[5] = {label           = "Schedule",  					
					field           = "Description",		
					searchfield     = "Description",
					searchalias     = "WS",						
					filtermode      = "2",
					search          = "text"}>		
					
<cfset fields[6] = {label           = "Valid",  					
					field           = "Calendardate",
					formatted       = "dateformat(CalendarDate,CLIENT.DateFormatShow)"}>	
					
<cfset fields[7] = {label           = "Sup",  
                    align           = "center",					
					field           = "SupportStaff",
					formatted       = "Rating",
					ratinglist      = "0=White,1=Green"}>								
					
<cfset fields[8] = {label           = "Tasks",  
                    align           = "center",					
					field           = "Tasks"}>											
					
<cfset fields[9] = {label           = "NIT",  					
					field           = "IndexNo",		
					functionscript  = "EditPerson",
					functionfield   = "PersonNo",					
					searchalias     = "P",	
					search          = "text"}>									

			
<cfset fields[10] = {label           = "Employee",  					
					field           = "FullName",		
					functionscript  = "EditPerson",
					functionfield   = "PersonNo",					
					searchalias     = "P",	
					search          = "text"}>						
					
<!---
<cfset fields[10] = {label          = "access",  					
					field           = "AccessLevel",
					isAccess        = "Yes",
					display         = "No"}>						
					--->
														
<cfset fields[11] = {label          = "id",  					
					field           = "PersonNo",
					isKey           = "No",
					display         = "No"}>							
										
<cfset fields[12] = {label          = "id",  					
					field           = "PositionNo",
					isKey           = "Yes",
					display         = "No"}>		
			
			
<cf_listing
    header            = "Positions"
    box               = "Positions"
	link              = "#SESSION.root#/WorkOrder/Application/WorkOrder/WorkForce/PositionListingContent.cfm?workorderid=#url.workorderid#&systemfunctionid=#url.systemfunctionid#"
    html              = "No"
	show              = "40"
	datasource        = "AppsEmployee"
	listquery         = "#myquery#"	
	listgroup         = "Description"
	listgroupfield    = "Description"
	listgroupdir      = "ASC"	
	listorder         = "SourcePostNumber"	
	listorderdir      = "ASC"
	headercolor       = "ffffff"
	listlayout        = "#fields#"
	filterShow        = "Yes"
	excelShow         = "Yes"	
	drillmode         = "window"
	drillargument     = "950;1130;false;false"	
	drilltemplate     = "Staffing/Application/Position/PositionParent/PositionView.cfm?drillid="	
	drillstring       = "">
						  					  