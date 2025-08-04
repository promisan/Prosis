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

<cfquery name="Period" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_MissionPeriod
	WHERE  Mission = '#url.mission#'
	AND    Period = '#url.period#'
</cfquery>

<cfquery name="Vendors" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    DISTINCT 
	          VendorCode,
	          VendorName,
			  (SELECT TOP 1 IndexNo FROM Employee.dbo.Person WHERE IndexNo = VendorCode) as IndexNo,			 
			  count(*) as Lines
	FROM      stLedgerIMIS I 
	WHERE     NOVADestination = 'Match'
	    AND   TransactionSerialNo NOT IN
		
	             (SELECT     RI.TransactionSerialNo
			      FROM       stReconciliationIMIS RI INNER JOIN
	                         stReconciliation R ON RI.ReconciliationNo = R.ReconciliationNo 
			 	  AND        (R.Status = 'Complete' OR R.Status = 'Direct') 
			     )
			   
	    AND   Mission = '#URL.Mission#'
		<!--- special for UN --->
		AND   Fund != 'ZTA'
		
	<!----
	Removed by Armin on 3/30/2015
	cfif URL.Mission neq "CMP">
		AND    I.FiscalYear = '#Period.AccountPeriod#'
	cfif	
	----->
	GROUP BY VendorCode,VendorName	
	ORDER BY  VendorName
</cfquery>

	<table width="100%" height="100%" align="center" border="0" class="navigation_table formpadding">
	
	      <tr><td colspan="11" align="left" style="padding-left:4px" class="labellarge"><b>IMIS disbursement Record</td></tr>
		  <tr><td colspan="11" class="linedotted"></td></tr>
		    <cfoutput>
			<tr><td height="25" align="left" colspan="3" class="labelmedium" style="padding-left:4px;padding-right:4px">Vendor/Consultant: </td>
				<td colspan="8">
				   <select name="Vendor" id="Vendor" class="regularxl"
					    size="1" style="width:300"					
	    	    	    onChange="ColdFusion.navigate('ReconcileViewLedgerDetail.cfm?mission=#url.mission#&Period=#url.period#&vendorcode='+this.value,'ledgerbox')">
						<!---	<option value="-1"<cfif #URL.vendorCode# eq "0">selected</cfif>>All</option> --->
					   <option value="">None</option>
						 
					   <cfloop query="Vendors">
					   
					     <cfif Indexno eq "" or len(IndexNo) lt 6>
	    	    	    
						 <option value="#VendorCode#"<cfif URL.vendorCode eq vendorCode>selected</cfif>>
						 		#VendorName# #VendorCode# (#lines#)
						 </option>
						 
						 </cfif>
						
				       </cfloop>	 
	               </SELECT>	
				   
		   		</td>
	 	   </tr>
		   
		   <tr><td height="25" align="left" class="labelmedium" colspan="3" style="padding-left:4px">Staff/Consultant:</td>
			
				<td colspan="8" class="labelmedium">
			
		    	      <select name="Person" id="Person" class="regularxl" style="width:300"
					    size="1" style="color:black"
	    	    	    onChange="ColdFusion.navigate('ReconcileViewLedgerDetail.cfm?mission=#url.mission#&Period=#url.period#&vendorcode='+this.value,'ledgerbox')">
						<!---	<option value="-1"<cfif #URL.vendorCode# eq "0">selected</cfif>>All</option> --->
					   <option value="">None</option>
						 
					   <cfloop query="Vendors">
					   	
						 <cfif Indexno neq "" and len(IndexNo) gte 6>
	    	    	    
						 <option value="#VendorCode#"<cfif URL.vendorCode eq vendorCode>selected</cfif>>
						 	#VendorName# #VendorCode# (#lines#)
						 </option>
						 
						 </cfif>
						
				       </cfloop>	 
	               </SELECT>	
				   </td>
			
			</tr>
			
			</cfoutput>
			
			<tr><td colspan="11" style="padding-left:4px" class="labelsmall">
			<font color="gray">Below you will find a list of ERP/IMIS transactions that need your attention to be reconciliated with NOVA information.
			Please drag these transaction onto the above yellow area and try to match the amount with NOVA transactions</i>
			<br></td></tr>	
			
			<tr><td colspan="11" class="line"></td></tr>
			
			<tr><td colspan="11" height="100%" style="border:0px solid silver;padding-left:10px;padding-right:10px">
			
				<cf_divscroll id="ledgerbox" style="height:100%">				
				
					<cfdiv id="ledgerbox" bind="url:ReconcileViewLedgerDetail.cfm?mission=#url.mission#&Period=#url.period#&vendorcode=#url.vendorcode#">				   		
				
				</cf_divscroll>
			
			</td>
			
			</tr>		
		
	</table>

