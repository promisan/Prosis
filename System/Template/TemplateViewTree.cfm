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

<cfquery name="Master" 
  datasource="AppsControl">
      SELECT * FROM ParameterSite
	  WHERE ServerRole = 'QA'
</cfquery>

<cfquery name="Design" 
  datasource="AppsControl">
      SELECT * FROM ParameterSite
	  WHERE ServerRole = 'Design'
</cfquery>

<cf_distributer>

<cfset Criteria = ''>

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">

<tr><td height="4"></td></tr>

<cfform>

  <tr><td valign="top">
  
    <table width="94%" height="100%" align="center" border="0" cellspacing="0" cellpadding="0">
		  	  
	  <cfif master eq "1">	 

	      <!--- moved to the tree  
	  
		  <cfif design.recordcount eq "1" and SESSION.isAdministrator eq "Yes">
		   			
			   <tr>
		        <td height="25">&nbsp;
				<a href="javascript:load('#Design.ApplicationServer#')">#Design.ApplicationServer# (Design)</a></td>
		       </tr>
		  
		  </cfif>
		  
		  --->
		  
		  <cfquery name="Mast" 
			  datasource="AppsControl">
			      SELECT * FROM ParameterSite
				  WHERE ServerRole = 'QA'
			</cfquery>

		    					
			<cfoutput>
			
			 <tr height="10" class="line labelmedium">
			 <td style="padding-left:10px">Last Scan: #DateFormat(Mast.scandate, CLIENT.DateFormatShow)# #TimeFormat(Mast.scandate, "HH:MM")#</td>
			 </tr>
			 <tr>
			  <td style="padding-left:10px;padding-top:7px;padding-bottom:7px" align="center">
			  					
					<!--- <button name="scanbutton" id="scanbutton" class="button10s" style="width:80%" onclick="javascript:batch('1'); document.getElementById('scanbutton').className='hide'"> --->
					
		      </td>
			 </tr>			 
						
		    </cfoutput>	  
			  		
	  </cfif>			  
		  
        <tr>
          <td height="100%" style="padding-top:6px"> 
		  
		  <cf_divscroll>		
		  
		  <cf_TemplateTreeData master="#master#">
		  
		  </cf_divscroll>
         
	    </td>
      </tr>
		 		
      </table>
	  </td>
  </tr>
  
</cfform>
  
</table>
</cfoutput>
