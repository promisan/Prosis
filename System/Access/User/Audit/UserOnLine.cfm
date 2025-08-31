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
<cfparam name="url.mode" default="">
<cfparam name="url.date" default="#dateformat(now(),CLIENT.DateFormatShow)#">

<CF_DateConvert Value="#url.date#">

<cfif url.mode eq "prior">
 	 <cfset dt = dateValue-1>
	 <cfset format = "png">
	 <cfset tip ="off">
<cfelseif url.mode eq "Next">
	 <cfset dt = dateValue+1>
	 <cfset format = "png">
	 <cfset tip ="off">
<cfelse>
	 <cfset dt = datevalue>
	 <cfset format = "flash"> 
	 <cfset tip ="mouseover">
</cfif>

<cfparam name="url.month" default="#month(dt)#">
<cfparam name="url.year" default="#year(dt)#">

<cfset d = daysinmonth("#url.year#/#url.month#/01")>

<!--- prepare based table --->
<cfquery name="Times" 
		datasource="appsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#"> 
		SELECT    Account, 
		          HostName, 
				  HostSessionNo, 
				  MIN(ActionTimestamp) AS SessionStart, 
				  MAX(ActionTimestamp) AS SessionEnd, 
				  CAST(CONVERT(varchar, 
                      MIN(ActionTimestamp), 102) AS datetime) AS SessionDate,
				  DAY(MIN(ActionTimestamp)) as SessionDay,
				  DATEDIFF(mi, MIN(ActionTimestamp), MAX(ActionTimestamp)) AS Minutes
		FROM      UserStatusLog		  
		WHERE     (Account = '#url.id#')
		AND       Created >= '#url.year#/#url.month#/01'
		AND       Created <= '#url.year#/#url.month#/#d#' 
		GROUP BY Account, HostName, HostSessionNo
		HAVING      (DATEDIFF(mi, MIN(ActionTimestamp), MAX(ActionTimestamp)) > 0)
		ORDER BY SessionStart DESC		
</cfquery>

<cfif len(url.month) eq "1">
 <cfset mt = "0#url.month#">
<cfelse>
 <cfset mt = "#url.month#">
</cfif>


<table width="98%">

	<cfoutput>
	
	<tr class="line labelmedium2">
	
		<td style="font-size:22px;height:35px;padding-left:5px">System interaction</td>
		<td align="right" colspan="3" height="20" style="padding-left:4px;padding-right:5px">			
			<a title="prior month" href="javascript:month('prior','01/#mt#/#url.year#')"><<</a>
			#monthasstring(url.month)# #url.year#
			<cfif dt+1 lt now()>
				<a title="next month" href="javascript:month('next','#d#/#mt#/#url.year#')">>></a></a>
			</cfif>
		</td>
		
	</tr>
	
	</cfoutput>
	
	<tr class="line">
	
	<td align="center" valign="top" style="padding:7px">
	
		<table border="0">
			<tr class="labelmedium2"><td align="center" style="max-height:30px;border-bottom:1px solid silver">Usage</td></tr>
			<tr><td style="height:100%">	
	
			<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
			
				<cfchart style = "#chartStyleFile#" format="png"
		           chartheight="300"
		           chartwidth="320"
		           scalefrom="0"		          
				   font="Calibri"				   
				   fontsize="11"
				   show3d="no"
		           seriesplacement="default"
		           labelformat="number"
		           xaxistitle="Day of the month"
		           yaxistitle="Hours"
		           tipstyle="mouseOver"
				   
		           showmarkers="No">
		   		   
			   <cfchartseries type="curve" serieslabel="Dates" seriescolor="##c0c0c0">
		   
			   <cfloop index="itm" from="1" to="#d#" step="1">
		  
				  <cfquery name="total" dbtype="query">
					  SELECT sum(Minutes) as Minutes
					  FROM   Times
					  WHERE  SessionDay = #itm#  
				  </cfquery>	
				  
				  <cfif total.minutes eq "">
				  	 <cfset tot = "0">
					 <cfchartdata item="#itm#" value="0"/>
				  <cfelse>
				 	 <cfset tot = "#total.minutes/60#">
					 <cfif tot gt 23>
					 	<cfset tot = 23>
					 </cfif>
					 <cfchartdata item="#itm#" value="#tot#"/>	
				  </cfif>     
				  
		  	    </cfloop>
		   
	    	   </cfchartseries>
				   		   
		  </cfchart>
	  
	  </td>
	  
	  </tr>
	  </table>
	  
</td>
	
		
 <cfquery name="Total" 
	datasource="appsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
	    SELECT  COUNT(*) AS Visits
		FROM    UserStatusLog
		WHERE   (Account = '#url.id#')
			AND       Created >= '#url.year#/#url.month#/01'
			AND       Created <= '#url.year#/#url.month#/#d#' 
		AND (TemplateGroup IS NOT NULL) 
		AND (TemplateGroup <> '[root]')	
</cfquery>	
   
<cfquery name="Visits" 
	datasource="appsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
	    SELECT   SystemModule, COUNT(*) AS Counted
		FROM     UserStatusLog A, Ref_ModuleControl M
		WHERE    A.SystemFunctionId = M.SystemFunctionId
		AND      Account = '#url.id#'
		AND      A.Created >= '#url.year#/#url.month#/01'
		AND      A.Created <= '#url.year#/#url.month#/#d#' 		
		GROUP BY SystemModule
</cfquery>	

<cfparam name="init" default="0">
		
<cfif visits.recordcount gte "1">
			    
		<td align="center" valign="top">	
		
		<table border="0">
		<tr class="labelmedium2"><td align="center" style="height:30px;border-bottom:1px solid silver">Relative usage between modules</td></tr>
		<tr><td>	
		   				
			<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
			
			<cfchart style="#chartStyleFile#" 
				     format="png"
			         chartheight="350"
			         chartwidth="460"
			         scalefrom="0"	
					 showborder="0"			
					 fontsize="12"  
					 title="Relative usage application areas"
			         scaleto="10"
			         seriesplacement="default"
			         labelformat="percent"
					 show3d="no"   				       
					 showlegend="Yes"
			         tipstyle="mouseOver"
			         showmarkers="No">	
		  
				   <cfchartseries type="pie" colorlist="##5DB7E8,##E8875D,##E8BC5D,##E85DA2,##5DE8D8,##CCCA6A,##339AFA,##66AC6A,##999A9A,##FFFA9A,##996AFA">
					 
					 <cfloop query="visits">
					 
					 	 <cfif total.visits gte "1" and counted gte "1">	
					 		<cfset tot = "#counted/total.visits#">
						 <cfelse>
						    <cfset tot = 0>  
						 </cfif>
		   		 					 	 
						 <cfchartdata item="#SystemModule#" value="#tot#"/>	
					 
					 </cfloop>
							 
				   </cfchartseries>	 
						  
			</cfchart>  
			
			</td>
			</tr>
		</table>	
			
		</td>
		
								
		<cfquery name="Visits" 
			datasource="appsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#"> 
			    SELECT   Mission, COUNT(*) AS Counted
				FROM     UserStatusLog A, Ref_ModuleControl M
				WHERE    A.SystemFunctionId = M.SystemFunctionId
				AND      Account = '#url.id#'
				AND      A.Created >= '#url.year#/#url.month#/01'
				AND      A.Created <= '#url.year#/#url.month#/#d#' 
				AND      Mission IN (SELECT Mission FROM Organization.dbo.Ref_Mission)		
				GROUP BY Mission
		</cfquery>	
		
		<td align="center" valign="top">		
		
			<table border="0">
			<tr class="labelmedium2"><td align="center" style="height:30px;border-bottom:1px solid silver">Relative usage between entities/missions</td></tr>
			<tr><td>	
		   				
			<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
			
			<cfchart style="#chartStyleFile#" 
				     format="png"
			         chartheight="350"
			         chartwidth="460"
			         scalefrom="0"	
					 showborder="0"			  
					 title="Relative usage application areas"
			         scaleto="10"
					 fontsize="12"					 
			         seriesplacement="default"
			         labelformat="percent"
					 show3d="no"   				       
					 showlegend="Yes"
			         tipstyle="mouseOver"
			         showmarkers="No">	
		  
				   <cfchartseries type="pie" colorlist="##b0b0b0,##c0c0c0,##a0a0a0,##6688aa,##002350,##CCCA6A,##339AFA,##66AC6A,##999A9A,##FFFA9A,##996AFA">
					 
					 <cfloop query="visits">
		   		 
					 	<cfset tot = 0>
						<cfif total.visits neq 0 and total.visits neq "">
							<cfset tot = "#counted/total.visits#">
						</cfif>

						 <cfchartdata item="#Mission#" value="#tot#"/>	
					 
					 </cfloop>
							 
				   </cfchartseries>	 
						  
			</cfchart>  
			
			</td>
			</tr>
			</table>
			
		</td>
	
	</tr>
		
</cfif>

</table>

<script>
	Prosis.busy('no')
</script>

