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

		
 <cfset dateValue = "">
<CF_DateConvert Value="#Form.SalaryEffective#">
<cfset eff =  dateValue>
	
<cfset dateValue = "">
<CF_DateConvert Value="#Form.SalaryEffective#">
<cfset first = dateValue>
		
<cfset scalenumber = url.scaleNo>	

 <cfquery name="get"
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	     SELECT * 
		 FROM   SalaryScale
	     WHERE  ScaleNo         = '#URL.scaleNo#'		  		
   </cfquery>
		   
   <cfquery name="Check"
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	     SELECT * 
		 FROM   SalaryScale
	     WHERE  Mission          = '#get.Mission#'
		 AND    SalarySchedule   = '#get.SalarySchedule#'
		 AND    ServiceLocation  = '#form.ServiceLocation#'		  
		 AND    SalaryEffective  = #eff#
		 AND    Operational      = 1 
   </cfquery>
		
   <cfif Check.recordcount eq "1">
   
	   <cfquery name="Check"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		     UPDATE SalaryScale
			 SET    Operational = '0'
		     WHERE  Mission          = '#get.Mission#'
			 AND    SalarySchedule   = '#get.SalarySchedule#'
			 AND    ServiceLocation  = '#form.ServiceLocation#'		  
			 AND    SalaryEffective  = #eff#
			 AND    Operational      = 1 
	   </cfquery>
   
   </cfif>
   
   <cfquery name="Check"
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	     SELECT * 
		 FROM   SalaryScale
	     WHERE  Mission          = '#get.Mission#'
		 AND    SalarySchedule   = '#get.SalarySchedule#'
		 AND    ServiceLocation  = '#form.ServiceLocation#'		  
		 AND    SalaryEffective  = #eff#
		 AND    Operational      = 1 
   </cfquery>
   
   <cfif Check.recordcount eq "0">
   
   	    <!--- ADD A NEW SCALE --->
		
	   <cftransaction>
	   	
			<cfquery name="Scale"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    INSERT INTO SalaryScale
				   	(SalarySchedule, 
					 Mission, 
					 ServiceLocation, 
					 SalaryEffective, 
					 SalaryFirstApplied,
					 OfficerUserid, 
					 OfficerLastName, 
					 OfficerFirstName)
				 SELECT DISTINCT 
				        SalarySchedule, 
						Mission, 
						'#Form.ServiceLocation#', 
						#Eff#,
						#First#,
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#'
			     FROM   SalaryScale
			     WHERE  ScaleNo = '#URL.scaleNo#'			  
		    </cfquery>
			
			<!--- prior --->
			
			<cfquery name="NewScale"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT   TOP 1 * 
				FROM     SalaryScale
				ORDER BY ScaleNo DESC			
		    </cfquery>
			
			<cfset scalenumber = NewScale.ScaleNo>
			
			<!--- copy details --->
			
			<cfquery name="Scale"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    INSERT INTO SalaryScalePercentage
					 (ScaleNo, 
					  ComponentName, 
					  EntitlementPointer, 
					  Percentage, 
					  CalculationBase, 
					  CalculationBaseFinal, 
					  CalculationBasePeriod, 
					  DetailMode,
					  OfficerUserId,OfficerLastName,OfficerFirstName)
				SELECT '#NewScale.ScaleNo#', 
					    ComponentName, 
					    EntitlementPointer, 
					    Percentage, 
					    CalculationBase, 
					    CalculationBaseFinal, 
					    CalculationBasePeriod, 
					    DetailMode,
					    '#SESSION.acc#','#SESSION.last#','#SESSION.first#'
				FROM    SalaryScalePercentage 
				WHERE   ScaleNo = '#url.scaleNo#'		   
		    </cfquery>
			
			<!--- copy details as well --->
			
			<cfquery name="ScaleDetails"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    INSERT INTO SalaryScalePercentageDetail
					   (ScaleNo, 
					    ComponentName, 
					    EntitlementPointer, 
					    DetailValue, 
					    Percentage)
				SELECT '#NewScale.ScaleNo#', 
					    ComponentName, 
					    EntitlementPointer, 
					    DetailValue,
					    Percentage
				FROM    SalaryScalePercentageDetail 
				WHERE   ScaleNo = '#url.scaleNo#'			   
		    </cfquery>
			
			<!--- copy line details as well --->
			
			<cfquery name="ScaleDetails"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    INSERT INTO SalaryScaleLine
					 (ScaleNo,
					  ServiceLevel,
					  ServiceStep, 
					  SalarySchedule,
					  ComponentName,
					  Currency,
					  Amount,
					  Operational)
				SELECT '#NewScale.ScaleNo#', 
					  ServiceLevel,
					  ServiceStep, 
					  SalarySchedule,
					  ComponentName,
					  Currency,
					  Amount,
					  Operational
				FROM  SalaryScaleLine
				WHERE ScaleNo = '#url.scaleNo#'			   
		    </cfquery>
			
		</cftransaction>
	
	</cfif>
					
  	
 <!--- close window, refresh left menu and load main screen --->	
 
 <cfoutput>
  
 <cfquery name="Scale"
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
     SELECT * 
	 FROM   SalaryScale
     WHERE  ScaleNo         = '#URL.scaleNo#'		  		 
</cfquery>
	
 <cfparam name="url.mid" default="">
 
 <script>
 
   parent.ColdFusion.navigate('RateViewTree.cfm?mission=#scale.mission#&schedule=#scale.salaryschedule#&location=#form.servicelocation#&mid=#url.mid#','treebox') 
   ProsisUI.closeWindow('addscale')   
   window.location = "rateedit.cfm?mid=#url.mid#&mission=#scale.mission#&schedule=#scale.salaryschedule#&location=#form.servicelocation#&effective=#dateformat(eff,client.dateSQL)#&mode=grade&operational=1"
 
 </script>	
 
 </cfoutput>				
	

