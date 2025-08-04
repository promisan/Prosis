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

<cfset url.cstf = "TPE_STF">

<table width="100%" height="100%">
	
	<cfoutput>
	
		<tr class="line" style="height:15px">		   
			<td colspan="1" class="labelmedium" align="center"><cf_tl id="All staff (no interns/SSA/Judges)">
			    <br><a href="#session.root#/Portal/Topics/PersonDiversity/StaffingMap.cfm?systemFunctionId=#url.systemFunctionId#&mission=#url.mission#&orgunit=#url.orgunit#&cstf=#url.cstf#&postclass=#url.postclass#&category=#url.category#&authorised=#url.authorised#&period=#url.period#" 
			 		target="_blank">(<cf_tl id="Show in Map">)</a>			
			</td>
			<cfloop index="itm" list="PR,GS">
				<cfif itm eq "PR">
					<td colspan="1" class="labelmedium" align="center">Professionals and higher<br>and Field service staff</td>
				<cfelse>
			    	<td colspan="1" class="labelmedium" align="center">General Services<br>staff</td>
				</cfif>
			</cfloop>
			<td colspan="1" class="labelmedium" align="center"><cf_tl id="Quantities"></td>
		</tr>
		
	</cfoutput>
		
	    <cfquery name="Summary1" dbtype="query">
			SELECT    Nationality, NationalityName,
			          COUNT(DISTINCT PersonNo) as Total
		 	 FROM     GetStaff
			 WHERE    PostType = '#right(url.cstf,len(url.cstf)-4)#'
		  	GROUP BY  Nationality, NationalityName				
		</cfquery>			
							
		<cfquery name="Summary" dbtype="query">
			SELECT    *
		 	FROM      Summary1
		  	ORDER BY  Total DESC				
		</cfquery>			
				
		<tr>
		
		<td width="25%" style="height:157px;min-width:230px">
		    
			<table width="99%" height="100%">
								
				<tr><td colspan="<cfoutput>#parent.recordcount+3#</cfoutput>" height="100%" width="100%">		
				
					<cf_divscroll style="width:100%" overflowy="scroll">		
					<table width="96%" class="navigation_table">		
					    <cfset tot = 0>				
						<cfoutput query="summary">		
							<tr class="navigation_row labelmedium">
							    <td style="padding-left:4px;width:100%">#currentrow# #NationalityName# (#Nationality#)</td>																						
								<td align="right" style="padding-right:2px;background-color:e1e1e1;min-width:33px;">#Total#</td>
							</tr>		
							<cfif total neq "">
								<cfset tot = tot + total>
							</cfif>
						</cfoutput>
					</table>
					</cf_divscroll>
				
				</td>
				</tr>
				
				<cfoutput>
				<tr class="labelmedium"><td colspan="#parent.recordcount+3#" style="padding-right:8px" align="right"><cf_tl id="Total">:<b>&nbsp;#tot#</td></tr>
				</cfoutput>
			
			</table>
		
		</td>
		
		<cfloop index="itm" list="PR,GS">
		
			 <cfquery name="Summary1" dbtype="query">
				SELECT    Nationality, NationalityName,
				          COUNT(DISTINCT PersonNo) as Total
			 	 FROM     GetStaff
				 <cfif itm eq "PR">
				 WHERE    ContractLevelParent IN ('#itm#','FSI')
				 <cfelse>
				 WHERE    ContractLevelParent IN ('#itm#')
				 </cfif>
			  	GROUP BY  Nationality, NationalityName				
			</cfquery>			
							
			<cfquery name="Summary" dbtype="query">
				SELECT    *
			 	FROM      Summary1
			  	ORDER BY  Total DESC				
			</cfquery>		
		
		    <td width="25%" colspan="1" class="labelmedium" align="center" style="height:157px;min-width:230px">
			
				<table width="99%" height="100%">
									
					<tr><td colspan="<cfoutput>#parent.recordcount+3#</cfoutput>" height="100%" width="100%" style="border-left:0px solid silver">		
					
						<cf_divscroll style="width:100%" overflowy="scroll">		
						<table width="96%" class="navigation_table">	
							<cfset tot = 0>							
							<cfoutput query="summary">		
								<tr class="labelmedium navigation_row">
								    <td style="padding-left:4px;width:100%">#currentrow# #NationalityName# (#Nationality#)</td>																								
									<td align="right" style="padding-right:2px;background-color:e1e1e1;min-width:33px;border-right:1px solid silver;border-left:1px solid silver;">#Total#</td>
								</tr>		
								<cfif total neq "">
								<cfset tot = tot + total>
							</cfif>
							</cfoutput>
						</table>
						</cf_divscroll>
					
					</td>
					</tr>
				
					<cfoutput>
					<tr class="labelmedium"><td colspan="#parent.recordcount+3#" class="line" align="right" style="padding-right:8px"><cf_tl id="Total">:<b>&nbsp;#tot#</td></tr>
					</cfoutput>
							
				</table>
			
			</td>
		</cfloop>
								
		<td align="center" style="width:25%;height:100%;">
		
				 <cfquery name="Parent" dbtype="query">
				  	SELECT    ContractLevelParent, ViewOrder,
					          COUNT(DISTINCT PersonNo) as Total
				 	 FROM     GetStaff
				  	GROUP BY  ContractLevelParent, ViewOrder
					ORDER BY  ViewOrder
			  	 </cfquery>				
				
				 <cfquery name="NatContent" dbtype="query">
				  	SELECT    ContractLevelParent,
					          COUNT(DISTINCT Nationality) as Total
				 	 FROM     GetStaff
				  	GROUP BY  ContractLevelParent
			  	</cfquery>		
				
				<table height="100%" width="100%" class="navigation_table">
				 
				     <cfoutput>				 
					 
						 <tr class="labelmedium">
						 	<td style="width:50%;padding-left:3px;padding-right:4px"><cf_tl id="Category"></td>					
							<td style="min-width:35;padding-right:3px" align="right"><cf_tl id="Nat"></td>						
							<td style="min-width:35" align="right"><cf_tl id="Total"></td>	 
						 </tr>
						 
						 <cfloop query="Parent">
							 <tr class="labelmedium navigation_row">
							 	<td style="padding-left:2px">#ContractLevelParent#</td>							
								<td align="right" style="padding-right:3px">						
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
						 
						 <tr bgcolor="E6E6E6" class="labelmedium">
						 	<td style="padding-left:2px;width:70%"><cf_tl id="Total"></td>					
							<td style="border:1px solid silver;border-bottom:0px;min-width:35;padding-right:3px" align="right">
							 <cfquery name="nat" dbtype="query">
								 SELECT   COUNT(DISTINCT Nationality) as Total
					 			 FROM     GetStaff			  								  	
						  	  </cfquery>	
							  #nat.Total#					
							</td>						
							<td style="border:1px solid silver;border-bottom:0px;min-width:35;padding-right:3px" align="right">#Summary.Total#</td>	 
						 </tr>		
					 	 
				     </cfoutput>
					 
				 </table>
		
			</td>
	</tr>
		
</table>