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
<table width="100%" style="width:400px" border="0">
		
	<tr class="line">
	
	<td colspan="2" valign="top">		
					
		<table width="100%" border="0">
		
		<tr class="labelmedium">
						
		    <td valign="bottom" style="padding-left:3px;padding-bottom:2px;font-size:20px;width:60%;height:42px"><cf_tl id="Distribution by Duty station"></td>
			
			<td>
			
			<cfinvoke component="Service.Analysis.CrossTab"  
				  method         = "ShowInquiry"
				  buttonName     = "Excel"
				  buttonText     = "Export to MS - Excel"
				  buttonClass    = "td"
				  buttonIcon     = "#SESSION.root#/Images/sqltable.gif"
				  scriptfunction = "facttabledetailxls"
				  reportPath     = "Portal\Topics\PersonDiversity\"
				  SQLtemplate    = "StaffingPreparation.cfm"  <!--- generates the data --->
				  queryString    = ""
				  dataSource     = "appsQuery" 
				  module         = "Staffing"
				  reportName     = "Widget: Staff Diversity"
				  table1Name     = "Export file"
				  filter         = "box=#url.mission#&Mission=#URL.Mission#&period=#url.period#&orgunit=#url.orgunit#&category=#url.category#&cstf=#url.cstf#&authorised=#url.authorised#&postclass=#url.postclass#"
				  data           = "1"					  
				  ajax           = "1"
				  olap           = "0" 
				  excel          = "1"> 
				  
				  </td>
				  
		</tr>
		</table>			
	
	</td></tr>
		
	<tr><td width="10%" style="padding-right:17px;padding-top:23px">

			<cfquery name="Location" dbtype="query">
			  	SELECT    LocationCode,LocationName,
				          COUNT(DISTINCT PersonNo) as Total
			 	 FROM     GetStaff
			  	GROUP BY  LocationCode,
				          LocationName							  
		  	</cfquery>	
						
			<cf_uichart	name="staffing#mission#02"						
				fontsize="14" 
				fontbold="no" 
				font="calibri"
				fontitalic="no" 												
				markersize="30" 
				backgroundcolor="##ffffff"					
		       	chartheight="220" 
			   	chartwidth="250">	
									
				   <cf_uichartseries type="pie"
			             query="#Location#"
		    	         itemcolumn="LocationCode"
		        	     valuecolumn="Total"		
						 datalabelstyle="pattern"					 					 				            
					     colorlist="##5DB7E8,##E8875D,##E8BC5D,##CCCA6A,##339AFA,##66AC6A,##999A9A,##FFFA9A,##996AFA"></cf_uichartseries>	
						 
			</cf_uichart>						 
						
		</td>
	
		<td style="width:300px; min-width:300px; max-width:300px; overflow:auto; padding-top:5px;" valign="top">
							 		 						 
	    	 <table style="width:95%">
			 
			 <tr><td align="center" valign="top" style="padding:5px">
			 			 
			 <cfquery name="ParentAll" dbtype="query">
			  	SELECT    ContractLevelParent, ContractLevelBudgetOrder, COUNT(DISTINCT PersonNo) as Total
			 	FROM      GetStaff
			  	GROUP BY  ContractLevelParent, ContractLevelBudgetOrder
				UNION
				SELECT    ContractLevelParent, ContractLevelBudgetOrder, 0 as Total
			 	FROM      GetPriorMonth
		  	 </cfquery>	
			 
			 <cfquery name="Parent" dbtype="query">
			 	SELECT 	  ContractLevelParent, SUM(Total) as Total
				FROM 	  ParentAll
				GROUP BY  ContractLevelParent
				ORDER BY  ContractLevelBudgetOrder
			 </cfquery>			
			
			 <cfquery name="CellContent" dbtype="query">
			  	SELECT    LocationCode,ContractLevelParent,
				          COUNT(DISTINCT PersonNo) as Total
			 	 FROM     GetStaff
			  	GROUP BY  LocationCode,ContractLevelParent
		  	</cfquery>		
			
			 <cfquery name="CellContentPrior" dbtype="query">
			  	SELECT    LocationCode,ContractLevelParent,
				          COUNT(DISTINCT PersonNo) as Total
			 	 FROM     GetPriorMonth
			  	GROUP BY  LocationCode,ContractLevelParent
		  	</cfquery>			
			 			
			 <table width="100%" class="navigation_table">
			 
			     <cfoutput>				 
				 <tr class="labelmedium fixrow fixlengthlist" style="background-color:##eaeaea80">
				 	<td style="padding-left:3px;padding-right:4px; font-size:90%;">
				 		<a href="javascript:showFundingDetail('location','#url.mission#', '#url.orgunit#', '#url.cstf#', '#url.postclass#', '#url.category#', '#url.authorised#', '#url.period#', 'detailArea')">
				 			<cf_tl id="Pivot">
				 		</a>
				 	</td>
					<cfloop query="Location">
					<td align="center"><cfif LocationName neq "">#LocationName#<cfelse>#LocationCode#</cfif></td>
					<td style="font-size:11px;min-width:15" align="right"></td>
					</cfloop>		
					<td align="center"><cf_tl id="Total"></td>
					<td style="font-size:11px;" align="right">+/-</td>	 
				 </tr>
				 
				 <cfloop query="Parent">
				 
					 <tr class="labelmedium navigation_row fixlengthlist">
					 	<td>#ContractLevelParent#</td>
						
						<cfloop query="Location">
						
							<cfquery name="getContent" dbtype="query">
							  	 SELECT  *
							 	 FROM    CellContent
								 WHERE   LocationCode    = '#LocationCode#' 
								 AND     ContractLevelParent = '#Parent.ContractLevelParent#'						  	
						  	</cfquery>
							
							<cfset vLink = "">
							<cfif getContent.Total neq "">
								<cfset vLink = "showDetail('location','#url.mission#', '#url.orgunit#', '#url.cstf#', '#url.postclass#', '#category#', '#authorised#', '#url.period#', '#Parent.ContractLevelParent#', '#LocationCode#', 'detailArea')">
							</cfif>
							
							<td align="right" onclick="#vLink#">							
							  <a>#getContent.Total#</a>					
							</td>
							
							<cfquery name="getContentPrior" dbtype="query">
							  	 SELECT  *
							 	 FROM    CellContentPrior
								 WHERE   LocationCode    = '#LocationCode#' 
								 AND     ContractLevelParent = '#Parent.ContractLevelParent#'						  	
						  	</cfquery>
							
							<td align="right" style="background-color:##e4e4e480;padding-top:3px;font-size:70%">		
												
							   <cfif getContent.Total neq "" and getContentPrior.Total neq "">
								   <cfset variance = getContent.Total - getContentPrior.Total>
							   <cfelse>
							   	   <cfset variance = "">		   
							   </cfif>			
							   <cfif variance eq "" or variance eq "0">
							   <cfelseif variance lt "0"><font color="FF0000">#variance#</font>
							   <cfelse><font color="008000">+#variance#</font>
							   </cfif>
							</td>
															
						</cfloop>		
						
						<td 
							align="right" 
							style="cursor:pointer;" 
							onclick="showDetail('location','#url.mission#', '#url.orgunit#', '#url.cstf#', '#url.postclass#', '#category#', '#authorised#', '#url.period#', '#ContractLevelParent#', '', 'detailArea')">
							<a>#total#</a>
						</td>

						<cfquery name="getContentPriorTotal" dbtype="query">
						  	 SELECT  SUM(Total) as Total
						 	 FROM    CellContentPrior
							 WHERE   ContractLevelParent = '#ContractLevelParent#'						  	
					  	</cfquery>
						
						<td align="right" style="background-color:##e4e4e480;padding-top:3px;font-size:80%">		
											
						   <cfif total neq "" and getContentPriorTotal.Total neq "">
							   <cfset variance = total - getContentPriorTotal.Total>
						   <cfelse>
						   	   <cfset variance = "">		   
						   </cfif>			
						   <cfif variance eq "" or variance eq "0">
						   <cfelseif variance lt "0"><font color="FF0000">#variance#</font>
						   <cfelse><font color="008000">+#variance#</font>
						   </cfif>
						</td>							
					 </tr>			 
				 </cfloop>
				 
				 <tr bgcolor="EaEaEa" class="labelmedium fixlengthlist">
				 	
					<td><cf_tl id="Total"></td>
					
					<cfloop query="Location">
					
					<td style="cursor:pointer;" align="right" 
					   onclick="showDetail('location','#url.mission#', '#url.orgunit#', '#url.cstf#', '#url.postclass#', '#category#', '#authorised#', '#url.period#', '', '#LocationCode#', 'detailArea')">
					   <a>#Total#</a>
					</td>
					
					    <cfquery name="getContentPrior" dbtype="query">
						  	 SELECT  SUM(Total) as Total
						 	 FROM    CellContentPrior
							 WHERE   LocationCode    = '#LocationCode#' 													  	
						</cfquery>
						
						<td align="right" style="font-size:80%;padding-top:3px">
							
							<cfif Location.Total neq "" and getContentPrior.Total neq "">
								   <cfset variance = Location.Total - getContentPrior.Total>
						    <cfelse>
							   	   <cfset variance = "">		   
						    </cfif>			
							
							<cfif variance eq "" or variance eq "0">
							<cfelseif variance lt "0"><font color="FF0000">#variance#</font>
							<cfelse><font color="008000">+#variance#</font>
							</cfif>
							
						</td>
																								
					</cfloop>	
						
					<td style="cursor:pointer;" align="right" 
					   onclick="showDetail('location','#url.mission#', '#url.orgunit#', '#url.cstf#', '#url.postclass#', '#category#', '#authorised#', '#url.period#', '', '', 'detailArea')">
						<a>#Summary.Total#</a>
					</td>	 

					<cfquery name="getContentPriorGrandTotal" dbtype="query">
					  	 SELECT  SUM(Total) as Total
					 	 FROM    CellContentPrior
					</cfquery>
					
					<td align="right" style="padding-top:3px;font-size:80%">
						
						<cfif Location.Total neq "" and getContentPriorGrandTotal.Total neq "">
							   <cfset variance = Summary.Total - getContentPriorGrandTotal.Total>
					    <cfelse>
						   	   <cfset variance = "">		   
					    </cfif>			
						
						<cfif variance eq "" or variance eq "0">
						<cfelseif variance lt "0"><font color="FF0000">#variance#</font>
						<cfelse><font color="008000">+#variance#</font>
						</cfif>
						
					</td>

				 </tr>	
				 		 
			     </cfoutput>
				 
			 </table>
			 			 
			 </td></tr>
			 </table>				 
			
	</td>	
</tr>
	
</table>

