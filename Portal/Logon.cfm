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
<cfparam name="thisbrowser.pass" default="1">

<cfset client.context = "main">		

<table width="100%" height="100%"><tr><td>

	<div align="left" style="position:absolute; top:100px; left:410px; width:510px;">

		<table border="0" cellpadding="0" cellspacing="0" height="300px">
			<tr>
				<td align="left" height="10px" valign="bottom" style="color:#454545; padding-top:10px">		
					<cfoutput>
					<strong>release #CLIENT.Version#</strong> [#client.release#]
					<br>			
					#SESSION.authorMemo#
					<br>
					#CLIENT.Manager#
					</cfoutput>		
				</td>
			</tr>
     
     		<tr><td height="80px" valign="bottom" class="labelmedium" align="left" >
                	<cfoutput>#SESSION.welcome#</cfoutput>
            	</td>

     		</tr>
     		<tr><td height="80px" class="labelmedium" valign="top" align="left" >
					<cfoutput>#SESSION.author#</cfoutput>
      			</td>
			</tr>   

     		<tr><td valign="middle" align="left" height="20px" class="labelmedium">
					<strong>Enter your ACCOUNT and PASSWORD below:</strong>
				</td>
			</tr>

     		<tr><td height="58px" valign="middle" align="left">			
				<cfif thisbrowser.pass eq 0>
				Your browser is no longer supported
				<cfelse>
					<cfset color="454545">
					<cfset align="left">
					<cfinclude template="Credentials.cfm">
				</cfif>	
				</td>
			</tr>

   </table>
    
  </div>

</td></tr></table>
