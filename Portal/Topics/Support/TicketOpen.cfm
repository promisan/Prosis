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

<cfquery name="get" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT   *
		  FROM     Ref_ModuleControl
		  WHERE    SystemModule = 'Portal'
		  AND      FunctionClass = 'Portal'
		  AND      FunctionName = 'Pending Support Tickets'  
	</cfquery> 

<cfif get.recordcount gte "1">
	
	<cf_screentop html="No" jquery="yes">
	
	<table width="96%" align="right" class="formpadding">
	
	<tr><td  class="labellarge" style="font-weight:200;font-size:35px;padding-right:10px">Support ticket center &nbsp;&nbsp; <u></b><!--- <a href="TicketListing.cfm?systemfunctionid=<cfoutput>#get.systemfunctionid#</cfoutput>"><font size="3"><cf_tl id="Inquiry"></a> ---> </font></td></tr>
	<tr><td></td></tr>
	
	<tr><td style="padding-right:10px">
	
	<!--- show the content of the ticket --->
		
		<cfquery name="getBase" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  SELECT   *
			  FROM     UserNames
			  WHERE    Account = '#session.acc#'  
		</cfquery> 
		
		<cfinvoke component = "Service.Connection.Connection"  
		   method           = "setconnection"    
		   object           = "UserSupport" 
		   ScopeId          = "#get.systemfunctionid#"
		   ControllerNo     = "998"
		   ObjectContent    = "#getBase#"
		   ObjectIdfield    = "account"
		   delay            = "15">	     
		
		<cf_pane id="PendingTicketWidget" search="No">
						
			<cf_paneItem id="#session.acc#" 
			        systemfunctionid = "#get.systemfunctionid#"  
					source           = "#session.root#/Portal/Topics/Support/TicketView.cfm"
					width            = "95%"
					height           = "auto"		
					Label            = "Pending Support Tickets"
					ShowPrint		 = "1"			
					PrintCallback 	 = "$('##ticketViewWidgetContainer').attr('style','width:100%;'); $('##ticketViewWidgetContainer').parent('div').attr('style','width:100%;');">		
					
					<!--- AutoRefreshSpan	 = "60000" --->
			
		</cf_pane>
	
	</td></tr>
			
	<cfoutput>		
	<tr><td height="8"></td></tr>
	<tr>
	 <td class="labellarge">
	 <table width="94%">	 
	 <tr>
	 <td class="labellarge" style="font-weight:200">
	 Processed and closed tickets for #year(now())#</td></tr>
	 <tr><td class="line"></td></tr>
	
	</cfoutput>
	
	<tr><td>
	
		<cfquery name="getMonth" 
		datasource="AppsControl" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT	 month(ObservationDate) as YearMonth, count(*) as Counted				
			FROM	 Observation O 
					 INNER JOIN Organization.dbo.Ref_EntityStatus R 
						ON O.ActionStatus = R.EntityStatus
			WHERE	 R.EntityCode = 'SysTicket'
			AND		 O.ObservationClass = 'Inquiry'
			AND		 O.ActionStatus = '3'
			AND		 O.Requester = '#session.acc#' 
			AND      Year(O.ObservationDate) = '#year(now())#'
			GROUP BY month(ObservationDate)
			ORDER BY month(ObservationDate)
		</cfquery>
		
		<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
			
			<cfchart style = "#chartStyleFile#" format="png" 
			         chartheight="200" 
					 chartwidth="#client.width-300#" 
					 scalefrom="0"
					 scaleto="30" 
					 showxgridlines="yes" 
					 showygridlines="yes"
					 gridlines="6" 
					 showborder="no" 
					 fontsize="13" 
					 fontbold="no" 
					 font="arial"
					 fontitalic="no" 
					 xaxistitle="" 				 
					 yaxistitle="Tickets" 
					 rotated="no" 
					 sortxaxis="no" 					 
					 tipbgcolor="##FFFFCC" 
					 showmarkers="yes" 
					 markersize="30" 
					 backgroundcolor="##ffffff">					 	 
					
						<cfchartseries
			             type="bar"			            
			             seriescolor="##00CCC6"
			             datalabelstyle="value"		            
			             markerstyle="diamond"
			             colorlist="##3399FF,##66CC66,##999999,##9966FF,##FF7777,##FFFFFF">
						 
						 <cfloop index="mt" from="1" to="12" step="1">
						 
						 <cfif mt lte month(now())>
						 
							 <cfquery name="get" dbtype="query">
									SELECT	*
									FROM    getMonth
									WHERE   YearMonth = #mt#
							</cfquery>			
							
							<cfif get.Counted neq ''>
								<cfset val = get.Counted>
							<cfelse>
								<cfset val = 0>
							</cfif>	 				 
						 
						   <cfchartdata item="#monthasstring(mt)#" value="#val#"></cfchartdata>
						
						 </cfif>
						
						 </cfloop>
						 
						</cfchartseries>
														
			</cfchart>
			
			</td></tr></table>
	
	</td></tr>
	
	</table>

</cfif>