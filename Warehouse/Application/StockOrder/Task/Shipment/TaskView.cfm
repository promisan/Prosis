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
		
<!--- --------------------------------------------------------------- --->
<!--- this template is to assign taskorder order headers No to a line --->
<!--- --------------------------------------------------------------- --->

<cfparam name="url.myclentity"   default="">
<cfparam name="url.scope"        default="">
<cfparam name="url.actionStatus" default="0">

<cfparam name="url.stockorderid"  default="">

<cfif url.stockorderid eq "">
	
	<table align="center">
	    <tr><td align="center" class="labelmedium" style="height:60"><font size="3">Task-order does not exist</font></td></tr>
	</table>
	
	<cfabort>

</cfif>

<cfif url.scope eq "regular" or url.myclentity neq "">

    <!--- ------------------------------------------------------------ --->
	<!--- in this mode we have a regular dialog so we load the scripts --->
	<!--- ------------------------------------------------------------ --->

	<cf_dialogProcurement>	
	<cf_ActionListingScript>
	<cf_FileLibraryScript>
	<cfajaximport tags="cfform,cfinput-datefield">
						
	<cfoutput>
	
		<script language="JavaScript">
		
			function processtaskorderreceipt(tid,actormode,template,action,id,batchid) {	
				if (confirm("Do you want to save the "+template+" record ?")) {					
				ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Task/Process/TaskForm'+template+'Submit.cfm?taskid='+tid+'&actormode='+actormode+'&action='+action+'&actionid='+id+'&batchid='+batchid,'processtask','','','POST','formtask')	
				 }		
			} 	
		
			function settaskreceived(id,tn,stockorderid) {		
			
			    if (confirm("Do you want to close the remaining shipping balance for this task ? Attention this action can only be reverted by an administrator.")) {		   
				ColdFusion.navigate('TaskDirect.cfm?id='+id+'&tn='+tn,'d'+id+'_'+tn);
				ColdFusion.navigate('#SESSION.root#/warehouse/application/stockorder/task/shipment/TaskViewWorkflow.cfm?ajaxid='+stockorderid,'#url.stockorderid#');
				}
				// try {opener.document.getElementById('tasktreerefresh').click();}  catch(e){};						
			}
				
			function taskprint(id) {
			    window.open("#SESSION.root#/Tools/Mail/MailPrepareOpen.cfm?id="+id+"&ID1="+id+"&ID0=/warehouse/inquiry/print/TaskView/Task.cfr","_blank", "left=30, top=30, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
			}	
			
			function cancelstockorder(id,scope) {
			    ColdFusion.navigate('TaskAssignmentCancel.cfm?scope='+scope+'&id='+id,'processtask')				
			}
			
		    function unlinkRequestTask(id,scope){
				ColdFusion.navigate('UnlinkTask.cfm?taskid='+id+'&context=window','processtask');
			 }
		</script>
	
	</cfoutput>

</cfif>

<cfquery name="GetTask" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  
    SELECT   H.*,
             R.Description as TaskClassDescription,
			 
			 (SELECT  count(*) 
			  FROM    ItemTransaction T, RequestTask R
			  WHERE   T.RequestId = R.RequestId
			  AND     T.TaskSerialNo = R.TaskSerialNo
			  AND     R.StockOrderId = '#url.stockorderid#'
			  ) as Transactions,
						 		
		     (SELECT OrgUnitName 
			  FROM   Organization.dbo.Organization 
			  WHERE  OrgUnit = H.OrgUnit) as Vendor	 				
			 
	FROM     TaskOrder H INNER JOIN
             Ref_TaskOrderClass R ON H.TaskClass = R.Code
			 	
	WHERE    StockOrderId = '#url.stockorderid#'
			
</cfquery>


<cfif url.stockorderid neq "" and getTask.recordcount eq "0">

<table align="center">
    <tr><td align="center"><font size="3">Task-order no longer exists</font></td></tr>
</table>

<cfabort>

</cfif>

<cfif getTask.recordcount eq "1">

   <cfset url.tasktype = getTask.TaskType>
   <cfset url.mission  = getTask.mission>

</cfif>

<cfinvoke component = "Service.Access"  
   method           = "warehouseshipper" 
   mission          = "#getTask.mission#" 
   warehouse        = "#getTask.warehouse#"
   returnvariable   = "shipperaccess">	   

<cfif url.actionstatus eq "0">
 <cfset html="Yes"> 
<cfelse>
 <cfset html="Yes">
</cfif>

<cfif getTask.ActionStatus eq "1">
     <cfset url.actionstatus = "1">
</cfif>

<cfif url.scope eq "regular" or url.myclentity neq "">

 <cf_screentop height="100%" scroll="yes" layout="webapp" html="#html#"
    user="yes" banner="green" bannerheight="53" line="no" label="Task Order #getTask.Reference#">
	
	<cf_dialogMaterial>
	
	<!--- added 04/04/2013 --->
	
	<cfoutput>
	
	<script language="JavaScript">
	
	function stockbatchprint(id, template) {
		window.open("#SESSION.root#/Tools/Mail/MailPrepareOpen.cfm?ts="+new Date().getTime()+"&id="+id+"&ID1="+id+"&ID0=/"+template,"_blank", "left=60, top=60, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
	}
			
	function processtaskorder(tid,actormode,template,action,id) {		    
	    ht = document.body.offsetHeight-80
		try { ColdFusion.Window.destroy('dialogprocesstask',true)} catch(e){};
		ColdFusion.Window.create('dialogprocesstask', 'Internal Task Order', '',{x:100,y:100,width:890,height:ht,resizable:true,modal:true,center:true})	
		ColdFusion.navigate('#session.root#/Warehouse/Application/StockOrder/Task/Process/TaskForm'+template+'.cfm?taskid='+tid+'&actormode='+actormode+'&action='+action+'&actionid='+id,'dialogprocesstask')			
	}

	</script>
	
	</cfoutput>
	
<cfelse>

  <!--- was giving an scrollbar issue, removed 27/9/2012
 <cf_screentop height="100%" scroll="no" layout="webapp" html="#html#"
    user="yes" close="ColdFusion.Window.destroy('dialogprocesstask',true)" 
	banner="gray" bannerheight="53" label="Task Order #getTask.Reference#">
	--->
 
</cfif>

<cf_divscroll>

<table width="98%" align="center" height="100%" bgcolor="white" cellspacing="0" cellpadding="0">

<tr><td valign="top">
	
<table width="100%" cellspacing="0" cellpadding="0">
	
	<tr><td class="xxhide" id="processtask"></td></tr> 			
	
	<!--- check if we have already recorded transactions for this stockorder --->
		
	<cfquery name="check" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">	  
	    SELECT    I.TransactionId
		FROM      ItemTransaction I INNER JOIN
                  RequestTask R ON I.RequestId = R.RequestId AND I.TaskSerialNo = R.TaskSerialNo
		WHERE     R.StockOrderid = '#url.stockorderid#'
	</cfquery>	
		
	<!--- only administrator functions qualify --->
	
	<cfif shipperaccess eq "EDIT" or shipperAccess eq "ALL">
					
		<cfif ( (url.ActionStatus lte "1" or (getAdministrator("*") eq "1" and url.scope eq "regular") ) AND check.recordcount eq "0") or SESSION.acc eq "xxxxAdministrator">
		
			<tr><td height="26" style="padding-left:3px">
					
					    <cfoutput>
							<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
								<tr>								
									<td style="height:35px" align="left">
									
									     <input type    = "button" 
											    name    = "Cancel" 
			                                    id      = "Cancel"
												value   = "Cancel this Task Order" 		
												class   = "button10g"
												style   = "width:210;height:25;font-size:13"																	
												onclick = "if (confirm('Do you want to undo this order and revert the requested tasked quantities ?')) { cancelstockorder('#url.stockorderid#','#url.scope#') }">
												
									</td>												
								</tr>
							</table>
							
						</cfoutput>
						
				</td>
			</tr>
			
			<tr><td colspan="4" style="border-top:1px dotted silver"></td></tr>
		
					
		</cfif>		
		
	</cfif>				
	
	<tr><td height="6"></td></tr>
	
	<tr>
		
		<td valign="top" style="padding-left:25px;padding-right:25px">
									
		<table width="100%" cellspacing="0" cellpadding="0" bgcolor="white" align="center">
		
			<cfoutput>
							
			<tr>
			
			  <cfif url.tasktype eq "Internal">
			  			  
				  <td height="20" class="labelmedium" width="100"><font color="808080"><cf_tl id="Truck">:</td>
				  <td width="40%" class="labelmedium" id="tasklocation">
				  
				    <table cellspacing="0" cellpadding="0">
					<tr>
						<td class="labelmedium">
					  				  
						<cfquery name="location"
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">		
							SELECT  *
							FROM    WarehouseLocation
							WHERE   Warehouse = '#getTask.Warehouse#'	
							AND     Location  = '#getTask.Location#'
						</cfquery>
					  
					  #Location.Description# (#Location.StorageCode#)
					  
					  </td>
					  		  
					<!--- if a shipment is issued you can no longer edit the truck 13/9/2013 ---> 	
					
					<cfif getTask.transactions eq "0">				  
					
						<cfif url.scope eq "regular" and (shipperaccess eq "EDIT" or shipperAccess eq "ALL")>   
					
						  	<td class="labelmedium" style="padding-left:3px">
							
							 <img style = "cursor:pointer" 
							    src     = "#SESSION.root#/images/edit.gif" 
							    alt     = "Edit" 
								border  = "0"
								onclick = "ColdFusion.navigate('#SESSION.root#/warehouse/application/stockorder/task/shipment/setTaskLocation.cfm?stockorderid=#url.stockorderid#&warehouse=#getTask.Warehouse#','tasklocation')">
								
							 </td>
						
						</cfif>
					
					</cfif>
					
				  </tr>
				  </table>
				  				  
				  </td>	
				  
			  <cfelse>
			  
				  <td height="25" class="labelmedium" width="100"><font color="808080"><cf_tl id="Vendor">:</td>
				  <td width="40%" class="labelmedium">#getTask.Vendor#</td>		
				  
			  </cfif>	
			  
			  <td height="22" class="labelmedium" width="100"><font color="808080"><cf_tl id="Order No">:</td>
			  <td width="40%" class="labelmedium">#getTask.Reference#</td>	
			</tr>
			
			<tr>
			  <td height="20" class="labelmedium"><font color="808080"><cf_tl id="Date">:</td>
			  <td class="labelmedium">#dateformat(getTask.OrderDate,CLIENT.DateFormatShow)#</td>			
			  <td height="20" class="labelmedium"><font color="808080"><cf_tl id="Class">:</td>
			  <td class="labelmedium">#getTask.TaskClassDescription#</td>	
			</tr>
									
			<tr>
			  <td height="20" class="labelmedium"><font color="808080"><cf_tl id="Issued on">:</td>
			  <td class="labelmedium">#dateformat(getTask.Created,CLIENT.DateFormatShow)# #timeformat(getTask.Created,"HH:MM")#</td>		
			  <td height="20" class="labelmedium"><font color="808080"><cf_tl id="Tasked by">:</td>
			  <td class="labelmedium">#getTask.OfficerFirstName# #getTask.OfficerLastName#</td>	
			</tr>
			
			<cfif getTask.PersonNo neq "">
			
				<cfquery name="Person"
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">		
					SELECT   *
					FROM     Person
					WHERE    PersonNo = '#getTask.PersonNo#'				
				</cfquery>
								
				<tr>
				  <td height="20" class="labelmedium"><font color="808080"><cf_tl id="Driver">:</td>			  
				  <td class="labelmedium">#Person.FirstName# #Person.LastName# (#Person.Reference#)</td>	
				</tr>		
			
			</cfif>
			
			<cfif getTask.Remarks neq "">
			
				<tr>
				  <td height="20" class="labelmedium"><cf_tl id="Remarks">:</td>
				  <td colspan="3" class="labelmedium">#getTask.Remarks#</td>		
				</tr>
			
			</cfif>		
				
			
			<tr><td height="4"></td></tr>
		
			<tr>
				<td colspan="4">						
				
				<cfset edit = "0">		
				<cfinclude template="TaskDetail.cfm">						
				
				</td>
			</tr>		
			
			<cfif getTask.recordcount gte "0">
			
				<tr><td colspan="4">
				
				<!--- workflow --->
				
				<cfset wflnk = "#SESSION.root#/warehouse/application/stockorder/task/shipment/TaskViewWorkflow.cfm">
		   
			    <input type="hidden" id="workflowlink_#url.stockorderid#" value="#wflnk#"> 
			 
			 	<cfdiv id="#url.stockorderid#"  bind="url:#wflnk#?ajaxid=#url.stockorderid#"/>
						
				</td></tr>		
			
			</cfif>			
								
			</cfoutput>
		
		</table>
				
		</td>
		
	</tr>	
	
	<cfif url.scope eq "regular" or url.myclentity neq "">
	
	<cfelse>
			
		<cf_tl id="Close" var="1">
				
		<tr><td align="center" style="padding:5px">
		
			<input class="button10s" value="#lt_text#" style="width:150;height:22" onclick="ColdFusion.Window.destroy('dialogprocesstask',true)">
		
		</td></tr>
	
	</cfif>
	
</table>

</td></tr>

</table>

</cf_divscroll>

<cf_screenbottom layout="webapp">


