
<cfquery name="Schedule"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	M.*, S.Description
	FROM 	SalaryScheduleMission M INNER JOIN SalarySchedule S ON S.SalarySchedule = M.SalarySchedule
	WHERE   Operational = 1
	ORDER BY Mission, S.ListingOrder
</cfquery> 

<cfquery name="Clear"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    DELETE FROM SalarySchedulePayrollItem
	WHERE  PayrollItem = '#Form.PayrollItem#'
</cfquery>   

<cfset row = 0>

<cfloop query="Schedule">

	<cfset row = row + 1>
		
	<cfparam name="form.objectcode_#row#"        default="">
	<cfparam name="form.itemmaster_#row#"        default="">
	<cfparam name="form.glaccount_#row#"         default="">
	<cfparam name="form.glaccountliability#row#" default="">
	
	<cfset mis = evaluate("form.missionselect_#row#")>
	<cfset sch = 1>
	
	<cfif isDefined("form.scheduleselect_#row#")>
		<cfset sch = 1>
	</cfif>
		
	<cfset obj = evaluate("form.objectcode_#row#")>
	<cfset itm = evaluate("form.itemmaster_#row#")>
	<cfset gla = evaluate("form.glaccount_#row#")>
	<cfset gll = evaluate("form.glaccountliability_#row#")>
					
	<cfif sch neq "">
	
		<cfquery name="Insert" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO SalarySchedulePayrollItem
		         (PayrollItem,
				  Mission,
				  SalarySchedule,
				  ObjectCode,
				  GLAccount,
				  GLAccountLiability,
				  ItemMaster,
				  Operational,
				  OfficerUserId,
				  OfficerLastName,
				  OfficerFirstName)
		  VALUES ('#Form.PayrollItem#',
        		  '#mis#', 
				  '#SalarySchedule#',
				  '#obj#',
				  '#gla#',
				  '#gll#',
				  '#itm#',
				  '#sch#',
				  '#SESSION.acc#',
				  '#SESSION.last#',
				  '#SESSION.first#')
		  </cfquery>	
		  		  		  
			<cfquery name="Param"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT 	*
				FROM 	Parameter	
			</cfquery>
			
		 <cfif Param.PostingMode eq "1">	
		  
		  <cfquery name="getParent" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   Employee.dbo.Ref_PostGradeParent		
				WHERE  Code IN (SELECT P.PostGradeParent
								FROM   SalaryScheduleServiceLevel AS L INNER JOIN Employee.dbo.Ref_PostGrade AS P ON L.ServiceLevel = P.PostGrade
								WHERE  L.SalarySchedule = '#SalarySchedule#')
												
			</cfquery>
					
			<cfloop query="getParent">
															
				<cfset gla = evaluate("form.glaccount_#row#_#currentrow#")>
				
				<cfif gla neq "">
								
					<cfquery name="Insert" 
						datasource="AppsPayroll" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						INSERT INTO SalarySchedulePayrollItemParent
						         (PayrollItem,
								  Mission,
								  SalarySchedule,				
								  GLAccount,	
								  PostGradeParent,			
								  OfficerUserId,
								  OfficerLastName,
								  OfficerFirstName)
					    VALUES ('#Form.PayrollItem#',
					       		  '#mis#', 
								  '#Schedule.SalarySchedule#',				  
								  '#gla#',				
								  '#code#',
								  '#SESSION.acc#',					
								  '#SESSION.last#',
								  '#SESSION.first#')
					  </cfquery>	
				  
				  </cfif>
				  
				  <!---
				  <cfoutput>#cfquery.executiontime#</cfoutput>
				  --->				  
			
			</cfloop>
			
			<cfelse>
			
			<!--- show by class --->
				
				<cfquery name="getClass" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   Employee.dbo.Ref_PostClass
					WHERE  PostClass IN (SELECT DISTINCT PostClass 
					                     FROM   Employee.dbo.Position 
										 WHERE  Mission = '#Schedule.Mission#')																		
				</cfquery>
			
				<cfloop query="getClass">
				
				<cfset gla = evaluate("form.glaccount_#row#_#currentrow#")>
				<cfset gll = evaluate("form.glaccountliability_#row#_#currentrow#")>
				
				<cfif gla neq "" or gll neq "">
								
					<cfquery name="Insert" 
						datasource="AppsPayroll" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						INSERT INTO SalarySchedulePayrollItemClass
						         (PayrollItem,
								  Mission,
								  SalarySchedule,				
								  GLAccount,	
								  GLAccountLiability,
								  PostClass,			
								  OfficerUserId,
								  OfficerLastName,
								  OfficerFirstName)
					    VALUES ('#Form.PayrollItem#',
					       		  '#mis#', 
								  '#Schedule.SalarySchedule#',				  
								  '#gla#',			
								  '#gll#',	
								  '#PostClass#',
								  '#SESSION.acc#',					
								  '#SESSION.last#',
								  '#SESSION.first#')
					  </cfquery>	
				  
				  </cfif>
				 
				</cfloop>
					
			</cfif>
	  
	 </cfif> 	
		
</cfloop>

<script>
	Prosis.busy('no')
</script>

<cfset url.id1 = form.PayrollItem>
<cfinclude template="PayrollSchedule.cfm">
