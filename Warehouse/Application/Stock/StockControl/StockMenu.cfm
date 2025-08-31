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
	
	<table height="100%" width="100%" border="0">
		<tr>										
			<td align="center" valign="top" height="100%" id="menuMaximized" class="show">
			   
			   <table height="100%" width="100%" class="formspacing">
			   					  		
			   <tr><td colspan="2" valign="top" style="padding-left:10px;padding-right:10px">
										
				<table width="100%" height="100%" cellspacing="0" cellpadding="0">
				
					<tr>
						<td style="padding-top:2px; padding-right:4px">
						
						<!--- we show any function to which this person has access systemfunctionid = "#url.systemfunctionid#" --->
																									
						<cf_StockViewWarehouse style="font-size:13pt;height:35px;width:284px" 								             
									mission          = "#url.mission#"
									warehouse        = "#url.warehouse#"	
									initwarehouse    = "#client.warehouseselected#"										
									name             = "warehouse"
									grouping         = "City"											
									onchange         = "se=document.getElementsByName('optionwarehouse'); if (se[0].checked == true) {se[0].click()} else {se[1].click()}">													
						
						</td>
					</tr>		
					
									
					
					<tr><td height="3"></td></tr>				
																			
					<cfoutput>
					
						<tr id="optionmenu" name="optionmenu" class="hide">
						<td height="25" style="padding-top:4px">
							<table cellspacing="0" cellpadding="0" class="formpadding">
							<tr>
							<td>
							<input type    = "radio" 
							       name    = "optionwarehouse" 
								   id      = "option"
								   class   = "radiol"
								   value   = "warehouse" 
								   checked 
								   onclick = "ptoken.navigate('StockViewMenu.cfm?mission=#url.mission#&warehouse='+document.getElementById('warehouse').value,'tree');refreshwarehouse()">
							</td>
							<td class="labelit" style="padding-left:4px"><cf_tl id="Stock Control"></td>
							<td style="padding-left:8px">									
							<input type    = "radio" 									  
								   value   = "shipping"
								   name    = "optionwarehouse" 
								   class   = "radiol"
								   id      = "optionshipping"
								   onclick = "ptoken.navigate('../../StockOrder/View/StockOrderTreeTask.cfm?systemfunctionid=#url.systemfunctionid#&mission=#url.mission#&warehouse='+document.getElementById('warehouse').value,'tree')">
							</td>
							<td style="padding-left:4px" class="labelit"><cf_tl id="Taskorder Control"></td>
							
							</table>
						</tr>
						
					</cfoutput>
					
					<cf_submenuleftscript>
					
					<tr>			
						<td width="100%" height="100%" valign="top" id="tree" name="tree">
																		
				  			<cfset url.warehouse = selWarehouse>		
							<cfset url.mission   = selMission>		
										
																																																					
							<cfinclude template="StockViewMenu.cfm">				
														
						</td>						
					</tr>						
				</table>	
										
			    </td>
				
			   </tr>
			   
			   </table>
			    				
			</td>						
		</tr>	
	</table>				
</cfoutput>					
