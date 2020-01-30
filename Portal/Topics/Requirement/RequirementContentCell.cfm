
<cfoutput>

	<cfif scope eq "total">
	    <cfset sc = "qSUM.">
	<cfelse>
		<cfset sc = ""> 
	</cfif>

	<cfset vDivisor = 1000.0>
			
	<td align="right" class="labelit mycell" style="padding-right:3px" bgcolor="#vNewColor#">		
		<cfif scope eq "total">
		#lsNumberFormat(qSum.Staff_new,",")#							
		<cfelse>
		#lsNumberFormat(Staff_new,",")#	
		</cfif>		
	</td>
	<td align="right" class="labelit mycell" style="padding-right:3px" bgcolor="#vNewColor#">		
		<cfif scope eq "total">
		#lsNumberFormat(qSum.FTE_new,",._")#							
		<cfelse>
		#lsNumberFormat(FTE_new,",._")#	
		</cfif>		
	</td>
	<td align="right" class="labelit mycell" style="padding-right:3px" bgcolor="#vNewColor#">	
	    <cfif scope eq "total">			   									
		#lsNumberFormat(qSum.Cost_new/vDivisor,",")#							
		<cfelse>
		#lsNumberFormat(Cost_new/vDivisor,",")#	
		</cfif>
	</td>
	<td align="right" class="labelit mycell" bgcolor="#vContinueColor#" style="color:##FFFFFF;padding-right:3px">					
	    <cfif scope eq "total">
		#lsNumberFormat(qSum.Staff_continued,",")#						 	
		<cfelse>
		#lsNumberFormat(Staff_continued,",")#	
		</cfif>		
	</td>
	<td align="right" class="labelit mycell" bgcolor="#vContinueColor#" style="color:##FFFFFF;padding-right:3px">					
	    <cfif scope eq "total">
		#lsNumberFormat(qSum.FTE_continued,",._")#						 	
		<cfelse>
		#lsNumberFormat(FTE_continued,",._")#	
		</cfif>		
	</td>
	
	<td align="right" class="labelit mycell"  bgcolor="#vContinueColor#" style="color:##FFFFFF;padding-right:3px">												
	    <cfif scope eq "total">
		#lsNumberFormat(qSum.Cost_continued/vDivisor,",")#	
		<cfelse>
		#lsNumberFormat(Cost_continued/vDivisor,",")#						
		</cfif>
	</td>
	<td align="right" class="labelit mycell"  bgcolor="#vOtherColor#" style="color:##FFFFFF;padding-right:3px">		
		<cfif scope eq "total">
			<cfset Other = qSum.Cost_total - qSum.Cost_new - qSum.Cost_continued>							
			#lsNumberFormat((Other)/vDivisor,",")#
		<cfelse>	
			<cfset Other = Cost_total - Cost_new - Cost_continued>							
			#lsNumberFormat((Other)/vDivisor,",")#
		</cfif>
	</td>
	<td align="right" class="labelit mycell"  bgcolor="#vTotalColor#" style="color:##FFFFFF;padding-right:3px">		
	    <cfif scope eq "total">			
		#lsNumberFormat(qSum.Cost_Total/vDivisor,",")#
		<cfelse>
		#lsNumberFormat(Cost_Total/vDivisor,",")#
		</cfif>
	</td>					
	<cfloop index="qtr" from="1" to="4">
	<td align="right" class="labelit mycell"  bgcolor="#vqColor#" style="padding-right:3px">		
		<cfif scope eq "total">
		    <cfset val = evaluate("qSum.Cost_#qtr#")>				
		<cfelse>
		    <cfset val = evaluate("Cost_#qtr#")>
		</cfif>
		#lsNumberFormat(val/vDivisor,",")#	
	</td>
	</cfloop>	
	
</cfoutput>		
