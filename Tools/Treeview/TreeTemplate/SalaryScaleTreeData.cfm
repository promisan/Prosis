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

<cfoutput>

<cf_UItree id="root" title="<span style='font-size:16px;color:gray;padding-bottom:3px'>Salaryscale</span>" expand="Yes">
 
<cfquery name="Schedule" 
  datasource="AppsPayroll" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">  
      SELECT * 
	  FROM   SalarySchedule
      WHERE  SalarySchedule IN (SELECT DISTINCT SalarySchedule FROM SalaryScale)	 
      ORDER BY ListingOrder
  </cfquery>

  <cfloop query="Schedule">
  
  <cfquery name="SalarySchedule" 
  datasource="AppsPayroll" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT * 
	  FROM   SalarySchedule
      WHERE  SalarySchedule = '#Schedule.SalarySchedule#'	 
  </cfquery>	
  
  <cfset sch = Schedule.SalarySchedule>
  
  	 <cf_UItreeitem value="#sch#"
			        display="<span style='font-size:14px' class='labelit'>#SalarySchedule.Description#</span>"																
					parent="root">
     
	  <cfquery name="Location" 
	  datasource="AppsPayroll" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	      SELECT DISTINCT ServiceLocation, Description 
	      FROM   SalaryScale S, 
		         Ref_PayrollLocation R
	   	  WHERE  SalarySchedule    = '#sch#'
		  AND    S.ServiceLocation = R.LocationCode
		  ORDER BY ServiceLocation
	  </cfquery>
    
	  <cfloop query="location">
	  
	       <cfset loc = Location.ServiceLocation>
		   
		     <cfquery name="Last" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				        SELECT   TOP 1 *
				        FROM     SalaryScale
				     	WHERE    SalarySchedule = '#sch#'
						AND      ServiceLocation = '#loc#'	
						AND      Mission         = '#attributes.mission#' 					
						ORDER BY ScaleNo DESC
		     </cfquery>
		   
		    <cf_UItreeitem value="#sch#_#loc#"
			        display="<span style='font-size:13px' class='labelit'>#Description#</span>"						
					href="#session.root#/Payroll/Application/SalaryScale/SalaryScaleListing.cfm?ID=#sch#&ID1=#loc#&ID2=all&contractid=#contractid#"							
					target="scaleright"
					expand="No"
					parent="#sch#">
		 						
				 <cfquery name="Service" 
				       datasource="AppsPayroll" 
				       username="#SESSION.login#" 
				       password="#SESSION.dbpw#">
				        SELECT   DISTINCT 
						         S.ServiceLevel, 
							     R.PostOrderBudget 
				        FROM     SalaryScale K,
						         SalaryScaleLine S, 
						         Employee.dbo.Ref_PostGrade R
				     	WHERE    K.ScaleNo   = S.ScaleNo
						AND      K.SalarySchedule = '#sch#'
						AND      K.ServiceLocation = '#loc#'
						<!--- limit grades to be shown --->
						AND      K.ScaleNo     = '#Last.ScaleNo#'
						AND      R.PostGrade   =  S.ServiceLevel
						AND	     S.Operational = '1'
						ORDER BY R.PostOrderBudget
				  </cfquery>				 
				 					  
				  <cfloop query="Service">
				  
				  	 <cf_UItreeitem value="#sch#_#loc#_#ServiceLevel#"
			        display="<span style='font-size:13px' class='labelit'>#ServiceLevel#</span>"						
					href="#session.root#/Payroll/Application/SalaryScale/SalaryScaleListing.cfm?ID=#sch#&ID1=#loc#&ID2=#ServiceLevel#&contractid=#contractid#&mission=#attributes.mission#"					
					target="scaleright"
					parent="#sch#_#LOC#">
					 						
				  </cfloop>	  
   
	  </cfloop>
  
 </cfloop>
 
 </cf_UItree>	
 
</cfoutput>




