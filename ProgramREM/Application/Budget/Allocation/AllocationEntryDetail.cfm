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

<table width="1%" cellspacing="0" cellpadding="0" border="0" class="navigation_table">

	<cfoutput query="getProgram" group="HierarchyCode">
		
		<tr><td height="2"></td></tr>
		
		<tr>
			<td style="height:40;font-size:20px" colspan="#cols#" class="labellarge"><font color="6688aa">#OrgUnitName# [#OrgUnitCode#]</font></td>
		</tr>
		
		<cfoutput group="PeriodHierarchy">		
		
			<cfquery name="check"
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   P.ProgramCode, P.ProgramName
				FROM     Program AS P INNER JOIN
		                 ProgramPeriod AS Pe ON P.ProgramCode = Pe.ProgramCode INNER JOIN
        	             Organization.dbo.Organization AS O ON Pe.OrgUnit = O.OrgUnit
				WHERE    P.Mission        = '#edition.mission#'
				AND      Pe.Period = '#url.Period#'
				AND      O.HierarchyCode LIKE '#hierarchyCode#%'
				AND      ProgramAllocation = '1'
			</cfquery>
			
			<cfif check.recordcount eq "0">
						
				<cfset cl = "regular">
			
			<cfelse>					
		
				<cfif ProgramAllocation eq "1">
					<cfset cl = "regular">
				<cfelse>
					<cfset cl = "hide">
				</cfif>	
				
			</cfif>							
						    
			<tr class="#cl#">
				<td height="24" 
				    colspan="#cols#" style="font-size:19px;padding-left:14px"
					class="labelmedium"><cfif ProgramAllocation eq "1"><font size="2">Budget:</font>&nbsp;&nbsp;</cfif><b>#Reference#</b> #ProgramName#</b>&nbsp;[<font size="2">#ProgramCode#</font>]</font>
				</td>
			</tr>
			
			<tr class="#cl#"><td colspan="#cols#" class="line"></td></tr>
			
			<!--- get amounts to be shown for each program later we can extend this to the
			program as well to limit the time --->
			
			<!--- -------------------------------------------- --->				
			<!--- get the allocation recorded for this program --->		
			<!--- -------------------------------------------- --->
				
			<cfquery name="getAllotment"
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT   Fund, ObjectCode, 
						     SUM(Amount) as Amount
				    FROM     #SESSION.acc#Allocation#FileNo# S
					WHERE    ProgramCode = '#programcode#'												
					GROUP BY ObjectCode,Fund 	
			</cfquery>					
			
			<cfif ProgramAllocation eq "1">
			
				<!--- obtain all programs under a unit 1/17/2015 --->
				
				<cfquery name="getPrograms"
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   DISTINCT P.ProgramCode, P.ProgramName
				FROM     Program AS P INNER JOIN
		                 ProgramPeriod AS Pe ON P.ProgramCode = Pe.ProgramCode INNER JOIN
        	             Organization.dbo.Organization AS O ON Pe.OrgUnit = O.OrgUnit
				WHERE    P.Mission = '#edition.mission#'
				AND      O.HierarchyCode LIKE '#hierarchyCode#%' 
				</cfquery>
				
				<cfset prg = quotedValueList(getPrograms.ProgramCode)>
				
			<cfelse>
			
				<cfset prg = "'#programcode#'">
				
			</cfif>	
						
			<cfif prg eq "">
				<cfset prg = "''">
			</cfif>
			
			<cfquery name="getForceObject" 
			    datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   DISTINCT Fund, ObjectCode
				    FROM     ProgramObject
					WHERE    ProgramCode IN (#preservesingleQuotes(prg)#)																	
			</cfquery>		
																	
			<!--- -------------------------------------------- --->	
			<!--- --get the requirements for this program----- --->
			<!--- -------------------------------------------- --->	
									
			<cfquery name="getRequirement" 
			    datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   Fund, ObjectCode,
							 SUM(Total) as Amount
				    FROM     #SESSION.acc#_AllRequirement S
					WHERE    ProgramCode IN (#preservesingleQuotes(prg)#)							
					GROUP BY ObjectCode,Fund 
			</cfquery>		
									 
			<!--- --------------------------------------------- --->
			<!--- -------execution amounts for all programs---- --->
			<!--- --------------------------------------------- --->
						
			<cfquery name="getReservation"
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   Fund, ObjectCode,
							 SUM(ReservationAmount) as Amount
				    FROM     #SESSION.acc#_AllReservation S
					WHERE    ProgramCode IN (#preservesingleQuotes(prg)#)												
					GROUP BY ObjectCode,Fund 	
			</cfquery>		
						
			<cfquery name="getObligation"
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT   Fund, ObjectCode,
					         SUM(ObligationAmount) as Amount
				    FROM     #SESSION.acc#_AllObligation S
					WHERE    ProgramCode IN (#preservesingleQuotes(prg)#)																			
					GROUP BY ObjectCode,Fund 		
			</cfquery>		
						
			<cfquery name="getInvoice"
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT   Fund,ObjectCode,
					         SUM(InvoiceAmount) as Amount
				    FROM     #SESSION.acc#_AllDisbursed S
					WHERE    ProgramCode IN (#preservesingleQuotes(prg)#)																
					GROUP BY ObjectCode,Fund 	
			</cfquery>	
														
			<cfset objr = 0>		
			
			<!--- get the data for each column and objectcode into 2 dimensional variables for Object and Fund --->
						
			<cfloop query="getObject">
						     
			    <cfset objr = objr+1>
				<cfset funr = 0>
								
				<cfloop query="FundList">
				
					<cfset funr = funr+1>	
									
					<!--- declare variables --->				
					
					<cfparam name="bud[objr][funr]" default="0">	
					<cfparam name="all[objr][funr]" default="0">
					<cfparam name="exp[objr][funr]" default="0">
																	
					
				    <cfloop query="getRequirement">
						<cfif getObject.Code eq ObjectCode and fundlist.fund eq fund>
						    <cfset bud[objr][funr] = Amount>					
						</cfif>
					</cfloop>		
					
					<cfloop query="getAllotment">
						<cfif getObject.Code eq ObjectCode and fundlist.fund eq fund>
						    <cfset all[objr][funr] = Amount>					
						</cfif>
					</cfloop>	
					
					<cfloop query="getReservation">
						<cfif getObject.Code eq ObjectCode and fundlist.fund eq fund>
						    <cfset exp[objr][funr] = Amount>					
						</cfif>
					</cfloop>		
					
					<cfloop query="getObligation">
						<cfif getObject.Code eq ObjectCode and fundlist.fund eq fund>
						    <cfset exp[objr][funr] = exp[objr][funr]+Amount>					
						</cfif>
					</cfloop>		
						
					<cfloop query="getInvoice">
						<cfif getObject.Code eq ObjectCode and fundlist.fund eq fund>
						    <cfset exp[objr][funr] = exp[objr][funr]+Amount>					
						</cfif>
					</cfloop>	
																		
				</cfloop>	
				
			</cfloop>			
								
			<cfloop query="getObject">
				
					<cfset show = "0">
					<cfset col  = "0">						
					
					<cfloop index="fund" list="#fd#">		
					
						<cfquery name="forceObject" dbtype="query">
							SELECT   *
							FROM     getForceObject 
							WHERE    ObjectCode = '#code#'
							AND      Fund       = '#Fund#'
						</cfquery>												
					
						<cfset col = col+1>
						<cfif bud[currentrow][col] neq "0" or 							  
							  all[currentrow][col] neq "0" or
							  exp[currentrow][col] neq "0" or forceObject.recordcount gte "1">							
							<cfset show = 1>								
						</cfif>						
					</cfloop>	
					
					<cfset programcode = getProgram.ProgramCode>
					
					<cfif show eq "1">
										
					<tr class="#cl#" class="navigation_row">		
					<td style="padding-left:20px">
					
						<table cellspacing="0" cellpadding="0">
							<tr>
							    <td style="cursor:pointer" align="center" onclick="more('#url.editionid#','#url.period#','#programcode#','#fund#','#code#','#spc#','#fdlist#')">
								
								<cfset show = 0>
								<cfset col = 0>
								
								<cfloop index="fund" list="#fd#">
								    <cfset col = col+1>
									<cfif bud[currentrow][col] neq "0">	
										<cfset show = 1>								
									</cfif>
									<cfif all[currentrow][col] neq "0">	
										<cfset show = 1>								
									</cfif>
								</cfloop>	
								
								<cfif show eq "1">
								
									<img src="#SESSION.root#/images/arrowright.gif" 
									    height="11" id="rgt_#programcode#__#code#" 
										alt="Transaction Log"
										border="0" align="absmiddle"
										class="regular">
										
									<img src="#SESSION.root#/images/arrowdown.gif" 
									  width="12" 
									  id="dwn_#programcode#__#code#" 
									  alt="Hide" 
									  border="0" 
									  align="absmiddle" 
									  class="hide">							
								
								</cfif>	
								
								<cf_space spaces="5">	
													
								</td>
								<td class="labelmedium">
								<cf_space spaces="12">
								<a href="javascript:more('#url.editionid#','#url.period#','#programcode#','#fund#','#code#','#spc#','#fdlist#')" tabindex="9999">#CodeDisplay#</a>
								</td>
							    <td class="labelmedium">	
								<cf_space spaces="56">						
								<cfif len(description) gt "40">
								#left(Description,40)#..
								<cfelse>
								#Description#
								</cfif>
								<font size="2" color="808080">[#Code#]</font>
								
								</td>
							</tr>	 
						</table>
					</td>	
														
					<cfset sub = 0>		
					<cfset row = currentrow>
						
					<cfset col = 0>
										
					<cfloop index="fund" list="#fd#">
					
						<cfset col = col+1>
						
						<!--- requirement column --->			
						
						<td align="right" style="border-left:0px solid silver;padding-left:2px">
																									
							<table cellspacing="0" cellpadding="0" width="100%">
								<tr>
								<td style="border:1px dotted d4d4d4" align="right" bgcolor="f4f4f4" class="labelmedium">
								#numberformat(bud[row][col],',__')#
								</td>
								</tr>
							</table>
						
						</td>
						
						<!--- allocation column --->	
						
						<td align="right" style="padding:1px">
								
							<cf_space spaces="#spc#">						
										
							<table cellspacing="0" cellpadding="0" width="100%">
								<tr>
								<td style="padding-left:4px;padding-right:4px" 
									  align="right" height="18">								        
							
							   		 <input type = "text" 
									  id     = "amt_#getProgram.programcode#_#fund#_#code#" 
									  class  = "regularxl enterastab" 					  
									  value  = "#numberformat(all[row][col],',__')#"
									  style  = "width:100%;height:22px;padding-top:1px;text-align:right;padding-right:3px"
									  onChange="apply('#url.editionid#','#url.period#','#getProgram.programcode#','#fund#','#code#',this.value,'#fdlist#')">
								  
								  </td>
								</tr>
							</table>
								  
					    </td>
						
						<!--- expenditire column --->	
						
						<td align="right" style="padding-left:2px">		
																
							<table cellspacing="0" width="100%" cellpadding="0">
								<tr>
								<td style="border:1px dotted d4d4d4" align="right" class="labelmedium" bgcolor="fffffdf" height="20">
								#numberformat(exp[row][col],',__')#
								</td>
								</tr>
							</table>
									
						</td>
						
						<cfset sub = sub+all[row][col]>
						
					</cfloop>	
					
					<cfif FundList.recordcount gte "2">
					
					<!--- total column --->			
							
					<td align="right" height="20" style="padding-left:2px">
						
						<cf_space spaces="#spc#">	
												
						<table cellspacing="0" width="100%" cellpadding="0">
								<tr>
								<td style="border:1px dotted d4d4d4;padding-right:7px" id="tot_#getProgram.programcode#__#code#"
								    align="right" class="labelmedium"
									bgcolor="EBF7FE" 
									height="20">#numberformat(sub,',__')#</td>
								<td width="6"></td>	
								</tr>
						</table>
						
					</td>
					
					</cfif>
						
					</tr>
					
					<!--- ------------- --->
					<!--- drilldown row --->
					<!--- ------------- --->
					
					<tr id="crow_#getProgram.programcode#__#code#" class="hide">		
					   <td></td>		
					   <td colspan="#cols-1#" style="padding-left:2px;padding-top:1px;padding-right:2px" id="c_#getProgram.programcode#__#code#"></td>				
					</tr>
					
					</cfif>			
					
				</cfloop>	
							
			<!--- clear the arrays --->
				
			<cfset ArrayClear(all)>
			<cfset ArrayClear(bud)>
			<cfset ArrayClear(exp)>				
			
			<!--- ------------------------- --->
			<!--- total row for the program --->
			<!--- ------------------------- --->
									
			<tr class="#cl#">	
			
			<td></td>	
				
				<cfquery name="get"
					datasource="AppsQuery" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT   Fund,SUM(Amount) as Amount
					    FROM     #SESSION.acc#Allocation#FileNo#
						WHERE    ProgramCode IN (#preservesingleQuotes(prg)#)		
						GROUP BY Fund											
				</cfquery>		
			
				<cfloop query="get">
				    <cfset val[currentrow] = amount>
				</cfloop>
				<cfset col = 0>
				<cfset sub = 0>
					
				<cfloop index="fund" list="#fd#">
				
					<td align="right" style="padding-left:2px">					
						<cf_space spaces="#spc#">																
					</td>
					
				    <cfset col = col+1>
					<cfparam name="val[#col#]" default="0">		
					
					<td align="right" height="20">		
					
						<cf_space spaces="#spc#">		
					
						<table cellspacing="0" width="100%" cellpadding="0">
							<tr class="labelmedium">
							<td style="border-top:1px solid silver;padding-right:7px" 
							    id="tot_#getProgram.programcode#_#fund#"
							    align="right" 
								height="18" class="labelmedium">#numberformat(val[col],',__')#</td>					
							</tr>
						</table>				
					
					</td>
					
					<td align="right" style="padding-left:2px">					
						<cf_space spaces="#spc#">																
					</td>
					
					<cfset sub = sub+val[col]>
					
				</cfloop>
				
				<cfif FundList.recordcount gte "2">
				
				<td align="right">
				
					<cf_space spaces="#spc#">		
			
					<table cellspacing="0" width="100%" cellpadding="0">
						<tr class="labelmedium">
						<td style="border-top:1px solid silver;padding-right:4px" id="tot_#getProgram.programcode#"
						    align="right" class="labelmedium" bgcolor="EBF7FE" height="20">#numberformat(sub,',__')#</td>
						<td width="6"></td>	
						</tr>
					</table>  
				  
				</td>
				
				</cfif>
			
			</tr>
			
			<cfset ArrayClear(val)>
									
		</cfoutput>
			
	</cfoutput>

</table>

<cfset ajaxonload("doHighlight")>