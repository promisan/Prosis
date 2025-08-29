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
<table width="100%">
	
	<cfoutput>
	
		<tr class="line">		   
			<td class="labelmedium2" align="center"><cf_tl id="Distribution">
			    <a 	href="#session.root#/Portal/Topics/PersonDiversity/StaffingMap.cfm?systemFunctionId=#url.systemFunctionId#&mission=#url.mission#&orgunit=#url.orgunit#&cstf=#url.cstf#&postclass=#url.postclass#&category=#category#&authorised=#authorised#&period=#url.period#" 
			 		target="_blank">(<cf_tl id="Show in full Map">)</a>
			
			</td>			
		    <td class="labelmedium2" align="center"><cf_tl id="Summary by order"></td>
			<td class="labelmedium2" align="center"><cf_tl id="Quantities"></td>
		</tr>
		
	</cfoutput>
		
	    <cfquery name="Summary1" dbtype="query">
			SELECT    Nationality, NationalityName,
			          COUNT(DISTINCT PersonNo) as Total
		 	 FROM     GetStaff
		  	GROUP BY  Nationality, NationalityName				
		</cfquery>			
			
		<cfquery name="CellContent" dbtype="query">
			SELECT    Nationality,ContractLevelParent,
			          COUNT(DISTINCT PersonNo) as Total
			FROM      GetStaff
			GROUP BY  ContractLevelParent,Nationality
		</cfquery>		
			
		<cfquery name="Summary" dbtype="query">
			SELECT    *
		 	FROM      Summary1
		  	ORDER BY  Total DESC				
		</cfquery>			
				
		<tr>
		
		<cfoutput>
								
		<cfquery name="getMission"
			datasource="AppsOrganization"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
		    	SELECT *
			    FROM   Ref_Mission
		     	WHERE  Mission = '#mission#'
		</cfquery>	
		
		<td align="center" style="padding:5px;width:200px;max-width:300px;width:300px">		
  			<div id="staffbox_#getMission.MissionPrefix#" style="height:200px; width:300px;max-width:300px;"></div>
		</td>
				
		</cfoutput>
		
		<td style="height:200px;padding:7px;width:30%">
		    
			<cf_divscroll overflowy="scroll">	
			
			<table align="left" style="width:100%">
			
				<tr class="labelmedium fixrow fixlengthlist" style="background-color:e4e4e4">
					<cfoutput>
				 	<td colspan="1"><cf_tl id="Nationality"></td>
				 	</cfoutput>
					<cfoutput query="Parent">
					<td align="center">#ContractLevelParent#</td>
					</cfoutput>		
					<td style="background-color:efefef;" align="center"><cf_tl id="Sum"></td>						
					<td style="min-width:20px;max-width:20px"></td>
				</tr>												
				
				<cfoutput query="summary">		
					<tr class="labelmedium navigation_row fixlengthlist" style="height:20px">
					    <td style="padding-left:4px;">#currentrow# #NationalityName#</td>														
						<cfloop query="Parent">
							<td align="right">						
							  <cfquery name="getContent" dbtype="query">
							  	 SELECT  *
							 	 FROM    CellContent
								 WHERE   ContractLevelParent = '#ContractLevelParent#' 
								 AND     Nationality  = '#summary.Nationality#'						  	
						  	  </cfquery>	
							  #getContent.Total#						
							</td>
						</cfloop>																			
						<td align="right" style="background-color:##eaeaea80;min-width:43px">#Total#</td>
					</tr>		
				</cfoutput>
																								
				<tr class="labelmedium fixlengthlist" style="background-color:f1f1f1">
					<cfoutput>
				 	<td colspan="1"><cf_tl id="Total"></td>
				 	</cfoutput>
					<cfoutput query="Parent">
					<td align="right">
					
					 <cfquery name="getContent" dbtype="query">
						  	 SELECT  SUM(Total) as Total
						 	 FROM    CellContent
							 WHERE   ContractLevelParent = '#ContractLevelParent#' 										 					  	
					  </cfquery>	
					  #getContent.Total#					
					</td>
					</cfoutput>	
					
					<cfoutput>	
					<td style="background-color:efefef" align="right">					
					 <cfquery name="getContent" dbtype="query">
						  	 SELECT  SUM(Total) as Total
						 	 FROM    CellContent																 					  	
					  </cfquery>	
					  #getContent.Total#	
					</td>	
					</cfoutput>
					
				 </tr>
			
			</table>
		
		</td>
		
		<!---
		
		<td width="50%" style="border:0px solid silver" valign="bottom" align="center">
		
			    <cfquery name="NationalityGraph" dbtype="query">
					SELECT    MAX(Total) as Maximum					         
				 	 FROM     Summary				  	
				</cfquery>	
				
				<cfquery name="NationalityTotal" maxrows=10 dbtype="query">
				     SELECT    *		         
				 	 FROM     Summary1				  	
					 ORDER BY Total DESC
				 </cfquery>	
				 
				<cfif NationalityGraph.Maximum neq "">	 
						
				  	<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
					
					<cfchart style = "#chartStyleFile#" 
						format="png"					
						scalefrom="0"
						scaleto="#NationalityGraph.Maximum*1.3#" 
						showxgridlines="yes" 
						showygridlines="yes"
						gridlines="7" 
						showborder="no" 
						fontsize="14" 
						fontbold="no" 
						font="calibri"
						fontitalic="no" 
						show3d="no" 
						xaxistitle="" 				 
						yaxistitle="" 
						rotated="no" 
						sortxaxis="no" 				 
						tipbgcolor="##000000" 
						showmarkers="yes" 
						markersize="30" 
						backgroundcolor="##ffffff"					
				       	chartheight="140" 
					   	chartwidth="470">	
											
						<cfchartseries
			             type="bar"
			             query="NationalityTotal"
			             itemcolumn="Nationality"
			             valuecolumn="Total"
			             datalabelstyle="value"
			             markerstyle="circle"
			             colorlist="gray,gray,gray,gray,gray,gray,gray,gray,gray,gray,gray,gray,gray,gray,gray,gray,gray,gray"></cfchartseries>
								 
					</cfchart>
					
				</cfif>	
									
			</td>
			
			--->
		
			<td align="center" valign="top" style="width:30%;height:140px;padding-top:5px">
		
				 <cfquery name="Parent" dbtype="query">
				  	SELECT    ContractLevelParent, ContractViewOrder,
					          COUNT(DISTINCT PersonNo) as Total
				 	 FROM     GetStaff
				  	GROUP BY  ContractLevelParent, ContractViewOrder
					ORDER BY  ContractViewOrder
			  	 </cfquery>				
				
				 <cfquery name="NatContent" dbtype="query">
				  	SELECT    ContractLevelParent,
					          COUNT(DISTINCT Nationality) as Total
				 	 FROM     GetStaff
				  	GROUP BY  ContractLevelParent
			  	</cfquery>		
				
				<table width="100%" class="navigation_table">
				 
				     <cfoutput>				 
					 
						 <tr class="labelmedium fixlengthlist" style="background-color:e6e6e6">
						 	<td><cf_tl id="Category"></td>					
							<td align="right"><cf_tl id="Nat"></td>						
							<td align="right"><cf_tl id="Total"></td>	 
						 </tr>
						 
						 <cfloop query="Parent">
							 <tr class="labelmedium navigation_row fixlengthlist">
							 	<td>#ContractLevelParent#</td>							
								<td align="right">						
								  <cfquery name="nat" dbtype="query">
								  	 SELECT  *
								 	 FROM    NatContent
									 WHERE   ContractLevelParent = '#Parent.ContractLevelParent#'						  	
							  	  </cfquery>	
								  #nat.Total#						
								</td>							
								<td align="right">#total#</td>
							 </tr>			 
						 </cfloop>
						 
						 <cfquery name="Summary" dbtype="query">
						  	SELECT  COUNT(DISTINCT PersonNo) as Total
						 	FROM    GetStaff			  	
						</cfquery>	
						 
						 <tr bgcolor="f1f1f1" class="labelmedium fixlengthlist">
						 	<td><cf_tl id="Total"></td>					
							<td align="right">
							 <cfquery name="nat" dbtype="query">
								 SELECT   COUNT(DISTINCT Nationality) as Total
					 			 FROM     GetStaff			  								  	
						  	  </cfquery>	
							  #nat.Total#					
							</td>						
							<td align="right">#Summary.Total#</td>	 
						 </tr>		
					 	 
				     </cfoutput>
					 
				 </table>
		
			</td>
	</tr>
		
</table>
