
<cfparam name="url.drillid" default="">

<cfif url.drillid eq "">

	<cf_screentop height="100%" 
			  scroll="Yes" 
			  label="New Customer"
			  jQuery="yes" 
			  layout="webapp" 
			  systemmodule="Warehouse" 
			  functionclass="Window" 
			  functionName="Customer Edit" 
			  line="no"
			  banner="gray">

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
			  
<cfajaximport tags="cfdiv,cfform">

<cf_calendarscript>
<cf_dialogstaffing>
<cf_fileLibraryScript>
<cf_listingscript>

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
			}
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
			window.open('<cfoutput>#SESSION.root#</cfoutput>/Warehouse/Application/Stock/Batch/BatchView.cfm?batchno='+thisbatch, '_blank','top=100,left=100,width=1200,height=800,resizable=no');
		}
	
</script>

<table width="100%" height="100%" cellspacing="0" cellpadding="0">

<cfif url.drillid neq "">

	<cfoutput>
	
	<tr><td height="34" style="padding:3px">
	
			<!--- top menu --->
			
			<table width="100%" border="0" align="center" cellspacing="0" cellpadding="0">		  		
										
				<cfset ht = "64">
				<cfset wd = "64">			
				
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
									source 	   = "CustomerEdit.cfm?drillid=#url.drillid#">
														
						
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
						<cf_tl id="Sales Orders" var="vHistory">
						<cf_menutab item       = "#itm#" 
						            iconsrc    = "Sales-Orders.png" 
									targetitem = "4"
									padding    = "5"
									iconwidth  = "#wd#" 								
									iconheight = "#ht#" 
									name       = "#vHistory#"
									source 	   = "../History/RecordListing.cfm?customerid=#url.drillid#&mission=#Customer.mission#">
						
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


							<td width="15%"></td>								 		
					</tr>
			</table>
	
		</td>
	 </tr>
	 </cfoutput>
	 
	<tr><td height="1" colspan="1" class="linedotted"></td></tr>

</cfif>

<tr><td height="100%" style="padding:10px">
	
	<table width="100%" 
	      border="0"
		  height="100%"
		  cellspacing="0" 
		  cellpadding="0" 
		  align="center" 
	      bordercolor="d4d4d4">
			
			<cf_menucontainer item="1" class="regular">
				<cfinclude template="CustomerEdit.cfm">
			</cf_menucontainer>							
			
			<cf_menucontainer item="2" class="hide">			
			<cf_menucontainer item="3" class="hide">				
			<cf_menucontainer item="4" class="hide">			
												
	</table>

</td></tr>

</table>

<cf_mapscript scope="embed">
<!---
<cfajaximport tags="cfmap" params="#{googlemapkey='#client.googlemapid#'}#">
--->
