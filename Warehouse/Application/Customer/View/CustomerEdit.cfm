
<cfparam name="url.drillid" default="">
<cfparam name="url.mission" default="">
<cfparam name="url.scope"   default="listing">

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
	
	function dosub(cde,val,sel) {
	    _cf_loadingtexthtml='';		
	   	ptoken.navigate('#SESSION.root#/Warehouse/Application/Customer/View/getSubList.cfm?cde='+cde+'&val='+val+'&sel='+sel,'sub_'+cde);

	
	}
</script>

<cf_divscroll style="height:98.5%">

<cfform method="POST"  style="height:98%" name="customerform" onsubmit="return false">

<table width="95%" class="formpadding formspacing" align="center">

	<tr class="hide"><td colspan="2" height="3" id="inputvalidation"></td></tr>
	
	<tr class="labelmedium2">
	<td style="min-width:220px"><cf_tl id="Entity">:</td>
	
	<td>
	
	    <table>
		<tr class="labelmedium2">
	    <td style="font-size:17px">#url.Mission# <cfif customer.CustomerSerialNo neq "">/ <b>#Customer.CustomerSerialNo#</b></cfif></td>	
	    <td style="padding-left:20px"><cf_tl id="Operational"> :</td>
		<td style="height:30px">
		
			<table>
			<tr class="labelmedium2">
			<td style="padding-left:0px"><input name="Operational" class="radiol enterastab" type="radio" value="1" <cfif Customer.Operational eq 1 or url.drillid eq "">checked</cfif>></td>
			<td style="padding-left:4px"><cf_tl id="Yes"></td>
			<td style="padding-left:7px"><input name="Operational" class="radiol enterastab" type="radio" value="0" <cfif Customer.Operational eq 0>checked</cfif>></td>
			<td style="padding-left:4px"><cf_tl id="No"></td>
			</tr>
			</table>			
			
		</td>
		
		</tr>
		</table>
	
	</td>
	</tr>
	
	<tr class="labelmedium2">
		<td width="18%"> <cf_tl id="Reference"> : <font color="red">*</font></td>
		<td>
		
			<input name="Scope"   type="hidden" value="#url.scope#">
		
			<cfif url.drillid eq "">
			    <input name="Action"  type="hidden" value="add">				
				<input name="Mission" type="hidden" value="#url.mission#">
				<cf_AssignId>
				<input name="CustomerId" type="hidden" value="#rowguid#">
				<cfset CustomerId = rowguid>
				<cfset mission    = url.Mission>
			<cfelse>
			    <input name="Action"  type="hidden"    value="edit">
				<input name="Mission" type="hidden"    value="#Customer.Mission#">
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
								 class="regularxxl enterastab"
								 required="Yes"
								 onKeyUp ="_cf_loadingtexthtml='';	ptoken.navigate('ValidateReference.cfm?customerid=#CustomerId#&reference='+this.value+'&mission=#url.mission#','id_validateReference');"
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
	<tr class="labelmedium2">
		<td><cf_tl id="Name"> : <font color="red">*</font></td>
		<td style="width:80%">
			<cfinput name="CustomerName" 
					 type="text" 
					 value="#Customer.CustomerName#" 
					 size="70" 
					 class="regularxxl enterastab"
					 maxlength="80" 
					 required="Yes" 
					 message="Please enter customer name.">
		</td>
	</tr>
	
	<!--- custom information --->
		
	<cfquery name="getTopics" 
		datasource="AppsMaterials"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			
			SELECT	 P.Description,P.SearchOrder, T.*
			FROM     Ref_Topic T INNER JOIN Ref_TopicParent P ON T.Parent = P.Parent							
			WHERE    T.TopicClass = 'Customer'	
			AND      ValueClass IN ('List','Lookup')	
					
	</cfquery>
	
	<cfloop query="getTopics">
			
		 <tr> 
		
			<td width="80" height="23" class="labelmedium2">#TopicLabel#: <cfif ValueObligatory eq "1"><font color="ff0000">*</font></cfif></td>
						
			<cfset tbcl = "CustomerTopic">					
								
			<cfif ValueClass eq "List">
			
				<td>
				
					<cfquery name="GetList" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT	 T.*,
							         <cfif customer.customerid neq "">
							         (SELECT ListCode 
									  FROM CustomerTopic 
									  WHERE Topic = T.Code 
									  AND CustomerId = '#Customer.CustomerId#') as Selected 							      
									 <cfelse> '' as Selected </cfif>									 
							FROM 	 Ref_TopicList T 
							WHERE 	 T.Code = '#Code#'  
							AND      ListCodeParent is NULL
							AND 	 T.Operational = 1
							ORDER BY T.ListOrder ASC
					</cfquery>
				
				<table>
				<tr>
				<td>
				
				<select class="regularxxl" name="Topic_#Code#" ID="Topic_#Code#" onchange="dosub('#Code#',this.value,'#GetList.Selected#')">
					<cfif ValueObligatory eq "0">
						<option value=""></option>
					</cfif>
					<cfloop query="GetList">
						<option value="#GetList.ListCode#" <cfif left(GetList.Selected,2) eq GetList.ListCode>selected</cfif>>#GetList.ListValue#</option>
					</cfloop>
				</select> 
				
				</td>
				
				<td style="padding-left:2px" id="sub_#Code#">
				
				<cfset url.cde = Code>
				<cfset url.val = left(GetList.Selected,2)>
				<cfset url.sel = GetList.Selected>
				
				<cfinclude template="getSubList.cfm">
								
				</td>
				
				</tr>
				</table>
								
				</td>
	
			</cfif>		
			
		</tr>	
			
	</cfloop>		
	
	<cfquery name="Person" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			    FROM   Employee.dbo.Person E
			    WHERE  PersonNo = '#Customer.PersonNo#'			
	</cfquery>
	
	<cfif Person.Recordcount eq "0">
	
		<tr class="labelmedium2">
			<td><cf_tl id="Individual">:</td>
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
														
					<td id="member">
																					
						<input type="text"   name="name"     id="name"  value="#Get.FirstName# #Get.LastName#" style="width:200px;cursor:pointer;padding-left:4px" 
						        textsize="80" maxlength="80" class="enterastab regularxxl" readonly onclick="ShowCandidate('#Customer.PersonNo#')">				
						<input type="hidden" name="personno" id="personno" value="#Customer.PersonNo#" size="10" maxlength="10" readonly>
					
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
									
					<td id="applicant" style="padding-top:1px">
					    <cf_img icon="delete" onclick="document.getElementById('personno').value='';document.getElementById('name').value=''">
					</td>					
												
					</tr>
				</table>		
				
			</td>
		</tr>
	
	<cfelse>
	
		<tr class="labelmedium2">
			<td><cf_tl id="Staff member">:</td>
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
																
					<input type="text" name="name" id="name" value="#Get.FirstName# #Get.LastName#" size="40" maxlength="40" class="enterastab regularxxl" readonly style="padding-left:4px">				
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
					
					<td style="padding-top:1px">
					    <cf_img icon="delete" onclick="document.getElementById('personno').value='';document.getElementById('name').value=''">
					</td>
					
					</cfif>
					
					
					</tr>
				</table>		
				
			</td>
		</tr>
		
	</cfif>	
	
	<tr class="labelmedium2">
		<td><cf_tl id="Organization">:</td>
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
					<input type="text" name="orgname" id="orgname" value="#Get.OrgUnitName#" size="40" maxlength="40" class="enterastab regularxxl" readonly style="padding-left:4px">				
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
					
					<td style="padding-top:1px">
					    <cf_img icon="delete" onclick="document.getElementById('orgunit').value='';document.getElementById('orgname').value=''">
					</td>
					
				</cfif>
				
			</tr>
		</table>					
		</td>
	</tr>
	
	<tr class="labelmedium2">
		<td><cf_tl id="Date of Birth"></td>
		<td>
			<cf_intelliCalendarDate9 FieldName="CustomerDOB"  class="regularxxl enterastab" Message="Please check the birth date"
			Default="#dateformat(Customer.CustomerDOB,'#CLIENT.DateFormatShow#')#" AllowBlank="True">		
		</td>
	</tr>
	
	<tr class="labelmedium2">
		<td><cf_tl id="eMailAddress"> :</td>
		<td>
			<cfinput name="eMailAddress"
			    id="emailaddress_#mission#" 
				 onKeyUp="applyCustomerData('#url.mission#','emailaddress',this.value)"
			    class="regularxxl enterastab" type="text" value="#Customer.eMailAddress#" validate="email" size="60" maxlength="50">
		</td>
	</tr>
	
	<tr class="labelmedium2">
		<td><cf_tl id="Mobile Number"> :</td>
		<td>
			<cfinput name="MobileNumber"
			     id="mobilenumber_#mission#" 
				 onKeyUp="applyCustomerData('#url.mission#','mobilenumber',this.value)" 
				 class="regularxxl enterastab" 
				 type="text" 
				 value="#Customer.MobileNumber#" 
				 size="15" maxlength="50" >
		</td>
	</tr>
	
	<tr class="labelmedium2">
		<td><cf_tl id="Phone Number"> :</td>
		<td>
			<cfinput name="PhoneNumber" 
			  onKeyUp="applyCustomerData('#url.mission#','phonenumber',this.value)"
			  id="phonenumber_#mission#" 
			  class="regularxxl enterastab" 
			  type="text" 
			  value="#Customer.PhoneNumber#" 
			  size="15" 
			  maxlength="50" >
		</td>
	</tr>
	
	<tr class="labelmedium2">
		<td><cf_tl id="Postal Code"> :</td>
		<td>
		
		 <cf_textInput
			  form      = "customerform"
			  type      = "ZIP"
			  mode      = "regularxxl"
			  name      = "PostalCode"
		      value     = "#Customer.PostalCode#"
		      required  = "No"
			  size      = "20"
			  maxlength = "20"
			  label     = "&nbsp;"
			  style     = "width:60px;text-align: center;">		
		
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
	
	<tr class="labelmedium2">
		<td><cf_tl id="Credit Threshold">#application.basecurrency#:</td>
		<td style="height:25px">
		
		 <cfinvoke component="Service.Access"  
		     	   method="org" 
				   mission="#Mission#" 
				   returnvariable="access"> 
				   
			   <table><tr class="labelmedium2">
			    <td>
	   				<cfif access eq "ALL">
						<cfinput type="Text" class="regularxxl enterastab" style="width:80;text-align:right;padding-right:4px" name="ThresholdCredit" value="#numberformat(customer.ThresholdCredit,',.__')#">
					<cfelse>
						#numberformat(customer.ThresholdCredit,',.__')#
						<cfinput type="hidden" name="ThresholdCredit" value="#numberformat(customer.ThresholdCredit,',.__')#">
					</cfif>
				</td>
				
				<td style="padding-left:15px"><cf_tl id="Current outstanding">:</td>
				
				<cfif url.drillid neq "">
							
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
	
	<tr class="labelmedium2">
	    <td><cf_tl id="Payment mode">:</td>
		
		<td style="height:30px">
		    <table>
			<tr class="labelmedium2">
			
			<td>
			
			<cfquery name="Settle" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
			    FROM   Ref_Settlement E
			    WHERE  Operational = 1
			</cfquery>			
									
			   <select class="regularxxl" name="SettleCode" ID="SettleCode">					
					<cfloop query="settle">
						<option value="#Code#" <cfif Customer.SettleCode eq code>selected</cfif>>#Description#</option>
					</cfloop>
				</select> 			
			
			</td>		
			
			<td style="padding-left:20px"><cf_tl id="Tax Exemption"> :</td>
			<td style="padding-left:0px"><input name="TaxExemption" class="radiol enterastab" type="radio" value="1" <cfif Customer.TaxExemption eq 1>checked</cfif>></td>
			<td style="padding-left:4px"><cf_tl id="Yes"></td>
			<td style="padding-left:7px"><input name="TaxExemption" class="radiol enterastab" type="radio" value="0" <cfif Customer.TaxExemption eq 0 or url.drillid eq "">checked</cfif>></td>
			<td style="padding-left:4px"><cf_tl id="No"></td>
			</tr>
			</table>
		</td>
	</tr>
	
	<tr valign="top" style="padding-top:5px" class="labelmedium2">
		<td ><cf_tl id="Memo">:</td>
		<td>
			<textarea name="Memo" style="height:40px;font-size:14px;padding:4px;width:95%" class="regular enterastab">#Customer.Memo#</textarea>
		</td>
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
								<cfinput type="button" name="delete" style="height:35px;width:180" class="button10g" value="#lt_text#" onclick="purgeCustomer('#url.drillid#','processPurge');">
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
						<cfinput type="button" name="#action#" style="height:35px;width:180" class="button10g" value="#lt_text#" onclick="Prosis.busy('yes');_cf_loadingtexthtml='';saveCustomer();">
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