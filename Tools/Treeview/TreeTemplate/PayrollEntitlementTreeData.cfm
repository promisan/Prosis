
<cfoutput>

	<cf_UItree id="root" title="<span style='font-size:17px;color:gray;padding-bottom:3px'>#URL.Mission#</span>" expand="Yes">
		       
	  <cfquery name="Period" 
	  datasource="AppsPayroll" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		  SELECT   DISTINCT S.PayrollStart, S.PayrollEnd, S.CalculationId
		  FROM     SalarySchedulePeriod S,
		           EmployeeSalary L0 
		  WHERE    S.SalarySchedule = '#URL.Schedule#' 
		  AND      S.SalarySchedule  = L0.SalarySchedule
		  AND      S.PayrollStart    = L0.PayrollStart
		  AND      S.Mission = '#URL.Mission#'
		  ORDER BY S.PayrollStart DESC
	  </cfquery>
	  
	  <cfquery name="BaseParent" 
	  datasource="AppsPayroll" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		  SELECT   DISTINCT S.CalculationId, R.PrintGroup, R.PrintGroupOrder
		  FROM     SalarySchedulePeriod S, 
		           EmployeeSalary L0, 
				   EmployeeSalaryLine L, 
				   Ref_PayrollItem C, 
				   Ref_SlipGroup R
		  WHERE    S.SalarySchedule  = L0.SalarySchedule
		  AND      S.PayrollStart    = L0.PayrollStart
		  AND      L0.PersonNo       = L.PersonNo
		  AND      L0.PayrollStart   = L.PayrollStart
		  AND      L0.PayrollCalcNo  = L.PayrollCalcNo
		  AND      C.PayrollItem     = L.PayrollItem
		  AND      R.PrintGroup      = C.PrintGroup
		  AND      S.Mission         = '#URL.Mission#'
		  AND      L0.Mission         = '#URL.Mission#'
		  ORDER BY R.PrintGroupOrder 
	  </cfquery>
	  
	  <cfquery name="BaseGrade" 
	  datasource="AppsPayroll" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		  SELECT    DISTINCT S.CalculationId, R.PostOrderBudget, L1.ServiceLevel
		  FROM      SalarySchedulePeriod S, 
		            EmployeeSalary L1, 
				    Employee.dbo.Ref_PostGradeBudget R
		  WHERE     S.SalarySchedule  = L1.SalarySchedule
		  AND       S.PayrollStart    = L1.PayrollStart
		  AND       L1.ServiceLevel   = R.PostGradeBudget
		  AND       S.Mission         = '#URL.Mission#'
		  AND       L1.Mission         = '#URL.Mission#'
		  ORDER BY  R.PostOrderBudget 
	  </cfquery>
	      
		  <cfloop query = "Period">
		  
		    <cfset Per = Period.CalculationId>
			
			<cf_UItreeitem value="#Per#"
		        display="<span style='font-size:16px;padding-bottom:3px;font-weight:bold' class='labelit'>#DateFormat(PayrollEnd, CLIENT.DateFormatShow)#</span>"												
				parent="root" 
				expand="No">
				
			<cf_UItreeitem value="#Per#_item"
			        display="<span style='font-size:15px' class='labelit'>Item</span>"																	
					parent="#Per#">						  		  		
		 		    
			  <cfquery name="Parent"
			         dbtype="query">
						SELECT   *
					    FROM     BaseParent 
						WHERE    CalculationId   = '#Per#' 
						ORDER BY PrintGroupOrder
			  </cfquery>
		  
			  <cfloop query = "Parent">
			  
			    <cfset Par = Parent.Printgroup>
				
				   <cf_UItreeitem value="#Per#_ItemNo_#PrintGroup#"
				        display="<span style='font-size:14px' class='labelit'>#PrintGroup#</span>"						
						href="InquiryView.cfm?mission=#url.mission#&ID=TOT&ID1=#URL.Schedule#&ID2=#Per#&ID3=#Par#&systemfunctionid=#url.systemfunctionid#"		
						target="right"		
						parent="#Per#_item">	
			  			         
			  </cfloop>
			  
			<cf_UItreeitem value="#Per#_grade"
			        display="<span style='font-size:15px' class='labelit'>Grade</span>"																	
					parent="#Per#">	  
		 		  
			  <cfquery name="Grade" dbtype="query">
					 SELECT   *
					 FROM     BaseGrade 
					 WHERE    CalculationId   = '#Per#' 
					 ORDER BY PostOrderBudget
			  </cfquery>
		  
			  <cfloop query = "Grade">
			  
			    <cfset Grd = Grade.ServiceLevel>
				
				  <cf_UItreeitem value="#Per#_Grade_#ServiceLevel#"
				        display="<span style='font-size:14px' class='labelit'>#GRD#</span>"						
						href="InquiryView.cfm?mission=#url.mission#&ID=LVL&ID1=#URL.Schedule#&ID2=#Per#&ID3=#Grd#&systemfunctionid=#url.systemfunctionid#"		
						target="right"		
						parent="#Per#_grade">				  
						     
			  </cfloop> 		  
		 		  
		  </cfloop>
	    
	</cf_UItree>
     
</cfoutput>

