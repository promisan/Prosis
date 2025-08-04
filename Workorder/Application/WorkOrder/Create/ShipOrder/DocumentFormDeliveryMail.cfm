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
<!--- send mail as part of the submission --->

<cfoutput>
		
<cfquery name="Customer" 
 datasource="AppsWorkOrder" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	SELECT *
	FROM   Customer
	WHERE  CustomerId   = '#URL.customerid#'					  
</cfquery>		

<cfquery name="getServiceMission" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   ServiceItemMission			
	WHERE  ServiceItem   = '#form.ServiceItem#'	
	AND    Mission       = '#url.mission#'		
		  
</cfquery>	

<cf_getLocalTime Mission="#url.mission#">

<cfif (form.Action_Delivery eq "Today" or (form.Action_Delivery eq "Tomorrow" and hour(localtime) gt "17")) 
       and isValid("email",getServiceMission.eMailAddress)>
							
		<cfquery name="getService" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT * 
			FROM   #client.lanPrefix#ServiceItem			
			WHERE  Code  = '#form.ServiceItem#'													  
		</cfquery>	
		
		<cf_tl id="Express Delivery" var="urgentaction">
								
		<cfmail to     = "jbatres@promisan.com"		
	       FROM        = "#client.eMail# (#session.first# #session.last#)"
		   PRIORITY    = "1"
		   SUBJECT     = "#ucase(urgentaction)# #getService.description#"			 
		   mailerID    = "#session.acc#"
		   TYPE        = "html"
		   spoolEnable = "Yes">		
						     
		   <table width="60%" border="1" bordercolor="silver" style="border-collapse:collapse; border:1px solid silver">
		   	   <tr>
			   	<td colspan="2" bgcolor="e7e7e7" align="center">
					
					<!---
					#getLogo.LogoPath##getLogo.LogoFileName#
					<img src="#getLogo.LogoPath#/#getLogo.LogoFileName#">
					--->	
											
					<img src="#session.root#/custom/kuntz/Kuntz-logo.jpg">							
					
				</td>
			</tr>
		   	<tr>					   
			   
			   	<td colspan="2" bgcolor="cbd9e3" style="border-top:1px solid silver; border-bottom:1px solid silver">
				  	&nbsp;&nbsp;&nbsp;&nbsp;<font face="calibri" size="4" color="454545"><b>#urgentaction#!!!</b></font>
					<br>
					&nbsp;&nbsp;&nbsp;&nbsp;<font face="calibri" size="2" color="gray"><cf_tl id="Customer">: #Customer.CustomerName#</font>						 
					<br>
					&nbsp;&nbsp;&nbsp;&nbsp;<font face="calibri" size="2" color="gray"><cf_tl id="City">: #Customer.City#  -  <cf_tl id="PostalCode">: #Customer.PostalCode#</font>
					<br>
					&nbsp;&nbsp;&nbsp;&nbsp;<font face="calibri" size="2" color="gray"><cf_tl id="Address">: #Customer.Address# #Customer.AddressNo#</font>
					<cfif Customer.MobileNumber neq "">
					<br>
					&nbsp;&nbsp;&nbsp;&nbsp;<font face="calibri" size="2" color="gray"><cf_tl id="Mobile">: #Customer.MobileNumber#</font>
					</cfif>
				  
				</td>
			</tr>
															  				  					   
			   <cfset url.mode = "view">					 
			   <cfinclude template="../CustomFields.cfm">	
			   
			<tr>
				  						  
			   	<td colspan="2" bgcolor="f1f1f1">
				  	<table style="border-collapse:collapse">
						<tr>
							<td>
								&nbsp;&nbsp;&nbsp;
							</td>
							<td>
								<cfoutput>
								<img src="#session.root#/images/action.gif">
								</cfoutput>
							</td>
							<td>
								<a href="#session.root#/WorkOrder/Application/WorkOrder/Create/WorkOrderEdit.cfm?drillid=#drillid#&context=backoffice"><font face="calibri" size="3">Open here</font></a>
							</td>
						</tr>
					</table>
				  </td>
			      						  
			   </tr>		   
			  					   
		   </table>  
		   <br>
		 				   			   																		
		   <!--- add the disclaimer --->
		   <cf_maildisclaimer context="template" id="#rowguid#">
		   			 
					
		</cfmail>	
		
</cfif>		
				
</cfoutput>				