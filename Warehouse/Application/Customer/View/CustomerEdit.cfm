
<cfparam name="url.drillid" default="">
<cfparam name="url.mission" default="">

<cfquery name="Customer" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Customer
	<cfif url.drillid neq "">
		WHERE  CustomerId = '#url.drillid#'
	<cfelse>
		WHERE  1=0
	</cfif>
</cfquery>

<cfif Customer.recordcount gt 0 and url.mission eq "">
	<cfset url.mission = Customer.Mission>
</cfif>

<cfoutput>
<script>
	function applyCustomerData(mis,fld,val) {	
		_cf_loadingtexthtml='';		
	   	ptoken.navigate('#SESSION.root#/Warehouse/Application/Customer/View/setCustomerData.cfm?mode=form&scope=mission&scopeid='+mis+'&field='+fld+'&value='+val,'inputvalidation');
	}
</script>

<cf_divscroll>

<cfform method="POST"  name="customerform" onsubmit="return false">

<table width="95%" class="formpadding formspacing" align="center">

	<tr><td colspan="2" height="10" id="inputvalidation"></td></tr>
	
	<tr>
	<td class="labelmedium"><cf_tl id="Entity"></td>
	<td class="labelmedium">#Customer.Mission#</td>
	</tr>
	
	<tr>
		<td width="18%" class="labelmedium"> <cf_tl id="Reference"> : <font color="red">*</font></td>
		<td class="labelmedium">
		
			<cfif url.drillid eq "">
				<input name="Mission" type="hidden" value="#url.mission#">
				<cf_AssignId>
				<input name="CustomerId" type="hidden" value="#rowguid#">
				<cfset CustomerId = rowguid>
				<cfset mission    = url.Mission>
			<cfelse>
				<input name="Mission" type="hidden" value="#Customer.Mission#">
				<input name="CustomerId" type="hidden" value="#Customer.CustomerId#">
				<cfset CustomerId = Customer.CustomerId>
				<cfset mission    = Customer.Mission>
			</cfif>			
								
			<cfquery name="Parameter" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   Ref_ParameterMission
				WHERE  Mission = '#url.mission#'
			</cfquery>
			
			<cfif Customer.Reference eq Parameter.CustomerDefaultReference AND Customer.CustomerName eq Parameter.CustomerDefaultReference>
			
			   #Customer.Reference#
			   
			   <input type="hidden" name="Reference" value="#Customer.Reference#">
			   <input type="hidden" value="1" name="validateReference" id="validateReference">
				   
			<cfelse>
			
					<table>
					   <tr>
					     <td>
						   
						    <cfinput name="Reference" 
								 type="text" 
								 value="#Customer.Reference#" 
								 size="10" 
								 maxlength="20"
								 class="regularxl enterastab"
								 required="Yes"
								 onKeyUp ="ColdFusion.navigate('ValidateReference.cfm?customerid=#CustomerId#&reference='+this.value+'&mission=#url.mission#','id_validateReference');"
								 message="Please enter Reference.">									 
								 
						 </td>
						 <td id="id_validateReference" style="padding-left:15px;">
						 	<input type="hidden" value="1" name="validateReference" id="validateReference">
						 </td>
		 			   </tr>
					</table>
			
			</cfif>
		</td>
	</tr>
	<tr>
		<td class="labelmedium"><cf_tl id="Name"> : <font color="red">*</font></td>
		<td style="width:80%">
			<cfinput name="CustomerName" 
					 type="text" 
					 value="#Customer.CustomerName#" 
					 size="30" 
					 class="regularxl enterastab"
					 maxlength="80" 
					 required="Yes" 
					 message="Please enter customer name.">
		</td>
	</tr>
	
	<cfquery name="Person" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			    FROM   Employee.dbo.Person E
			    WHERE  PersonNo = '#Customer.PersonNo#'			
	</cfquery>
	
	<cfif Person.Recordcount eq "0">
	
		<tr>
			<td class="labelmedium"><cf_tl id="Individual">:</td>
			<td>		
					
			<cfquery name="Get" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
		    FROM   Applicant.dbo.Applicant
		    WHERE  PersonNo = '#Customer.PersonNo#'
			</cfquery>
			
     			<table>
				
					<tr>
					
					<td id="member">
																
						<input type="text"   name="name"     id="name" value="#Get.FirstName# #Get.LastName#" size="40" maxlength="40" class="regularxl" readonly style="padding-left:4px">				
						<input type="hidden" name="personno" id="personno" value="#Get.PersonNo#" size="10" maxlength="10" readonly>
					
					</td>
					<td style="padding-left:3px">
					
					<cfset link = "#SESSION.root#/Warehouse/Application/Customer/View/setApplicant.cfm?customerid=#url.drillid#">	
								
					 <cf_selectlookup
					    class      = "Applicant"
					    box        = "member"
						button     = "no"
						icon       = "search.png"
						iconwidth  = "25"
						iconheight = "25"
						title      = "#lt_text#"
						link       = "#link#"						
						close      = "Yes"
						des1       = "PersonNo">
							
					</td>
										
					<cfif get.PersonNo neq "">
					
					<td>
					    <cf_img icon="delete" onclick="document.getElementById('personno').value='';document.getElementById('name').value=''">
					</td>
					
					</cfif>
												
					</tr>
				</table>		
				
			</td>
		</tr>
	
	<cfelse>
	
		<tr>
			<td class="labelmedium"><cf_tl id="Staff member">:</td>
			<td>		
					
			<cfquery name="Get" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
			    FROM   Employee.dbo.Person E
			    WHERE  PersonNo = '#Customer.PersonNo#'
			</cfquery>
			
			<table cellspacing="0" cellpadding="0">
					<tr>
					
					<td id="member">
																
					<input type="text" name="name" id="name" value="#Get.FirstName# #Get.LastName#" size="40" maxlength="40" class="regularxl" readonly style="padding-left:4px">				
					<input type="hidden" name="personno" id="personno" value="#Get.PersonNo#" size="10" maxlength="10" readonly>
					
					</td>
					<td style="padding-left:3px">
					
					<cfset link = "#SESSION.root#/Warehouse/Application/Customer/View/setEmployee.cfm?customerid=#url.drillid#">	
								
					 <cf_selectlookup
					    class      = "Employee"
					    box        = "member"
						button     = "no"
						icon       = "search.png"
						iconwidth  = "25"
						iconheight = "25"
						title      = "#lt_text#"
						link       = "#link#"						
						close      = "Yes"
						des1       = "PersonNo">
							
					</td>
					
					<cfif get.PersonNo neq "">
					
					<td>
					    <cf_img icon="delete" onclick="document.getElementById('personno').value='';document.getElementById('name').value=''">
					</td>
					
					</cfif>
					
					
					</tr>
				</table>		
				
			</td>
		</tr>
		
	</cfif>	
	
	<tr>
		<td class="labelmedium"><cf_tl id="Organization">:</td>
		<td>	
				
		<cfquery name="Get" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
		    FROM   Organization E
		    WHERE  OrgUnit = '#Customer.OrgUnit#'
		</cfquery>
						
		<table>
			<tr>				
				<td id="orgunitbox">															
					<input type="text" name="orgname" id="orgname" value="#Get.OrgUnitName#" size="40" maxlength="40" class="regularxl" readonly style="padding-left:4px">				
					<input type="hidden" name="orgunit" id="orgunit" value="#Get.OrgUnit#" size="10" maxlength="10" readonly>				
				</td>
				<td style="padding-left:3px">
				
				<cfset link = "#SESSION.root#/Warehouse/Application/Customer/View/setOrgUnit.cfm?customerid=#url.drillid#">	
							
				 <cf_selectlookup
				    class        = "Organization"
				    box          = "orgunitbox"
					button       = "no"
					icon         = "search.png"
					iconwidth    = "25"
					iconheight   = "25"
					filter1      = "Mission"
					filter1value = "#Parameter.TreeCustomer#"
					title        = "#lt_text#"
					link         = "#link#"						
					close        = "Yes"
					des1         = "Orgunit">
						
				</td>
				
				<cfif get.OrgUnit neq "">
					
					<td>
					    <cf_img icon="delete" onclick="document.getElementById('orgunit').value='';document.getElementById('orgname').value=''">
					</td>
					
				</cfif>
				
			</tr>
		</table>					
		</td>
	</tr>
	
	<tr>
		<td class="labelmedium"><cf_tl id="Date of Birth"></td>
		<td>
			<cf_intelliCalendarDate9 FieldName="CustomerDOB"  class="regularxl enterastab" Message="Please check the birth date"
			Default="#dateformat(Customer.CustomerDOB,'#CLIENT.DateFormatShow#')#" AllowBlank="True">		
		</td>
	</tr>
	
	<tr>
		<td class="labelmedium"><cf_tl id="eMailAddress"> :</td>
		<td>
			<cfinput name="eMailAddress"
			    id="emailaddress_#mission#" 
				 onKeyUp="applyCustomerData('#url.mission#','emailaddress',this.value)"
			    class="regularxl enterastab" type="text" value="#Customer.eMailAddress#" validate="email" size="45" maxlength="50">
		</td>
	</tr>
	
	<tr>
		<td class="labelmedium"><cf_tl id="Mobile Number"> :</td>
		<td>
			<cfinput name="MobileNumber"
			     id="mobilenumber_#mission#" 
				 onKeyUp="applyCustomerData('#url.mission#','mobilenumber',this.value)" 
				 class="regularxl enterastab" 
				 type="text" 
				 value="#Customer.MobileNumber#" 
				 size="15" maxlength="50" >
		</td>
	</tr>
	
	<tr>
		<td class="labelmedium"><cf_tl id="Phone Number"> :</td>
		<td>
			<cfinput name="PhoneNumber" 
			  onKeyUp="applyCustomerData('#url.mission#','phonenumber',this.value)"
			  id="phonenumber_#mission#" 
			  class="regularxl enterastab" 
			  type="text" 
			  value="#Customer.PhoneNumber#" 
			  size="15" 
			  maxlength="50" >
		</td>
	</tr>
	
	<tr>
		<td class="labelmedium"><cf_tl id="Postal Code"> :</td>
		<td>
		
		 <cf_textInput
					  form      = "customerform"
					  type      = "ZIP"
					  mode      = "regularxl"
					  name      = "PostalCode"
				      value     = "#Customer.PostalCode#"
				      required  = "No"
					  size      = "12"
					  maxlength = "12"
					  label     = "&nbsp;"
					  style     = "width:100px;text-align: center;">		
		
			
		</td>
	</tr>
	
	<!---
	<cfif  url.drillid eq "">
	<tr>
		<td> <cf_tl id="Country"> : </td>
		<td>
			<cfquery name="GetCountry" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT DISTINCT W.Warehouse, N.Name
				FROM   Warehouse W
					   INNER JOIN System.dbo.Ref_Nation N
					   ON W.Country = N.Code
				WHERE  Mission = '#url.mission#'
			</cfquery>
			
			<cfselect name="Warehouse">
				<cfloop query="GetCountry">
					<option value="#Warehouse#"> #Name#
				</cfloop>
			</cfselect>
			
		</td>
	</tr>
	</cfif>
	--->
	
	<tr>
		<td class="labelmedium"><cf_tl id="Credit Threshold"> :</td>
		<td style="height:25px" class="labelmedium">
		
		 <cfinvoke component="Service.Access"  
		     	   method="org" 
				   mission="#Mission#" 
				   returnvariable="access"> 
				   
			   <table><tr>
			    <td>
	   				<cfif access eq "ALL">
						<cfinput type="Text" class="regularxl enterastab" style="width:80;text-align:right;padding-right:4px" name="ThresholdCredit" value="#numberformat(customer.ThresholdCredit,',.__')#">
					<cfelse>
						#numberformat(customer.ThresholdCredit,',.__')#
						<cfinput type="hidden" name="ThresholdCredit" value="#numberformat(customer.ThresholdCredit,',.__')#">
					</cfif>
				</td>
				<td class="labelit" style="padding-left:5px">#application.basecurrency#</td>
				<td style="padding-left:15px" class="labelmedium"><cf_tl id="Current outstanding">#application.basecurrency# :</td>
				
				<cfif customer.customerid neq "">
							
				<cfinvoke component = "Service.Process.Materials.Customer"  
				   method           = "CustomerReceivables" 
				   mission          = "#customer.Mission#" 
				   customerid       = "#customer.CustomerId#"  
				   returnvariable   = "credit">	   
				  			  			
				<td style="padding-left:15px" class="labelmedium">#numberformat(credit.outstanding,",.__")#</td>	
				
				</cfif>
							
				</tr></table>
			
		</td>
	</tr>
	
	<tr>
		<td class="labelmedium"><cf_tl id="Tax Exemption"> :</td>
		<td style="height:30px" class="labelmedium">
		    <table>
			<tr class="labelmedium">
			<td style="padding-left:0px"><input name="TaxExemption" class="radiol enterastab" type="radio" value="1" <cfif Customer.TaxExemption eq 1>checked</cfif>></td>
			<td style="padding-left:4px"><cf_tl id="Yes"></td>
			<td style="padding-left:7px"><input name="TaxExemption" class="radiol enterastab" type="radio" value="0" <cfif Customer.TaxExemption eq 0 or url.drillid eq "">checked</cfif>></td>
			<td style="padding-left:4px"><cf_tl id="No"></td>
			</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class="labelmedium"><cf_tl id="Operational"> :</td>
		<td style="height:30px" class="labelmedium">
			<table>
			<tr class="labelmedium">
			<td style="padding-left:0px"><input name="Operational" class="radiol enterastab" type="radio" value="1" <cfif Customer.Operational eq 1 or url.drillid eq "">checked</cfif>></td>
			<td style="padding-left:4px"><cf_tl id="Yes"></td>
			<td style="padding-left:7px"><input name="Operational" class="radiol enterastab" type="radio" value="0" <cfif Customer.Operational eq 0>checked</cfif>></td>
			<td style="padding-left:4px"><cf_tl id="No"></td>
			</tr>
			</table>			
			
		</td>
	</tr>
	<tr valign="top" style="padding-top:5px">
		<td class="labelmedium"><cf_tl id="Memo">:</td>
		<td>
			<textarea name="Memo" rows="5" style="font-size:13px;padding:4px;width:80%" class="regular enterastab">#Customer.Memo#</textarea>
		</td>
	</tr>
	
	<tr>
		<td colspan="2" height="1"></td>
	</tr>
	
	<tr>
		<td colspan="2" class="line"></td>
	</tr>
		
	<tr>
		<td colspan="2" align="center">
			<table>
				<tr>
					<cfif url.drillid neq "">
						<cfquery name="validatePurge" 
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT 	*
								FROM   	WarehouseBatch
								WHERE  	CustomerId = '#url.drillid#'
								OR		CustomerIdInvoice = '#url.drillid#'
						</cfquery>
						<cfif validatePurge.recordCount eq 0>
							<td style="padding-right:5px;" id="processPurge">
								<cf_tl id="Delete" var="1">
								<cfinput type="button" name="delete" style="width:120" class="button10g" value="#lt_text#" onclick="purgeCustomer('#url.drillid#','processPurge');">
							</td>
						</cfif>
					</cfif>
					<td>
						<cfif url.drillid eq "">
							<cf_tl id="Save" var="1">
							<cfset action = "Save">
						<cfelse>
							<cf_tl id="Update" var="1">
							<cfset action = "Update">
						</cfif>
						<cfinput type="button" name="#action#" style="width:120" class="button10g" value="#lt_text#" onclick="Prosis.busy('yes');_cf_loadingtexthtml='';saveCustomer();">
					</td>
				</tr>
			</table>
		</td>
	</tr>
	
</table>

</cfform>

</cf_divscroll>

<cfset ajaxonload("doCalendar")>

</cfoutput>