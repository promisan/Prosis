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
<cfoutput>

<table id="mainwrapper" width="100%">
	<tr>
		<td colspan="3" align="center" valign="center">
				<cfinclude template="WorkClusterProgressBar.cfm">
		</td>	
	</tr>		
	<tr id="rdProgressBar">
			<td width="20%"></td>
			<td style="top:30%; left:50%; margin-left:-200px; margin-top:-75px; width:500px; height:150px;" id="dDContent" name="dDContent">
			      <table width="100%">
			       	<cfif IsDefined("qAllUnits")>
			       	<tr><td  class="labellarge" style="font-size: 23px; font-family:'Montserrat', Arial, Helvetica, sans-serif;">
					  There is already a draft planning in the workings for the following branches.
					  <br>
					  Do you want to remove it?
						</td>
					</tr>
					
					<tr height="80px"><td></td></tr>
					<tr height="40px">
						<td width="100%">
							<table width="100%">
									<cfset i = 0>
									<cfloop query="qAllUnits">
									  <cfif i eq 0>
									  	<tr>
									  	<td width="25%" class="labelit">
									  <cfelse>
									  	<td class="labelit">			
									  </cfif>
									  #OrgUnitName#									  
									  <cfif i eq 3>
									    </td></tr> 
									  	<cfset i=0>
									  <cfelse>
									  	<cfset i=i+1>
									    </td>	
									  </cfif>		
									</cfloop>	
							</table>	
						</td>	
					</tr>	
					<cfelse>
			       	<tr><td width="100%" class="labellarge" style="font-size: 23px; font-family:'Montserrat', Arial, Helvetica, sans-serif;">
					  		Dependent on your selected brnaches the process will approx take 20-100 seconds to discover the best route.
					  		<br>
					  		Do you want to proceed?
						</td>
					</tr>
					</cfif>
					
					<tr height="40px"><td></td></tr>
			       	<tr><td width="100%">
			       		<table>
			       			<tr>
								<td align="center">
			       					<cfif IsDefined("qAllUnits")>
				       					<input type="button" value="No" style="width:200px;cursor:pointer;margin-top:5px; color: ##900;font-size: 150%;height: 29px;" onclick="javascript:refresh_dss('#URL.date#','#URL.step#','pass')">
			       					<cfelse>
				       					<input type="button" value="Back" style="width:200px;cursor:pointer;margin-top:5px; color: ##900;font-size: 150%;height: 29px;" onclick="javascript:planning()">
			       					</cfif>
			       				</td>
								
			       				<td style="padding-left:2px" align="center">
			       					<input type="button" value="Yes" style="width:200px;cursor:pointer;margin-top:5px; color: ##2F1AB8;font-size: 150%;height: 29px;" onclick="javascript:resetcluster('#url.date#',0)">
			       				</td>
			       			</tr>	
			       		</table>	
			       		</td>
					</tr>
					
					
				</table>
			</td>
			<td width="20%"></td>
	</tr>		
</table>
</cfoutput>