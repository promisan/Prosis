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


<table width="100%" height="100%">
		
		<tr class="line" style="height:20px"><td colspan="2" style="height:35px;font-size:20px" class="labelmedium"><cf_tl id="Distribution by gender"></td></tr>
	
		<tr><td width="6%" style="padding-left:5px;padding-top:15px;padding-right:4px">

		    <cfquery name="Sex" dbtype="query">
			  	SELECT    Gender,
				          COUNT(DISTINCT PersonNo) as Total
			 	 FROM     GetStaff
			  	GROUP BY  Gender
		  	</cfquery>	
			
			 <cfquery name="Max" dbtype="query">
			  	SELECT    *
			 	 FROM     Sex
				 ORDER BY Total DESC			  	
		  	</cfquery>	
					
				<cf_uichart name="staffing#mission#01"				
					scalefrom="0"					
					showxgridlines="yes" 
					showygridlines="yes"
					gridlines="6" 
					showborder="no" 
					fontsize="14" 
					fontbold="no" 
					font="calibri"					
					show3d="no" 					
					xaxistitle="" 				 
					yaxistitle="" 
					rotated="no" 
					sortxaxis="no" 				 
					tipbgcolor="000000" 
					showmarkers="yes" 					
					markersize="30" 					
					backgroundcolor="##ffffff"					
			       	chartheight="220" 
				   	chartwidth="250">					
																					
					   <cf_uichartseries type="pie"
				             query="#Sex#"
			    	         itemcolumn="Gender"
			        	     valuecolumn="Total"	
							 datalabelstyle="pattern"
				             markerstyle="rectangle"						 						 
						     colorlist="##E08FE0,##0B8EDD"></cf_uichartseries>	
							 
				</cf_uichart>
						
		</td>
	
		<td style="padding-top:5px;min-width:100">
	    				
			<table height="100%" width="100%" style="border:0px solid silver">
			 <tr><td align="right" valign="top" style="padding-left:0px;padding-top:5px">
			 
			 <cfquery name="Parent" dbtype="query">
			  	SELECT    ContractLevelParent, ContractViewOrder,
				          COUNT(DISTINCT PersonNo) as Total
			 	 FROM     GetStaff
			  	GROUP BY  ContractLevelParent, ContractViewOrder
				ORDER BY  ContractViewOrder
		  	 </cfquery>				
			
			 <cfquery name="CellContent" dbtype="query">
			  	SELECT    Gender,ContractLevelParent,
				          COUNT(DISTINCT PersonNo) as Total
			 	 FROM     GetStaff
			  	GROUP BY  Gender,ContractLevelParent
		  	</cfquery>				
			 			
			 <table width="100%" style="min-width:270px" class="navigation_table">
			 
			     <cfoutput>		
				 		 
				 <tr class="labelmedium fixlengthlist">
				 	<td></td>
					<cfloop query="Sex">
					<td style="background-color:<cfif gender eq 'F'>##E08FE080<cfelse>##0B8EDD80</cfif>" colspan="2" align="center">#Gender#</td>					
					</cfloop>		
					<td style="background-color:##f1f1f180" align="center"><cf_tl id="Total"></td>	 
				 </tr>
				 
					 <cfloop query="Parent">
						 <tr class="labelmedium navigation_row">
						 	<td>#ContractLevelParent#</td>
							<cfloop query="Sex">
								<cfquery name="getContent" dbtype="query">
								  	 SELECT  *
								 	 FROM    CellContent
									 WHERE   Gender              = '#Gender#' 
									 AND     ContractLevelParent = '#Parent.ContractLevelParent#'						  	
							  	</cfquery>

								<cfset vLink = "">
								<cfif Total neq "" AND Parent.Total neq "" and getContent.Total neq "" and Parent.Total neq "0">
									<cfset vLink = "showDetail('gender','#url.mission#', '#url.orgunit#', '#url.cstf#', '#url.postclass#', '#category#', '#authorised#', '#url.period#', '#Parent.ContractLevelParent#', '#gender#', 'detailArea')">
								</cfif>
								<td align="right" onclick="#vLink#">
								  <a>#getContent.Total#</a>					
								</td>
								<td align="right" bgcolor="E6E6E6" style="background-color:##e6e6e680">
								<cfif Parent.Total neq "" and getContent.Total neq "" and Parent.Total neq "0">
								    <cfset ratio = (getContent.Total*100)/Parent.Total>						
									#numberformat(ratio,'._')#%
								</cfif>
								</td>
							</cfloop>		
							<td align="right" style="cursor:pointer;" onclick="showDetail('gender','#url.mission#', '#url.orgunit#', '#url.cstf#', '#url.postclass#', '#category#', '#authorised#', '#url.period#', '#ContractLevelParent#', '', 'detailArea')"><a>#total#</a></td>
						 </tr>			 
					 </cfloop>
					 
				 <tr bgcolor="E6E6E6" class="labelmedium">
				 	<td style="padding-left:4px"><b><cf_tl id="Total"></td>
					<cfloop query="Sex">
						<td style="cursor:pointer;background-color:<cfif gender eq 'F'>##E08FE080<cfelse>##96F5F380</cfif>" 
							align="right"
							onclick = "showDetail('gender','#url.mission#', '#url.orgunit#', '#url.cstf#', '#url.postclass#', '#category#', '#authorised#', '#url.period#', '', '#gender#', 'detailArea')">
								<a>#Total#</a>
						</td>
						<td align="right" 
							bgcolor="E6E6E6" 
							style="cursor:pointer;background-color:<cfif gender eq 'F'>##E08FE080<cfelse>##96F5F380</cfif>">
						<cfset ratio = (Total*100)/Summary.Total>			
						#numberformat(ratio,'._')#%
						</td>
					</cfloop>		
					<td style="cursor:pointer" align="right" onclick="showDetail('gender','#url.mission#', '#url.orgunit#', '#url.cstf#', '#url.postclass#', '#category#', '#authorised#', '#url.period#', '', '', 'detailArea')"><a>#Summary.Total#</a></td>	 
				 </tr>			 
			     </cfoutput>
				 
			 </table>
			 	
			</td></tr>
			</table>	
			
		</td>
		
	</tr>
</table>