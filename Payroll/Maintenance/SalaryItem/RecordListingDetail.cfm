<cfquery name="SearchResult"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	I.*, 
	        			
			(SELECT count(*)
		 	 FROM 	SalarySchedulePayrollItem
			 WHERE 	PayrollItem     = I.PayrollItem
			 AND	Operational   = 1 ) as Used,
			 			
			(SELECT count(*)
			 FROM   Ref_PayrollComponent S 
			 WHERE  I.PayrollItem = S.PayrollItem) as counted			 
			 
	FROM 	#client.lanPrefix#Ref_PayrollItem I INNER JOIN Ref_SlipGroup R ON I.PrintGroup = R.PrintGroup
			
	ORDER BY PrintGroupOrder,
			 I.Source,	        
			 PrintOrder, 			 
			 I.PayrollItem
</cfquery>

<table width="95%" align="center" class="navigation_table">

<tr class="labelmedium fixrow fixlengthlist">
   	<TD style="padding-left:4px;height:20"><cf_tl id="Section"></TD> 
	<TD><cf_tl id="Code"></TD>
	<TD><cf_tl id="Description"></TD>
	<TD><cf_tl id="Payslip Name"></TD>
	<TD><cf_tl id="Components"></TD>	
    <TD><cf_tl id="Entered"></TD>  
</TR>

<cfoutput query="SearchResult" group="PrintGroup">

  <TR class="line fixrow2" style="top:45px;">
	<TD COLSPAN="6" style="font-weight:290;font-size:32px;height:47;padding-left:8px" class="labelmedium">#PrintGroup#</TD>	
  </TR>
  
<cfoutput group="Source">

 <TR class="line fixrow3">
	<TD COLSPAN="6" style="top:65px;font-weight:200;font-size:20px;height:40;padding-left:8px" class="labelmedium">#Source#</TD>	
  </TR>
  
<cfoutput group="Printorder">    

	<cfoutput group="PayrollItem">   
	 
	    <TR class="navigation_row line labelmedium fixlengthlist" style="height:22px">
			<td width="6%" align="center" style="height:14">
				<table align="right">
					<tr>
						<td>						
							<cfif Used eq 0>
								<cf_img icon="delete" onclick="recordpurge('#PayrollItem#')"> 
							</cfif>
						</td>
						<td width="3"></td>
						<td>
							<cf_img icon="open" navigation="Yes" onclick="recordedit('#PayrollItem#')">
						</td>
						<td width="10"></td>
					</tr>
				</table>			  
			</td>			
			<td>#PayrollItem#</td>
			<TD>#PayrollItemName#</TD>
			<TD style="padding-left:5px">#PrintDescription#</TD>
			
			<cfif counted lte "1">
			   <cfset ht = "21">
			<cfelseif counted eq "2">
			   <cfset ht = "42">	
			<cfelse>
			   <cfset ht = "42">
			</cfif>
				
			<TD style="min-width:300px;height:#ht#px;background-color:##f1f1f180">	
			
			<cfquery name="Component"
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT 	*								 
					FROM 	Ref_PayrollComponent R 
					WHERE   R.PayrollItem = '#payrollitem#'												
					ORDER BY R.Description
				</cfquery>   

				<div style="max-height:#ht#px;" class="toggleScroll-y">
					<cfloop query="Component">
					<table width="100%">				   									
						<tr class="labelmedium <cfif currentrow neq recordcount>line</cfif>" style="height:10px"><td style="padding-left:4px;padding-right:4px">#Description# (#Period#)</td></tr>								
					</table>
					</cfloop>
				</div>	
							
			</TD>
			
			<TD style="padding-left:3px;padding-right:3px">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
	    </TR>
		
	</CFOUTPUT>	
	
</CFOUTPUT>	
	
</CFOUTPUT>

</CFOUTPUT>

</TABLE>

<cfset AjaxOnLoad("doHighlight")>	