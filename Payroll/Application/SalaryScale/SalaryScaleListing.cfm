<!--- Create Criteria string for query from data entered thru search form --->

<cf_screentop height="100%" scroll="Yes" html="No" jquery="Yes">
 
<!--- Query returning search results --->

<cfif URL.ID2 eq "All">
   <cfset lvl = ""> 
<cfelse>
   <cfset lvl = "AND ServiceLevel = '#URL.ID2#'">
</cfif>

<cfquery name="SearchResult" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT      S.SalarySchedule, 
	    	    G.PaymentCurrency, 
			    ServiceLocation, 
			    ServiceLevel, 
			    ServiceStep,
			    R.Description, 
			    S.ScaleNo,
				S.SalaryEffective,
			    G.Description as SalaryScheduleName,
			    Amount as BasePayroll									
				
    FROM        SalaryScale S, 
	            SalaryScaleLine L,
			    SalarySchedule G,
			    Ref_PayrollLocation R
				
	WHERE       S.ScaleNo = L.ScaleNo
    AND         S.SalarySchedule  = '#URL.ID#'
	AND         ServiceLocation   = '#URL.ID1#'
	AND         S.Mission         = '#url.mission#'
	AND         S.SalarySchedule = G.SalarySchedule
	AND         L.ComponentName IN (
	                                SELECT   Code
   								    FROM     Ref_PayrollComponent PC INNER JOIN
						                     SalarySchedule SS ON PC.PayrollItem = SS.SalaryBasePayrollItem
									WHERE    SalarySchedule = G.SalarySchedule
									)  
	AND         S.ServiceLocation = R.LocationCode
    	        #preserveSingleQuotes(lvl)# 
				
	AND         Amount > 0
	AND 		L.OperationaL = '1'			
	
	ORDER BY    S.SalarySchedule,
				ServiceLocation, 
			    ServiceLevel, 
			    ServiceStep,
				S.SalaryEffective DESC 
				
</cfquery>


<CFOUTPUT>		
	
	<script>
			
	function selected(scaleno,level,step,curr,contractid) {
			 
		  try {		  
			 parent.applyscale(scaleno,level,step,curr,contractid);	
		  } catch(e) {}				      
		  parent.ProsisUI.closeWindow('mydialog',true)	
	
	}
	
	</script>

</CFOUTPUT>

<table width="98%" align="center">

<tr><td>

<table width="100%" class="navigation_table">

<tr><td colspan="6" style="font-size:20px" class="labelmedium2"><cfoutput>#url.mission#</cfoutput></TD></tr>

<TR class="line labelmedium2 fixlengthlist">    
    <TD><cf_tl id="Schedule"></TD>
	<TD><cf_tl id="Location"></TD>
	<TD></TD>
    <TD align="center"><cf_tl id="Grade"></TD>
	<TD align="center"><cf_tl id="Step"></TD>	 
	<TD align="right"><cf_tl id="Base Amount"></TD>	  
</TR>
 
<cfoutput query="SearchResult" group="SalarySchedule">

<tr><td colspan="6" style="padding-left:4px" class="labelmedium">#SalarySchedule# #SalaryScheduleName# (#PaymentCurrency#)</TD></tr>

	<cfoutput group="ServiceLocation">
	
	<tr class="line">	  
	    <td colspan="6" style="padding-left:7px" class="labelmedium2">#ServiceLocation# #Description#</td>
	</tr>
	
		<cfoutput group="ServiceLevel">
		
			<cfoutput group="ServiceStep">
			
			<TR class="navigation_row line fixlengthlist labelmedium2">
				
				<td align="center" style="padding-top:5px">
						<cf_img icon="select" navigation="Yes" 
						 onclick="selected('#scaleno#','#ServiceLevel#','#ServiceStep#','#PaymentCurrency#','#url.contractid#')"> 		
				</td>
				<td></td>
				<td>#dateformat(SalaryEffective,client.dateformatshow)#</td>
				<td align="center">#ServiceLevel#</td>
				<td align="center">#ServiceStep#</td>
				<td align="right" style="padding-right:10px">#numberformat(BasePayroll,",.__")#</td>
			</TR>
						
			</cfoutput>
		
		</cfoutput>
		
	</cfoutput>
	
</cfoutput>

</TABLE>

</tr></td>
</table>
