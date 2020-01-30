
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfset dateValue = "">
<CF_DateConvert Value="#form.DateEffective#">
<cfset STR = dateValue>

<cfset sch = replaceNoCase(Form.SalarySchedule," ","","ALL")> 
<cfset sch = replaceNoCase(sch,"-","","ALL")> 
			
<cfif ParameterExists(Form.Insert)> 

	<cfquery name="Verify" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM  SalarySchedule
	WHERE SalarySchedule  = '#sch#' 
	</cfquery>

   <cfif Verify.recordCount is 1>
   
	   <script language="JavaScript">
	      alert("A schedule with this code has been registered already!")
	   </script>  
  
   <cfelse>
   
   		<cftransaction>
   
			<cfquery name="Insert" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO SalarySchedule
			         (SalarySchedule, 
					  Description, 
					  PaymentCurrency, 
					  SalaryCalculationPeriod, 
					  SalaryBasePeriodDays, 
					  SalaryBaseRate, 
					  SalaryBasePayrollItem, 	                
					  OfficerUserId,
					  OfficerLastName,
					  OfficerFirstName)
			  VALUES ('#sch#',
			          '#Form.Description#', 
					  '#Form.Currency#',
					  '#Form.SalaryCalculationPeriod#',
					  '#Form.SalaryBasePeriodDays#',
					  '#Form.SalaryBaseRate#',
					  '#Form.SalaryBasePayrollItem#',					 			  
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#')
			</cfquery>
			
			<cfquery name="Insert" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO SalaryScheduleMission
			         (SalarySchedule, 
					  Mission, 
					  DateEffective,
					  OfficerUserId,
					  OfficerLastName,
					  OfficerFirstName)
			  VALUES ('#sch#',
			          '#Form.Mission#', 
					  #STR#,
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#')
			</cfquery>
		
		</cftransaction>
		  
    </cfif>		  
           
</cfif>

<cfoutput>
<script language="JavaScript">   
     window.close()
	 opener.location = "RecordListing.cfm?idmenu=#url.idmenu#&init=1"       
</script>  
</cfoutput>
