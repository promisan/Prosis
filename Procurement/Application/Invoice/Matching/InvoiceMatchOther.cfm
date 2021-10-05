			
<cfquery name="Other" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
     SELECT * 
     FROM   Invoice
     WHERE  Mission       = '#InvoiceIncoming.Mission#'
	   AND  OrgUnitVendor = '#InvoiceIncoming.OrgUnitVendor#'
	   AND  InvoiceNo     = '#InvoiceIncoming.InvoiceNo#'
	<!---
	AND  InvoiceId    != '#URL.ID#'
	--->
</cfquery>	

<cfquery name="Parameter1" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_ParameterMission
	WHERE  Mission = '#Invoice.Mission#' 
</cfquery>  
	
<!--- ------------------------------ --->
<!--- show related invoice instances --->
<!--- ------------------------------ --->
			
<cfif Other.recordcount gt "1">			
	
	     <table width="100%" style="border:1px solid d4d4d4" class="navigation_table">
								 
	     <cfoutput query="Other">
		 
		 <cf_fileLibraryCheck			    	
			DocumentPath="#Parameter1.InvoiceLibrary#"
			SubDirectory="#InvoiceId#" 
			Filter="">	
		 
		 <cfif InvoiceId eq URL.ID>
		 <tr bgcolor="ffffaf" class="line labelmedium2">	
		 <cfelse>
	     <tr bgcolor="f4f4f4" class="line labelmedium2 navigation_row">	
		 </cfif>
		 
		 <td style="padding-left:4px;background-color:e6e6e6" width="20">#InvoiceSerialNo#.</td>
		 
		 <td style="padding-left:4px;padding-right:4px;height:22px;width:40px;">
		 			 
		   <cfif files gte "1">
		   
			   <img src="#SESSION.root#/Images/arrowright.gif" alt="Expand" onclick="javascript:moreattachments('#InvoiceId#','#currentrow#','#mission#')" 
			     align="absmiddle" 
				 border="0" style="cursor: pointer;" class="show" id="vExp_#currentrow#">
		 
			   <img src="#SESSION.root#/Images/arrowdown.gif" 
			      alt="Collapse" 
				  onclick="javascript:moreattachments('#InvoiceId#','#currentrow#','#mission#')" 
				  border="0" style="cursor: pointer;" class="hide" id="vMin_#currentrow#">
			  
			</cfif> 
			 						  
		 </td> 				 
		
		 <td>
		 	<cfif files gte "1">
			 <a title="recorded" href="javascript:moreattachments('#InvoiceId#','#currentrow#','#mission#')">
			 </cfif>
			 #dateformat(created,CLIENT.DateFormatShow)#</a>
		 </td>
		 
		 <td width="20" style="padding-top:2px">
		 
		 <cfif InvoiceId neq URL.ID>
		 
		  <cf_img icon="edit" onClick="javascript:invoiceedit('#InvoiceId#')" tooltip="Open Payable">
		 		 
		 </cfif> 
		  
		 </td>
		 <td>#OfficerFirstName# #OfficerLastName#</td>
		 <td>#dateformat(documentDate,CLIENT.DateFormatShow)#</td>
		
		 <td><cfif ActionStatus eq "1"><cf_tl id="Processed">
		 		   <cfelseif ActionStatus eq "9"><font color="FF0000"><cf_tl id="Voided"></font>	
		           <cfelse>
				   
					   <cfquery name="Check" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
								SELECT ObjectKeyValue4 
				                FROM Organization.dbo.OrganizationObject
				        		WHERE EntityCode    = 'ProcInvoice'
								AND  ObjectKeyValue4 = '#InvoiceId#' 
					   </cfquery>	   
				   
				       <cfif check.recordcount eq "0"><b><cf_tl id="On Hold"></b>
					   <cfelse><cf_tl id="In circulation">
					   </cfif>
				   </cfif>&nbsp;</td>
		
		 <td><cfif ReconciliationNo neq ""><font color="0080FF"><cf_tl id="Reconciled"></cfif></td>	   
		 <td>#DocumentCurrency#</td>		   				 
		 <td align="right" width="30%" style="padding-right:5px">#NumberFormat(DocumentAmount,"__,__.__")#</td>
							 
		</tr>
		
		<cfif files gt "0">
						  					
			<tr id="mattachments_#currentrow#" class="hide" >
			
			<td></td>
			<td colspan="9"
			    id="attach_#currentrow#"
			    style="border: 0px solid silver;">
				<cfdiv id="iattachments_#currentrow#"/>
			</td>
			
			</tr>	
								
		</cfif>					 
	  					
		</cfoutput>
						 
	    </table>
					
   </cfif>
   
   <cfset ajaxonload("doHighlight")>