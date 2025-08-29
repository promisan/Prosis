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
<table style="width:100%" height="100%">

<cfquery name="CurrencyList"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM Currency
</cfquery>

<cfif Component.recordcount eq "0">

	<table><tr><td class="labellarge">	
	  Schedule has not been enabled for components 	  
	  </td></tr></table>
	
<cfelse>

	
	<cfset w = 80/Component.recordcount>
					
	<cfquery name="PostGrade"
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
    	SELECT   *
		FROM     SalaryScheduleServiceLevel P, 
		         Employee.dbo.Ref_PostGrade R
		WHERE    P.ServiceLevel   = R.PostGrade		
		AND      P.SalarySchedule = '#url.schedule#'
		AND      P.Operational = 1
		ORDER BY R.PostOrder
	</cfquery>			

        <cfset init="false">
	
	    <!--- header 1 --->
		
		<tr>
		
		<td colspan="<cfoutput>#component.recordcount+2#</cfoutput>" valign="top">
		
			<cf_divscroll>	
									
			<table width="99%">		
		
			<tr class="labelmedium fixrow" style="border:0px;height:20px">
			
			   <td valign="top" style="padding-top:4px;min-width:80px"><!---<b><cf_tl id="Step">---></td>
			   
			   <cfoutput query="Component">
			   
			     <cfquery name="getCurrency"
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				    SELECT  TOP 1 *
					FROM    SalaryScaleLine
					WHERE   ScaleNo        = '#Scale.ScaleNo#' 				
					AND     ComponentName  = '#ComponentName#'							
	     		</cfquery>		
				
				<cfif getCurrency.recordcount gte "1">
						
	    			 <cfset curr = getCurrency.Currency>
					 
				<cfelse>
							
					 <cfquery name="schedule"
						datasource="AppsPayroll" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
					    SELECT  TOP 1 *
						FROM    SalarySchedule
						WHERE   SalarySchedule = '#Scale.SalarySchedule#'						
		     		</cfquery>		
									
				     <cfset curr = schedule.PaymentCurrency>
					 
				</cfif>		
			   
			   <td valign="top" style="padding-right:2px;border-right:1px solid silver;border-left:1px solid silver;padding-left:2px">
			   
			   <table width="100%" align="center" class="formpadding">		
			    
				   <tr class="labelit">
				   <td height="20" align="center" style="font-size:14px;cursor:pointer;min-width:80px;word-break: break-all;">
					   <cf_UItooltip  tooltip="#ComponentName# #Description#">#left(ComponentName,10)#</cf_UItooltip>
				   </td>
				   </tr> 
				   
				   <tr><td align="center">
				   
				   <table>
				   <tr class="labelit"><td>
				   
				    <cfset cp = "#replace(ComponentName,' ','','ALL')#">
				    <cfset cp = "#replace(cp,'-','','ALL')#">
					
				   	<select name="Currency_#cp#" style="font:10px;border:0px">
					  <cfloop query="CurrencyList">
					    <option value="#Currency#" <cfif Currency eq curr>selected</cfif>>#Currency#</option>
					  </cfloop>
					</select>	
					
					<input type="hidden" name="Currency_#cp#_old" id="Currency_#cp#_old" value="#getCurrency.Currency#">
							   
				   </td>	
				   <td style="padding-left:2px">/#left(Period,1)#</td>
				   </tr>
				   </table>
				   
				   </td>
				   </tr> 		  
			   </table>
			   </td>
			   </cfoutput>
			   
			   <td style="width:25px"></td>
			   
			</tr>			
		
			<!--- header 2 --->
				
			<tr style="height:35px" class="fixrow2 line">
			   <td width="40" align="center"></td>
			  
			  <cfset pGrade=PostGrade.PostGrade>
	
			   <cfoutput query="Component">
			   
				   <td align="right" style="padding-right:2px;border-right:1px solid silver;border-left:1px solid silver;padding-left:2px">
				  			   
				   	<table align="right" class="formpadding">
					    <tr><td style="padding:4px">		   		           
					   		   <cfset cp = "#replace(ComponentName,' ','','ALL')#">
							   <cfset cp = "#replace(cp,'-','','ALL')#">
					   			   
							   <cfset gr = "#replace(pGrade,'-','')#">
							   <cfset gr = "#replace(gr,' ','')#">								          
							   <img src="#session.root#/Images/copy4.gif" alt="Inherit to all levels" height="13" width="13" border="0" onclick="populateall('#gr#_1_#cp#','_#cp#')">					   
						   </td>				   
						   <td style="padding-left:4px;border:1px solid silver;padding:4px">					 
							   <img src="#session.root#/Images/delete5.gif" alt="Delete to all levels" height="13" width="13" border="0" onclick="deleteall('_1_#cp#','_#cp#')">				  				   
					       </td>
					   </tr> 		 
					   </table>
					   
				   </td>
			   
			   </cfoutput>
			   
			   
		    </tr>				
						
			<cfoutput query="PostGrade">		
				
				<cfset gr = "#replace(PostGrade,'-','')#">
				<cfset gr = "#replace(gr,' ','')#">				
							
			    <tr style="border-bottom:1px solid silver">
										
					   <td>
					   
						   <table>
						   <tr>
						   <td style="padding-right:6px">
											    					
							<img src="#SESSION.root#/Images/arrowright.gif" alt="" 
							id="#gr#Exp" border="0" class="regular" 
							align="absmiddle" style="cursor: pointer;" 
							onClick="maximize('#gr#')">
							
							<img src="#SESSION.root#/Images/arrowdown.gif" 
							id="#gr#Min" alt="" border="0" 
							align="absmiddle" class="hide" style="cursor: pointer;" 
							onClick="maximize('#gr#')">
												
							</td>
							<td style="height:32px; font-size:16px" class="labelmedium"><a href="javascript:maximize('#gr#')">#PostGrade#</a></td>
							
							</tr>
							</table>
						
						</td>
						
						 <cfloop query="Component">
			   
					     <td align="right" style="padding-right:2px;border-right:1px solid silver;border-left:1px solid silver;padding-left:2px"></td>
					   
					     </cfloop>
						
					
				</tr>
																				
				<cfset grade = Postgrade>
				
				<!--- show all the steps --->		
													
				<cfloop index="st" from="1" to="#PostGradeSteps#" step="1">
							   
					<cfset stl = "border-bottom:1px solid silver;height:20px">				
				
					<tr name="#gr#" id="#gr#" class="hide" style="#stl#">
					
					<td style="min-width:80px;padding-left:5px;padding-right:5px" class="labelit" align="center"><cfif st lt 10>0</cfif>#st#</td>
					
						<!--- August 29th moved the query to make the screen load a factor 4 faster --->
					
					    <cfquery name="AmountList"
						datasource="AppsPayroll" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT *
							FROM   SalaryScaleLine
							WHERE  ScaleNo       = '#Scale.ScaleNo#' 
							AND    ServiceLevel  = '#grade#'
							AND    ServiceStep   = '<cfif st lt 10>0</cfif>#st#'	
							AND    Operational = '1'									
						</cfquery>		
											
						<cfset comp = StructNew()>
						
						<cfloop query="AmountList">
																
							<cfset name = replace(componentname," ","","ALL")>
							<cfset name = replace(name,"-","","ALL")>
							<cfset name = replace(name,",","","ALL")>
							<cfset comp["#name#"] = amount>
										
						</cfloop>
										
					<cfloop query="Component">
																				
						<cfset name = replace(componentname," ","","ALL")>
						<cfset name = replace(name,"-","","ALL")>
						<cfset name = replace(name,",","","ALL")>												
						<cfparam name="comp.#name#" default="0">
															
						<cfset amt = evaluate("comp.#name#")>
						
						<cfset cp = "#replace(ComponentName,' ','','ALL')#">
						<cfset cp = "#replace(cp,'-','','ALL')#">
						
						<cfif RateStep eq "0" and st gt "1">
						
								<td align="right" style="background-color:e1e1e1;padding-right:2px;border-left:1px solid silver;padding-left:2px">
								<!--- hide --->		
								<!---				
								<input type="hidden" name="#gr#_#st#_#cp#_old" value="#amt#">							
								--->
								</td>
							
						<cfelse>		
																				
								<cfif RateComponentName eq ""> 			
								
								<td align="right" style="padding-right:4px;border-left:1px solid silver;;border-right:1px solid silver;">
									
									<cfif schedule.paymentRounding gte "2">
								
										<cfset amt = "#numberformat(amt,',.__')#">
									
									<cfelse>
									
										<cfset amt = "#numberformat(amt,',')#">
									
									</cfif>
																														
									<cfinput type="Text"
								       name="#gr#_#st#_#cp#"							   
								       message="Please enter a valid amount"
								       validate="float"
									   value="#amt#"
								       required="No"
								       visible="Yes"
								       enabled="Yes"							   							       
									   maxlength="20"
									   style="border:0px solid silver;text-align:right;width:97%;font-size:12.5px!important;"
								       class="amount2 enterastab regularh"/>
									   
									   <input type="hidden"  name="#gr#_#st#_#cp#_old" value="#amt#">
								   
								 </td>  
								   
								 <cfelse>
								 
									 <td align="right" style="font-size:13px;background-color:ffffcf;padding-right:2px;border-left:1px solid silver;;border-right:1px solid silver;">								
									 	 #numberformat(amt,'.__')#							 
									 </td>							 
								 
								 </cfif>  
													  
						</cfif>	  
			
						</cfloop>
					</tr>
					
				    <cfif init eq "false">
						<cfset init="true">
					</cfif>		
					
					</cfloop>
					
												
			</cfoutput>
						
			</table>
		
		</cf_divscroll>
				
		</td>
		
		</tr>
		
    </cfif>		
	
</table>