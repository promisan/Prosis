<cfform action="InvoiceMatchSubmit.cfm?ID=#URL.ID#&html=#url.html#" style="min-width:1200px" method="POST" name="invoice">

<table style="width:1200px" width="100%" align="center">

<tr><td style="padding-top:4px;padding-left:10px;padding-right:10px;min-width:920"></td>

		<table width="96%" align="center">
						  
		  <tr>
		   <td colspan="5">
		   		  
		     <table width="100%" cellspacing="0" cellpadding="0">
			 
			 <tr class="labelmedium2 line" style="height:20px">
		  
		  	 <td style="min-width:100px;max-width:100;padding-left:12px"><cf_tl id="Received">:</td>			 
			 <td><cfoutput>#dateformat(InvoiceIncoming.DocumentDate,CLIENT.DateFormatShow)#</cfoutput></td>			 
			 
			  <td style="padding-left:24px"><cf_tl id="Recorded">:</td>
				
				 <td>
				 
				 <cfoutput>#dateformat(InvoiceIncoming.Created,CLIENT.DateFormatShow)# #timeformat(InvoiceIncoming.Created,"HH:MM")# (#InvoiceIncoming.OfficerLastName#)</cfoutput>
				 
				 </td>
				
					 <td style="padding-left:4px;font-weight:bold;font-size:20px">
					 
					   					  
					  	 <cfif invoice.actionStatus eq "0">
						   <font size="3" color="#008000"><cf_tl id="In Process"></font></b>	  
					    <cfelseif invoice.actionStatus gte "1" and invoice.actionStatus neq "9">
						    <font size="3" color="green"><cf_tl id="Processed">
							<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/validate.gif" 
							   align="absmiddle" 
							   alt="" 
							   border="0">			
							</font>
						  <cfelse><font size="3" color="red">
							<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/stop2.jpg" 
							   align="absmiddle" 
							   alt="" 
							   border="0">
							  <font color="red"><cf_tl id="Voided"></font>
						  </cfif>	
					  
					 
					 </td>
			 
			 
			 <td align="right" style="padding-right:10px;padding-top:0px;width:70" valign="top">
			 
			 		<cfoutput>
					
						<table><tr><td>
				       			 
						<img src="#SESSION.root#/Images/mail.png"
					     alt="eMail Routing Slip Invoicing Procedures"
					     border="0"
						 height="25px"
						 width="25px"
					     align="bottom"
					     style="cursor: pointer;"
						 onClick="printout('mail','#URL.ID#')">
						 
						</td>
						<td style="padding-left:10px;padding-right:8px"> 
					    
						<img src="#SESSION.root#/Images/print_gray.png" 
						 style="cursor: pointer;" onclick="printout('print','#URL.ID#')"
						 alt="Print Routing Slip Invoicing Procedures" 
						 height="19"
						 border="0" align="absmiddle">		
						 
						 </td></tr></table>			   
					  		   
					</cfoutput>		
			 
			 </td>
			 
			 
			 </tr>
			 
			 <!---
			 
			 <tr>
			 
				 <td class="labelmedium2" style="padding-left:24px"><cf_tl id="Recorded">:</td>
				 <td colspan="3" class="labelmedium2">
				 
				 <table><tr class="labelmedium2"><td>
				 
				 <cfoutput>#dateformat(InvoiceIncoming.Created,CLIENT.DateFormatShow)# #timeformat(InvoiceIncoming.Created,"HH:MM")# (#InvoiceIncoming.OfficerLastName#)</cfoutput>
				 
				 </td>
				
					 <td style="padding-left:4px">
					 
					    [
					  
					  	 <cfif invoice.actionStatus eq "0">
						   <font face="Calibri" size="3" color="#008000"><cf_tl id="In Process"></font></b>	  
					    <cfelseif invoice.actionStatus gte "1" and invoice.actionStatus neq "9">
						    <font  face="Calibri" size="3" color="green"><cf_tl id="Processed">
							<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/validate.gif" 
							   align="absmiddle" 
							   alt="" 
							   border="0">			
							</font>
						  <cfelse><font  face="Calibri" size="3" color="red">
							<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/stop2.jpg" 
							   align="absmiddle" 
							   alt="" 
							   border="0">
							  <font size="2" color="red"><cf_tl id="Voided"></font>
						  </cfif>	
					     ]
					 
					 
					 </td>
				 
				 </tr>
				 
				 </table>
			  
		     </tr>
			 
			 --->
			 
		   <tr class="labelmedium2 line" style="height:20px">		   	   
		  
		   <td style="min-width:143px;max-width:143;padding-left:12px"><cf_UIToolTip  tooltip="The unit of which the workflow processors (workgroup) have been granted access to"><cf_tl id="Owner">:</cf_UIToolTip><font color="FF0000">*</font></td>
					 
				 <td colspan="4">				 
				 		   
		    		<!--- HERE select the owner --->
					  
					<cfquery name="Mandate" 
					  datasource="AppsOrganization" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					      SELECT  *
					      FROM     Ref_MissionPeriod
					   	  WHERE    Mission = '#Invoice.Mission#'
						  AND      Period  = '#Invoice.Period#'				
					</cfquery>
			 
					<!--- show only the last parent org structure --->
					 <cfquery name="Owner" 
					  datasource="AppsOrganization" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					      SELECT    DISTINCT TreeOrder,OrgUnitName,OrgUnit,OrgUnitCode 
					      FROM      #Client.LanPrefix#Organization
					   	  WHERE     (
						             ParentOrgUnit is NULL OR ParentOrgUnit = '' OR 
						             Autonomous = 1 OR 
									 OrgUnit = '#Invoice.OrgUnitOwner#'
									)							 
						  AND       Mission     = '#Mandate.Mission#'
						  AND       MandateNo   = '#Mandate.MandateNo#'
						  
						  <cfif getAdministrator(mandate.mission) eq "1">		 
						 	  
							  <!--- no filtering as user is a (local) administrator --->
			 
						  <cfelse>
						  AND       ( 
						            OrgUnit IN (SELECT OrgUnit 
						                        FROM   Organization.dbo.OrganizationAuthorization 
												WHERE  Role = 'ProcApprover' 
												AND    UserAccount = '#session.acc#' 
												AND    AccessLevel != '0') 
									OR 
									OrgUnit = '#Invoice.OrgUnitOwner#' 
									OR
									Mission IN (SELECT Mission 
						                        FROM   Organization.dbo.OrganizationAuthorization 
												WHERE  Role = 'ProcApprover' 
												AND    OrgUnit is NULL
												AND    UserAccount = '#session.acc#' 
												AND    AccessLevel != '0') 
									)			
						  </cfif>			
						  
						  
						  ORDER BY  TreeOrder, OrgUnitName
					 </cfquery>					 
					 
					 <table><tr><td class="labelmedium2">
					 
					  <cfif invoice.actionStatus eq "0">
					 			 
					  <select name="OrgUnitOwner" id="OrgUnitOwner" class="regularxl" style="border:0px;border-left:1px solid silver;border-right:1px solid silver;height:25px;font-size:14px;width:230px;"
				          onChange="ColdFusion.navigate('InvoiceMatchOrgUnit.cfm?id=<cfoutput>#InvoiceIncoming.InvoiceIncomingId#</cfoutput>&field=owner&orgunit='+this.value,'unitprocess')">
						  
						<cfif Owner.recordcount eq "0">  
					     <option value="">--- <cf_tl id="select"> ---</option>
						 </cfif>
					    <cfoutput query="Owner">
		     		   	  <option value="#OrgUnit#" <cfif Invoice.OrgUnitOwner eq OrgUnit>selected</cfif>>#OrgUnitName#</option>
		         	    </cfoutput>  
		              </select>	
					  
					  <cfelse>
					  
					  <cfquery name="Org" 
							  datasource="AppsOrganization" 
							  username="#SESSION.login#" 
							  password="#SESSION.dbpw#">
							      SELECT   *
							      FROM     Organization
							   	  WHERE    OrgUnit  = '#Invoice.OrgUnitOwner#'								 
							 </cfquery>
							 
							 <cfoutput>#Org.OrgUnitName#</cfoutput>			
					  
					  
					  </cfif>
					  
					  </td>
					  
					  <td class="labelit" style="padding-left:40px"><cf_tl id="Center">:</td>
					  <td class="labelmedium2" style="padding-left:20px">
					  
					     <cfif invoice.actionStatus eq "0">
					  
					  	 <cfquery name="Center" 
							  datasource="AppsOrganization" 
							  username="#SESSION.login#" 
							  password="#SESSION.dbpw#">
							      SELECT   TreeOrder, OrgUnitName, OrgUnit, OrgUnitCode 
							      FROM     #Client.LanPrefix#Organization
							   	  WHERE    Mission     = '#Mandate.Mission#'
								  AND      MandateNo   = '#Mandate.MandateNo#'
								  ORDER BY HierarchyCode
							 </cfquery>
							 
						    <select name="OrgUnitCenter" id="OrgUnitCenter" class="enterastab regularxl" style="border:0px;border-left:1px solid silver;border-right:1px solid silver;height:25px;font-size:14px;width:230px;"
							 onChange="ColdFusion.navigate('InvoiceMatchOrgUnit.cfm?id=<cfoutput>#url.id#</cfoutput>&field=center&orgunit='+this.value,'unitprocess')">>
						    <cfoutput query="Center">
			     		     	  <option value="#OrgUnit#" <cfif Invoice.OrgUnit eq OrgUnit>selected</cfif>>#OrgUnitName#</option>
			         	    </cfoutput>  
			              </select>	
						  
						  <cfelse>
						  
						  	<cfquery name="Org" 
							  datasource="AppsOrganization" 
							  username="#SESSION.login#" 
							  password="#SESSION.dbpw#">
							      SELECT   *
							      FROM     Organization
							   	  WHERE    OrgUnit  = '#Invoice.OrgUnit#'								 
							 </cfquery>
							 
							 <cfoutput>#Org.OrgUnitName#</cfoutput>						  
						  
						  </cfif>
					  
					  </td>
					  
					  <td id="unitprocess"></td>
					  
					  </tr></table>
					   							 
				 </td>		
				 
				 <td></td>		 
		  
		  </tr>		
		  		  								  
		  </table>
		  
		  </td>
		  </tr>					  		 		  		  
		 		  
		    <cfoutput>
			
				<cf_tl id="Invoice Matching" var="matchlabel">
				<cf_tl id="Incoming Invoice" var="matchincoming">
					    
				<script language="JavaScript">
				
				   function edit() {
				   					   
						ProsisUI.createWindow('mydialog', '#matchlabel#', '',{x:100,y:100,height:700,width:870,modal:true,center:true})    						 				
						ptoken.navigate('#SESSION.root#/Procurement/Application/Invoice/Workflow/MarkDown/MarkDownView.cfm?invoiceid=#url.id#','mydialog') 						
									
				   }
			   								
				   function editincoming() {			    
				   
						ProsisUI.createWindow('mydialogs', '#matchincoming#', '',{x:100,y:100,height:700,width:870,modal:true,center:true})    									
						ptoken.navigate('#SESSION.root#/Procurement/Application/Invoice/InvoiceEntry/IncomingView.cfm?invoiceid=#url.id#','mydialogs') 	

					  }
					 
					
			    </script>
			
			
			</cfoutput>
			<cf_dialogLedger>
			<cf_dialogStaffing>
		    
		  <tr>		        
			<td colspan="6" id="invoicedetail">					
			       <cfinclude template="InvoiceMatchDetail.cfm">				
			</td>		
		  </tr>   
		  	  
		  <!--- ---------------------- --->
		  <!--- ------tagging--------- --->
		  <!--- ---------------------- --->
			  	 
		  <cfif parameter1.EnableInvTag eq "1" and operational eq "1">
					
		    <!--- embed the labeling script --->
		
				<cfquery name="DELETE" 
				datasource="AppsLedger">
					DELETE FROM FinancialObject 
					WHERE  EntityCode = 'INV'
					AND    OfficerUserId = '#SESSION.acc#'
					AND    ObjectKeyValue4 NOT IN (
					                               SELECT InvoiceId 
				                                   FROM   Purchase.dbo.Invoice
												   )									
				</cfquery>	
									
					<cf_ObjectListingScript entitycode="INV"> 
					
					<tr class="line"><td colspan="6" id="label" align="center" style="padding-left:15px">			
						
						  <cf_ObjectListing 
						    TableWidth       = "98%"
							Label            = "Yes"
						    EntityCode       = "INV"
							ObjectReference  = "Invoice"
							ObjectKey        = "#Invoice.invoiceId#"
							Mission          = "#Invoice.Mission#"
							Amount           = "#Invoice.DocumentAmount#" 
							Entry            = "#parameter1.InvTagMode#"
							Object           = "Purchase.dbo.RequisitionLineFunding"  
							Currency         = "#APPLICATION.BaseCurrency#">					
													
						</td>
					</tr>  							
																	
			</cfif>	 		
		  
		  <!--- ---------------------- --->
		  <!--- receipt matching lines --->
		  <!--- ---------------------- --->
				
			<cfif InvoiceIncoming.InvoiceClass neq "Warehouse">
					
				<cfif Action.ReceiptEntry eq "1" or Action.ReceiptEntry eq "0">
				
						<cfinclude template="InvoiceMatchReceiptLines.cfm">
				
				</cfif>
				
			<cfelse>
			
			   <tr><td align="center" height="30" style="padding-left:13px;padding-bottom:5px">	
			   
			       <!--- in this mode we have an invoice created for internal issuances, which we
				   call the fuel provider mode in which an payable is generated for in the ystem
				   recorded issuances (mode external) 
				   
				   In this mode the invoice will be associated and paid from a single purcahse --->
			      
				   <cfinclude template="InvoiceMatchWarehouseLines.cfm">		  	   
				   </td>
			   </tr>
			
			</cfif>	
			  		
			<!--- -------------------------------------- --->				 		  
			<!--- routing applied for enabled types only --->
			<!--- -------------------------------------- --->
			  			
			<cfif Action.InvoiceWorkflow eq "1">
					
					<cfquery name="Check" 
					datasource="AppsOrganization">
						SELECT * 
						FROM   Ref_EntityClass
						WHERE  EntityCode  = 'ProcInvoice'
						AND    EntityClass = '#Invoice.EntityClass#'							
					</cfquery>	
								
					<cfif check.recordcount eq "0" and Invoice.HistoricInvoice eq "0">
									
						<tr><td height="3"></td></tr>
										
						<tr><td colspan="6" align="center" class="labelmedium2" style="font-size:15">
							<font size="1" color="000000"><cf_tl id="Attention">:</font>
							<cfif Invoice.ActionStatus neq "9">
							<font color="6688aa"><cf_tl id="This invoice is on hold">.</font>
							<cfelse>
							<cfoutput>
							<font color="red"> <cf_tl id="This invoice has been voided on"> #dateformat(Invoice.ActionStatusDate,CLIENT.DateFormatShow)# (#Invoice.ActionStatusUserId#).</font>
							</cfoutput>
							</cfif>
						</td></tr>				
						
						<cfif Invoice.ActionStatus neq "9">
													
							<tr><td>
							<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center" style="border:1px dotted silver" class="formpadding">
							    <cfset url.mission = invoice.mission>
							    <cfinclude template="../InvoiceEntry/InvoiceRouting.cfm">						
							</table>
							</td></tr>	
												
						</cfif>
							
										
					</cfif>
								
			</cfif>	
				
			<!--- ------------ --->
			<!--- context memo --->
			<!--- ------------ --->
			
			<tr>	 
			
			<td colspan="6" style="padding-top:8px;padding-left:20px"> 
			
				    <table width="99%" border="0" cellspacing="0" cellpadding="0" align="center">
			
					<tr>
						<td class="labelmedium2">
						
						<cfoutput>
						
						   <img src="#SESSION.root#/Images/arrowright.gif" alt="Expand" onclick="javascript:more('#url.id#')" 
						     align="absmiddle" 
							 border="0" 
							 style="cursor: pointer;"
							 class="show" 
							 id="vExp">
							 
						   <img src="#SESSION.root#/Images/arrowdown.gif" 
						      alt="Record and view additional comments and remarks" 
							  onclick="javascript:more('#url.id#')" 
							  border="0" 
							  height="9" width="9"
							  style="cursor: pointer;"
							  class="hide" 
							  id="vMin">
							  
							 </td>
							 
							 <td class="labelmedium2" style="font-weight:200;font-size:20px"> 
							  
							  <a href="javascript:more('#url.id#')" title="Record and view additional comments and remarks">
							  <font color="0080C0"><cf_tl id="Additional Comments and Remarks"></font>	
							  </a>
							  
							 </td> 
							  					
						</cfoutput>
			
					</tr>
					
					<tr id="bcomments" class="hide">
						<td colspan="2">
							<cfdiv id="icomments"/>
						</td>
					</tr>	
			
				</table>		
			
		</td> 
		</tr>
		
		<cfif Action.InvoiceWorkflow eq "1">
		
		    <!--- show the workflow for processing --->
			
			<cfquery name="WF" 
				datasource="AppsOrganization">
				SELECT * 
				FROM   OrganizationObject
				WHERE  ObjectKeyValue4 = '#Invoice.InvoiceId#'	
				AND    Operational = 1						
			</cfquery>	
			
			<!--- added pointer to detect if anything is missing in the invoice right now used
			only for invalid mappings for the invoice only to the requisition --->		
			
										
			<cfif documententrystatus eq "1">		
													
				<cfif (dateformat(Invoice.Workflowdate,client.dateSQL) lte now() and Invoice.workflowdate neq "")
				        or WF.recordcount eq "1" 
						or Invoice.EntityClass neq "">
									
				<tr><td colspan="2" style="padding-left:7px;padding-right:7px">
						 			
					<cfif Invoice.HistoricInvoice eq "0">
					
						<cfset wflnk = "InvoiceMatchWorkflow.cfm">
		   
		                <cfoutput>
						
					    <input type="hidden" 
					          name="workflowlink_#url.id#" 
							  id="workflowlink_#url.id#"
					          value="#wflnk#"> 
							  
						<input type="hidden" 
				               name="workflowlinkprocess_#url.id#" 
							   id="workflowlinkprocess_#url.id#"
							   onclick="ColdFusion.navigate('InvoiceMatchDetail.cfm?id=#url.id#','invoicedetail')">
		        			  
						</cfoutput>	  
		 
					      <cfdiv id="#url.id#">
						      <cfset url.ajaxid = url.id>
							  <cfinclude template="InvoiceMatchWorkflow.cfm">
						  </cfdiv>   
						
					</cfif>	
									
				</td></tr>
											
				</cfif>
			
			</cfif>
										
			<cfif parameter1.EnableInvTag eq "1" and AccessReq eq "EDIT">
				
			<tr><td height="5"></td></tr>
			
		    <!--- embed the labeling script --->
		
				<cfquery name="DELETE" 
				datasource="AppsLedger">
					DELETE FROM FinancialObject
					WHERE EntityCode = 'INV'
					AND   OfficerUserId = '#SESSION.acc#'
					AND   ObjectKeyValue4 NOT IN (SELECT InvoiceId FROM Purchase.dbo.Invoice)									
				</cfquery>	
				
				<cfif Invoice.HistoricInvoice eq "0">
						
					<cf_ObjectListingScript entitycode="INV"> 
					<tr><td colspan="2" id="label" align="center">
							
						  <cf_ObjectListing 
						    TableWidth       = "98%"
							Label            = "Yes"
						    EntityCode       = "INV"
							ObjectReference  = "Invoice"
							ObjectKey        = "#Invoice.invoiceId#"
							Mission          = "#Invoice.Mission#"
							Amount           = "#Invoice.DocumentAmount#" 
							Entry            = "#parameter1.InvTagMode#"
							Object           = "Purchase.dbo.RequisitionLineFunding"  
							Currency         = "#APPLICATION.BaseCurrency#">						
						
						</td>
					</tr>  
				
				</cfif>
										
			</cfif>	 	
						
			<cfif invoice.historicInvoice eq "1" and AccessReq eq "EDIT">
				
			<tr><td height="5"></td></tr>
			
		    	<!--- embed the labeling script --->
		
				<cfquery name="DELETE" 
				datasource="AppsLedger">
					DELETE FinancialObject
					FROM   FinancialObject K
					WHERE  EntityCode    = 'INV'
					AND    OfficerUserId = '#SESSION.acc#'
					AND    ObjectKeyValue4 NOT IN (SELECT InvoiceId FROM Purchase.dbo.Invoice WHERE InvoiceId = K.ObjectKeyValue4)									
				</cfquery>
												
				<cf_ObjectListingScript entitycode="INV"> 
				
				<tr><td colspan="2" id="label" align="center">
							
					  <cf_ObjectListing 
					    TableWidth       = "98%"
						Label            = "Yes"
					    EntityCode       = "INV"
						ObjectReference  = "Invoice"
						ObjectKey        = "#Invoice.invoiceId#"
						Mission          = "#URL.Mission#"
						Amount           = "#Invoice.DocumentAmount#" 
						Entry            = "#parameter1.InvTagMode#"
						Object           = "Purchase.dbo.RequisitionLineFunding"  
						Currency         = "#APPLICATION.BaseCurrency#">
					
					</td>
				</tr>  
																
			</cfif>	 
				
												
			<tr>
			<td class="line" height="35" colspan="6" align="center" style="border-top:1px solid silver">
			
				<cfquery name="HeaderLedger" 
			    datasource="AppsLedger" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				    SELECT * 
					FROM   TransactionHeader
					WHERE  ReferenceId = '#URL.ID#' 
				</cfquery>						
							
				<!--- do not allow deletion if the transaction was already partially processed = paid --->
							
				<cfif HeaderLedger.Amount eq HeaderLedger.AmountOutstanding 
				     and invoice.historicInvoice eq "0" 
					 and (AccessReq eq "EDIT" or AccessReq eq "ALL")>
					
					<cfform action="InvoiceMatchSubmit.cfm?ID=#URL.ID#&html=#url.html#" method="POST" name="invoice">
									
					<table cellspacing="0" cellpadding="0" class="formspacing">				
					<tr>				
						<cfif Invoice.ActionStatus neq "9">
							<td><input type="submit" class="button10g" name="Cancel" id="Cancel" value="Void" onclick="return ask('void')"></td>
						<cfelseif AccessReq eq "ALL">
							<td><input type="submit" class="button10g" name="Reinstate" id="Reinstate" value="Reinstate" onclick="return ask('reinstate')"></td> 				
						</cfif>				
						<td><input type="submit" class="button10g" name="Purge" id="Purge" value="Delete" onclick="return ask('delete')"></td>				
						
					</tr>				
					</table>
					
					</cfform>
					
				</cfif>				
			
		    </td>
			</tr>
					
		</cfif>		
			 
		</table>
			
	</td>
	</tr>
	
</table>


</cfform>