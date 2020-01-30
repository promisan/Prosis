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
			
	<table width="100%" border="0" class="formpadding  clsNoPrint" style="table-layout: fixed;" >
	
		<tr class="hide"><td height="5" id="inputvalidation"></td></tr>
					
		<tr class="labelmedium" style="padding-right: 2px;">
		
			<td width="70"><cf_tl id="Mobile">:</td>	
			<td width="110"> <input type="text" 
					   id="mobilenumber_#url.customerid#"
					   size="8" style="align:center"
					   onKeyUp="applyCustomerData('#url.customerid#','mobilenumber',this.value)"
					   maxlength="15" 
					   class="regularxl enterastab"
					   value = "#customer.MobileNumber#">	
			</td>
			<td width="40"><cf_tl id="DOB">:</td>	
			<td width="120" class="CustDOB">
			
				<cf_intelliCalendarDate9
					FieldName="CustomerDOB_#left(url.customerid,4)#" 
					id="CustomerDOB_#left(url.customerid,4)#" 
					Manual="True"		
					class="regularxl"		
					onChange="applyCustomerData('#url.customerid#','customerdob',this.value,'CustomerDOB_#left(url.customerid,4)#')"								
					DateValidEnd="#dateformat(now(),'YYYYMMDD')#"
					Default="#dateformat(customer.CustomerDOB,client.dateformatshow)#"
					AllowBlank="True">	
					
			
			</td>
			
			<td width="50"><cf_tl id="Mail">:</td>	
			<td width="170">
				  <input type="text" 				  
					   id  ="emailaddress_#url.customerid#"
					   size="15"
					   onKeyUp="applyCustomerData('#url.customerid#','emailaddress',this.value)"
					   maxlength="50" 
					   style="width:100%;font-size: 12px!important;"
					   class="regularxl enterastab"
					   value = "#customer.emailAddress#">
			</td>
			
		</tr>	
		
		
		<tr><td height="2"></td></tr>
				
		<tr class="labelmedium">
			
			<td style="min-width:60px;padding-right:4px;"><cf_tl id="Postal">:</td>	
			<td colspan="2">		
			
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
						  style     = "">		
				 
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
		


		<cftry>
			<cfquery name="qCheck"
			datasource="AppsTransaction" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT AddressId 
				FROM   Sale#URL.Warehouse#
				WHERE CustomerId = '#url.customerid#'
			</cfquery> 							
		
		<cfcatch>
			
			<cfquery name="qAlterTable"
			datasource="AppsTransaction" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				ALTER TABLE Sale#URL.Warehouse# ADD AddressId uniqueidentifier NULL  
			</cfquery> 							
			
		</cfcatch>
		
		</cftry>

		<cfquery name="qExisting"
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM   Sale#URL.Warehouse#
			WHERE CustomerId = '#url.customerid#'
		</cfquery> 							
				
		<cfif customerAddress.recordcount neq 0>
			<tr class="labelmedium">
				<td width="50"><cf_tl id="Branch">:</td>	
				
				<cfif url.addressid eq "00000000-0000-0000-0000-000000000000" and qExisting.recordcount neq 0>
					<cfset url.addressid = qExisting.AddressId>
				</cfif>	
					
				<td width="170">
					<select id	="addressidselect" 
						style="font-size:16px" class="regularxl enterastab"
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