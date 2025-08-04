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
	    FROM    WorkOrderEvent WO 		      
	    WHERE   WO.WorkOrderId = '#url.workorderid#'
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
</cfquery>

<cfset prior = "0">

<cf_divscroll>
	
<table width="100%" border="0" class="formpadding" cellpadding="0" align="center">
	
	<cfset cols = "10">
				      
	<tr>
	
	    <td style="width:99%" colspan="4" align="center">
					  
		    <table width="99%" border="0" cellspacing="0" cellpadding="0" class="navigation_table">
					
		    <TR>
			   
			   <td width="2%" height="20"></td>
			   <td width="2%"></td>
			   <td width="16%" class="labelit"><cf_tl id="Reference"></td>		
			   <td width="100" class="labelit"><cf_space spaces="26"><cf_tl id="Effective"></td>   	  		   
			   		  
			   <td align="right" class="labelit">
		         
				 <cfoutput>
									 
				   <cfif access eq "EDIT" or access eq "ALL">
				     <A href="javascript:workflowevents('#url.tabno#','#URL.WorkOrderId#','')"><font size="2" color="0080FF">[<cf_tl id="add">]</font></a>
				   </cfif>
								
				 </cfoutput>
				 
			   </td>		  
		    </TR>	
				
			<cfoutput>
					
			    <tr><td colspan="#cols#" class="line"></td></tr>		
					
					
			<cfset currrow = 0>		
								
			<cfloop query="Detail">
			
				<cfset currrow = currrow + 1>
			 
			    <cfif currrow lt last and currrow gte first>	
								
				    <!--- check for active workflow --->  
	   		        <cf_wfActive entitycode="WrkEvent" objectkeyvalue4="#WorkOrderEventId#">					
				
					<tr><td colspan="#cols#" class="line"></td></tr>				
				   									
					<TR class="navigation_row" id="eventline#currentrow#">		   
					
						 <td height="20" width="20"
						    align="center" 
							style="cursor:pointer" 
							onclick="eventworkflow('#workordereventid#','box_#workordereventid#')" >
							
							<cf_space spaces="10">
					   
					        <cfif wfexist eq "1">		
					 				 
							 	 <cfif wfstatus eq "open" and prior eq "0">
								
									 <img id="exp#workordereventid#" 
								     class="hide" 
									 src="#SESSION.root#/Images/arrowright.gif" 
									 align="absmiddle" 
									 alt="Expand" 
									 height="9"
									 width="7"			
									 border="0"> 	
													 
								     <img id="col#workordereventid#" 
								     class="regular" 
									 src="#SESSION.root#/Images/arrowdown.gif" 
									 align="absmiddle" 
									 height="10"
									 width="9"
									 alt="Hide" 			
									 border="0"> 
								
								<cfelse>
								
									<img id="exp#workordereventid#" 
								     class="regular" 
									 src="#SESSION.root#/Images/arrowright.gif" 
									 align="absmiddle" 
									 alt="Expand" 
									 height="9"
									 width="7"			
									 border="0"> 	
													 
								    <img id="col#workordereventid#" 
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
						   
					   <td style="padding-right:9px"><font face="Verdana" size="2" color="6688aa"><b>#EventReference#</td>
					   <td>#dateformat(EventDate,CLIENT.DateFormatShow)#</td>
					   <td>
					   	<cf_space spaces="38">	
						
					   </td>
					  		  
					  
					   <td align="right" width="30">		
					   
					   		<cf_space spaces="8">
							
					   		<cfif (access eq "EDIT" or access eq "ALL") and actionStatus eq "0">   
							
								<cf_img icon="edit" onclick="workflowevents('#url.tabno#','#URL.WorkOrderId#','#workordereventid#')">		
								
							</cfif>				 
										 
					   </td>
					   
					   <td align="left" style="padding-left:4px" width="30" id="eventdelete#currentrow#">
					   
					   		<cf_space spaces="8">
							
					   		<cfif access eq "ALL" and actionStatus eq "0"> 
							
								<cf_img icon="delete"  onclick="eventpurge('#currentrow#','#URL.workorderid#','#workordereventid#')">
														  
							 </cfif> 
								 
					  </td>				  
					 				   
				    </TR>	
					
										
					<tr><td height="1"></td></tr>
										
					<tr id="attach_#workordereventid#">	
					    <td></td>
				   		<td></td>					
				        <td colspan="#cols-3#" style="padding-left:4px">						
											
							<cfif access eq "EDIT" or access eq "ALL">   
					   
						   		<cf_filelibraryN
							    	DocumentHost="#parameter.documenthost#"
									DocumentPath="#parameter.documentLibrary#"
									SubDirectory="#url.workorderid#" 
									box="event#currentrow#"
									loadscript="no"
									Filter="#left(workordereventid,8)#"						
									Insert="yes"
									Remove="yes"
									reload="true">		
								
							<cfelse>
							
								<cf_filelibraryN
							    	DocumentHost="#parameter.documenthost#"
									DocumentPath="#parameter.documentLibrary#"
									SubDirectory="#url.workorderid#" 
									box="event#currentrow#"
									loadscript="no"
									Filter="#left(workordereventid,8)#"						
									Insert="no"
									Remove="no"
									reload="true">							
							
							</cfif>	
				  
				        </td>
			    </tr>	
											
				<tr><td height="2"></td></tr>
				
				<input type="hidden" 
			      name="workflowlink_#workordereventid#" 
	              id="workflowlink_#workordereventid#"
			      value="../servicereview/servicelineWorkflow.cfm">		
				  
				  				
			<cfif wfstatus eq "open" and prior eq "0">
				
					<tr id="box_#workordereventid#">
					<td></td>
					<td></td>
					<td colspan="#cols-3#" id="#workordereventid#">
										
						<cfset url.ajaxid = workordereventid>
						<cfinclude template="ServiceLineWorkflow.cfm">
						
						<cfset prior = "1">
															
					</td></tr>		
				
				<cfelse>
				
					<tr id="box_#workordereventid#" class="hide">		
						<td></td>	
						<td></td>	
						<td colspan="#cols-3#" id="#workordereventid#"></td>
					</tr>		
				
				</cfif>
				
	   
			  		  
			 	<tr><td height="4"></td></tr>
				
				</cfif>	
												
			</cfloop>		
			
			
			</cfoutput>			
															
			</table>
			
		</td>
		</tr>		
					
	</table>	
	
	</cf_divscroll>
	
	<cfset ajaxonload("doHighlight")>