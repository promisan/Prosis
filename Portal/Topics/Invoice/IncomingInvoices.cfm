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
<cfparam name="url.orgunit" default="">
<cfparam name="url.period"  default="B12-13">

<cfif url.orgunit neq "">

	<cfquery name="get" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">	
		 SELECT * 
		 FROM   Organization 
		 WHERE  OrgUnit = '#url.orgunit#' 
	</cfquery>
	
</cfif>

<cfquery name="getInvoices" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">	 
	 
	 SELECT     I.InvoiceId, 
	            I.OrgUnitOwner, 
				I.OrgUnitVendor, 
				I.InvoiceNo, 
				I.InvoiceSerialNo, 
				I.Description, 
				I.DocumentCurrency, 
				I.DocumentAmount, 
				I.DocumentDate,
                   (SELECT   round(SUM(AmountMatched/1000),2) AS Expr1
                    FROM     InvoicePurchase
                    WHERE    InvoiceId = I.InvoiceId) AS BaseAmountMatched, 
				I.OrderType, 
				R.Description AS OrderTypeName, 
				I.ActionStatus
	 FROM       Invoice AS I INNER JOIN
                      Ref_OrderType AS R ON I.OrderType = R.Code
	 WHERE      I.Mission = '#url.mission#' 
	 
	 AND        I.ActionStatus <> '9' 
	 
	 <!--- to be reviewed for now i disabled it but O had several in invoice that were on hold, but
	 like the workflow existance manages partially as well
	 AND        I.InvoiceSerialNo = 1 
	 --->
	 
	 AND       I.Period = '#url.period#'
	 
	 <!--- removed 3/5/2016 and added I.Period 
	
	 AND         I.InvoiceId IN (SELECT InvoiceId 
	                             FROM   InvoicePurchase IP, Purchase P
	                             WHERE  IP.InvoiceId = I.InvoiceId
								 AND    IP.Purchaseno = P.PurchaseNo
								 AND    P.Period = '#url.period#')        
								 
	 --->							 
	 
	 <!--- invoices are under rotation 

	 AND        I.InvoiceId IN
                          (SELECT   ObjectKeyValue4
                            FROM    Organization.dbo.OrganizationObject
                            WHERE   EntityCode = 'ProcInvoice' 
							AND     ObjectKeyValue4 = I.InvoiceId)
							
	 --->
							
	 <cfif url.orgunit neq "">
	 
		AND       OrgUnitOwner IN (
		                           SELECT OrgUnit 
		                           FROM   Organization.dbo.Organization
								   WHERE  Mission   = '#url.mission#'
								   AND    MandateNo = '#get.MandateNo#'
								   AND    HierarchyCode LIKE ('#get.HierarchyCode#%')
								  )  
	 </cfif>						
	
	 ORDER BY     R.ListingOrder, OrderTypeName, I.DocumentDate
	
</cfquery>	

<table width="100%" style="background-color:white">

<tr>

	<td style="width:6px">&nbsp;&nbsp;</td>
		
	<td width="29%">
		
	  <table height="100%">
	 
	   <tr><td valign="top">
				  
	  <cfquery name="Summary" dbtype="query">
		    SELECT     OrderTypeName, 		          				 
					   COUNT(InvoiceId) as Counted,
					   SUM(BaseAmountMatched) as AmountPayable
		    FROM       getInvoices		
		    GROUP BY   OrderTypeName	    
	  </cfquery>	
	  
	   <cf_uichart name="divInvoiceGraph_1"
			chartheight="220"
			showlabel="No"
			showvalue="No"
			chartwidth="520">
					
			<cf_uichartseries type="bar"
			    query="#Summary#" 
				itemcolumn="OrderTypeName" 
				valuecolumn="AmountPayable" 
				colorlist="##E87E04"/>
				
	  	</cf_uichart>
			 		
		</td></tr>
		</table>
	
	</td>
		
	<!--- summary table --->

	<cfquery name="getList" dbtype="query">
        SELECT     OrderTypeName, 		          				 
				   COUNT(InvoiceId) as Counted,
				   SUM(BaseAmountMatched) as AmountPayable
	    FROM       getInvoices			
	    GROUP BY   OrderTypeName	    
	</cfquery>		
		
	<td width="69%" valign="top" style="border:0px solid silver;padding:4px">
	
		<table width="100%" align="center">
				
		<cfquery name="Module" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   *
				FROM     Ref_ModuleControl
				WHERE    SystemModule  = 'Procurement'
				AND      FunctionClass = 'Application'
				AND      FunctionName  = 'Invoice Matching'
		</cfquery>		
						
		<tr class="labelmedium line fixlengthlist">
		
		<td style="padding-left:4px"><cf_tl id="Type"></td>		
		<td colspan="2" align="right"><cf_tl id="YTD">000s</td>
				
		<cfoutput>		
		<cfset link = "Procurement/Application/Invoice/InvoiceView/InvoiceViewView.cfm?Mission=#url.mission#|Period=#url.period#|ID=STA|ID1=Pending|SystemFunctionId=#module.systemfunctionid#">
		
		<cfif Module.recordcount eq "1">	
		 <td colspan="2" style="cursor:pointer" align="right" 
		   onclick="ptoken.open('#session.root#/Procurement/Application/Invoice/InvoiceView/InvoiceView.cfm?Mission=#url.mission#&SystemFunctionId=#module.systemfunctionid#&link=#link#','_blank')">						 
		 <font color="0080C0"><cf_tl id="In Process">000s</font>
		</cfif>
		</cfoutput>
		
		 </td>
		</tr>
					
		<cfoutput query="getList">					
						
			<cfquery name="getPending" dbtype="query">
		        SELECT     COUNT(InvoiceId) as Counted,
						   SUM(BaseAmountMatched) as AmountPayable
			    FROM       getInvoices		
				WHERE      ActionStatus = '0'	
				
				AND        OrderTypeName = '#OrderTypeName#'				       
			</cfquery>	
							
			<tr class="navigation_row labelmedium line fixlengthlist">
			  <td style="padding-left:4px">#OrderTypeName#</td>
			  <td align="right" style="padding-left:6px">#Counted#</td>
			  <td align="right" style="padding-left:6px"><b>#numberFormat(AmountPayable,',__')#</td>
			  <td align="right">#getPending.Counted#</td>
			  <td align="right">#numberFormat(getPending.AmountPayable,',__')#</td>
			</tr>
			
			</cfoutput>	
							
		</table>
	
	</td>
	
</tr>

</table>

<cfset ajaxOnLoad("doHighlight")>
