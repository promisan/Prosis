
<table width="100%" height="100%">
	
	<cfoutput>
	
		<tr class="line" style="height:15px">		   
			<td colspan="1" class="labelmedium" align="center"><cf_tl id="Distribution">
			    <a 	href="#session.root#/Portal/Topics/PersonDiversity/StaffingMap.cfm?systemFunctionId=#url.systemFunctionId#&mission=#url.mission#&orgunit=#url.orgunit#&cstf=#url.cstf#&postclass=#url.postclass#&category=#category#&authorised=#authorised#&period=#url.period#" 
			 		target="_blank">(<cf_tl id="Show in full Map">)</a>
			
			</td>			
		    <td colspan="1" class="labelmedium" align="center"><cf_tl id="Summary by order"></td>
			<td colspan="1" class="labelmedium" align="center"><cf_tl id="Quantities"></td>
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
		
		<td width="30%" align="center" style="padding:5px">
  			<div id="mymap" style="height:200px; width:100%;"></div>
		</td>
		
		<td width="30%" style="height:200px;min-width:400px;padding:7px">
		    
			<table width="99%" height="100%">
			
				<tr class="labelmedium">
					<cfoutput>
				 	<td colspan="1" style="border:1px solid silver;width:100%;padding-left:3px;"><cf_tl id="Nationality"></td>
				 	</cfoutput>
					<cfoutput query="Parent">
					<td style="border:1px solid silver;min-width:33;padding-right:2px" align="center">#ContractLevelParent#</td>
					</cfoutput>		
					<td style="border:1px solid silver;background-color:efefef;min-width:43px;padding-right:2px" align="center"><cf_tl id="Sum"></td>	
					<td style="min-width:26px"></td> 
				 </tr>
				
				<tr><td colspan="<cfoutput>#parent.recordcount+3#</cfoutput>" height="100%" width="100%" style="border-left:0px solid silver">		
				
					<cf_divscroll style="width:100%" overflowy="scroll">		
					<table width="98%" class="navigation_table">						
						<cfoutput query="summary">		
							<tr class="line labelmedium navigation_row" style="height:10px">
							    <td style="padding-left:4px;width:100%">#currentrow# #NationalityName# (#Nationality#)</td>														
								<cfloop query="Parent">
									<td align="right" style="min-width:33;border-left:1px solid silver;border-bottom:1px solid silver;padding-right:2px">						
									  <cfquery name="getContent" dbtype="query">
									  	 SELECT  *
									 	 FROM    CellContent
										 WHERE   ContractLevelParent = '#ContractLevelParent#' 
										 AND     Nationality  = '#summary.Nationality#'						  	
								  	  </cfquery>	
									  #getContent.Total#						
									</td>
								</cfloop>																			
								<td align="right" style="padding-right:2px;background-color:eaeaea;min-width:43px;border-right:1px solid silver;border-left:1px solid silver;">#Total#</td>
							</tr>		
						</cfoutput>
					</table>
					</cf_divscroll>
				
				</td>
				</tr>
																
				<tr class="labelmedium">
					<cfoutput>
				 	<td colspan="1" style="border:1px solid silver;width:100%;padding-left:3px;"><cf_tl id="Total"></td>
				 	</cfoutput>
					<cfoutput query="Parent">
					<td style="border:1px solid silver;min-width:33;padding-right:2px" align="right">
					
					 <cfquery name="getContent" dbtype="query">
						  	 SELECT  SUM(Total) as Total
						 	 FROM    CellContent
							 WHERE   ContractLevelParent = '#ContractLevelParent#' 										 					  	
					  </cfquery>	
					  #getContent.Total#	
					
					
					</td>
					</cfoutput>	
					
					<cfoutput>	
					<td style="border:1px solid silver;background-color:efefef;min-width:43px;padding-right:2px" align="right">
					
					 <cfquery name="getContent" dbtype="query">
						  	 SELECT  SUM(Total) as Total
						 	 FROM    CellContent																 					  	
					  </cfquery>	
					  #getContent.Total#	
					</td>	
					</cfoutput>
					<td style="min-width:26px"></td> 
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
		
			<td align="center" valign="top" style="width:30%;;height:140px;padding:2px">
		
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
					 
						 <tr class="labelmedium line">
						 	<td style="width:50%;padding-left:3px;padding-right:4px"><cf_tl id="Category"></td>					
							<td style="min-width:35;padding-right:3px" align="right"><cf_tl id="Nat"></td>						
							<td style="min-width:35" align="right"><cf_tl id="Total"></td>	 
						 </tr>
						 
						 <cfloop query="Parent">
							 <tr class="labelmedium line navigation_row" style="height:10px">
							 	<td style="padding-left:2px">#ContractLevelParent#</td>							
								<td align="right" style="border:1px solid silver;padding-right:3px">						
								  <cfquery name="nat" dbtype="query">
								  	 SELECT  *
								 	 FROM    NatContent
									 WHERE   ContractLevelParent = '#Parent.ContractLevelParent#'						  	
							  	  </cfquery>	
								  #nat.Total#						
								</td>							
								<td align="right" style="border:1px solid silver;padding-right:3px">#total#</td>
							 </tr>			 
						 </cfloop>
						 
						 <cfquery name="Summary" dbtype="query">
						  	SELECT  COUNT(DISTINCT PersonNo) as Total
						 	FROM    GetStaff			  	
						</cfquery>	
						 
						 <tr bgcolor="E6E6E6" class="labelmedium line">
						 	<td style="padding-left:2px;width:70%"><cf_tl id="Total"></td>					
							<td style="border:1px solid silver;min-width:35;padding-right:3px" align="right">
							 <cfquery name="nat" dbtype="query">
								 SELECT   COUNT(DISTINCT Nationality) as Total
					 			 FROM     GetStaff			  								  	
						  	  </cfquery>	
							  #nat.Total#					
							</td>						
							<td style="border:1px solid silver;min-width:35;padding-right:3px" align="right">#Summary.Total#</td>	 
						 </tr>		
					 	 
				     </cfoutput>
					 
				 </table>
		
			</td>
	</tr>
		
</table>
