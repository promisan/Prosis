
<cfparam name="url.init" default="0">

<cf_screentop height="100%" html="No" scroll="Yes" jQuery="Yes">

<table width="100%" height="100%" cellspacing="0" cellpadding="0" align="center" >
<tr><td colspan="2" height="10">

<cfset Page         = "0">
<cfset add          = "1">
<cfset Header       = "Salary Schedule and Payroll Scales">
<cfinclude template = "../HeaderPayroll.cfm"> 

</td></tr>

<cfif url.init eq "1">
	<cfflush>
	<cfinclude template="CreateScale.cfm">
</cfif>

<cfquery name="SearchResult"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
	FROM     SalarySchedule S, 
	         SalaryScheduleMission M
	WHERE    S.SalarySchedule = M.SalarySchedule
	ORDER BY S.ListingOrder
</cfquery>

<cfoutput>

<script>
	
	w = #CLIENT.width# - 100;
	h = #CLIENT.height# - 150;
		
	function reloadForm(page) {
	     ptoken.location("RecordListing.cfm?idmenu=#URL.IDMenu#&init=1"); 
	}
	
	function recordadd(grp) {
	   ptoken.open("ScheduleAdd.cfm?idmenu=#URL.idmenu#&id=", "Add", "left=80, top=80, width=660, height=480, toolbar=no, status=yes, scrollbars=no, resizable=yes");
	}
	
	function recordedit(id1) {
	    ptoken.open("ScheduleEdit.cfm?idmenu=#URL.idmenu#&id1=" + id1, id1+"Edit")	
	}
	
	function missionedit(sch,mis) {
	    ptoken.open("MissionEdit.cfm?idmenu=#URL.idmenu#&schedule=" + sch + "&mission=" + mis, "Mission", "left=80, top=80, width=900, height=700, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function rate(sch,mis,loc) {   
	    ptoken.open("RateView.cfm?idmenu=#url.idmenu#&Schedule=" + sch + "&Mission=" + mis + "&Location=" + loc, "Edit");
	}
	
	function removelocation(sch,mis,loc,id) {
	    _cf_loadingtexthtml='';	
		ptoken.navigate("deleteLocation.cfm?idmenu=#url.idmenu#&Schedule=" + sch + "&Mission=" + mis + "&Location=" + loc, id)
	}

</script>	

</cfoutput>
	
<tr><td colspan="2" style="Padding-top:5px">

	<table width="97%" height="100%" cellspacing="0" cellpadding="0" border="0" align="center" class="navigation_table">
	
	 <tr><td height="30" class="labellarge" style="font-size:30px;height:50px">&nbsp;Salary schedule and Rates</td>
		 <td align="right">
		   <input class="button10g" style="width:150px" type="button" name="Init" value="Initialise" onclick="reloadForm()">		
		 </td>
	</tr>
	
	<tr><td colspan="2" width="100%" height="100%" valign="top">
	
	<cf_divscroll>
	
		<table width="98%">
		 
			<tr class="line fixrow" style="height:20px;">
		    <td width="4%" class="labelit" align="center"></td>
		    <td width="10%" class="labelit"><cf_tl id="Code"></td>
			<td width="20%" class="labelit"><cf_tl id="Name"></td>
			<td class="labelit"><cf_tl id="Period"></td>
			<td class="labelit"><cf_tl id="Currency"></td>
			<td class="labelit"><cf_tl id="Base Salary"></td>	
			</tr>
			
			<!---	
			<tr class="labelit">
			
			    <td width="4%" bgcolor="ffffff"></td>		
									
				<td style="border-bottom:1px solid silver" width="22%"><font color="808080"><cf_tl id="Entity"></td>
							
				<td style="border-bottom:1px solid silver" width="22%"><font color="808080"><cf_tl id="Payroll Location"></td>
				<td style="border-bottom:1px solid silver" width="10%"><font color="808080"><cf_tl id="Ctr"></td>
					
				<td style="border-bottom:1px solid silver" width="22%"><font color="808080"><cf_tl id="Payroll Location"></td>
				<td style="border-bottom:1px solid silver" width="10%"><font color="808080"><cf_tl id="Ctr"></td>
				
				<td style="border-bottom:1px solid silver" width="22%"><font color="808080"><cf_tl id="Payroll Location"></td>
				<td style="border-bottom:1px solid silver" width="10%"><font color="808080"><cf_tl id="Ctr"></td>
					
			</tr>
			--->						
		
		<cfoutput query="SearchResult" group="SalarySchedule"> 
		     
			<tr><td style="height:15px"></td></tr> 
		    <tr class="labelmedium navigation_row line">
				<td style="height:30px" align="center">
					<cf_img icon="edit" navigation="Yes" onclick="recordedit('#SalarySchedule#');">
				</td>
				<td style="min-width:150px;font-size:21px"><a href="javascript:recordedit('#SalarySchedule#')">#SalarySchedule#</a></td>
				<td style="min-width:300px">#Description#</td>
				<td>#SalaryCalculationPeriod#
				<cfif SalaryCalculationPeriod eq "MONTH">(#SalaryBasePeriodDays#)<cfelse>(#SalaryBasePeriod#)</cfif></td>
				<td>#PaymentCurrency#</td>
				<td><cfif SalaryBaseRate eq "1">Rate<cfelse>Negotiated Amount</cfif></td>		
			</tr>	
			
			<cfoutput group="Mission"> 		
			
				<tr class="labelmedium">
				
				<td></td>
										
				<td style="padding-left:10px" bgcolor="D3E9F8"><a href="javascript:missionedit('#SalarySchedule#','#mission#')">#Mission#</a>&nbsp;(#dateformat(DateEffective,CLIENT.DateFormatShow)#)</td>			
											
					<cfquery name="Location"
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT DISTINCT 
						       P.SalarySchedule,
							   P.Mission, 
							   P.ServiceLocation, 
							   L.Description as LocationDescription
						FROM   SalaryScale P, 
							   Ref_PayrollLocation L
						WHERE  L.LocationCode   = P.ServiceLocation
						AND    P.SalarySchedule = '#SalarySchedule#'
						AND    P.Mission        = '#Mission#'
						ORDER BY ServiceLocation
					</cfquery>					
											
					<cfif location.recordcount gte 1>
					
						<cfset cnt = 1>
						
					</cfif>
					
					<cfloop query="location">	
														
						<cfquery name="check"
						datasource="AppsPayroll" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT TOP 1 *
							FROM   SalaryScaleLine L, SalaryScale P
							WHERE  L.ScaleNo = P.ScaleNo
							AND    ServiceLocation  = '#ServiceLocation#'
							AND    P.SalarySchedule  = '#SalarySchedule#'
							AND    Mission         = '#Mission#'					
						</cfquery>			
						
						<cf_assignid>
					
					    <td class="labelit" id="#rowguid#" style="padding-left:5px">
						
							<table><tr><td style="font-size:14px">					
							<a href="javascript:rate('#SalarySchedule#','#Mission#','#ServiceLocation#')">#ServiceLocation#&nbsp;#LocationDescription#</a>
												
							   <cfquery name="Contract"
								datasource="AppsEmployee" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT  COUNT(*) AS Total
									FROM    PersonContract
									WHERE   DateEffective < getdate() 
									AND     DateExpiration >= getdate()
									AND     ActionStatus IN ('0','1')
							   	    AND 	SalarySchedule  = '#SalarySchedule#' 
									AND 	ServiceLocation = '#ServiceLocation#'
									AND     Mission         = '#Mission#'								 
								</cfquery>		
							 	 	 	 
								(#Contract.total#)								 
								 					
							</td>
							<td style="padding-left:3px">
							
							  <cfif check.recordcount eq "0">
								<cf_img icon="delete" onclick="removelocation('#SalarySchedule#','#Mission#','#ServiceLocation#','#rowguid#')">
							  </cfif>
							  
							</td>
							</tr>
							</table>
						
						</td>
											
						<cfif cnt eq "3">
						</tr>
						<tr><td></td><td></td>
						<cfset cnt = 0>
						</cfif>		
						
						<cfset cnt = cnt+1>				
						
					</cfloop>				
					
		 	</cfoutput>			
				
		</cfoutput>
		
		</table>
	
	</cf_divscroll>			
		
	</td></tr>
	</table>

</td>
</tr>

</table>

<cf_screenbottom html="No">
