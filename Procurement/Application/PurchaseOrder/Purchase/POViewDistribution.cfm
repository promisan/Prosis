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
<cfquery name="PO" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      Purchase
	WHERE     PurchaseNo = '#URL.ID1#'	
</cfquery>

<cfinvoke component="Service.Access"
	   Method="procApprover"
	   OrgUnit="#PO.OrgUnit#"
	   OrderClass="#PO.OrderClass#"
	   ReturnVariable="ApprovalAccess">		   

<cfquery name="Purchase" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    sum(OrderAmount) as Amount
	FROM      PurchaseLine
	WHERE     PurchaseNo = '#URL.ID1#'	
</cfquery>	   

<cfquery name="Currency" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      PurchaseLine
	WHERE     PurchaseNo = '#URL.ID1#'	
</cfquery>

<cfquery name="Execution" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT sum(Amount) as Amount
    FROM  PurchaseExecution
	WHERE PurchaseNo = '#URL.ID1#'	
</cfquery>

<cfif Execution.amount eq "">
 <cfset diff = Purchase.Amount>
<cfelse>
 <cfset diff = Purchase.Amount - Execution.Amount> 
</cfif>

<cfquery name="Last" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT count(*)+1 as Last
    FROM  PurchaseExecution
	WHERE PurchaseNo = '#URL.ID1#'	
</cfquery>

<cfif Last.last eq "">

  <cfset lst = "1">
  
<cfelse>

  <cfset lst = last.last>
    
</cfif>

<cfquery name="Item" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    P.ExecutionId, 
	          P.PurchaseNo, 
			  P.Description, 
			  P.ListingOrder, 
			  P.Amount, 
			  
			  (SELECT SUM(RequestAmount) 
			   FROM PurchaseExecutionRequest 
			   WHERE PurchaseNo = P.PurchaseNo and ExecutionId = P.ExecutionId 
			   AND ActionStatus != '9') 
			   AS Requested,
			  
			  (SELECT SUM(Amount)
			   FROM InvoicePurchaseExecution 
			   WHERE PurchaseNo = P.PurchaseNo and ExecutionId = P.ExecutionId 
			   AND   InvoiceId NOT IN (SELECT InvoiceId FROM Invoice WHERE ActionStatus = '9')
			   ) AS Invoiced			 
			  
	FROM      PurchaseExecution P 
	WHERE     P.PurchaseNo = '#URL.ID1#'		
	GROUP BY  P.ExecutionId,
	          P.PurchaseNo,
			  P.Description,
			  P.ListingOrder,
			  P.Amount  
	ORDER BY  P.Listingorder,
	          P.Description  		    	
</cfquery>

<cfparam name="url.id2" default="0">

<cfform name="fDistribution" id="fDistribution" onsubmit="return false">

<table cellspacing="0" width="100%" bgcolor="ffffff" cellpadding="0" border="0" class="navigation_table">

<cfoutput>

<tr class="line">
    <td height="20"></td>
	<td width="40" class="labelit">
	
	<cfif ApprovalAccess eq "EDIT" or ApprovalAccess eq "ALL">
		<cfif url.id2 eq "">	
		    <a href="javascript:ColdFusion.navigate('POViewDistribution.cfm?ID1=#URL.ID1#&ID2=0','boxdistribution')"><font color="0080FF">[<cf_tl id="hide">]</a>
		<cfelse>
		 <a href="javascript:ColdFusion.navigate('POViewDistribution.cfm?ID1=#URL.ID1#&ID2=','boxdistribution')"><font color="0080FF">[<cf_tl id="add">]</a>
		</cfif>
	</cfif>
	</td>
	<td width="40%" class="labelit"><cf_tl id="Item"></td>
	<td width="70" class="labelit"><cf_tl id="Curr"></td>
	<td width="14%" class="labelit" align="right"><cf_tl id="Obligated"></td>
	<td width="14%" class="labelit" align="right"><cf_tl id="Reserved"></td>
	<td width="14%" class="labelit" align="right"><cf_tl id="Invoiced"></td>
	<td width="30"></td>
	<td width="30"></td>
</tr>

</cfoutput>

<cfoutput query ="Item">
	
	<cfif url.id2 neq ExecutionId>
	
	<tr bgcolor="white" class="navigation_row">
	
	<td>&nbsp;</td>
	<td class="labelit">#listingorder#</td>
	<td class="labelit" height="18"
	    style="padding-left: 2px;">
		<cfif ApprovalAccess eq "EDIT" or ApprovalAccess eq "ALL">
		   <A href="javascript:ColdFusion.navigate('POViewDistribution.cfm?ID1=#URL.ID1#&ID2=#executionid#','boxdistribution')">
		#Description#
		<cfelse>
		#Description#
		</cfif>
	</td>		
	<td class="labelit">#Currency.Currency#</td>	
	<td class="labelit" align="right">#numberformat(Amount,"__,__.__")#</td>		
	<td class="labelit" align="right">	
	        <cfif requested gte "0">			
				<A href="javascript:executionrequest('#url.id1#','#executionid#')">
				<font color="0080C0">
			</cfif>
			#numberformat(Requested,"__,__.__")#
	</td>			
	<td class="labelit" align="right">#numberformat(Invoiced,"__,__.__")#</td>	
	<td align="right" width="20" style="padding-top:1px">
      <cfif ApprovalAccess eq "EDIT" or ApprovalAccess eq "ALL">		  
	   	   <cf_img icon="edit" onclick="ColdFusion.navigate('POViewDistribution.cfm?ID1=#URL.ID1#&ID2=#executionid#','boxdistribution')">		  		   
	  </cfif>
    </td>
			   				   
	<td align="left" width="20" style="padding-left:3px;padding-top:1px">
	
	     <cfif ApprovalAccess eq "EDIT" or ApprovalAccess eq "ALL">		
		     <cfif requested eq "">					 
			 	 <cf_img icon="delete" onclick="ColdFusion.navigate('POViewDistributionPurge.cfm?ID1=#URL.ID1#&ID2=#executionid#','boxdistribution')">			 				   
			 </cfif>						  
		 </cfif>
		 
	 </td>	
	
	</tr>
	
	<tr id="box#executionid#" class="hide">
	     <td colspan="9" id="c#executionid#"></td>
	</tr>   
		
	<cfelse>	
					
			<TR style="height:40px" bgcolor="ffffcf">
			<td></td>
			<td style="height:30px;padding-left:10px">			
			
			    <cfinput type="Text"
			       name="ListingOrder"
			       message="You must enter a order"
			       validate="integer"
			       required="Yes"		
				   value="#currentrow#"   
				   style="width:25;text-align:center" 
			       size="1"
				   class="regularxl"
			       maxlength="2">
			
			</td>
			<td height="28">
			
				<cfinput type="Text" 				  
				   name="Description" 
				   message="You must enter a description" 
				   required="Yes" 
				   value="#Description#"				   
				   style="width:97%" 						 
				   maxlength="90" 
				   class="regularxl">
				   
	        </td>
						   
			<td  class="labelit">#Currency.Currency#</td>								 
			<td>
				
				   <cfinput type="Text" 
				      name="Amount" 
					  message="You must enter an amount" 
					  required="Yes" 
					  size="20" 		
					  value="#numberformat(Amount,"__.__")#"			  
					  style="text-align:right"					 
					  validate="float"
					  class="regularxl"
					  maxlength="20">
					  
			</td>
				
			<td align="right">
						
			<cfif requested gte "0">			
			<A href="javascript:'#url.id1#','#executionid#')">
			</cfif>
			#numberformat(Requested,"__,__.__")#</td>
			<td align="right">#numberformat(Invoiced,"__.__")#</td>	
										   
			<td align="right" style="padding-left:4px">
				
				<input type= "button" 
					value  = "Save"
					onclick= "validate('fDistribution','boxdistribution','POViewDistributionSubmit.cfm?id1=#URL.ID1#&id2=#url.id2#')"
					class  = "button10g" 
					style  = "height:25;width:43">				
				
			</td>			    
			<td></td>
			</TR>	
			
			<tr id="box#executionid#" class="hide">
			   <td colspan="9" id="c#executionid#"></td>
			</tr>   
			   			
			</td></tr>
			<cfif currentrow neq recordcount>
			<tr><td colspan="9" class="line"></td></tr>
			</cfif>
			
	</cfif>

</cfoutput>	

<cfoutput>

<!--- add new --->
	
   <cfif url.id2 eq "" and (ApprovalAccess eq "EDIT" or ApprovalAccess eq "ALL")>
											
			<TR bgcolor="f4f4f4" class="line" style="height:30px">				
			<td></td>
			<td style="height:40px;padding-left:10px">			
			
			    <cfinput type="Text"
			       name="ListingOrder"
			       message="You must enter a order"
			       validate="integer"
			       required="Yes"		
				   value="#lst#"   
				   style="width:25;text-align:center" 
			       size="1"
			       maxlength="2"
			       class="regularxl">
				 
			
			</td>
			<td height="28">
			
				<cfinput type="Text" 
				   value="" 
				   name="Description" 
				   message="You must enter a description" 
				   required="Yes" 
				   style="width:98%" 						 
				   maxlength="90" 
				   class="regularxl">
				   
	        </td>
						   
			    <td class="labelit">				
					#Currency.Currency#			
				</td>								 
				<td>
				
				   <cfinput type="Text" 
				      name="Amount" 
					  message="You must enter an amount" 
					  required="Yes" 
					  size="20" 					  
					  style="text-align:right"
					  value=""
					  validate="float"
					  class="regularxl"
					  maxlength="20">
					  
				</td>
				
			<td></td>	
			<td></td>	
										   
			<td align="right" style="Padding-left:4px">
				
				<input type="button" 
					value="Add" 
					class="button10s" 
					onclick="validate('fDistribution','boxdistribution','POViewDistributionSubmit.cfm?id1=#URL.ID1#&id2=#url.id2#')"
					style="width:43;height:25">				
				
			</td>			    
			<td></td>
		</TR>	
		
	</cfif>
	
	<cfif diff neq 0>
	
		<tr><td colspan="9" class="line"></td></tr>
		
		<tr bgcolor="DBF0FB" class="navigation_row">
		   <td></td>
		   <td></td>
		   <td class="labelit">Remaining unspecified amount</td>
		   <td class="labelit">#currency.currency#</td>
		   <td class="labelit" align="right">
		   <cfif diff lt 0><font color="FF0000"></cfif>
		   #Numberformat(diff,"__,__.__")#</td>
		   <td></td>
		   <td></td>
		   <td></td>
		   <td></td>
		</tr>

	</cfif>

</table>

</cfoutput>

</cfform>

<cfset ajaxonload("doHighlight")>
