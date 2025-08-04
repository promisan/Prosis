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

<!--- limited gantchart --->

<cfquery name="check" 
	  datasource="appsWorkOrder">
	  SELECT *
	  FROM   WorkOrderLine 
	  WHERE  WorkOrderId =  '#attributes.workorderid#'	
	  AND    DateExpiration is NULL
</cfquery>

<cfquery name="Dates" 
	  datasource="appsWorkOrder">
	  SELECT MIN(DateEffective) as Start,
	         MAX(DateExpiration) as EndDate
	  FROM   WorkOrderLine
	  WHERE  WorkOrderId =  '#attributes.workorderid#'	
</cfquery>
   
<!--- get the data value --->

<cfif Dates.Start eq "">
	<cfset STR = NOW()-30>
<cfelse>
	<CF_DateConvert Value="#dateformat(Dates.Start,client.dateformatshow)#">
	<cfset STR = dateValue>
</cfif>

<cfif Dates.EndDate eq ""> 

	<CF_DateConvert Value="#dateformat(now(),client.dateformatshow)#">
	<cfset END = STR>

<cfelse>

	<CF_DateConvert Value="#dateformat(Dates.EndDate,client.dateformatshow)#">
	<cfset END = dateValue>
	<cfif END lt STR>
		<cfset END = STR>
	</cfif> 

</cfif>

<cfset prior = "">
<cfset i = 0>

<!--- populate an array --->

<cfloop condition="#STR# lte #END#">
    
	<cfset str = dateadd("d","1",str)>
	<cfset wk = DatePart("ww", STR)>
	<cfset mt = DatePart("m", STR)>
	<cfset yr = DatePart("yyyy", STR)>
	
	<cfif wk neq prior>
	  <cfset i = i+1>	
	  <cfset list[i][1] = "#wk#">
	  <cfset list[i][2] = "#mt#">
	  <cfset list[i][3] = "#yr#">
	  <cfset prior = wk>
	</cfif>	

</cfloop>

<cfquery name="Line" 
	  datasource="appsWorkOrder">
	  
	  SELECT    S.Reference, 
	            S.Description, 
				WL.WorkOrderId, 
				WL.WorkOrderLine, 
				WL.WorkOrderLineId,
				WL.OrgUnitImplementer, 
				WL.OrgUnit, 
				WL.ServiceDomainClass, 
                R.Description AS ActivityClass, 
				R.PointerSale AS forSale, 
				R.PointerStock AS forStock,
				WL.DateEffective, 
				WL.DateExpiration,
				WL.ActionStatus,
				WL.WorkOrderLineMemo
	  FROM      WorkOrderLine WL INNER JOIN
                WorkOrderService S ON WL.ServiceDomain = S.ServiceDomain AND WL.Reference = S.Reference INNER JOIN
                Ref_ServiceItemDomainClass R ON WL.ServiceDomain = R.ServiceDomain AND WL.ServiceDomainClass = R.Code
	  
	  WHERE  WL.WorkOrderId =  '#attributes.workorderid#'	
	  AND    WL.Operational = 1
</cfquery>

<cfif line.recordcount gte "1">

<cfset wd  = 100/i>

<table width="100%" height="<cfoutput>#line.recordcount*25+38#</cfoutput>"
	 class="navigation_table">

		<cfoutput>
		
		<tr>
		
		<td width="15%" valign="top" style="padding-left:1px;height:80;padding-right:1px">
		
			<table width="98%" border="0" height="100%" cellspacing="0" cellpadding="0" style="border-top:1px dotted white;border-bottom:1px dotted silver;">
				
				<tr>
				    <td width="15%" style="border-bottom:0px solid silver;height:42;padding-left:8px;padding-right:8px" valign="top">						
						<cf_space spaces="63">
					</td>						
				</tr>		
								
				<cfloop query="Line">
							
					<tr>
					
						<td height="100%" style="height:26;padding-left:12px;border-bottom:1px solid silver">
																		
							 <table cellspacing="0" cellpadding="0">
								 <tr>
								  <td style="padding-top:1px">
								    <cf_img icon="select" navigation="Yes" onclick="workorderlineopen('#workorderlineid#','#url.systemfunctionid#','embed')">
								  </td>								  
								  <td style="padding-top:3px;padding-left:8px;min-width:150px" class="labelit fixlength">
								      <a href="javascript:workorderlineopen('#workorderlineid#','#url.systemfunctionid#','embed')">
								      #ServiceDomainClass# #Description#</font> <cfif forsale eq "1"><font color="gray">(<cf_tl id="sale">)</font></cfif><cfif forstock eq "1">(deduct)</cfif></font>
									  </a>								  									  
								  </td>								  
								 </tr>
							 </table>
						
						</td>
						
					</tr>
				
				</cfloop>
				
				<tr><td height="22"></td></tr>
				
			</table>
		
		</td>
		
		<td width="85%" valign="top" style="padding-top:1px;padding-left:0px;padding-right:2px">
		
				<cf_divscroll overflowx="Auto">
									
				<table width="99%">
				
				<tr>
				   
					<cfset i = 0>
					<cfset prior = "">
					
					<td class="labelit" align="center" style="width:#wd#%;height:21">
						
					<table width="100%">
					<tr>
					
					<!--- month --->
					
					<cfloop array="#list#" index="week">	
				    
						<cfset i = i+1>		
										
						<cfif prior neq monthasstring(week[2])>
						
							<cfset cnt = 0>
							<cfloop array="#list#" index="check">									
								<cfif check[2] eq week[2] and check[3] eq week[3]>
									<cfset cnt = cnt + 1>
								</cfif>
							</cfloop>							
							
							<td class="labelmedium2 line" align="center" colspan="#cnt#" style="height:23px;border-left:1px solid silver;border-right:1px solid silver;padding-right:5px">								
															
							<cfset m = monthasstring(week[2])>
							<cfset y = week[3]>
							<cfset m = "#m#">								
							<cf_tl id="#m#">								
							
							<cfset prior = monthasstring(week[2])>
						
							</td>								
						
						</cfif>																
						
					</cfloop>
					
					</tr>
					
					<!--- week --->
					
					<tr style="height:15px">
					<cfloop array="#list#" index="week">					    												
						<td style="font-size:13px" align="center" class="labelmedium line">#week[1]# <cf_space spaces="7"></td>					
					</cfloop>					
					</tr>					
						
				<cfloop query="Line">
					
					<tr>
																
						<cfset i = 0>
						<!--- get the data value --->
						<CF_DateConvert Value="#dateformat(DateEffective,client.dateformatshow)#">
						<cfset LSTR = dateValue>
						
						<cfif DateExpiration eq "">
							<CF_DateConvert Value="#dateformat(End,client.dateformatshow)#">
						<cfelse>
						    <CF_DateConvert Value="#dateformat(DateExpiration,client.dateformatshow)#">
						</cfif>
						<cfset LEND = dateValue>
						
						<cfset syr = DatePart("yyyy", lstr)>
						<cfset swk = DatePart("ww", lstr)>
						
						<cfset eyr = DatePart("yyyy", lend)>
						<cfset ewk = DatePart("ww", lend)>
																						
						<cfloop array="#list#" index="week">	
												
							<cfset color = "white">
															
							<cfif syr lte week[3] and eyr gte week[3]>
																				
							    <cfif (syr eq week[3] and swk lte week[1]) or syr lt week[3]>
																												
									<cfif (eyr eq week[3] and ewk gte week[1]) or eyr gt week[3]>		
																				
										<cfif actionStatus eq "1">																		
										<cfset color="green">
										<cfelse>														
										<cfset color="yellow">								
										</cfif>										
																	    
									</cfif>			
								
								</cfif>			
											
							</cfif>
							
						    <cfset i = i+1>		
							<td bgcolor="#color#" align="center" style="height:21;width:#wd#%;border-bottom:1px solid silver;border-top:1px solid silver"></td>		
							
						</cfloop>
						
					</tr>
				
				</cfloop>
				
				
					</table>	
						
					</td>	
				</tr>
				
				</table>
						
				</cf_divscroll>			
				
			</td>
			</tr>
		
		</cfoutput>
 
</table>

</cfif>

<cfset AjaxOnLoad("doHighlight")>	