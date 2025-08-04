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

<cfparam name="SESSION.welcome" default="">	
<cfparam name="CLIENT.acc" default="">	

<cfquery name="System" 
	datasource="AppsSystem">
		SELECT *  
		FROM   Parameter
</cfquery>
	
<!--- provision to link to https Armin 8/10/2011--->
	
<cfif CGI.HTTPS eq "off">
	<cfset tpe = "http">
<cfelse>	
	<cfset tpe = "https">
</cfif>

<cf_assignid>

<cfoutput>

<form name="reloginform_#rowguid#" method="post" autocomplete="off" style="height:130px">

	<cfset client.count = "1">
	
	<table style="background-color:white; width:100%; height:130px" align="center">
	
		<tr>
			<td width="1%" height="5px" style="line-height:5px">&nbsp;</td>
			<td height="5px" style="line-height:5px"></td>
			<td width="1%" height="5px" style="line-height:5px">&nbsp;</td>
		</tr>
		
		<tr>
			<td></td>
			<td valign="middle">			
				
				<table width="94%" align="center" style="margin:0 auto" cellpadding="0" cellspacing="0" onkeyUp="if (window.event.keyCode == '13') { document.getElementById('relogonSubmit_#rowguid#').click() }">
				
					<cfoutput>									
				
					<!---	
					<tr>
						<td height="5px">
						</td>
					</tr>				
					
					<tr>
						<td style="font-family:Calibri, Helvetica; font-size:18px; color:gray; line-height:18px; text-align:left;padding-left:10px"><span style="color:black; font-size:22px"><cfoutput><b>#SESSION.welcome#</b></cfoutput></span> <cf_tl id="authentication manager"></td>
					</tr>
					
					<tr>
						<td style="line-height:21px">
							<hr>
						</td>
					</tr>
					--->
					<tr>
						<td style="font-family:Calibri,Helvetica; font-size:16px; line-height:18px; text-align:center">
							<cf_tl id="Your session expired, please submit your credentials again. You may then proceed with your work" class="Message">.
						</td>
					</tr>
					
					<tr>
						<td style="height:15px">
						</td>
					</tr>
					
					<cfparam name="client.logoncredential" default="#session.acc#">					
									
					<cfif client.logoncredential neq "">
					    <cfset logon = client.logoncredential> 
					<cfelse>
						<cfset logon = "">
					</cfif>
									
					<tr>
						<td align="center" style="padding-left:25;padding-right:25">
						   
								<table width="80%" cellspacing="0" cellpadding="0" align="center" border="0">				
									<cfparam name="session.acc" default="">			
									<tr>				
										<td width="100px"><font face="Calibri" size="2" color="gray"><cf_tl id="Account">:</b></font></td>													
										<td><input id="account" name="account" class="regularxl" style="height:23px; padding:2px 2px 2px 4px; border:1px solid ##C0C0C0; width:170px;" type="text" value="#client.logoncredential#"  maxlength="20" required="yes" message="Please enter your account"></td>			
									</tr>	
									<tr><td height="2"></td></tr>		
									<tr>				                
										<td width="100px"><font face="Calibri" size="2" color="gray"><cf_tl id="Password">:</b></font></td>			  
										<td><input type="password" name="password" id="password" maxlength="20" class="regularxl" autocomplete="off" style="height:23px; padding:2px 2px 2px 4px; border:1px solid ##C0C0C0; width:170px;"></td>		
									</tr>												
								</table>
							
						</td>
					</tr>
								
					<tr><td height="12px"></td></tr>		
					<tr><td height="1px" style="border-top:1px solid silver"></td></tr>		
					<tr><td height="10px"></td></tr>			
					
					<tr>	
						<td align="center">
						
						 <table cellspacing="0" cellpadding="0" class="formpadding">
						 <tr><td style="padding-right:2px">
						 	
							<cf_tl id="Logout" var="vlabel">					 
						 	<input style="font-size:12pt; border:1px solid silver; font-family:calibri; cursor:pointer; background:f4f4f4; height: 27px; width:120px"
								    type="button" 									
								    name="close_#rowguid#" 
									id="close_#rowguid#" 
									value="#vlabel#" 
								    onclick="javascript:try { exit() } catch(e) { window.close() }">
												 						 
						 </td>						 
						 <td>
								<cf_tl id="Relogin" var="olabel">												
								<input style="font-size:12pt;border:1px solid silver; font-family:calibri; cursor:pointer; background:f4f4f4; height: 27px; width:120px"
								    type="button" 									
								    name="relogonSubmit_#rowguid#" 
									id="relogonSubmit_#rowguid#" 
									value="#olabel#" 
								    onclick="_cf_loadingtexthtml='';ColdFusion.navigate('#tpe#://#CGI.HTTP_HOST#/#System.VirtualDirectory#/Portal/reLogonSubmit.cfm?width='+screen.width+'&height='+screen.height+'&innerheight=900','relogonresultbox_#rowguid#','','','POST','reloginform_#rowguid#'); try {document.getElementById('div_container_screen').style.overflow = 'auto';} catch(e){};		">
									
						</td></tr>
						</table>			
							
						</td>					
					</tr>	
					
					</cfoutput>
					
				</table>
				
			</td>
			<td></td>
		</tr>
				
		<tr><td id="relogonresultbox_#rowguid#" style="padding-bottom:5px;padding-top:2px" colspan="3" class="labelit" align="center"></td></tr>
		
	 </table>

</form>

<!---

<script>
	document.getElementById('password').fics()
	Prosis.busy('no')
</script>

--->

</cfoutput>
