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
<cfparam name="url.mission" default="Kuntz">

<cfoutput>
<script>
	function doConfirm(d) {
		var r=confirm("Do you wish to confirm the deliveries for "+d+"?");
		if (r==true) {
			ptoken.navigate('WorkOrderDelivery/setDeliveries.cfm?mission=#url.mission#&date='+d,'result');				
		}		
	}
	
</script>

</cfoutput>
<!--- ---------------------------- --->
<!--- designed for KUNTZ only ---- --->
<!--- ---------------------------- --->

<table width="95%" height="100%" cellspacing="0" cellpadding="0" align="center">

<tr valign="top">

	<!--- Deliveries by Branch --->
	<td align="center">
	
	<cfquery name="Deliveries"
		datasource="appsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		SELECT   PL.PersonNo,
				 A.DateTimePlanning, 	
		         W.WorkOrderId,
				 C.PostalCode,
		         C.CustomerName,	         
		         PL.LastName, 
				 PL.FirstName,
				 PL.PlanOrderCode,
				 PL.Schedule as DagDeel, 
				 1 as Planned,
				 (CASE WHEN DateTimeActual is NULL THEN 0 ELSE 1 END) as Actual
	    FROM     WorkOrder AS W INNER JOIN
                 WorkOrderLine AS WL ON W.WorkOrderId = WL.WorkOrderId INNER JOIN
                 WorkOrderLineAction AS A ON WL.WorkOrderId = A.WorkOrderId AND WL.WorkOrderLine = A.WorkOrderLine INNER JOIN
				 
				 
				   <!--- planned for today --->
			 				 
				 	(
				 
				    SELECT  W.WorkPlanId, 
					        D.PlanOrder, 
							D.PlanOrderCode, 
							R.Description as Schedule,		
							P.PersonNo,					
							P.LastName, 							
							P.FirstName,
							D.DateTimePlanning, 
							D.WorkActionId
							
							<!---
							(SELECT TOP 1 TopicValue
							 FROM   WorkPlanTopic
							 WHERE  WorkPlanId = W.WorkPlanId
							 AND    Topic      = 'f004'
							 AND    Operational = 1) as Mobile
							 --->
							
				    FROM    WorkPlan AS W INNER JOIN
                            WorkPlanDetail AS D ON W.WorkPlanId = D.WorkPlanId INNER JOIN
                            Employee.dbo.Person AS P ON W.PersonNo = P.PersonNo INNER JOIN
							Ref_PlanOrder AS R ON R.Code = D.PlanOrderCode
					WHERE   W.Mission = '#url.mission#' 							
					AND     D.WorkActionId IS NOT NULL 
					
					) PL ON A.WorkActionId = PL.WorkActionId AND A.DateTimePlanning = PL.DateTimePlanning INNER JOIN
				 
			 
							 
				 Customer as C ON W.CustomerId = C.CustomerId 
	   WHERE     A.ActionClass = 'Delivery' 	  
	   AND       W.Mission = '#url.mission#'	
	   AND       W.ActionStatus != '9'
	   AND       WL.Operational = 1
	   AND       A.DateTimePlanning >= '#dateformat(now()-7,client.dateSQL)#' 
	   AND       A.DateTimePlanning <= '#dateformat(now()+4,client.dateSQL)#' 
	  
	
	   ORDER BY  A.DateTimePlanning DESC,PL.LastName
	</cfquery>	
			
  <table width="100%">  
  
  	<cfloop index="day" from="0" to="7" step="1">
	
	<cfset datetimeplanning = dateformat(now()+1-day,client.dateSQL)>
	
	  
  	<cfquery name="Summary"       
         dbtype="query">
			SELECT   PersonNo,LastName, FirstName,
			         sum(Planned) as Planned,
					 sum(Actual) as Actual
			FROM     Deliveries
			WHERE    DateTimePlanning = '#datetimeplanning#'
			GROUP BY PersonNo,LastName, FirstName
	</cfquery>	

	<cfquery name="total"       
        dbtype="query">
		SELECT   sum(Planned) as Planned,
				 sum(Actual) as Actual
		FROM     Deliveries			
		WHERE    DateTimePlanning = '#datetimeplanning#'	
	</cfquery>	
		  
	
	<cfif total.planned neq "">
	
		<cfoutput>
		
	  	<tr>
	  	  <td valign="top" class="labellarge" style="font-size:34px;padding-top:8px;padding-left:15px">		   
			<font size="5">&nbsp;<b>#dateformat(datetimeplanning,"DDDD DD MMMM YYYY")#</b> :</font> <font><font size="7"><cfif total.planned eq "">None<cfelse><b>#total.planned#</b><font size="2">&nbsp;scheduled</font></cfif></font>
		  </td>
		  <td align="right" valign="bottom" class="labelmedium">
		  <img src="#SESSION.root#/images/logos/map.png" align="absmiddle" height="16" width="16" alt="" border="0">
		  <a href="#session.root#/workorder/application/Delivery/DeliveryView.cfm?mission=#url.mission#&date=#dateformat(datetimeplanning,CLIENT.DateFormatShow)#" target="_blank"><font color="0080FF">[Open Planner]</font></a>
		  </td>
	    </tr>  
				
		</td></tr>
		</cfoutput> 
		
		<tr><td class="line" colspan="2"></td></tr>
		    
		<cfif summary.recordcount gte "1"> 
		
	    <tr>
		
	       <td align="left">
		
			<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
					
			<cfchart style = "#chartStyleFile#" format="png" 			       
			         chartheight="430" 
					 chartwidth="550" 
					 showxgridlines="yes" 
					 showygridlines="yes"
					 gridlines="6" 
					 showborder="no" 				
					 fontitalic="no" 				
					 labelformat="percent"
					 show3d="no"
					 rotated="no" 
					 sortxaxis="no" 				 
					 tipbgcolor="##FFFFCC" 
					 url="javascript:ptoken.navigate('#SESSION.root#/portal/topics/WorkOrderDelivery/TopicDetail.cfm?mission=#url.mission#&LastName=$SERIESLABEL$&dts=#dateformat(datetimeplanning,CLIENT.DateFormatShow)#','detail_#day#')"
					 showmarkers="yes" 
					 markersize="30" 
					 backgroundcolor="##ffffff">					 
					 
						<cfchartseries
			             type="pie"
			             query="Summary"
			             itemcolumn="LastName"
			             valuecolumn="Planned"		             
						 datalabelstyle="columnLabel"
			             colorlist="##5DB7E8,##E8875D,##E8BC5D,##E85DA2,##5DE8D8,##CCCA6A,##339AFA,##66AC6A,##999A9A,##FFFA9A,##996AFA"
			             paintstyle="plain"></cfchartseries>				 
															 
					</cfchart>  
				
			</td>
			
			<td align="right" valign="top">
			
			<cf_space spaces="100">
			
			<cfquery name="DagDeel"       
	         dbtype="query">
			 SELECT   PersonNo,LastName, FirstName,  <!--- , DagDeel, --->
			          sum(Planned) as Planned,
					  sum(Actual) as Actual
			 FROM     Deliveries
			 WHERE    DateTimePlanning = '#datetimeplanning#'
			 GROUP BY PersonNo,LastName, FirstName <!--- ,DagDeel --->
		    </cfquery>	

			<cfquery name="qCheck"       
	         dbtype="query">
				 SELECT *
				 FROM   Deliveries
				 WHERE  DateTimePlanning = '#datetimeplanning#'
				 AND    Actual = 0 
		    </cfquery>	
			
			<table width="95%" cellspacing="0" border="0" cellpadding="0" class="navigation_table">
			<tr>
				<cfoutput>
				<td height="4" class="labelmedium" align="right" colspan="4" id="btnConfirm_#dateformat(datetimeplanning,'DDMMYYYY')#" name="btnConfirm_#dateformat(datetimeplanning,'DDMMYYYY')#">
					<cfif qCheck.recordcount neq 0 AND DateTimePlanning lt dateformat(now(),client.dateSQL)>
							<a href="javascript:doConfirm('#datetimeplanning#')" style="color:0080FF">[Confirm Scheduled Deliveries on #datetimeplanning#]</a>
							<div id="result">
							</div>
					</cfif>		
				</td>
				</cfoutput>				
			</tr>				
			<tr><td height="4"></td></tr>
			<tr class="labelmedium">
				<td>Driver</td>
				<!---
				<td>Schedule</td>
				--->
				<td align="right">Planned</td>
				<td align="right">Delivered</td>
			</tr>		
			<tr><td colspan="4" class="line"></td></tr>
			<tr><td height="4"></td></tr>
			
			<cfoutput query="DagDeel" group="LastName">
			<cfoutput group="firstName">
			
			<cfquery name="get"       
	         dbtype="query">
				SELECT   *
				FROM     Summary
				WHERE    LastName  = '#lastname#'
				AND      FirstName = '#firstname#'			
			</cfquery>	
		
			<tr class="labelmedium navigation_row">
			<td style="padding-right:4px" height="18" colspan="1" style="padding-left:3px">#get.FirstName# #get.LastName#</td>				
			<td align="right">#get.Planned#</td>			
			<td style="padding-right:4px" align="right" id="total_#get.PersonNo#_#dateformat(datetimeplanning,"DDMMYYYY")#">#get.Actual#</td>		
			</tr>
			
			<!---
			<tr><td colspan="4" class="line"></td></tr>
			<cfoutput group="dagdeel">
			<tr class="labelit navigation_row">
			    <td></td>
				<!--- <td>#DagDeel#</td> --->
				<td align="right">#Planned#</td>
				<!---
				<cfset topiccode = ReReplaceNoCase(DagDeel,"[^0-9,]","","ALL")>
				--->
				<td align="right" id="actual_#PersonNo#_#dateformat(datetimeplanning,'DDMMYYYY')#">#Actual#</td>
			</tr>
			</cfoutput>			
			--->
			</cfoutput>
			</cfoutput>
			</table>		
			
			</td>	  	
		
		</tr>
		
		</cfif>
				
	</cfif>
	
	<cfoutput>
	
    <tr><td colspan="2" id="detail_#day#"></td></tr>
	
	</cfoutput>
	
		
	</cfloop>

	</table>
	</td>

</tr>	
		
</table>

<cfset ajaxonload("doHighlight")>	
