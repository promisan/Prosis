
<cfif url.workorderlineid eq "">

   <!--- do not show anything here --->

<cfelse>
	
	<cfoutput>	
	
	<cfif url.requestid eq "">
	
		  <cfquery name="User" 
		   datasource="AppsWorkOrder" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			 SELECT  PersonNo as PersonNoFrom,
			         '' as PersonNoTo
		     FROM    WorkOrderLine WL
			 WHERE   WL.WorkorderLineId  = '#url.workorderlineid#'		
		  </cfquery>
		  
		   <cfquery name="LineCustomer" 
		   datasource="AppsWorkOrder" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			 SELECT  W.CustomerId as CustomerFrom,
					 W.CustomerId as CustomerTo
		     FROM    WorkOrder W, WorkOrderLine WL
			 WHERE   W.WorkOrderId       = WL.WorkOrderId
			 AND     WL.WorkorderLineId  = '#url.workorderlineid#'		
		  </cfquery>
		  
		  <cfparam name="LineAsset.AssetTo" default="Y">
		  <cfparam name="LineTransfer.TransferTo" default="">
	
	<cfelse>
	
		 <cfquery name="User" 
		   datasource="AppsWorkOrder" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			 SELECT RW.ValueFrom as PersonNoFrom,
			        RW.ValueTo   as PersonNoTo
		     FROM   RequestWorkorderDetail RW
			 WHERE  RW.Requestid       = '#url.requestid#'
			 AND    Amendment          = 'PersonNo'			
		 </cfquery>
		 	 
		 <cfquery name="LineCustomer" 
		   datasource="AppsWorkOrder" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			 SELECT RW.ValueFrom as CustomerFrom,
			        RW.ValueTo   as CustomerTo
		     FROM   RequestWorkorderDetail RW
			 WHERE  RW.Requestid       = '#url.requestid#'
			 AND    Amendment          = 'Customer'			
		 </cfquery>
		 
		   <cfquery name="LineTransfer" 
		   datasource="AppsWorkOrder" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			 SELECT RW.ValueTo as TransferTo
		     FROM   RequestWorkorderDetail RW
			 WHERE  RW.Requestid       = '#url.requestid#'
			 AND    Amendment          = 'TransferMode'			
		 </cfquery>
		 
		  <cfquery name="LineAsset" 
		   datasource="AppsWorkOrder" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			 SELECT RW.ValueTo as AssetTo
		     FROM   RequestWorkorderDetail RW
			 WHERE  RW.Requestid       = '#url.requestid#'
			 AND    Amendment          = 'Asset'			
		 </cfquery>
		 
		 <cfif LineCustomer.recordcount eq "0">
		 
			   <cfquery name="LineCustomer" 
			   datasource="AppsWorkOrder" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
				 SELECT  W.CustomerId as CustomerFrom,
				         '00000000-0000-0000-0000-000000000000' as CustomerTo
			     FROM    WorkOrder W, WorkOrderLine WL
				 WHERE   W.WorkOrderId       = WL.WorkOrderId
				 AND     WL.WorkorderLineId  = '#url.workorderlineid#'		
			  </cfquery>
		 
		 </cfif>
	
	</cfif>	
	
	<table width="100%" height="130" cellspacing="0" cellpadding="0">
	
	    <!--- deprecated 
	   	<tr>
			<td><cf_space spaces="39">Transfer Mode:</td>
			<td style="padding-left:4px">
				
					<select name="TransferModeTo" 
					   style="font:16px" 
					   onchange="ColdFusion.navigate('../Templates/RequestTransferToggle.cfm?mode='+(this.value),'transferbox')">
						<option value="Person" <cfif LineTransfer.TransferTo eq "Person">selected</cfif>>Person to Person</option>
						<option value="Customer" <cfif LineTransfer.TransferTo eq "Customer">selected</cfif>>Customer/Agency to Customer/Agency</option>
						<option value="Other" <cfif LineTransfer.TransferTo eq "Other">selected</cfif>>Other</option>
					</select>
			</td>
			<td id="transferbox"></td>
		</tr>
		
		<tr><td height="4"></td></tr>
		
		--->
	
		<tr>
		
		<td width="12%"></td>		
		<td width="90%" style="padding-left:3px">		
		
		<!---
		<cfif LineTransfer.TransferTo eq "Person" or LineTransfer.TransferTo eq "">
		   <cfset clc = "hide">
		   <cfset clp = "regular">		 		  
		<cfelseif LineTransfer.TransferTo eq "Customer">
		   <cfset clc = "regular">
		   <cfset clp = "hide">				
		<cfelse>
		   <cfset clc = "regular">
		   <cfset clp = "regular">				
		</cfif>
		--->
		
		<cfif url.mode eq "Person">
		   <cfset clc = "hide">
		   <cfset clp = "regular">		 		  
		<cfelseif url.mode eq "Customer">
		   <cfset clc = "regular">
		   <cfset clp = "hide">				
		<cfelse>
		   <cfset clc = "regular">
		   <cfset clp = "regular">				
		</cfif>
					
		<table cellspacing="0" cellpadding="0">		
		
		<input type="hidden" name="PersonNoFrom" id="PersonNoFrom" value="#User.PersonNoFrom#">
		<input type="hidden" name="CustomerFrom" id="CustomerFrom" value="#LineCustomer.CustomerFrom#">
				
		<tr>
		<td style="border:1px solid silver" width="330" valign="top">
			
			 <cfinclude template="RequestTransferFrom.cfm">
		
		</td>
		
		<td>&nbsp;</td>
		
		<td style="border:1px solid silver" width="330" valign="top">
		   <cfinclude template="RequestTransferTo.cfm">
		</td>
		
		</tr>
		
		<tr><td colspan="3" style="padding-top:4px">
			<cf_space spaces="30">
		    <table cellspacing="0" cellpadding="0" align="center">
			    <tr><td align="center">
				<img src="#SESSION.root#/images/logos/workorder/transfer.png" alt="" border="0">
				</td><td class="labelmedium">
				Transfer also the associated devices:			
				<cfif url.Accessmode eq "Edit">
					<input class="radiol" type="checkbox" name="AssetTo" id="AssetTo" value="Y" <cfif LineAsset.AssetTo eq "Y">checked</cfif>>
				<cfelse>
					<b>#LineAsset.AssetTo#</b>
				</cfif>			
				</td></tr>						
		   </table>
		   </td>
		</tr>		
			
		
		</td>
		</tr>
		</table>
			
	
	</cfoutput>
	
</cfif>


