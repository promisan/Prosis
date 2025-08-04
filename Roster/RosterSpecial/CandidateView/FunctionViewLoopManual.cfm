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
<!--- ------------ --->
<!--- MANUAL block --->
<!--- ------------ --->    
             
<table width="100%" cellspacing="0" cellpadding="0">
   <tr><td height="1" bgcolor="silver"></td></tr>
   <tr><td>
   <table width="100%">
	    <tr><td width="30" align="center" height="25">
	    <cfoutput>
		<img src="#SESSION.root#/Images/arrowright.gif" alt="" 
			id="dmanualExp" border="0" class="regular" 
			align="middle" style="cursor: pointer;" 
			onClick="listing('manual','show','','','','','0','','1','LastName')">
			
			<img src="#SESSION.root#/Images/arrowdown.gif" 
			id="dmanualMin" alt="" border="0" 
			align="middle" class="hide" style="cursor: pointer;" 
			onClick="listing('manual','hide','','','','','0','','1','LastName')">
			
		</cfoutput>	&nbsp;
		</td>
		<td><a href="javascript: listing('manual','show','','','','','0','','1','LastName')">Manually Registered Candidates</a></b></td>
		</tr>
  </table>
  </td></tr>
  			  
  <tr><td class="hide" bgcolor="ffffbf" height="1" id="wmanual">&nbsp;Retrieving information ...</td></tr>
  <tr id="dmanual" class="hide"><td id="imanual"></td></tr>		   

</table>
	  