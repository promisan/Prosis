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

<!--- master edit --->

<cfajaximport tags="cfdiv,cfwindow">

<cf_fileLibraryScript>

<cfquery name="Inv" 
datasource="appsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     I.*, 
	           IC.DocumentAmount AS IncomingAmount,
			   IC.ExemptionPercentage,
			   IC.ExemptionAmount,
			   IC.InvoiceIncomingId
	FROM       Invoice I INNER JOIN
    	       InvoiceIncoming IC ON I.Mission = IC.Mission AND I.OrgUnitOwner = IC.OrgUnitOwner AND I.OrgUnitVendor = IC.OrgUnitVendor AND 
	           I.InvoiceNo = IC.InvoiceNo
	WHERE      I.InvoiceId = '#url.invoiceid#'
</cfquery>	


<cfquery name="Currency" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM Currency
</cfquery>

<cfquery name="Parameter" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_ParameterMission
	WHERE Mission = '#Inv.Mission#' 
</cfquery>

<cf_tl id="Incoming Invoice" var="vTitle">

<cf_screentop height="100%" jquery="Yes" scroll="yes" label="#vTitle#" user="No" html="No" layout="webapp" banner="gray">
 
	<cfform name="incomingedit" action="IncomingEditSubmit.cfm?invoiceincomingid=#inv.invoiceincomingid#" method="POST" target="result">
	
		<table width="94%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		
		<tr><td></td></tr>
		
		<tr class="hide"><td colspan="2"><iframe name="result" id="result"></iframe></td></tr>	
		
		<TR>
		      <td height="25" class="labelmedium"><cf_tl id="Amount on Invoice">:</b></td>
		
		      <td colspan="1">	
			  <table border="0" cellspacing="0" cellpadding="0" class="formpadding">
			   <tr><td>
			  
			     <table style="border:1px solid silver" cellspacing="0" cellpadding="0" class="formpadding">
				 <tr>
				 <td width="40" class="labelmedium" align="center">
			     <cfoutput>#Inv.DocumentCurrency# 
				 </td></tr>
				 </table>
				 
				 </td>
				 
				 <cfquery name="Check" 
				datasource="appsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT     *				           
					FROM       Invoice I INNER JOIN
		   	    			   InvoiceIncomingLine IC ON I.Mission = IC.Mission 
							       AND I.OrgUnitOwner = IC.OrgUnitOwner 
								   AND I.OrgUnitVendor = IC.OrgUnitVendor 
								   AND I.InvoiceNo = IC.InvoiceNo
					WHERE      I.InvoiceId = '#url.invoiceid#'
			    </cfquery>	
				 
				 <td style="padding-left:2px">
				 
				 <cfif check.recordcount eq "0">
				  <cfset cl = "regularxl">
				 <cfelse>
				  <cfset cl = "hide">			  
				 </cfif>
				 
				  <cfif Parameter.TaxExemption eq "0">
				  
						   <cf_tl id="Enter a valid amount" var="1" class="message">
						   
						    <cfinput type="Text"
						       name="documentamount"
						       message="#lt_text#"
						       validate="float"
						       required="Yes"
						       visible="Yes"					 
						       enabled="Yes"						       
							   class="#cl# regularxl"
							   value="#NumberFormat(Inv.IncomingAmount,".__")#"
						       maxlength="15"
						       style="text-align: right;">
					   
					   <cfelse>
					   
					   	 <cf_tl id = "Enter a valid amount" var="1" class="message">
					   
					   	 <cfinput type="Text"
						       name="documentamount"
						       message=""
						       validate="float"					   
						       required="Yes"
						       visible="Yes"
						       enabled="Yes"						       
							   class="#cl# regularxl"
							   value="#NumberFormat(Inv.IncomingAmount,".__")#"
						       maxlength="15"
						       style="text-align: right;"
							   onchange  = "ColdFusion.navigate('#SESSION.root#/procurement/application/invoice/InvoiceEntry/InvoiceExemption.cfm?tag=no&documentamount='+this.value+'&tax='+tax.value,'exemption')">
							   
						</cfif>   
								   
			    </cfoutput>
				
			  </td>
			  
			  <td id="documentamounttotal">
			  
			        <cfif check.recordcount gte "1">
					
						<cfquery name="ClearLines" 
							datasource="AppsPurchase" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#"> 					
							    DELETE FROM stInvoiceIncomingLine		
								WHERE InvoiceId = '#inv.InvoiceIncomingId#'								
					    </cfquery>	
					
						<cfquery name="InsertLines" 
							datasource="AppsPurchase" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#"> 	
											
							    INSERT INTO stInvoiceIncomingLine
							
									(InvoiceId, 
									 InvoiceLineId,
									 InvoiceLineNo, 
									 LineDescription, 
									 LineAmount, 
									 LineReference)
									
								SELECT '#inv.InvoiceIncomingId#',
								       InvoiceLineId,
								       LineSerialNo,
									   LineDescription, 
									   LineAmount, 
									   LineReference
									   
								FROM   InvoiceIncomingLine
								WHERE  Mission       = '#Check.Mission#'
								AND    OrgUnitOwner  = '#Check.OrgUnitOwner#'
								AND    OrgUnitVendor = '#Check.OrgUnitVendor#'
								AND    InvoiceNo     = '#Check.InvoiceNo#'	
								
					    </cfquery>	
			   
						<cfquery name="Total" 
							datasource="AppsPurchase" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#"> 					
							    SELECT SUM(LineAmount) as Total 
								FROM   InvoiceIncomingLine		
								WHERE Mission       = '#Check.Mission#'
								AND   OrgUnitOwner  = '#Check.OrgUnitOwner#'
								AND   OrgUnitVendor = '#Check.OrgUnitVendor#'
								AND   InvoiceNo     = '#Check.InvoiceNo#'			
					    </cfquery>	
			
			            <cfoutput>
				  		    <table width="100" style="border:1px solid silver" cellspacing="0" cellpadding="0" align="left" class="formpadding">
							<tr>		
							<td width="120" class="labelmedium" align="right" style="padding-right:3px" bgcolor="ffffcf">
							#numberformat(total.total,"__,__.__")#
							</td></tr>
							</table>	
						</cfoutput>
					
					</cfif>		  
			  
			  </td>
						
			  <td width="2"></td>
																		   
			  <td>
			  			  				   
				   <cfoutput>
				     <cf_tl id ="Specification" var="1">
					 
				     <input type="button" 
					     class="button10g" 
						 style="width:120px;height:27px" 
						 name="Details"
						 id="Details" 
						 value="#lt_text#..."
						 onclick="ptoken.navigate('#SESSION.root#/procurement/application/invoice/invoiceentry/InvoiceEntryLine.cfm?myform=incomingedit&tax='+tax.value+'&mission=#inv.mission#&id=#inv.invoiceincomingid#','linedetail')">
						 
					</cfoutput>	 
						   
			  </td>
			  
			  </tr>
			 
			  </table>
			  
			  </td>		
			  
			  </tr>
			  
			  <tr><td colspan="2" id="linedetail">
			  
			  
			  </td></tr>	  
			  
			  <cfif Parameter.TaxExemption eq "1" or Inv.ExemptionAmount neq "0">
				 
				    <tr>
				  	<TD class="labelmedium"><cf_tl id="Tax Included on Invoice">:</TD>
				    <TD>
						
							<table cellspacing="0" cellpadding="0">
							
								<tr>
								<td>
								 <cf_tl id="Enter a valid percentage" var="1">  		
								<cfinput type="Text" 
								name="tax" 
								value="#inv.ExemptionPercentage*100#"
								message="#lt_text#" 
								validate="float" 
								required="Yes" 
								class="regularxl"
								size="1" 
								style="text-align: center;width:40px" 
								onChange="ptoken.navigate('#SESSION.root#/procurement/application/invoice/InvoiceEntry/InvoiceExemption.cfm?tag=no&documentamount='+documentamount.value+'&tax='+this.value,'exemption')">
								
								</td>
								<td width="19" class="labelmedium" align="center">%</td>													 
					            <td colspan="1" id="exemption">	
							  
							      <cfoutput>
							  			<input type="Text"
									       name="ExemptionAmount"
										   id="ExemptionAmount"
									       message="Enter a valid amount"
									       validate="float"
									       required="Yes"
										   readonly
										   class="regularxl"
										   value="#numberformat(inv.ExemptionAmount,',.__')#"				      
									       size="15"
									       maxlength="15"
									       style="width:100;text-align: right;">
									</cfoutput>	   
										   
								</td>													
								</tr>
							
						  </table>
						
					</TD>
					
					</tr>
															 
			 <cfelse>
			
			    <input type="hidden" name="ExemptionAmount" id="ExemptionAmount" value="0">	
				<input type="hidden" name="tax" id="tax" value="0">	 		 
								 
			 </cfif>
			 
			 <tr><td></td></tr>
			 
			 <tr><td colspan="2" height="1" class="line"></td></tr>
			 
			 <tr><td></td></tr>
			 
			 <tr>
				<td align="center" height="30" colspan="2">
				  <cfoutput>
				  	  <cf_tl id="Save" var="1">
					  <input type="submit" class="button10g" style="width:140px;height:26px" align="center" value="#lt_text#" name="Save" id="Save">
				  </cfoutput>
				</td>
		     </tr>
			 
			 </td></tr>
			 				 
		</table>			
	
	</cfform>