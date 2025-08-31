<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfoutput>

	<cfif scope eq "total">
	    <cfset sc = "qSUM.">
	<cfelse>
		<cfset sc = ""> 
	</cfif>

	<cfset vDivisor = 1000.0>
			
	<td align="right" class="labelmedium mycell" style="padding-right:3px;background-color:###vNewColor#80">		
		<cfif scope eq "total">
		#lsNumberFormat(qSum.Staff_new,",")#							
		<cfelse>
		#lsNumberFormat(Staff_new,",")#	
		</cfif>		
	</td>
	<td align="right" class="labelmedium mycell" style="padding-right:3px;background-color:###vNewColor#80">		
		<cfif scope eq "total">
		#lsNumberFormat(qSum.FTE_new,",._")#							
		<cfelse>
		#lsNumberFormat(FTE_new,",._")#	
		</cfif>		
	</td>
	<td align="right" class="labelmedium mycell" style="padding-right:3px;background-color:###vNewColor#80">	
	    <cfif scope eq "total">			   									
		#lsNumberFormat(qSum.Cost_new/vDivisor,",")#							
		<cfelse>
		#lsNumberFormat(Cost_new/vDivisor,",")#	
		</cfif>
	</td>
	<td align="right" class="labelmedium mycell" style="background-color:###vContinueColor#80;padding-right:3px">					
	    <cfif scope eq "total">
		#lsNumberFormat(qSum.Staff_continued,",")#						 	
		<cfelse>
		#lsNumberFormat(Staff_continued,",")#	
		</cfif>		
	</td>
	<td align="right" class="labelmedium mycell" style="background-color:###vContinueColor#80;padding-right:3px">					
	    <cfif scope eq "total">
		#lsNumberFormat(qSum.FTE_continued,",._")#						 	
		<cfelse>
		#lsNumberFormat(FTE_continued,",._")#	
		</cfif>		
	</td>
	
	<td align="right" class="labelmedium mycell"  style="background-color:###vContinueColor#80;padding-right:3px">												
	    <cfif scope eq "total">
		#lsNumberFormat(qSum.Cost_continued/vDivisor,",")#	
		<cfelse>
		#lsNumberFormat(Cost_continued/vDivisor,",")#						
		</cfif>
	</td>
	<td align="right" class="labelmedium mycell"  style="background-color:###vOtherColor#80;padding-right:3px">		
		<cfif scope eq "total">
			<cfset Other = qSum.Cost_total - qSum.Cost_new - qSum.Cost_continued>							
			#lsNumberFormat((Other)/vDivisor,",")#
		<cfelse>	
			<cfset Other = Cost_total - Cost_new - Cost_continued>							
			#lsNumberFormat((Other)/vDivisor,",")#
		</cfif>
	</td>
	<td align="right" class="labelmedium mycell"  style="background-color:###vTotalColor#80;padding-right:3px">		
	    <cfif scope eq "total">			
		#lsNumberFormat(qSum.Cost_Total/vDivisor,",")#
		<cfelse>
		#lsNumberFormat(Cost_Total/vDivisor,",")#
		</cfif>
	</td>					
	<cfloop index="qtr" from="1" to="4">
	<td align="right" class="labelmedium mycell" style="background-color:###vqColor#80;padding-right:3px">		
		<cfif scope eq "total">
		    <cfset val = evaluate("qSum.Cost_#qtr#")>				
		<cfelse>
		    <cfset val = evaluate("Cost_#qtr#")>
		</cfif>
		#lsNumberFormat(val/vDivisor,",")#	
	</td>
	</cfloop>	
	
</cfoutput>		
