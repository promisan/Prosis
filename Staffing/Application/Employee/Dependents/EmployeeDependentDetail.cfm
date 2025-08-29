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
<cfparam name="url.status" default="valid">
<cfparam name="url.webapp" default="">
<cfparam name="url.contractid" default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.scope" default="backOffice">

<!--- Query returning search results --->
<cfquery name="Search" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT   *, 
	         
	         (SELECT TOP 1 ObjectId 
			  FROM   Organization.dbo.OrganizationObject
			  WHERE  (Objectid = L.DependentId OR ObjectKeyValue4 = L.DependentId)
			  AND    EntityCode = 'Dependent'
			  AND    Operational = 1) as WorkflowId,
			  
			 Rel.Description as RelDescription
			 
    FROM     PersonDependent L,
	         Ref_Beneficiary R, 
			 Ref_Relationship Rel
	WHERE    L.Beneficiary  = R.Code
	AND 	 L.Relationship = Rel.Relationship
	AND      L.PersonNo     = '#URL.ID#' 
	<cfif url.scope neq "backoffice">
	AND      L.Operational = 1
	</cfif>
	<cfif url.status neq "all">
	AND      L.ActionStatus != '9'
	</cfif>
	ORDER BY L.BirthDate, L.DateEffective, L.Relationship
</cfquery>

<cfinvoke component="Service.Access"  
    	  method="contract"  
		  personno="#URL.ID#" 
		  returnvariable="access">
	
<cfquery name = "hasContract"
	datasource = "AppsEmployee"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   PersonContract
	WHERE  PersonNo = '#URL.ID#' 
	AND    ActionStatus != '9'
</cfquery>	

<cfquery name = "openContract"
	datasource = "AppsEmployee"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   PersonContract
	WHERE  PersonNo = '#URL.ID#' 
	AND    ActionStatus = '0'
</cfquery>	


<cfif openContract.recordcount eq "1" and hasContract.recordcount gte "1">
	<cfset openContract = "1">
<cfelse>
	<cfset openContract = "0">	
</cfif>

<cfif hasContract.recordcount eq 0 >
	<cfset access = "ALL">
</cfif>
		
<table style="min-width:800px" width="100%">
 
   <tr class="line">
   
   <td colspan="6">
   
   <table style="min-width:800px" width="100%"><tr>
    
	<cfif url.action eq "Person">
	  
	    <td height="20">
		
		<table width="100%">
		<tr>
		<td>
		
		   <cfif url.scope eq "portal">	
		        <img src="<cfoutput>#session.root#/Images/Dependent.png</cfoutput>" style="height:65px;float:left;">
    	   		<h1 style="float:left;color:#333333;font-size:28px;font-weight:200">Dependent <strong> Entitlements</strong></h1>			        	
        		<p style="clear: both; font-size: 15px; margin: 1% 0 0 1%;">Review your declared dependents and the entitlements that affect your monthly payroll.</p>
        		<div class="emptyspace" style="height: 40px;"></div>
			<cfelse>
				<img src="<cfoutput>#session.root#/Images/Dependent.png</cfoutput>" style="height:65px;float:left;">
    	   		<h1 style="float:left;color:#333333;font-size:22px;font-weight:200;padding-top:22px;">Dependent <strong> Entitlements</strong></h1>		
			</cfif>            
		</td>
		
		<td>&nbsp;</td>
		
		<cfoutput>
		
		<cfif url.webapp eq "">
		
			<cfif url.action neq "contract">
			
				<cfif url.status eq "valid">
					 
				     <td valign="bottom" align="right" class="labelmedium2">
					 <a href="javascript:dependentshow('#url.id#','all','#url.action#')">[Show ALL records]</a>
					 </td>
				 
				<cfelse>
				 
				 	<td valign="bottom" align="right" class="labelmedium2">
					 <a href="javascript:dependentshow('#url.id#','valid','#url.action#')">[HIDE Superseded records]</a>
				    </td>
					 
				</cfif>
			
			</cfif>
		
		</cfif>
		
		</cfoutput>
		
		</tr>
		</table>
		</td>
	
	<cfelse>
		
	    <td style="font-size:20px" class="labellarge">
		
			 <cfif url.scope eq "portal">				 
			 
        		<img src="<cfoutput>#session.root#/Images/Dependent.png</cfoutput>" style="height:65px;float:left;">
        		<h1 style="float:left;color:#333333;font-size:28px;font-weight:200;padding-top:20px;">Dependent <strong> Entitlements</strong></h1>
        		
        			<p style="clear: both; font-size: 15px; margin: 1% 0 0 1%;">
	        			Check and print the details of your monthly payments, deductions and benefits.
        			</p>
        			<div class="emptyspace" style="height: 40px;"></div>
        	  
				
			<cfelse>
							
        		<h1 style="color:#333333;font-size:20px;font-weight:200">Dependent <strong> Entitlements</strong></h1>        		
			
			</cfif>	
        
            </td>
	
	</cfif>
	
	<cfoutput>	
		 	
	<td align="right" style="padding-top:5px;font-size:15px;padding-right:5px">
	
		    <cfif url.webapp eq "">
		
				<cfif access eq "EDIT" or access eq "ALL">			
	
				<cf_tl id="Add Dependent" var="1">	
									
					<cfif url.action eq "contract">		
						   
					   <cfif url.contractid neq ""> 
						   <a href="javascript:dependent('#URL.ID#','#url.action#','#url.contractid#')">#lt_text#</a>									
					   </cfif>
					   
					<cfelse>
					
					   <a href="javascript:dependent('#URL.ID#','#url.action#')">#lt_text#</a>				
					   
					</cfif>
				</cfif>		
			
			</cfif>
			
	    </td>
		
	</cfoutput>
	
	</tr></table>
	
   </td>
	
  </tr>
  
<cfif openContract eq "1" and url.action eq "Person">
	<tr class="line"><td align="center" style="height:30px" class="labellarge" colspan="2"><font color="red"><cf_tl id="There is a contract pending review"></td></tr>
</cfif>
   
<tr>

  <td width="100%" colspan="2">
  <table width="100%" class="navigation_table">
	
<TR class="labelmedium2 line fixlengthlist">
    <td height="20"></td>
    <td></td>
    <td colspan="2"><cf_tl id="Relation"></td>	
	<TD><cf_tl id="S"></TD>
    <TD><cf_tl id="DOB"></TD>
	<TD><cf_tl id="Beneficiary"></TD>
	<TD><cf_tl id="Action"></TD>
	<TD><cf_tl id="Officer"></TD>
	<TD><cf_tl id="Source"></TD>
	<TD><cf_tl id="Effective"></TD>
	<td><cf_tl id="Status"></td>
</TR>

<cfset last = '1'>

<cfif search.recordcount eq "0">
	<tr><td colspan="11" class="labelmedium2" align="center" style="padding-top:10px;font-weight:300"><font color="808080"><cf_tl id="There are no records to be shown in this view">.</td></tr>
</cfif>

<cfoutput query="Search">
	
	<cfif actionstatus eq "9">
		<cfset color = "e6e6e6">
	<cfelse>
		<cfset color = "white">
	</cfif>
	
	<tr bgcolor="#color#" class="navigation_row labelmedium2 line fixlengthlist">
	
	     <td height="20" align="center" style="padding-left:4px;cursor:pointer" onclick="workflowdrilldependent('#dependentid#','box_#dependentid#')" >
		 
		  <cfif opencontract eq "0" and url.action eq "person">
				
			  <cfif workflowid neq "" and url.action eq "person"> <!--- if opened from the contract point of view do not show --->
			
				  	<cfif actionStatus eq "0" or actionstatus eq "1">
													
						 <img name="exp#WorkflowId#" id="exp#WorkflowId#" 
						     class="hide" 
							 src="#SESSION.root#/Images/arrowright.gif" 
							 align="absmiddle" 
							 alt="Expand" 
							 height="10"
							 width="10"			
							 border="0"> 	
										 
					   <img name="col#WorkflowId#" id="col#WorkflowId#" 
						     class="regular" 
							 src="#SESSION.root#/Images/arrowdown.gif" 
							 align="absmiddle" 
							 height="10"
							 width="10"
							 alt="Hide" 			
							 border="0"> 
							 
					<cfelse>
																								
					   <img name="exp#WorkflowId#" id="exp#WorkflowId#" 
						     class="regular" 
							 src="#SESSION.root#/Images/arrowright.gif" 
							 align="absmiddle" 
							 alt="Expand" 
							 height="10"
							 width="10"			
							 border="0"> 	
										 
					   <img name="col#WorkflowId#" id="col#WorkflowId#" 
						     class="hide" 
							 src="#SESSION.root#/Images/arrowdown.gif" 
							 align="absmiddle" 
							 height="10"
							 width="10"
							 alt="Hide" 			
							 border="0"> 			
					
					</cfif>			 
					 
				</cfif>	 
			
			</cfif> 
		 		 
		</td>
						
		<td style="padding-top:1px">		
				
		   <cfset editmode = "0">
		    	   
			<cfif url.webapp eq "">
																
			    <cfif url.action eq "contract">			
																			
					<!--- check if this dependent record is part of the	contract processing --->			
					
					<cfquery name="getAction" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						 SELECT  *
				         FROM    EmployeeAction 
				    	 WHERE   ActionSourceId = '#url.contractid#'
					</cfquery>							
								
					<cfif getAction.recordcount eq "1">
															
						<cfquery name="Associated" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT  *
							FROM    EmployeeActionSource
							WHERE   ActionDocumentNo = '#getAction.ActionDocumentNo#'			
							AND     ActionSourceId   = '#dependentid#'
						</cfquery>
																																				
						<cfif associated.recordcount eq "1">
																														
						     <!--- it is linked --->
							 
							 <table>
							 <tr>
																		
							 <cfif ActionStatus neq "9">	
																					 								
								<cfif access eq "EDIT" or access eq "ALL">
								
								   <td style="padding-left:2px;padding-top:2px">
								   	<cf_img icon="open" navigation="Yes" onclick="dependentedit('#URL.ID#','#DependentId#','#url.action#','#url.contractid#')">
								   </td>																	
								   <cfset editmode = "1">
									
								</cfif>	
								
							</cfif>
							
							 <td><img src="#SESSION.root#/images/link.gif" alt="Associated to this action" align="absmiddle" border="0"></td>
							
							</tr>
							</table>
							
						<cfelse>
						
						     <table><tr><td>
							 
							  <cfif ActionStatus neq "9">	
								
								<cfif getAdministrator("#hasContract.Mission#") or access eq "EDIT" or access eq "ALL">
								
								   <td style="padding-left:2px">
								   	<cf_img icon="open" navigation="Yes" onclick="dependentedit('#URL.ID#','#DependentId#','#url.action#','#url.contractid#')">
								   </td>																	
								   <cfset editmode = "1">
									
								</cfif>	
								
							</cfif>
							 
							</td></tr></table>
										 
						</cfif>
					
					</cfif>	
				
				<cfelse>				
			
				    <cfif ActionStatus neq "9">	
					
						<cfquery name="getContractAction" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							 SELECT  *
					         FROM    EmployeeActionSource 
					    	 WHERE   ActionSourceId = '#dependentid#'
							 AND     ActionDocumentNo IN (SELECT ActionDocumentNo 
							                              FROM   EmployeeAction EA
														  WHERE  ActionSource = 'Contract'
														  AND    ActionSourceId IN (SELECT ContractId
														                            FROM   PersonContract 
																					WHERE  ContractId = EA.ActionSourceId 
																					AND    ActionStatus = '0'))
						</cfquery>													
					
					    <cfif (ActionStatus eq "0" or ActionStatus eq "5") and getContractAction.recordcount gte "1">
					   
					   		 <!--- it is linked --->
						    <img src="#SESSION.root#/images/link.gif" alt="Associated to a contract" align="absmiddle" border="0">
						
						<cfelse>
																	
						<cfif access eq "EDIT" or access eq "ALL">
						
							<cfif (opencontract eq "0" and url.action eq "person") or url.action eq "contract">
																		
								 <cf_img icon="open" navigation="Yes"  onclick="dependentedit('#URL.ID#','#DependentId#','#url.action#','')">
								 
							 <cfelse>
							 	 
							 	 <cfset editmode = "0">
							 
							 </cfif>
														
						</cfif>																
						
						
						</cfif>
						
					</cfif>
				
				</cfif>
				
		  </cfif>	
			
		</td>	
		<td colspan="2" style="font-size:16px">
		    
		    <cfif editmode eq "1">
			<a href="javascript:dependentedit('#URL.ID#','#DependentId#','#url.action#','#url.contractid#')"><font size="2" color="408080">#RelDescription#</font></a>: #FirstName# #LastName#
			<cfelse>
			#FirstName# #LastName#	<font size="2" color="800080">#RelDescription#</font>
			</cfif>
			
		</td>
		
		<TD>#Gender#</TD>
		<TD>#Dateformat(BirthDate, CLIENT.DateFormatShow)# (#datediff("yyyy",BirthDate,now())#)</TD>
		<td>#Description#</td>
		<TD>
		
		<cfquery name = "Action"
			datasource = "AppsEmployee"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT DISTINCT ActionDocumentNo
			FROM (
			SELECT ActionDocumentNo 
			FROM   EmployeeAction
			WHERE  ActionSourceId = '#DependentId#'	
			UNION
			SELECT EA.ActionDocumentNo 
			FROM   EmployeeAction EA INNER JOIN EmployeeActionSource EAS ON EA.ActionDocumentNo = EAS.ActionDocumentNo
			WHERE  EAS.ActionSourceId = '#DependentId#'
			) as Base				
		</cfquery>
		
		<cfloop query="Action">
		    <cfif url.scope eq "backoffice">		    
			<a href="javascript:padialog('#Actiondocumentno#')">#ActionDocumentNo#</a><cfif recordcount neq currentrow>;</cfif>
			<cfelse>
			#ActionDocumentNo#<cfif recordcount neq currentrow>;</cfif>
			</cfif>
		</cfloop>
				
		</TD>
		<td>#OfficerLastName#</td>
		<td>#Source#</td>
		<TD><cfif DateEffective neq "">#Dateformat(DateEffective, CLIENT.DateFormatShow)#<cfelse>#Dateformat(Created, CLIENT.DateFormatShow)#</cfif></TD>
			
		<cfif actionStatus eq "9">
			<td id="status_#dependentid#" align="center" style="border:1px solid silver;background-color:##ff000080"><cf_tl id="Inactive"></td>	
		<cfelseif actionstatus eq "0">
		<td id="status_#dependentid#" align="center" style="border:1px solid silver;border-right:0px;background-color:##ffffaf80"><cf_tl id="Pending"></td>
		<cfelseif actionstatus eq "1">
		<td id="status_#dependentid#" align="center" style="border:1px solid silver;border-right:0px;background-color:##e1e1e180"><cf_tl id="In Process"></td>		
		<cfelse>
		<td id="status_#dependentid#" align="center" style="border:1px solid silver;border-right:0px;background-color:##80E38280"><cf_tl id="Cleared"></td>	
		</cfif>		
		
	</tr>
		
		<cfif len(remarks) gte "15">
		<tr bgcolor="#color#">
		    <td></td>			
			<td></td>
		    <TD colspan="10" class="labelit">#Remarks#</font></TD>
		</tr> 		
	    </cfif>
					
		<cfquery name="Parameter" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT   *
		    FROM     Parameter	
		</cfquery>
		
		<cf_verifyOperational 
		         module    = "Payroll" 
				 Warning   = "No">				 
				 
			<cfif operational eq "1" or Parameter.DependentEntitlement eq "1">	 
			
				<cfif url.action eq "Person" and actionstatus eq "0">
					<tr class="fixlengthlist" style="height:20px"><td></td><td></td><td class="line" colspan="10"><font color="red"><cf_tl id="Record record is not considered for payroll until approved"></td></tr>
				</cfif>
				
				<!--- Query returning search results --->
				<cfquery name="SearchLine" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT 'Dependent Entitlement' as Class,*
				    FROM   PersonDependentEntitlement L, 
					       Ref_PayrollTrigger R
					WHERE  L.PersonNo = '#URL.ID#' 
					AND    L.SalaryTrigger = R.SalaryTrigger
					AND    L.DependentId = '#Search.DependentId#'  
					AND    ParentEntitlementId is NULL
					<cfif url.status neq "all">
					AND    L.Status != '9'
					</cfif>
					
					UNION
					
					SELECT 'Counter for Staff Entitlement' as Class, *
				    FROM   PersonDependentEntitlement L, 
					       Ref_PayrollTrigger R
					WHERE  L.PersonNo = '#URL.ID#' 
					AND    L.SalaryTrigger = R.SalaryTrigger
					AND    L.DependentId = '#Search.DependentId#'  
					AND    ParentEntitlementId IN (SELECT EntitlementId FROM PersonEntitlement WHERE Status != '9')
					<cfif url.status neq "all">
					AND    L.Status != '9'
					</cfif>					
					
					ORDER BY Class,L.SalaryTrigger,L.DateEffective,ParentEntitlementId
				</cfquery>
				
				<cfif SearchLine.RecordCount gt 0>
								
					<tr class="navigation_row_child" bgcolor="#color#">
				
					<td></td>				
					<td valign="top" align="left"></td>
					<td colspan="12" style="padding:2px;padding-right:0px">
				
					<cfif actionstatus eq "9">
					
					<table width="98%" bgcolor="f4f4f4" style="border:1px solid silver;padding:bottom:2px">
					
					<cfelse>
					
					<table width="98%" bgcolor="ffffcf" style="border:1px solid silver;padding:bottom:2px">
								
					</cfif>
					
					<cfset act = actionStatus>
					<cfset prior = "">
									   
					<cfloop query="SearchLine">
						
							<cfif class neq prior>							
						<!---	<tr class="labelit line" bgcolor="ffffff"><td colspan="9">#class#</td></tr> --->
							<cfset prior = class>							
							</cfif>
																		
							   <tr class="line labelmedium" style="height:20px;">
							   
							   		 <cfif act neq "9">
								       <!--- if actionstatus is 0, then it needs to be approved, if it is 1 then the entitlement counts for payroll --->
									   
								       <cfif url.action eq "contract">						    
									   
										   <cfif Status eq "0">		
											   <td width="10%" align="center" style="border-right:1px solid silver;background-color:yellow"><cf_tl id="In Process"></td>
										   <cfelse>
										       <td width="10%" align="center" style="border-right:1px solid silver;"></td>
										   </cfif>
																	   
									   <cfelse>
									   
										   <cfif Status eq "2">									   
										   <td width="10%" align="center" style="border-right:1px solid silver;background-color:##80E382"><cf_tl id="Cleared"></td>
										   <cfelseif Status eq "1">   
										     <td width="10%" align="center" style="border-right:1px solid silver;background-color:yellow"><cf_tl id="In Process"></td>									   
										   <cfelse>
										    <td width="10%" align="center" style="border-right:1px solid silver;background-color:yellow"><cf_tl id="Pending"></td> 									   
										   </cfif>
									   </cfif>	
									   
								   <cfelse>
								   		 <td width="10%" style="border-left:1px solid silver;background-color:red"></td>     
								   </cfif>
								   <td style="width:20px" align="center"><cfif ParentEntitlementId neq "">*</cfif></td>
								   <td width="40%" style="padding-left:7px">#Description# <cfif TriggerGroup eq "Insurance" and EntitlementSubsidy eq "1">(<cf_tl id="Subsidy">)
								   <cfelseif  TriggerGroup eq "Insurance"><font style="text-decoration: line-through;" color="FF0000">(<cf_tl id="subsidy">)</cfif></td>
								   
								   <cfif ParentEntitlementId neq "">							   
								   
								   		<!--- added 24/10 after Rudi observation --->
									   <TD width="8%" align="center">#Dateformat(DateEffective, CLIENT.DateFormatShow)#</TD>
									   <TD width="10%" align="center" style="min-width:90px;padding-right:4px">
										   <cfif DateExpiration neq "">
										   #Dateformat(DateExpiration, CLIENT.DateFormatShow)#
										   <cfelse>
										   <font color="808080"><i><cf_tl id="Contract end">
										   </cfif>
									   </TD>
									   <TD colspan="2" style="min-width:10%">#EntitlementGroup#</TD> 								
										
								   <cfelse>		
								   					   
									   <TD width="8%" align="center">#Dateformat(DateEffective, CLIENT.DateFormatShow)#</TD>
									   <TD width="10%" align="center" style="min-width:90px;padding-right:4px">
										   <cfif DateExpiration neq "">
										   #Dateformat(DateExpiration, CLIENT.DateFormatShow)#
										   <cfelse>
										   <font color="808080"><i><cf_tl id="Contract end">
										   </cfif>
									   </TD>
									   <TD colspan="2" style="min-width:10%">#EntitlementGroup#</TD>
									   				   
								   
								   </cfif>	  
								   
								   <td align="right" style="min-width:250px;padding-right:5px" width="25%">#OfficerLastName# #dateformat(Created,client.dateformatshow)#</td>	
								   								   
							   </tr>
						
					</cfloop>
					
					</table>
				
				</td></tr>
				
				<cfif remarks neq "">
				
				   <tr class="navigation_row_child labelmedium" bgcolor="#color#"><td></td>
				       <td></td>
				       <td colspan="11">#SearchLine.Remarks#</td>
				   </tr> 	
				   		
				</cfif>				
				
			</cfif>
				
		</cfif>		
						
		<cfif url.action eq "person" and workflowid neq "">		
			
			<input type  = "hidden" 
			       name  = "workflowlink_#dependentid#" 
			       id    = "workflowlink_#dependentid#" 				   
			       value = "#SESSION.root#/staffing/application/employee/dependents/EmployeeDependentWorkflow.cfm">	
				   
			<input type="hidden" 
			   	   name="workflowlinkprocess_#dependentid#" id="workflowlinkprocess_#dependentid#" 
			       onclick="ptoken.navigate('setDependentStatus.cfm?id=#dependentid#','status_#dependentid#')">		    				   
		
			<cfif ActionStatus eq "0" or ActionStatus eq "1">
			
				<tr id="box_#dependentid#" class="navigation_row_child">
				<td colspan="2"></td>
				<td colspan="11" id="#dependentid#">
			
					<cfset url.ajaxid = dependentid>
					<cfinclude template="EmployeeDependentWorkflow.cfm">
				
				</td></tr>
				
			<cfelse>
			
				<tr id="box_#dependentid#" class="hide">
				<td colspan="2"></td>
				<td colspan="11" id="#dependentid#"></td></tr>
			
			</cfif>		
			  	
		</cfif>
		
</cfoutput>

</TABLE>

</td></tr>

</table>

<cfset AjaxOnLoad("doHighlight")>	