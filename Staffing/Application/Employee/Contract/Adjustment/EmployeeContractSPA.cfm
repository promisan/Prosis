
<!--- Query returning search results --->

	<cfquery name="SPA" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *,
		 (SELECT TOP 1 ObjectId 
			  FROM Organization.dbo.OrganizationObject 
			  WHERE Objectid = L.PostAdjustmentId) as WorkflowId
	    FROM     PersonContractAdjustment L
		WHERE    L.PersonNo         = '#URL.ID#' 
		AND      L.PostAdjustmentId = '#PostAdjustmentId#'
		<cfif url.status eq "valid">		
		AND      ActionStatus IN ('0','1')
		</cfif>		
		ORDER BY DateEffective DESC
	</cfquery>
		
		
	<cfoutput query="SPA">	
		
	<cfif ActionStatus eq "9">
	
	<tr bgcolor="FEE3DE" class="labelmedium" style="border-top:1px solid silver">
	
	<cfelse>
	
	<tr class="#cl# labelmedium" bgcolor="C6F2EE" style="border-top:1px solid silver">
	
	</cfif>
				
	<td height="20" 
		width="30"	
		style="padding-left:0px"
		align="center"	
		bgcolor="efefef"
		style="cursor:pointer" 
		onclick="workflowdrill('#PostAdjustmentId#','box_#PostAdjustmentId#','spa')" >
	
		 <cfif workflowid neq "">
		 
			 <cfif actionStatus eq "0">
			    <cfset cl = "hide">
				<cfset ce = "regular">
			 <cfelse>	
			    <cfset ce = "hide">
				<cfset cl = "regular">
			 </cfif>
		 
			   <img id="exp#PostAdjustmentId#" 
			     class="#cl#" 
				 src="#SESSION.root#/Images/arrowright.gif" 
				 align="absmiddle" 
				 alt="Expand" 
				 height="9"
				 width="7"			
				 border="0"> 	
								 
			   <img id="col#PostAdjustmentId#" 
			     class="#ce#" 
				 src="#SESSION.root#/Images/arrowdown.gif" 
				 align="absmiddle" 
				 height="10"
				 width="9"
				 alt="hide" 			
				 border="0"> 
			 
		</cfif>	 
	
	</td>
	
	<td bgcolor="efefef"></td>
		
	<TD class="labelmedium" style="border-left:1px solid gray;padding-left:8px;padding-right:14px;border-right:1px solid gray" 
	  align="right" width="80" style="padding-right:6px">SPA:</TD>	
	
	<td align="center" width="30">
	
	     <cfinvoke 
		    component="Service.Access"  
			method="contract"  
			personno="#URL.ID#" 
			returnvariable="access">
	     
		 	<cfif ActionStatus eq "9">	
			
			<!--- hide --->	 
			
			<cfelse>
			
				<!--- <cfif row eq "1">	---->
				 <cfset jvlink = "ColdFusion.Window.create('spa', 'Contract Post Adjustment','',{x:100,y:100,height:630,width:480,resizable:false,modal:true,center:true});ColdFusion.navigate('Adjustment/ContractSPA.cfm?contractid=#contractid#&postadjustmentid=#postadjustmentid#&spabox=#url.spabox#','spa')">						
				 <cfif (access eq "EDIT" or access eq "ALL") and ActionStatus lte "1">				 
				     <cf_img icon="edit" onClick="#jvlink#">			 							 
				 </cfif> 				 
				<!--- </cfif>  ---->
		 
		   </cfif>		
		 
	</td>	
		
	<td colspan="3" style="padding-right:7px"></td>
	
	<TD colspan="2">#PostServiceLocation# #PostSalarySchedule#</TD>		
		
	<TD colspan="1" style="padding-left:1px">#PostAdjustmentLevel#/#PostAdjustmentStep#</TD>
	
	<td>
			
				<cfif stepincreasedate eq "">--
				<cfelseif StepIncreaseDate lte DateEffective><font color="FF0000"
				                              style="font-style: italic; text-decoration: line-through;">#Dateformat(StepIncreaseDate, CLIENT.DateFormatShow)#
				<cfelse>#Dateformat(StepIncreaseDate, CLIENT.DateFormatShow)#
				</cfif>
						
			</td>
	
	<td></td>	
	<td width="80" style="padding-left: 4px;">
	
		<cfif actionStatus eq "9">
			<font color="red"><cf_tl id="Superseded">				
		<cfelse>
			<cfif actionstatus eq "1"><cf_tl id="Cleared"><cfelse><font color="800000"><cf_tl id="Pending"></cfif>
		</cfif>		
	</td>

	<cfset vDatesColor = "background-color:##E0E0E0;">
	<cfif now() GTE DateEffective AND (now() LTE DateExpiration OR DateExpiration eq "")>
		<cfset vDatesColor = "background-color:##95EDA3;">
	</cfif>
	
	<td align="center" style="border-left:1px solid gray;border-right:0px solid silver; #vDatesColor#">#Dateformat(DateEffective, CLIENT.DateFormatShow)#</td>
	<td align="center" style="border-left:1px solid gray;border-right:0px solid silver; #vDatesColor#">
	<cfif DateExpiration neq "">
	#Dateformat(DateExpiration, CLIENT.DateFormatShow)#
	<cfelse>
	<i>..</i>
	</cfif>
	</td>	
	
	</tr>
	
	<cfif remarks neq "">
		<tr class="labelmedium clsDetailComments clsDetailComments_#PostAdjustmentId#" style="border-top:1px solid d0d0d0;background-color:F0FFFF; display:none;">
		<td bgcolor="FFFFFF"></td>
		<td bgcolor="FFFFFF"></td>
		<td colspan="3" align="left" style="background-color:f1f1f1;font-size:12px;height:20px;padding-left:5px;border:1px solid silver;border-bottom:0px solid silver;padding-right:10px;border-top:1px solid d0d0d0">#Officerlastname#: #dateformat(created,client.dateformatshow)#&nbsp;#timeformat(created,"HH:MM")#</td>
		<td colspan="12" align="left" style="background-color:C6F2EE;height:20px;font-size:12px;padding-left:5px;border:1px solid silver;border-bottom:0px solid silver;padding-right:10px;border-top:1px solid d0d0d0"><cfif left(remarks,9) eq "Generated"><font color="800000"></cfif>#Remarks#</td>
		</tr>		
	</cfif>	
	
	<cfif actionStatus eq "0" and dependentshow eq "0">
	
	<!--- determine PA action --->
					
		<cfquery name="PA" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT     TOP 1 *
				FROM       EmployeeAction
				WHERE      ActionSourceId = '#PostAdjustmentId#'			
		</cfquery>	
			
		<cfif PA.recordcount eq "1">
				
			<!--- show workflow directly if this is pending --->
			
			<cfset dependentshow = "1">
			
			<tr id="dependentbox">	
				
				<td></td>
				<td colspan="14" id="contentdependent">
				
				<table width="100%" ccellspacing="0" ccellpadding="0" align="center">
				<tr><td style="border-bottom:1px solid silver;border-right:1px solid silver">
									
					<cfset url.contractid = PostAdjustmentId>
					<cfset url.action = "contract">
										
					<cfinclude template="../../Dependents/EmployeeDependentScript.cfm">
					<cfinclude template="../../Dependents/EmployeeDependentDetail.cfm"> 
				
				</td></tr>
				</table>
				
				</td>
			</tr>
			
		</cfif>	
	
	</cfif>
	
	<cfif workflowid neq "">
			
		<input type="hidden" 
		   name="workflowlink_#PostAdjustmentId#" 
		   id="workflowlink_#PostAdjustmentId#" 		   
		   value="Adjustment/EmployeeContractSPAWorkflow.cfm">			
		   
		<cfif actionStatus eq "0">
		
		<tr id="box_#PostAdjustmentId#" class="regular">
			
			<td></td>
			<td colspan="14" id="#PostAdjustmentId#">
		
			<cfdiv bind="url:Adjustment/EmployeeContractSPAWorkflow.cfm?ajaxid=#PostAdjustmentId#">
			
			</td>
			</tr>
		
		<cfelse>   
			
			<tr id="box_#PostAdjustmentId#" class="hide">
			<td></td>
			<td colspan="14" id="#PostAdjustmentId#"></td></tr>
		
		</cfif>
	
	</cfif>
		
	</cfoutput>
	