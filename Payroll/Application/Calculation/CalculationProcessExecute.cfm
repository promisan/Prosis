<!--
    Copyright © 2025 Promisan

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

<cfquery name="Last" 
	datasource="appsPayroll"	 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   TOP 1 *
	FROM     CalculationLog	
	ORDER BY Created DESC
</cfquery>

<cfif last.recordcount eq "0">
   <cfset nextprocess = 1>
<cfelse>
   <cfset nextprocess = last.ProcessNo + 1>   
</cfif>

<cfoutput>

<!---
<cf_screentop html="no" height="100%" scroll="Yes" label="Payroll Calculation Batch" layout="webapp" banner="Yellow" user="No">
--->

<table bgcolor="white" width="100%" height="100%" class="formpadding">

	<tr><td valign="center" align="center">
	
		<table width="94%" height="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		
		<tr><td class="labelmedium" style="padding:2px" width="130"><cf_tl id="Payroll">:</td>
		    <td class="labelmedium" width="70%" style="padding:2px"><cf_tl id="Calculation"></td></tr>
		<tr class="line"><td class="labelmedium" style="padding:2px"><cf_tl id="Officer">:</b></td>
		    <td class="labelmedium" style="padding:2px">#SESSION.first# #SESSION.last# on #timeformat(now(),"HH:MM:SS")#</td></tr>
		
		<!--- at some point for CICIG 
					
		<tr class="hide"><td class="labelmedium" style="padding:2px"><cf_tl id="Specific Employee"></td>
		    <td class="labelmedium" style="padding:2px">
			
			<cfset link = "getPerson.cfm?field=PersonNo">	
		
			<table cellspacing="0" cellpadding="0" width="96%">
					<tr>
									
								
						<td width="90%" id="employee">
						<input type="hidden" id="personno" name="personno" value="">	
						</td>
						
						<td width="20" style="padding-left:1px">
							
						   <cf_selectlookup
							    box        = "employee"
								link       = "#link#"
								button     = "Yes"
								close      = "Yes"						
								icon       = "search.png"
								iconheight = "25"
								iconwidth  = "25"
								class      = "employee"
								des1       = "PersonNo">
								
						</td>	
										
								
					</tr>
				</table>		
			
			
			</td>
		</tr>
		
		--->
				
		<tr class="hide"><td colspan="2" class="hide" id="runbox"></td></tr>
		<tr class="line"><td colspan="2" style="height:100%" valign="top">
		<cfdiv id="progressbox" style="position:relative;overflow: auto; width:100%; height:330; scrollbar-face-color: F4f4f4;">
			
			<table width="100%" cellspacing="0" cellpadding="0">
			<tr><td colspan="2" align="center" height="320">
			    
				<button onclick="payrollprocess('#nextprocess#','','','',''); prg = setInterval('showprogresscalculate(\'#nextprocess#\')', 5000)"			
				    class="button10g" 
					name="execute" 
					style="height:40px"
					type="button"
					value="Close">
					<table align="center"><tr class="labelmedium"><td>
					<img src="#SESSION.root#/Images/play.png" height="18" width="18" border="0" align="absmiddle">
					</td>
					<td style="font-size:17px;padding-left:4px"><cf_tl id="Start"></td>
					</tr>
					</table>
					
				</button>
				</td>
			</tr>	
			</table>
			
		</cfdiv>
		</td></tr>
		
		<tr><td align="center" colspan="2">
		<input type="button" onclick="ProsisUI.closeWindow('executetask');history.go()" class="button10g" name="Close" value="Close">
		</td></tr>
		</table>
	
	</td></tr>

</table>

</cfoutput>