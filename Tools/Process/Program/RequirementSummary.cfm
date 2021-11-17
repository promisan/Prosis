
<cfparam name="Attributes.Mode"             default="Quarter">
<cfparam name="Attributes.ProgramCode"      default="">
<cfparam name="Attributes.Period"           default="">
<cfparam name="Attributes.Edition"          default="">
<cfparam name="Attributes.Support"          default="Yes">

<cfparam name="url.ProgramCode"      default="#Attributes.ProgramCode#">
<cfparam name="url.Period"           default="#Attributes.Period#">
<cfparam name="url.Edition"          default="#Attributes.Edition#">

	<cfinvoke component="Service.Access"  
			Method         = "budget"
			ProgramCode    = "#URL.ProgramCode#"
			Period         = "#URL.Period#"	
			EditionId      = "#URL.edition#"  
			Role           = "'BudgetManager'"
			ReturnVariable = "BudgetAccess">	

	<cfinvoke component="Service.Process.Program.ProgramAllotment"  
			Method         = "RequirementAdjusted"
			ProgramCode    = "#URL.ProgramCode#"
			Period         = "#URL.Period#"	
			EditionId      = "#URL.Edition#"  
			ActionStatus   = "'0','1'"  <!--- 5/15/2015 added '0' --->
			Mode           = "variable"
			Support        = "#attributes.Support#"
			ReturnVariable = "myquery">			
			
	<cfquery name="getSupport" 
		datasource="AppsProgram">
		    SELECT PA.*, O.Resource
			FROM   ProgramAllotment PA INNER JOIN Ref_Object O ON PA.SupportobjectCode = O.Code
			WHERE  PA.ProgramCode = '#URL.ProgramCode#' 
			AND    PA.Period      = '#URL.Period#'
			-- AND    EditionId   = '#URL.Edition#' 
    </cfquery>	  
	
 			
	<cfquery name="getSummary" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">			
								
		SELECT     R.ListingOrder, 
		           R.Name, 
				   R.Code,
				   R.Description,
				   D.RequestYear, 
				   D.RequestQuarter,				   
				   SUM(RequestAmountBase) AS Total,  
				   SUM(SupportAmountBase) AS Support  
				   
		FROM      (#preservesingleQuotes(myquery)#) D INNER JOIN Ref_Resource R ON R.Code = D.Resource	
				
		GROUP BY R.ListingOrder, R.Name, R.Code, R.Description, D.RequestYear, D.RequestQuarter 
		ORDER BY R.ListingOrder, R.Name, R.Code, R.Description, D.RequestYear, D.RequestQuarter
									
	</cfquery>	
			
	<cfquery name="Program" 
		datasource="AppsProgram">
		    SELECT *
			FROM   Program
			WHERE  ProgramCode = '#URL.ProgramCode#' 
	</cfquery>	
	
	<cfquery name="ProgramPeriod" 
		datasource="AppsProgram">
		    SELECT *, (SELECT Mission FROM Organization.dbo.Organization WHERE OrgUnit = Pe.OrgUnit) as Mission
			FROM   ProgramPeriod Pe
			WHERE  ProgramCode = '#URL.ProgramCode#'
			AND    Period      = '#URL.Period#'			
	</cfquery>		
	
	<cfquery name="PlanPeriod" 
		datasource="AppsProgram">
		    SELECT *
			FROM   Ref_Period
			WHERE  Period = '#URL.Period#' 
	</cfquery>	 
	
	<cfif getSummary.recordcount eq "0">
	
		<table width="100%">
			<tr>
			<td class="labelmedium" align="center" style="font-size:22px; height:40px"><font color="FF0000"><cf_tl id="No detailed requirements found"></font></td>
			</tr>
	    </table>
		<cfabort>
	
	<cfelse>	
	
			<cfif url.edition gte "1">
			
				<cfquery name="getEdition" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">	
					SELECT Period 
					FROM   Ref_AllotmentEdition 
					WHERE  EditionId = '#url.edition#' 
				</cfquery>		
			
			</cfif>
											
			<cfquery name="getPeriod" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	
				SELECT    MIN(DateEffective) as DateEffective, MAX(DateExpiration) as DateExpiration 				
				FROM      Ref_Period						
				WHERE     Period IN (SELECT Period FROM ref_AllotmentEdition WHERE Mission = '#ProgramPeriod.Mission#')					
				<cfif url.edition gte "1">				
				AND       Period IN (SELECT Period FROM Ref_AllotmentEdition WHERE EditionId = '#url.edition#')					
				<cfelse>													
				<!--- we show consequitive requirements --->
				AND       Period IN (
			               SELECT Period 
			               FROM   Ref_Period 
						   WHERE  DateExpiration >= '#PlanPeriod.DateEffective#'
						   <cfif PlanPeriod.isPlanningPeriodExpiry neq "">
						   AND   DateExpiration  <= '#PlanPeriod.isPlanningPeriodExpiry#'
						   </cfif>								   
						  						 						   
						   <!--- Period is not a plan period itself in Mission Period --->
						   
						   AND    Period NOT IN (SELECT PP.Period 
							                     FROM   Organization.dbo.Ref_MissionPeriod PP, 
												        Ref_Period RE
												 WHERE  PP.Period    = Re.Period
												 AND    PP.Mission   = '#Program.mission#'    
												 <!--- not like the correct period --->
												 AND    PP.Period   != '#url.period#'
												 AND    Re.IsPlanningPeriod = 1 
												 AND    PP.isPlanPeriod = 1)		
													
					      )																							 
				</cfif>
			</cfquery>
									
			<cfif getPeriod.DateEffective eq "">
			
				<table width="100%"><tr><td class="labelmedium" align="center" style="height:40px"><font color="808080">Requirement view not supported</font></td></tr></table>
				<cfabort>
			
			</cfif>
				
			<cfquery name="getLast" dbtype="query">
			    SELECT    *
				FROM      getSummary				
				ORDER BY  RequestYear DESC
			</cfquery>						
			
			<cfquery name="getResource" dbtype="query">
			    SELECT    DISTINCT ListingOrder, Name, Description
				FROM      getSummary
				<cfif getsupport.Resource neq "">
				WHERE     Code <> '#getsupport.Resource#'
		       </cfif>					
			</cfquery>	
				
			<cfset SY = year(getPeriod.DateEffective)>
			<cfset SM = quarter(getPeriod.DateEffective)>
				
			<cfif getLast.RequestYear gt year(getPeriod.DateEffective)>
					<cfset EY = getLast.RequestYear>
					<cfset EM = 4>
			<cfelse>
					<cfset EY = year(getPeriod.DateEffective)>
					<cfset EM = quarter(getPeriod.DateEffective)>
			</cfif>								
				
			<table width="100%" border="0" class="navigation_table">
							
			<!--- we build an array --->
			
				<cfoutput>
				
				<cfset ar = ArrayNew(3)> <!--- requirement --->
				<cfset su = ArrayNew(3)> <!--- support     --->
			
			    <!--- populate array --->
				<cfloop query="getSummary">
				    <cfif RequestQuarter eq "">
						<cfset ar[SY][SM][ListingOrder] = total>	
						<cfset su[SY][SM][ListingOrder] = support>
					<cfelse>					   	
						<cfset ar[RequestYear][RequestQuarter][ListingOrder] = total>	
						<cfset su[RequestYear][RequestQuarter][ListingOrder] = support>	
					</cfif>					
				</cfloop>
							
			    <!--- get width --->	
						
				<cfset cnt = 0>		
				<cfloop index="yr" from="#SY#" to="#EY#">		
				    <cfif yr eq SY>					
					    <cfset fr = sm>
						<cfset to = 4>				
					<cfelseif yr lt EY>
						<cfset fr = 1>
						<cfset to = 4>			   
					<cfelse>
						<cfset fr = 1>
						<cfset to = em>			  
					</cfif>					
					<cfloop index="mt" from="#fr#" to="#to#">				
						<cfset cnt = cnt+1>							  						
					</cfloop>	
					<cfset cnt = cnt+1>						
				</cfloop>
				
				<!--- get header --->	
						
				<cfset w = 65/cnt>
				
				<cfset cnt = 0>
				<tr class="labelmedium line fixlengthlist" style="background-color:f1f1f1">
				<td style="height:20px;padding-left:4px;border:1px solid silver"><cf_tl id="Resource"></td>
				
				<cfloop index="yr" from="#SY#" to="#EY#">		
				
				    <cfif yr eq SY>					
					    <cfset fr = sm>
						<cfset to = 4>				
					<cfelseif yr lt EY>
						<cfset fr = 1>
						<cfset to = 4>			   
					<cfelse>
						<cfset fr = 1>
						<cfset to = em>			  
					</cfif>									
					<cfloop index="mt" from="#fr#" to="#to#">				
						<cfset cnt = cnt+1>				
					    <td width="#w#%" align="right" style="border:1px solid silver" align="center">Qtr #mt#</td>														
					</cfloop>	
					<td bgcolor="ffffcf" align="right" width="#w#%" style="font-size:16px;border:1px solid silver" align="center">#yr#</td>								
				</cfloop>
				<td style="font-size:16px;padding-right:4px;border:1px solid silver" align="right" bgcolor="E3E8C6"><b>#planperiod.description#</td>
				</tr>
						
				<!--- lines --->		
					
				<cfloop query="getResource">	
				
				    <cfset tot = 0>	
					<tr class="linedotted navigation_row fixlengthlist labelmedium2">	
					<td style="height:18px">#Description#</td>	
						
						<cfloop index="yr" from="#SY#" to="#EY#">		
									
						    <cfif yr eq SY>					
							    <cfset fr = sm>
								<cfset to = 4>				
							<cfelseif yr lt EY>
								<cfset fr = 1>
								<cfset to = 4>			   
							<cfelse>
								<cfset fr = 1>
								<cfset to = em>			  
							</cfif>		
							
							<cfset yrt = 0>
												
							<cfloop index="mt" from="#fr#" to="#to#">	
							    <cfparam name="ar[yr][mt][listingorder]" default="">	
								<cfif ar[yr][mt][listingorder] neq "">									
								<td align="right" style="border-right:1px solid silver;height:18px">						
									#numberformat(ar[yr][mt][listingorder],',__')#
									<cfset yrt = yrt + ar[yr][mt][listingorder]>
									<cfset tot = tot + ar[yr][mt][listingorder]>
								</td>	
								<cfelse>
								<td bgcolor="F1F1F1" style="height:18px;padding-right:12px;border-right:1px solid silver;"></td>	
								</cfif>
									
							</cfloop>		
							
							<td bgcolor="ffffcf" align="right" class="labelit" style="border-right:1px solid silver;background-color:##ffffaf80;height:18px">#numberformat(yrt,'__,__')#</td>
											   								
						</cfloop>	
							
						<td width="10%" class="labelmedium" bgcolor="E3E8C6" style="border-right:1px solid silver;background-color:##E3E8C680;font-size:13px;height:18px" align="right">
						#numberformat(tot,',__')#			
						</td>				
					</tr>				
							
				</cfloop>	
				
				<cfset tot = 0>	
				<tr class="line labelmedium2 fixlengthlist" style="border-top:1px solid silver">	
					<td><cf_tl id="Total Requirements"></td>
							
						<cfloop index="yr" from="#SY#" to="#EY#">					
						
						    <cfif yr eq SY>					
							    <cfset fr = sm>
								<cfset to = 4>				
							<cfelseif yr lt EY>
								<cfset fr = 1>
								<cfset to = 4>			   
							<cfelse>
								<cfset fr = 1>
								<cfset to = em>			  
							</cfif>		
							
							<cfset yrt = 0>										
							
							<cfloop index="mt" from="#fr#" to="#to#">	
							    
								<cfset sub = 0>
								 
								<cfloop query="getResource">	
								
								    <cftry>
									<cfset sub = sub + ar[yr][mt][listingorder]>
									<cfset yrt = yrt + ar[yr][mt][listingorder]>
									<cfcatch></cfcatch>
									</cftry>
								
								</cfloop>
													    							
								<td align="right" style="border-right:1px solid silver;height:22px">						
									#numberformat(sub,',__')#							
								</td>	
								<cfset tot = tot+sub>
															
							</cfloop>	
							
							<td bgcolor="ffffcf" style="border-right:1px solid silver;background-color:##ffffaf80;height:22px" align="right">#numberformat(yrt,'__,__')#</td>
																			   								
						</cfloop>	
							
						<td align="right" bgcolor="E3E8C6" style="border-right:1px solid silver;background-color:##E3E8C680;height:22px">
						#numberformat(tot,',__')#			
						</td>				
				
				</tr>										
				 										
				<cfif getsupport.SupportPercentage gt "0">
					
					<!---
						<cfset ratio = getsupport.SupportPercentage/100>
						
						--->
						
						<tr class="line labelmedium2">	
							<td><cf_tl id="Program Support Cost"></td>	
							
								<cfset tot = 0>			
								
								<cfloop index="yr" from="#SY#" to="#EY#">		
											
								    <cfif yr eq SY>					
									    <cfset fr = sm>
										<cfset to = 4>				
									<cfelseif yr lt EY>
										<cfset fr = 1>
										<cfset to = 4>			   
									<cfelse>
										<cfset fr = 1>
										<cfset to = em>			  
									</cfif>		
									
									<cfset yrt = 0>		
																										
									<cfloop index="mt" from="#fr#" to="#to#">	
									    
										<cfset sub = 0>
										<cfset flt = 0>
										
										<!--- calculated support records --->	
										 
										<cfloop query="getResource">	
										
										    <cftry>
											<cfset sub = sub + su[yr][mt][listingorder]>
											<cfset yrt = yrt + su[yr][mt][listingorder]>
											<cfset tot = tot + su[yr][mt][listingorder]>
											<cfcatch></cfcatch>
											</cftry>	
																				
										</cfloop>
																																																	
										<!--- now we add manual support records --->										
																				
										<cfif getSupport.Resource neq "">
										
											<cfquery name="getSupportLines" dbtype="query">
											    SELECT    DISTINCT ListingOrder, Name, Description
												FROM      getSummary											
												WHERE     Code = '#getsupport.Resource#'									      					
											</cfquery>
											
											<cfloop query="getSupportLines">
											
												<cftry>
												<cfset sub = sub + ar[yr][mt][listingorder]>												
												<cfset yrt = yrt + ar[yr][mt][listingorder]>
												<cfset tot = tot + ar[yr][mt][listingorder]>
												<cfcatch></cfcatch>
												</cftry>
											
											</cfloop>	
																															
										</cfif>																		
																																			    							
										<td align="right" style="border-right:1px solid silver;font-size:13px;height:18px">						
											#numberformat(sub,',__')#							
										</td>									
																	
									</cfloop>	
																																																					
									<td bgcolor="ffffcf" style="border-right:1px solid silver;font-size:13px;height:18px" align="right">
									#numberformat(yrt,',__')#
									</td>
																					   								
								</cfloop>	
																						
								<td bgcolor="E3E8C6" width="10%" align="right" style="border-right:1px solid silver;font-size:13px;height:18px">								
								#numberformat(tot,',__')#			
								</td>				
								
						</tr>	
						
						<cfif BudgetAccess neq "NONE">
						
							<!--- final overal total row --->
						
							<tr bgcolor="EBEAE7" class="labelmedium2">	
								<td><cf_tl id="Overall"></td>		
								
								    <cfset tot = 0>
									
									<cfloop index="yr" from="#SY#" to="#EY#">		
												
									    <cfif yr eq SY>					
										    <cfset fr = sm>
											<cfset to = 4>				
										<cfelseif yr lt EY>
											<cfset fr = 1>
											<cfset to = 4>			   
										<cfelse>
											<cfset fr = 1>
											<cfset to = em>			  
										</cfif>		
										<cfset yrt = 0>		
																												
										<cfloop index="mt" from="#fr#" to="#to#">	
										    
											<cfset sub = 0>
											 
											<cfloop query="getResource">	
											
											    <cftry>
												<cfset sub = sub + ar[yr][mt][listingorder]>
												<cfset sub = sub + su[yr][mt][listingorder]>
												<cfset yrt = yrt + ar[yr][mt][listingorder]>
												<cfset yrt = yrt + su[yr][mt][listingorder]>
												<cfset tot = tot + ar[yr][mt][listingorder]>
												<cfset tot = tot + su[yr][mt][listingorder]>
												<cfcatch></cfcatch>
												</cftry>
											
											</cfloop>
																																	
											<cfif getSupport.Resource neq "">
										
												<cfquery name="getSupportLines" dbtype="query">
												    SELECT    DISTINCT ListingOrder, Name, Description
													FROM      getSummary											
													WHERE     Code = '#getsupport.Resource#'									      					
												</cfquery>
												
												<cfloop query="getSupportLines">
												
													<cftry>
													<cfset sub = sub + ar[yr][mt][listingorder]>
													<cfset yrt = yrt + ar[yr][mt][listingorder]>
													<cfset tot = tot + ar[yr][mt][listingorder]>
													<cfcatch></cfcatch>
													</cftry>
												
												</cfloop>	
																				
											</cfif>											
																											    							
											<td align="right" style="border-right:1px solid silver;height:22px">						
												<b>#numberformat(sub,',__')#</b>							
											</td>																
																		
																		
										</cfloop>	
																				
										<td bgcolor="ffffcf" style="border-right:1px solid silver;height:22px" align="right">
										<b>#numberformat(yrt,',__')#</b></td>
																						   								
									</cfloop>		
																		
									<td align="right" bgcolor="E3E8C6" style="border-right:1px solid silver;height:22px">
										<b>#numberformat(tot,',__')#</b></td>				
							</tr>		
						
						</cfif>												
					
					</cfif>							
											
			    </cfoutput>	
			
			</table>
			
	</cfif>	
	
	<cfset ajaxonload("doHighlight")>	