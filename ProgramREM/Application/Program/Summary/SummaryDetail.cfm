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
<cfquery name="get" 
    datasource="AppsProgram" 
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT *
    FROM   Program
	WHERE  ProgramCode = '#url.programcode#'			 
</cfquery>

<cfquery name="missionperiod" 
    datasource="AppsOrganization" 
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_MissionPeriod
	WHERE  Mission         = '#get.Mission#'			 
	AND    PlanningPeriod  = '#url.period#'
	AND    isPlanPeriod = 1
</cfquery>

<cfquery name="Parameter" 
    datasource="AppsProgram" 
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_ParameterMission
	WHERE  Mission         = '#get.Mission#'			 	
</cfquery>

<cfquery name="getRequirement" 
    datasource="AppsProgram" 
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT    *
	FROM      ProgramAllotmentRequest
	WHERE     RequirementId IN
	              (SELECT   TOP 1 RequirementId
	               FROM     ProgramAllotmentRequest 
	               WHERE    ProgramCode = '#url.programcode#' 
				   AND      Period      = '#url.period#' 
				   AND      RequestType = 'Standard'
				   ORDER BY Created DESC)    
</cfquery>	

<cfquery name="getProgramPeriod" 
    datasource="AppsProgram" 
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT   *
    FROM     ProgramPeriod
	WHERE    ProgramCode = '#url.programcode#'			 
	AND      Period      = '#url.period#'
</cfquery>
	

<cfif getRequirement.recordcount eq "0">

	<table width="98%" border="0" align="center" >
		<tr class="line"><td class="line labelmedium" style="padding-top:10px;padding-bottom:10px" align="center"><font color="FF0000">View not supported as there are no financial requirements defined</td></tr>
	</table>

<cfelse>

	<cfset format = "png">	

	<table width="98%" border="0" align="center" class="formpadding">
		<tr class="clsNoPrint">
			<td colspan="2" align="right" style="padding-rigth:10px;">
				<cfoutput>
					<span id="printTitle" style="display:none;"><cf_tl id="Program Summary"></span>
					<cf_tl id="Print" var="1">
					<cf_button2 
						mode		= "icon"
						type		= "Print"
						title       = "#lt_text#" 
						id          = "Print"					
						height		= "20px"
						width		= "25px"
						imageHeight = "25px"
						printTitle	= "##printTitle"
						printContent = ".clsPrintContentSummary">
				</cfoutput>
			</td>
		</tr>
					
		<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
				
		<cfset vColorList = "##E85DA2,##5DE8D8,##CCCA6A,##339AFA,##66AC6A,##999A9A,##FFFA9A,##996AFA">			
		
		<cfquery name="getOE" 
		    datasource="AppsProgram" 
			username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    SELECT   R.Listingorder, R.Code, R.Description, O.Code as objectCode
		    FROM     Ref_Object O, Ref_Resource R
			WHERE    O.Resource = R.Code
		</cfquery> 
			
		<cfinvoke component      = "Service.Process.Program.Execution"  
			   method            = "Disbursement" 
			   period            = "'#period#'" 		  <!--- execution period --->		   
			   mission           = "#get.mission#"
			   Currency          = "#Parameter.BudgetCurrency#"
			   programhierarchy  = "#getProgramPeriod.PeriodHierarchy#"		  			  		    		  		   
			   ObjectParent      = "1"	  
			   mode              = "view"
			   transactionSource = "'AccountSeries','ReconcileSeries','Obligation'"
			   returnvariable    = "disbursement">			   
			   		   		  
				
		<cfquery name="gDisb" dbtype="query">
			SELECT 	 getOE.Code as Resource,
			         getOE.ListingOrder as ResourceOrder,
			         getOE.Description as ResourceName,
					 SUM(Disbursement.InvoiceAmount/1000) as Total
			FROM	 Disbursement, getOE
			WHERE	 Disbursement.ObjectCode = getOE.ObjectCode
			GROUP BY getOE.Code,
					 getOE.Description,
					 getOE.ListingOrder
			ORDER BY getOE.Listingorder						
		</cfquery>	  	
		
		<tr><td width="50%" style="padding-left:0px" class="labelmedium" valign="top">
		
			<cf_space spaces="100">
		
		    <table width="97%">
			
			<cfquery name="getReviewFlow" 
		    datasource="AppsProgram" 
			username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
				SELECT     TOP 1 OO.ObjectId
				FROM       ProgramPeriodReview AS P INNER JOIN
		                   Organization.dbo.OrganizationObject AS OO ON P.ReviewId = OO.ObjectKeyValue4
				WHERE      P.ProgramCode = '#url.ProgramCode#' 
				AND        P.Period      = '#url.Period#' 
				AND        P.ActionStatus = '3'
				ORDER BY   P.Created DESC
			</cfquery>
			
			<cfif getReviewFlow.recordcount gte "1">
			
				<cfquery name="getDocument" 
			    datasource="AppsOrganization" 
				username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				SELECT    R.DocumentType, 
				          R.DocumentCode, 
						  R.DocumentDescription, 
						  AD.DocumentPath, 
						  AD.OfficerUserId, 
						  AD.OfficerLastName, 
						  AD.OfficerFirstName, 
						  AD.Created
				FROM      OrganizationObjectActionReport AS AD INNER JOIN
		                  Ref_EntityDocument AS R ON AD.DocumentId = R.DocumentId
				WHERE     AD.ActionId =
		                          (SELECT    TOP 1 R.ActionId
		                            FROM     OrganizationObjectActionReport AS R INNER JOIN
		                                     OrganizationObjectAction AS A ON R.ActionId = A.ActionId
		                            WHERE    A.ObjectId = '#getReviewFlow.objectid#'
		                            ORDER BY A.ActionFlowOrder DESC)
				</cfquery>		
								
				<cfoutput query="getDocument">
				<tr class="line labelmedium">
				   <td><a href="#SESSION.rootDocument#\#getDocument.documentpath#" target="_blank"><font color="0080C0"><u>#documentdescription#</a></td>
				   <td style="padding-left:4px">#OfficerLastName# (#dateformat(created,client.dateformatshow)#)</td>
			     </tr>
				</cfoutput>
									
			</cfif>								
			
			<!--- obtain last requirement --->
				
			<cfoutput query="getRequirement">			
			<tr class="line"><td class="labelmedium"><cf_tl id="Last Requirement"></td>
			<td class="labelmedium">#OfficerLastName# (#dateformat(created,client.dateformatshow)#)</td>
			</tr>		
			</cfoutput>
					
			<!--- allotment --->
			
			<cfquery name="getAllotment" 
		    datasource="AppsProgram" 
			username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
				SELECT   PAA.ActionDate, 
				         PAA.Reference, 
						 PAA.Status, 
						 PAA.OfficerUserId, 
						 PAA.OfficerLastName, 
						 PAA.OfficerFirstName,
						 R.ListingOrder, 
						 R.Description, 
						 SUM(A.AmountBase) AS Amount
						 
				FROM     ProgramAllotmentDetail AS A INNER JOIN
		                 Ref_Object AS O ON A.ObjectCode = O.Code INNER JOIN
		                 Ref_Resource AS R ON O.Resource = R.Code INNER JOIN
		                 ProgramAllotmentAction AS PAA ON A.ActionId = PAA.ActionId
				WHERE    A.ActionId IN
		                          (SELECT     TOP 1 ActionId
		                            FROM      ProgramAllotmentAction
		                            WHERE     ProgramCode = '#url.ProgramCode#' 
									AND       Period      = '#url.period#' 
									AND       ActionClass = 'Transaction'
									AND       Status != '9'
									ORDER BY Created DESC)
								
				GROUP BY R.ListingOrder, 
				         R.Description, 
						 PAA.Status,
						 PAA.ActionDate, 
						 PAA.Reference, 
						 PAA.OfficerUserId, 
						 PAA.OfficerLastName, 
						 PAA.OfficerFirstName
				ORDER BY  ActionDate DESC			 
			</CFQUERY>		 
			
			<cfif getAllotment.recordcount gte "1">
			
			<cfoutput>
			<tr class="line"><td colspan="1" class="labelmedium"><cf_tl id="Last Issued Allotment"></td>
			<td class="labelmedium">#getAllotment.OfficerLastName# (#dateformat(getAllotment.ActionDate,client.dateformatshow)#)</td>
			</tr>
			<tr class="line labelmedium">
			   <td style="padding-left:4px;height:25px"><b>#getAllotment.Reference#:</td>
			   <td style="padding-left:4px"><cfif getAllotment.Status neq "3"><font color="FF0000">[Draft]</cfif></font></td>
		    </tr>		
			</cfoutput>
			
			<tr>
				<td colspan="2" style="padding-left:4px;padding-right:4px">
				<table width="100%" class="navigation_table">
				<cfoutput query="getAllotment">
				<tr class="labelmedium navigation_row line">
				
				<td style="padding-left:6px">#Description#</td>
				<td align="center">#application.baseCurrency#</td>
				<td align="right" style="padding-right:5px">#numberformat(amount,"__,__")#</td>			
				</tr>
				</cfoutput>
				</table>			
				</td>
			</tr>
			
			</cfif>
			
			<cfquery name="getOutput" 
		    datasource="AppsProgram" 
			username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
				SELECT     PA.ActivityDate, 
				           PA.ActivityDescription, 
						   PO.ActivityOutput, 
						   PO.ProgramCategory,
						   (SELECT Description FROM Ref_ProgramCategory WHERE Code = PO.ProgramCategory) as CategoryDescription,
	                          (SELECT    TOP 1 ProgressStatus
	                            FROM     ProgramActivityProgress
	                            WHERE    ProgramCode = PO.ProgramCode 
								AND      RecordStatus != '9' 
								AND      ActivityPeriod = PO.ActivityPeriod 
								AND      OutputId = PO.OutputId
	                            ORDER BY ProgressStatusDate DESC) AS Status
				FROM         ProgramActivity AS PA INNER JOIN
	                      ProgramActivityOutput AS PO ON PA.ProgramCode = PO.ProgramCode AND PA.ActivityPeriod = PO.ActivityPeriod AND PA.ActivityId = PO.ActivityId
				WHERE     PA.ProgramCode = '#url.programcode#' 
				AND       PA.ActivityPeriod = '#url.period#' 
				AND       PA.RecordStatus <> '9' 
				AND       PO.RecordStatus <> '9'
			</cfquery>	
			
			<cfif getOutput.recordcount gte "1">
			
			<tr><td class="labelmedium" style="padding-right:15px"><cf_space spaces="40"><cf_tl id="Progress Reported"></td></tr>
			
			<tr>	
				
				<td colspan="2" style="padding-left:20px;padding-right:15px">
					<table width="100%">
					<cfoutput query="getOutput">
					<tr class="labelit">
					    <td valign="top" style="padding-top:1px">#currentrow#.</td>
						<td style="padding-right:10px"><cfif CategoryDescription neq ""><b>#CategoryDescription#<br></b>&nbsp;</cfif>#ActivityOutput#</td>
						<td><cfif Status eq ""><cf_tl id="None"><cfelseif Status eq "1"><cf_tl id="Pending"><cfelseif Status eq "3"><cf_tl id="Completed"></cfif></td>
					</tr>		
					</cfoutput>
					</table>		
				</td>
			
			</tr>
			
			</cfif>
			
			</table>
			
			</td>	
			
			<cfif gDisb.recordcount gte "1">
								
			<td width="50%" rowspan="1" valign="top" align="right" style="padding-left:10px;border-left:1px solid silver">
			
			    <table width="100%" cellspacing="0" cellpadding="0">
				
				<tr><td bgcolor="fafafa" align="center" style="height:25px;border:1px solid gray;padding-left:14px" class="labelmedium"><cf_tl id="Expenditure"> by Resource</td></tr>
				
				<tr><td style="padding-top:10px">		
							
				<cfchart
			           format="png"
			           chartheight="180"
			           chartwidth="400"
			           seriesplacement="default"
			           font="Calibri"
			           fontsize="13"
			           labelformat="number"
			           tipstyle="mouseOver"
			           showmarkers="yes"
			           pieslicestyle="sliced"
			           style="#chartStyleFile#">
					
					<cfchartseries 
				   		type="bar"
			            query="gDisb"
		    	        itemcolumn="ResourceName"
		        	    valuecolumn="Total"
			            serieslabel="Expenditure"
					    colorlist="#vColorList#"
		        	    markerstyle="circle">
					</cfchartseries>
					
				</cfchart>
				
				</td></tr>	
				</table>
										
			</td>
			
			</cfif>
		
		</tr>
		
		<tr><td class="line" colspan="2"></td></tr>
		
		<tr>
			<td colspan="2" height="50%" style="padding-left:20px;padding-right:10px" class="labellarge">
						
				<cfoutput query="missionperiod">
	
					<cfset edi = "#missionperiod.EditionId#">
					
					<!--- <cfif missionperiod.EditionidAlternate neq "">
						<cfset edi = "'#missionperiod.EditionId#','#missionperiod.EditionidAlternate#'">
					<cfelse>
					    <cfset edi = "'#missionperiod.EditionId#'">
					</cfif>	 --->
					
													
					<!--- ------ create tables with budget------ --->	
					<cfinvoke component = "Service.Process.Program.Execution"  
						   method           = "Budget" 
						   period           = "#period#" 		  <!--- execution period --->
						   planningperiod   = "#url.period#"
						   mission          = "#get.mission#"
						   Currency         = "#Parameter.BudgetCurrency#"
						   programhierarchy = "#getProgramPeriod.PeriodHierarchy#"		  			  
						   Status           = "request" 	     		  
						   editionid        = "#edi#"	
						   ObjectParent     = "1"	  
						   mode             = "view"
						   returnvariable   = "requirement">	
						
						   
					<cfinvoke component = "Service.Process.Program.Execution"  
						   method           = "Budget" 
						   period           = "#period#" 		  <!--- execution period --->
						   planningperiod   = "#url.period#"
						   mission          = "#get.mission#"
						   Currency         = "#Parameter.BudgetCurrency#"
						   programhierarchy = "#getProgramPeriod.PeriodHierarchy#"		  			  
						   Status           = "1" 	     		  
						   editionid        = "#edi#"	
						   ObjectParent     = "1"	  
						   mode             = "view"
						   returnvariable   = "allotment">		
					   
					   <!---
					   <cfdump var="#allotment#">   
					   --->
						   
					<cfquery name="gReq" dbtype="query">
						SELECT 	 getOE.Code as Resource,
						         getOE.ListingOrder as ResourceOrder,
						         getOE.Description as ResourceName,
								 SUM(Requirement.Total/1000) as Total
						FROM	 Requirement, getOE
						WHERE	 Requirement.ObjectCode = getOE.ObjectCode
						GROUP BY getOE.Code,
								 getOE.Description,
								 getOE.ListingOrder
						ORDER BY getOE.Listingorder	
					</cfquery>
													
					<cfquery name="gAllot" dbtype="query">
						SELECT 	 getOE.Code as Resource,
						         getOE.ListingOrder as ResourceOrder,
						         getOE.Description as ResourceName,
								 SUM(Allotment.Total/1000) as Total
						FROM	 Allotment, getOE
						WHERE	 Allotment.ObjectCode = getOE.ObjectCode
						GROUP BY getOE.Code,
								 getOE.Description,
								 getOE.ListingOrder
						ORDER BY getOE.Listingorder					
					</cfquery>
					
					<table>
					<tr><td class="labelmedium">
					<table class="formpadding">
					<tr  class="labelmedium">
					<td style="font-size:25px;padding-right:10px">#URL.Period#</b></td>
					<td style="width:20px;border:1px solid gray" bgcolor="5DB7E8"></td>
					<td style="padding-left:5px;padding-right:10px">
					<cf_tl id="Budget">
					</td>
					<td style="width:20px;border:1px solid gray" bgcolor="E8875D"></td>
					<td style="padding-left:5px;padding-right:10px">
					<cf_tl id="Allotment">
					</td> 
					<td style="width:20px;border:1px solid gray" bgcolor="E8BC5D"></td>
					<td style="padding-left:5px;padding-right:10px">
					<cf_tl id="Expenditure">
					</td>
					
					<td class="clsNoPrint">	
										
					<!--- prepare a test case then we generalise a bit more --->	
					<cfset vTDate1 = createDate(1990,1,1)>
					<cfset vTDate2 = createDate(2050,12,31)>
					<cfset vTStringDate1 = dateformat(vTDate1, client.dateformatshow)>
					<cfset vTStringDate2 = dateformat(vTDate2, client.dateformatshow)>

					<cfset fields[1] = {criterianame = "entity",                      	criteriavalue = "#get.mission#" }>
					<cfset fields[2] = {criterianame = "periodedition",               	criteriavalue = "#missionperiod.EditionId#" }>  
					<cfset fields[3] = {criterianame = "periodedition_MISSIONPERIOD", 	criteriavalue = "#url.period#" }>
					<cfset fields[4] = {criterianame = "amount1000",                  	criteriavalue = "Yes" }>
					<cfset fields[5] = {criterianame = "hidezeroamount",              	criteriavalue = "'Yes'" }>
					<cfset fields[6] = {criterianame = "approvedbudget",              	criteriavalue = "'No'" }>
					<cfset fields[7] = {criterianame = "fund",              			criteriavalue = "''" }>					
					<cfset fields[8] = {criterianame = "PROGRAMGROUP",              	criteriavalue = "" }>
					<cfset fields[9] = {criterianame = "transactiondate",              criteriavalue = "'#vTStringDate1#'" }>
					<cfset fields[10] = {criterianame = "transactiondate_end",          criteriavalue = "'#vTStringDate2#'" }>
					<cfset fields[11] = {criterianame = "project",              		criteriavalue = "#getProgramPeriod.Reference#" }>
					<cfset fields[12] = {criterianame = "review",              			criteriavalue = "''" }>
					<cfset fields[13] = {criterianame = "orgunit",              		criteriavalue = "''" }>
					<cfset fields[14] = {criterianame = "orgunit_PPARENTORGUNIT",     	criteriavalue = "''" }>
					<cfset fields[15] = {criterianame = "orgunit_MANDATENO",           	criteriavalue = "''" }>
					<cfset fields[16] = {criterianame = "fundtotal",           			criteriavalue = "'0'" }>
					<cfset fields[17] = {criterianame = "grandtotal",           		criteriavalue = "'1'" }>
					<cfset fields[18] = {criterianame = "parenttotal",           		criteriavalue = "'0'" }>
						
					<cf_rptVariant SystemModule="Program" 
					               LayoutCode="DBE" 
								   ListCriteria="#fields#">
					
					</td>
					
					</tr></table>
					</td></tr>
					
					<tr><td>
					
					<cfloop query="gAllot">
					
						<cfquery name="check" dbtype="query">
							SELECT    *
							FROM      gReq
							WHERE     Resource = '#Resource#'								
						</cfquery>						
					
						<cfif check.recordcount eq "0">
							
							<cfset temp = queryaddrow(gReq, 1)>							
							<!--- set values in cells --->
							<cfset temp = querysetcell(gReq, "Resource", "#Resource#")>
							<cfset temp = querysetcell(gReq, "ResourceOrder", "#ResourceOrder#")>
							<cfset temp = querysetcell(gReq, "ResourceName", "#ResourceName#")>
							<cfset temp = querysetcell(gReq, "Total", "0")>
						
						</cfif>
						
						<cfquery name="check" dbtype="query">
							SELECT    *
							FROM      gDisb
							WHERE     Resource = '#Resource#'								
						</cfquery>						
					
						<cfif check.recordcount eq "0">
							
							<cfset temp = queryaddrow(gDisb, 1)>							
							<!--- set values in cells --->
							<cfset temp = querysetcell(gDisb, "Resource", "#Resource#")>
							<cfset temp = querysetcell(gDisb, "ResourceOrder", "#ResourceOrder#")>
							<cfset temp = querysetcell(gDisb, "ResourceName", "#ResourceName#")>
							<cfset temp = querysetcell(gDisb, "Total", "0")>
						
						</cfif>
								
					
					</cfloop>
					
					<cfif gAllot.recordcount gte "0">
																					
							<cfchart 
								style="#chartStyleFile#" 
								format="#format#"
						       	chartheight="170" 
							   	chartwidth="830"
								 font="Calibri"
					           fontsize="13">	
							
							   <cfif gReq.recordcount gte "1">
													   											
								   <cfchartseries 
								   		type="bar"
							            query="gReq"
										color="5DB7E8"
						    	        itemcolumn="ResourceName"
						        	    valuecolumn="Total"
							            serieslabel="Required"							    
						        	    markerstyle="circle">
										
									</cfchartseries>
								
								</cfif>
								
								<cfchartseries 
							   		type="bar"
						            query="gAllot"
									color="E8875D"
					    	        itemcolumn="ResourceName"
					        	    valuecolumn="Total"
						            serieslabel="Alloted"							    
					        	    markerstyle="circle">
									
								</cfchartseries>
								
								<cfif gDisb.recordcount gte "1">
								
									<cfchartseries 
								   		type="bar"
							            query="gDisb"
										color="E8BC5D"
						    	        itemcolumn="ResourceName"
						        	    valuecolumn="Total"
							            serieslabel="Expenditure"							    
						        	    markerstyle="circle">
										
									</cfchartseries>
								
								</cfif>
																 
						    </cfchart>
						
					</cfif>	
										   
				</cfoutput>	
				
				</td></tr>
					
				</table>
						
			</td>
		</tr>
		
		<tr><td class="line" colspan="2"></td></tr>
		
	</table>

</cfif>

<cfset ajaxonload("doHighlight")>
	