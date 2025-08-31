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
<cfoutput>

<cfquery name="YearList" 
  datasource="AppsPayroll" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT   DISTINCT YEAR(Created) as Year
      FROM     SalarySchedulePeriod S
	  WHERE    S.Mission = '#URL.Mission#'	 
	  ORDER BY Year DESC	  	  
</cfquery>

	<cf_UItree id="root" title="<span style='font-size:17px;color:black;padding-bottom:3px'>#URL.Mission# #URL.Schedule#</span>" expand="Yes">
	
	  <cfloop query="YearList">	 
		  
		  <cfif YEAR(now()) eq YearList.Year>
		      <cfset exp = "True">
		  <cfelse>
		      <cfset exp = "False"> 
		  </cfif>
		  
		   <cf_UItreeitem value="#year#"
		        display="<span style='font-size:18px;padding-top:5px;padding-bottom:2px;font-weight:bold' class='labelmedium'>#Year#</span>"														
				parent="root"	
				href="InquiryView.cfm?mission=#url.mission#&ID=year&ID1=#URL.Schedule#&ID2=#year#&ID3=&systemfunctionid=#url.systemfunctionid#"		
				target="right"									
		        expand="#exp#">	
			
	   <cfset yr = year>
	   
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
			  AND      S.Mission         = '#URL.Mission#'
			  AND      year(S.PayrollStart) = #yr#
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
			  AND      year(S.PayrollStart) = #yr#
			  ORDER BY R.PrintGroupOrder 
		  </cfquery>
	  
		  <cfquery name="BaseGrade" 
		  datasource="AppsPayroll" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			  SELECT     DISTINCT S.CalculationId, R.PostOrder, L1.ServiceLevel
			  FROM       SalarySchedulePeriod S, 
			             EmployeeSalary L1, 
					     Employee.dbo.Ref_PostGrade R
			  WHERE      S.SalarySchedule    = L1.SalarySchedule
			  AND        S.PayrollStart      = L1.PayrollStart
			  AND        L1.ServiceLevel     = R.PostGrade
			  AND        S.Mission           = '#URL.Mission#'
			  AND        L1.Mission          = '#URL.Mission#'
			  AND        YEAR(S.PayrollStart) = #yr#
			  ORDER BY   R.PostOrder 
			  
		  </cfquery>
	      
		  <cfloop query = "Period">
		  
		    <cfset Per = Period.CalculationId>
			
			<cf_UItreeitem value="#Per#"
		        display="<span style='font-size:16px;padding-bottom:3px;font-weight:bold' class='labelit'>#DateFormat(PayrollEnd, CLIENT.DateFormatShow)#</span>"												
				parent="#yr#" 
				href="InquiryView.cfm?mission=#url.mission#&ID=TOT&ID1=#URL.Schedule#&ID2=#Per#&ID3=&systemfunctionid=#url.systemfunctionid#"		
				target="right"			
				expand="No">
				
			<cf_UItreeitem value="#Per#_item"
			        display="<span style='font-size:15px' class='labelit'>Item</span>"		
					href="InquiryView.cfm?mission=#url.mission#&ID=TOT&ID1=#URL.Schedule#&ID2=#Per#&ID3=&systemfunctionid=#url.systemfunctionid#"		
					target="right"																
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
					href="InquiryView.cfm?mission=#url.mission#&ID=LVL&ID1=#URL.Schedule#&ID2=#Per#&ID3=&systemfunctionid=#url.systemfunctionid#"		
					target="right"														
					parent="#Per#">	  
		 		  
			  <cfquery name="Grade" dbtype="query">
					 SELECT   *
					 FROM     BaseGrade 
					 WHERE    CalculationId   = '#Per#' 
					 ORDER BY PostOrder
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
		  
		   </cfloop>
	    
	</cf_UItree>
     
</cfoutput>

