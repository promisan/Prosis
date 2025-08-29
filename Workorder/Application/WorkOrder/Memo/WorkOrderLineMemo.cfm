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
<cfparam name="url.memoid"        default="">
<cfparam name="url.action"        default="">
<cfparam name="form.MemoDate"     default="">
<cfparam name="form.MemoBody"     default="">
<cfparam name="form.MemoSubject"  default="">

<cfparam name="URL.containerId"	  default="memobox">

<cfif url.memoid neq "">

	<cfset memoid = url.memoid>

</cfif>

<cfif url.action eq "Delete">

	<cfquery name="Delete" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    DELETE FROM WorkOrderLineMemo
		WHERE  WorkOrderId   = '#URL.WorkOrderId#'
		AND    WorkOrderLine = '#URL.WorkOrderLine#'
		AND    MemoId = '#memoid#'		
	</cfquery>

	<cfset url.memoid = "">
	
<cfelse>	
	
	<cfif Form.MemoDate neq ''>
	    <CF_DateConvert Value="#Form.MemoDate#">
		<cfset DTE = dateValue>
	<cfelse>
	    <cfset DTE = 'NULL'>
	</cfif>
	
	<!--- date convert --->
		
	<cfif form.MemoSubject neq "" or form.MemoBody neq "">
	
		<cfquery name="Check" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   WorkOrderLineMemo
			WHERE  WorkOrderId   = '#URL.WorkOrderId#'
			AND    WorkOrderLine = '#URL.WorkOrderLine#'
			AND    MemoId = '#memoid#'		
		</cfquery>
		
		<cfif Check.recordcount eq "0">
	
			<cfquery name="Memo" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    INSERT INTO WorkOrderLineMemo
					(WorkOrderId, 
					 WorkOrderLine,
					 MemoId, 
					 MemoSubject, 
					 MemoDate, 
					 MemoBody, 
					 OfficerUserId, 
					 OfficerLastName, 
					 OfficerFirstName)
				VALUES
				   ('#URL.WorkOrderId#',
				    '#URL.WorkOrderLine#',
					'#memoid#',
					'#form.MemoSubject#',
					#dte#,
					'#form.MemoBody#',
					'#SESSION.acc#',
					'#SESSION.last#',
					'#SESSION.first#')			
			</cfquery>
				
		<cfelse>
		
			<cfquery name="update" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    UPDATE WorkOrderLineMemo
				SET    MemoBody      = '#form.MemoBody#',
				       MemoSubject   = '#form.MemoSubject#',
					   MemoDate      = #dte#
				WHERE  WorkOrderId   = '#URL.WorkOrderId#'
				AND    WorkOrderLine = '#URL.WorkOrderLine#'  
				AND    MemoId        = '#memoid#'						
			</cfquery>	
		
		</cfif>
		
		<cfset url.memoid = "">
		
	</cfif>

</cfif>

<cfquery name="Workorder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * FROM WorkOrder
		WHERE  WorkOrderId   = '#URL.WorkOrderId#'		
</cfquery>

<!--- define access --->

<cfinvoke component = "Service.Access"  
   method           = "WorkorderProcessor" 
   mission          = "#workorder.mission#" 
   serviceitem      = "#workorder.serviceitem#"
   returnvariable   = "access">	
	
<cfquery name="Memo" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT    *
    FROM      WorkOrderLineMemo
	WHERE     WorkOrderId   = '#URL.WorkOrderId#'
	AND       WorkorderLine = '#url.workorderline#'
	ORDER BY  Created DESC
</cfquery>
		   
<cfform name="memoform" id="memoform">
	
		<table width="95%" 
		  align="center" 	 
		  border="0"	
		  class="navigation_table"
		  cellspacing="0" 
		  cellpadding="0">
		  
		<tr><td height="2"></td></tr> 
		
		<tr>
		    <td height="20" width="16"></td>
			<td width="70%" class="labelit"> <cf_tl id="Memo"></td>
			<td class="labelit"><cf_tl id="Officer"></td>
			<td class="labelit"><cf_tl id="Date">/<cf_tl id="Time"></td>
			<td align="center"></td>
		
		</tr>
		
		<tr><td colspan="5" class="line"></td></tr>
		
		<tr><td height="4"></td></tr>
	
			<cfoutput query="Memo">
			
				<cfif url.memoid eq memoid and SESSION.acc eq OfficerUserId>
				
					<tr bgcolor="ffffff">
					    <td height="20" style="padding-left:4px">#currentrow#.</td>
						<td colspan="4" align="center" height="80">
						<table width="100%" class="formpadding" cellspacing="0" cellpadding="0">
						
						<tr>
						<td class="labelit"><cf_tl id="Subject">:</td>
						<td><input type="text" name="MemoSubject" id="MemoSubject" value="#MemoSubject#" size="50" maxlength="50" class="regularxl"></td>
						</tr>
						
						<tr>
						<td class="labelit"><cf_tl id="Date">:</td>
						<td>
						 <cf_intelliCalendarDate9 class="regularxl" FieldName="MemoDate" Default="#Dateformat(MemoDate, CLIENT.DateFormatShow)#" AllowBlank="True">	
						</td>
						</tr>
						
						<tr><td colspan="2">
						<textarea name="MemoBody" class="regular" style="padding:3px;font-size:14px;width: 100%;height:75">#MemoBody#</textarea>
						</td></tr>
						</table>
						</td>
					</tr>
					
					<tr>
					<td></td>
					<td colspan="4">
							
					<cf_filelibraryN
					    box="doc#currentrow#"
						DocumentPath="WorkOrder"
						SubDirectory="#URL.WorkOrderId#" 
						Filter="#left(memoid,8)#"				
						Insert="yes"
						Remove="yes"
						width="100%"	
						Loadscript="no"				
						border="1">				
					
					</td>
					</tr>
					
					<tr><td height="4"></td></tr>
					<tr><td colspan="5" class="line"></td></tr>
					<tr><td height="4"></td></tr>
					
					<tr><td height="3"></td></tr>
					<tr><td colspan="5" align="center">
					<input type="button" name="Save" id="Save" value="Save" class="button10s" style="width:100px" onclick="ColdFusion.navigate('#SESSION.root#/workorder/application/workorder/Memo/WorkOrderLineMemo.cfm?containerId=#url.containerId#&tabno=#url.tabno#&WorkorderLine=#url.workorderline#&workorderid=#url.workorderid#&memoid=#memoid#','#URL.containerId#','','','POST','memoform')">
					</td></tr>
					
									
				<cfelse>
				
				    <cfif SESSION.acc eq OfficerUserId>
					
						<tr class="navigation_row">
						
					<cfelse>
		
						<tr class="navigation_row">
					
					</cfif>
					
					    <td height="20" valign="top" style="padding-top:3px;padding-left:4px;padding-right:6px">#currentrow#.</td>
						<td colspan="1" width="70%">
							<table class="formpadding">
								<tr><td class="labelit">#dateformat(MemoDate,CLIENT.DateFormatShow)#: <b>#MemoSubject#</b></td></tr>				
								<tr><td class="labelit">#paragraphformat(MemoBody)#</td></tr>
							</table>
						</td>				
						<td class="labelit">#OfficerFirstName# #OfficerLastName#</td>
						<td class="labelit">#dateformat(created,CLIENT.DateFormatShow)# #timeformat(created,"HH:MM")#</td>
						<td align="center">
						
							<cfif SESSION.acc eq OfficerUserId or access eq "EDIT" or access eq "ALL">
								<table cellspacing="3" cellpadding="3"><tr><td>
								
								   <cf_img icon="edit" navigation="Yes"
								   	     onclick="ColdFusion.navigate('#SESSION.root#/workorder/application/workorder/Memo/WorkOrderLineMemo.cfm?containerId=#url.containerId#&tabno=#url.tabno#&WorkOrderId=#url.WorkOrderId#&workorderline=#url.workorderline#&&memoid=#memoid#','#URL.containerId#')" border="0">
								</td>
								<td style="padding-left:4px">
																							
									<cf_img icon="delete"
								   	     onclick="javascript:if (confirm('Remove this record ?. This action can not be reversed !')) {ColdFusion.navigate('#SESSION.root#/workorder/application/workorder/Memo/WorkOrderLineMemo.cfm?containerId=#url.containerId#&tabno=#url.tabno#&WorkOrderId=#url.WorkOrderId#&workorderline=#url.workorderline#&memoid=#memoid#&action=delete','#URL.containerId#')}">
											
								</td>
								</tr>
								</table>
							</cfif>
						
						</td>
						
					  </tr>
					  
					  <tr>
						<td></td>
						<td colspan="4">
								
						<cf_filelibraryN
						    box="doc#currentrow#"
							DocumentPath="WorkOrder"
							SubDirectory="#URL.WorkOrderId#" 
							Filter="#left(memoid,8)#"
							Presentation="all"
							Insert="no"
							Remove="no"
							width="100%"	
							Loadscript="no"				
							border="1">				
						
						</td>
						</tr>
								
				
				</cfif>
								
				<tr><td colspan="5" height="1" class="line"></td></tr>
							
			</cfoutput>	
			
			<cfif url.memoid eq "">
			
			<cf_assignId>
			
			<cfset memoid = rowguid>	
			
			<tr bgcolor="ffffff">
			<td height="23" valign="top" style="padding-top:7px;padding-right:6px"> <cfoutput>#memo.recordcount+1#.</cfoutput></td>
			<td colspan="4" align="center">
			
				<table width="100%" class="formpadding" cellspacing="0" cellpadding="0">
						
						<tr>
						<td class="labelit">Subject:</td>
						<td><input type="text" name="MemoSubject" id="MemoSubject" size="50" maxlength="50" class="regularxl"></td>
						</tr>
						
						<tr>
						<td class="labelit">Date:</td>
						<td>
						 <cf_intelliCalendarDate9
							FieldName="MemoDate" 
							class="regularxl"
							Default="#Dateformat(now(), CLIENT.DateFormatShow)#"				
							AllowBlank="True">	
						</td>
						</tr>
						
						<tr><td colspan="2">
						<textarea name="MemoBody" class="regular" style="padding:3px;font-size:14px;width: 100%;height:75"></textarea>
						</td></tr>
		    	</table>
					
			</td>
			</tr>
			
			<tr>
			<td></td>
			<td colspan="4">
								
			<cf_filelibraryN
				box="doc0"
				DocumentPath="WorkOrder"
				SubDirectory="#URL.WorkOrderId#" 
				Filter="#left(memoid,8)#"			
				Insert="yes"
				Remove="yes"
				width="100%"	
				Loadscript="no"								
				border="1">				
			
			</td>
			</tr>
			
			<tr><td colspan="5" class="line"></td></tr>
			
			<tr><td height="3"></td></tr>
			
			<tr><td colspan="5" align="center">
			    <cfoutput>
					<input type="button" name="Save" id="Save" value="Save" style="width:170px;height:25px;font-size:12px" class="button10g" 
					onclick="ColdFusion.navigate('#SESSION.root#/workorder/application/workorder/Memo/WorkOrderLineMemo.cfm?containerId=#url.containerId#&tabno=#url.tabno#&WorkOrderId=#url.WorkOrderId#&WorkorderLine=#url.workorderline#&memoid=#memoid#','#url.containerId#','','','POST','memoform')">			
				</cfoutput>
			</td></tr>
			
			<tr><td height="3"></td></tr>
				
		</cfif>	
	
	</table>

</cfform>

<cfset ajaxonload("doHighlight")>
<cfset ajaxonload("doCalendar")>