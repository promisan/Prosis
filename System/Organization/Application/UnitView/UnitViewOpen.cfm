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
<cfparam name="url.systemfunctionid" default="">

<cfoutput>

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>   

<script language="JavaScript">	

	<cfswitch expression="#URL.ID1#">
	
		<cfcase value="address">							
			{  parent.right.location =  "#SESSION.root#/System/Organization/Application/Address/UnitAddress.cfm?systemfunctionid=#url.systemfunctionid#&ID=#URL.ID#&mid=#mid#" }			
		</cfcase>
	
		<cfcase value="child">		
			{  parent.right.location =  "#SESSION.root#/System/Organization/Application/Children/Children.cfm?systemfunctionid=#url.systemfunctionid#&ID=#URL.ID#&mid=#mid#" }			
		</cfcase>	
		
		<cfcase value="memo">		
			{  parent.right.location =  "#SESSION.root#/System/Organization/Application/Memo/MemoView.cfm?systemfunctionid=#url.systemfunctionid#&ID=#URL.ID#&mid=#mid#" }	
		</cfcase>
			
		<cfcase value="category">		
			{  parent.right.location =  "#SESSION.root#/System/Organization/Application/Category/CategoryView.cfm?systemfunctionid=#url.systemfunctionid#&ID=#URL.ID#&mid=#mid#" }						  
		</cfcase>
		
		<cfcase value="threshold">		
			{  parent.right.location =  "#SESSION.root#/System/Organization/Application/Threshold/ThresholdListing.cfm?systemfunctionid=#url.systemfunctionid#&ID=#URL.ID#&mid=#mid#" }						  
		</cfcase>
		
		<cfcase value="purchase">		
			{  parent.right.location =  "#SESSION.root#/System/Organization/Application/OrganizationPurchase.cfm?systemfunctionid=#url.systemfunctionid#&ID1=VED&ID=#URL.ID#&mid=#mid#"	}									
		</cfcase>	
		
		<cfcase value="Account">	
			{  parent.right.location =  "#SESSION.root#/System/Organization/Application/BankAccount/OrganizationBankAccount.cfm?systemfunctionid=#url.systemfunctionid#&ID1=ACC&ID=#URL.ID#&mid=#mid#" }								
		</cfcase>	
		
		<cfcase value="Invoice">		
			{  parent.right.location =  "#SESSION.root#/System/Organization/Application/AP/InvoiceListing.cfm?systemfunctionid=#url.systemfunctionid#&ID1=ACC&ID=#URL.ID#&mid=#mid#" }									
		</cfcase>	
		
		<cfcase value="InvoiceAP">		
			{  parent.right.location =  "#SESSION.root#/System/Organization/Application/AP/APListing.cfm?systemfunctionid=#url.systemfunctionid#&ID1=ACC&ID=#URL.ID#&mid=#mid#" }									
		</cfcase>	
		
		<cfcase value="InvoiceAPpayment">		
			{	parent.right.location =  "#SESSION.root#/System/Organization/Application/AP/PaymentListing.cfm?systemfunctionid=#url.systemfunctionid#&ID1=ACC&ID=#URL.ID#&mid=#mid#" }									
		</cfcase>	
					
		<cfcase value="InvoiceAR">		
			{	parent.right.location =  "#SESSION.root#/System/Organization/Application/AR/InvoiceListing.cfm?systemfunctionid=#url.systemfunctionid#&ID1=ACC&ID=#URL.ID#&mid=#mid#" }									
		</cfcase>	
		
		<cfcase value="InvoiceARreceipt">		
			{   parent.right.location =  "#SESSION.root#/System/Organization/Application/AR/ReceiptListing.cfm?systemfunctionid=#url.systemfunctionid#&ID1=ACC&ID=#URL.ID#&mid=#mid#" }									
		</cfcase>	
	
	</cfswitch>
	
</script>	

</cfoutput>

