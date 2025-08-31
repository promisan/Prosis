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
<cf_actionlistingscript>
<cf_dialogstaffing>

<cfquery name="Action" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
     SELECT * FROM EmployeeAction A, Ref_Action R
	 WHERE A.ActionCode = R.ActionCode
	 AND   A.ActionDocumentNo = '#url.drillid#'	
</cfquery>

<cfif Action.ActionPersonNo neq "">

	 <cfquery name="Person" 
	    datasource="AppsEmployee" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	     SELECT * 
		 FROM   Person
		 WHERE  PersonNo = '#Action.ActionPersonNo#'
	  </cfquery> 
	  
	  <cfif Person.recordcount eq "0">
	  
	  	<!--- record has vanished to we can remove the action as well --->
	  
		<cfquery name="reset" 
		    datasource="AppsEmployee" 
	    	username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
	    	 DELETE FROM EmployeeAction 
			 WHERE ActionDocumentNo = '#url.drillid#'	
		</cfquery>
		
		<cfquery name="resetwf" 
		    datasource="AppsOrganization" 
	    	username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
	    	 DELETE FROM OrganizationObject
			 WHERE  EntityCode = 'PersonAction'	
			 AND    ObjectKeyValue1 = '#url.drillid#'
		</cfquery>	
		
	  </cfif>

</cfif>

<cfif Action.Recordcount eq "0">

		<cfquery name="resetwf" 
		    datasource="AppsOrganization" 
	    	username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
	    	 DELETE FROM OrganizationObject
			 WHERE  EntityCode = 'PersonAction'	
			 AND    ObjectKeyValue1 = '#url.drillid#'
		</cfquery>	
		
		<table width="95%" height="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		
		<tr><td align="center" style="height:100px" class="labelmedium"><cf_tl id="Record was purged"></td></tr>
		
		</table>


</cfif>

<cf_screentop height="100%" 
    label="Personnel Action" 
	option="Listing of raised personnel actions" 
	line="no" 
	scroll="No" 
	layout="webapp" 
	banner="gray"
	jquery="yes">
	
<cfoutput query="Action">
			 
	<table width="97%" height="100%" align="center" class="formpadding">
	
	<tr><td height="3"></td></tr>
	<tr class="line labelmedium2">
	   <td height="15" width="100"><cf_tl id="Action No">:</td>
	   <td width="40%">#Action.ActionDocumentNo#</td>
	   <td height="15"><cf_tl id="Action">:</td>
	   <td>#Action.Description# <cfif ActionStatus eq "9"><font color="FF0000">:<cf_tl id="Revoked"></font></cfif></td>
	</tr>
	
	<tr class="line labelmedium2">
	   <td height="15"><cf_tl id="Officer">:</td>
	   <td>#Action.OfficerFirstName# #Action.OfficerLastName# #dateformat(Action.Created, CLIENT.dateformatshow)# #timeformat(Action.Created, "HH:MM:SS")#</td>
	   <td height="15"><cf_tl id="Action Effective">:</td>
	   <td>#dateformat(Action.ActionDate, CLIENT.DateFormatShow)#</td>
	</tr>
	
	<cfif Action.ActionPersonNo eq "">
	<tr class="line labelmedium2">
	   <td height="15"><cf_tl id="Mode">:</td>
	   <td>Mandate Batch Process</td>
	   
	   <cfif Action.ActionDescription neq "">	
	   <td height="15"><cf_tl id="Memo">:</td>
	   <td>#Action.ActionDescription#</td>
	   </cfif>  
	   
	</tr>
	
	<cfelse>
	
		
	   <cfif Action.ActionDescription neq "">	
		<tr class="line labelmedium2">   
	 	  <td height="15">Memo:</td>
		   <td>#Action.ActionDescription#</td>
		</tr>   
	   </cfif>  
	   	   	 
	   <cfquery name="Person" 
	    datasource="AppsEmployee" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	     SELECT * 
		 FROM   Person
		 WHERE  PersonNo = '#Action.ActionPersonNo#'
	  </cfquery> 
	  
	  <tr class="line labelmedium2" style="border-top:1px solid silver">	
	   <td height="15"><cf_tl id="Name">:</td>
	   <td colspan="1"><a href="javascript:EditPerson('#Person.PersonNo#')">#Person.FirstName# #Person.LastName# (#Person.PersonNo#) #Person.Gender#</a></td>	
	   <td height="15"><cf_tl id="IndexNo">:</td>
	   <td colspan="1">#Person.IndexNo# #Person.PersonStatus#</td>
	   </tr>	
	   
	   <tr class="line labelmedium2">	
	   <td height="15"><cf_tl id="DOB">:</td>
	   <td colspan="1">#dateformat(Person.BirthDate,client.dateformatshow)#</td>	
	   <td height="15"><cf_tl id="Nationality">:</td>
	   <td colspan="1">#Person.Nationality#</td>
	   </tr>	
	 	
	</cfif>	
	
		
	<cfquery name="Source" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	 SELECT *
	 FROM (
	     SELECT   '1' as Sort, A.ActionSourceId as ParentSourceId, A.ActionSourceNo as ParentSourceNo, EAS.*
		 FROM     EmployeeActionSource EAS INNER JOIN EmployeeAction A ON EAS.ActionDocumentNo = A.ActionDocumentNo
		 WHERE    A.ActionDocumentNo = '#Action.ActionDocumentNo#'	
		 AND      A.ActionSourceId = EAS.ActionSourceId
		 UNION 
		 SELECT   '2' as Sort, A.ActionSourceId as ParentSourceId, A.ActionSourceNo as ParentSourceNo, EAS.*
		 FROM     EmployeeActionSource EAS INNER JOIN EmployeeAction A ON EAS.ActionDocumentNo = A.ActionDocumentNo
		 WHERE    A.ActionDocumentNo = '#Action.ActionDocumentNo#'	
		 AND      A.ActionSourceId != EAS.ActionSourceId
		 ) as B
		 ORDER BY Sort,ActionStatus,Created 
	</cfquery>
			
	<tr><td colspan="4" height="100%">
	
	<table width="100%" height="100%">
				
	<cfif getAdministrator("*") eq "1" and Action.ActionSource eq "Person">
	
		<script language="JavaScript">		
			function revert(doc) {		
				ptoken.navigate('ActionDialogRevert.cfm?actiondocumentno='+doc,'revert')		
			}		
		</script>
		
		<tr>
		
		<td colspan="3" align="left" id="revert" style="height:40">
					
				<cf_tl id="Cancel" var="1">
				
				<cfoutput>
					<input class="button10g" 
					       onclick="revert('#Action.ActionDocumentNo#')" 
						   style="width:110" 
						   type="button" 
						   name="Delete" 
						   value="<cfoutput>#lt_text#</cfoutput>">
				</cfoutput>
					
		</td>
		
		</tr>
	
	
	</cfif>
		
	<cfif source.recordcount gte "2" and source.actionfield eq "">
	<tr><td colspan="3" align="center" class="labelmedium2" style="padding:4px;height:1px">		
	This action <cfif ActionDescription eq "denied"><font color="FF0000">would have</font><cfelse>has</cfif> affected <b>#source.recordcount#</b> records in the system. You may inspect each leg by selecting the below links in the colored box.	
	</td></tr>	
	</cfif>
		
	<tr><td colspan="3">
	
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
				
		<cfset wf = 0>
		
		<cfset lk = "">
		
		<cfif Source.ActionSource neq "Assignment">
		
			<tr>			
			<td style="width:200px">
						
			<table width="100%">
			<tr>
						
			<cfloop query="Source">			   
					
				<cfif actionfield neq "">
				
					<cfset wf = 1>
					
					<cfif ActionStatus neq "9">
					
						<td style="height:40px"></td>
						<td style="padding-left:8px"><font color="808080"><cf_tl id="After">:</td>
						<td style="padding-left:8px"><font size="3">#ActionFieldValue# (effective per : <cfif ActionFieldEffective eq "">#dateformat(Created,CLIENT.DateFormatShow)#<cfelse>#dateformat(ActionFieldEffective,CLIENT.DateFormatShow)#</cfif>)</td>
									
					<cfelse>
					
						<td style="height:40px"></td>
						<td style="padding-left:8px"><font color="808080"><cf_tl id="Before">:</td>
						<td style="padding-left:8px"><font size="3">#ActionFieldValue#</td>							
						</tr>		
								
					</cfif>
														
				<cfelse>
				
					<cfset wd = 100/source.recordcount>
																			
					<cfif actionSource eq source.actionsource>
					
					    <cfif source.recordcount gte "2">
											
							<cfset wf = 0>
										
							<cfif ActionStatus eq "1">
																
								<cfif (actionSourceId eq parentsourceId and actionsourceid neq "") or (actionSourceNo eq parentsourceno and actionSourceNo neq "")>
								<cfset lk = "#source.actionlink#&action=1">								
								<td align="center" style="cursor:pointer;height:40px;width:#wd#%;background-color:85FE70;padding:6px;font-size:16px;border:1px solid gray"
								onclick="ptoken.open('#SESSION.root#/#ActionLink#&action=1','detail')">
								<a><font color="000000">#currentrow# Primary #ActionSource# leg</a>
								</td>
								<cfelse>
								<td align="center" style="cursor:pointer;width:#wd#%;background-color:silver;padding:6px;font-size:16px;border:1px solid gray"
								onclick="ptoken.open('#SESSION.root#/#ActionLink#&action=1','detail')">
								<a><font color="000000">#currentrow# Associated #ActionSource# leg</a>
								</td>								
								</cfif>
																			
							<cfelse>
																													
								<td align="center" style="cursor:pointer;width:#wd#%;background-color:FF8080;padding:6px;font-size:16px;border:1px solid gray"
								onclick="ptoken.open('#SESSION.root#/#ActionLink#&action=1','detail')">								
								<a><font color="000000">#currentrow# Superseded #ActionSource# leg</font></a>								
								</td>
							
							</cfif>
							
						<cfelse>
						
							<cfset lk = "#source.actionlink#&action=1">	
						
						</cfif>							
					
					</cfif>				
					
				</cfif>	
			
			</cfloop>
			
			</tr>
				</table>
				</td>
					
			</tr>
						
			<cfif wf eq "1" or left(actionCode,1) eq "1">
									
				<tr><td height="6"></td></tr>
										
				<cfoutput>
				
					<cf_actionListingScript>
					<cf_FileLibraryScript>
																
					<input type="hidden" 
					   name="workflowlink_#url.drillid#" 
					   id="workflowlink_#url.drillid#" 
					   value="#SESSION.root#/Staffing/Application/Employee/PersonAction/ActionWorkflow.cfm">		
			
					<tr>
						<td height="99%" width="100%" align="center" valign="top">
						
						<table width="98%" height="100%" 							
							 align="center" 
							 bgcolor="FAFAFA" 
							 style="border: 0px solid b1b1b1;" 
							 class="formpadding">
							 
						<tr><td valign="top">
																	  													
						<cf_securediv id="#url.drillid#" 
						    bind="url:#SESSION.root#/Staffing/Application/Employee/PersonAction/ActionWorkflow.cfm?ajaxid=#url.drillid#">   
							
							</td>
						</tr>
						</table>
										
						</td>
					</tr>
														
				</cfoutput>			
			
			</cfif>
		
		</cfif>
				
		</table>
		
	</td></tr>
	
	<cfset checksum = round(Rand()*5)>	
					
	<cfif Source.ActionLink neq "">
			   
		<tr>
		<td height="99%">
										
			<cfif Source.ActionSource eq "Assignment">
			
				<cfif checksum eq "1">
				
					<cfquery name="Clean" 
					    datasource="AppsEmployee" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
						DELETE EmployeeAction
						FROM   EmployeeAction A
						WHERE  ActionSource = 'Assignment' 
						AND    ActionPersonNo IN (SELECT PersonNo FROM Person WHERE PersonNo = A.ActionPersonNo) 
						AND    ActionSourceNo NOT IN (SELECT AssignmentNo FROM PersonAssignment WHERE AssignmentNo = A.ActionSourceNo)
						AND    ActionSourceNo is not NULL
					</cfquery>				
				</cfif>	
						
				<cfset lk = Source.ActionLink & "&action=1">	
				
			
			<cfelse>	
			
				<cfquery name="Parent" 
			    datasource="AppsEmployee" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				     SELECT   * 
					 FROM     EmployeeActionSource
					 WHERE    ActionDocumentNo = '#Action.ActionDocumentNo#'	
					 AND      ActionSourceId   = '#Action.ActionSourceId#'	
				</cfquery>
				
				<cfset link = Parent.ActionLink>
							
				<cfif Parent.ActionSource eq "Contract">
				
					<!--- cleanup --->
					
					<cfif checksum eq "1">
					
						<cfquery name="Clean" 
					    datasource="AppsEmployee" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
							DELETE EmployeeAction
							FROM   EmployeeAction A
							WHERE  ActionSource = 'Contract' 
							AND    ActionPersonNo IN     (SELECT PersonNo   FROM Person WHERE PersonNo = A.ActionPersonNo) 
							AND    ActionSourceId NOT IN (SELECT ContractId FROM PersonContract WHERE Contractid = A.ActionSourceId)
						</cfquery>		
					
					</cfif>					
					
				    <!--- 
					<cfquery name="Check" 
				    datasource="AppsEmployee" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
					     SELECT   ActionStatus 
						 FROM     PersonContract
						 WHERE    PersonNo    = '#Parent.PersonNo#'	
						 AND      ContractId  = '#Parent.ActionSourceId#'	
					</cfquery>
					--->
					
				<cfelseif Parent.ActionSource eq "Dependent">
				
					<!--- cleanup --->
					
					<cfif checksum eq "1">
					
						<cfquery name="Clean" 
					    datasource="AppsEmployee" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
							DELETE EmployeeAction
							FROM   EmployeeAction A
							WHERE  ActionSource = '#Parent.ActionSource#' 
							AND    ActionPersonNo IN     (SELECT PersonNo FROM Person WHERE PersonNo = A.ActionPersonNo) 
							AND    ActionSourceId NOT IN (SELECT DependentId FROM PersonDependent WHERE Dependentid = A.ActionSourceId)				
						</cfquery>		
					
					</cfif>
				
					 <!--- 
					<cfquery name="Check" 
					    datasource="AppsEmployee" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
						     SELECT   ActionStatus 
							 FROM     PersonDependent
							 WHERE    PersonNo    = '#Parent.PersonNo#'	
							 AND      DependentId  = '#Parent.ActionSourceId#'	
					</cfquery>	
					--->				
					
				<cfelseif Parent.ActionSource eq "Leave">	
				
					<cfif checksum eq "1">
				
						<cfquery name="Clean" 
					    datasource="AppsEmployee" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">					
							DELETE EmployeeAction
							FROM   EmployeeAction A
							WHERE  ActionSource = '#Parent.ActionSource#' 
							AND    ActionPersonNo IN     (SELECT PersonNo FROM Person WHERE PersonNo = A.ActionPersonNo) 
							AND    ActionSourceId NOT IN (SELECT LeaveId FROM PersonLeave WHERE LeaveId = A.ActionSourceId)					
						</cfquery>		
					
					</cfif>
				
					<!---
					<cfquery name="Check" 
					    datasource="AppsEmployee" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
						     SELECT   Status as ActionStatus
							 FROM     PersonLeave
							 WHERE    PersonNo    = '#Parent.PersonNo#'	
							 AND      LeaveId  = '#Parent.ActionSourceId#'	
					</cfquery>
					--->	
					
				<cfelseif Parent.ActionSource eq "SPA">	
				
					<cfif checksum eq "1">
				
						<cfquery name="Clean" 
					    datasource="AppsEmployee" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
							DELETE EmployeeAction
							FROM   EmployeeAction A
							WHERE  ActionSource = '#Parent.ActionSource#' 
							AND    ActionPersonNo IN     (SELECT PersonNo FROM Person WHERE PersonNo = A.ActionPersonNo) 
							AND    ActionSourceId NOT IN (SELECT PostAdjustmentId FROM PersonContractAdjustment WHERE PostAdjustmentId = A.ActionSourceId)					
						</cfquery>		
					
					</cfif>
				  
				    <!---
					<cfquery name="Check" 
					    datasource="AppsEmployee" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
						     SELECT   ActionStatus
							 FROM     PersonContractAdjustment
							 WHERE    PersonNo    = '#Parent.PersonNo#'	
							 AND      PostAdjustmentId  = '#Parent.ActionSourceId#'	
					</cfquery>	
					--->	
				
				</cfif>
				
			</cfif>	
			
			<cftry>
				<cfparam name="Check.actionStatus" default="0">
			<cfcatch>

			</cfcatch>	
			</cftry>	
			
			<!--- this is likely a bit too much house cleaning as it hides some history that cuased transaction to be deactivated 
			
			<cfif check.actionStatus gte "8">
			
				<cfquery name="RevertPA" 
				    datasource="AppsEmployee" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
				    	 UPDATE EmployeeAction 
						 SET    ActionStatus = '9', 
						        ActionDate = getDate(),
								ActionDescription = 'Reverted'
						 WHERE  ActionDocumentNo = '#Parent.ActionDocumentNo#'	
				</cfquery>				
			
			</cfif>
			
			--->			
					    
			<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
			<cfset mid = oSecurity.gethash()/>  	
			
			<iframe src="#SESSION.root#/#lk#&mid=#mid#"
			        name="detail"
			        id="detail"
			        width="100%"
			        height="100%"
			        marginwidth="0"
			        marginheight="0"
			        frameborder="0">
					
			</iframe>
				
		</td>
		</tr>	
				
	<cfelse>
	
		<tr><td height="100%"></td></tr>	
		
	</cfif>
	
	</table>
	</td></tr>
	
</table>

</cfoutput>	