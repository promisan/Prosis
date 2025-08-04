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

<cf_VerifyOperational Module = "Procurement">

<cfif ModuleEnabled eq "1">

	<!--- this query is likely not optimised yet for its content : Hanno 25/10/2015 --->
	
	<!--- financial base currency Allotment, Obligation and Disbursement --->

	<cfquery name="ProgramBudget" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     SUM(AmountBase) AS Total
		FROM       ProgramAllotmentDetail
		WHERE      ProgramCode = '#url.programCode#' 
		AND        Period      = '#url.period#' 
		AND        Status      = '1'		
	</cfquery>			

	<cfquery name="Purchase" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  DISTINCT Pur.PurchaseNo, 
                Pur.OrderClass, 	
				Pur.Mission,					
				Pur.OrderDate, 
				Pur.OrgUnitVendor, 
				Org.OrgUnitNameShort as OrgUnitName, 						
                Pur.Period,
				
				(SELECT SUM(OrderAmountBaseObligated) 
				 FROM   PurchaseLine
				 WHERE  Purchaseno = Pur.Purchaseno
				 AND    ActionStatus != '9') as AmountObligated, 
					
				(SELECT SUM(GLL.AmountBaseCredit)
				 FROM  	Invoice I INNER JOIN
	                    Accounting.dbo.TransactionHeader GL ON I.InvoiceId = GL.ReferenceId INNER JOIN
       		            Accounting.dbo.TransactionLine GLL ON GL.JournalSerialNo = GLL.JournalSerialNo AND GL.Journal = GLL.Journal
				 WHERE  I.ActionStatus != '9'
				 AND    (GLL.ParentJournal = '' or GLL.ParentJournal is NULL)
				 AND    I.InvoiceId IN
		                          (SELECT    InvoiceId
              				       FROM     InvoicePurchase
		                           WHERE    PurchaseNo = Pur.PurchaseNo)
				) as AmountInvoiced 
						
		FROM    Purchase Pur INNER JOIN
	            Organization.dbo.Organization Org ON Pur.OrgUnitVendor = Org.OrgUnit
				 
		WHERE    <!--- dropped as it would potentially create duplicates (
		         RequisitionNo IN (SELECT RequisitionNo 
		                           FROM   RequisitionLineFunding
								   WHERE  RequisitionNo = Line.RequisitionNo
								   AND    ProgramCode = '#URL.ProgramCode#')	 
		         OR 
				 --->
		         Pur.ProgramCode = '#URL.ProgramCode#'
							 
		<!--- show only periods of which the date effective = same or lies before the 
		      effective date of the selected planning period --->

		AND      Pur.Period IN (
		                        SELECT Period 
		                        FROM   Program.dbo.Ref_Period 
								WHERE  DateEffective <= (SELECT DateEffective 
								                         FROM   Program.dbo.Ref_Period 
						    					         WHERE  Period = '#URL.Period#')
							   )
						 
		ORDER BY OrderDate		 
	</cfquery>	
	
	<cfquery name="Total"
       dbtype="query">
		SELECT SUM(AmountObligated) as Obligated, 
		       SUM(AmountInvoiced) as Invoiced
		FROM   Purchase
	</cfquery>		
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding navigation_table">
	
		<tr>
	    <td width="100%">
	    <table width="100%" border="0" cellspacing="0" cellpadding="0">
		
								
			<TR class="labelit line">
				<td width="20"></td>
			    <TD width="20"></TD>
			    <TD width="85"><cf_tl id="Obligation"></TD>
				<td width="80"><cf_tl id="Entity"></td>	  
				<TD width="70"><cf_tl id="Class"></TD>
				<TD width="70"><cf_tl id="Period"></TD>
				<TD width="200"><cf_tl id="Unit"></TD>
				<TD width="70"><cf_tl id="Date"></TD>
				<TD width="100" align="right"><cf_tl id="Amount"></TD>
				<TD width="100" style="padding-right:10px" align="right"><cf_tl id="Paid"></TD>
			</TR>			
			
			
			<cfif Purchase.recordcount eq "0">
			  <TR><td colspan="10" align="center" class="labelmedium"><cf_tl id="No Obligation recorded" class="message"></td><TR>
			  <tr><td colspan="10" class="line"></td></tr>
			</cfif>
			
		    <cfoutput query="Purchase">
		    
				<TR class="labelit linedotted navigation_row">
				<td width="20">&nbsp;&nbsp;</td>
			    <TD width="20">#currentrow#.</TD>
			    <TD width="85"><a href="javascript:ProcPOEdit('#PurchaseNo#','view')" 
				      title="Open Purchase order"><font color="0080C0">#PurchaseNo#</font></a></TD>
				<td width="80">#Mission#</td>	  
				<TD width="70">#OrderClass#</TD>
				<TD width="70">#Period#</TD>
				<TD width="200">#OrgUnitName#</TD>
				<TD width="70">#DateFormat(OrderDate,CLIENT.DateFormatShow)#</TD>
				<TD width="100" align="right">#NumberFormat(AmountObligated,",.__")#</TD>
				<TD width="100" style="padding-right:10px" align="right">#NumberFormat(AmountInvoiced,",.__")#</TD>
			    </TR>				
			
			</CFOUTPUT>
			
			<cfif Purchase.recordcount gte "1">
				<tr><td colspan="10" class="line"></td></tr>
				<tr class="labelit line">
				    <td></td>
				    <td colspan="5"><b><cf_tl id="Activity Budget"></b></td>
					<td colspan="2"><cfoutput>#NumberFormat(ProgramBudget.Total,"__,__.__")#</cfoutput></td>
					<TD height="20" width="100" align="right"><b><cfoutput>#NumberFormat(total.Obligated,"__,__.__")#</cfoutput></b></TD>
					<TD height="20" style="padding-right:10px" width="100" align="right"><b><cfoutput>#NumberFormat(total.Invoiced,"__,__.__")#</cfoutput></b></TD>				
				</tr>
			</cfif>
	
		</table>

		</td></tr>

	</table>

<cfelse>
	 
	<cfquery name="CategoryAll" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT F.Area, F.Code, F.Description, S.*
	FROM   ProgramCategory S, 
	       Ref_ProgramCategory F 
	WHERE  S.ProgramCode = '#URL.ProgramCode#'
	  AND  S.ProgramCategory = F.Code
	</cfquery>
	
	<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="E4E4E4" class="formpadding">
	
		<tr>
	    <td width="100%">
	    <table width="100%" border="0" cellspacing="0" cellpadding="0">
			
			<cfif CategoryALL.recordcount eq "0">
			  <TR><td height="15" colspan="4" align="center">&nbsp;<b><cf_tl id="No details recorded" class="message"></b></td><TR>
			</cfif>
			
		    <cfoutput query="CategoryAll" group="AREA">
		    <TR><td height="15" colspan="4" class="bannerN2">&nbsp;<b>#Area#</b></td><TR>
			<cfoutput>
			<TR>
		    <TD>&nbsp;&nbsp;</TD>
		    <TD>#Description#</TD>
			<TD>#OfficerFirstName# #OfficerLastName#</TD>
			<TD>#DateFormat(Created,CLIENT.DateFormatShow)#</TD>
			<TD></TD>
		    </TR>	
			</CFOUTPUT>
			</CFOUTPUT>
	
		</table>

		</td></tr>

	</table>
	
</cfif>

<cfset ajaxonload("doHighlight")>	