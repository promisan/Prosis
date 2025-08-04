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


<cf_screentop height="100%" jquery="Yes" scroll="no" html="No">

<cf_textareascript>

<cfparam name="url.recordstatus" default="1">
<cfparam name="url.type" default="1">

<script language="JavaScript">

function pdf(id) {
	window.open('TasksPDF.cfm?contractid='+id)
}

function training(itm,val) {
	se = document.getElementById(itm)
	if (val == true) { 
		se.className = "regular" 	
	} else { 
		se.className = "hide" 
	}
}

</script>
    
<cfquery name="WorkContract" 
datasource="AppsEPAS" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Contract
	WHERE  ContractId = '#URL.ContractID#'
</cfquery>

<cfquery name="Parameter" 
datasource="AppsEPAS" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Parameter
</cfquery>

<cfquery name="Priority" 
 datasource="AppsEPAS" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
  SELECT *
  FROM   Ref_Priority
</cfquery>

<cfquery name="Section" 
datasource="AppsEPAS" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_ContractSection
	WHERE  Code = '#URL.Section#'
</cfquery>

<!--- Query returning search results for activities  --->
<cfquery name="EditActivity" 
datasource="AppsEPAS" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT   *		
  FROM     ContractActivity 
  WHERE    ContractId       = '#URL.ContractID#'
  AND      RecordStatus     = '#url.recordstatus#'
  AND      ActivityIdParent is NULL
</cfquery>

<cfif EditActivity.recordcount eq "0" or len(EditActivity.ActivityDescription) lte 20>
	
	<cfquery name="EditActivity" 
	datasource="AppsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT   *		
	  FROM     ContractActivity 
	  WHERE    ContractId = '#URL.ContractID#'
	  AND      RecordStatus = '1'
	  AND      ActivityIdParent is NULL
	</cfquery> 
 
</cfif>

<cfquery name="Evaluation" 
	datasource="AppsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT   *		
	  FROM     ContractEvaluation
	  WHERE    ContractId     = '#URL.ContractID#'
	  AND      EvaluationType = '#url.type#'
</cfquery> 

<cfif Parameter.HideObjective eq "1">
   <cfset cl = "hide">
<cfelse>	
   <cfset cl = "regular">
</cfif>

<!--- Priority and Reference --->
<cfset vShowExtendedInfo = "display:none;">


<cfif workcontract.personNo neq client.personNo and getAdministrator("*") eq "0">

	<table width="99%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
					  
		  <tr><td colspan="2" align="center" style="height:95%">
		  	<h1 style="padding-left:5px;font-size:25px;font-weight:200;color:red">			
			  <cf_tl id="You are not permitted to perform this step">
			 </h1> 
		  </td></tr>
		  
		  <tr><td colspan="2" style="height:40px">
	
			 <cf_Navigation
					 Alias         = "AppsEPAS"
					 Object        = "Contract"
					 Group         = "Contract"
					 Section       = "#URL.Section#"
					 Id            = "#URL.ContractId#"
					 SetNext       = "0"
					 BackEnable    = "1"
					 HomeEnable    = "0"
					 ResetEnable   = "0"
					 ResetDelete   = "0"	
					 ProcessEnable = "0"
					 NextEnable    = "1"
					 NextMode      = "1"
					 NextSubmit    = "0"
					 NextName      = "Next">
			 
			 </td></tr>		 
		  
	</table>  
		
<cfelseif (Evaluation.ActionStatus eq "2" and url.recordstatus eq "2") or (WorkContract.ActionStatus gte "2" and url.recordstatus eq "1")>


	<cfquery name="getActivity" 
	datasource="AppsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT   *		
	  FROM     ContractActivity 
	  WHERE    ContractId       = '#URL.ContractID#'
	  AND      RecordStatus     = '#url.recordstatus#'
	  AND      ActivityIdParent is NULL
	</cfquery>
	
	<cfif getActivity.recordcount eq "0">
	
	     <cfquery name="InsertActivity" 
		     datasource="AppsEPAS" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO ContractActivity
			         ( ContractId,
					   ActivityDescription,
					   Reference,
					   RecordStatus,
					   OfficerUserId,
					   OfficerLastName,
					   OfficerFirstName)
			  SELECT  ContractId,
					   ActivityDescription,
					   Reference,
					   '#url.recordstatus#',
					   OfficerUserId,
					   OfficerLastName,
					   OfficerFirstName
			  FROM     ContractActivity
			  WHERE    ContractId = '#URL.ContractId#'
			  AND      RecordStatus = '1'			     
		  </cfquery>
	  
	 </cfif> 
		

	<table width="99%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
					  
		  <tr><td colspan="2" align="center" height="95%">
		  	<h1 style="padding-left:5px;font-size:25px;font-weight:200;color:red">			
			  <cf_tl id="You are not permitted to perform this step anymore">
			 </h1> 
		  </td></tr>
		 
			<tr><td colspan="2" style="height:40px">
			
			 <cf_Navigation
					 Alias         = "AppsEPAS"
					 Object        = "Contract"
					 Group         = "Contract"
					 Section       = "#URL.Section#"
					 Id            = "#URL.ContractId#"
					 SetNext       = "0"
					 BackEnable    = "1"
					 HomeEnable    = "0"
					 ResetEnable   = "0"
					 ResetDelete   = "0"	
					 ProcessEnable = "0"
					 NextEnable    = "1"
					 NextMode      = "1"
					 NextSubmit    = "0"
					 NextName      = "Next">
					 
					 </td>
			 </tr>
			 
		</table>  	 
	
<cfelse>

	<cfform style="height:100%" action="TasksSubmit.cfm?Section=#URL.Section#&recordstatus=#url.recordstatus#" method="POST" name="entry">
	
	<table height="100%" width="100%">
	
	<tr><td style="height:100%">	
		
		<cf_divscroll>	
	
		<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
			
			<tr>    
		    <td height="36" align="left">
				<cfoutput>
					<table width="100%">
	                    <tr>				
							<td class="labellarge">
							
							<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">	    
								<tr>				
									<td>
									<table><tr><td>
									<img src="#SESSION.root#/Images/Logos/PAS/ReviewEdit-on.png" height="64" alt="" border="0" align="absmiddle" style="margin-left: 20px;float:left;">
									</td><td class="labellarge" style="padding-top:10px;font-size:30px;height:10px;padding:10px 8px 0;font-weight: 200;">
									#Section.Description#
									</tr></table> 
									</td>							
								</tr>
								
							</table>				
						    </td>
											
							<td align="right" style="padding-top:20px;padding-right:20px;">				
							
								<table>		
							    <TR>
							    <td class="labelit" style="padding-left:10px;padding-right:10px;width:80px">
								<cfoutput>
									<cf_interface cde="ActivityReference">#Name#:
								</cfoutput>
								</td>
							    <TD valign="top">			
									<cfinput class="regularxl" name="Reference" value="#EditActivity.Reference#" type="text" size="20" maxlength="20" required="no">
								</TD>
								</TR>
								</table>	
							
							</td>
						</tr>
						
						<cfif section.Instruction neq "">
							<tr><td colspan="2" class="labellarge" style="font-size:16px;padding:10px 28px 0;font-weight: 200;">#Section.Instruction#</td></tr>
						</cfif>
					</table>
				</cfoutput>
		    </td>
		  </tr> 	
	    
		  <tr><td>
		         
		    <table width="97%" align="center">
			
			<tr><td colspan="1">
			
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">			
				  
				<cfoutput>
			    	<input type="hidden" name="ContractId" value="#URL.ContractId#">	
				</cfoutput>
				
				  <tr>						
							<td width="90%" colspan="2" class="labelit">						
							<table>
							<tr>
							<td class="labelmedium" style="height:25px;font-size:20px;padding-left:6px">
							<h1 style="font-size:25px;height:30px;padding:8px 3px 0;font-weight: 200;">
							<cf_tl id="Description of Major assignments and personal objectives"></h1></td>
							</tr>
							</table>						 
							</td>						 
						  </tr>
			    	
				
				 <!--- Field: Activity Description--->
				<TR>
				    <cfoutput>
					
						<TD valign="top" style="padding-left:10px;padding-right:10px;border-bottom:1px solid silver">
									
						 <cf_textarea name="Description"                                            
						   height         = "400"
			               width          = "100%"
						   toolbar        = "mini"
						   loadscript     = "Yes"
						   resize         = "yes"
						   color          = "ffffff">#EditActivity.ActivityDescription#</cf_textarea>
						</TD>
					
					</cfoutput>
				</TR>
				
				</table>
				
			</td></tr>
			   	
			<tr><td height="3" class="<cfoutput>#cl#</cfoutput>"></td></tr>
			
			<tr>
			
			<td colspan="1">
									
					<cfquery name="Class" 
					datasource="AppsEPAS" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT * 
						FROM   Ref_OutputClass
					</cfquery>
					
					<!--- <cfset count = "#Parameter.NoTasks#"> --->
					<cfset count = WorkContract.enableTasks - 1>					
					
					<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
					  
					  <tr>
					    <td width="100%" style="padding-top:10px">
						
					   <table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">						 
						  								         
						   <cfloop index="task" from="1" to="#count#">
						   
						   							  
							  <cfquery name="Activity" 
							    datasource="AppsEPAS" 
								maxrows=1
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								   SELECT *
								   FROM   ContractActivity
								   WHERE  ContractId    = '#URL.ContractId#'
								   AND    RecordStatus = '#url.recordstatus#'
								   AND    ActivityOrder = '#task#'						   
							 </cfquery>						 
													 						 
							 <cfif Activity.recordcount eq "0">
							 						 
								  <cfquery name="Activity" 
								    datasource="AppsEPAS" 
									maxrows=1
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									   SELECT *
									   FROM   ContractActivity
									   WHERE  ContractId    = '#URL.ContractId#'
									   AND    RecordStatus  = '1'
									   AND    ActivityOrder = '#task#'						   
								 </cfquery>
							 
							 </cfif>
						   
						    <TR>
							
						       <td class="labellarge" colspan="3" style="font-size:25px;height:40px;padding-left:5px">
							   
								   <table width="100%">
									   <tr>
									   <td><h2 style="font-size:24px;height:50px;padding:25px 25px 0 0;font-weight: 200;"><cf_tl id="Key task"> <cfoutput>#task#</cfoutput>: <cfif Parameter.MinTasks gte task><font color="FF0000">*</cfif></h2></td>
									   <cfoutput>
										   <td align="right" style="padding-right:0px; #vShowExtendedInfo#">
											    <table cellspacing="0" cellpadding="0">
												    <tr>							
													<td class="labelit" style="padding-left:20px;padding-right:4px"><cf_interface cde="Priority">#Name#:</td>
													<td>
												        <cfset pri = Activity.PriorityCode>
														<select name="PriorityCode_#task#" style="text-align: center;" class="regularxl">
														    
															<cfloop query="Priority">
															      <option value="#Code#" <cfif "#pri#" eq "#Code#">selected</cfif>>
																  #Description#
																  </option>
															</cfloop>
														</select>
													</td>
													<td class="labelit" style="padding-right:4px">&nbsp;&nbsp;&nbsp;<cf_interface cde="ActivityReference">#Name#:</td>						
													<td><input type="text" value="#Activity.reference#" name="Reference_#task#" size="10" maxlength="10" class="regularxl"></td>
													</tr>
												</table>						   				   
										   </td>
									   </cfoutput>
									   </tr>
								   </table>
								   
							   </td>
							   
		  				     </TR>
						   
						     <tr><td>
						       
							   <table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
							   																	  
							    <tr>
								
								<td style="padding-left:2px" colspan="2">
								
								<cfif Parameter.MinTasks gte task>
								
									<cf_interface cde="TaskError">
												
									<cfoutput>
																					
										<cf_textarea name="Description_#task#" 
										          toolbar  = "basic" 									  
		                                          height   = "300"
		                                          width    = "100%"
												  message  = "#Name#" 
												  required = "Yes" 									  
												  resize   = "0"
												  class    = "regularxl">#Activity.ActivityDescription#</cf_textarea>
												  
									</cfoutput>
									
									<cfelse>
									
										<cfoutput>
										
										<cf_textarea name="Description_#task#" 
									          toolbar   = "basic" 									  
											  message   = "#Name#" 
	                                          height   = "300"
	                                          width    = "100%"
											  resize    = "0"
											  required  = "Yes" 
											  class     = "regularxl">#Activity.ActivityDescription#</cf_textarea>
													  
										
										</cfoutput>
								
								</cfif>
								
								</td>
								</tr>
								
								<tr><td colspan="2" height="3"></td></tr>
								
								<cfoutput>
																		
								<tr>
								
							    <td class="regular" colspan="2">
								   	
									<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">	
									
									<cfset act = "#Activity.ActivityId#">
										
									<cfloop query="Class">
									
									    <tr>							  
										<td class="labelit" style="padding-left:4px;min-width:100px">#Description#</td>
										<td width="90%">
										
											<cfif Act neq "">
											
													<cfquery name="Out" 
											         datasource="AppsEPAS" 
													 username="#SESSION.login#" 
											         password="#SESSION.dbpw#">
											         	 SELECT *
												         FROM   ContractActivityOutput
														 WHERE  ContractId = '#URL.ContractId#'
														 AND    ActivityId = '#Act#'
														 AND    OutputClass = '#Code#'
													</cfquery>
												
												 	<input type="text" 
												       name="output_#task#_#code#" 
													   value="#Out.OutputDescription#" 													  
													   style="width:100%"
													   maxlength="100" 
													   class="regularxl"> 
														
											<cfelse>
											
													<input type="text" 
												       name="output_#task#_#code#" 
													   value="" 
													   style="width:100%"													  
													   maxlength="100" 
													   class="regularxl"> 
															
											</cfif>
													
										</td>
										</tr>
														
									</cfloop>
									
									</table>
											
								</td>	
								</TR>
								
								<cfif Parameter.HideTraining eq "0">
								
									  <cfquery name="Training" 
									     datasource="AppsEPAS" 
										 maxrows=1
									     username="#SESSION.login#" 
									     password="#SESSION.dbpw#">
									       SELECT *
									       FROM ContractTraining
										   WHERE ContractId = '#URL.ContractId#'
										   <cfif #Activity.ActivityId# neq "">
										   AND   ActivityId = '#Activity.ActivityId#'
										   <cfelse>
										   AND  ActivityId = '{00000000-0000-0000-0000-000000000000}'
										   </cfif>
									  </cfquery>
									  
									<tr>
									
										<td class="labelit"><cf_interface cde="TrainingHeader">&nbsp;&nbsp;&nbsp;#Name#:</td>
										<td colspan="1">
										  <input type="checkbox" 
										         onclick="training('b#task#',this.checked)" 
												 name="Training_#task#" 
												 value="1" <cfif #Training.Recordcount# neq "0">checked</cfif>>
									</tr>
									
									<cfif Training.Recordcount neq "0">
									  <cfset cl = "regular">
									<cfelse>  
									  <cfset cl = "hide">
									</cfif>  
													
									<tr id="b#task#" class="#cl#">
										<td></td>
										<td><cfinclude template="TrainingEntry.cfm"></td>
									</tr>							
															
								</cfif>	
															
								</cfoutput>
							   
							    </table>
							   	   
						   </cfloop>
					     
					</TABLE>
					
				</td>
				
				</tr>
			  
		  	</table>
			
			</td>
				
			</tr>
			  
		  </table>
		  
		  </td>
				
		 </tr>	  
		 			 
	  </table>
	  
	  </cf_divscroll>
	  	  
	  </td>
	  
	 </tr>
	  
	 <tr><td align="center" style="min-height:50px">
	  
	  <script>
		  	 initTextArea();	
		  </script>	
		  
		  <cfif getAdministrator("#workcontract.mission#") eq "1">
			  <cfset reset = "1">
		  <cfelse>
			  <cfset reset = "0">
		  </cfif>	
		  		 		   			
		  <cf_Navigation
			 Alias         = "AppsEPAS"
			 Object        = "Contract"
			 Group         = "Contract"
			 Section       = "#URL.Section#"
			 Id            = "#URL.ContractId#"
			 SetNext       = "0"
			 BackEnable    = "1"
			 HomeEnable    = "0"
			 ResetEnable   = "#reset#"
			 ResetDelete   = "0"	
			 ProcessEnable = "0"			 
			 SaveSubmit    = "1"
			 NextEnable    = "1"
			 NextMode      = "1"
			 NextSubmit    = "1"			 
			 NextName      = "Save and Next">			 			 
	  
	  </td></tr>
	  
	  </table>
	 
	</CFFORM>
	

</cfif>

<script>
	parent.Prosis.busy('no')
</script>
