
<!--- filter by owner of the position --->

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
	 
	 <!--- to be reviewed for now i disabled it but OICT had several in invoice that were on hold, but
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
	 
	 <!--- invoices are under rotation --->

	 AND        I.InvoiceId IN
                          (SELECT   ObjectKeyValue4
                            FROM    Organization.dbo.OrganizationObject
                            WHERE   EntityCode = 'ProcInvoice' 
							AND     ObjectKeyValue4 = I.InvoiceId)
							
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


<table width="100%" border="0" class="navigation_table">


<tr>

	<td style="width:6px">&nbsp;&nbsp;</td>
		
	<td width="29%" style="padding:10px;border:0px solid silver">
		
	  <table height="100%" cellspacing="0" cellpadding="0" border="0">
	 
	 	  <tr><td valign="top">
				  
	  <cfquery name="Summary" dbtype="query">
		    SELECT     OrderTypeName, 		          				 
					   COUNT(InvoiceId) as Counted,
					   SUM(BaseAmountMatched) as AmountPayable
		    FROM       getInvoices		
		    GROUP BY   OrderTypeName	    
	  </cfquery>	
	
	  <cfset vColorlist = "##D24D57,##52B3D9,##E08283,##E87E04,##81CFE0,##2ABB9B,##5C97BF,##9B59B6,##E08283,##663399,##4DAF7C,##87D37C">
	  <cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
	  
	  <cfchart style = "#chartStyleFile#" 
		       format="png"
		       chartheight="220" 
			   chartwidth="420"    
			   font="Calibri" fontsize="16"
		       seriesplacement="default"	  
			   pieslicestyle="solid"
			   showxgridlines="yes"
		       sortxaxis="no">	
								
			   <cfchartseries
	             type="bar"
	             query="Summary"				 
	             itemcolumn="OrderTypeName"
	             valuecolumn="AmountPayable"
	             serieslabel="Summary"
				 seriescolor = "EB974E"
			     colorlist="#vColorlist#"></cfchartseries>			
				 
		</cfchart>	
		
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
		
	<td>&nbsp;</td>	
	
	<td width="69%" valign="top" bgcolor="f4f4f4" style="border:0px solid silver;padding:10px">
	
		<table width="100%" cellspacing="0" cellpadding="0" align="center">
				
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
						
		<tr class="labelmedium line">
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
							
			<tr class="navigation_row labelmedium line">
			  <td width="40%" style="padding-left:4px">#OrderTypeName#</td>
			  <td align="right" style="padding-left:6px">#Counted#</td>
			  <td align="right" style="padding-left:6px"><b>#numberFormat(AmountPayable,'__,__')#</td>
			  <td align="right">#getPending.Counted#</td>
			  <td align="right">#numberFormat(getPending.AmountPayable,'__,__')#</td>
			</tr>
			
			</cfoutput>	
							
		</table>
	
	</td>
	

	
</tr>

<tr><td height="5"></td></tr>

<cfset ajaxOnLoad("doHighlight")>

</table>
