
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

<table width="100%">
	<tr><td colspan="2" align="center" height="370">
		
		<button onclick="payrollprocess('#nextprocess#','#url.id#',document.getElementById('forcesettlement').value,document.getElementById('mission').value,'0'); prg = setInterval('showprogresscalculate(\'#nextprocess#\')', 5000)"			
		    class="button10g" 
			name="execute" 
			type"button"
			value="Close">
			<img src="#SESSION.root#/Images/play.png" border="0" align="absmiddle"><cf_tl id="Start">
		</button>
		
		</td>
	</tr>	
	</table>
	
</cfoutput>	