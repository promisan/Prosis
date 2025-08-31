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
 <table width="100%" class="navigation_table">
 
	 <tr><td>
	 
		 <table width="100%" class="navigation_table">		 		        	      		
								
				<cfquery name="org" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">			
					SELECT * FROM Organization.dbo.Organization WHERE OrgUnit = '#url.orgunit#'	
				</cfquery>									
								
				 <cfquery name="Period" 
						datasource="AppsPayroll"
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT    TOP 1 Mission, SalarySchedule, PayrollStart, PayrollEnd
							FROM      SalarySchedulePeriod
							WHERE     Mission = '#org.mission#' 
							AND       CalculationStatus IN ('0', '1', '2') 
							AND       SalarySchedule = '#form.salaryschedule#' 
				  </cfquery>	
							 
				 <CF_DateConvert Value="#dateformat(Period.PayrollStart,client.dateformatshow)#">
				 <cfset str = datevalue>
				 
				 <CF_DateConvert Value="#dateformat(Period.PayrollEnd,client.dateformatshow)#">
				 <cfset end = datevalue>
																		
				<!--- we check if the selection in the header 1 or more records in the table --->
				
				<cfif url.ajaxid neq "">
				
				     <!--- workflow edit / edit --->
								   					 
					 <cfquery name="Get" 
						datasource="AppsPayroll" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">							
							SELECT      OrgUnitActionId, OrgUnit, CalendarDateEnd,WorkAction as SalarySchedule,PayrollItem,EntitlementClass
							FROM        PersonMiscellaneous AS M INNER JOIN
							            Organization.dbo.OrganizationAction AS A ON M.SourceId = A.OrgUnitActionId
							WHERE       A.OrgUnitActionId     = '#url.ajaxid#' 										
					</cfquery>	
					
					<cfquery name="getPrior" 
						  datasource="AppsPayroll" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">				 
						    SELECT      OrgUnitActionId
							FROM        PersonMiscellaneous AS M INNER JOIN
							            Organization.dbo.OrganizationAction AS A ON M.SourceId = A.OrgUnitActionId
							WHERE       A.OrgUnit             = '#get.orgunit#' 
							AND         A.CalendarDateEnd     < '#get.CalendarDateEnd#'
							AND         A.WorkAction          = '#get.salaryschedule#'
							AND         M.PayrollItem         = '#get.payrollitem#'
							AND         M.EntitlementClass    = '#get.entitlementclass#'			 
							AND         M.Source              = 'Unit'			
					 </cfquery>				 
				
				<cfelse>
				
				    <!--- data entry screen --->
				
					<cfquery name="Get" 
						datasource="AppsPayroll" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">							
							SELECT      OrgUnitActionId
							FROM        PersonMiscellaneous AS M INNER JOIN
							            Organization.dbo.OrganizationAction AS A ON M.SourceId = A.OrgUnitActionId
							WHERE       A.OrgUnit             = '#url.orgunit#' 
							AND         A.CalendarDateEnd     = #end#
							AND         A.WorkAction          = '#form.salaryschedule#'
							AND         M.PayrollItem         = '#form.payrollitem#'
							AND         M.EntitlementClass    = '#form.entitlementclass#'			 
							AND         M.Source              = 'Unit'					
					</cfquery>	
					
					<cfquery name="getPrior" 
						  datasource="AppsPayroll" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">				 
						    SELECT      OrgUnitActionId
							FROM        PersonMiscellaneous AS M INNER JOIN
							            Organization.dbo.OrganizationAction AS A ON M.SourceId = A.OrgUnitActionId
							WHERE       A.OrgUnit             = '#url.orgunit#' 
							AND         A.CalendarDateEnd     < #end#
							AND         A.WorkAction          = '#form.salaryschedule#'
							AND         M.PayrollItem         = '#form.payrollitem#'
							AND         M.EntitlementClass    = '#form.entitlementclass#'			 
							AND         M.Source              = 'Unit'			
					 </cfquery>
									
				</cfif>
				
										 
				<cfquery name="getPersons" 
					  datasource="AppsEmployee" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					  SELECT  DISTINCT P.PersonNo, 
								    P.LastName, 
									P.ListingOrder,
									P.FirstName, 
									A.FunctionDescription, 
									A.LocationCode,
									P.IndexNo, 
									A.AssignmentNo, 
									A.DateEffective, 
									A.DateExpiration,
										
									(SELECT   TOP 1 ContractLevel
									 FROM     PersonContract
									 WHERE    PersonNo     = P.PersonNo
									 AND      Mission      = Pos.Mission
									 AND      ActionStatus IN ('0','1')
									 AND      DateEffective  <= #end#
									 AND      DateExpiration >= #str#
									 ORDER BY DateEffective DESC) as PersonGrade,
									 
									(SELECT   TOP 1 SalarySchedule
									 FROM     PersonContract
									 WHERE    PersonNo     = P.PersonNo
									 AND      Mission      = Pos.Mission
									 AND      ActionStatus IN ('0','1')
									 AND      DateEffective  <= #end#
									 AND      DateExpiration >= #str#
									 ORDER BY DateEffective DESC) as SalarySchedule
										 
					  FROM 	  Person P 
					          INNER JOIN PersonAssignment A ON P.PersonNo = A.PersonNo
							  INNER JOIN Position Pos ON A.PositionNo = Pos.PositionNo
								
					  WHERE   P.PersonNo = A.PersonNo
					  <!--- the unit of the operational assignment --->
					  AND     A.OrgUnit = '#url.orgunit#'
					  -- AND     A.Incumbency       > '0'
					  AND     A.AssignmentStatus IN ('0','1')
					  -- AND     A.AssignmentClass  = 'Regular'	<!--- not needed anymore as loaned people have leave as well --->		
					  AND     A.AssignmentType   = 'Actual'
					  AND     A.DateEffective   <= #end#
					  AND     A.DateExpiration  >= #str#
				</cfquery>	
				
				 
				 
				 <tr class="labelmedium2 line fixlengthlist">
				     <td style="padding-left:4px"><cf_tl id="IndexNo"></td>
					 <td><cf_tl id="FirstName"></td>
					 <td><cf_tl id="LastName"></td>
					 <td><cf_tl id="Function"></td>
					 <td><cf_tl id="Contract"></td>
					 <td align="right"><cf_tl id="Prior"></td>
					  <td style="min-width:80px"><cf_tl id="Reference"></td> 	 
					 <td align="right" style="width:90px"><cf_tl id="Amount"></td> 		
					
				 </tr>
				 
				 <cfoutput>
				 <input type="hidden" name="PersonNo" value="#ValueList(getPersons.PersonNo)#">
				 </cfoutput>
				 
				  <cfquery name="getStatus" 
					  datasource="AppsPayroll" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">				 
					     SELECT     MAX(Status) as Status
		  	             FROM       PersonMiscellaneous
		      	         WHERE      Source    = 'Unit' 
						 <cfif get.OrgUnitActionId neq "">
						 AND        SourceId  = '#get.OrgUnitActionId#' 
						 <cfelse>
						 AND        1=0
						 </cfif>
				 </cfquery>
								 
				 <cfoutput query="getPersons">
				 
				    <cfif PersonGrade neq "" and SalarySchedule eq form.SalarySchedule>
										
						<cfquery name="getAmountPrior" 
						  datasource="AppsPayroll" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">				 
						     SELECT     Amount, DocumentReference,Status
			  	             FROM       PersonMiscellaneous
			      	         WHERE      PersonNo = '#Personno#'
							 AND        Source    = 'Unit' 
							 <cfif getPrior.OrgUnitActionId neq "">
							 AND        SourceId  = '#getPrior.OrgUnitActionId#' 
							 <cfelse>
							 AND        1=0
							 </cfif>
						 </cfquery>
					
					    <cfquery name="getAmount" 
						  datasource="AppsPayroll" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">				 
						     SELECT     Amount, DocumentReference,Status
			  	             FROM       PersonMiscellaneous
			      	         WHERE      PersonNo = '#Personno#'
							 AND        Source    = 'Unit' 
							 <cfif get.OrgUnitActionId neq "">
							 AND        SourceId  = '#get.OrgUnitActionId#' 
							 <cfelse>
							 AND        1=0
							 </cfif>
						 </cfquery>
						
						 <tr class="labelmedium2 line navigation_row fixlengthlist">
						     <td style="padding-left:4px"><a href="javascript:EditPerson('#personno#')" tabindex="9999">#IndexNo#</a></td>
							 <td>#FirstName#</td>
							 <td>#LastName#</td>
							 <td>#FunctionDescription#</td>
							 <td>#PersonGrade#</td>
							 <td align="right">#numberFormat(getAmountPrior.Amount,',.__')#</td>
							 <cfif getStatus.status lt "3">
								 <td><input type="text" name="DocumentReference_#PersonNo#" value="#getAmount.DocumentReference#" maxlength="30" class="regularxl" style="width:100%;min-width:120px;border-bottom:0px;border-top:0px;background-color:##e1e1e180;padding-left:4px"></td>			 
								 <td><input type="text" class="regularxl" style="max-width:90px;min-width:80px;border-bottom:0px;border-top:0px;background-color:##e1e1e180;text-align:right;padding-right:4px" name="Amount_#PersonNo#" value="#numberFormat(getAmount.Amount,',.__')#"></td>			 								
							 <cfelse>								 	 
								 <td>#getAmount.DocumentReference#</td>			 							
								 <td align="right">#numberFormat(getAmount.Amount,',.__')#</td>		
							 </cfif>
							
						 </tr>	
					 
					 </cfif>		 
				 
				 </cfoutput>
				 
		 </table>	
	 
	 </td>
	 </tr>
	 
	 <cfoutput>
	 	 	 
	 <cfif getStatus.status lte "1">
 
		 <tr>
		 <td align="center" style="padding-top:5px">		 
		     <input type="button" 
			     style="width:200px" 
				 class="button10g" 
				 name="Submit" value="Submit" 
				 onclick="Prosis.busy('yes');_cf_loadingtexthtml='';ptoken.navigate('commissionSubmit.cfm?ajaxid=#get.OrgUnitActionId#&mission=#org.mission#&orgunit=#org.orgunit#','content','','','POST','MiscellaneousEntry')">
		 </td>
		 </tr>
		 
	 </cfif> 	 
	 
	 <cfif get.OrgUnitActionId neq "">
	 								
		 <tr><td style="padding-left:4px;padding-right:4px">			
				
			    <cfset url.ajaxid = get.OrgUnitActionId>
				<cfparam name="url.mid" default="">
				<cfset wflnk = "CommissionWorkflow.cfm">
				<input type="hidden" id="workflowlink_#url.ajaxid#" value="#wflnk#"> 
	            <cfdiv id="#url.ajaxid#"  bind="url:#wflnk#?ajaxid=#url.ajaxid#&mid=#url.mid#"/>
	
				<!---
				 <input type="hidden" 
				          id="workflowlinkprocess_#pk#" 
				          value="#wflnk#"> 
	  
	                --->
				
				</td>
		 </tr>	
	 
	 </cfif>
	 
	 </cfoutput>	 
			
</table>			

<cfset ajaxonload("doHighlight")>

<script>
	Prosis.busy('no')
</script>