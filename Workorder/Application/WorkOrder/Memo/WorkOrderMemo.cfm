
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
				<table cellpadding="0" cellspacing="0" width="100%" border="0">
				
					<tr>
						<td width="60px"></td>
						<td height="35px" colspan="4" valign="middle" class="labelmedium" style="padding-top:5px"><b>
							<img src="#SESSION.root#/Images/pencil_write.png" alt="Enter a memo" border="0" width="22px" height="22px" align="absmiddle">
							&nbsp;<cf_tl id="Please enter your Memo">
						</td>
					</tr>
					
					<tr>
					    <td>&nbsp;&nbsp;#currentrow#.<cf_space spaces="14"></td>
						<td colspan="4" align="left" height="110px">
							<textarea name="WorkOrderMemo" class="regular" style="font-size:13px;padding:4px;border-radius:4px;background-color:ffffef;width: 99%;height:100">#WorkOrderMemo#</textarea>
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
					<input type="button" name="Save" id="Save" value="Save" class="button10s" style="width:100px" onclick="ColdFusion.navigate('../Memo/WorkOrderMemo.cfm?tabno=#url.tabno#&workorderid=#url.workorderid#&memoid=#memoid#&mission=#url.mission#','contentbox#url.tabno#','','','POST','memoform')">
					</td></tr>
					<tr><td height="6" colspan="5"></td></tr>
				</table>
			</td>
		</tr>
		
		<cfelse>
				   			
			    <tr class="navigation_row">
			    <td class="labelit" height="23">&nbsp;&nbsp;#currentrow#.<cf_space spaces="14"></td>
				<td class="labelit" width="70%">#paragraphformat(WorkOrderMemo)#</td>
				<td class="labelit">#OfficerFirstName# #OfficerLastName#</td>
				<td class="labelit">#dateformat(created,CLIENT.DateFormatShow)# #timeformat(created,"HH:MM")#</td>
				<cfif SESSION.acc eq OfficerUserId>
				 <td align="center" style="padding-right:3px">
				   <cf_img icon="edit" navigation="Yes"  onclick="ColdFusion.navigate('#SESSION.root#/workorder/application/workorder/Memo/WorkOrderMemo.cfm?tabno=#url.tabno#&WorkOrderId=#url.WorkOrderId#&memoid=#memoid#&mission=#url.mission#','contentbox#url.tabno#')" border="0">				  
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
				
					<tr style="font-family: Calibri; font-size: 14px;">
						<td width="60px"></td>
						<td height="35px" colspan="4" valign="middle" style="padding-top:5px" class="labelmedium"><b>
							<img src="#SESSION.root#/Images/pencil_write.png" alt="Enter a memo" border="0" width="22px" height="22px" align="absmiddle">
							&nbsp;&nbsp;<cf_tl id="Please enter your Memo">
						</td>
					</tr>
						
					<tr>
						<td> <cf_space spaces="6"><cfoutput>&nbsp;&nbsp;#memo.recordcount+1#.</cfoutput></td>
						<td colspan="4" align="left" height="110px">
							<textarea name="WorkOrderMemo" class="regular" style="font-size:13px;padding:4px;border-radius:4px;background-color:ffffef;width: 99%;height:100"></textarea>
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
							  style   = "width:120px; height:23" 
							  class   = "button10s" 
							  onclick = "ColdFusion.navigate('../Memo/WorkOrderMemo.cfm?tabno=#url.tabno#&WorkOrderId=#url.WorkOrderId#&memoid=#memoid#&mission=#url.mission#','contentbox#url.tabno#','','','POST','memoform')">
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
