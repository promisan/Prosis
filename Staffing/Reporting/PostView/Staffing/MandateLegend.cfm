<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->

   <!--- filter --->
<table width="100%" cellspacing="0" cellpadding="0">
   <tr><td>
	<table cellspacing="0" cellpadding="0">
	   <tr><td height="22">
	    <cfoutput>
		<img src="#SESSION.root#/Images/select4.gif" alt="" 
			id="legendExp" border="0" class="regular" 
			align="absmiddle" style="cursor: pointer;" 
			onClick="more('legend','show')">
			
			<img src="#SESSION.root#/Images/arrowdown.gif" 
			id="legendMin" alt="" border="0" 
			align="absmiddle" class="hide" style="cursor: pointer;" 
			onClick="more('legend','hide')">
		 </cfoutput>	
			&nbsp;
		</td>
		
		<td class="regular" id="legendExpT">
		<a class="regular" href="javascript:more('legend','show')"><b><font face="Verdana" color="0080C0"><cf_tl id="Legend"></b> - <cfoutput>#fil#</cfoutput> - </a>
		</td>
		
		<td class="hide" id="legendMinT">
		<a class="hide" href="javascript:more('legend','hide')"><b><font face="Verdana" color="0080C0"><cf_tl id="Legend"></b> - <cfoutput>#fil#</cfoutput> -</a>
		</td>
		</tr>
	</table>
  </td>
  </tr>
							  
  <tr id="legend" class="hide">
  <td>
  
  <table width="60%" align="center">
  <tr><td class="labelheader">A</td><td class="labelheader">Authorised Positions</td></tr>
  <tr><td class="labelheader">N</td><td class="labelheader">Other Not Authorised Positions</td></tr>
  <tr><td class="labelheader">I</td><td class="labelheader">Incumbents</td></tr>
  <tr><td class="labelheader">V</td><td class="labelheader">Vacant Positions</td></tr>
  <tr><td class="labelheader">G</td><td class="labelheader">Temporary Assistance Positions</td></tr>
  </table>
   
  </td>
  </tr>
			   		   
</table>
	   
