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
<style>
.ygtvlabel img{
    width: 24px!important;
    height: auto;
    vertical-align: middle;
    top: -1px;
    position: relative;
}
span.child-2 {
    font-size: 12px;
}
</style>
<cfquery name="Parameter" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_ParameterMission
	WHERE Mission = '#URL.Mission#' 
</cfquery> 

<cfoutput>

<cf_tl id="Invoice" var="vInvoice">

<cf_UItree
	id="root"
	title="<span style='font-size:16px;color:gray;padding-bottom:3px'>#vInvoice# #url.mission#</span>"	
	expand="Yes">

<cf_tl id="Listing" var="1">     

<cf_UItreeitem value="Listing"
        display="<span style='font-size:17px;padding-top:5px;;padding-bottom:5px;font-weight:bold' class='labelit'>#lt_text#</span>"
		parent="Root"							
        expand="Yes">	
		
	<cf_tl id="Advanced Search" var="1">	 
		
	<cf_UItreeitem value="Advanced"
	        display="<span style='font-size:15px' class='labelit'>#lt_text#</span>"
			parent="Listing"						
			target="right"
			href="InvoiceViewOpen.cfm?ID1=Locate&ID=STA&Mission=#Attributes.Mission#&systemfunctionid=#attributes.systemfunctionid#">	
	
	<cf_tl id="Document Date" var="1">		
	
	<cf_UItreeitem value="Date"
	        display="<span style='padding-top:5px;font-size:15px' class='labelit'>#lt_text#</span>"						
			parent="Listing" Expand="Yes">				
	
	    <cf_tl id="Today" var="1">
			
		<cf_UItreeitem value="Today"
		        display="<span style='font-size:14px' class='labelit'>#lt_text# [#dateformat(now(), CLIENT.DateFormatShow)#]</span>"
				parent="Date"						
				target="right"
				href="InvoiceViewOpen.cfm?ID1=Today&ID=STA&Mission=#Attributes.Mission#&systemfunctionid=#attributes.systemfunctionid#">	
		
		<cf_tl id="This week" var="1">		
		<cf_UItreeitem value="Week"
		        display="<span style='font-size:14px' class='labelit'>#lt_text#</span>"
				parent="Date"					
				target="right"
				href="InvoiceViewOpen.cfm?ID1=Week&ID=STA&Mission=#Attributes.Mission#&systemfunctionid=#attributes.systemfunctionid#">	

		<cf_tl id="This month" var="1">		
		<cf_UItreeitem value="Month"
		        display="<span style='font-size:14px' class='labelit'>#lt_text#</span>"
				parent="Date"							
				target="right"
				href="InvoiceViewOpen.cfm?ID1=Month&ID=STA&Mission=#Attributes.Mission#&systemfunctionid=#attributes.systemfunctionid#">		

    <cf_tl id="Invoice Status" var="1">			
	<cf_UItreeitem value="Status"
	        display="<span style='padding-top:5px;font-size:15px' class='labelit'>#lt_text#</span>"			
			parent="Listing" Expand="Yes">									
		
		<cf_tl id="Incoming" var="1">
		<cf_UItreeitem value="OnHold"
		        display="<span style='font-size:14px' class='labelit'>#lt_text#</SPAN>"
				parent="Status"			
				img="#SESSION.root#/Images/Incoming-blue.png"
				target="right"
				href="InvoiceViewOpen.cfm?ID1=Hold&ID=STA&Mission=#Attributes.Mission#&systemfunctionid=#attributes.systemfunctionid#">	
		
		<cf_tl id="In Circulation" var="1">
		<cf_UItreeitem value="In Process"
		        display="<span style='font-size:14px' class='labelit'>#lt_text#</span>"
				parent="Status"			
				img="#SESSION.root#/Images/Circulation-blue.png"
				target="right"
				href="InvoiceViewOpen.cfm?ID1=Pending&ID=STA&Mission=#Attributes.Mission#&systemfunctionid=#attributes.systemfunctionid#">		
		
		<cf_tl id="Posted" var="1">
		<cf_UItreeitem value="Completed"
		        display="<span style='font-size:14px' class='labelit'>#lt_text#</SPAN>"
				parent="Status"			
				img="#SESSION.root#/Images/Processed-blue.png"
				target="right"
				href="InvoiceViewOpen.cfm?ID1=Completed&ID=STA&Mission=#Attributes.Mission#&systemfunctionid=#attributes.systemfunctionid#">							
		
		<cf_tl id="Voided" var="1">		
		<cf_UItreeitem value="Cancelled"
		        display="<span style='color: RED;font-size:14px' class='labelit'>#lt_text#</font></SPAN>"
				parent="Status"			
				img="#SESSION.root#/Images/Stopped.png"
				target="right"
				href="InvoiceViewOpen.cfm?ID1=Cancelled&ID=STA&Mission=#Attributes.Mission#&systemfunctionid=#attributes.systemfunctionid#">	
		
		<cf_tl id="Purchase class" var="1">			
			
	<cf_UItreeitem value="Purchase"
	        display="<span style='padding-top:5px;font-size:15px' class='labelit'>#lt_text#</span>"					
			parent="Listing" Expand="Yes">		
						
			<cfquery name="Type" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT     *
				FROM       Ref_OrderType
				WHERE      Code IN (SELECT  OrderType
	                                FROM    Purchase
	                                WHERE   Mission = '#URL.Mission#')		
			</cfquery>
			
			<cfloop query="type">
			
				<cf_UItreeitem value="#code#"
			        display = "<span style='font-size:14px' class='labelit'>#Description#</span>"
					parent  = "purchase"			
					img     = "#SESSION.root#/Images/Arrow-Sq-R-blue.png"
					target  = "right"
					href    = "InvoiceViewOpen.cfm?ID1=Purchase&ID=#code#&Mission=#Attributes.Mission#&systemfunctionid=#attributes.systemfunctionid#">	
						
			</cfloop>										

<cf_tl id="Audit" var="1">	
		
<cf_UItreeitem value="audit"
        display="<span style='font-size:17px;padding-top:5px;;padding-bottom:5px;font-weight:bold' class='labelit'>#lt_text#</span>"
		parent="Root"					
        expand="No">
		
		<cf_tl id="Not Matched to Purchase" var="1">	
		
		<cf_UItreeitem value="Match"
	        display="<span style='font-size:14px' class='labelit'>#lt_text#</SPAN>"
			parent="audit"						
			target="right"
			href="InvoiceViewOpen.cfm?ID1=PRM&ID=STA&Mission=#Attributes.Mission#&systemfunctionid=#attributes.systemfunctionid#">			
		
		<cf_tl id="Ledger Posting Inconsistency" var="1">
				
		<cf_UItreeitem value="Cons"
	        display="<span style='font-size:14px' class='labelit'>#lt_text#</SPAN>"
			parent="audit"						
			target="right"
			href="InvoiceViewOpen.cfm?ID1=PRP&ID=STA&Mission=#Attributes.Mission#&systemfunctionid=#attributes.systemfunctionid#">		
			
<cf_tl id="Functions" var="1">			
			
<cf_UItreeitem value="special"
        display="<span style='font-size:17px;padding-top:5px;;padding-bottom:5px;font-weight:bold' class='labelit'>#lt_text#</span>"
		parent="Root"					
        expand="No">	
		
		<cfif Parameter.enableInvTag eq "1">
		
		<cf_UItreeitem value="Tag"
	        display="<span style='font-size:14px' class='labelit'>Pending Tagging</SPAN>"
			parent="Special"			
			img="#SESSION.root#/Images/Tag-blue.png"
			target="right"
			href="InvoiceViewOpen.cfm?ID1=Tagging&ID=TAG&Mission=#Attributes.Mission#&systemfunctionid=#attributes.systemfunctionid#">		
			
		</cfif>		
			
		<cf_UItreeitem value="Post"
	        display="<span style='font-size:14px' class='labelit'>Disbursement reconciliation</span>"
			parent="Special"			
			img="#SESSION.root#/Images/Journal-blue.png"
			target="right"
			href="../Reconcile/ReconcileOpen.cfm?ID1=Reconcile&ID=REC&Mission=#Attributes.Mission#">										
			
			
</cf_UItree>

</cfoutput>		
