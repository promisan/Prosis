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

<!--- ----------------------------------------------------------------------- --->
<!--- this template is to PROCESS internal taskorder into stock transactions- --->
<!--- ----------------------------------------------------------------------- --->
<!--- ---------------NO NEED to have an Taskorder header reference----------- --->

<cfparam name="url.actormode" default="Provider">

		 		
  <table width="98%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">		
 
 		<cfoutput> 
        <tr>
			<td height="20">
				<table>
					<tr>
					<td width="200" height="30" class="labelit" style="padding-left:3px">Find Pending Request/Taskorder:</td>
					<td width="40" style="padding-left:8px"><input onkeyup="if (window.event.keyCode == '13') { document.getElementById('find').click() }"  type="text" id="search" name="search" class="regularxl" style="width:90"></td>
					<td width="40" style="padding-left:3px"><input type="button" id="find" value="Find" class="button10s" style="height:25px;width:49"
					     onclick="ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Task/Process/TaskViewSearch.cfm?systemfunctionid=#url.systemfunctionid#&warehouse='+document.getElementById('warehouseshow').value+'&mission=#url.mission#&search='+document.getElementById('search').value,'searchme')">							 
					 </td>			
					<td></td>							
					</tr>						
				</table>
			</td>
		</tr>
		<tr><td height="1" id="searchme"></td></tr>
		</cfoutput>
		
		<tr><td colspan="1" class="linedotted"></td></tr>
  
        <tr><td valign="top" id="mainbox">		
				
		<cfinclude template="TaskViewContent.cfm">
		
		</td></tr>  
  	   
</table>	
		
	
