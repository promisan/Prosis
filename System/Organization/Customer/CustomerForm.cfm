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
   
<!--- customer form --->

<cf_dialogOrganization>
<cf_ListingScript>
<cf_dialogLedger>
<cf_MenuScript>
<cf_calendarscript>

<cfoutput>

	<script language="JavaScript">

	function validate(myform,dsn) {		
		document.customerform.onsubmit() 		
		if (_CF_error_messages.length == 0) {				
			   ptoken.navigate('#SESSION.root#/system/organization/customer/CustomerFormSubmit.cfm?systemfunctionid='+opener.document.getElementById('systemfunctionid').value+'&form=&dsn='+dsn,'savebox','','','POST','customerform')			   		
		}		
	}		
	
	function deletecustomer(id,dsn) {
	    ptoken.navigate('#SESSION.root#/system/organization/customer/CustomerFormDelete.cfm?customerid='+id+'&systemfunctionid='+opener.document.getElementById('systemfunctionid').value+'&form=&dsn='+dsn,'savebox')			   				
	}
		
	</script>
	
</cfoutput>

<cfajaximport tags="cfform,cfdiv">

<cfquery name="Get" 
	datasource="#url.dsn#"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM  Customer
		<cfif url.customerid neq "">
		WHERE CustomerId  = '#URL.CustomerId#' 
		<cfelse>
		WHERE 1=0
		</cfif>
</cfquery>

<cfquery name="Requester" 
	datasource="AppsOrganization"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM  Organization
		WHERE OrgUnit = '#get.OrgUnit#'						
</cfquery>
		
<cfif url.customerid neq "">

	<cfif get.recordcount eq "0">
	
	<table align="center"><tr><td class="labelmedium" style="padding-top:20px" align="center"><font color="FF0000"><cf_tl id="No longer on file"></td></tr></table>
	
	<cfabort>
	
	</cfif>	
		
	<cfquery name="Mission" 
		datasource="#url.dsn#"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM  Ref_ParameterMission		
			WHERE Mission = '#get.mission#'	
	</cfquery>
			
	<cfquery name="Workorder" 
		datasource="#url.dsn#"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM  WorkOrder		
			WHERE CustomerId  = '#URL.CustomerId#' 	
	</cfquery>
	
	<cfset url.mission = get.Mission>
	
	<cf_screentop height="100%" 
		   layout="webapp" 
		   label="Customer Maintenance" 
		   banner="green" 
		   user="yes"
		   jquery="Yes"
		   scroll="no">
		
<cfelse>
		
	<cfquery name="Mission" 
		datasource="#url.dsn#"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_ParameterMission		
			WHERE  Mission = '#url.mission#'	
	</cfquery>
	
	<cf_screentop height="100%" 
	   layout="webapp" 
	   label="Record Customer" 
	   banner="green" 
	   jquery="Yes"
	   user="yes"
	   scroll="no">
		
</cfif>

		
<cfoutput>	

<cfparam name="url.mode"   default="edit">
<cfparam name="url.portal" default="0">
<cfset ht = "30">

<table width="100%" height="100%" cellspacing="0" cellpadding="0" bgcolor="FFFFFF">

<tr class="hide"><td id="process"></td></tr>
<tr><td height="4"></td></tr>
<tr><td>

<cf_divscroll>

	<cfform name="customerform" style="height:100%" onsubmit="return false">   
						
			<table width="94%"   			
			   class="formspacing formpadding"
		       align="center">
			   
				   	<tr><td height="4"></td></tr>		  		  		      
			  				
					  <input type="hidden" name="CustomerId" id="CustomerId" value="#url.customerId#">
					  <input type="hidden" name="dsn" id="CustomerId" value="#url.dsn#">
					 									  			   
					   <tr>
					   <td width="130" style="padding-left:8px;#ht#" class="labelmedium"><cf_tl id="Name">:<cfif url.mode eq "edit"><font color="FF0000">*</font></cfif></td>
					   <td class="labelmedium">
						
						<cfif url.mode eq "view">
						
						  <font size="3"><b>#get.CustomerName#</font>
							   
						<cfelse>
						
							<cfinput type="Text"
						       name="customername"
						       required="Yes"
							   class="regularxl  enterastab"
							   value="#get.CustomerName#"
						       size="60"
						       maxlength="80">
						
						</cfif>	   
					   </td>
					   </tr>				   
					   
					   <tr>
						<td width="10%" class="labelmedium" style="padding-left:8px;#ht#"><cf_tl id="Provider">:<cfif url.mode eq "edit"><font color="FF0000">*</font></cfif></td>
						<td class="labelmedium">
						
						<cfif url.mode eq "view">
						
							#get.Mission#
						
						<cfelse>
									
							<cfif get.recordcount eq "0">
							
							<select name="mission" id="mission" class="regularxl  enterastab">
							<cfloop query="Mission">
								<option value="#Mission#" <cfif url.mission eq mission>selected</cfif>>#Mission#</option>
							</cfloop>
							</select>
							
							<cfelse>
							
							<select name="mission" id="mission" class="regularxl  enterastab">
							<cfloop query="Mission">
								<option value="#Mission#" <cfif get.mission eq mission>selected</cfif>>#Mission#</option>
							</cfloop>
							</select>
							
							</cfif>
						
						</cfif>
						
					   </td>
					   </tr>	
					   
					   	<!--- india sales order, record basic info --->
								   
						   <tr>
							<td class="labelmedium" style="padding-left:8px;#ht#"><cf_tl id="Contact mail">:</td>
							<td class="labelmedium">
							
							<table><tr class="labelmedium">
							<td>
							<cfif url.mode eq "view">
							
							   <cfif get.EMailAddress eq "">n/a<cfelse>#get.eMailAddress#</cfif>
							   
							<cfelse>   
							
								<cf_tl id="Please enter a correct mail address" var="vEmailMessage" class="message">
							
								<cfinput type="Text"
							       name="eMailAddress"
							       validate="email"
							       required="No"   
								   class="regularxl"
								   message="#vEmailMessage#"   
								   value="#get.eMailAddress#"
							       size="30"
							       maxlength="50">
								   
							</cfif>	   
						   </td>
						  						   
							<td class="labelmedium" style="padding-left:8px;#ht#"><cf_tl id="Phone">:</td>
							<td class="labelmedium">
							
								<cfif url.mode eq "view">
							
								   <cfif get.PhoneNumber eq "">n/a<cfelse>#get.PhoneNumber#</cfif>
							   
								<cfelse>   
							
									<cfinput type="Text"
								       name="PhoneNumber"
								       required="No"
									   class="regularxl enterastab"
									   value="#get.PhoneNumber#"
								       size="16"
								       maxlength="50">
								   
								</cfif>   
						   </td>
						  						   
							<td class="labelmedium" style="padding-left:8px;#ht#"><cf_tl id="Mobile">:</td>
							<td class="labelmedium">
							
								<cfif url.mode eq "view">
							
								   <cfif get.MobileNumber eq "">n/a<cfelse>#get.MobileNumber#</cfif>
							   
								<cfelse>   
							
									<cfinput type="Text"
								       name="MobileNumber"
								       required="No"
									   class="regularxl enterastab"
									   value="#get.MobileNumber#"
								       size="16"
								       maxlength="50">
								   
								</cfif>   
						   </td>
						  </tr>	
						  
						  </table>
						 
					 </td> 				   
					 </tr>
					  				   				  				   			  			  			   
					   <cfif url.dsn eq "AppsWorkorder" and mission.CustomerDetail eq "1">
					  				   			   
				       <cfif get.address eq "" and url.mode eq "view">
					   				   
					   <cfelse>				
					   
					         <cfif get.address eq "" and Requester.OrgUnit neq "">		
							 
							 <cfelse>			   							  
						  					   
						     <tr>
								<td class="labelmedium" style="padding-left:8px;#ht#"><cf_tl id="Address">:<cfif url.mode eq "edit"></cfif></td>
								<td class="labelmedium">
								
								<cfif url.mode eq "view">
								
								   #get.Address#
									   
								<cfelse>
								
									<cfinput type= "Text"
								       name      = "Address"
								       required  = "No"
									   class     = "regularxl  enterastab"
									   value     = "#get.Address#"
								       size      = "60"
								       maxlength = "100">
								
								</cfif>	   
							   </td>
							</tr>
														   					    
							<tr>
								
							  <td class="labelmedium" style="padding-left:8px;#ht#"><cf_tl id="Postal Code">:</td>
							  <td class="labelmedium">
							  
							   <table><tr><td>
								
								<cfif url.mode eq "view">
								
								   #get.PostalCode#
									   
								<cfelse>
								
									<cfinput type="Text"
								       name="PostalCode"
								       required="No"
									   class="regularxl enterastab"
									   value="#get.PostalCode#"
								       size="8"
								       maxlength="10">
								
								</cfif>	  
								
								</td>
								
								<td class="labelmedium" style="padding-left:8px;#ht#"><cf_tl id="City">:<cfif url.mode eq "edit"><font color="FF0000">*</font></cfif></td>
								<td class="labelmedium" style="padding-left:6px">
								
									<cfif url.mode eq "view">
									
									   #get.City#
										   
									<cfelse>
									
										<cfinput type="Text"
									       name="City"
									       required="No"
										   class="regularxl enterastab"
										   value="#get.City#"
									       size="34"
									       maxlength="40">
									
									</cfif>	   
								
							   </td>
							   
							   <td class="labelmedium" style="padding-left:8px;#ht#"><cf_tl id="Country">:<cfif url.mode eq "edit"><font color="FF0000">*</font></cfif></td>
								<td class="labelmedium" style="padding-left:6px">
								
									<cfif url.mode eq "view">
									
									<cfquery name="Nation" 
										datasource="AppsSystem" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										    SELECT *
										    FROM   Ref_Nation
											WHERE  Code = '#get.Country#'
										</cfquery>
									
										<b>#Nation.Name#</b>									
										   
									<cfelse>
									
									<cfquery name="Nation" 
									datasource="AppsSystem" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									    SELECT   *
									    FROM     #CLIENT.LanPrefix#Ref_Nation
										ORDER BY Name
									</cfquery>
  	
									
									<cfif get.recordcount eq "0">			
																				
											<cfquery name="default" 
												datasource="appsOrganization"
												username="#SESSION.login#" 
												password="#SESSION.dbpw#">
													SELECT *
													FROM   Ref_Mission		
													WHERE  Mission = '#url.mission#'	
											</cfquery>
									
										   	<select name="country" id="country" style="width:150px" class="enterastab regularxl" required="No">			
											    <cfloop query="Nation">
													<option value="#Code#" <cfif Code eq default.CountryCode>selected</cfif>>#Name#</option>
												</cfloop>
										   	</select>		
										<cfelse>
											<select name="country" id="country" style="width:150px" class="enterastab regularxl" required="No">			
											    <cfloop query="Nation">
													<option value="#Code#" <cfif get.Country eq Code>selected</cfif>>#Name#</option>
												</cfloop>
										   	</select>		
										</cfif>
									   
									
									</cfif>	   
								
							   </td>
								
								</tr>
								
								
								
							  </table> 
							   </td>
							 
							</tr>
																								   				   
						   </cfif>
						  
						</cfif>  					  
					  				   
					   </cfif>
					   
					   <cfif url.mode eq "view" and get.Reference eq "">
		
							<!--- nada --->
							
					   <cfelse>	
					      
						   <tr>
							<td class="labelmedium" style="padding-left:8px;#ht#"><cf_tl id="Reference">:</td>
							<td class="labelmedium">
							
								<cfif url.mode eq "view">
							
								   #get.Reference#
							   
								<cfelse>   
								
									<cfinput type="Text"
									       name="Reference"
									       required="No"
										   class="regularxl"
										   value="#get.Reference#"
									       size="20"
									       maxlength="20">
										   
								</cfif>		   
							</td>
						   </tr>
					   
					   </cfif>
					   
					  		   
					   
					   <cfif url.portal eq "0">
					   			   
					   <tr>
						<td class="labelmedium" style="height:30px;padding-left:8px;#ht#" width="160">
						
						<cf_space spaces="50">
						
						<cf_tl id="Organization">:</td>
																		
							<cfquery name="Requester" 
								datasource="AppsOrganization"
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT *
									FROM  Organization
									WHERE OrgUnit = '#get.OrgUnit#'						
							</cfquery>
														
						    <td>						
						
							<cfif url.mode eq "view">
						
							   <cfif requester.recordcount gte "1">
							   
							   <table cellspacing="0" cellpadding="0">
							   
							   <tr>
		
							   <td class="labelmedium">#requester.OrgUnit# (#Requester.Mission#/#Requester.OrgUnitCode#)</td>
							   
							   <td>&nbsp;&nbsp;</td>
		
							   <td>
							   
								   <cfif url.portal eq "0">
								  						  								   
									   <button name="drill" id="drill" class="button10g"  onclick="viewOrgUnit('#requester.orgunit#')">
										   <img src="#SESSION.root#/images/locate.png" 
											   alt="" 
											   height"11" width="11'
											   border="0" 
											   style="cursor:pointer" 
											   align="absmiddle">&nbsp;
											   <cf_tl id="Customer Organization">											   
									   </button>
								   
								   </cfif>
							   
							   </td>
							   </tr>
							   </table>
								   
							    <cfelse>
								
								<font color="FF0000"><cf_tl id="undefined"></font>
								
							    </cfif>   
						   
							<cfelse>   
																				
								<cfif get.recordcount eq "1" and get.OrgUnit neq "0">							
														 																							
								   <cfdiv bind="url:CustomerProfile.cfm?mode=#url.mode#&dsn=#url.dsn#&customerid=#url.customerid#&mission={mission}" id="unit">
														
								<cfelse>
															
								   <!--- trying to match something here --->
																	
								   <cfdiv bind="url:CustomerProfile.cfm?mode=#url.mode#&dsn=#url.dsn#&customerid=#url.customerid#&name={customername}&mission={mission}" id="unit">
								   
								</cfif>   
														 
							 </cfif>
						
						</td>
					   </tr>
					   
				   </cfif>
				   
				     <cfquery name="Terms" 
							datasource="AppsWorkOrder"
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
					   	    SELECT     *
							FROM       Ref_Terms							
						</cfquery> 	
				   
				   <tr>
						<td class="labelmedium" style="height:25;padding-left:8px;#ht#"><cf_tl id="Billing Terms">:</td>
						<td class="labelmedium">
											
								<cfif url.mode eq "view">
								
									<cfquery name="Terms" 
										datasource="AppsWorkOrder"
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
								   	    SELECT     *
										FROM       Ref_Terms	
										WHERE      Code = '#get.Terms#'						
									</cfquery> 	
						
									#terms.description#															  
							   
								<cfelse> 								
									
									<cf_tl id="Please select a valid terms value" var="1">
									<cfselect 
										query="Terms" 
										name="terms" 
										id="terms" 
										class="regularxl enterastab" 
										display="Description" 
										value="Code" 
										selected="#get.Terms#" 
										required="Yes" 
										message="#lt_text#">
									</cfselect>																				
									   
								</cfif>
									   
							</td>
					 </tr>
				   
				   <tr>
						<td class="labelmedium" style="height:25;padding-left:8px;#ht#"><cf_tl id="Tax Exemption">:</td>
						<td class="labelmedium">
											
								<cfif url.mode eq "view">
							
								   <cfif get.TaxExemption eq "1">Yes<cfelse>No</cfif>
							   
								<cfelse> 
								
									<table cellspacing="0" cellpadding="0">
										<tr>
										<td>
										<input type="radio" class="radiol" name="TaxExemption" value="1" <cfif get.Taxexemption eq "1">checked</cfif>>										
										</td>
										<td class="labelmedium" style="padding-left:4px">Yes</td>
										<td style="padding-left:10px">
										<input type="radio" class="radiol" name="TaxExemption" value="0" <cfif get.Taxexemption eq "0" or get.Taxexemption eq ""> checked</cfif>>		
										</td>
										<td class="labelmedium" style="padding-left:4px">No</td>									
									   </tr>
									</table>  								
									   
								</cfif>
									   
							</td>
					 </tr>
					 
								 
					
							   						   
					 <!--- price sceduling --->
										  
					   <cfquery name="Category" 
							datasource="AppsMaterials"
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
						   	   SELECT   *
							   FROM     Ref_Category
							   WHERE    FinishedProduct = 1 
							   <!---
							   AND      Category IN   (SELECT     Category
							                           FROM       WarehouseCategory
							                           WHERE      Warehouse IN (SELECT    Warehouse
						                                                        FROM      Warehouse
						                                                        WHERE     Mission = '#url.mission#')
														)
														
														--->
					   
					   </cfquery>
					   
					   <cfquery name="Schedule" 
							datasource="AppsMaterials"
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
					   	    SELECT     *
							FROM       Ref_PriceSchedule
							ORDER BY FieldDefault DESC, ListingOrder
						</cfquery> 	
					   
					   <cfif Category.recordcount gte "1">
					   
					   	 <tr>
						 <td class="labelmedium" valign="top" style="font-size:25px;padding-top:5px;height:25;padding-left:8px;#ht#"><cf_tl id="Price schedule"></td>
						 </tr>
												
						   <cfloop query="Category">
						   
							  <cfquery name="PriceSchedule" 
									datasource="AppsWorkOrder"
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
							  		SELECT   *
									FROM     CustomerSchedule
									<cfif url.customerid neq "">
									WHERE  CustomerId = '#url.customerid#'
									AND    Category   = '#category#'
									<cfelse>
									WHERE 1=0
									</cfif>							
									ORDER BY DateEffective DESC
								</cfquery>
								
							   <tr class="labelmedium" style="height:20px">
							   	<td style="min-width:300px;padding-left:18px">#Description#:</td>
									
								<td style="padding-left:1px">
								
									<table><tr>
									
									<td>
									
									<cfif PriceSchedule.dateEffective eq "">
									
									<cf_intelliCalendarDate9
										FieldName="f#currentrow#_DateEffective" 									
										class="regularxl enterastab"															
										Default="#dateformat(now(),client.dateformatshow)#"
										AllowBlank="False">	
									
									<cfelse>
									
									<cf_intelliCalendarDate9
										FieldName="f#currentrow#_DateEffective" 									
										class="regularxl enterastab"															
										Default="#dateformat(PriceSchedule.dateEffective,client.dateformatshow)#"
										AllowBlank="False">	
										
									</cfif>	
									
									</td>
																		
									<td style="padding-left:7px">
									<select class="regularxl enterastab" name="f#currentrow#_PriceMode">
										<option value="S" <cfif PriceSchedule.PriceMode eq "S">selected</cfif>>From Schedule</option>
										<option value="L" <cfif PriceSchedule.PriceMode eq "L">selected</cfif>>Last Quoted price</option>
									</select>
									</td>
									
									<td style="padding-left:7px">
									
									<select class="regularxl enterastab" name="f#currentrow#_Schedule">
									    <cfloop query="Schedule">
											<option value="#Code#" <cfif PriceSchedule.PriceSchedule eq Code>selected</cfif>>#Description#</option>
										</cfloop>
									</select>						
									
									</td>
									
									</tr></table>
								
								</td>
							   
							   </tr>
												   
						   </cfloop>
					  				   
				      </cfif>
					  
					  <cfif url.dsn eq "AppsWorkOrder">
					 					
						<cfquery name="Ledger" 
						datasource="appsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT   *
							FROM     Ref_AreaGledger
							ORDER BY ListingOrder
						</cfquery>
						
							 <tr>
						 <td class="labelmedium" valign="top" style="font-size:20px;padding-top:5px;height:25;padding-left:8px;#ht#"><cf_tl id="Ledger Posting"></td>
						 </tr>
							
												
							<cfloop query="Ledger">													   
							
								<tr>
								   <td class="labelmedium" style="height:25;padding-left:18px;#ht#">#Description#:<cf_space spaces="40"></td>
								   <td>
								   <table class="formpadding">
								   <tr>
								   
								   	<cfif url.customerid eq "">
									
										<cfquery name="Mission" 
											datasource="appsWorkOrder" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
											SELECT * 
											FROM   Ref_ParameterMissionGledger
											WHERE  Mission = '#url.mission#'
											AND    Area = '#area#'
										</cfquery> 
									
										<cfset glaccount = mission.glaccount>
									
									<cfelse>
								   								   
										<cfquery name="Account" 
										datasource="appsWorkOrder" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
											SELECT *
											FROM   CustomerGLedger A, 										          
												   Ref_AreaGledger G
											WHERE  A.CustomerId = '#URL.customerId#'	
											AND    G.Area   = A.Area   
											AND    A.Area   = '#Area#'
											ORDER BY ListingOrder
										</cfquery>
										
										<cfif Account.recordcount eq "0">
										
											<cfquery name="Mission" 
											datasource="appsWorkOrder" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
												SELECT * 
												FROM   Ref_ParameterMissionGledger
												WHERE  Mission = '#url.mission#' 
												AND    Area    = '#area#'
											</cfquery> 
																						
											<cfquery name="Add" 
												datasource="appsWorkOrder" 
												username="#SESSION.login#" 
												password="#SESSION.dbpw#">
												INSERT INTO CustomerGLedger
														(CustomerId,
														 Area,
														 GLAccount,
														 OfficerUserId,
														 OfficerLastName,
														 OfficerFirstName)
												VALUES  ('#url.customerid#',
														 '#area#',
														 '#mission.glaccount#',
														 '#session.acc#',
														 '#session.last#',
														 '#session.first#')										   
											</cfquery>
																				
											<cfquery name="Account" 
												datasource="appsWorkOrder" 
												username="#SESSION.login#" 
												password="#SESSION.dbpw#">
													SELECT   *
													FROM     CustomerGLedger A, 
												             Accounting.dbo.Ref_Account B,
														     Ref_AreaGledger G
													WHERE    A.GLAccount = B.GLAccount
													AND      A.CustomerId = '#URL.customerId#'	
													AND      G.Area   = A.Area   
													AND      A.Area   = '#Area#'
													ORDER BY ListingOrder
											</cfquery>
																							
											<cfset glaccount = mission.glaccount>
											
										<cfelse>
										
		
											<cfset glaccount = account.glaccount>
											
										</cfif>
										
									</cfif>
									
									<cfquery name="Account" 
										datasource="appsWorkOrder" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										SELECT *
										FROM   Accounting.dbo.Ref_Account												  
										WHERE  GLAccount = '#glaccount#'											
									</cfquery>
										
									<cfif area neq "Income" and BillingEntry eq "0">
										   <cfset filter = "balance">
										   <cfset field = "AccountClass">		   				   
									<cfelse>  
										   <cfset filter = "result">
										   <cfset field = "AccountClass">				
									</cfif>
									
									<td>
									<img src="#SESSION.root#/Images/search.png" alt="Select" name="img3#area#" 
											onMouseOver="document.img3#area#.src='#SESSION.root#/Images/contract.gif'" 
											onMouseOut="document.img3#area#.src='#SESSION.root#/Images/search.png'" style="border:1px solid gray;border-radius:3px;"
											style="cursor: pointer;" width="25" height="23" border="0" align="absmiddle" 
											onClick="selectaccount('#area#glaccount','#area#gldescription','#area#debitcredit','#url.mission#','#field#','#filter#','');">
									
									</td>
										
									<cfset vReq = "No">	
									<cfif lcase(area) eq "stock">
										<cfset vReq = "Yes">
									</cfif>
									
									<td>	
									<cfinput type="text"   name="#area#glaccount"     size="13" value="#GLAccount#"  class="regularxl" readonly style="text-align: left;" message="Please, enter a valid account for #area# area." required="#vReq#">
									</td>
									
									<td>										
									<input type="text"     name="#area#gldescription" id="#area#gldescription"  value="#Account.Description#" class="regularxl" size="40" readonly style="text-align: left;">
									</td>
									<input type="hidden"   name="#area#debitcredit"   id="#area#debitcredit">
									
									</tr>
									</table>   	   
								   
								</tr>		
													
							</cfloop>
								  
					  </cfif>
				   
				    
					  <cfif url.mode eq "view" and get.Memo eq "">
					   
					      	<!--- nada --->
					   
					   <cfelse>
								  			   
						   <tr>
							<td class="labelmedium" style="padding-left:8px;#ht#"><cf_tl id="Memo">:</td>
							<td class="labelmedium">
											
								<cfif url.mode eq "view">
							
								   #get.Memo#
							   
								<cfelse>   
								
									<cfinput type="Text"
								       name="Memo"
								       required="No"
									   class="regularxl enterastab"
									   value="#get.Memo#"
							    	   size="70"
								       maxlength="80">
									   
								</cfif>
									   
							</td>
						   </tr>
					   
					   </cfif>  		
				   
				    <tr>
						<td class="labelmedium" style="height:25;padding-left:8px;#ht#"><cf_tl id="Operational">:</td>
						<td class="labelmedium">
											
								<cfif url.mode eq "view">
							
								   <cfif get.Operational eq "1">Yes<cfelse>No</cfif>
							   
								<cfelse> 
								
									<table cellspacing="0" cellpadding="0">
										<tr>
										<td>
										<input type="radio" class="radiol" name="Operational" value="1" <cfif get.Operational eq "1">checked</cfif>>										
										</td>
										<td class="labelmedium" style="padding-left:4px">Yes</td>
										<td style="padding-left:10px">
										<input type="radio" class="radiol" name="Operational" value="0" <cfif get.Operational eq "0" or get.Operational eq ""> checked</cfif>>		
										</td>
										<td class="labelmedium" style="padding-left:4px">No</td>									
									   </tr>
									</table>  								
									   
								</cfif>
									   
							</td>
					 </tr>
					  			
				   <!--- -------------------- --->	   
				   <!--- bottom of the screen --->
				   <!--- -------------------- --->
					  
				   <tr><td height="5"></td></tr>
						
				   <tr><td colspan="2" class="line"></td></tr>
						
				   <tr>
					   
				  	   <td colspan="2" height="35" align="center" id="savebox">
					   
					   	   <table class="formspacing"><tr>
						   
						    <td>
							   
							    <cf_tl id="Delete" var="vDelete">
														   
								<cfif url.customerid neq "">
								
								 <cfif workorder.recordcount eq "0">
								   
								   <input type = "button" 
									   name    = "Delete" 
									   ID      = "Delete"
									   value   = "#vDelete#" 
									   class   = "button10g" 
									   onclick = "deletecustomer('#url.customerid#','#url.dsn#')" 
									   style   = "font-size:13px;height:24;width:140px">	
								   
								   </cfif>
							   
							   </cfif>
							   
							   </td>
							   
						   <td>
						   						   												   
					   	   <cf_tl id="Save" var="vSave">
						   
						   	<input type = "button" 
							   name    = "Save" 
							   ID      = "Save"
							   value   = "#vSave#" 
							   class   = "button10g" 
							   onclick = "validate('orderform','#url.dsn#')" 
							   style   = "font-size:13px;height:24;width:140px">	
							   
							   </td>
							  
							   </tr>
							   
							 </table>
													   
					   </td>
						   
				   </tr>	   
						
			</table> 
					
		</cfform>
		
</cf_divscroll>		
		
</td></tr>
</table>	

</cfoutput>		