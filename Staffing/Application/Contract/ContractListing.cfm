<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<!--- 

1. define the selection date from the mandate
2. show people
--->

<cfparam name="url.mission"    default="">
<cfparam name="url.header"     default="0">
<cfparam name="url.mandateno"  default="">
<cfparam name="url.id"         default="par">
<cfparam name="url.year"       default="">
<cfparam name="url.month"      default="">
<cfparam name="url.expiration" default="0">
<cfparam name="url.systemfunctionid" default="">

<cfif url.header eq "1">
	<cf_screentop jquery="Yes" html="No">
	<cf_listingscript>
</cfif>

<cfif url.year eq "">

	<cfquery name="Mandate" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_Mandate
		WHERE  Mission   = '#url.Mission#'
		AND    MandateNo = '#url.MandateNo#'
	</cfquery>

	<cfif mandate.dateexpiration gte now()>
	   <cfset eff = dateformat(now(),"yyyymmdd")>  
	   <cfset exp = dateformat(now(),"yyyymmdd")>  
	<cfelse>
	   <cfset eff = dateformat(Mandate.DateExpiration,"yyyymmdd")>
	   <cfset exp = dateformat(Mandate.DateExpiration,"YYYYmmdd")>
	</cfif>
	
<cfelse>	

	 <cfset date = "01/#url.month#/#url.year#">
	 <CF_DateConvert Value="#date#">
	 <cfset eff = dateformat(datevalue,"yyyymmdd")> 
	 
	 <cfset date = "#daysInMonth(dateValue)#/#url.month#/#url.year#"> 
	
	 <CF_DateConvert Value="#date#">	 	 
	 <cfset exp = dateformat(datevalue,"yyyymmdd")>  
	
</cfif>	

<cfoutput>

	<cfsavecontent variable="myquery">
	
	SELECT * --,DateExpiration
	FROM (
	
	SELECT     PC.PersonNo, 
	           P.FullName,
			   P.LastName,
			   P.FirstName,
			   P.Nationality,
			   P.BirthDate,
			   P.Gender,
			   P.IndexNo,
			   R.PostOrder,
			   (CASE WHEN EnforceFinalPay = 1 THEN 'Final' ELSE 'Normal' END) as PayrollMode,
			   PC.ServiceLocation,
			   PL.LocationDescription,
	           PC.DateEffective, 
			   PC.DateExpiration, 
			   (SELECT Left(Description,20) FROM Ref_AppointmentStatus WHERE Code = PC.AppointmentStatus) as AppointmentStatus,				  
			   (SELECT Description FROM Ref_ContractType WHERE ContractType = PC.ContractType) as ContractType,			  
			   PC.SalarySchedule,
			   SSC.ScheduleDescription, 
			   PC.ContractLevel, 
			   PC.ContractStep, 
			   PC.ContractTime,
	           PC.ActionStatus, 
			   PC.ReviewPanel, 
			   PC.StepIncreaseDate, 
			   PC.PersonnelActionNo,
			   <!---
			   CTD.ContractTimeDesc,
			   --->
			   STR(
				    (SELECT count(DISTINCT PA.PersonNo)
					FROM   PersonAssignment AS PA INNER JOIN
				    	   Position AS POS ON PA.PositionNo = POS.PositionNo
				    WHERE  POS.Mission = '#url.mission#'
					AND    PA.DateExpiration >= '#eff#' AND PA.DateEffective <= '#exp#'  
				    AND    PA.AssignmentStatus IN ('0','1')
					AND    PA.PersonNo = P.PersonNo
					AND    PA.Incumbency > 0
					AND    PA.AssignmentClass = 'Regular'
				    )) as Assignment
				
	FROM       Person P INNER JOIN 
	           PersonContract PC ON P.PersonNo = PC.PersonNo INNER JOIN
	           Ref_PostGrade AS R ON PC.ContractLevel = R.PostGrade INNER JOIN 
			   <!--- masking already the alias for the Description as these two fields will be needed in the Filter, CF_Listing must know which one the search refers as we can not set ALIAS.FieldName --->
    		   (SELECT LocationCode, Description as LocationDescription FROM Payroll.dbo.Ref_PayrollLocation) AS PL ON PL.LocationCode = PC.ServiceLocation INNER JOIN 
			   (SELECT SalarySchedule, Description as ScheduleDescription FROM Payroll.dbo.SalarySchedule) as SSC ON SSC.SalarySchedule = PC.SalarySchedule
			   <cfif url.id eq "par">
			     AND R.PostGradeParent = '#url.id1#'
			   <cfelse>
			     AND PC.SalarySchedule = '#url.id1#'			 
			   </cfif>
			   
			   <!---
			   INNER JOIN ( SELECT CASE WHEN PC1.ContractTime < '100' THEN 'Part-Time Contract' ELSE 'Full-Time Contract' END AS ContractTimeDesc, PC1.ContractId
			   								FROM Employee.dbo.PersonContract PC1
			   				) as CTD
							ON CTD.ContractId = PC.ContractID
							--->

							
			   
	WHERE 	   PC.ActionStatus != '9'	
	
	AND        (    PC.Mission = '#url.mission#'
		 
		      	<!--- NY provision only --->
				  OR  PC.PersonNo IN
			          		 (SELECT PA.PersonNo
				              FROM   PersonAssignment AS PA INNER JOIN
			    	                 Position AS P ON PA.PositionNo = P.PositionNo
			        	      WHERE  P.Mission = '#url.mission#'
							  AND    PA.DateExpiration >= '#eff#' AND PA.DateEffective <= '#exp#'  
							  AND    PA.AssignmentStatus IN ('0','1')
							  )
        		)		   
			   
	<cfif url.expiration eq "0">
			   
		 AND        PC.DateEffective <= '#exp#'
		 AND       (PC.DateExpiration IS NULL OR PC.DateExpiration >= '#eff#')  
				
	<cfelseif url.expiration eq "1">
	
		 AND        (PC.DateExpiration >= '#eff#' and PC.DateExpiration <= '#exp#') 
		
		 AND        PC.PersonNo NOT IN
                    	      (SELECT     PersonNo
	                            FROM      PersonContract
    	                        WHERE     PersonNo       = PC.PersonNo 
								AND       Mission        = PC.Mission 
								AND       SalarySchedule = PC.SalarySchedule 
								AND       ActionStatus != '9' 
								AND       (DateExpiration IS NULL OR DateExpiration > '#exp#')
							  )
							  
	<cfelseif url.expiration eq "2">
	
		 AND     PC.DateEffective <= '#exp#'
		 AND     (PC.DateExpiration IS NULL OR PC.DateExpiration >= '#eff#') 
		  
		 AND     PC.PersonNo NOT IN (SELECT PA.PersonNo
								FROM   PersonAssignment AS PA INNER JOIN
							    	   Position AS POS ON PA.PositionNo = POS.PositionNo
							    WHERE  POS.Mission = '#url.mission#'
								AND    PA.DateExpiration >= '#eff#' AND PA.DateEffective <= '#exp#'  
							    AND    PA.AssignmentStatus IN ('0','1')
								AND    PA.PersonNo = P.PersonNo
								AND    PA.Incumbency > 0
								AND    PA.AssignmentClass = 'Regular'
							    ) 
		 
	
	</cfif>		
	
	) as B
	WHERE 1=1
	-- condition
				 
	</cfsavecontent>	
	
</cfoutput>				
		
<cfparam name="client.header" default="">

<cfset fields=ArrayNew(1)>

<cfset itm = 0>
					
<cfset itm = itm+1>		
<cf_tl id="Last name" var="1">				
<cfset fields[itm] = {label       = "#lt_text#",                  
					field         = "LastName",
					filtermode    = "0",
					search        = "text"}>				

<cfset itm = itm+1>		
<cf_tl id="First name" var="1">					
<cfset fields[itm] = {label       = "#lt_text#",                  
					field         = "FirstName",
					filtermode    = "0",
					search        = "text"}>					

<cfset itm = itm+1>		
<cf_tl id="IndexNo" var="1">		
<cfset fields[itm] = {label       = "#lt_text#",                  
					field         = "IndexNo",
					search        = "text"}>		
					
<cfset itm = itm+1>								
<cfset fields[itm] = {label       = "S", 		
                    labelfilter   = "Gender",					
					field         = "Gender",		
					width         = "3",			
					filtermode    = "2",   
					column        = "common", 
					align         = "center",
					search        = "text"}>		

<cfset itm = itm+1>		
<cf_tl id="Schedule" var="1">						
<cfset fields[itm] = {label       = "#lt_text#",  					
					field         = "ScheduleDescription",
					filtermode    = "3",
					searchfield   = "ScheduleDescription",
					fieldsort     = "ScheduleDescription",
					search        = "text"}>								

<cfset itm = itm+1>
<cf_tl id="Grade" var="1">								
<cfset fields[itm] = {label       = "#lt_text#",  					
					field         = "ContractLevel",
					displayfilter = "Yes",
					filtermode    = "3",
					column        = "common",
					fieldsort     = "PostOrder",
					search        = "text"}>

<cfset itm = itm+1>							
<cf_tl id="Step" var="1">	
<cfset fields[itm] = {label      = "#lt_text#",  					
					field        = "ContractStep"}>	

<cfset itm = itm+1>							
<cf_tl id="Time" var="1">	
<cfset fields[itm] = {label      = "#lt_text#",  					
					  field      = "ContractTime",
					  filtermode = "3",
					  search     = "text"}>					

<cfset itm = itm+1>		
<cf_tl id="Appointment" var="1">									
<cfset fields[itm] = {label      = "#lt_text#", 					
					field        = "AppointmentStatus",
					column       = "common",
					filtermode   = "2",
					search       = "text"}>	
					
<cfset itm = itm+1>		
<cf_tl id="Contract" var="1">									
<cfset fields[itm] = {label      = "#lt_text#", 					
					field        = "ContractType",
					filtermode   = "2",
					column       = "common",
					search       = "text"}>	
										
<cfset itm = itm+1>
<cf_tl id="Location" var="1">											
<cfset fields[itm] = {label      = "#lt_text#", 					
					field        = "LocationDescription",
					filtermode   = "2",
					searchfield  = "LocationDescription",
					fieldsort    = "LocationDescription",
					search       = "text"}>	

<cfset itm = itm+1>		
<cfset fields[itm] = {label      = "A", 					
					field        = "Assignment",		
					width        = "3",
					filtermode   = "0",		
					align        = "center",
					search       = "text"}>	
					
					
<cfset itm = itm+1>		
<cf_tl id="Mode" var="1">									
<cfset fields[itm] = {label      = "#lt_text#", 					
					field        = "PayrollMode",
					search       = "text"}>																						

<cfset itm = itm+1>		
<cf_tl id="Effective" var="1">											
<cfset fields[itm] = {label      = "#lt_text#",					
					field        = "DateEffective",
					search       = "date",
					display      = "no",
					align        = "center",
					formatted    = "dateformat(DateEffective,'#CLIENT.DateFormatShow#')"}>	

<cfset itm = itm+1>	
<cf_tl id="Expiration" var="1">							
<cfset fields[itm] = {label    = "#lt_text#",  					
					field      = "DateExpiration",
					align      = "center",
					column     = "month",
					formatted  = "dateformat(DateExpiration,'#CLIENT.DateFormatShow#')"}>										

<table width="100%" height="100%"><tr><td style="padding:8px;width:100%;height:100%">	
	
	<cf_listing
		    header         = "Contract"
		    box            = "contract_#url.mission#_#url.id#"
			link           = "#SESSION.root#/Staffing/Application/Contract/ContractListing.cfm?systemfunctionid=#url.systemfunctionid#&header=#url.header#&mission=#url.mission#&mandateno=#url.mandateno#&id=#url.id#&id1=#url.id1#&year=#url.year#&month=#url.month#&expiration=#url.expiration#"
		    html           = "No"
			show           = "40"
			datasource     = "AppsEmployee"
			listquery      = "#myquery#"
			listkey        = "personNo"
			listgroup      = "Postorder"
			listgroupfield = "ContractLevel"
			listgroupdir   = "ASC"
			listorder      = "LastName"
			listorderdir   = "ASC"
			headercolor    = "ffffff"
			listlayout     = "#fields#"
			filterShow     = "Yes"
			excelShow      = "Yes"
			drillmode      = "tab"
			drillargument  = "940;1190;false;false"	
			drilltemplate  = "Staffing/Application/Employee/PersonView.cfm?id="
			drillkey       = "PersonNo">
	
</td></tr></table>		

					  