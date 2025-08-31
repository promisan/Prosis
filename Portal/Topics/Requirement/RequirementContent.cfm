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
<cfparam name="url.orgunit" default="">
<cfparam name="url.period"  default="">
<cfparam name="url.layout"  default="org">
<cfparam name="url.status"  default="">

<!--- ------------------------------------------- --->
<!--- ---------------- Hardcoded ---------------- --->
<!--- ------------------------------------------- --->

<cfquery name="new" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">	
		 SELECT * 
		 FROM   ItemMaster 
		 WHERE  BudgetOutputPointer = '2' 
</cfquery>

<cfquery name="con" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">	
		 SELECT * 
		 FROM   ItemMaster 
		 WHERE  BudgetOutputPointer = '3' 
</cfquery>	

<cfparam name="itemmaster_hr_new"       default="#quotedvaluelist(new.code)#">
<cfparam name="itemmaster_hr_continued" default="#quotedvaluelist(con.code)#">

<cfif url.orgunit neq "">

	<cfquery name="get" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">	
		 SELECT * 
		 FROM   Organization 
		 WHERE  OrgUnit = '#url.orgunit#' 
	</cfquery>
	
</cfif>

<!--- review cycle and year of the showing --->

<cfquery name="reviewcycle" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
		 SELECT * 
		 FROM   Ref_ReviewCycle 
		 WHERE  CycleId = '#url.reviewCycle#' 
</cfquery>

<cfset url.year = year(reviewCycle.DateBudgetEffective)>

<!--- get a base file from the component for a year --->
<cfset vMission = replace(url.mission, "-", "", "ALL")>
<cfset tbl = "#session.acc#_requirement_#vMission#">

<cftransaction isolation="READ_UNCOMMITTED">

<cfquery name="getBase" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">	 

	SELECT     Parent.ProgramCode  as ParentProgramCode,
			   Parent.ProgramName  as ParentProgramName,
			   Parent.ListingOrder as ParentListingOrder,
			   
			   LEFT(Pe.PeriodHierarchy, (CASE WHEN CHARINDEX('.', Pe.PeriodHierarchy) > 0 THEN CHARINDEX('.', Pe.PeriodHierarchy) - 1 ELSE 0 END)),
			   
			   PO.OrgUnit          as ParentOrgUnit,
			   PO.OrgUnitNameShort as ParentUnitNameShort, 
	           PO.OrgUnitName      as ParentUnitName, 
			   O.OrgUnit,
			   O.OrgUnitName, 
			   O.HierarchyCode,
			   P.ProgramName, 
			   
			   <!---
			   (SELECT name of action for a valid review cycle 			   
			   --->
			   			   
			   Pe.Reference, 
			   Pe.ProgramCode, 		   			   			   
			   Pe.Period,
			   			   
			    ( SELECT ISNULL(ROUND(SUM(RequestQuantity/12),1),0)
			     FROM   userquery.dbo.#tbl#
				 WHERE  ProgramCode = P.ProgramCode
				 AND    RequestYear = '#url.year#'
				 AND    ItemMaster IN (#preservesingleQuotes(itemmaster_hr_new)#)
				 ) as FTE_new,
				 
				  ( SELECT ISNULL(ROUND(CEILING(SUM(RequestQuantity/12.01)),1),0)
			     FROM   userquery.dbo.#tbl#
				 WHERE  ProgramCode = P.ProgramCode
				 AND    RequestYear = '#url.year#'
				 AND    ItemMaster IN (#preservesingleQuotes(itemmaster_hr_new)#)
				 ) as Staff_new, 
			   
			    ( SELECT ISNULL(ROUND(SUM(RequestAmountBase),2),0)
			     FROM   userquery.dbo.#tbl#
				 WHERE  ProgramCode = P.ProgramCode
				 AND    RequestYear = '#url.year#'
				 AND    ItemMaster IN (#preservesingleQuotes(itemmaster_hr_new)#)
				 ) as Cost_new,
				 
				  ( SELECT ISNULL(ROUND(SUM(RequestQuantity/12),1),0)
			     FROM   userquery.dbo.#tbl#
				 WHERE  ProgramCode = P.ProgramCode
				 AND    RequestYear = '#url.year#'
				 AND    ItemMaster IN (#preservesingleQuotes(itemmaster_hr_continued)#)
				 ) as FTE_continued,
				 
				   ( SELECT ISNULL(ROUND(CEILING(SUM(RequestQuantity/12.01)),1),0)
			     FROM   userquery.dbo.#tbl#
				 WHERE  ProgramCode = P.ProgramCode
				 AND    RequestYear = '#url.year#'
				 AND    ItemMaster IN (#preservesingleQuotes(itemmaster_hr_continued)#)
				 ) as Staff_continued, 
				  
				 ( SELECT ISNULL(ROUND(SUM(RequestAmountBase),2),0)
			     FROM   userquery.dbo.#tbl#
				 WHERE  ProgramCode = P.ProgramCode
				 AND    RequestYear = '#url.year#'
				 AND    ItemMaster IN (#preservesingleQuotes(itemmaster_hr_continued)#)
				  ) as Cost_continued,
				  
				 ( SELECT ISNULL(ROUND(SUM(RequestAmountBase),2),0)
			     FROM   userquery.dbo.#tbl#
				 WHERE  ProgramCode = P.ProgramCode
				 AND    RequestYear = '#url.year#'
				 AND    ItemMaster NOT IN (#preservesingleQuotes(itemmaster_hr_new)#,#preservesingleQuotes(itemmaster_hr_continued)#)
				 AND    ObjectCode IN (SELECT Code FROM Ref_Object WHERE Staffing = 1)
				  ) as Cost_other,  
							   
			   <!--- overall total which then defines the other costs --->
			   
			   <cfloop index="qtr" from="1" to="4">
			   
			     ( SELECT ISNULL(ROUND(SUM(RequestAmountBase),2),0)
			     FROM   userquery.dbo.#tbl#
				 WHERE  ProgramCode = P.ProgramCode
				 AND    RequestYear = '#url.year#'
				 AND    RequestQuarter = '#qtr#' ) as Cost_#qtr#,			   
			   
			   </cfloop>
			   
			   ( SELECT ISNULL(ROUND(SUM(RequestAmountBase),2),0)
			     FROM   userquery.dbo.#tbl#
				 WHERE  ProgramCode = P.ProgramCode
				 AND    RequestYear = '#url.year#' ) as Cost_total						   							
								
	FROM       Program AS P INNER JOIN
	           ProgramPeriod AS Pe ON P.ProgramCode = Pe.ProgramCode INNER JOIN
	           Organization.dbo.Organization AS O ON Pe.OrgUnit = O.OrgUnit INNER JOIN
	           Organization.dbo.Organization AS PO ON O.Mission = PO.Mission AND O.MandateNo = PO.MandateNo AND O.HierarchyRootUnit = PO.OrgUnitCode INNER JOIN
			   
			   <!--- we link the compoments to the master program as defined for this period --->
			   <!--- Program AS Parent ON LEFT(P.ProgramHierarchy, CHARINDEX('.', P.ProgramHierarchy) - 1)  = Parent.ProgramHierarchy --->		
			   ProgramPeriod AS PeParent ON PeParent.Period = Pe.Period AND LEFT(Pe.PeriodHierarchy, (CASE WHEN CHARINDEX('.', Pe.PeriodHierarchy) > 0 THEN CHARINDEX('.', Pe.PeriodHierarchy) - 1 ELSE 1 END)) = PeParent.PeriodHierarchy	INNER JOIN
			   Program as Parent ON PeParent.ProgramCode = Parent.ProgramCode
			   
   
    <!--- review status has reached a value that is used for --->			   	
	
	WHERE      EXISTS (SELECT 'X' 
	                   FROM   ProgramPeriodReview 
					   WHERE  ProgramCode = P.ProgramCode 
					   AND    Period = Pe.Period 
					   AND    ReviewCycleId = '#url.reviewcycle#'
					   <cfif url.status neq "">
					   AND    ActionStatus = '#url.status#'
					   <cfelse>
					   AND    ActionStatus <= '3'
					   </cfif>
					   <!---
					   AND    ActionStatus >= '#url.status#' AND ActionStatus <= '3'
					   --->
					   ) 

    <!--- selected plan period --->							  
	AND        Pe.Period = '#url.period#' 
	
	<!--- program is valid for the period --->
	AND        Pe.RecordStatus <> '9'	
	
	<cfif url.orgUnit neq "">
	<!--- parent orgunit filter --->	
	AND        PO.MissionOrgUnitId IN (SELECT MissionOrgUnitId FROM Organization.dbo.Organization WHERE OrgUnit = '#url.orgunit#') 
	</cfif>
	<cfif url.layout eq "org">
	ORDER BY   PO.HierarchyCode, PO.OrgUnit, O.HierarchyCode, O.OrgUnit
	<cfelse>
	ORDER BY   Parent.ListingOrder, PO.OrgUnit, O.HierarchyCode, O.OrgUnit
	</cfif>

</cfquery>

</cftransaction>

<cfif url.layout eq "org">
	<cfset group = "ParentOrgUnit">
<cfelse>
	<cfset group = "ParentProgramCode">
</cfif>		

<cfif getBase.recordcount lt "1">
	<table align="center"><tr><td style="height:50px" class="labelmedium">No information found to be shown.</td></tr></table>		
	<cfabort>
</cfif>

<style>

td.mycell {
	padding-right:3px; 
	padding-left:1px; 
	border-left:1px solid #EDEDED;
 }
 
td.mycellN {
	padding-right:5px; 
	padding-left:1px; 
	border-left:1px solid #EDEDED;
 }

</style>

<table width="100%">

<tr>
		
	<!--- summary table --->
	
	<td width="100%" valign="top">
			
		<cfset vProjectStyle 		= "border-right:1px solid ##C0C0C0;">
		<cfset vNewColor 			= "FFFF00">
		<cfset vNewColor1			= "yellow">
		<cfset vContinueColor 	    = "80FF80">
		<cfset vContinueColor1	    = "green">
		<cfset vOtherColor 			= "B0B0B0">
		<cfset vTotalColor			= "6688aa">
		<cfset vQColor				= "FF8040">
		
		<cfset vDivisionStyleDetail = "padding-right:2px; padding-left:2px; border-right:1px solid ##C0C0C0;">				
		
		<!--- querydata --->
		
		<cfsavecontent variable="myquery">
		     <cfoutput>
			 SELECT count(*)             as Total,
			        SUM(FTE_New)         as FTE_New,
					SUM(Staff_New)       as Staff_New,
			 	    SUM(Cost_new)        as Cost_new,
					SUM(FTE_continued)   as FTE_continued,
					SUM(Staff_continued) as Staff_continued,
					SUM(Cost_continued)  as Cost_continued,										
					<cfloop index="qtr" from="1" to="4">
					SUM(Cost_#qtr#)      as Cost_#qtr#,
					</cfloop>
					SUM(Cost_total)      as Cost_total															  
		    FROM    getBase		
			</cfoutput>
		</cfsavecontent>	
					
		<cf_tl id="Click to drilldown" var="trMessage">
		
		<cfif getBase.recordcount gte "40">
			<cfset ht = "500">
		<cfelse>
			<cfset ht = "450">
		</cfif>	
		
		<cf_divscroll id="requirementMainContainer" width="100%" height="#ht#">
		
			<table width="98%" class="navigation_table" cellpadding="0" cellspacing="0">
			
			    <!--- header --->
				
				<cfoutput>				
				
				<!--- top line --->
				<tr style="height:20px">
					<td></td>
					<td></td>
					<td width="10%" colspan="3" bgcolor="#vNewColor#" class="labelmedium2" align="center" 
					   style="border-bottom:1px solid silver;height:25px;padding-left:3px;padding-right:3px;border-top-left-radius:8px"><cf_tl id="New"></td>
					<td width="10%" colspan="3" bgcolor="#vContinueColor#" class="labelmedium2" align="center" 
					   style="border-bottom:1px solid silver;padding-left:3px;padding-right:3px;border-top-right-radius:8px"><cf_tl id="Continuation"></td>
					<td colspan="6" style="border-bottom:1px solid ##C0C0C0;"></td>
				</tr>
				<!--- second line --->
				<tr class="labelmedium2 line fixlengthlist" style="height:30px;filter:alpha(opacity=95); -moz-opacity:0.95; -webkit-opacity:0.95; opacity:0.95;">
					<td colspan="2" style="padding-left:10px;"></td>		
					<td align="right" bgcolor="#vNewColor#" class="mycell"  style="min-width:50px"><cf_tl id="Staff"></td>							
					<td align="right" bgcolor="#vNewColor#" class="mycell"  style="min-width:50px"><cf_tl id="FTE"></td>					
					<td align="right" class="mycell"  bgcolor="#vNewColor#"  style="min-width:50px"><cf_tl id="Cost"></td>		
					<td align="right" class="mycell"  bgcolor="#vContinueColor#" style="min-width:50px"><cf_tl id="Staff"></td>			
					<td align="right" class="mycell"  bgcolor="#vContinueColor#" style="min-width:50px"><cf_tl id="FTE"></td>					
					<td align="right" class="mycell"  bgcolor="#vContinueColor#" style="min-width:50px"><cf_tl id="Cost"></td>					
					<td align="right" class="mycell"  bgcolor="#vOtherColor#"    style="min-width:50px"><cf_tl id="Other"></td>					
					<td align="right" class="mycell"  bgcolor="#vTotalColor#"    style="min-width:60px"><cf_tl id="Total"></td>		
					<cfloop index="qtr" from="1" to="4">			
					<td align="right" class="mycell"  bgcolor="#vQColor#" style="padding-right:3px;min-width:60px"> <cf_space spaces="14"><cf_tl id="Q#qtr#"></td>
					</cfloop>					
				</tr>													
				<!--- overall total --->				
				
				<cfquery name="qSum" dbtype="query">
					   #preserveSingleQuotes(myQuery)#					
			  	</cfquery>		
								
				<tr class="line" style="filter:alpha(opacity=88); -moz-opacity:0.88; -webkit-opacity:0.88; opacity:0.88;">
					<td width="100%" class="labelmedium2" height="30px" style="height:28px;font-size:17px"><cf_tl id="Overall total">#url.year#</td>										
					<td class="labelit mycellN" style="padding-left:8px;font-weight:bold; padding-right:2px;"><b>#qSum.total#</td>		
					<cfset scope = "total">
					<cfinclude template="RequirementContentCell.cfm">																	
				</tr>				
																				
				</cfoutput>
								
				<cfoutput query="getBase" group="#group#">
																																	
					<cfif url.orgunit eq "">					
					
						<!--- group level : parent unit or parent program --->					
						<cfquery name="qSum" dbtype="query">						
							    #preserveSingleQuotes(myQuery)#		
								<cfif url.layout eq "org">									
								WHERE	ParentOrgUnit = #parentorgunit#
								<cfelse>
								WHERE   ParentProgramCode = '#parentprogramcode#' 
								</cfif>
					  	</cfquery>	
						
						<cfif qSum.recordcount gte "1">
										
						<tr class="line navigation_row" 
							style="filter:alpha(opacity=80); -moz-opacity:0.80; -webkit-opacity:0.80 opacity:0.80;">
							
							<td colspan="1" class="labelmedium2 fixlength" style="padding-left:2px; font-size:17px; height:30px;font-weight:bold;">
							   <cfif url.layout eq "org"><cfif ParentUnitNameShort neq "">#ParentUnitNameShort#<cfelse>#ParentUnitName#</cfif><cfelse>#ParentProgramName#</cfif>									
							</td>							
							<td style="padding-left:8px;font-size:17px;" align="right" class="labelmedium2 mycellN" ><b>#qSum.total#</td>	
							<cfset scope = "total">	
							<cfinclude template="RequirementContentCell.cfm">	
						</tr>							
												
						</cfif>
					
					</cfif>		
																				
					<cfoutput group="orgUnit">
										
						<!--- orgunit level --->	
						<cfquery name="qSum" dbtype="query">
							   	#preserveSingleQuotes(myQuery)#	WHERE OrgUnit = #orgUnit#
					  	</cfquery>		
																
						<tr class="clsDetail_#ParentOrgUnit# navigation_row line" 
							style="cursor:pointer; filter:alpha(opacity=70); -moz-opacity:0.70; -webkit-opacity:0.70; opacity:0.70;" 
							title="#trMessage# #OrgUnitName#" 
							onclick="if($('.clsDetailChild_#OrgUnit#').is(':visible')){ $('.clsDetailChild_#OrgUnit#').css('display','none'); $('##twistie_#OrgUnit#').attr('src','#session.root#/images/arrowright.gif'); }else{ $('.clsDetailChild_#OrgUnit#').css('display',''); $('##twistie_#OrgUnit#').attr('src','#session.root#/images/arrowdown3.gif'); }">
								<td style="padding-left:#len(hierarchyCode)*4#px;" class="labelit" bgcolor="f1f1f1">								
									<table>
										<tr>
											<td class="labelmedium">
												<cfset vShowTwistie = "#session.root#/images/arrowright.gif">
												<cfif url.orgUnit neq "">
													<cfset vShowTwistie = "#session.root#/images/arrowdown3.gif">
												</cfif>
												<img id="twistie_#OrgUnit#" src="#vShowTwistie#">
											</td>
											<td class="fixlength labelmedium" style="padding-left:7px;">#OrgUnitName#</td>
										</tr>
									</table>
								</td>								
								<td class="mycellN labelmedium2" style="padding-left:8px;"  align="right" id="count_total_Org_#OrgUnit#"><b>#qSum.total#</td>	
								<cfset scope = "total">														
								<cfinclude template="RequirementContentCell.cfm">								
								
						</tr>					
						
						<cfoutput>	
						
							<cfset vShowLines = "">
							<cfif url.orgUnit eq "">
								<cfset vShowLines = "display:none;">
							</cfif>
											
							<!--- project/component level --->						
							<tr class="line labelmedium navigation_row clsDetailChild_#orgUnit# clsDetail_#evaluate(group)#" 
								style="#vShowLines#" title="#ProgramName#">							
									<td class="fixlength" style="padding-left:#10+len(hierarchyCode)*4+7#px;padding-right:5px">
									<a class="navigation_action" href="javascript:EditProgram('#ProgramCode#','#Period#','Project')">#Reference#</a> #ProgramName#</td>
									
									<td></td>
									<cfset scope = "detail">
									<cfinclude template="RequirementContentCell.cfm">									
							</tr>														
						</cfoutput>												
						
					</cfoutput>						
					
				</cfoutput>
				
			</table>
			
		</cf_divscroll>	
		
	</td>
		
	<!--- Graph --->	
	
	<td style="display:none;" valign="top" align="center" class="clsGraphProjectRequirementContainer clsNoPrint">
	
	 <cf_space spaces="100">
	
	  <table cellspacing="0" cellpadding="0">	 
	  <tr><td align="center" style="padding-top:21px;padding-left:20px">
	  
	  <table class="formspacing">
	  
	  <cfoutput>
	  
		  <tr>
		  <td bgcolor="#vNewColor#" style="width:20px;height:20px;border:1px solid gray"></td>
		  <td class="labelit" style="padding-left:3px;padding-right:6px">Staff NEW</td>	 
		  <td bgcolor="#vContinueColor#" style="width:20px;height:20px;border:1px solid gray"></td>
		  <td class="labelit" style="padding-left:3px;padding-right:6px">Staff CONTINUE</td>
		  </tr>
		  
		  <tr>
		  <td class="labelit" bgcolor="silver" style="width:20px;height:20px;border:1px solid gray"></td>
		  <td class="labelit" style="padding-left:3px;padding-right:6px">Staff OTHER</td>
		  <td bgcolor="#vOtherColor#" style="width:20px;height:20px;border:1px solid gray"></td>
		  <td style="padding-left:3px;padding-right:6px" class="labelit">Operations</td>
		  </tr>
	  
	  </cfoutput>
	  
	  </table>
	  
	  </td></tr>
	 
 	  <tr><td>
				  
	  <cfquery name="Summary" dbtype="query">
		    SELECT     SUM(Cost_new/1000) as Cost_New, 		          				 
					   SUM(Cost_continued/1000) as Cost_Continued,
					   SUM(Cost_other/1000) as Cost_Other,
					   SUM(Cost_total/1000) as Cost_total					  
		    FROM       getBase				    	    
	  </cfquery>	
	
	  <cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
	  
		<cfchart style = "#chartStyleFile#" format="png"
		       chartheight="470" 
			   chartwidth="420" 
		       showygridlines="yes"		   
		       seriesplacement="default"	
			   showlegend="No"  
		       show3d="no"
			   fontsize="14"
			   font="Calibri"		   		  
			   tipstyle="mouseOver"
		       tipbgcolor="E9E9D1"
			   pieslicestyle="solid"
			   showxgridlines="yes"
		       sortxaxis="no">	
		   
		   <cfchartseries type="pie" colorlist="#vNewColor1#,#vContinueColor1#,silver,#vOtherColor#" datalabelstyle="value">
		   
		       <cfset other = summary.Cost_Total - summary.Cost_Continued - summary.Cost_new - summary.Cost_other>								
			   <cfchartdata item="HR New" value="#numberformat(summary.Cost_new,'_._')#"></cfchartdata>
			   <cfchartdata item="HR Continued" value="#numberformat(summary.Cost_continued,'_._')#"></cfchartdata>
			   <cfchartdata item="HR Other" value="#numberformat(summary.Cost_other,'_._')#"></cfchartdata>
			   <cfchartdata item="Total" value="#numberformat(Other,'_._')#"></cfchartdata>	
			   		   
			 </cfchartseries>  
				 
		</cfchart>
		
		</td></tr></table>
	
	</td>
	
	<cfoutput>
	<cf_tl id="Toggle Graph" var="1">
	<td align="center" class="clsNoPrint" style="width:50px; background-color:##EDEDED; cursor:pointer;" title="#lt_text#" 
	   onclick="$('.clsGraphProjectRequirementContainer').toggle(); if($('.clsGraphProjectRequirementContainer').is(':visible')){ $('.twistieGraphProjectRequirement').attr('src','#session.root#/Images/HTML5/Gray/right.png'); }else{ $('.twistieGraphProjectRequirement').attr('src','#session.root#/Images/HTML5/Gray/left.png'); };">
		<img class="twistieGraphProjectRequirement" src="#session.root#/Images/HTML5/Gray/left.png" height="25px">
	</td>
	</cfoutput>
	
</tr>

</table>

<cfset AjaxOnLoad("doHighlight")>

