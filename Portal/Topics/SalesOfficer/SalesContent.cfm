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
<cfset mission = "">

<cfloop index="itm" list="#url.mission#" delimiters="__">

	<cfif mission eq "">
		<cfset mission = "'#itm#'">
	<cfelse>
		<cfset mission = "#mission#,'#itm#'">
	</cfif>	
	
</cfloop>

<cfparam name="url.orgunit" default="">

<cfif url.orgunit eq "0">
	<cfset unit = "">
<cfelse>
	<cfset unit = url.orgunit>	
</cfif>

<cfparam name="url.period"  default="">
<cfparam name="url.actor"   default="">
<cfparam name="url.layout"  default="Store">
<cfparam name="url.sort"    default="Margin">
<cfparam name="url.stage"   default="Pending">

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

<cfquery name="check" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	    SELECT     TOP 1 *			   
	    FROM       ItemTransactionShipping	
		WHERE      SalesPersonNo = '#url.actor#'			
</cfquery>	

<cfif check.recordcount eq "0">
	<cfset user = "">
<cfelse>
	<cfset user = url.actor>
</cfif>

<cfquery name="base" 
	     datasource="AppsMaterials" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">	
		 
		SELECT      T.Mission,
		            TS.SalesPersonNo,
		            MONTH(T.TransactionDate) AS TransactionMonth, 
					YEAR(T.TransactionDate)  AS TransactionYear, 
		            T.Warehouse, 
					(SELECT WarehouseName FROM Warehouse WHERE Warehouse = T.Warehouse) as WarehouseName,
					<!---
					 <cfif unit neq "">
		           P.OrgUnit, 
				   P.OrgUnitName, 
				   </cfif>
				   --->
					TS.PriceSchedule,
					(SELECT Description FROM Ref_PriceSchedule WHERE Code = TS.PriceSchedule) as PriceScheduleName,
					T.ItemCategory, 
					R.Description, 
					
					<cfif url.sort eq "Margin">
					   ROUND(SUM(TS.SalesBaseAmount+T.TransactionValue), 0) AS Total		
					<cfelseif url.sort eq "Sales">
					   ROUND(SUM(TS.SalesBaseAmount), 0) AS Total
					<cfelse>
					   COUNT(DISTINCT TransactionBatchNo) AS Total
					</cfif>
					
	    FROM        ItemTransaction AS T INNER JOIN
	                ItemTransactionShipping AS TS ON T.TransactionId = TS.TransactionId INNER JOIN
	                Ref_Category AS R ON T.ItemCategory = R.Category
				<!---	
					 <cfif Unit neq "">			   
			   INNER JOIN     Organization.dbo.Organization AS O ON Sub.OrgUnit = O.OrgUnit 
			   INNER JOIN     Organization.dbo.Organization AS P ON O.Mission = P.Mission AND O.MandateNo = P.MandateNo AND O.HierarchyRootUnit = P.OrgUnitCode						  
				</cfif>			
				--->
		WHERE    Mission IN (#preserveSingleQuotes(mission)#)
		<cfif user neq "">
		AND      SalesPersonNo = '#user#' 
		</cfif>					
	   
		AND      T.TransactionType = '2' 
			
		<cfif url.period eq "All">
			AND    YEAR(T.TransactionDate) >= '2015'
		<cfelse>
			AND    YEAR(T.TransactionDate)  = '#url.period#' 	
		</cfif>
		
		<!--- settle stage 
		<cfif url.stage eq "">
		<cfelseif url.stage eq "pending">
		AND        ActionStatus < '3'	
		<cfelse>
		AND        ActionStatus = '3'
		</cfif>
		--->
		
		<!---
		<cfif Unit neq "">
		AND    P.OrgUnit = '#url.orgunit#' 
		</cfif>		
		--->	
		
	    GROUP BY    T.Mission, T.Warehouse, T.ItemCategory, YEAR(T.TransactionDate), MONTH(T.TransactionDate), R.Description, TS.SalesPersonNo, TS.PriceSchedule
	    ORDER BY    TransactionMonth, T.Warehouse, T.ItemCategory	 		
	
</cfquery>

<table width="100%" height="100%"  class="navigation_table" id="SalesOfficerMainContainer">

<tr>
					
	<td width="250" valign="top" style="height:150px;padding-top:8px">
	
	  <table height="100%" border="0">
	 
	 	  <tr><td valign="top" style="padding-top:7px;">
		  
		  	<table>
			
			  <cf_uichart style="border:0px solid silver">			
			 		  				  
				  <cfquery name="SummaryStore" dbtype="query">
					    SELECT     Warehouse      as FieldRow, 
						           WarehouseName  as FieldRowName, 									           				 
								   SUM(Total)     as Amount					   
					    FROM       Base		
						<cfif user neq "">
						WHERE      SalesPersonNo = '#user#'
						</cfif>						
					    GROUP BY   Warehouse,WarehouseName    
						ORDER BY   Description
				  </cfquery>				  
			  		
					<cfquery name="SummarySchedule" dbtype="query">
					
				        SELECT     PriceSchedule     as FieldRow, 
						           PriceScheduleName as FieldRowName, 								   
								   SUM(Total)        as Amount	
					    FROM       Base		
						<cfif user neq "">
						WHERE      SalesPersonNo = '#user#'
						</cfif>					
					    GROUP BY   PriceSchedule, 
						           PriceScheduleName 
					</cfquery>			
								
					<cfquery name="SummaryCategory" dbtype="query">
					  
				        SELECT     ItemCategory     as FieldRow, 
						           Description      as FieldRowName, 								   
								   SUM(Total)       as Amount	
					    FROM       Base		
						<cfif user neq "">
						WHERE      SalesPersonNo = '#user#'
						</cfif>					
					    GROUP BY   ItemCategory, 
						           Description
						ORDER BY Amount DESC		  
								   
					</cfquery>	
				  					
				
			  <cfset vColorlist = "##D24D57,##52B3D9,##E08283,##E87E04,##81CFE0,##2ABB9B,##5C97BF,##9B59B6,##E08283,##663399,##4DAF7C,##87D37C">
			  <cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
			  
			  <cf_assignid>
			  	  

			  <cfif 1 eq 1>
			  
			  		<tr>
			  
			  		<td valign="top">

					<cf_uichart name="divSalesOfficerGraph_#divname#1"
								chartheight="160"
								chartwidth="470"
								url="javascript:alert($ITEMLABEL$)">
						<cf_uichartseries type="pie"
						    query="#SummaryStore#" 
							itemcolumn="FieldRowName" 
							valuecolumn="Amount" 
							colorlist="#vColorList#"/>
				  	</cf_uichart>
					
					</td>
					
					<td rowspan="2" style="padding-left:30px">

					<cf_uichart name="divSalesOfficerGraph_#divname#3"
						chartheight="340"
						showlabel="No"
						showvalue="No"
						fontsize="10"
						chartwidth="620">
								
						<cf_uichartseries type="bar"
						    query="#SummaryCategory#" 
							itemcolumn="FieldRowName" 
							valuecolumn="Amount" 
							colorlist="##E87E04"/>
							
				  	</cf_uichart>
										
					</td>
					
					</tr>
					
					<tr>
					
					<td valign="top">
					<cf_uichart name="divSalesOfficerGraph_#divname#2"
								chartheight="160"
								chartwidth="470">
						<cf_uichartseries type="pie"
						    query="#SummarySchedule#" 
							itemcolumn="FieldRowName" 
							valuecolumn="Amount" 
							colorlist="#vColorList#"/>
				  	</cf_uichart>
					
					</td>
					
					</tr>

			  <cfelse>

				  <cfchart style = "#chartStyleFile#"
						   format="jpg"
						   chartheight="380"
						   chartwidth="930"
						   seriesplacement="percent"						   
						   show3d="No"
						   fontsize="12"
						   scaleFrom = "0"
						   showlegend="no"
						   showxgridlines="yes"
						   sortxaxis="yes">

						   <cfchartseries
							 type="pie"
							 query="Summary"
							 itemcolumn="FieldRowName"
							 valuecolumn="Amount"
							 datalabelstyle="columnlabel"
							 seriescolor = "EB974E"
							 colorlist="#vColorlist#"/>
							
					</cfchart>

			  </cfif>
				
				</td>
				
				<td>	
				
				 <!---		
				
				 <cfquery name="Summary" dbtype="query">
					    SELECT     Source,							            				 
								   SUM(Actions) as Counted					   
					    FROM       Base		
						<cfif user neq "">
						WHERE      Actor = '#user#'
						</cfif>						
					    GROUP BY   Source   
						ORDER BY   Source
				 </cfquery>	
				
				 <cfchart style = "#chartStyleFile#" 
				       format="png"
				       chartheight="300" 
					   chartwidth="350"    			  
				       seriesplacement="default"	 
					   showborder="No"
					   show3d="no"
					   fontsize="12" 
					   scaleFrom = "0"  					   
					   showlegend="no"
					   pieslicestyle="solid"
					   showxgridlines="yes"
				       sortxaxis="yes">															
						 
						  <cfchartseries
				             type="bar"
				             query="Summary"				 
				             itemcolumn="Source"
				             valuecolumn="Counted"						 
				             serieslabel="Events by Source"						
							 seriescolor = "EB974E" 				 			 
						     colorlist="#vColorlist#"/>		 
						 
				</cfchart>	
				
				--->
				
				</td></tr></table>
										
		</td></tr>
		</table>
	
	</td>
	
	</tr>
		
	<cfif url.stage eq "">
		<cfset width = "29">
	<cfelse>
		<cfset width = "50">	
	</cfif>
				
	<tr>
									
		<!--- summary table --->
				
		<cfif url.layout eq "Store">
	
			<cfquery name="getList" dbtype="query">
		        SELECT     Warehouse          as FieldRow, 
				           WarehouseName      as FieldRowName, 
						   TransactionYear    as EventYear,
						   TransactionMonth   as EventMonth,
						   SUM(Total)         as Amount	
			    FROM       Base		
				<cfif user neq "">
				WHERE      SalesPersonNo = '#user#'
				</cfif>					
			    GROUP BY   Warehouse, 
				           WarehouseName, 			
						   TransactionYear,			    
						   TransactionMonth   
			</cfquery>	
			
		<cfelseif url.layout eq "PriceSchedule">	
		
			<cfquery name="getList" dbtype="query">
			
		        SELECT     PriceSchedule      as FieldRow, 
				           PriceScheduleName  as FieldRowName, 
						   TransactionYear    as EventYear,
						   TransactionMonth   as EventMonth,
						   SUM(Total)         as Amount	
			    FROM       Base		
				<cfif user neq "">
				WHERE      SalesPersonNo = '#user#'
				</cfif>					
			    GROUP BY   PriceSchedule, 
				           PriceScheduleName, 			
						   TransactionYear,			    
						   TransactionMonth   
			</cfquery>	
		
		<cfelse>
				
			<cfquery name="getList" dbtype="query">
		        SELECT     ItemCategory       as FieldRow, 
				           Description        as FieldRowName, 
						   TransactionYear    as EventYear,
						   TransactionMonth   as EventMonth,
						   SUM(Total)         as Amount	
			    FROM       Base		
				<cfif user neq "">
				WHERE      SalesPersonNo = '#user#'
				</cfif>					
			    GROUP BY   ItemCategory, 
				           Description, 	
						   EventYear,					    
						   TransactionMonth   
				ORDER BY Amount DESC		   
			</cfquery>	
		
		</cfif>
					
		<td valign="top" style="border-left:1px solid silver;border-bottom:1px solid silver;border-top:1px solid silver">
			
			<table width="97%" height="100%">
			
			<cfif base.recordcount gte "800">
			
				<cfoutput>
				<tr class="line">
				  <td colspan="27" style="padding-left:4px" align="left" class="labelit clsNoPrint" style="cursor:pointer;padding-right:10px" onclick="loadmodule('#session.root#/Staffing/Reporting/ActionLog/EventListing.cfm','#base.mission#','header=1','')">
				  	<a><cf_tl id="Open"><cf_tl id="listing"></a>
				  </td>		  
				  </tr>
				</cfoutput>
			  
			</cfif>
									
			<cfoutput>	
					
			<tr class="labelmedium fixlengthlist fixrow">
								
				<td style="padding-left:5px;width:100%;border-bottom:1px solid silver"><cf_tl id="Classification"></td>		
				<cfloop index="mth" from="1" to="12">
				<td colspan="<cfif url.stage eq "">2<cfelse>1</cfif>" style="min-width:#width#px;border-bottom:1px solid silver;border-left:1px solid silver;<cfif mth eq 12>border-right:0px solid silver</cfif>" 
				    align="center">#left(monthasstring(mth),3)#</td>
				</cfloop>			
				<td align="center" style="min-width:#width#px;border-bottom:1px solid silver;border-left:1px solid silver;<cfif mth eq 12>border-right:0px solid silver</cfif>" colspan="2"><cf_tl id="Total"></td>
			
			</tr>
			
			<cfif url.stage eq "">
			
			<tr class="labelmedium line" bgcolor="f4f4f4" style="height:10px">
			
				<td style="width:100%"></td>	
											
				<cfloop index="mth" from="1" to="12">	
				    <cfif url.stage eq "">		
					<td align="center" bgcolor="yellow" style="font-size:10px;min-width:#width#px;border-left:1px solid silver">P</td>
					<td align="center" bgcolor="B9F4C4" style="font-size:10px;min-width:#width#px;border-left:1px solid silver">C</td>					
					<cfelseif url.stage eq "Pending">
					<td align="center" bgcolor="yellow" style="font-size:10px;min-width:#width#px;border-left:1px solid silver">P</td>					
					<cfelse>				
					<td align="center" bgcolor="B9F4C4" style="font-size:10px;min-width:#width#px;border-left:1px solid silver">C</td>	
					</cfif>
				</cfloop>
				
				<cfif url.stage eq "">
				   <td align="center" bgcolor="yellow" style="font-size:10px;min-width:#width#px;border-left:1px solid silver">P</td>
				   <td align="center" bgcolor="B9F4C4" style="font-size:10px;min-width:#width#px;border-left:1px solid silver;border-right:1px solid silver">C</td>	
				<cfelseif url.stage eq "Pending">
					<td align="center" bgcolor="yellow" style="font-size:10px;min-width:#width#px;border-left:1px solid silver">P</td>				
				<cfelse>				
					<td align="center" bgcolor="B9F4C4" style="font-size:10px;min-width:#width#px;border-left:1px solid silver;border-right:1px solid silver">C</td>	
				</cfif>
								
			</tr>
			
			</cfif>
			
			</cfoutput>	
					
			<cfquery name="list" dbtype="query">
			 	 SELECT   DISTINCT EventYear,FieldRow, FieldRowName
				 FROM     getList
				 ORDER BY Amount DESC
			 </cfquery>
			 
			 <cfset prior = "">
			 				 
				 <cfset trp = "border-left:1px solid silver;">
				 
				 <cfoutput>		 
				 <tr>
				
						<td style="padding-left:4px;width:100%"></td>		
						<cfloop index="mth" from="1" to="12">	
							<cfif url.stage eq "" or url.stage eq "Pending">		
							<td align="center" style="background-color:##ffffaf50;min-width:#width#px;#trp#"></td>
							</cfif>
							<cfif url.stage eq "" or url.stage eq "Completed">
							<td align="center" style="background-color:##B9F4C450;min-width:#width#px;#trp#"></td>					
							</cfif>
						</cfloop>
						<cfif url.stage eq "" or url.stage eq "Pending">
						<td align="center" bgcolor="yellow" style="min-width:#width#px;#trp#"></td>
						</cfif>
						<cfif url.stage eq "" or url.stage eq "Completed">
						<td align="center" bgcolor="B9F4C4" style="min-width:#width#px;#trp#;border-right:1px solid silver"></td>	
						</cfif>
						
					</tr>		
					
				</cfoutput>		
				 								
				 <cfoutput query="List">				 										
									
					<tr class="navigation_row line fixlengthlist">
					 
					  <td style="width:100%">
					  
						  <table width="95%" align="right">
						  <tr>
						  	<td style="height:20px" class="fixlength">													
								<cfif prior neq FieldRowName>#FieldRowName#<cfset prior = fieldRowName></cfif>
							</td>
							<cfif url.period eq "All">
							<td align="right" style="padding-right:3px;font-size:12px;">#EventYear#</td>
							</cfif>
						  </tr>
						  </table>
						  
					  </td>	
					  	
					  <!--- Pending --->
											
					  <cfquery name="getPending" dbtype="query">
					        SELECT     EventMonth, SUM(amount) as Counted
						    FROM       getList
							WHERE      FieldRow     = '#FieldRow#'													  								
							AND        EventYear    = '#EventYear#'
							<!--- 	-- AND        ActionStatus < '3' --->										       
							GROUP BY   EventMonth							
					  </cfquery>	
					  					
					  <cfset arPending=arraynew(1)> 					
					  <cfset ArraySet(arPending, 1, 12, 0)>
		 
					  <!--- Populate the array row by row ---> 
					  <cfloop query="getPending"> 
						    <cfset arPending[EventMonth]=Counted> 									   
					  </cfloop> 
						
					  <!--- Complete --->
						
					  <cfquery name="getComplete" dbtype="query">
						        SELECT     EventMonth, SUM(amount) as Counted
							    FROM       getList
								WHERE      FieldRow     = '#FieldRow#'		
								AND        EventYear    = '#EventYear#'											  								
								<!--- AND        ActionStatus = '3'	--->									       
								GROUP BY   EventMonth
					  </cfquery>		
						
					  <cfset arComplete=arraynew(1)> 					
					  <cfset ArraySet(arComplete, 1, 12, 0)>
		 
					  <!--- Populate the array row by row ---> 
					  <cfloop query="getComplete"> 
					    <cfset arComplete[EventMonth]=Counted> 									   
					  </cfloop> 
					  				 
					  <cfloop index="mth" from="1" to="12">
														
							<cfset pend = arPending[mth]>
							
							<cfset thisDivName	="#LEFT(REPLACE(url.mission,"__","","ALL"),25)#YKK"> <!----throwing an error when selecting more than 7 entities---->
							
							<cfif url.stage eq "" or url.stage eq "Pending">
								<cfif pend eq "0">																	
									<td style="#trp#;min-width:#width#px" align="center">-</td>						
								<cfelse>							
									<td onclick="doPersonDetail('#url.mission#','#unit#','#eventyear#','#url.sort#','#mth#','#user#','#url.layout#','#fieldrow#','P','#thisDivName#')" 
									   style="#trp#;min-width:#width#px;cursor:pointer;background-color:##FFFF0050" align="right">#numberformat(pend,',')#</td>														
								</cfif>
							</cfif>
														
							<cfset cmpl = arComplete[mth]>		
							
							<cfif url.stage eq "" or url.stage eq "Completed">										
								<cfif cmpl eq "0">																	
									<td style="#trp#;min-width:#width#px" align="center">-</td>						
								<cfelse>							
									<td onclick="doPersonDetail('#url.mission#','#unit#','#eventyear#','#url.sort#','#mth#','#user#','#url.layout#','#fieldrow#','C','#thisDivName#')" 
									   style="#trp#;min-width:#width#px;cursor:pointer;background-color:##00FF4050" align="right">#numberformat(cmpl,',')#</td>														
								</cfif>						
							</cfif>
								
					</cfloop>	
					 				
					<cfset pend = ArraySum(arPending)>	
					
					<cfset thisDivName	="#LEFT(REPLACE(url.mission,"__","","ALL"),25)#YKK"> <!----throwing an error when selecting more than 7 entities---->
				
					<cfif url.stage eq "" or url.stage eq "Pending">
						<cfif pend eq "0">																	
							<td style="#trp#;min-width:#width#px" align="center">-</td>							
						<cfelse>							
							<td bgcolor="yellow" onclick="doPersonDetail('#url.mission#','#unit#','#eventyear#','#url.sort#','','#user#','#url.layout#','#fieldrow#','P','#thisDivName#')" 
							    style="#trp#;min-width:#width#px;cursor:pointer" align="right">#numberformat(pend,',')#</td>														
						</cfif>
					</cfif>
									
					<cfset cmpl = ArraySum(arComplete)>	
						
					<cfif url.stage eq "" or url.stage eq "Completed">		
						<cfif cmpl eq "0">						
						<td align="center" style="#trp#;min-width:#width#px;border-left:1px solid silver;border-right:1px solid silver">-</td>			  						
						<cfelse>
						<td align="right" bgcolor="00FF40" onclick="doPersonDetail('#url.mission#','#unit#','#eventyear#','#url.sort#','','#user#','#url.layout#','#fieldrow#','C','#thisDivName#')" 
						    style="min-width:#width#px;border-left:1px solid silver;border-right:1px solid silver">#numberformat(cmpl,',')#</td>			  												
						</cfif>		
					</cfif>				
					 
					</tr>
					
				</cfoutput>		
						 
			<cfoutput>
			 
			<!--- Pending --->										
			<cfquery name="getPending" dbtype="query">
			        SELECT     EventMonth, SUM(amount) as Counted
				    FROM       getList
					<!--- WHERE      ActionStatus < '3' --->										       
					GROUP BY   EventMonth
			</cfquery>		
			
			<cfset arPending=arraynew(1)> 					
			<cfset ArraySet(arPending, 1, 12, 0)>
	
			<!--- Populate the array row by row ---> 
			<cfloop query="getPending"> 
			    <cfset arPending[EventMonth]=Counted> 									   
			</cfloop> 
			
			<!--- Complete --->
			
			<cfquery name="getComplete" dbtype="query">
			        SELECT   EventMonth, SUM(amount) as Counted
				    FROM     getList
					<!--- WHERE    ActionStatus = '3' --->														       
					GROUP BY EventMonth
			</cfquery>		
			
			<cfset arComplete=arraynew(1)> 					
			<cfset ArraySet(arComplete, 1, 12, 0)>
	
			<!--- Populate the array row by row ---> 
			<cfloop query="getComplete"> 
			    <cfset arComplete[EventMonth]=Counted> 									   
			</cfloop> 	
			
			 
			<tr class="navigation_row labelmedium">
				  <td width="100%" style="padding-left:4px"><cf_tl id="Total"></td>
				  
				  <cfloop index="mth" from="1" to="12">
				  						
						<cfset thisDivName	="#LEFT(REPLACE(url.mission,"__","","ALL"),25)#YKK"> <!----throwing an error when selecting more than 7 entities---->
						
						<cfif url.stage eq "" or url.stage eq "Pending">
						<cfset pend = arPending[mth]>										
						<td bgcolor="<cfif getPending.counted gt 0>yellow</cfif>" style="padding-right:3px;border-left:1px solid silver" align="right"
							onclick="doPersonEvent('#url.mission#','#unit#','#url.period#','#url.sort#','#mth#','#user#','#url.layout#','','P','#thisDivName#')">
							#numberformat(pend,',')#</td>
						</cfif>	
							
						<cfif url.stage eq "" or url.stage eq "Completed">											
						<cfset cmpl = arComplete[mth]>					
						<td align="right" bgcolor="00FF40" style="padding-right:3px;border-left:1px solid silver"
							onclick="doPersonEvent('#url.mission#','#unit#','#url.period#','#url.sort#','#mth#','#user#','#url.layout#','','C','#thisDivName#')">
							#numberformat(cmpl,',')#</td>		
						</cfif>				
					
				  </cfloop>	 
				  
				  <cfset thisDivName	="#LEFT(REPLACE(url.mission,"__","","ALL"),25)#YKK"> <!----throwing an error when selecting more than 7 entities---->
				  
				  <cfif url.stage eq "" or url.stage eq "Pending">
				  <cfset pend = ArraySum(arPending)>										
				  <td bgcolor="yellow" style="padding-right:3px;border-left:1px solid silver" align="right"
	  				onclick="doPersonEvent('#url.mission#','#unit#','#url.period#','#url.sort#','','#user#','#url.layout#','','P','#thisDivName#')">#numberformat(pend,',')#</td>
				  </cfif>
				  
				  <cfif url.stage eq "" or url.stage eq "Completed">				 						
				  <cfset cmpl = ArraySum(arComplete)>							
				  <td align="right" bgcolor="e4e4e4" style="padding-right:3px;border-left:1px solid silver;border-right:1px solid silver"
					onclick="doPersonEvent('#url.mission#','#unit#','#url.period#','#url.sort#','','#user#','#url.layout#','','C','#thisDivName#')">#numberformat(cmpl,',')#</td>		
				   </cfif>	  
				 
				</tr>
							
				</cfoutput>
								
			</table>				
		
		</td>
			
	</tr>

<cfset ajaxOnLoad("doHighlight")>

<cfset thisDivName	="#LEFT(REPLACE(url.mission,"__","","ALL"),25)#YKK"> <!----throwing an error when selecting more than 7 entities---->

<!---

<cfif user neq "">
	<cfset ajaxOnLoad("function(){ doPersonEvent('#url.mission#','#url.orgunit#','#url.period#','#url.sort#','','#user#','#url.layout#','','P','#thisDivName#'); }")>
<cfelse>
	<cfset ajaxOnLoad("function(){ doPersonEvent('#url.mission#','#url.orgunit#','#url.period#','#url.sort#','','xxxxxx','#url.layout#','','P','#thisDivName#'); }")>	
</cfif>

--->

</table>
