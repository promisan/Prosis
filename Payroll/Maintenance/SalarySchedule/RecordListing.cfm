
<cfparam name="url.init" default="0">

<cf_screentop height="100%" html="No" scroll="Yes" jQuery="Yes">

<table width="100%" height="100%" align="center" >
<tr><td colspan="2" height="10">

<cfset Page         = "0">
<cfset add          = "1">
<cfset Header       = "Salary Schedule and Payroll Scales">
<cfinclude template = "../HeaderPayroll.cfm"> 

</td></tr>

<cfif url.init eq "1">	
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

<cf_dialogLedger>
<cf_calendarscript>

<cfajaximport tags="cfform">

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
	    ProsisUI.createWindow('misdialog', 'Details', '',{x:100,y:100,height:325,width:700,resizable:false,modal:true,center:true})	
	    ptoken.navigate('MissionEdit.cfm?idmenu=#URL.idmenu#&schedule=' + sch + '&mission=' + mis, 'misdialog');
	}
		
	function missioneditsubmit(sch,mis,act) {
		document.formmission.onsubmit() 
		if( _CF_error_messages.length == 0 ) {           
			ptoken.navigate('MissionEditSubmit.cfm?idmenu=#URL.idmenu#&action='+act+'&mission='+mis+'&schedule='+sch,'processmanual','','','POST','formmission')
		}   
    }	
	
	function applyaccount(acc) {
	    ptoken.navigate('setAccount.cfm?account='+acc,'processmanual')
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
	
<tr><td colspan="2" style="padding-top:5px">

	<table width="97%" height="100%" align="center" class="navigation_table">
	
	 <tr><td class="labellarge" style="padding-left:6px;font-size:30px;height:50px">Salary schedule and Rates</td>
		 <td align="right" style="padding-right:6px">
		   <input class="button10g" style="width:150px" type="button" name="Init" value="Initialise" onclick="reloadForm()">		
		 </td>
	</tr>
	
	<tr class="hide"><td id="process"></td></tr>
	<tr><td colspan="2" width="100%" height="100%" valign="top">
	
	<cf_divscroll>
	
		<table width="98%">
		 
			<tr class="line labelmedium fixlengthlist" style="height:20px;">
		    <td align="center"></td>
		    <td><cf_tl id="Code"></td>
			<td><cf_tl id="Name"></td>
			<td><cf_tl id="Modality"></td>			
			</tr>					
		
		<cfoutput query="SearchResult" group="SalarySchedule"> 		    
			
		    <tr class="labelmedium navigation_row line fixlengthlist">
				<td style="height:30px" align="center">
					<cf_img icon="edit" navigation="Yes" onclick="recordedit('#SalarySchedule#')">
				</td>
				<td style="font-size:19px">#SalarySchedule#</td>
				<td>#Description#</td>
				<td>
				<cfif SalaryCalculationPeriod eq "MONTH">
				<cfif SalaryBasePeriodDays eq "30">Actual Calendar Days (28-31)
				<cfelseif SalaryBasePeriodDays eq "30fix">Fixed 30 Day month
				<cfelse>Average Working days (21.75)
				</cfif>
				</cfif>
				#PaymentCurrency#
				(<cfif SalaryBaseRate eq "1">Rate<cfelse>Negotiated Amount</cfif>)
				</td>
				
			</tr>	
			
			<cfoutput group="Mission"> 		
			
				<tr class="labelmedium line fixlengthlist">
				
				<td></td>
										
				<td style="padding-left:10px" bgcolor="D3E9F8">
				   
				   <a href="javascript:missionedit('#SalarySchedule#','#mission#')">#Mission#</a>
				   
				</td>
				<td style="padding-left:4px">#dateformat(DateEffective,CLIENT.DateFormatShow)#</td>			
											
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
					
					    <td id="#rowguid#" style="padding-left:5px;border-left:1px solid silver;border-bottom:1px solid silver;border-right:1px solid silver;">
						
							<table><tr class="labelmedium">
							
							<td style="padding-top:2px"><cf_img icon="open" onclick="rate('#SalarySchedule#','#Mission#','#ServiceLocation#')"></td>
							
							<td>#ServiceLocation#&nbsp;#LocationDescription#
												
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
							<td style="padding-left:3px;padding-top:2px;">
							
							  <cfif check.recordcount eq "0">
								<cf_img icon="delete" onclick="removelocation('#SalarySchedule#','#Mission#','#ServiceLocation#','#rowguid#')">
							  </cfif>
							  
							</td>
							</tr>
							</table>
						
						</td>
											
						<cfif cnt eq "3">
						</tr>
						<tr><td></td><td></td><td></td>
						<cfset cnt = 0>
						</cfif>		
						
						<cfset cnt = cnt+1>				
						
					</cfloop>				
					
		 	</cfoutput>			
			
			<tr><td style="height:3px"></td></tr>
				
		</cfoutput>
		
		</table>
	
	</cf_divscroll>			
		
	</td></tr>
	</table>

</td>
</tr>

</table>

<cf_screenbottom html="No">
