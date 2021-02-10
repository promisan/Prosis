<cfquery name="Last" 
	datasource="appsPayroll">
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

<table bgcolor="white" width="100%" height="100%" cellspacing="0" cellpadding="0" class="formpadding">

	<tr><td valign="center" align="center" style="background-color:ffffff">
	
		<table width="98%" height="98%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		
		<tr><td class="labelmedium" width="130"><cf_tl id="Payroll">:</td><td class="labelit" width="80%"><cf_tl id="Closing"></td></tr>
		<tr><td class="labelmedium"><cf_tl id="Requester">:</b></td><td class="labelit">#SESSION.first# #SESSION.last# : #timeformat(now(),"HH:MM:SS")#</td></tr>
		
		<tr><td colspan="2" height="1" class="line"></td></tr>
		<tr><td colspan="2" class="hide labelit" id="runbox"></td></tr>
		<tr><td colspan="2" height="440" style="background-color:ffffffff" valign="top">
		
		<cfdiv id="progressbox" style="position:relative;overflow: auto; width:100%; height:380; scrollbar-face-color: F4f4f4;">			
			<table width="100%" cellspacing="0" cellpadding="0">
			<tr><td colspan="2" align="center" height="380">			
				<button name="execute" value="Close" type="button" class="button10g" onClick="payrolllock('#nextprocess#','#calculationid#','#actionstatus#',''); prg = setInterval('showprogresslock(\'#nextprocess#\')', 5000)">
					<img src="#SESSION.root#/Images/play.png" height="15" width="15" border="0" align="absmiddle">&nbsp;<cf_tl id="Start">
				</button>				
				</td>
			</tr>	
			</table>			
		</cfdiv>
		</td></tr>
		<tr><td colspan="2" height="1" class="line"></td></tr>
		<tr><td align="center" colspan="2">
		<input type="button" onclick="ProsisUI.closeWindow('executetask');history.go()" class="button10g" name="Close" value="Close">
		</td></tr>
		</table>
	
	</td></tr>

</table>

</cfoutput>