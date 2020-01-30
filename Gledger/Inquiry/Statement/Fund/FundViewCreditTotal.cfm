
<cfoutput>

	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  	  	    
          <cfif crt lt dbt>
	      		
		  <!---		  
	      <tr bgcolor="FFC1C1"><td colspan="3"><p align="left">&nbsp;<b><font color="FF0000">Overspending</b></td>
    		  <td align="right"><b><font color="FF0000"><cfoutput>#NumberFormat(dbt-crt,'_,____')#</cfoutput></b>&nbsp;</font></td>
		  </tr>
		  --->
		  
		  <tr><td colspan="3" height="3"></td></tr>
		  <tr><td colspan="4" height="1" class="line"></td></tr>
          <tr><td height="19" colspan="3">
          <p align="left">&nbsp;<b>Total</b></font></td>
            <td align="right">
          <b><cfoutput>#NumberFormat(dbt,'__,___')#</cfoutput></b>&nbsp;</font></td></tr>
       
	      <cfelse>
		  
	      <tr><td colspan="4" height="1" class="line"></td></tr>
	      <tr><td height="19" colspan="3">
          <p align="left">&nbsp;<b>Total</b></td>
            <td align="right">
          <b><cfoutput>#NumberFormat(crt,'__,___')#</cfoutput></b>&nbsp;</td></tr>
	
		  </cfif>  	
		  
	</table>  
	
</cfoutput>