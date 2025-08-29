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
<cfquery name="getLastDate" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	SELECT LastScheduleDate, count(*)
	FROM (
	
	    SELECT   WL.DateExpiration,
		         WLS.ScheduleId, 
		         WLS.ScheduleName, 
				 WLS.ActionClass, 
				 WLS.WorkSchedule, 
				 WLS.WorkSchedulePriority, 
				 WLS.ScheduleClass, 
				 WLS.ScheduleEffective,
                 (SELECT  MAX(ScheduleDate) AS Expr1
                  FROM    WorkOrderLineScheduleDate
                  WHERE   ScheduleId = WLS.ScheduleId) AS LastScheduleDate
				  
		FROM     WorkOrderLine AS WL INNER JOIN
                 WorkOrderLineSchedule AS WLS ON WL.WorkOrderId = WLS.WorkOrderId AND WL.WorkOrderLine = WLS.WorkOrderLine
				 
		WHERE    WL.WorkOrderId    = '#url.workorderid#'
		
		AND     (WL.DateExpiration IS NULL OR WL.DateExpiration >= GETDATE()) 
		
		AND      WL.Operational    = 1 
		
		AND      WLS.ActionStatus  = '1'
		
		) as B
	
	WHERE LastScheduleDate is not NULL	
	GROUP BY LastScheduleDate
	ORDER BY count(*) DESC	
			
</cfquery>	

<table width="90%" align="center">
	
	<tr><td height="40"></td></tr>
	
	<tr><td colspan="2" class="labellarge"><b><u>Extend the scheduled activities assigned to active service lines</td></tr>
	
	<tr><td height="40"></td></tr>
	
	<tr class="xhide">
	    <td height="10" id="processbatch"></td>
	</tr>
	
	<tr><td id="progressbox" colspan="2"  align="center">
	
		<cfform>
		<table width="100%">
		
				<tr>
					<td width="300" style="padding-left:20px" class="labellarge">Most lines were scheduled until:</td>
					<td class="labelmedium"><b><cfoutput>#dateformat(getLastDate.LastScheduleDate,client.dateformatshow)#</cfoutput></td>		
				</tr>
				
				<tr><td height="20"></td></tr>
					
				<tr>
					<td style="padding-left:20px" class="labellarge">Extend until :</td>
					<td>
					
						<cfset new = createDate(year(now()),"12","31")>
					
						 <cf_intelliCalendarDate9
								    Manual="False"
									FieldName="DateSelect" 
									class="regularxl"
									Default="#dateformat(new,client.dateformatshow)#"
									AllowBlank="False">						
					
					</td>
				</tr>
				
				<tr><td height="10"></td></tr>
				
				<tr><td colspan="2" class="line"></td></tr>
							
				<tr><td colspan="2" align="center">
				
				   <cfoutput>
				   
				   <input type="button" 
					      name="Extend" 
						  value="Extend now!" 
					      onclick="_cf_loadingtexthtml='';ColdFusion.navigate('../ServiceDetails/Schedule/doWorkScheduleExtension.cfm?workorderid=#url.workorderid#&extensiondate='+document.getElementById('DateSelect').value,'processbatch');ColdFusion.navigate('#session.root#/tools/ProgressBar/ProgressBarInit.cfm?name=schedule','progressbox')" 
					      class="button10s" 
						  style="height:28;font-size:14px;width:200">
						  
					</cfoutput>	  
					  
				   </td>
			    </tr>
				
		</table>
		</cfform>
	
	</td>
	</tr>		
		
</table>

<cfset ajaxOnLoad("doCalendar")>