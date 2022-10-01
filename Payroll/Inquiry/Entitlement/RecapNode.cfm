	
<cfquery name="Base" 
	  datasource="AppsPayroll" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT    C.PrintGroup,			    
			    L.PaymentCurrency, 
				G.PostGrade,
				G.PostOrder,
			    SUM(L.PaymentAmount) as Amount
	  FROM   	SalarySchedulePeriod S, 
		        EmployeeSalary L0, 
				EmployeeSalaryLine L, 
				Ref_PayrollItem C,
				Employee.dbo.Ref_PostGrade G
	  WHERE  	S.CalculationId   = '#URL.ID2#' 
	  AND    	S.SalarySchedule  = L0.SalarySchedule
	  AND    	S.PayrollStart    = L0.PayrollStart
	  AND    	S.Mission         = L0.Mission
	  AND    	L0.PersonNo       = L.PersonNo
	  AND       G.PostGrade       = L0.ServiceLevel
	  AND    	L0.PayrollStart   = L.PayrollStart
	  AND    	L0.PayrollCalcNo  = L.PayrollCalcNo
	  AND    	C.PayrollItem     = L.PayrollItem 
	 
	  GROUP BY   C.PrintGroup, L.PaymentCurrency,G.PostGrade, G.PostOrder
	  HAVING     SUM(L.PaymentAmount) != 0
	  ORDER BY   C.PrintGroup, L.PaymentCurrency
</cfquery>
	
<cfif Base.recordCount neq "0">

	<table width="98%" height="100%" align="center">

	  <tr><td valign="top" style="border:0px solid silver">
		
			<table width="100%" align="center">
									
			<cfquery name="Group" dbtype="query">
                 SELECT    PrintGroup,			    
			               PaymentCurrency, 
						   SUM(Amount) as Amount
           	     FROM      Base
	   	         GROUP BY  PrintGroup, PaymentCurrency
           	     ORDER BY  PrintGroup, PaymentCurrency
			 </cfquery>
			   									
			<tr>
				<td align="center" width="35%" valign="top" style="min-width:400px;padding-right:10px; border-right:1px solid Silver;">
				
					<table width="100%" class="navigation_table formpadding"> 
					
						<tr class="line labelmedium2">
						    <td>&nbsp;</td>
						    <td style="font-size:16px;font-weight:bold;padding-top:6px"><cf_tl id="Amounts by group" var="1"> <cfoutput>#lt_text#</cfoutput></td>						
							<td align="center"><cf_tl id="Curr"></td>
							<td align="right" style="padding-right:5px"><cf_tl id="Amount"></td>
						</tr>
						
						<cfset sum = 0>
						
						<cfoutput query="Group">
							<cfset vLineTotal = "">
							<cfif currentrow eq recordCount>
								<cfset vLineTotal = "line">
							</cfif>
							<tr style="cursor: pointer; height:15px;" class="line navigation_row labelmedium #vLineTotal#" 
							    onclick="javascript:listing('#url.id#','#url.id1#','#url.id2#','','#PrintGroup#')">
						        <td>&nbsp;</td>
						        <td style="padding-right:8px;">#PrintGroup#</td>							
								<td align="center">#PaymentCurrency#</td>
								<td align="right" style="padding-right:5px">#NumberFormat(Amount,",.__")#</td>
							</tr>
							<cfset sum = sum + Amount>
						</cfoutput>						
						
						<tr class="labelmedium2">
						    <td>&nbsp;</td>
							<td colspan="2"><cf_tl id="Total"></b></td>
							<td align="right" style="padding-right:5px"><b><cfoutput>#NumberFormat(Sum,",.__")#</cfoutput></b></td>
						</tr>
					
					</table>
				
				</td>				
				</tr>
				
				<cfquery name="Grade" dbtype="query">
                 SELECT    PostGrade,			    
			               PostOrder, 
						   PaymentCurrency,
						   SUM(Amount) as Amount
           	     FROM      Base
	   	         GROUP BY  PostGrade, PostOrder,PaymentCurrency
           	     ORDER BY  POstGrade, PostOrder,PaymentCurrency
			 </cfquery>  
			 
			 <tr>
				<td align="center" width="35%" valign="top" style="min-width:400px;padding-right:10px; border-right:1px solid Silver;">
				
					<table width="100%" class="navigation_table formpadding"> 
					
						<tr class="line labelmedium2">
						    <td>&nbsp;</td>
						    <td style="font-size:16px;font-weight:bold;padding-top:6px"><cf_tl id="Amounts by grade" var="1"><cfoutput>#lt_text#</cfoutput></td>						
							<td align="center"><cf_tl id="Curr"></td>
							<td align="right" style="padding-right:5px"><cf_tl id="Amount"></td>
						</tr>
						
						<cfset sum = 0>
						
						<cfoutput query="Grade">
							<cfset vLineTotal = "">
							<cfif currentrow eq recordCount>
								<cfset vLineTotal = "line">
							</cfif>
							<tr style="cursor: pointer; height:15px;" class="line navigation_row labelmedium #vLineTotal#" 
							    onclick="javascript:listing('#url.id#','#url.id1#','#url.id2#','','#PostGrade#')">
						        <td>&nbsp;</td>
						        <td style="padding-right:8px;">#PostGrade#</td>							
								<td align="center">#PaymentCurrency#</td>
								<td align="right" style="padding-right:5px">#NumberFormat(Amount,",.__")#</td>
							</tr>
							<cfset sum = sum + Amount>
						</cfoutput>						
						
						<tr class="labelmedium2">
						    <td>&nbsp;</td>
							<td colspan="2"><cf_tl id="Total"></b></td>
							<td align="right" style="padding-right:5px"><b><cfoutput>#NumberFormat(Sum,",.__")#</cfoutput></b></td>
						</tr>
					
					</table>
				
				</td>				
				</tr>
								
				
			</table>	
		
		</td>
									
		<td align="center">
			
				<table width="100%">
								
				<tr><td align="center" valign="middle" style="padding:5px">
				
				    <cfset ht = (group.recordcount+grade.recordcount) * 22 + 100>
					
					<cfset vColorlist = "##D24D57,##52B3D9,##E08283,##E87E04,##81CFE0,##2ABB9B,##5C97BF,##9B59B6,##E08283,##663399,##4DAF7C,##87D37C">
								
					<cf_uichart chartheight="#ht#"		          			          
			           seriesplacement = "default"
			           font            = "Calibri"				   
			           fontsize        = "14"							 		         
					   showlabel       = "Yes"	
					   showvalue       = "Yes"		
					   Legend          = "No"		   
			           tipstyle        = "mouseOver"		         
			           
			           url="javascript:listing('#url.id#','#url.id1#','#url.id2#','','$ITEMLABEL$')">
							   
						<cf_uichartseries
			             type="pie"
			             query="#Grade#"
			             itemcolumn="PostGrade"
			             valuecolumn="Amount"
			             serieslabel="Calculated amounts"	            
					     seriescolor="#vcolorlist#"  
			             markerstyle="circle"/>
						 			
					</cf_uichart>
				
				</td></tr>		
				</table>
			
		</td>
	</tr>
		
	<tr><td colspan="2" height="100%" align="center" style="background-color:f4f4f4;padding:4px;border:1px solid silver" id="listingcontent"></td></tr>
	
	</table>

</cfif>

<cfset ajaxonload("doHighlight")>
<script>
	Prosis.busy('no')
</script>

