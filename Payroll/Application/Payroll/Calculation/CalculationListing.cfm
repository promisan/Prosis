<!--
    Copyright © 2025 Promisan

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

<cfparam name="URL.Mission"    default="">

<cfoutput> 

<!--- body --->


	<cfsavecontent variable="sqlbody">
	
	    SELECT * 
		FROM (
		
		
		SELECT       Processid,
					 ProcessNo, 
		             ProcessBatchId, 
					 ProcessClass, 
					 L.PersonNo, 
					 
					 (SELECT LastName+', '+FirstName
					  FROM   Employee.dbo.Person
					  WHERE  PersonNo = L.PersonNo) as Name,	
					  
					 (SELECT IndexNo
					  FROM   Employee.dbo.Person
					  WHERE  PersonNo = L.PersonNo) as IndexNo,	 				 										 
					  
					 (  SELECT count(*)
                        FROM   CalculationLogSettlementLine
						WHERE  ProcessNo = L.ProcessNo
						AND    ProcessBatchId = L.ProcessBatchId
						AND    PersonNo = '#url.id#' ) as Touched,								  
					  
		             L.Mission, 
					 L.SalarySchedule, 
					 RIGHT(CONVERT(varchar,L.PayrollStart,101),4)+'/'+LEFT(CONVERT(varchar,L.PayrollStart,101),2) as PayrollStart, 
					 L.Duration, 
					 L.ActionStatus, 
					 L.OfficerUserId, 
					 (L.OfficerLastName+', '+L.OfficerFirstName) as OfficerName, 
					 L.Created
		FROM         CalculationLog L 
		WHERE        L.PersonNo = '#url.id#' 
		AND          L.ActionStatus = '2'
		
		UNION 
		
		SELECT       ProcessId,
		             ProcessNo, 
		             ProcessBatchId, 
					 ProcessClass, 
					 L.PersonNo,
					 '[Full Schedule]' as Name,
					 '' as IndexNo, 		
					 (  SELECT count(*)
                        FROM   CalculationLogSettlementLine
						WHERE  ProcessNo = L.ProcessNo
						AND    ProcessBatchId = L.ProcessBatchId
						AND    PersonNo = '#url.id#' ) as Touched,					 				 										 
					  
		             L.Mission, 
					 L.SalarySchedule, 
					 RIGHT(CONVERT(varchar,L.PayrollStart,101),4)+'/'+LEFT(CONVERT(varchar,L.PayrollStart,101),2) as PayrollStart,  
					 L.Duration, 
					 L.ActionStatus, 
					 L.OfficerUserId, 
					  (L.OfficerLastName+', '+L.OfficerFirstName) as OfficerName,
					 L.Created
		FROM         CalculationLog L 
		WHERE        EXISTS (SELECT ProcessBatchId
		                     FROM   CalculationLogSettlementLine
							 WHERE  ProcessNo = L.ProcessNo
							 AND    ProcessBatchId = L.ProcessBatchId
							 AND    PersonNo = '#url.id#') 
		AND          L.PersonNo = ''	
		AND          L.ActionStatus = '2'				 
 		
				
		) as B
		
		
		WHERE        1=1	
	   
	</cfsavecontent>
	
</cfoutput>	

<!--- pass the view --->

<cfoutput> 

	<cfsavecontent variable="myquery">  
		#preserveSingleQuotes(sqlbody)#					
	</cfsavecontent>	
		  
</cfoutput>

<!--- show person, status processing color and filter on raise by me --->


<cfset fields=ArrayNew(1)>

<cfset itm = 0>

<cfset itm = itm+1>							
<cfset fields[itm] = {label       = "Process No",  					
					field         = "ProcessNo",
					filtermode    = "2",					
					search        = "number"}>	

<!---					
<cfset itm = itm+1>							
<cfset fields[itm] = {label       = "Class",  					
					field         = "ProcessClass"}>	
--->					
					
<cfset itm = itm+1>							
<cfset fields[itm] = {label       = "Entity",  					
                    labelfilter   = "Entity",
					field         = "Mission",	
					filtermode    = "2",								
					search        = "text"}>		
					
<cfset itm = itm+1>							
<cfset fields[itm] = {label       = "Schedule",  					
                    labelfilter   = "SalarySchedule",
					field         = "SalarySchedule",	
					filtermode    = "2",								
					search        = "text"}>	
					
<cfset itm = itm+1>							
<cfset fields[itm] = {label       = "Entitlement",  					
					field         = "PayrollStart",									
					search        = "text",
					filtermode     = "2"}>						
					
<cfset itm = itm+1>							
<cfset fields[itm] = {label       = "T",  					
                    labelfilter   = "Touched",
					field         = "Touched",	
					align         = "center",					
					width         = "5"}>						
					
					
<cfset itm = itm+1>						
<cfset fields[itm] = {label       = "Process Scope",                  
					field         = "Name",					
					filtermode    = "2",	
					search        = "text"}>			



<!---					
<cfset itm = itm+1>						
<cfset fields[itm] = {label       = "S", 	                    			
					field         = "Status",										 					
					align         = "center",
					formatted     = "Rating",
					display       = "1",
					ratinglist    = "0=Yellow,1=Yellow,3=green,5=purple,9=red"}>				
					
					
<cfset itm = itm+1>						
<cfset fields[itm] = {label       = "S", 	
                    LabelFilter   = "Status",				
					field         = "StatusName",					
					filtermode    = "2",    
					search        = "text",
					align         = "center",					
					display       = "0"}>	
					
--->																																		
				
		
<cfset itm = itm+1>							
<cfset fields[itm] = {label       = "Officer",  
                    labelfilter   = "Officer", 					
					field         = "OfficerName",
					filtermode    = "2",					
					search        = "text"}>
					
<cfset itm = itm+1>							
<cfset fields[itm] = {label       = "On",  					
					field         = "Created",
					align         = "center",										
					formatted     = "dateformat(Created,'#CLIENT.DateFormatShow#')"}>		
					
<cfset itm = itm+1>							
<cfset fields[itm] = {label       = "Hour",  					
					field         = "Created",
					align         = "center",										
					formatted     = "timeformat(Created,'HH:MM')"}>							
					
<cfset itm = itm+1>							
<cfset fields[itm] = {label       = "Dur(s)",  					
					field         = "Duration",
					align         = "center"}>											
					
			
<table width="100%" height="100%">
<tr><td style="padding:0px;width:100%;height:100%">	
	
	<cf_listing
		    header         = "Payroll"
		    box            = "Payroll"
			link           = "#SESSION.root#/Payroll/Application/Payroll/Calculation/CalculationListing.cfm?id=#url.id#&systemfunctionid=#url.systemfunctionid#"
		    html           = "No"
			show           = "40"
			datasource     = "appsPayroll"
			listquery      = "#myquery#"			
			listorder      = "Created"
			listorderdir   = "DESC"
			listgroup     = "ProcessNo"
			listgroupdir  = "DESC"
			headercolor    = "ffffff"
			listlayout     = "#fields#"
			filterShow     = "Yes"
			excelShow      = "Yes"
			drillmode      = "embed"
			drillargument  = "940;1190;false;false"	
			drillstring    = "PersonNo=#url.id#"
			drilltemplate  = "Payroll/Application/Payroll/Calculation/CalculationDetail.cfm"
			drillkey       = "ProcessId">
	
</td></tr></table>		
