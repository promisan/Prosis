
<cfif url.txt neq "">
	<cffile action = "read"  
	    file = "#SESSION.rootPath#\CFRStage\user\#SESSION.acc#\Logs\#URL.txt#"  
	    variable = "Message">
</cfif>	
	
<cfoutput>
  <table align="center" valign="top" width="100%" height="100%">
  	<tr valign="top">
		<td style="padding:4px" class="labelmedium">
			<cfif url.txt neq "">
				#Message#
			<cfelse>
				Displaying results...	
			</cfif>	
		</td>
	</tr>
	</table> 
</cfoutput>