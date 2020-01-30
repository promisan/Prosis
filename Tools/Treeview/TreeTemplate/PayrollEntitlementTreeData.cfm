

<cfoutput>

	<cftree name="root"
		fontsize="13"		
		bold="No"   
		format="html"    
		required="No">   
		   
		       
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
		  ORDER BY  R.PostOrderBudget 
	  </cfquery>
	      
		  <cfloop query = "Period">
		  
		    <cfset Per = Period.CalculationId>
		  
		    <cftreeitem value="#Per#"
				        display="#DateFormat(PayrollEnd, CLIENT.DateFormatShow)#"
						parent="Root"										
				        expand="No">			
		
		    <cftreeitem value="#Per#_Item"
				        display="Item"
						parent="#Per#"										
				        expand="No">	
		    
			  <cfquery name="Parent"
			         dbtype="query">
						SELECT *
					    FROM BaseParent 
						WHERE CalculationId   = '#Per#' 
						ORDER BY PrintGroupOrder
			  </cfquery>
		  
			  <cfloop query = "Parent">
			  
			    <cfset Par = Parent.Printgroup>
			  
			    <cftreeitem value="#Per#_ItemNo_#PrintGroup#"
					        display="#PrintGroup#"
							parent="#Per#_Item"		
							href="InquiryView.cfm?ID=TOT&ID1=#URL.Schedule#&ID2=#Per#&ID3=#Par#"									
							target="right"
					        expand="No">	
			         
			  </cfloop>
		    
		   <cftreeitem value="#Per#_grade"
				        display="Grade"
						parent="#Per#"										
				        expand="No">	
		  
			  <cfquery name="Grade" dbtype="query">
					 SELECT *
					 FROM BaseGrade 
					 WHERE CalculationId   = '#Per#' 
					 ORDER BY PostOrderBudget
			  </cfquery>
		  
			  <cfloop query = "Grade">
			  
			    <cfset Grd = Grade.ServiceLevel>
			  
			    <cftreeitem value="#Per#_Grade_#ServiceLevel#"
					        display="#GRD#"
							parent="#Per#_grade"		
							href="InquiryView.cfm?ID=LVL&ID1=#URL.Schedule#&ID2=#Per#&ID3=#Grd#"									
							target="right"
					        expand="No">	
			     
			  </cfloop> 
		  
		 		  
		  </cfloop>
	    
	  </cftree>  
     
</cfoutput>

