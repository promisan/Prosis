
<cfset FileNo = round(Rand()*100)>

<cf_screentop height="100%" scroll="No" html="No" busy="busy10.gif" jquery="Yes" ValidateSession="No">

<cfparam name="URL.id1"  	  default="">
<cfparam name="URL.doFilter"  default="0">

<cfajaximport tags="cfdiv">
<input type="hidden" value="refresh" id="refreshbutton" onclick="parent.document.getElementById('refreshbutton').click()">

<cfif url.id neq "WHS">

    <cf_dialogProcurement>

	<cf_dialogStaffing>
	<cf_dialogMaterial>
	<cf_dialogLedger>	
	<cf_annotationscript>
	<cfinclude template="RequisitionViewViewScript.cfm">
			
</cfif>

<table height="100%" width="100%">

    <tr class="hide"><td id="process"></td></tr>
	
    <cfif url.id1 eq "Locate">
		<tr><td height="100">
			<cfinclude template="RequisitionViewLocate.cfm">			
		</td></tr>		
		<tr><td valign="top" style="height:100%;padding-right:4px" id="detail"></td></tr>
		
	<cfelseif url.id eq "WRF">
	
		<cf_timesheetscript>
		
		<cfquery name="getPeriod" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
	        password="#SESSION.dbpw#">
			SELECT 	*
			FROM 	Ref_Period
			WHERE	Period  = '#url.Period#'			
		</cfquery>
		
		<cfif now() lte getPeriod.DateExpiration>
		   <cfset per = now()>
		<cfelse>
			<cfset per = getPeriod.DateExpiration>
		</cfif>
						
	   <table width="100%" height="100%" align="center">		
	   
	    <cfoutput>	   
	    <tr><td style="padding-left:25px;padding-right:25px;padding-top:15px" class="labellarge"><b>Workforce for which one or more requisitions were raised for positions in #url.period#</td></tr>		
		</cfoutput>
		
		<tr><td width="100%" height="100%" valign="top" align="center" style="padding-left:25px;padding-right:25px;padding-top:15px">	
		<cf_divscroll id="detail" style="height:100%;padding-top:4px;padding-bottom:4px;padding-right:10px">
		<cf_TimeSheetView label="Staff part of requisitions reviewed" tableborder="0" selectiondate="#per#" object="Requisition" objectkeyvalue1="#url.mission#" objectkeyvalue2="#url.period#">	
		</cf_divscroll>
				
		</td></tr>		
		
		<tr><td height="5"></td></tr>
		</table>	
				
	<cfelse>
		<tr><td height="100%" style="padding-top:3px;padding-left:1px;padding-right:2px" valign="top" width="100%">						
		 <cf_divscroll id="detail" style="height:100%;padding-top:4px;padding-bottom:4px"> 					 
		    <cfinclude template="RequisitionViewGeneral.cfm">					
		 </cf_divscroll>	
			</td>
		</tr>	
	</cfif>
</table>
