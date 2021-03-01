<!--- 

1. define the selection date from the mandate
2. show people
--->

<cfparam name="url.mission"   default="">
<cfparam name="url.mandateno" default="">
<cfparam name="url.id"        default="par">
<cfparam name="url.date"      default="">

<cfif url.date eq "">

	<cfquery name="Mandate" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_Mandate
		WHERE  Mission = '#url.Mission#'
		AND    MandateNo = '#url.MandateNo#'
	</cfquery>

	<cfif mandate.dateexpiration gte now()>
	   <cfset sel = dateformat(now(),"YYYYMMDD")>  
	<cfelse>
	   <cfset sel = dateformat(Mandate.DateExpiration,"YYYYMMDD")>
	</cfif>
	
<cfelse>	
		
		<cfset dateValue = "">
		<CF_DateConvert Value="#url.date#">
		<cfset dte = dateValue>
		<cfset sel = dateformat(dte,"YYYYMMDD")>
	
</cfif>	

<script>
	Prosis.busy('no')
</script>

<cfoutput>

	<cfsavecontent variable="myquery">
	
	 SELECT  L1.ServiceLevel,   
             (SELECT PostOrder 
			  FROM   Employee.dbo.Ref_PostGrade 
			  WHERE  PostGrade = L1.ServiceLevel) as PostOrder, 
			 L1.PostType, 
		     L1.ServiceStep, 
		     L1.ServiceLocation, 
		     L1.PayrollEnd, 
		     P.FirstName+' '+P.LastName as Name, 		    
		     P.Nationality, 
			 P.Gender,
		     P.BirthDate, 
		     P.IndexNo, 
		     P.PersonNo, 
			 C.PayrollItemName, 
		     SUM(L2.PaymentAmount) as Amount
	  FROM   SalarySchedulePeriod S, 
	         EmployeeSalaryLine L2, 
		     EmployeeSalary L1, 
		     Ref_PayrollItem C, 
		     Employee.dbo.Person P
	  WHERE  S.CalculationId   = '#URL.ID2#' 
	  AND    (C.PrintGroup     = '#URL.ID3#' or L1.ServiceLevel = '#URL.ID3#')
	  AND    (C.PayrollItem    = '#URL.ID4#' or C.PayrollItemName = '#url.id4#')
	  
	  AND    S.SalarySchedule  = L1.SalarySchedule
	  AND    S.PayrollStart    = L1.PayrollStart
	  AND    S.Mission         = L1.Mission
	  AND    L1.PersonNo       = L2.PersonNo
	  AND    L1.PayrollStart   = L2.PayrollStart
	  AND    L1.PersonNo       = P.PersonNo 
	  AND    C.PayrollItem     = L2.PayrollItem 
	      
	  GROUP BY L1.ServiceLevel,           
			   L1.ServiceStep, 
			   L1.ServiceLocation, 
			   L1.PayrollEnd, 
			   C.PayrollItemName,
			   P.LastName, 
			   P.FirstName, 
			   P.Gender,
			   P.PersonNo, 
			   P.IndexNo, 
			   P.Nationality, 
			   L1.PostType,
			   P.BirthDate 
			   			   
	</cfsavecontent>	

</cfoutput>		
		
<cfparam name="client.header" default="">

<cfset fields=ArrayNew(1)>
		
<cfset fields[1] = {label      = "No",                  
					field      = "IndexNo",					
					search     = "text"}>		
				
<cfset fields[2] = {label      = "Name",                  
					field      = "Name",					
					search     = "text"}>				
					
<cfset fields[3] = {label      = "Gender",                  
					field      = "Gender",		
					column     = "common",
					filtermode = "2",			
					search     = "text"}>	
					
<cfset fields[4] = {label      = "PostType",                  
					field      = "PostType",	
					column     = "common",
					filtermode = "3",						
					search     = "text"}>															

<cfset fields[5] = {label      = "Grade",                  
					field      = "ServiceLevel",
					fieldsort  = "PostOrder",
					column     = "common",
					filtermode = "3",
					search     = "text"}>		
						
<cfset fields[6] = {label      = "S", 					
					field      = "ServiceStep",										
					search     = "text"}>		
					
<cfset fields[7] = {label      = "Amount",  					
					field      = "Amount",					
					aggregate  = "sum",
					align      = "right",
					formatted  = "numberformat(Amount,',.__')",					
					search     = "number"}>									
					
					
<cf_listing
    header        = "Entitlement"
    box           = "entitlement"
	link          = "#SESSION.root#/Payroll/Inquiry/Entitlement/RecapItemContent.cfm?ID=#URL.ID#&ID1=#URL.ID1#&ID2=#URL.ID2#&ID3=#URL.ID3#&ID4=#url.id4#&systemfunctionid=#url.systemfunctionid#"
    html          = "No"
	show          = "200"
	datasource    = "AppsPayroll"
	listquery     = "#myquery#"
	listkey       = "PostGrade"
	listorder     = "PostOrder"
	listorderdir  = "ASC"
	headercolor   = "ffffff"
	listlayout    = "#fields#"
	filterShow    = "Hide"
	excelShow     = "Yes"
	drillmode     = "tab"
	drillargument = "960;1200;false;false"	
	drilltemplate = "Staffing/Application/Employee/PersonView.cfm?id="
	drillkey      = "PersonNo">
					  
