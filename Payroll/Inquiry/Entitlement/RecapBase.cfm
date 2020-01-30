
<cfparam name="url.id" default="">

<cfquery name="Component" 
  datasource="AppsPayroll" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT   DISTINCT C.PayrollItem,
                    C.PrintDescription as PayrollItemName, 
				    C.PrintDescriptionLong, 
				    C.PrintOrder,
					C.ComponentOrder,
					C.Source,
				    L.PaymentCurrency, 
				    SUM(L.PaymentAmount) as Amount
  FROM   	SalarySchedulePeriod S, 
	        EmployeeSalary L0, 
			EmployeeSalaryLine L, 
			Ref_PayrollItem C
  WHERE  	S.CalculationId   = '#URL.ID2#' 
  AND    	S.SalarySchedule  = L0.SalarySchedule
  AND    	S.PayrollStart    = L0.PayrollStart
  AND    	L0.PersonNo       = L.PersonNo
  AND    	L0.PayrollStart   = L.PayrollStart
  AND    	L0.PayrollCalcNo  = L.PayrollCalcNo
  AND    	C.PayrollItem     = L.PayrollItem
  
  <cfif url.id eq "TOT">
  AND        C.PrintGroup     = '#URL.ID3#' 
  <cfelse>
  AND        L0.ServiceLevel  = '#URL.ID3#' 
  </cfif>
  
  GROUP BY   C.PrintOrder, C.ComponentOrder, C.Source, C.PayrollItem, C.PrintDescriptionLong,C.PrintDescription, L.PaymentCurrency
  HAVING SUM(L.PaymentAmount) != 0
  ORDER BY   C.Source DESC,
             C.ComponentOrder,
             C.PrintDescription, 
			 C.PrintDescriptionLong, L.PaymentCurrency 
</cfquery>

<cfif Component.recordCount neq "0">

	<table width="98%" 
	       height="100%" 
		   border="0" 	   
		   align="center" 
		   cellpadding="0" 
		   cellspacing="0">

    <tr><td height="3"></td></tr>
	<tr><td colspan="3" height="35" align="center">
		
		   <table width="100%">
		   <tr>
			<td class="labellarge" style="font-size:125%;"><cf_tl id="Amounts by item" var="1"> <cfoutput>#lt_text#: #url.id3#</cfoutput></td>
		   </tr>
		   </table>
		   
		</td></tr>	   

	<tr><td height="5"></td></tr>
	<tr><td valign="top" style="border:0px solid silver">
		
		<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
								
		<tr>
			<td align="center" width="35%" valign="top" style="min-width:400px;padding-right:10px; border-right:1px solid Silver;">
			
				<table width="95%" border="0" cellpadding="0" cellspacing="0" class="navigation_table formpadding"> 
				
					<tr class="line labelmedium">
					    <td>&nbsp;</td>
					    <td><cf_tl id="Code"></td>
						<td><cf_tl id="Item"></td>
						<td align="center"><cf_tl id="Curr"></td>
						<td align="right" style="padding-right:5px"><cf_tl id="Amount"></td>
					</tr>
					
					<cfset sum = 0>
					
					<cfoutput query="Component">
						<cfset vLineTotal = "">
						<cfif currentrow eq recordCount>
							<cfset vLineTotal = "line">
						</cfif>
						<tr style="cursor: pointer; height:15px;" class="line navigation_row labelmedium #vLineTotal#" onclick="javascript:listing('#url.id#','#url.id1#','#url.id2#','#url.id3#','#PayrollItem#')">
					        <td>&nbsp;</td>
					        <td style="padding-right:8px;">#PayrollItem#</td>
							<td width="50%">#PrintDescriptionLong#</td>
							<td align="center">#PaymentCurrency#</td>
							<td align="right" style="padding-right:5px">#NumberFormat(Amount,",.__")#</td>
						</tr>
						<cfset sum = sum + Amount>
					</cfoutput>						
					
					<tr class="labelmedium">
					    <td>&nbsp;</td>
						<td colspan="3"><cf_tl id="Total"></b></td>
						<td align="right" style="padding-right:5px"><b><cfoutput>#NumberFormat(Sum,",.__")#</cfoutput></b></td>
					</tr>
				
				</table>
			
			</td>
							
			<td align="center">
			
				<table width="100%">
								
				<tr><td align="center" valign="middle" style="padding-top:9px">
				
				<cfchart format="png"
		           chartheight="400"
		           chartwidth="700"
		           showygridlines="no"
		           seriesplacement="default"
		           font="Calibri"
				   show3d="no" 
		           fontsize="10"			
				   showlegend="No"
				   showborder="no"   
		           labelformat="number"
		           tipstyle="mouseOver"
		           tipbgcolor="##ffffff"
		           pieslicestyle="sliced"
		           url="javascript:listing('#url.id#','#url.id1#','#url.id2#','#url.id3#','$ITEMLABEL$')">
						   
					<cfchartseries
		             type="bar"
		             query="Component"
		             itemcolumn="PayrollItem"
		             valuecolumn="Amount"
		             serieslabel="Calculated amounts"	            
				     seriescolor="40BC86"  
		             markerstyle="circle"/>
					 			
				</cfchart>
				</td></tr>		
				</table>
				
			</td>
			</tr>
							
			</table>
		</td>
	</tr>
		
	<tr><td height="100%" valign="top" align="center" style="padding:4px;border-top:1px solid silver;" id="listingcontent"></td></tr>
	
	</table>

</cfif>

<cfset ajaxonload("doHighlight")>
<script>
	Prosis.busy('no')
</script>

