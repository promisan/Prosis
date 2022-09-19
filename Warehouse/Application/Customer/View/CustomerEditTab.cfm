
<cfparam name="url.drillid" default="">
<cfparam name="url.scope"   default="">

<cfif url.drillid eq "">

	<cf_screentop height="100%" 
			  scroll        = "Yes" 
			  label         = "New Customer"
			  jQuery        = "yes" 
			  layout        = "webapp" 
			  html          = "No"
			  systemmodule  = "Warehouse" 
			  functionclass = "Window" 
			  functionName  = "Customer Edit" 
			  line          = "no"
			  banner        = "gray">

<cfelse>

		<cfquery name="Customer" 
				 datasource="AppsMaterials" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 
				 SELECT isNull(Reference,'') as Reference, CustomerName, Mission
				 FROM   Customer
				 WHERE  CustomerId = '#url.drillid#'
				 
		</cfquery>

		<cf_screentop height="100%" 
			  scroll="Yes" 
			  label="Edit Customer: #Customer.CustomerName# - #Customer.Reference#" 
			  layout="webapp" 
			  systemmodule="Warehouse" 
			  functionclass="Window" 
			  functionName="Customer Edit" 
			  jQuery="yes"
			  line="no"
			  banner="gray">

		<cf_menuscript>
		
</cfif>
			  
<cfajaximport tags="cfdiv,cfform,cfinput-autosuggest">

<cf_calendarscript>
<cf_dialogstaffing>
<cf_fileLibraryScript>
<cf_listingscript>
<cf_dialogMaterial>

<cf_tl id="Do you want to remove this customer and all of its details ?" var="vPurgeCustomerMess">

<script language="JavaScript">
		
		function saveCustomer(){
		 
			document.customerform.onsubmit() 
			
			if( _CF_error_messages.length == 0 ) {		
			
				var validateReference = document.getElementById('validateReference');
				
				if (validateReference.value == 0){
					alert('Please enter a valid Reference.');
					validateReference.focus();
					return false;
				}							
				
				ptoken.navigate('CustomerSubmit.cfm','contentbox1','','','POST','customerform');
				
			} else { Prosis.busy('no') }
		}
		
		//Address
		function addressentry(customerid) {
    		ptoken.navigate('<cfoutput>#SESSION.root#</cfoutput>/Warehouse/Application/Customer/Address/AddressEntry.cfm?customerid=' + customerid,'addressdetail');
		}
		
		function addressentryvalidate() {
			document.addressform.onsubmit() 
			if( _CF_error_messages.length == 0 ) {            
				ptoken.navigate('<cfoutput>#SESSION.root#</cfoutput>/Warehouse/Application/Customer/Address/AddressEntrySubmit.cfm','addressprocess','','','POST','addressform')
			 }   
		}	 
			
		function addressedit(customerid,addressid) {   
			ptoken.navigate('<cfoutput>#SESSION.root#</cfoutput>/Warehouse/Application/Customer/Address/AddressEdit.cfm?mode=edit&customerid='+customerid+'&addressid=' + addressid,'addressdetail')		
		}

		function addresseditvalidate(action) {
			document.addressform.onsubmit() 	
			if( _CF_error_messages.length == 0 ) {  
			    Prosis.busy('yes')   	    	  
				_cf_loadingtexthtml='';		
				ptoken.navigate('<cfoutput>#SESSION.root#</cfoutput>/Warehouse/Application/Customer/Address/AddressEditSubmit.cfm?action=' + action,'addressprocess','','','POST','addressform')
			 }   
		}
		
		function purgeCustomer(id,target) {
			if (confirm('<cfoutput>#vPurgeCustomerMess#</cfoutput>')) {
				ptoken.navigate('<cfoutput>#SESSION.root#</cfoutput>/Warehouse/Application/Customer/View/CustomerPurge.cfm?id='+id,target);
			}
		}
		
		<cfif url.drillid neq "">
		function getDataByDate(control) {
			ptoken.navigate('<cfoutput>#SESSION.root#/Warehouse/Application/Customer/PriceSchedule/Categories.cfm?customerid=#url.drillid#&mission=#Customer.mission#&dateeffective=</cfoutput>'+document.getElementById(control).value,'divCategories');
		}
		</cfif>


		function displaybatch(thisbatch){
			ptoken.open('<cfoutput>#SESSION.root#</cfoutput>/Warehouse/Application/Stock/Batch/BatchView.cfm?batchno='+thisbatch, '_blank','top=100,left=100,width=1200,height=800,resizable=no');
		}
	
</script>

<table width="100%" height="100%" cellspacing="0" cellpadding="0">

<cfif url.drillid neq "">

	<cfoutput>
	
	<tr><td height="34" style="padding:3px">
	
			<!--- top menu --->
			
			<table width="100%" align="center">		  		
										
				<cfset ht = "58">
				<cfset wd = "58">			
				
				<tr>		
							
						<cfset itm = 0>
						
						<cfset itm = itm+1>			
						<cf_tl id="Details"	var="vDetails">
						<cf_menutab item       = "#itm#" 
						            iconsrc    = "Detail.png" 
									targetitem = "1"
									padding    = "5"
									iconwidth  = "#wd#" 
									iconheight = "#ht#" 
									name       = "#vDetails#"
									class      = "highlight1"
									source 	   = "CustomerEdit.cfm?scope=#url.scope#&drillid=#url.drillid#">														
						
						<cfset itm = itm+1>		
						<cf_tl id="Address"	var="vAddress">
						<cf_menutab item       = "#itm#" 
						            iconsrc    = "Address.png" 
									targetitem = "2"
									padding    = "5"
									iconwidth  = "#wd#" 								
									iconheight = "#ht#"
									name       = "#vAddress#"
									source 	   = "../Address/CustomerAddress.cfm?customerid=#url.drillid#&mission=#Customer.mission#">									
									
						<cfset itm = itm+1>		
						<cf_tl id="Communication"	var="vCommunication">
						<cf_menutab item       = "#itm#" 
						            iconsrc    = "Circulation.png" 
									targetitem = "2"
									padding    = "5"
									iconwidth  = "#wd#" 								
									iconheight = "#ht#"
									name       = "#vCommunication#"
									source 	   = "../Outreach/CustomerOutreach.cfm?customerid=#url.drillid#&mission=#Customer.mission#">				
									
						<cfset itm = itm+1>		
						<cf_tl id="Price Schedule" var="vPriceSchedule">
						<cf_menutab item       = "#itm#" 
						            iconsrc    = "Price.png" 
									targetitem = "3"
									padding    = "5"
									iconwidth  = "#wd#" 								
									iconheight = "#ht#" 
									name       = "#vPriceSchedule#"
									source 	   = "../PriceSchedule/RecordListing.cfm?customerid=#url.drillid#&mission=#Customer.mission#">
									
						<cfset itm = itm+1>		
						<cf_tl id="Quotes"	var="vQuotes">
						<cf_menutab item       = "#itm#" 
						            iconsrc    = "Logos/Warehouse/Pending-Receipts.png" 
									targetitem = "2"
									padding    = "5"
									iconwidth  = "#wd#" 								
									iconheight = "#ht#"
									name       = "#vQuotes#"
									source 	   = "../Quote/QuoteListingContent.cfm?customerid=#url.drillid#&mission=#Customer.mission#">				
									
						<cfset itm = itm+1>		
						<cf_tl id="Sales and Receivables" var="vHistory">
						<cf_menutab item       = "#itm#" 
						            iconsrc    = "Sales-Orders.png" 
									targetitem = "4"
									padding    = "5"
									iconwidth  = "#wd#" 								
									iconheight = "#ht#" 
									name       = "#vHistory#"
									source 	   = "../History/RecordListing.cfm?customerid=#url.drillid#&mission=#Customer.mission#">
									
						<cfset itm = itm+1>		
						<cf_tl id="Customer Advance" var="vAdvance">
						<cf_menutab item       = "#itm#" 
						            iconsrc    = "Logos/Payroll/Entitlement.png" 
									targetitem = "4"
									padding    = "5"
									iconwidth  = "#wd#" 								
									iconheight = "#ht#" 
									name       = "#vAdvance#"
									source 	   = "../../../../Gledger/Inquiry/Advance/ListingCustomer.cfm?customerid=#url.drillid#&mission=#Customer.mission#">			
						
						<cfset itm = itm+1>		
						<cf_tl id="Beneficiaries" var="vBeneficiaries">
						<cf_menutab item       = "#itm#" 
						            iconsrc    = "Dependent.png" 
									targetitem = "4"
									padding    = "5"
									iconwidth  = "#wd#" 								
									iconheight = "#ht#" 
									name       = "#vBeneficiaries#"
									source 	   = "../Beneficiary/RecordListing.cfm?customerid=#url.drillid#&mission=#Customer.mission#">

						 		
					</tr>
			</table>
	
		</td>
	 </tr>
	 </cfoutput>
	 
	<tr><td height="1" colspan="1" class="linedotted"></td></tr>

	<tr><td height="100%" style="padding:6px">
	
	<table width="100%" 	     
		  height="100%"
		  align="center">
			
			<cf_menucontainer item="1" class="regular">
				<cfinclude template="CustomerEdit.cfm">
			</cf_menucontainer>							
			
			<cf_menucontainer item="2" class="hide">			
			<cf_menucontainer item="3" class="hide">				
			<cf_menucontainer item="4" class="hide">			
												
	</table>

	</td></tr>

<cfelse>

	<tr><td id="contentbox1"><cfinclude template="CustomerEdit.cfm"></td></tr>

</cfif>

</table>

<cf_mapscript scope="embed">
<!---
<cfajaximport tags="cfmap" params="#{googlemapkey='#client.googlemapid#'}#">
--->
