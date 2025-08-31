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
<!---
<table><tr><td>
1a. All external pending taskorders that are not cancelled<br>
1b. Sort by date and warehouse
2. Check box<br>
3. -Generate- taskorder and option to print<br>
4. It also means that we should only receive against external taskorder if they have a number ?<br>
</td></tr></table>
--->

<table width="100%" height="100%" cellspacing="0" cellpadding="0" align="center">

<tr class="hide"><td id="process"></td></tr>

<tr><td valign="top" style="padding:4px">	
	
	  <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="silver" align="center">		  
			
			<tr><td height="5px"></td></tr>
			<tr>
			  <td colspan="2" align="left" valign="bottom">	 
			  
			    <cfquery name="Get" 
					  datasource="AppsMaterials" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
						SELECT   *
						FROM     Ref_TaskType
						WHERE    Code = '#url.tasktype#'
				</cfquery>
				  
				  <table cellspacing="0" width="100%" cellpadding="0">
					  <tr>
					  
					  <!---
					  
					  <td align="left" height="30" style="padding-left:10px" valign="middle" width="7%">
					  
					  <cfoutput>
					  	<img src="#SESSION.root#/Images/prepare.png" alt="" border="0" align="absmiddle">
					  </cfoutput>
					 
					  </td>
					  --->
					  
					  <td style="padding-left:0px" width="93%" class="labellarge">
					  <!---
					  <font face="Verdana" size="3"><cf_tl id="Issue Task Fulfillment Order"></b>						
					  <br>
					  --->
					  <cf_tl id = "Issue delivery order for" class="message" var = "msg1">
					  <cfoutput>
					   #msg1# : <b><cfoutput>#get.Description#</cfoutput><b></font> 
					  </cfoutput>
					  </td>
					  </tr>
				  </table>	 
				   
			  </td>
			</tr>	
			
			<tr><td class="linedotted"></td></tr>
					
			<tr><td height="10"></td></tr>	
						
			<tr id="taskorderbox" class="hide">
			
			   <td align="center" style="padding-bottom:6px">
			   
			   <cfoutput>		
			   
			   <cf_button mode="silverlarge" label="Generate" label2="shipment order" width="190px" onclick="submittask('#url.mission#','#url.warehouse#','#url.tasktype#')" icon="Images/batch.gif">			  
					  
			   </cfoutput>	  
			   
			   </td>
			   
 		    </tr>
					
			<tr>
				<td>
			
				<form name="taskplanning" id="taskplanning">
				
					<cfset edit = "1">
					<cfinclude template="TaskDetail.cfm">
										
				</form>
			
			</td>
			</tr>
	
		</table>		
		
</td></tr>
</table>





