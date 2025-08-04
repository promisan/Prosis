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

<cfparam name="url.link" default="#SESSION.root#/Portal/SelfService/Extended/LogonProcessOpen.cfm?id=#url.id#">
  
  <table width="358px" cellpadding="0" cellspacing="0" border="0" align="center">  
  
	<tr><td valign="top">
	
	        <form name="accountform" id="accountform" >

			<table border="0" cellpadding="0" cellspacing="0" width="100%" >
				<tr><td colspan="2" align="center" style="padding-top:10px; font-family: Calibri; font-size: 15px; color:white">
				<b>
				<cfif main.functionInfo neq "">
					#Main.FunctionInfo# 
				<cfelse>
					Example text
				</cfif>

				</b>
				</td></tr>
				
				<tr><td colspan="2" height="38px"></td></tr>
				<tr>
					<td colspan="2" align="center" style="font-family: Calibri; font-size: 14px; line-height:14px; color:##3c80ba">
						
						<cfif client.languageid eq "ENG">#Dateformat(NOW(),"DDDD, DD MMMM YYYY")#
						<cfelseif client.languageid eq "ESP">#Dateformat(NOW(),"DD MMM, YYYY")#
						<cfelseif client.languageid eq "FRA">#Dateformat(NOW(),"MMM DD, YYYY")#
						</cfif>
						
					</td>
				</tr>
				
				<tr><td colspan="2" height="18px">&nbsp;</td></tr>
				<tr>
					<td width="33%" align="right" style="padding-right:7px; color:##0b5093">
					<cf_tl id="Username">:
					</td>                
                   	<td width="67%" align="left">
					
						<cfset vPreClient = "">
						<cfif isDefined("client.logon")>
							<cfset vPreClient = client.logon>
						</cfif>
						
						 <input type="Text" 
						    name="account" 
							id="account"
							value="#vPreClient#" 
							class="regularxl"
							style="border:1px solid silver; background-color:##f3faff; width:115px"
							<cfif client.browser eq "Explorer">
                            	size="15"
                            <cfelse>
                            	size="16"
                            </cfif>
							maxlength="50">				   		   							
							
			  		</td>
				</tr>
                   
                <tr>
                   	<td height="<cfif client.browser eq "Explorer">3<cfelse>5</cfif>" colspan="2"></td>
                </tr>
               	
                <tr>
                    <td align="right" style="padding-right:7px; color:##0b5093">
						<cf_tl id="Password">:
					</td>  
					<cfset eLogin = "javascript:ColdFusion.navigate('#SESSION.root#/Portal/SelfService/LogonAjaxSubmit.cfm?ID=#URL.ID#&link=#url.link#&mission=#client.mission#&webapp=#url.id#','dError','','','POST','accountform')">
			  		<td align="left">
			    		<input type="password" class="passwordxl" name="password" size="16" maxlength="24" style="border:1px solid silver; background-color:##f3faff; width:115px" onkeydown="if (event.keyCode == 13) #eLogin#">					
						<input type="hidden" name="HasPassword" value="1" checked tabindex="99">		          
			  		</td>
			 	</tr>
               	
				<tr height="25" valign="bottom">
                   	<td>&nbsp;</td>
					<td>	
									
					<img src="extended/images/submit.png" id="logonnow" name="logonnow" alt="" width="49" height="18" border="0" style="cursor:pointer"
						onClick="#eLogin#">	
					                 							   
                       </td>
                 </tr>
				 
				<!--- feedback box --->				
				<tr>
                   	<td valign="bottom" colspan="2" id="dError" name="dError" height="5px" align="center" style="font: normal 11px Calibri; color: white;">    		
					</td>
				</tr>
				
				<tr>
                   	<td  colspan="2"  height="12px" align="right" style="font: normal 11px Calibri; color: gray; padding-right:70px">   
						<a href="javascript:accountRequest('#url.id#');" style="cursor:pointer">                        
						<font color="gray">
							<cf_tl id="Request Access">
						</font>
						</a>
					</td>
				</tr>			
				
				<tr>
                   	<td  colspan="2"  height="12px" align="right" style="font: normal 11px Calibri; color: gray; padding-right:70px">
						<a href="javascript:ResetPassword('#url.id#');" style="cursor:pointer">
						<font color="gray">						
							<cf_tl id="Forgot my Password">
						</font>
						</a>
					</td>
				</tr>   
				 
			</table>			

			</form>
		</td>
	</tr>
	
</table>

</cfoutput>


