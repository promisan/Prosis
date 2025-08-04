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

<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
				
			<tr><td height="3"></td></tr>	
			
			<TR class="line">
		    <td colspan="2">
				<table width="100%" cellspacing="0" cellpadding="0">
										
					<tr>
					
					<td class="hide" id="securitysave"></td>
					
					<td width="150" height="30" class="labelmedium">Anonymous Access:</td>
				 	<td>
					
					<table cellspacing="0" cellpadding="0"><tr>
				
					<cfif Line.Operational eq "1">
						<td class="labelmedium">
					    <b>&nbsp;
					 	<cfif Line.EnableAnonymous eq "1">Yes<cfelse>Disabled</cfif>
						</td>
					  
					<cfelse>					
					 
						<cfif Line.SystemModule eq "">
						    <td><input type="radio" name="EnableAnonymous" id="EnableAnonymous" value="1" onclick="secsave('EnableAnonymous','1')"></td><td>Yes</td>
							<td><input type="radio" name="EnableAnonymous" id="EnableAnonymous" value="0" onclick="secsave('EnableAnonymous','0')" checked></td><td>No</td>
						<cfelse>
						    <td><input type="radio" name="EnableAnonymous" id="EnableAnonymous" value="1" onClick="alert('Access to this report will be granted outside framework');secsave('EnableAnonymous','1')" <cfif "1" eq Line.EnableAnonymous>checked</cfif>></td><td>Yes</td>
							<td><input type="radio" name="EnableAnonymous" id="EnableAnonymous" value="0" onclick="secsave('EnableAnonymous','0')" <cfif "0" eq Line.EnableAnonymous>checked</cfif>></td><td>No</td>
						</cfif>	
					
					</cfif>
					</tr>
					</table>
					</td>
					
					<td width="70" class="labelmedium">Global&nbsp;access:</td>
					<TD style="padding-left:20px">
					
					<table cellspacing="0" cellpadding="0"><tr class="labelmedium">
				
					<cfif Line.Operational eq "1">
					
					    <td><b>&nbsp;<cfif Line.EnableGlobal eq "1"><font color="0080FF">Yes</font><cfelse>Disabled</cfif></td>
				  
					<cfelse>
				
						<cfif Line.EnableGlobal eq "">
							<td><input type="radio" name="EnableGlobal" id="EnableGlobal" value="1" onclick="secsave('EnableGlobal','1')" checked></td><td>Yes</td>
							<td><input type="radio" name="EnableGlobal" id="EnableGlobal" value="0" onclick="secsave('EnableGlobal','0')"></td><td>No</td>
						<cfelse>
							<td><input type="radio" name="EnableGlobal" id="EnableGlobal" onclick="secsave('EnableGlobal','1')" value="1" <cfif "1" eq Line.EnableGlobal>checked</cfif>></td><td>Yes</td>
							<td><input type="radio" name="EnableGlobal" id="EnableGlobal" onclick="secsave('EnableGlobal','0')" value="0" <cfif "0" eq Line.EnableGlobal>checked</cfif>></td><td>No</td>
						</cfif>	
					
					 </cfif>
					 
					 </tr></table>
				 	
					</td>
				
					<td align="right" class="labelmedium">Enable Mailing list:</td>
					<TD style="padding-left:10px">
					
					<table cellspacing="0" cellpadding="0"><tr class="labelmedium">
				
					<cfif Line.Operational eq "1">
					
					    <td><b><cfif Line.EnableMailingList eq "1">Yes</font><cfelse><font color="red">No</cfif><td>
				  
					<cfelse>
				
						<cfif Line.SystemModule eq "">
							<td><input type="radio" name="EnableMailingList" id="EnableMailingList" value="1" onclick="secsave('EnableMailingList','1')" checked></td><td class="labelit">Yes</td>
							<td><input type="radio" name="EnableMailingList" id="EnableMailingList" value="0" onclick="secsave('EnableMailingList','0')" ></td><td class="labelit">No</td>
						<cfelse>
							<td><input type="radio" name="EnableMailingList" id="EnableMailingList" value="1" onclick="secsave('EnableMailingList','1')"  <cfif "1" eq Line.EnableMailingList>checked</cfif>></td><td>Yes</td>
							<td><input type="radio" name="EnableMailingList" id="EnableMailingList" value="0" onclick="secsave('EnableMailingList','0')"  <cfif "0" eq Line.EnableMailingList>checked</cfif>></td><td>No</td>
						</cfif>	
					
					 </cfif>
					 
					  </tr>
					  </table>
				 	
					</td>
				</tr>
				
				</table>
			</td>		
			
			 <cfinvoke component="Service.AccessReport"  
	          method="editreport"  
			  ControlId="#Line.ControlId#" 
			  returnvariable="accessedit">					  
									
			<cfif accessEdit eq "EDIT" or accessEdit eq "ALL" or SESSION.isAdministrator eq "Yes">
			
			 <cfset sec = 0>
			 
			<cfelse>
			
			 <cfset sec = 1>
			  
			</cfif>
			
			<!--- change of security in production #op# changeinto 0 --->	
			
			<script language="JavaScript">
			
				function rolesubmit(md) {
							
				 if (md == "") {
				     rl = document.getElementById("role").value
	 			 } else {
			   	     rl = ""
				 }
				 
				 dl = document.getElementById("roledelegation").checked
				 op = document.getElementById("roleoperational").checked
				 cl = document.getElementById("classparameter").value
				 ptoken.navigate('RoleSubmit.cfm?id=#URL.ID#&id1='+md+'&status=#sec#&role='+rl+'&del='+dl+'&op='+op+'&param='+cl,'rolebox','','','POST','entry')			
				 
				}
				
				function groupsubmit(md) {
							
				 if (md == "") {
				     gp = document.getElementById("group").value
	 			 } else {
			   	     gp = ""
				 }
				 
				 dl = document.getElementById("groupdelegation").checked
				 op = document.getElementById("groupoperational").checked
				 ptoken.navigate('GroupSubmit.cfm?id=#URL.ID#&id1='+md+'&status=#sec#&group='+gp+'&del='+dl+'&op='+op,'groupbox')			
				}
				
				function show(val,btn)	 {
				
					 if (val == "") { 
					  document.getElementById(btn).className = "hide" 
					  } else {
					  document.getElementById(btn).className = "button10s";	
					 }
				 }
				 
				 function editrole(status, id, role) {				 				    					
					ProsisUI.createWindow('myrole', 'Receipt', '',{x:100,y:100,height:document.body.clientHeight-100,width:document.body.clientWidth-100,modal:true,resizable:false,center:true})    								
					ptoken.navigate('RoleView.cfm?status='+status+'&id='+id+'&role='+role,'myrole') 		
				 }
				 
				 function rolerefresh(status,id) {				 
					_cf_loadingtexthtml='';	
				    ptoken.navigate('Role.cfm?status='+status+'&ID='+id+'&ID1=','rolebox');
				 }
					
			</script>
			
			<tr><td colspan="2" style="height:56px;font-size:29px;font-weight:200" class="labelmedium"><font color="gray">Report accessibility</td></tr>
			<TR>
			    
			   	<td colspan="2">						 
				  <cf_securediv bind="url:Role.cfm?id=#URL.ID#&status=#sec#" id="rolebox">
				</td>
			</TR>
			
			<tr><td height="3" colspan="2"></td></tr>
			
			<cf_dialogStaffing>
				   
			<TR>
		      	<TD colspan="2">
				   <cf_securediv bind="url:Group.cfm?id=#URL.ID#&status=#sec#" id="groupbox"/>
				</TD>
			</TR>
</table>		
</cfoutput>	