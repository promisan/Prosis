
<cf_tl id="Advanced Inquiry" var="tInquiry">

<cf_screentop height="100%" scroll="no" layout="webapp" label="#tInquiry#" jquery="Yes" html="Yes" MenuAccess="Yes" SystemFunctionId="#url.idmenu#">
									
    <cfquery name="clearreport" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE 	FROM         Ref_ReportControl
		WHERE   FunctionName = 'Facttable: Payroll'								
	</cfquery>													
		
	<cfquery name="Schedule" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     S.SalarySchedule, S.Description
		FROM       SalaryScheduleMission P INNER JOIN
		           SalarySchedule S ON P.SalarySchedule = S.SalarySchedule
		WHERE      P.Mission = '#url.mission#'  
		AND        S.Operational = 1		
		AND       S.SalarySchedule IN (SELECT DISTINCT SalarySchedule FROM EmployeeSettlement)	
		ORDER BY   S.ListingOrder					
											
	</cfquery>
																	
	<cfset datasets=ArrayNew(1)>										
	
	<cfloop query="schedule">	
					
		<cfset datasets[currentrow] = 
		       {table      = "table#currentrow#",
			    tablename  = "#SalarySchedule#", 
			    tableclass = "variable",
				tabledrill = "Staffing/Application/Employee/PersonView.cfm",
				tablefield = "PersonNo"}>		
			
	</cfloop>																								
	
	<cfinvoke component="Service.Analysis.CrossTab"  
		  method         = "ShowInquiry"
		  buttonName     = "Analysis"
		  buttonClass    = "variable"		<!--- pass the loading script --->  
		  buttonIcon     = "#SESSION.root#/Images/dataset.png"
		  buttonText     = "#tInquiry#"
		  buttonStyle    = "height:29px;width:120px;"
		  reportPath     = "Payroll\Inquiry\Settlement\"
		  SQLtemplate    = "FactTablePayroll.cfm"
		  queryString    = "Mission=#URL.Mission#"
		  dataSource     = "appsQuery" 
		  module         = "Payroll"
		  reportName     = "Facttable: Payroll"
		  olap           = "1"
		  datasets       = "#datasets#"								 					  
		  target         = "analysisbox"								 										 
		  returnvariable = "script"> 
		  
		  <table width="100%" height="100%">
		  		  
		  <cfif schedule.recordcount gte "1">
		  
		  	   <tr id="open">
			   <td class="labellarge" align="center" style="padding-top:5px">
		  
			   <cfoutput>
					<input class="button10g" type="button" value="Open" style="font-size:20px;height:40;width:200" onClick="#script#;document.getElementById('open').className='hide'">	
			   </cfoutput>
			   
			   </td></tr>
			   
			   <tr><td height="90%" style="padding-top:6px">		  
				  <iframe name="analysisbox" id="analysisbox" width="100%" height="100%" frameborder="0"></iframe>			  
			       </td>
			   </tr>
		   
		   <cfelse>
		   
		   	  <tr><td class="labellarge" align="center">No records found</td></tr>
		   
		   </cfif>		
		  
		  </table>		