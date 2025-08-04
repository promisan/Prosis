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

<cfoutput>

   <table width="100%" border="0" cellspacing="0" cellpadding="0">
			  	    
          <cfif dbt lt crt>
	       
		  <!--- 
	      <tr bgcolor="8CE3C0">
		  <td colspan="3">
             <p align="left">&nbsp;<b>Positive cashflow</b></font>
		  </td>
	 	  <td align="right">
		     <font color="008040">
             <b><cfoutput>#NumberFormat(crt-dbt,'__,___')#</cfoutput></b>&nbsp;&nbsp;
			 </font>
		  </td>
		  </tr>
		  --->
   		  <tr><td colspan="3" height="4"></td></tr>	  
		  <tr><td colspan="4" height="1" class="line"></td></tr>
          <tr><td height="19" colspan="3">
          <p align="left">&nbsp;<b>Total</b></td>
            <td align="right">
          <b><cfoutput>#NumberFormat(crt,'__,___')#</cfoutput></b>&nbsp;</td></tr>
       
	      <cfelse>
		 		  
	      <tr><td colspan="4" height="1" class="line"></td></tr>
	      <tr><td height="19" colspan="3" >
          <p align="left">&nbsp;<b>Total</b></td>
          <td align="right">
          <b><cfoutput>#NumberFormat(dbt,'__,___')#</cfoutput></b>&nbsp;
		  </td></tr>
			
		  </cfif>  	
		  
  </table>  
	
</cfoutput>
