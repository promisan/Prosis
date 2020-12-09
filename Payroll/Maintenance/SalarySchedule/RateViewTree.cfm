
<cfparam name="url.operational" default="1">

<cfquery name="Effective" 
   datasource="AppsPayroll" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	SELECT   DISTINCT S.ServiceLocation, D.Description, S.SalaryFirstApplied, S.SalaryEffective
	FROM     SalaryScale S, Ref_PayrollLocation D
	WHERE    S.ServiceLocation = D.LocationCode
	AND      S.Mission          = '#URL.Mission#' 
	AND      S.SalarySchedule   = '#URL.Schedule#' 	
	AND      S.Operational      = '#url.operational#'
	ORDER BY ServiceLocation, SalaryFirstApplied DESC, SalaryEffective 
</cfquery>

<cfif effective.recordcount eq "0">

<table align="center"><tr><td style="padding-top:10px"><cf_tl id="No scales found"></td></tr></table>

<cfelse>

<!--- no rates found --->
	
<table height="100%" width="100%" align="center">
  
  	 <tr><td height="3"></td></tr>
      <tr>
        <td valign="top" style="height:100%;padding-top:4px;padding-left:5px"> 
				
		<cf_divscroll>
		
		<cf_UItree id="root"
			title="<span style='font-size:16px;color:gray;padding-bottom:3px'>#url.mission#</span>"	
			expand="Yes">
						   
		   <cfoutput query="Effective" group="ServiceLocation">
		   
		   		  <cfif servicelocation eq url.location>
				    <cfset exp = "Yes">
				  <cfelse>
				    <cfset exp = "no">	
				  </cfif>
				  
				  <cf_UItreeitem value="#ServiceLocation#"
			        display="<span style='font-size:16px;padding-top:5px;padding-bottom:5px;font-weight:bold' class='labellarge'>#ServiceLocation# #Description#</span>"						
					parent="root"	
					target="right"
					href="Blank.cfm"						
			        expand="#exp#">	
		   									
					<cfoutput group="SalaryFirstApplied">
					
						<cfif month(SalaryFirstApplied) neq month(SalaryEffective)>
							<cfset val = "#dateformat(SalaryFirstApplied,'YYYY/MM')# [eff:#dateformat(SalaryEffective,'YYYY/MM')#]">
						<cfelse>
							<cfset val = "#dateformat(SalaryFirstApplied,'YYYY/MM')#">						
						</cfif>
						
						 <cf_UItreeitem value="#ServiceLocation#_#currentrow#"
					        display="<span style='font-size:14px;' class='labelit'>#val#</span>"						
							parent="#ServiceLocation#"	
							target="right"
							href="RateEdit.cfm?Effective=#SalaryEffective#&Schedule=#url.schedule#&Mission=#url.Mission#&Location=#servicelocation#&operational=#url.operational#&mode=Grade"						
					        expand="Yes">
												
                            
							<cf_UItreeitem value="#ServiceLocation#_#currentrow#_1"
					        display="<span style='font-size:13px;' class='labellarge'>Grades scale</span>"						
							parent="#ServiceLocation#_#currentrow#"	
							href="RateEdit.cfm?Effective=#SalaryEffective#&Schedule=#url.schedule#&Mission=#url.Mission#&Location=#servicelocation#&operational=#url.operational#&mode=Grade"
							target="right"
							img="#SESSION.root#/Images/Incoming.png"			
					        expand="No">		
							
							<cf_UItreeitem value="#ServiceLocation#_#currentrow#_2"
					        display="<span style='font-size:13px;' class='labellarge'>Percentages</span>"						
							parent="#ServiceLocation#_#currentrow#"	
							href="RateEdit.cfm?Effective=#SalaryEffective#&Schedule=#url.schedule#&Mission=#url.Mission#&Location=#servicelocation#&operational=#url.operational#&mode=percentage"
							target="right"
							img="#SESSION.root#/Images/Incoming.png"			
					        expand="No">	
							
							<cf_UItreeitem value="#ServiceLocation#_#currentrow#_3"
					        display="<span style='font-size:13px;' class='labellarge'>Other Rates</span>"						
							parent="#ServiceLocation#_#currentrow#"	
							href="RateEdit.cfm?Effective=#SalaryEffective#&Schedule=#url.schedule#&Mission=#url.Mission#&Location=#servicelocation#&operational=#url.operational#&mode=rate"
							target="right"
							img="#SESSION.root#/Images/Incoming.png"			
					        expand="No">				
					
					</cfoutput>
								
			</cfoutput>		
		
		</cf_UItree>
								
		</cf_divscroll>
												
		</td>
	  </tr>
	  	  
</table>

</cfif>
