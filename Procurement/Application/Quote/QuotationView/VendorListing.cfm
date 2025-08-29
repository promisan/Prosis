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
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
  
    <tr>
    <td width="100%">
  		<table border="0" cellpadding="0" cellspacing="0" width="100%" class="formpadding">
		
    <TR class="labelit linedotted">
       <td width="4%" style="width:30px" height="21">&nbsp;</td>
	   <td width="4%">&nbsp;</td>
  	   <td width="40%"><cf_tl id="Description"></td>
	   <td align="right"><cf_tl id="Qty"></td>
       <td align="center"><cf_tl id="UoM"></td>
       <td align="right"><cf_tl id="Price"></td>
       <td align="right"><cf_tl id="Amount"></td>
	   <td align="right"><cf_tl id="Purchase"></td>
       <td align="right"></td>
     </TR>  
	 
	<cfquery name="Vendors" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    OrgUnitVendor, SUM(QuoteAmountBase) AS Total, Org.OrgUnitName, Org.OrgUnit
		FROM      RequisitionLineQuote Q, RequisitionLine L, Organization.dbo.Organization Org 
		WHERE     Q.JobNo = '#URL.ID1#'
		AND       L.RequisitionNo = Q.RequisitionNo
		<!---
		AND       L.ActionStatus IN ('2k','3') 
		--->
		AND       L.ActionStatus != '9'
		AND       Q.OrgUnitVendor = Org.OrgUnit
		GROUP BY OrgUnitVendor,Org.OrgUnitName, Org.OrgUnit
		ORDER BY SUM(QuoteAmountBase)
	</cfquery>
		
	<cfoutput query="Vendors">
		
		<TR>
	    <td>&nbsp;</td>
		<td>&nbsp;</td>
   	    <td colspan="5" class="labelmedium"><b>#OrgUnitName#</td>
		<td colspan="1" align="right" class="labelmedium"><b>#numberFormat(Total,",__.__")#</td>
		 <td>&nbsp;</td>
		</TR> 
		
		<cfquery name="Lines" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    Q.*, 
		          R.RequestDescription AS Expr1, 
				  P.PurchaseNo AS PurchaseNo,
				  A.Description		
        FROM      RequisitionLineQuote Q INNER JOIN
                  RequisitionLine R ON Q.RequisitionNo = R.RequisitionNo LEFT OUTER JOIN
                  PurchaseLine P ON R.RequisitionNo = P.RequisitionNo 
				  AND R.RequisitionNo = P.RequisitionNo 
				  LEFT OUTER JOIN Ref_Award A ON Q.Award = A.Code
        WHERE     Q.JobNo = '#URL.ID1#' 
		<!---
		AND       R.ActionStatus IN ('2k', '3') 
		--->
		AND       R.ActionStatus != '9'
		AND       Q.OrgUnitVendor = '#OrgUnitVendor#'
		</cfquery>  
		
		<cfset row = CurrentRow>
				
		<cfloop query="Lines">
			
			<cfif QuoteAmountBase lte "0">
							
			<tr class="linedotted" bgcolor="ffffcf" id="#requisitionno#_4">
			
			<cfelse>
			
			<cfif Selected eq "0">
			
			<tr class="linedotted" bgcolor="f6f6f6" id="#requisitionno#_4">
			
			<cfelse>
			
			<tr class="linedotted" bgcolor="EAFBFF" id="#requisitionno#_4">
			
			</cfif>
			
			</cfif>
			
			<td height="20" style="padding-left:5px" align="center"><cfif Selected eq "1">
			<img src="#SESSION.root#/Images/check.png" height="13" alt="" border="0"></cfif></td>	  
			
			 <cfif access eq "ALL" and (workflowEnabled eq "0" or flowdefined.recordcount eq "0")>
			 
			 	 <td rowspan="1" style="padding-top:1px" align="center">
				
				 <cf_img icon="edit" onClick="ProcQuoteEdit('#quotationid#');">
								 
				 </td>
				 <td class="labelit"><a href="javascript:ProcQuoteEdit('#quotationid#')"><cfif VendorItemDescription eq "">#RequestDescription#<cfelse>#VendorItemDescription#</cfif></a></td>
					
			   <cfelseif workflow eq "1">			
			   
			   	 <td rowspan="1" style="padding-top:1px" align="center">	 				   
				  <cf_img icon="select" onClick="ProcQuoteEdit('#quotationid#');"> 				  				 
				 </td>
				 <td class="labelit"><a href="javascript:ProcQuoteEdit('#quotationid#')"><cfif VendorItemDescription eq "">#RequestDescription#<cfelse>#VendorItemDescription#</cfif></a></td>
				 	 
			   <cfelse>	
			   
				   	<td></td>
					<td class="labelit"><cfif VendorItemDescription eq "">#RequestDescription#<cfelse>#VendorItemDescription#</cfif></td>
			   			
					<!--- no actionenabled --->							 				 
					
			   </cfif>					
		
   		    <td align="right" class="labelit">#QuotationQuantity#</td>
		    <td align="right" class="labelit">#QuotationUoM#</td>
	        <td align="right" class="labelit">#NumberFormat(QuoteAmountBase/QuotationQuantity,"__,__.__")#</td>
	        <td align="right" class="labelit">#NumberFormat(QuoteAmountBase,"__,__.__")#</td>
			<td align="right" class="labelit">
			<cfif selected eq 1>
			<a href="javascript:ProcPOEdit('#PurchaseNo#','view')"
						  title="View Purchase Order"><font color="2F97FF">#PurchaseNo#</font></a>
			</cfif>			  
			
			</td>	        
			<td align="right">&nbsp;</td>	  
           	</tr>
			
			<cfif Award neq "">
				<tr>
				   <td height="20"></td>
				   <td></td>
				   <td colspan="7" class="labelmedium"><font color="b0bob0">Award reason</font>: #Description# #AwardRemarks#</td>
				</tr>
			</cfif>
									
		</cfloop>
					
	</cfoutput>
	
	</table>
	
	</td></tr>
	
	</table>