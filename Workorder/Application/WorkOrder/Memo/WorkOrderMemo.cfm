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

<cfparam name="url.memoid"         default="">
<cfparam name="form.WorkOrderMemo" default="">

<cfquery name="Parameter" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_ParameterMission
	WHERE Mission = '#url.Mission#'	
</cfquery>

<cfif url.memoid neq "">

	<cfset memoid = url.memoid>

</cfif>

<cfif form.WorkOrderMemo neq "">

	<cfquery name="Check" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   WorkOrderMemo
		WHERE  WorkOrderId = '#URL.WorkOrderId#'
		AND    MemoId = '#memoid#'		
	</cfquery>
	
	<cfif Check.recordcount eq "0">

		<cfquery name="Memo" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    INSERT INTO WorkOrderMemo
			(WorkOrderId, MemoId, WorkOrderMemo, OfficerUserId, OfficerLastName, OfficerFirstName)
			VALUES
			('#URL.WorkOrderId#','#memoid#','#form.WorkOrderMemo#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')			
		</cfquery>
			
	<cfelse>
	
		<cfquery name="update" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE WorkOrderMemo
			SET    WorkOrderMemo  = '#form.WorkOrderMemo#'
			WHERE  WorkOrderId    = '#URL.WorkOrderId#'
			AND    MemoId = '#memoid#'						
		</cfquery>	
	
	</cfif>
	
	<cfset url.memoid = "">
	
</cfif>

<cfquery name="Memo" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   WorkOrderMemo
	WHERE  WorkOrderId = '#URL.WorkOrderId#'
	ORDER BY Created 
</cfquery>
 

<form method="post" name="memoform" id="memoform">
	
	<table width="95%" 
	  align="center" 	 
	  cellspacing="0" class="navigation_table" 
	  cellpadding="0">
	  
	 <tr><td height="14"></td></tr> 
	
	<tr>
	    <td height="21" width="16"></td>
		<td width="70%" class="labelit"><cf_tl id="Memo"></td>
		<td class="labelit"><cf_tl id="Officer"></td>
		<td class="labelit"><cf_tl id="Date/Time"></td>
		<td align="center"></td>
	
	</tr>
		
	<tr><td colspan="5" height="1" class="line"></td></tr>
	
	<cfoutput query="Memo">
	
		<cfif url.memoid eq memoid and form.WorkOrderMemo eq "" and SESSION.acc eq OfficerUserId>
		<tr>
			<td colspan="5" style="border:0px solid silver">
				<table width="100%">
				
										
					<tr>
					    <td style="padding-left:5px;width:30px">#currentrow#.</td>
						<td colspan="4" align="left" style="width:100%">
							<textarea name="WorkOrderMemo" class="regular" style="border:0px;background-color:f1f1f1;font-size:14px;padding:4px;width: 99%;height:100">#WorkOrderMemo#</textarea>
						</td>
					</tr>
					
					<!--- attachments --->
					
					<tr>
					   
					   <td></td>
						<td colspan="4">
															
							<cf_filelibraryN
						    	DocumentHost="#parameter.documenthost#"
								DocumentPath="#parameter.documentLibrary#"
								SubDirectory="#url.workorderid#" 
								Box="box_#currentrow#"
								loadscript="no"
								style="border: 0px solid silver"
								width="100%"												
								Filter="#left(memoid,8)#"						
								Insert="yes"
								Remove="yes"
								reload="true">			
						</td>
					</tr>
										
					<tr><td colspan="5" align="center">
					<input type="button" name="Save" id="Save" value="Save" class="button10g" style="width:220px" onclick="ptoken.navigate('../Memo/WorkOrderMemo.cfm?tabno=#url.tabno#&workorderid=#url.workorderid#&memoid=#memoid#&mission=#url.mission#','contentbox#url.tabno#','','','POST','memoform')">
					</td></tr>
					<tr><td height="6" colspan="5"></td></tr>
				</table>
			</td>
		</tr>
		
		<cfelse>
				   			
			    <tr class="navigation_row labelmedium2">
			    <td height="23" style="padding-left:4px;padding-right:10px">#currentrow#.</td>
				<td width="70%">#paragraphformat(WorkOrderMemo)#</td>
				<td>#OfficerFirstName# #OfficerLastName#</td>
				<td>#dateformat(created,CLIENT.DateFormatShow)# #timeformat(created,"HH:MM")#</td>
				<cfif SESSION.acc eq OfficerUserId>
				 <td align="center" style="padding-right:3px">
				   <cf_img icon="open" navigation="Yes"  onclick="ptoken.navigate('#SESSION.root#/workorder/application/workorder/Memo/WorkOrderMemo.cfm?tabno=#url.tabno#&WorkOrderId=#url.WorkOrderId#&memoid=#memoid#&mission=#url.mission#','contentbox#url.tabno#')" border="0">				  
			     </td>
			    <cfelse>
			     <td></td>
			    </cfif>
			</tr>
									
			<cf_filelibraryCheck
				    	DocumentHost="#parameter.documenthost#"
						DocumentPath="#parameter.documentLibrary#"
						SubDirectory="#url.workorderid#" 						
						Filter="#left(memoid,8)#">	
						
			<cfif files gte "1">			
			
			<tr>
			   	<td></td>			
				<td colspan="4">
													
					<cf_filelibraryN
				    	DocumentHost="#parameter.documenthost#"
						DocumentPath="#parameter.documentLibrary#"
						SubDirectory="#url.workorderid#" 
						Box="box_#currentrow#"
						loadscript="no"						
						width="99%"						
						Filter="#left(memoid,8)#"						
						Insert="no"
						Remove="no"
						reload="true">	
							
				
				</td>
			</tr>
			
			</cfif>
			
			<tr><td colspan="5" class="line"></td></tr>
			
		
		</cfif>
					
	</cfoutput>
	
	<cfif url.memoid eq "">
	
		<cf_assignId>
		
		<cfset memoid = rowguid>	
		<cfoutput>
		<tr>
			<td colspan="5" style="border:0px solid silver">
				<table cellpadding="0" cellspacing="0" width="100%" border="0">
															
					<tr>
						<td> <cf_space spaces="6"><cfoutput>&nbsp;&nbsp;#memo.recordcount+1#.</cfoutput></td>
						<td colspan="4" align="left" style="width:100%">
							<textarea name="WorkOrderMemo" class="regular" style="background-color:f1f1f1;border:0px;font-size:14px;padding:4px;width: 99%;height:100"></textarea>
						</td>
					</tr>
			
					<tr>
					    <td></td>
						<td colspan="4">		
							
							<cf_filelibraryN
						    	DocumentHost="#parameter.documenthost#"
								DocumentPath="#parameter.documentLibrary#"
								SubDirectory="#url.workorderid#" 
								Box="box_9999"								
								width="100%"								
								loadscript="no"
								Filter="#left(memoid,8)#"						
								Insert="yes"
								Remove="yes"
								reload="true">
													
						</td>
					</tr>
					
					<tr> <td colspan="5" align="center">
					    <cfoutput>		
							<cf_tl id="Save" var="vSave">
							<input type = "button" 
							  name    = "Save" 
                              id      = "Save"
							  value   = "#vSave#" 
							  style   = "width:220px; height:23" 
							  class   = "button10g" 
							  onclick = "ptoken.navigate('../Memo/WorkOrderMemo.cfm?tabno=#url.tabno#&WorkOrderId=#url.WorkOrderId#&memoid=#memoid#&mission=#url.mission#','contentbox#url.tabno#','','','POST','memoform')">
						</cfoutput>
					</td></tr>
					
				</table>
			</td>
		</tr>
		</cfoutput>
	</cfif>
	
</table>

</form>

<cfset AjaxOnLoad("doHighlight")>	
