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
<cfparam name="url.addressid"  default="00000000-0000-0000-0000-000000000000">

<cfif isValid("guid",url.customerid)>
	
	<cfquery name="customer" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		    SELECT  *
			FROM   Customer
			WHERE  CustomerId = '#url.customerid#'	    							   
	</cfquery>
	
	<!-- <cfform> -->
	
	<cfoutput>
			
	<table class="clsNoPrint" style="width:100%">
	
		<tr class="hide"><td height="5" id="inputvalidation"></td></tr>
					
		<tr class="labelmedium" style="padding-right:2px">
		
			<td style="padding-left:24px" title="Mobile No"><cf_tl id="Mobile"></td>	
			<td width="110"> <input type="text" 
					   id="mobilenumber_#url.customerid#"
					   size="8" style="align:center;background-color:##efefef50"
					   onKeyUp="applyCustomerData('#url.customerid#','mobilenumber',this.value)"
					   maxlength="15" 
					   onchange="this.background-color:ffffff"
					   class="regularxl enterastab"
					   value = "#customer.MobileNumber#">	
			</td>
			<!---
			<td width="40"><cf_tl id="DOB"></td>	
			--->
			
			
			<td style="padding-left:3px;min-width:120px" title="Date of birth" class="CustDOB">
										
				<cf_intelliCalendarDate9
					FieldName="CustomerDOB_#left(url.customerid,4)#" 
					id="CustomerDOB_#left(url.customerid,4)#" 
					Manual="True"		
					class="regularxl"		
					style="background-color:##efefef50;text-align:center"
					onfocus="this.background-color='##eaeaea50'"
					onChange="applyCustomerData('#url.customerid#','customerdob',this.value,'CustomerDOB_#left(url.customerid,4)#')"								
					DateValidEnd="#dateformat(now(),'YYYYMMDD')#"
					Default="#dateformat(customer.CustomerDOB,client.dateformatshow)#"
					AllowBlank="True">	
							
			</td>
			
						
			<td style="min-width:160px;width:100%" title="eMail address">
						
				  <input type="text" 				  
					   id  ="emailaddress_#url.customerid#"
					   size="15"
					   onKeyUp="applyCustomerData('#url.customerid#','emailaddress',this.value)"
					   maxlength="50" 
					   onchange="this.background-color:ffffff"
					   style="width:100%;background-color:##efefef50"
					   class="regularxl enterastab"
					   value = "#customer.emailAddress#">
					   
			</td>
			
		</tr>	
				
		<tr><td height="2"></td></tr>
				
		<tr class="labelmedium">
			
			<td style="min-width:70px;padding-right:4px;padding-left:24px"><cf_tl id="Postal"></td>	
			<td colspan="4">		
						
				 <cf_textInput
						  form      = "customerform"
						  type      = "ZIP"
						  mode      = "regularxl"
						  name      = "postalcode"
						  id        = "postalcode_#url.customerid#"
					      value     = "#Customer.PostalCode#"
					      required  = "No"
						  size      = "6"
						  maxlength = "8"
						  label     = "find"
						  onKeyUp   = "applyCustomerData('#url.customerid#','postalcode',this.value)"
						  style     = "background-color:##efefef50">		
				 
			</td>
		</tr>

		<cfquery name="customerAddress" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  A.*
				FROM   CustomerAddress CA INNER JOIN
						System.dbo.Ref_Address A 
						ON CA.AddressId = A.AddressId
				WHERE  CustomerId = '#url.customerid#'
		</cfquery>


		<cfquery name="qExisting"
		datasource="AppsMaterials"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM   vwCustomerRequest
			WHERE CustomerId = '#url.customerid#'
		</cfquery> 							
				
		<cfif customerAddress.recordcount neq 0>
		
			<tr><td height="2"></td></tr>
			
			<tr class="labelmedium">
				<td style="padding-left:24px;min-width:80px;padding-right:5px"><cf_tl id="Branch"></td>	
				
				<cfif url.addressid eq "00000000-0000-0000-0000-000000000000" and qExisting.recordcount neq 0>
					<cfset url.addressid = qExisting.AddressId>
				</cfif>	
					
				<td width="170" colspan="3">	
							
					<select id	="addressidselect" 
						style="background-color:##efefef50" class="regularxl enterastab"
						onkeyup="this.background-color:ffffff"
						onchange="ptoken.navigate('#SESSION.root#/warehouse/application/salesorder/POS/sale/applyCustomer.cfm?mission=#qExisting.Mission#&warehouse=#url.warehouse#&category=&itemno=&search=&customerid='+document.getElementById('customeridselect').value+'&addressid='+this.value,'customerbox')">						
						<cfloop query="customerAddress">
							<option value="#customerAddress.AddressId#" <cfif URL.addressId eq customerAddress.AddressId>selected</cfif>>#customerAddress.Address# #customerAddress.AddressCity#</option>
						</cfloop>						
					</select>
					
				</td>	
			</tr>			
		<cfelse>
			<input type="hidden" id="addressidselect" value="00000000-0000-0000-0000-000000000000">	
		</cfif>
			
	</table>
	
	</cfoutput>	
	
	<!-- </cfform> -->

</cfif>

<cfset ajaxOnLoad("doCalendar")>