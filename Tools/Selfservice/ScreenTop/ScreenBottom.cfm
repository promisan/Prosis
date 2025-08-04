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

<cfparam name="Attributes.graphic"      default="Yes">
<cfparam name="Attributes.footer"       default="none">
<cfparam name="Attributes.html"         default="Yes">
<cfparam name="Attributes.layout"       default="Default">
<cfparam name="Attributes.mail"         default="No">
<cfparam name="Attributes.bgcolor"      default="ffffff">

<cfoutput>

<cfif attributes.html eq "Yes">

	<cfif attributes.layout eq "WebApp">
	
	   
	
		</td></tr>
		</table>
		
		<!--- newly added--->
		</td></tr>
		</table>	
		
		</div>
		<!--- ---------- --->
		
		
	<cfelseif attributes.layout eq "webdialog">
	
		</td></tr>
		</table>	
		
		<!--- newly added--->
		</td></tr>
		</table>	
		<!--- ---------- --->
		
	<cfelseif attributes.layout eq "InnerBox">
	
		</td></tr>
		</table>
			
		</td></tr>
		</table>	
	
	<cfelse>
	
		<cfset image = "#SESSION.root#/Tools/Selfservice/LoginImages">
		  
		   </td>
		   <td bgcolor="#attributes.bgcolor#">&nbsp;&nbsp;</td>
		   <td><img src="#image#/spacer.gif" width="1" height="4" border="0" alt="" /></td>
		  </tr>  
		  
		  <tr>
		    <td colspan="7" height="1" align="center" bgcolor="FFFFFF">
			</td>
		    <td><img src="#image#/spacer.gif" width="1" height="1" border="0" alt="" /></td>
		  </tr>
		  	
		  <cfif attributes.footer neq "none">
		
			  <tr>
			   <td colspan="7" height="5px" bgcolor="252f51">
			   			   			   
				<cfif attributes.footer eq "default">
				   	<div align="center"><span class="style16"><font color="FFFFFF" size="1">#client.applicationfooter#</span></div>
				<cfelse>
				   	<div align="center"><span class="style16"><font color="FFFFFF">#attributes.footer#</span></div>
				</cfif>
				
				</td>
			   <td><img src="#image#/spacer.gif" width="1" height="10" border="0" alt="" /></td>
			  </tr>
		  
		  <cfelse>
		  
			  <tr>
			   <td colspan="7" background="#image#/black1.jpg">
			   <td><img src="#image#/spacer.gif" width="1" height="7" border="0" alt="" /></td>
			  </tr>
		  
		  </cfif>	
		
		   <tr>
		   <td colspan="9"></td>
		   <td><img src="#image#/spacer.gif" width="1" height="4" border="0" alt="" /></td>
		  </tr> 
	   
		</table>
		
	</cfif>	
	<!--- newly added--->
		</div>
	</body>
	<!--- ---------- --->
	
	
</cfif>

</cfoutput>


<!---
</center>
</body>
--->
</html>