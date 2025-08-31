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
<cfparam name="dte" default="#now()#">

<cfparam name="url.startyear"  default="#year(dte)#">
<cfparam name="url.startmonth" default="#month(dte)#">
<cfparam name="url.day"        default="#day(dte)#">

<cfset dateob=CreateDate(URL.startyear,URL.startmonth,URL.Day)>

<cfset st = DateAdd("d", "-#DayOfWeek(dateob) - 1#", dateob)>
<cfset ed = DateAdd("d", "6", st)>

<cfquery name  = "getlist" 
    datasource= "AppsEmployee" 
    username  = "#SESSION.login#" 
	password  = "#SESSION.dbpw#">      				 
		SELECT   *
		FROM     Ref_WorkAction AS R
		WHERE    Operational = 1
		ORDER BY R.ListingOrder
</cfquery>

<!--- we get the source data --->

<cfquery name  = "getdata" 
    datasource= "AppsEmployee" 
    username  = "#SESSION.login#" 
	password  = "#SESSION.dbpw#">      
				 
	SELECT   W.ActionClass, 
	       	 Year(W.CalendarDate) as CalendarYear, 			
			 Month(W.CalendarDate) as CalendarMonth, 	
			 		 
			 (SELECT ActionDescription
			  FROM   Employee.dbo.Ref_WorkAction
			  WHERE  ActionClass = W.ActionClass ) as ActionDescription,		
	         
			 (SELECT ViewColor
			  FROM   Employee.dbo.Ref_WorkAction
			  WHERE  ActionClass = W.ActionClass ) as ViewColor,	
			  
			 (SELECT ActionColor 
			  FROM   Employee.dbo.Ref_WorkActivity 
			  WHERE  ActionCode = A.ActivityId ) as ActionColor,	
			 		 
			 W.ActionCode,
			 A.ActivityDescription,
			 A.ActivityDescriptionShort,
			 A.ActivityDateStart,
			 A.ProgramCode,
			 P.ProgramName,
			 P.Mission,			 
			 ISNULL(SUM(CONVERT(Float,W.HourSlotMinutes) / 60), 0) AS Total
			 
	FROM     Program.dbo.Program P INNER JOIN
             Program.dbo.ProgramActivity A ON P.ProgramCode = A.ProgramCode RIGHT OUTER JOIN
             PersonWorkDetail W ON A.ActivityId = W.ActionCode 			  		 
	
	WHERE    W.PersonNo = '#url.id#' 
	
	AND      Year(W.CalendarDate) = '#url.startyear#'
	
	GROUP BY Year(W.CalendarDate),Month(W.CalendarDate), W.ActionClass, A.ActivityDateStart, A.ProgramCode, W.ActionCode, A.ActivityId,ActivityDescription,ActivityDescriptionShort,P.Mission,P.ProgramName 
	ORDER BY Year(W.CalendarDate),Month(W.CalendarDate), A.ProgramCode, A.ActivityDateStart 

</cfquery>

<cfoutput>

	<table width="95%" align="center">
		
	<tr class="line"><td colspan="2">
		
		<table cellspacing="0" cellpadding="0">
				
			<tr class="labelmedium">
			<td style="width:30;padding-left:10px">
			 
				  <cfset dd = dateAdd("yyyy",-1,st)>	  				  
				  <img src="#Client.VirtualDir#/Images/Back.png" height="32" width="32" style="cursor:pointer" alt="" border="0" onclick="gotoyear('#URL.ID#','#day(dd)#','#Month(dd)#','#Year(dd)#','1')">	
					  
			</td>
			
			<td style="padding-left:8px;padding-right:8px;width:100%" align="center"><font size="6" color="gray"><b>#url.startYear#</font></b></td>
			<td align="right" style="width:30;padding-right:10px;">
			
			<cfif ed gt now()>
			
			<cfelse>
			
				<cfset dd = dateAdd("yyyy",+1,ed)>	  
			    <img src="#Client.VirtualDir#/Images/Next.png" height="32" width="32" style="cursor:pointer" alt="" border="0" onclick="gotoyear('#URL.ID#','#day(dd)#','#Month(dd)#','#Year(dd)#','1')">	
				
			</cfif>	
					
			</td>
			</tr>
				
		</table>
	
	</td>
	</tr>
								
	<tr>
	
	  <td align="center">
	
		<table width="100%">
		
		<tr><td width="100%">						
		
				<cfquery name="getClass"         
		         dbtype="query">
					 SELECT ActionDescription,ActionClass, ViewColor, SUM(Total) as Total
					 FROM   getData
					 GROUP BY ActionDescription, ActionClass, ViewColor
					 ORDER BY ActionDescription
				</cfquery>		
				
				<cftry>
			
				<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
				
					<cfchart style = "#chartStyleFile#" format="png"
			           chartheight="240"
			           chartwidth="700"
			           scalefrom="0"
			           gridlines="6"
			           showxgridlines="yes"
			           seriesplacement="default"
			           font="Calibri"
			           fontsize="17"          
			           labelformat="number"
			           show3d="yes"
			           tipstyle="mouseOver"
			           tipbgcolor="F4F4F4"
			           showmarkers="yes"
			           markersize="30"			          
			           backgroundcolor="ffffff">
				   
				    <cfset color = valueList(getClass.viewColor)>  
						 
					<cfchartseries
			             type="pie"
			             query="getClass"
			             itemcolumn="ActionDescription"
			             valuecolumn="Total"
			             seriescolor="0000CC"
			             datalabelstyle="pattern"				            
			             markerstyle="mcross"
			             colorlist="#color#">
					 
				 </cfchartseries>
							 
			  </cfchart>
			  
			  <cfcatch>
			  Unsupported color
			  </cfcatch>
			  
			  </cftry>
		
		</td></tr>
		
		</table>
	
	</td>
	
	<td style="padding:20px">
	
		<!---
		<table width="100%" height="100%" style="border:1px solid silver">
		<tr><td height="200" id="summarydetail" class="labelit" align="center"><b>[TBD for Umoja]</td></tr>
		</table>
		--->
		
	</td>
	</tr>
	
	<tr><td style="border:1px solid gray" colspan="2">
	
		<table width="100%" class="navigation_table">
		
		<tr style="background-color:d1d1d1" class="labelmedium line">
		<td width="30%" style="padding:4px;padding-left:6px;width:100%"><cf_tl id="Time class"></td>
		
			<cfloop index="per" from="1" to="12">			
			<td width="5%" align="center" style="min-width:50px;border-right:1px solid silver">#left(MonthAsString(per),3)#</td>		
			</cfloop>
		
			<td width="7%" align="right" style="min-width:70px;padding:4px;padding-left:4px">Hrs</td>
			<td width="8%" align="right" style="min-width:70px;padding:4px;padding-left:4px">Percent</td>
		
		</tr>
		
		</cfoutput>
		
		<cfquery name="getOverall"         
		    dbtype="query">
			 SELECT SUM(Total) as Total
			 FROM  getData			
		</cfquery>		
		
		<!--- ------------ --->
		<!--- content rows --->
		<!--- ------------ --->	
		
		<cfoutput query="getList">
		
		<tr><td colspan="15" style="border-top:1px solid gray"></td></tr>
			
		<tr class="labelmedium navigation_row line">
			<td style="border-right:1px solid gray;background-color:###viewColor#4D;padding:4px;padding-left:7px">#ActionDescription#</td>
				
				<cfloop index="per" from="1" to="12">
						
				<td  align="right" style="border-right:1px solid silver;padding-right:7px;background-color:###viewColor#33">		
				
					<cfquery name="getHours"         
					         dbtype="query">
							 SELECT SUM(Total) as Total
							 FROM   getData
							 WHERE  ActionClass = '#ActionClass#'
							 AND    CalendarMonth = #per#
					</cfquery>
					
					<cfif getHours.Total eq "">-<cfelse>#getHours.Total#</cfif>
					
				</td>
				
				</cfloop>
				
				<td align="right" style="padding-right:6px;border-right:1px solid silver;background-color:###viewColor#4D;border-left:1px solid gray;">
				
				    <cfquery name="getHours"         
					         dbtype="query">
							 SELECT SUM(Total) as Total
							 FROM  getData
							 WHERE ActionClass = '#ActionClass#'					
					</cfquery>
					
					<cfif getHours.Total eq "">
					-
					<cfelse>
					#getHours.Total#
					</cfif>
				
				</td>
				
				<td align="right" style="padding-right:6px;border-right:1px solid silver;background-color:###viewColor#4D;border-left:1px solid gray;">
							
						<cfif getHours.Total neq "" and getOverall.Total neq "" and getOverall.Total neq "0">
							
						<cfset perc = (getHours.Total/getOverall.Total)*100>					
						#numberformat(perc,"__")# %					
						</cfif>
						
				</td>			
					
		  </tr>
		  
		  <!--- ---------------------- --->
		  <!--- subrow for an activity --->
		  <!--- ---------------------- --->	
						
		  <cfif ProgramLookup eq "1">
				
				<cfquery name="getActivity"         
				         dbtype="query">
						 SELECT DISTINCT ProgramCode, 
						                 ProgramName, 
										 ActionCode,
										 ActivityDescription,
										 ActionColor
						 FROM  getData
						 WHERE ActionClass = '#ActionClass#'					 					 
				</cfquery>
				
				<cfset prior = "">
				
				<cfloop query="getActivity">
				
					<cfif actioncode neq "">
					
						<!--- program header --->
						
						<cfif programcode neq prior>		
																	
							<tr class="labelit line navigation_row">							
							<td colspan="1" style="border-right:1px solid gray;height:20;padding:0px;padding-left:10px">#ProgramName#</td>													
							<cfloop index="per" from="1" to="12">
																
								<cfquery name="getHours"         
							         dbtype="query">
									 SELECT SUM(Total) as Total
									 FROM   getData
									 WHERE  ActionClass = '#getList.ActionClass#'
									 AND    ProgramCode   = '#ProgramCode#'
									 AND    CalendarMonth = #per#
								</cfquery>			
											
								<cfif getHours.Total eq "0">
									<td align="right" style="border-right:1px solid silver;padding-right:7px"></td>
								<cfelse>
								<td align="right" style="cursor:pointer;border-right:1px solid silver;padding-right:13px">#getHours.Total#</td>
								</cfif>
							
							</cfloop>
							
							<!--- total column --->
							
							<td align="right" style="border-right:1px solid silver;padding-right:13px">
						
							    <cfquery name="getHours"         
							         dbtype="query">
									 SELECT SUM(Total) as Total
									 FROM  getData
									 WHERE ActionClass  = '#getList.ActionClass#'
									  AND    ProgramCode   = '#ProgramCode#'		
								</cfquery>
								
								<cfif getHours.Total eq "">-<cfelse>#getHours.Total#</cfif>
						
							</td>			
							
							<td align="right" style="border-right:1px solid silver;padding-right:13px">
							
							<cfif getHours.Total neq "" and getOverall.Total neq "">						
							<cfset perc = (getHours.Total/getOverall.Total)*100>						
							#numberformat(perc,"__")# %						
							</cfif>
							
							</td>					
							
						</tr>		
																
						</cfif>
						
						<cfset prior = ProgramCode>
									
					    <!--- ---------------- --->
					    <!--- actioncode lines --->
						<!--- ---------------- --->
						
						<tr class="labelit line navigation_row">	
							<td style="background-color:###actionColor#4D;border-right:1px solid gray;padding-left:25px">#ActivityDescription#</td>
							
							<cfloop index="per" from="1" to="12">
																
								<cfquery name="getHours"         
							         dbtype="query">
									 SELECT SUM(Total) as Total
									 FROM   getData
									 WHERE  ActionClass = '#getList.ActionClass#'
									 AND    ActionCode  = '#ActionCode#'
									 AND    CalendarMonth = #per#
								</cfquery>			
											
								<cfif getHours.Total eq "0">
									<td align="right" style="border-right:1px solid silver;padding-right:7px"></td>
								<cfelse>
								    <td align="right" style="background-color:###actionColor#33;cursor:pointer;border-right:1px solid silver;padding-right:13px">#getHours.Total#</td>
								</cfif>
							
							</cfloop>
							
							<!--- total column --->
							
							<td align="right" style="background-color:###actionColor#4D;border-right:1px solid silver;padding-right:13px">
						
							    <cfquery name="getHours"         
							         dbtype="query">
									 SELECT SUM(Total) as Total
									 FROM  getData
									 WHERE ActionClass  = '#getList.ActionClass#'
									 AND   ActionCode  = '#ActionCode#'				
								</cfquery>
								
								<cfif getHours.Total eq "">-<cfelse>#getHours.Total#</cfif>
						
							</td>			
							
							<td align="right" style="background-color:###actionColor#4D;border-right:1px solid silver;padding-right:13px">						
							<cfif getHours.Total neq "" and getOverall.Total neq "">						
							<cfset perc = (getHours.Total/getOverall.Total)*100>						
							#numberformat(perc,"__")# %						
							</cfif>						
							</td>					
							
						</tr>
					
					</cfif>
				
				</cfloop>
				
			</cfif>
								
		</cfoutput>
		
		<cfoutput>
			
		<!--- ------------------ --->
		<!--- ----total rows---- --->
		<!--- ------------------ --->	
			
		<tr class="line labelmedium" style="background-color:e4e4e4;border-top:1px solid gray;border-right:1px solid silver">	
		
			<td style="padding:4px"><cf_tl id="Total"></td>
			
			<cfloop index="per" from="1" to="12">
			
				<cfquery name="getHours"         
				         dbtype="query">
						 SELECT SUM(Total) as Total
						 FROM   getData
						 WHERE  CalendarMonth = #per#
				</cfquery>					
				
				<td align="right" style="padding:4px;border-right:1px solid silver">
				<cfif getHours.Total eq "">-<cfelse>#getHours.Total#</cfif>				
				</td>
			
			</cfloop>
							
			<td align="right" style="padding-right:9px;border-right:1px solid silver">
				<cfif getOverall.Total eq "">-<cfelse>#getOverall.Total#</cfif>			
			</td>
					
			<td align="right" style="padding-right:9px;border-right:1px solid silver">
			
				<cfif getHours.Total neq "" and getOverall.Total neq "">							
					<cfset perc = (getOverall.Total/getOverall.Total)*100>						
					#numberformat(perc,"__")# %							
				</cfif>
			
			</td>
				
		</tr>	
		
		</table>	
	
	</td></tr>	
	</table>

</cfoutput>

<cfset ajaxonload("doHighlight")>


