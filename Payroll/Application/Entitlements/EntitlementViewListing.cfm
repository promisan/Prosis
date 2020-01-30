
<cfparam name="URL.Mission"    default="">

<cfquery name="Parameter" 
   datasource="AppsPayroll" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT *
   FROM   Ref_ParameterMission 
   WHERE  Mission = '#url.mission#'
</cfquery>

<cfoutput> 

<!--- body --->

<cfif url.id neq "PCR">

	<cfsavecontent variable="sqlbody">
	
	    SELECT * 
		FROM (
		
		SELECT     P.PersonNo,
		           P.IndexNo AS IndexNo, 
		           P.LastName AS LastName, 
				   P.FirstName AS FirstName, 
				   P.Gender AS Gender, 
				   
				   ( CASE WHEN (SELECT count(*)
				                FROM   Employee.dbo.PersonAssignment PA, Employee.dbo.Position PO
								WHERE  PA.PositionNo = PO.PositionNo
								AND    PO.Mission = '#url.mission#'
								AND    PA.DateEffective  <= getDate()
								AND    PA.DateExpiration >= getDate()
								AND    PA.PersonNo = P.PersonNo
								AND    AssignmentStatus IN ('0','1')
								) > 0 THEN 'Onboard' ELSE 'Inactive' END) as PersonStatus,
								
								
					 (  SELECT   TOP 1 PC.SalarySchedule
				        FROM     Employee.dbo.PersonContract PC
						WHERE    PC.PersonNo       = P.PersonNo
						AND      PC.Mission        = '#url.mission#'
						AND      PC.ActionStatus IN ('0','1')
						AND      PC.DateEffective  <= getDate()		
						AND      PC.DateExpiration  >= getDate()
							 ) as PersonSchedule,	
											
				   E.ObjectId,				
				   E.EntitlementId,
				   E.DependentId,
				   CAST(UPPER(D.LastName) as VARCHAR(50))+ ', ' + CAST(D.FirstName as VARCHAR(50)) as DependentFirstName,
				   DATEDIFF(year,D.BirthDate,GETDATE()) as DependentAge,
				   D.BirthDate as DependentBirthDate,
				   E.SalaryTrigger,
				   G.Description,
				   E.SalarySchedule,
				   E.DateEffective,
				   ISNULL(E.DateExpiration,'12/31/9999') as DateExpiration,
				   E.Currency,
				   E.Amount,
				   E.Status,
				   ( CASE WHEN Status = '2' THEN 'Approved'
				   		  WHEN Status = '3' THEN 'Approved' 
						  WHEN Status = '5' THEN 'Billed'  ELSE 'Pending' END) as StatusName,
				   E.OfficerLastName,
				   E.Created
		FROM       
		
		(
		
		SELECT     PersonNo, 
		           EntitlementId as ObjectId,  
				   EntitlementId,  
				   '{00000000-0000-0000-0000-000000000000}' AS DependentId, 
				   SalarySchedule, 
				   SalaryTrigger, 
				   DateEffective, 
				   DateExpiration, 
				   Currency, 
				   Amount, 
				   Status, 
				   OfficerLastName,
				   Created
				   
		FROM       PersonEntitlement F
		WHERE      1=1
		AND        SalarySchedule IN (SELECT SalarySchedule
		                              FROM   SalaryScheduleMission 
									  WHERE  Mission = '#url.mission#')
									  
								  
									  
		AND       EXISTS (SELECT   'X'
	                        FROM    Organization.dbo.OrganizationObject
	                        WHERE   ObjectKeyValue4 = F.EntitlementId 
					        AND     Mission = '#url.mission#')							  
		                 
		UNION ALL
		
		SELECT     PersonNo, 
		           EntitlementId as ObjectId,  
				   EntitlementId,  
				   DependentId, 
				   SalarySchedule, 
				   (
				    SELECT   SalaryTrigger
					FROM     Ref_PayrollComponent
					WHERE    PayrollItem = F.PayrollItem
					) as SalaryTrigger,
				   
				   DateEffective, 
				   DateExpiration, 
				   Currency, 
				   Amount, 
				   Status, 
				   OfficerLastName,
				   Created
				   
		FROM       PersonEntitlement F
		WHERE      1=1
		AND        SalarySchedule IN (SELECT SalarySchedule
		                              FROM   SalaryScheduleMission 
									  WHERE  Mission = '#url.mission#')
									  
		AND        SalaryTrigger is NULL							  
									  
		AND       EXISTS (SELECT   'X'
	                        FROM    Organization.dbo.OrganizationObject
	                        WHERE   ObjectKeyValue4 = F.EntitlementId 
					        AND     Mission = '#url.mission#')							  
		
		UNION ALL

		<!--- specifically for contract entitlments --->
		SELECT     PersonNo, 
		           EntitlementId as ObjectId,  
				   EntitlementId,  
				   '{00000000-0000-0000-0000-000000000000}' AS DependentId, 
				   SalarySchedule, 
				   SalaryTrigger, 
				   DateEffective, 
				   DateExpiration, 
				   Currency, 
				   Amount, 
				   Status, 
				   OfficerLastName,
				   Created
				   
		FROM       PersonEntitlement F
		WHERE      1=1
		AND        SalarySchedule IN (SELECT SalarySchedule
		                              FROM   SalaryScheduleMission 
									  WHERE  Mission = '#url.mission#')			  
		AND       NOT EXISTS (SELECT   'X'
	                        FROM    Organization.dbo.OrganizationObject
	                        WHERE   ObjectKeyValue4 = F.EntitlementId 
					        AND     Mission = '#url.mission#')							  
		                 
		UNION ALL
			
		SELECT     PersonNo, 
		           DependentId as ObjectId, 
				   EntitlementId, 
				   DependentId, 
				   SalarySchedule, 
				   SalaryTrigger, 
				   DateEffective, 
				   DateExpiration, 
				   '', 
				   0, 
				   Status, 
				   OfficerLastName, 
				   Created
		FROM       PersonDependentEntitlement PE
		WHERE      1=1
		AND        EXISTS  (SELECT 'X'
		                      FROM   Employee.dbo.PersonDependent 
							  WHERE  PersonNo = PE.PersonNo 
							  AND    DependentId = PE.DependentId 
							  AND    ActionStatus != '9')   
							  
		AND        PersonNo IN (SELECT PersonNo
		                        FROM   Employee.dbo.PersonContract 
							    WHERE  Mission = '#url.mission#'
								AND    ActionStatus = '1')					  
		
		
			
		UNION ALL
		
		SELECT    OT.PersonNo, 
		          OT.OvertimeId as ObjectId, 
				  OT.OvertimeId,  
				  '{00000000-0000-0000-0000-000000000000}' AS DependentId, 
				  '', 
				  OTD.SalaryTrigger, 
				  OvertimePeriodStart, 
				  OvertimePeriodEnd, 
				  '', 
				  OTD.OvertimeHours, 
				  OT.Status, 
				  OT.OfficerLastName, 
				  OT.Created			  
		FROM      PersonOvertime OT INNER JOIN PersonOverTimeDetail OTD ON OT.PersonNo = OTD.PersonNo AND OT.OvertimeId = OTD.OvertimeId
		WHERE     (OTD.OvertimeHours > 0 or OTD.OvertimeMinutes > 0) 
		AND       EXISTS (SELECT   'X'
	                        FROM    Organization.dbo.OrganizationObject
	                        WHERE   ObjectKeyValue4 = OT.OvertimeId 
					        AND     Mission = '#url.mission#')
		
		
		) E INNER JOIN Employee.dbo.Person P ON E.PersonNo = P.PersonNo 
		
		INNER JOIN Ref_PayrollTrigger G ON E.SalaryTrigger = G.SalaryTrigger
		
		LEFT OUTER JOIN Employee.dbo.PersonDependent D ON E.DependentId = D.DependentId AND D.ActionStatus != '9'
		
		) as X
		
		WHERE 1=1 
		
		-- condition
		
		
	</cfsavecontent>
	
<cfelse>

<cfsavecontent variable="sqlbody">

		SELECT *
		FROM  (

		SELECT     PM.PersonNo, 
		           CostId as ObjectId,
				   
				     ( CASE WHEN (SELECT count(*)
				                FROM   Employee.dbo.PersonAssignment PA, 
								       Employee.dbo.Position PO
								WHERE  PA.PositionNo = PO.PositionNo
								AND    PO.Mission = '#url.mission#'
								AND    PA.DateEffective  <= getDate()
								AND    PA.DateExpiration >= getDate()
								AND    PA.PersonNo = P.PersonNo
								AND    AssignmentStatus IN ('0','1')
								) > 0 THEN 'Onboard' ELSE 'Inactive' END) 
								
								as PersonStatus,
								
					 (  SELECT TOP 1 SalarySchedule
				        FROM   Employee.dbo.PersonContract PC
						WHERE  PC.PersonNo = P.PersonNo
						AND    PC.Mission = '#url.mission#'
						AND    PC.DateEffective  <= getDate()											
						AND    PC.ActionStatus IN ('0','1')
						ORDER BY DateEffective DESC)
						 
						  		as PersonSchedule,	
										
											
				   P.IndexNo, 
				   P.LastName, 
				   P.FirstName, 
				   P.Gender, 
                   P.Nationality,
		           PM.CostId, 
				   PM.DateEffective, 
				   PM.DateExpiration, 
				   R.PayrollItemName, 
				   PM.EntitlementClass, 
				   PM.Quantity, 
				   PM.Currency, 
				   PM.Amount, 
				   PM.Status, 
				   
				      ( CASE WHEN Status = '2' THEN 'Approved'
				   		     WHEN Status = '3' THEN 'Approved' 
						     WHEN Status = '5' THEN 'Billed'  ELSE 'Pending' END) as StatusName,
							 
                   PM.OfficerLastName, 
				   PM.Created 
				  
		FROM       PersonMiscellaneous PM INNER JOIN
                   Ref_PayrollItem R ON PM.PayrollItem = R.PayrollItem INNER JOIN
                   Employee.dbo.Person P ON PM.PersonNo = P.PersonNo
		WHERE      PM.Status < '5'
		
		<!--- has a valid contract for this entity --->
		AND        PM.PersonNo IN (SELECT PersonNo
		                           FROM   Employee.dbo.PersonContract 
							       WHERE  Mission = '#url.mission#'
								   AND    ActionStatus = '1')			
	
	    ) as D
		
		WHERE 1=1 
				
		-- condition		
	
	</cfsavecontent>


</cfif>	

<cfquery name="Trigger" 
   datasource="AppsPayroll" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT *
   FROM   Ref_PayrollTrigger 
   WHERE  SalaryTrigger = '#url.id1#'
</cfquery>

<cfswitch expression="#URL.ID#">

`	<cfcase value="GRP">
				
	    <cfset condition = "AND SalaryTrigger IN (SELECT SalaryTrigger FROM Ref_PayrollTrigger WHERE TriggerGroup = '#url.id1#') AND Status != '9'">
							  	
		<cfset text = "">
		 
	</cfcase>
	
	<cfcase value="TRG">
				
	    <cfset condition = "AND SalaryTrigger = '#url.id1#' AND Status != '9'">
							  	
		<cfset text = "">
		 
	</cfcase>
	
	<cfcase value="TOD">
	
		  <cfset condition = "AND Created >= getDate() - 31 AND Status != '9'">
							  	
		<cfset text = "">
		
	</cfcase>	
		
	<cfcase value="PEN">
	
		  <cfset condition = "AND Status IN ('0','1')">
							  	
		<cfset text = "">	
			
	</cfcase>	
	
	<cfcase value="PCR">
	
		<cfset condition = "AND Status < '5'">
							  	
		<cfset text = "">	
	
	</cfcase>
	
</cfswitch>
	
</cfoutput>

<cfquery name="Parameter" 
   datasource="AppsPayroll" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT *
   FROM   Ref_ParameterMission 
   WHERE  Mission = '#url.mission#'
</cfquery>

<!--- pass the view --->

<cfoutput> 

	<cfsavecontent variable="myquery">  
		#preserveSingleQuotes(sqlbody)#		
		#preserveSingleQuotes(condition)#			
	</cfsavecontent>	
		  
</cfoutput>

<cfif trigger.triggercondition eq "Dependent">
	<cfset cond = "Dependent">
<cfelse>
    <cfset cond = "Entitlement">
</cfif>

<!--- show person, status processing color and filter on raise by me --->

<cfparam name="client.header" default="">

<cfset fields=ArrayNew(1)>

<cfset itm = 0>

<cfif url.id eq "TOD" or url.id eq "PEN" or url.id eq "GRP">

	<cfset itm = itm+1>
	
	<cf_tl id="Trigger" var="1">
	<cfset fields[itm] = {label    = "#lt_text#", 
	                    width      = "0", 
						field      = "Description",						
						filtermode = "2",
						search     = "text"}>
						
<cfelseif url.id eq "PCR">

	<cfset itm = itm+1>
	
	<cf_tl id="Item" var="1">
	<cfset fields[itm] = {label    = "#lt_text#", 
	                    width      = "0", 
						field      = "PayrollItemName",						
						filtermode = "2",
						search     = "text"}>						


</cfif>
	
	<cfset itm = itm+1>
	
	<cf_tl id="Id" var="1">
	<cfset fields[itm] = {label           = "#lt_text#", 
	                    width             = "0", 
						field             = "IndexNo",
						functionscript    = "EditPerson",
						functionfield     = "personno",
						functioncondition = "#cond#",
						filtermode        = "0",
						search            = "text"}>
						
	<cfif Trigger.triggerGroup neq "Personal">						
						
		<cfset itm = itm+1>					
		
		<cf_tl id="Schedule" var="1">
		<cfset fields[itm] = {label    = "#lt_text#", 
	                    width          = "0", 
						field          = "PersonSchedule",
						filtermode     = "3",
						search         = "text"}>		
					
	</cfif>								
						
	<cfset itm = itm+1>					

	<cf_tl id="Modality" var="1">
	<cfset fields[itm] = {label      = "#lt_text#", 
                    width      = "0", 
					field      = "PersonStatus",
					display    = "0",
					displayfilter = "yes",
					filtermode = "3",
					search     = "text"}>									
						
					
	<cfset itm = itm+1>		
	<cf_tl id="Staff Name" var="1">
	<cfset fields[itm] = {label      = "#lt_text#", 
	                    width      = "0", 
						field      = "LastName",
						filtermode = "0",
						search     = "text"}>
						
					
	<cfset itm = itm+1>		
	<cf_tl id="FirstName" var="1">
	<cfset fields[itm] = {label      = "#lt_text#", 
	                    width      = "0", 
						field      = "FirstName",
						display    = "0",
						displayfilter = "yes",
						filtermode = "0",
						search     = "text"}>		
						
	<cfif (trigger.triggercondition eq "Dependent" and (url.id eq "TRG" or url.id eq "GRP")) or trigger.triggergroup eq "Personal">
	
		<cfset itm = itm+1>		
		<cf_tl id="DOB" var="1">
		<cfset fields[itm] = {label      = "#lt_text#", 
		                    width      = "0", 
							field      = "DependentBirthDate",
							filtermode = "0",
							display    = "0",
							displayfilter = "no",
							formatted  = "dateformat(DependentBirthDate,CLIENT.DateFormatShow)",
							search     = "date"}>			
		
		<cfset itm = itm+1>		
		<cf_tl id="Dependent" var="1">
		<cfset fields[itm] = {label      = "#lt_text#", 
		                    width      = "0", 
							field      = "DependentFirstName",
							filtermode = "0",
							search     = "text"}>		
							
		
		<cfset itm = itm+1>		
		<cf_tl id="Age" var="1">
		<cfset fields[itm] = {label      = "#lt_text#", 
		                    width      = "0", 
							field      = "DependentAge",
							filtermode = "0",
							search     = "number"}>							
								
	</cfif>		
	
	<cfif url.id1 eq "Overtime" or Trigger.TriggerGroup eq "Overtime">
	
	<cfset itm = itm+1>		
		<cf_tl id="Overtime" var="1">
		<cfset fields[itm] = {label      = "#lt_text#", 
		                    width      = "0", 
							align      = "center",
							field      = "Amount",
							filtermode = "0",
							search     = "number"}>			
	
	</cfif>	
						
	<cfset itm = itm+1>								
	<cf_tl id="Effective" var="1">
	<cfset fields[itm] = {label      = "#lt_text#",    
						width      = "0", 
						field      = "DateEffective",		
						labelfilter = "Date Effective",			
						formatted  = "dateformat(DateEffective,CLIENT.DateFormatShow)",
						search     = "date"}>	
						
	<cfset itm = itm+1>					
	<cf_tl id="Expiration" var="1">
	<cfset fields[itm] = {label    = "#lt_text#",    
						width      = "0", 
						field      = "DateExpiration",		
						labelfilter = "Date Expiration",			
						formatted  = "dateformat(DateExpiration,CLIENT.DateFormatShow)",
						search     = "date"}>	
						
					
	<cfset itm = itm+1>					
	<cf_tl id="Status" var="1">
	<cfset fields[itm] = {label    = "#lt_text#", 
                    width          = "0", 
					field          = "StatusName",
					filtermode     = "3",
					search         = "text"}>		
					
					
	<cfset itm = itm+1>					
	<cf_tl id="Officer" var="1">
	<cfset fields[itm] = {label    = "#lt_text#",    
					width          = "0", 
					field          = "OfficerLastName",
					filtermode     = "2",   					
					search         = "text"}>																										
					
	<cfif url.id eq "PCR">
	
		<cfset itm = itm+1>					
		<cf_tl id="Class" var="1">
		<cfset fields[itm] = {label    = "#lt_text#",    
							width      = "0", 
							field      = "EntitlementClass",							
							filtermode = "2",															
							search     = "text"}>	
		
		<cfset itm = itm+1>					
		<cf_tl id="Curr" var="1">
		<cfset fields[itm] = {label      = "#lt_text#",    
							width      = "0", 
							field      = "Currency",	
							labelfilter = "Currency",
							filtermode = "3",															
							search     = "text"}>	
							
		<cfset itm = itm+1>					
		<cf_tl id="Amount" var="1">
		<cfset fields[itm] = {label      = "#lt_text#",    
							width      = "0", 
							align      = "right",
							field      = "Amount",										
							formatted  = "numberformat(Amount,',.__')",
							search     = "amount"}>		
							
	<cfelseif Trigger.triggerGroup eq "Personal">	
	
	<cfset itm = itm+1>					
		<cf_tl id="Curr" var="1">
		<cfset fields[itm] = {label      = "#lt_text#",    
							width      = "0", 
							field      = "Currency",	
							labelfilter = "Currency",
							filtermode = "3",															
							search     = "text"}>	
							
		<cfset itm = itm+1>					
		<cf_tl id="Amount" var="1">
		<cfset fields[itm] = {label      = "#lt_text#",    
							width      = "0", 
							align      = "right",
							field      = "Amount",										
							formatted  = "numberformat(Amount,',.__')",
							search     = "amount"}>											
	
	
	</cfif>				
					


<table width="100%" height="100%" cellspacing="0" cellpadding="0" align="center">
<tr><td style="padding:6px">
										
	<cf_listing
    	header        = "lsPayroll"
    	box           = "lsPayroll"
		link          = "#SESSION.root#/Payroll/Application/Entitlements/EntitlementViewListing.cfm?#cgi.query_string#"		
    	html          = "No"
		show	      = "30"
		datasource    = "AppsPayroll"
		listquery     = "#myquery#"
		listkey       = "EntitlementId"
		listgroup     = "StatusName"	
		listorder     = "PersonNo"		
		listorderdir  = "ASC"
		headercolor   = "ffffff"
		listlayout    = "#fields#"
		annotation    = "EntEntitlement"
		filterShow    = "Yes"
		excelShow     = "Yes"
		drillmode     = "securewindow"	
		drillargument = "920;1200;false;false"	
		drillstring   = "mode=list"
		drilltemplate = "ActionView.cfm?id="
		drillkey      = "ObjectId">

</td></tr></table>

<script>
	parent.Prosis.busy('no')
</script>

