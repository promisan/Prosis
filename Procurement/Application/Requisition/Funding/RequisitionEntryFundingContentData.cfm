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
<cfset cnt = 0>

<!--- --------- --->
<!--- fund loop --->
<!--- --------- --->

<cfloop query="Edition">

	<cfif showmode eq "standard">
	
		<!--- ----------------------------------------------------------------------------- --->
		<!--- provision to open the selected object of expenditire upon editing of the fund --->
		<!--- ----------------------------------------------------------------------------- --->
		
		<cfquery name="Current" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   DISTINCT ProgramCode
			FROM     RequisitionLineFunding
			WHERE    RequisitionNo = '#URL.ID#' 	
			AND      Fund          = '#fund#'
		</cfquery>
		
		<cfset cur = "">
		<cfloop query="current">
			<cfset cur = "#cur#,#programcode#">
		</cfloop>	
		
		<cfquery name="getProgramLedger" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
				SELECT  DISTINCT TL.ProgramCode 
			    FROM    TransactionHeader TH,
				        TransactionLine TL
				 WHERE  TH.Mission         = '#url.mission#'		
				 AND    TH.Journal         = TL.Journal
				 AND    TH.JournalSerialNo = TL.JournalSerialNo		
				 <!---								 
				 AND    TL.ProgramPeriod   = '#period#'		
				 --->
				 AND    TH.AccountPeriod IN (#preservesingleQuotes(peraccsel)#) 	
				 <cfif fund neq "">
				 AND    TL.Fund = '#Fund#'			
			     </cfif>
		</cfquery> 
			
		<!--- ----------------------------------------------------------------------------- --->
		<!--- select fundable programs ---------------------------------------------------- --->
		<!--- ----------------------------------------------------------------------------- --->
								
		<cfquery name="Program" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   P.ProgramCode,
			         P.ProgramName,
	                 Pe.PeriodHierarchy as ProgramHierarchy,
					 Pe.PeriodDescription as ProgramDescription,
					 P.ProgramClass, 
					 P.ProgramScope,					
					 Pe.Reference,
					 Pe.ReferenceBudget1,
					 Pe.ReferenceBudget2,
					 Pe.ReferenceBudget3,
					 Pe.ReferenceBudget4,
					 Pe.ReferenceBudget5,
					 Pe.ReferenceBudget6								 
					 
			FROM     Program P INNER JOIN
			         ProgramPeriod Pe ON P.ProgramCode = Pe.ProgramCode				 
	
			WHERE    P.Mission = '#URL.Mission#' 
			AND      Pe.Period = '#per#' 
			<cfif URL.Job eq ""> 			   						
			AND      Pe.OrgUnit IN (SELECT  OrgUnit 
				                    FROM    Organization.dbo.Organization
				                    WHERE   Mission = '#URL.Mission#'
								    AND     HierarchyCode >= '#HStart#' 
								    AND     HierarchyCode < '#HEnd#') 			
			<cfelse> <!--- provision for job additions S&H --->
			AND      Pe.OrgUnit IN (SELECT OrgUnit 
			                        FROM  Purchase.dbo.RequisitionLine 
								    WHERE JobNo = '#URL.Job#')  
			</cfif>				
					
			<!--- ---------------------------------------------------- --->
			<!--- additional filter added, to be checked for CMP as they might link for project which 
			are not funded, make it a parameter instead --->
			
			<!--- show only programs that have or a budget or have a funding used --->
			
			
			<cfif Parameter.FundingOnProgram eq "1">
						
			AND   (
						         
					 P.ProgramCode IN ( 
			
						   <!--- enabled for procurement except if this is global 
						   20/20/10 : removed distinct to make the query go much faster !! 
						   --->  
	
						   SELECT PR.ProgramCode 
	                       FROM  Program PR,
						         ProgramObject PD
						   WHERE PR.Mission      = '#URL.Mission#'
						   AND   PR.ProgramScope  = 'Unit'
						   AND   PR.ProgramCode  = PD.ProgramCode
						   AND   PD.Fund         = '#Fund#'					  				   
						   					   
						   )					   
											   
					OR 	 P.ProgramCode IN (   					   
						  					  					 							   
						   <!--- used in allotment --->	
	
						   SELECT PR.ProgramCode 
	                       FROM  Program PR,ProgramAllotmentDetail PD
						   WHERE PR.ProgramCode = PD.ProgramCode
						   AND   PR.Mission     = '#URL.Mission#'
						   AND   PD.Period     = '#per#'
						   AND   PD.Fund       = '#Fund#'						  			   
						   AND   PD.Amount <> '0'					   
						   )
						   					   
					OR 	 P.ProgramCode IN (   	   		  
						   
						   <!--- used in purchase --->
						   
						   SELECT F.ProgramCode 
	                       FROM  Purchase.dbo.RequisitionLine R,
						         Purchase.dbo.RequisitionLineFunding F
						   WHERE R.RequisitionNo = F.RequisitionNo
						   AND   R.Mission    = '#URL.Mission#'
						   AND   R.Period     = '#URL.Period#'
						   AND   F.Fund       = '#Fund#'						   			   
						   AND   (R.ActionStatus > '1' AND R.ActionStatus <> '9')						   
						   )
					
					<cfif getProgramLedger.ProgramCode neq "">	   
					OR 	 P.ProgramCode IN (#QuotedValueList(getProgramLedger.ProgramCode)#)		   
					</cfif>
						   
						   <!--- removed for performance reasons 		   					   
						  
						   UNION  <!--- used in financials --->
						   
						   SELECT DISTINCT L.ProgramCode 						   
						   FROM   Accounting.dbo.TransactionLine L INNER JOIN
							      Accounting.dbo.TransactionHeader H ON L.Journal = H.Journal AND L.JournalSerialNo = H.JournalSerialNo
						   WHERE  H.Mission      = '#URL.Mission#'
						   AND    H.AccountPeriod IN (#preservesingleQuotes(peraccsel)#) 	
						   
						   AND    L.Fund        = '#Fund#'
						   AND    L.ObjectCode IN (SELECT Code 
						                           FROM   Ref_Object 
												   WHERE  Procurement = 1)			
												   
												   --->		
												   
					  ) 							   
			</cfif>				
						   
			AND      Pe.RecordStatus <> '9'	
			ORDER BY Pe.PeriodHierarchy	
			
		</cfquery>		
	
		<!---
		<cfparam name="t" default="0">	
		<br>
		<cfset t = t + cfquery.executiontime>	
		<cfoutput>#fund# P: #cfquery.ExecutionTime# :  #t#</cfoutput> 	
		
		--->
		
		<cfif program.recordcount gte 1>
			<cfset showfund = "1">
		<cfelse>
			<cfset showfund = "0">			
		</cfif> 
		
	<cfelse>
	
		<cfset showfund = "1">
	
	</cfif>
	
		
	<cfif showfund eq "1">
	
		<cfoutput>		
						
			<cfif showmode eq "standard">
				<cfset cl = "E0FACF">
			<cfelse>
			    <cfset cl = "EAFBFD">
			</cfif>
						
			<cfquery name="Total" 
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
				SELECT  TOP 1 'Result' as Result,
				
						(
						SELECT    ISNULL(SUM(Total),0) AS Total
						FROM      dbo.#SESSION.acc#Requirement						
						WHERE     Fund = '#fund#'					
							 		
						) as Requirement,
						
						(
						SELECT   ISNULL(SUM(Total),0) AS Total
						FROM      dbo.#SESSION.acc#Release
						WHERE     Fund = '#fund#'					
						) as Allotment,						
											
						(
						SELECT   ISNULL(SUM(ReservationAmount),0) as Amount
						FROM     dbo.#SESSION.acc#Planned
						WHERE    Fund = '#fund#'											
						) as Planned,
						
						(
						SELECT   ISNULL(SUM(ReservationAmount),0) as Amount
						FROM     dbo.#SESSION.acc#Requisition
						WHERE    Fund = '#fund#'					
						) as Reservation,
														
						(
						SELECT   ISNULL(SUM(ObligationAmount),0) as Amount 
						FROM     #SESSION.acc#Obligation
						WHERE    Fund = '#fund#'													
						) as Obligation,
						
						(
						SELECT   ISNULL(SUM(InvoiceAmount),0) as Amount
						FROM     dbo.#SESSION.acc#Invoice
						WHERE    Fund = '#fund#'					
	
						) as Invoice
															
				FROM      Program.dbo.Ref_Fund
				WHERE     Code = '#fund#'					
				
			</cfquery>
			
			<cfif total.Requirement neq "0" 
			    or Total.allotment  neq "0" 
				or Total.Planned    neq "0" 
				or Total.Obligation neq "0">
			
			<tr>
			<td width="100%" bgcolor="#cl#" class="labelmedium" style="padding-left:10px">#Fund#</td>
									
			<!--- fund totals --->
							
			<td align="right" 
			    bgcolor="f1f1f1" 
				style="border-left: 1px solid Gray;" style="padding-left:1px">																					
				<cfset rsc =  total.Requirement>											
				<cf_space align="right" label="#numberformat(rsc/1000,",._")#" spaces="#spc#">	
			</td>		
			<td align="right" bgcolor="f1f1f1" style="padding-left:1px;border-left: 1px solid Gray;">										
				<cfset all =  total.allotment>			
				<cf_space align="right" label="#numberformat(all/1000,",._")#" spaces="#spc#">							
			</td>		
			<td align="right" bgcolor="ffffdf" style="padding-left:1px;border-left: 1px solid Gray">													
				<cfset pla =  Total.Planned>
				<cf_space align="right" label="#numberformat(pla/1000,",._")#" spaces="#spc#">				
			</td>		
			<td align="right" bgcolor="ffffdf" style="padding-left:1px;border-left: 1px solid Gray;">						
				<cfset res =  Total.Reservation>
				<cf_space align="right" label="#numberformat(res/1000,",._")#" spaces="#spc#">								
			</td>
			<td align="right" bgcolor="ffffdf" style="padding-left:1px;border-left: 1px solid Gray;">						
				<cfset obl =  Total.Obligation>
				<cf_space align="right" label="#numberformat(obl/1000,",._")#" spaces="#spc#">									
			</td>				
			<td align="right" bgcolor="ffffaf" style="padding-left:1px;border-left: 1px solid Gray;">	
								
				<cfif Parameter.FundingCheckCleared eq "0">			
					<cfif rsc-obl-res gte 0>
						<cf_space align="right" label="#numberformat((rsc-pla-obl-res)/1000,",._")#" spaces="#spc#">
					<cfelse>
						<cf_space align="right" label="#numberformat((rsc-pla-obl-res)/1000,",._")#" spaces="#spc#" color="red">
					</cfif>			
				<cfelse>					
					<cfif all-obl-res gte 0>
						<cf_space align="right" label="#numberformat((all-pla-obl-res)/1000,",._")#" spaces="#spc#">
					<cfelse>
						<cf_space align="right" label="#numberformat((all-pla-obl-res)/1000,",._")#" spaces="#spc#" color="red">
					</cfif>						
				</cfif>				
			</td>		
			<td align="right" style="padding-left:1px;border-left: 1px solid Gray;;padding-right:2px">					
				<cfset inv =  Total.Invoice>
				<cf_space align="right" label="#numberformat(inv/1000,",._")#" spaces="#spc#">					
			</td>	
				
			<td bgcolor="white" style="border-left: 1px solid Gray;"><cf_space spaces="2"></td>		
			
			</tr>	
			
			</cfif>		
				
						
		</cfoutput>
		
	</cfif>		
	
	<cfif showmode eq "standard">
		
		<cfset cnt = cnt+program.recordcount>
		
		<cfset edid = editionid>
		<cfset fdid = fund>	
	
		<cftry>				
								 
			<cfoutput query="Program">
								
				<cfif ProgramClass eq "Program">
					 <cfset cl = "e7e7e7">
				<cfelseif ProgramClass eq "Component">
					 <cfset cl = "ffffcf"> 
				<cfelse>
					 <cfset cl = "ffffff">
				</cfif>
						
				<tr bgcolor="#cl#" class="navigation_row line">
						
				<td height="20" width="100%">
																	
					<table width="100%" cellspacing="0" cellpadding="0">
					<tr>
					
		    		<td align="center" width="30" class="navigation_action" onclick="object('#programcode#','#url.mission#','#url.period#','#programclass#','#programhierarchy#','#edid#','#fdid#')">
					
						<cf_space spaces="10">	
						
						<cfif findNoCase(programcode,cur)>		
														
						   <img src="#SESSION.root#/Images/icon_expand.gif" alt="" 
								id="#programcode#_#edid#_#fdid#Exp" border="0" class="hide" 
								align="absmiddle" style="cursor: pointer;">
														
						   <img src="#SESSION.root#/Images/icon_collapse.gif" 
								id="#programcode#_#edid#_#fdid#Min" alt="" border="0" 
								align="absmiddle" class="regular" style="cursor: pointer;">			
								
						<cfelse>
						
						   <img src="#SESSION.root#/Images/icon_expand.gif" alt="" 
								id="#programcode#_#edid#_#fdid#Exp" border="0" class="regular" 
								align="absmiddle" style="cursor: pointer;">
														
						   <img src="#SESSION.root#/Images/icon_collapse.gif" 
								id="#programcode#_#edid#_#fdid#Min" alt="" border="0" 
								align="absmiddle" class="hide" style="cursor: pointer;">			
						
						</cfif>		
						
					</td>
									
					<td width="100%" bgcolor="<cfif ProgramClass eq 'Program'>eaeaea</cfif>">
							
					<cf_space spaces="127">
											 
					<table width="100%">
					
						 <cfif ProgramScope neq "Unit">		
							 <cfset cl = "ffffcf">								 
						 </cfif>
						<tr>
						<td style="min-width:40px">
						<cfloop index="itm" list="#ProgramHierarchy#" delimiters=".">
						  <b>.&nbsp;&nbsp;</b>
						</cfloop>
						</td>
						<td class="labelit" style="padding-right:4px" onclick="object('#programcode#','#url.mission#','#url.period#','#programclass#','#programhierarchy#','#edid#','#fdid#')">
		
								     <cf_space spaces="30">
							 <cfif ReferenceBudget1 neq "">
								#ReferenceBudget1#-#ReferenceBudget2#-#ReferenceBudget3#<cfif ReferenceBudget4 neq "">-#ReferenceBudget4#</cfif><cfif ReferenceBudget5 neq "">-#ReferenceBudget5#</cfif><cfif ReferenceBudget6 neq "">-#ReferenceBudget6#</cfif>						
							 <cfelseif Reference neq "">
								#Reference#
							 <cfelse>
							    <cfif ProgramScope eq "Unit">					
									#ProgramCode#
								</cfif>					
							</cfif>					
						</td>		
						<td class="labelit" width="100%">
															 
						<cfif ProgramClass eq "Program">
						
							<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
							 <tr><td align="center" class="labelit">												
								 <font size="2">
								 <a href="javascript:object('#programcode#','#url.mission#','#url.period#','#programclass#','#programhierarchy#','#edid#','#fdid#')" title="#programdescription#">#ProgramName#</a>
								 </font>
								 </td>					 
								 <td></td>
								 </tr>
						    </table>
							
						 <cfelse>
						 
	                         <table cellspacing="0" cellpadding="0">
							 <tr><td class="labelit" style="padding-right:6px">#left(ProgramClass,1)#:</td>
							 	<td class="labelit">							 		 				    
								 <a href="javascript:AllotmentInquiry('#ProgramCode#','#fdid#','#URL.Period#','Budget','#Edition.Version#')" title="#programdescription#">
								 <font color="0080C0">#ProgramName#</font>
								 </a>
								 </td>
							 </tr>
							 </table>	
							 
						 </cfif>	
							 
						</td>
						</tr>
					</table>
					</td>
					</tr>
					
					</table>
								
				</td>
				
				<!--- added 15/10/2012 as clustered query to make it a bit faster --->
						
				<cfquery name="Total" 
					datasource="AppsQuery" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					
					SELECT  TOP 1 'Result' as Result,
					
							(
							SELECT    ISNULL(SUM(Total),0) AS Total
							FROM      dbo.#SESSION.acc#Requirement						
							WHERE     ProgramHierarchy LIKE '#ProgramHierarchy#%'													  						
							<cfif fdid neq "">						  
							AND       Fund = '#fdid#'					
							</cfif>		 		
							) as Requirement,
							
							(
							SELECT   ISNULL(SUM(Total),0) AS Total
							FROM      dbo.#SESSION.acc#Release
							WHERE     ProgramHierarchy LIKE '#ProgramHierarchy#%'									  												  
							<cfif fdid neq "">						  
							AND       Fund = '#fdid#'					
							</cfif> ) as Allotment,						
												
							(
							SELECT   ISNULL(SUM(ReservationAmount),0) as Amount
							FROM     dbo.#SESSION.acc#Planned
							WHERE    ProgramHierarchy LIKE '#ProgramHierarchy#%'
							<cfif fdid neq "">						  
								AND       Fund = '#fdid#'					
							</cfif>						
							) as Planned,
							
							(
							SELECT   ISNULL(SUM(ReservationAmount),0) as Amount
							FROM     dbo.#SESSION.acc#Requisition
							WHERE    ProgramHierarchy LIKE '#ProgramHierarchy#%'
							<cfif fdid neq "">						  
								AND       Fund = '#fdid#'					
							</cfif>				
							) as Reservation,
															
							(
							SELECT   ISNULL(SUM(ObligationAmount),0) as Amount 
							FROM     #SESSION.acc#Obligation
							WHERE    ProgramHierarchy LIKE '#ProgramHierarchy#%'
								<cfif fdid neq "">						  
									AND       Fund = '#fdid#'					
								</cfif>		
							) as Obligation,
							
							(
							SELECT   ISNULL(SUM(InvoiceAmount),0) as Amount
							FROM     dbo.#SESSION.acc#Invoice
							WHERE    ProgramHierarchy LIKE '#ProgramHierarchy#%'
							<cfif fdid neq "">						  
							AND       Fund = '#fdid#'					
							</cfif>		
							) as Invoice
																
					FROM      Program.dbo.Program
					WHERE     ProgramCode = '#ProgramCode#'					
					
				</cfquery>
				
				<!--- 16ms is a bit too much here, can be improved to close to 0 
				<cfoutput>P: #cfquery.ExecutionTime#</cfoutput> 
				--->
					
											
				<td align="right" 
				    bgcolor="f1f1f1" 
					style="border-left: 1px solid Gray;"  
					onclick="object('#programcode#','#url.mission#','#url.period#','#programclass#','#programhierarchy#','#edid#','#fdid#')">																		
					<cfset rsc =  total.Requirement>											
					<cf_space align="right" label="#numberformat(rsc/1000,"_,_._")#" spaces="#spc#">	
				</td>		
				<td align="right" bgcolor="f1f1f1" style="border-left: 1px solid Gray;"
				    onclick="object('#programcode#','#url.mission#','#url.period#','#programclass#','#programhierarchy#','#edid#','#fdid#')">										
					<cfset all =  total.allotment>			
					<cf_space align="right" label="#numberformat(all/1000,"_,_._")#" spaces="#spc#">							
				</td>		
				<td align="right" bgcolor="ffffdf" style="border-left: 1px solid Gray">										
					<cfset pla =  Total.Planned>
					<cf_space align="right" label="#numberformat(pla/1000,"_,_._")#" spaces="#spc#">				
				</td>		
				<td align="right" bgcolor="ffffdf" style="border-left: 1px solid Gray;">						
					<cfset res =  Total.Reservation>
					<cf_space align="right" label="#numberformat(res/1000,"_,_._")#" spaces="#spc#">								
				</td>
				<td align="right" bgcolor="ffffdf" style="border-left: 1px solid Gray;">						
					<cfset obl =  Total.Obligation>
					<cf_space align="right" label="#numberformat(obl/1000,"_,_._")#" spaces="#spc#">									
				</td>				
				<td align="right" bgcolor="ffffaf" style="border-left: 1px solid Gray;">	
									
					<cfif Parameter.FundingCheckCleared eq "0">			
						<cfif rsc-obl-res gte 0>
							<cf_space align="right" label="#numberformat((rsc-pla-obl-res)/1000,"_,_._")#" spaces="#spc#">
						<cfelse>
							<cf_space align="right" label="#numberformat((rsc-pla-obl-res)/1000,"_,_._")#" spaces="#spc#" color="red">
						</cfif>			
					<cfelse>					
						<cfif all-obl-res gte 0>
							<cf_space align="right" label="#numberformat((all-pla-obl-res)/1000,"_,_._")#" spaces="#spc#">
						<cfelse>
							<cf_space align="right" label="#numberformat((all-pla-obl-res)/1000,"_,_._")#" spaces="#spc#" color="red">
						</cfif>						
					</cfif>				
				</td>		
				<td align="right" style="border-left: 1px solid Gray;;padding-right:2px">					
					<cfset inv =  Total.Invoice>
					<cf_space align="right" label="#numberformat(inv/1000,"_,_._")#" spaces="#spc#">					
				</td>	
					
				<td bgcolor="white" style="border-left: 1px solid Gray;"><cf_space spaces="2"></td>		
				
				</tr>
						 
					<cfif findNoCase(programcode,cur)>
					 
					 	<tr id="d#ProgramCode#_#edid#_#fdid#" class="regular">
					     <td colspan="9">											 
		    			 <cfdiv id="i#ProgramCode#_#edid#_#fdid#" 
						 bind="url:RequisitionEntryFundingSelectObject.cfm?isparent=1&ItemMaster=#URL.ItemMaster#&id=#url.id#&programcode=#programcode#&programclass=#programclass#&mission=#URL.mission#&programhierarchy=#programhierarchy#&period=#url.period#&edition=#edid#&fund=#fdid#"/>								 
						 </td>
						</tr> 
						 			   			 
					<cfelse>
					 
					 	<tr id="d#ProgramCode#_#edid#_#fdid#" class="hide">
					     <td colspan="9"><cfdiv id="i#ProgramCode#_#edid#_#fdid#"/></td>
						</tr>	
					   
					</cfif>
				
			</cfoutput>		
					
		<cfcatch>
			
			<tr><td colspan="9" class="labelit" height="40" align="center"><font size="2" color="FF8040">We encoutered a network delay. Please make you selection again</td></tr>
			<cfabort>
				
		</cfcatch>
			
		</cftry>
		
	</cfif>	
				
</cfloop>
	
<!--- final section --->

<cfif showmode eq "standard">
		
	<cfif cnt eq "0">
	
		<tr><td colspan="9" class="labelmedium" style="padding-top:40px" height="38" align="center"><font color="FF0000">
	
	     <cf_message message = "Sorry, but I am not able to locate any project or programs for the selected unit. Request for this unit can not be completed!"
	    	  return = "no">
			  
			  </td>
		</tr>	  
			
	<cfelse>
							
			<tr><td colspan="9" height="1" class="line"></td></tr>
			
			<tr class="hide"><td colspan="9">
				<iframe name="result" id="result" width="100%" height="100" frameborder="0"></iframe>
			</td></tr>
			
		
	</cfif>
	
</cfif>	
	
