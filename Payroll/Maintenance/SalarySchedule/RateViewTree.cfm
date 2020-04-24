
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
	
<table height="100%" width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
  
  	 <tr><td height="3"></td></tr>
      <tr>
        <td valign="top" style="height:100%;padding-top:4px;padding-left:5px"> 
				
		<cf_divscroll>
		
		<cfform>
				
		<cftree name="root"
		   font="calibri"
		   fontsize="15"		
		   bold="No"   
		   format="html"    
		   required="No">  
	   
		   <cfoutput query="Effective" group="ServiceLocation">
		   
		   		  <cfif servicelocation eq url.location>
				    <cfset exp = "Yes">
				  <cfelse>
				    <cfset exp = "no">	
				  </cfif>
		   
				  <cftreeitem value="#ServiceLocation#"
			        display="<span style='color:black'>#ServiceLocation# #Description#</span>"						
					parent="root"	
					href="Blank.cfm"						
					target="right"								
			        expand="#exp#">	
					
					<cfoutput group="SalaryFirstApplied">
					
						<cfif month(SalaryFirstApplied) neq month(SalaryEffective)>
							<cfset val = "#dateformat(SalaryFirstApplied,'YYYY/MM')# [eff:#dateformat(SalaryEffective,'YYYY/MM')#]">
						<cfelse>
							<cfset val = "#dateformat(SalaryFirstApplied,'YYYY/MM')#">						
						</cfif>
											
						<cftreeitem value="#ServiceLocation#_#currentrow#"
				        display="<span style='color:black'>#val#</span>"	
						href="RateEdit.cfm?Effective=#SalaryEffective#&Schedule=#url.schedule#&Mission=#url.Mission#&Location=#servicelocation#&operational=#url.operational#&mode=Grade"																		
						parent="#ServiceLocation#"							
						target="right"								
				        expand="Yes">	
                            
							<cftreeitem value="#ServiceLocation#_#currentrow#_1"
					        display="Grades scale"						
							parent="#ServiceLocation#_#currentrow#"	
							href="RateEdit.cfm?Effective=#SalaryEffective#&Schedule=#url.schedule#&Mission=#url.Mission#&Location=#servicelocation#&operational=#url.operational#&mode=Grade"
							target="right"
							img="#SESSION.root#/Images/Incoming.png"			
					        expand="No">		
							
							<cftreeitem value="#ServiceLocation#_#currentrow#_2"
					        display="Percentages"						
							parent="#ServiceLocation#_#currentrow#"	
							href="RateEdit.cfm?Effective=#SalaryEffective#&Schedule=#url.schedule#&Mission=#url.Mission#&Location=#servicelocation#&operational=#url.operational#&mode=percentage"
							target="right"
							img="#SESSION.root#/Images/Incoming.png"			
					        expand="No">	
							
							<cftreeitem value="#ServiceLocation#_#currentrow#_3"
					        display="Other Rates"						
							parent="#ServiceLocation#_#currentrow#"	
							href="RateEdit.cfm?Effective=#SalaryEffective#&Schedule=#url.schedule#&Mission=#url.Mission#&Location=#servicelocation#&operational=#url.operational#&mode=rate"
							target="right"
							img="#SESSION.root#/Images/Incoming.png"			
					        expand="No">				
					
					</cfoutput>
								
			</cfoutput>		
		
		</cftree> 	
		
		</cfform>	
						
		</cf_divscroll>
												
		</td>
	  </tr>
	  	  
</table>

</cfif>
