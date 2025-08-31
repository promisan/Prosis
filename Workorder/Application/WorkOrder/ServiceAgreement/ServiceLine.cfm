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
<cfparam name="URL.workorderid" default="">	
<cfparam name="URL.search"      default="">
<cfparam name="box"             default="">
<cfparam name="url.page"        default="1">

<cfquery name="WorkOrder" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  WorkOrder
	WHERE WorkorderId = '#URL.WorkOrderId#'	
</cfquery>

<cfquery name="Parameter" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_ParameterMission
	WHERE Mission = '#WorkOrder.Mission#'	
</cfquery>

<cfquery name="Customer" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Customer
	WHERE CustomerId = '#workorder.customerid#'	
</cfquery>

<!--- define access --->

<cfinvoke component = "Service.Access"  
	   method           = "WorkorderProcessor" 
	   mission          = "#workorder.mission#"	  
	   serviceitem      = "#workorder.serviceitem#"
	   returnvariable   = "access">	
	   
<cfquery name="Service" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  ServiceItem
	WHERE Code = '#WorkOrder.Serviceitem#'	
</cfquery>

<cfquery name="CurrencyList" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Currency	
</cfquery>
	
<cfoutput>
	<cfsavecontent variable="qry">		
	    FROM    WorkOrderBaseLine WO 		      
	    WHERE   WO.WorkOrderId = '#url.workorderid#'
	    <cfif url.search neq "">
	    AND     WO.TransactionReference LIKE '%#url.search#%' 	
	    </cfif>	    		
	</cfsavecontent>
</cfoutput>

<cfquery name="Total" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT count(*) as Total 
    #preserveSingleQuotes(qry)#	
</cfquery>

<cf_pagecountN show="33" 
               count="#Total.Total#">
			   
<cfset counted  = total.total>		

<cfquery name="Detail" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT TOP #last# WO.*				
    #preserveSingleQuotes(qry)#		
	ORDER BY DateEffective DESC
</cfquery>

<cfset prior = "0">

<cf_divscroll>
	
<table width="100%" border="0" class="formpadding" cellpadding="0" align="center">
	
	<cfset cols = "10">
				      
	<tr>
	
	    <td style="width:99%" colspan="4" align="center">
					  
		    <table width="99%" border="0" cellspacing="0" cellpadding="0" class="navigation_table">
					
		    <TR class="line labelmedium">
			   
			   <td height="20"></td>
			   <td></td>
			   <td width="16%"><cf_tl id="Reference"><cf_space spaces="46"></td>		
			   <td width="100"><cf_space spaces="26"><cf_tl id="Effective"></td>  
			   <td width="100"><cf_space spaces="26"><cf_tl id="Expiration"></td>
			   <td width="80"><cf_tl id="Status"></td>		    
			   <td width="60%"><cf_tl id="Memo"></td>			   	  		   
			  
			   <cfoutput>
			       <td width="10%" align="right"><cf+tl id="Amount"> #APPLICATION.BaseCurrency#</td>
			   </cfoutput>
			   		  
			   <td align="right" width="7%" colspan="2" class="labellarge">		         
				 <cfoutput>									 
				   <cfif access eq "EDIT" or access eq "ALL">
				     <a href="javascript:agreement('#url.tabno#','#URL.WorkOrderId#','')"><font  size="2" color="0080FF">[<cf_tl id="add"> <cf_tl id="SLA">]</font></a>
				   </cfif>								
				 </cfoutput>				 
			   </td>		
			     
		    </TR>	
				
			<cfoutput>
					
			    <tr><td colspan="#cols#" class="line"></td></tr>		
					
				<tr class="line">
				    <td height="20" colspan="#cols#">			
					 <cfinclude template="ServiceLineNavigation.cfm">
				    </td>
				</tr>			
					
			<cfset currrow = 0>		
								
			<cfloop query="Detail">
			
				<cfset currrow = currrow + 1>
			 
			    <cfif currrow lt last and currrow gte first>	
								
				    <!--- check for active workflow --->  
	   		        <cf_wfActive entitycode="WrkAgreement" objectkeyvalue4="#transactionid#">							
				   									
					<TR class="navigation_row labelmedium line" id="agreementline#currentrow#">		
					   				   
						 <td height="20" width="20"
						    align="center" 
							style="cursor:pointer" 
							onclick="agreementworkflow('#transactionid#','box_#transactionid#')" >
							
							<cf_space spaces="10">
					   
					        <cfif wfexist eq "1">		
					 				 
							 	 <cfif wfstatus eq "open" and prior eq "0">
								
									 <img id="exp#transactionid#" 
								     class="hide" 
									 src="#SESSION.root#/Images/arrowright.gif" 
									 align="absmiddle" 
									 alt="Expand" 
									 height="9"
									 width="7"			
									 border="0"> 	
													 
								     <img id="col#transactionid#" 
								     class="regular" 
									 src="#SESSION.root#/Images/arrowdown.gif" 
									 align="absmiddle" 
									 height="10"
									 width="9"
									 alt="Hide" 			
									 border="0"> 
								
								<cfelse>
								
									<img id="exp#transactionid#" 
								     class="regular" 
									 src="#SESSION.root#/Images/arrowright.gif" 
									 align="absmiddle" 
									 alt="Expand" 
									 height="9"
									 width="7"			
									 border="0"> 	
													 
								    <img id="col#transactionid#" 
								     class="hide" 
									 src="#SESSION.root#/Images/arrowdown.gif" 
									 align="absmiddle" 
									 height="10"
									 width="9"
									 alt="Hide" 			
									 border="0"> 
								
								</cfif>
																		  
					   </cfif>	 
					   				   
					   </td>
					   
					   <td height="20"
					       style="font-size: 8px;padding-right:20px">#currentrow#.</td>								   
					   <td style="padding-right:9px">#TransactionReference#</td>
					   <td>#dateformat(DateEffective,CLIENT.DateFormatShow)#</td>
					   <td>#dateformat(DateExpiration,CLIENT.DateFormatShow)#</td>
					   <td>
					   
					   	<cf_space spaces="38">							
					    <cfdiv bind="url:../ServiceAgreement/ServiceLineStatus.cfm?transactionid=#transactionid#"
						       id="#transactionid#_status">
						
					   </td>
					   <td>#TransactionMemo#</td>				  
					  
					   <td align="right">
										   									   
							<cfquery name="Total" 
							datasource="AppsWorkOrder" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
									SELECT  sum(Amount) as Amount
								    FROM    WorkOrderBaseLineDetail 		      
								    WHERE   TransactionId = '#transactionid#'						  
							</cfquery>				   						   
						   #numberformat(Total.Amount,",.__")#
						   
					   </td>
					 
					   <td align="right" width="30">		
					   
					   		<cf_space spaces="8">							
					   		<cfif (access eq "EDIT" or access eq "ALL") and actionStatus eq "0">   							
								<cf_img icon="edit" onclick="agreement('#url.tabno#','#URL.WorkOrderId#','#transactionid#')">										
							</cfif>				 
										 
					   </td>
					   
					   <td align="left" style="padding-left:4px" width="30" id="agreementdelete#currentrow#">
					   
					   		<cf_space spaces="8">							
					   		<cfif access eq "ALL" and actionStatus eq "0"> 							
								<cf_img icon="delete"  onclick="agreementpurge('#currentrow#','#URL.workorderid#','#transactionid#')">														  
							 </cfif> 
								 
					  </td>				  
					 				   
				    </TR>	
					
					<cfquery name="Funding" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT  TOP 1 *
						FROM    Ref_Funding										
					</cfquery>
					
					<cfquery name="Funds" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT  *
						FROM    WorkOrderFunding
						WHERE   WorkorderId = '#url.workorderid#'
						AND     WorkorderLine is NULL							
					</cfquery>
					
					<cfif Funding.recordcount eq "0" and Funds.recordcount gte "1">	
						<tr>
						    <td></td><td></td><td colspan="8" height="25" align="center" style="border:1px dotted silver">								
							<font face="Verdana" color="FF0000"><cf_tl id="Problem there is no funding defined on the workorder level" class="message"></font>								
							</td>
						</tr>	
						<tr><td height="5"></td></tr>		
							
					</cfif>
										
					<tr id="agreementline0#currentrow#">				
						    <td></td><td></td><td></td>		
							<td colspan="5" style="padding-left:4px">								
												
									<cfquery name="FinalDetail" 
									datasource="AppsWorkOrder" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										SELECT   R.UnitDescription, D.Quantity, D.Rate, D.Amount
										FROM     WorkOrderBaseLineDetail D INNER JOIN
										         ServiceItemUnit R ON D.ServiceItem = R.ServiceItem AND D.ServiceItemUnit = R.Unit
										WHERE    TransactionId = '#TransactionId#'
										ORDER BY ListingOrder
									</cfquery>
								
									<table width="540" cellspacing="0" cellpadding="0" bgcolor="FFFFEF" class="formpadding">
									
										<cfloop query="FinalDetail">
											<tr class="labelmedium line">
											    <td style="padding-left:2px">#unitDescription#</td>
											    <td align="right" style="padding-left:2px">#numberformat(quantity,"__,__")#</td>
												<td align="right" style="padding-left:2px">#numberformat(rate,",.__")#</td>
												<td align="right" style="padding-left:2px;padding-right:5px">#numberformat(amount,",.__")#</td>				
											</tr>
										</cfloop>
									
									</table>									
							</td>
					</tr>
						
										
					<tr  id="agreementline1#currentrow#">	
					    <td></td>
				   		<td></td>					
				        <td colspan="#cols-3#" style="padding-left:4px">						
											
							<cfif access eq "EDIT" or access eq "ALL">   
					   
						   		<cf_filelibraryN
							    	DocumentHost="#parameter.documenthost#"
									DocumentPath="#parameter.documentLibrary#"
									SubDirectory="#url.workorderid#" 
									box="agree#currentrow#"
									loadscript="no"
									Filter="#left(transactionid,8)#"						
									Insert="yes"
									Remove="yes"
									reload="true">		
								
							<cfelse>
							
								<cf_filelibraryN
							    	DocumentHost="#parameter.documenthost#"
									DocumentPath="#parameter.documentLibrary#"
									SubDirectory="#url.workorderid#" 
									box="agree#currentrow#"
									loadscript="no"
									Filter="#left(transactionid,8)#"						
									Insert="no"
									Remove="no"
									reload="true">							
							
							</cfif>	
				  
				        </td>
			    </tr>	
											
				<tr><td height="2"></td></tr>
				
				<tr id="boxdetail#currentrow#" class="hide">
				   <td></td>
				   <td></td>
				   <td colspan="#cols-2#" id="detail#currentrow#">			
				    <!--- show usage ?? --->				
				   </td>
			    </tr>
				
				<input type="hidden" 
			      name="workflowlink_#transactionid#" 
	              id="workflowlink_#transactionid#"
			      value="../serviceagreement/servicelineWorkflow.cfm">			   
			  		  
			    <input type="hidden" 
			      name="workflowlinkprocess_#transactionid#" 
	              id="workflowlinkprocess_#transactionid#"
			      onclick="ColdFusion.navigate('../serviceagreement/servicelinestatus.cfm?transactionid=#transactionid#','#transactionid#_status')">		   		   
			   							   			
				<cfif wfstatus eq "open" and prior eq "0">
				
					<tr id="box_#transactionid#">
					<td></td>
					<td></td>
					<td colspan="#cols-3#" id="#transactionid#">
										
						<cfset url.ajaxid = transactionid>
						<cfinclude template="ServiceLineWorkflow.cfm">
						
						<cfset prior = "1">
															
					</td></tr>		
				
				<cfelse>
				
					<tr id="box_#transactionid#" class="hide">		
						<td></td>	
						<td></td>	
						<td colspan="#cols-3#" id="#transactionid#"></td>
					</tr>		
				
				</cfif>
				
				<tr class="line"><td colspan="10" height="4"></td></tr>
				
				</cfif>	
												
			</cfloop>		
						
			<tr class="line" style="border-top:1px solid silver"><td height="24" colspan="#cols#">
				 <cfinclude template="ServiceLineNavigation.cfm">
			</td></tr>	
			
			</cfoutput>			
															
			</table>
			
		</td>
		</tr>		
					
	</table>	
	
	</cf_divscroll>
	
	<cfset ajaxonload("doHighlight")>