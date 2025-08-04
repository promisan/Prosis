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

<cfparam name="URL.RequestId" default="{00000000-0000-0000-0000-000000000000}">


      				
<cfquery name="GroupAll" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    R.*, E.RequestId as Selected
	FROM      PurchaseExecutionRequestReason E RIGHT OUTER JOIN
			  Ref_StatusReason R ON E.ReasonCode = R.Code AND E.RequestId = '#url.RequestId#' 
	WHERE     R.Status      = '#URL.Status#'
	AND       R.StatusClass = '#URL.StatusClass#'		
	AND       R.Operational = 1
</cfquery>
						
   <table width="100%" border="0" cellspacing="0" cellpadding="0">
   
  	 	   	  							
   		<TR><td width="100%">
							
	    <cfoutput>
					
		<table width="100%" border="0">
		
		<tr>
   			<td width="100%">
			
			<table width="100%"
		       border="0"
		       cellspacing="0"
		       cellpadding="0"
		       align="left"
			   class="formpadding"
		       bordercolor="C0C0C0"
		       bgcolor="ffffff">
		
				</cfoutput>
			
			    <cfset row = 0>
									
				<cfoutput query="GroupAll">
														
					<cfif row eq "2">
					    <TR>						
						<cfset row = 0>
																		
					</cfif>
				
				    <cfset row = row + 1>
					<td width="50%" valign="top">
											
					<table width="100%" cellspacing="0" cellpadding="0">
					
						<cfif Selected eq "">
						  <TR class="regular" id="f#url.row#_#code#_0">
						<cfelse> 
						  <TR class="highlight4" id="f#url.row#_#code#_0">							         
						</cfif>
						<td width="50">&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td width="97%">
						#Description#							
						</td>
						<TD width="5%">												
																				
						<cfif Selected eq "">
							<input type="hidden" name="f#url.row#_#code#" id="f#url.row#_#code#">
							<input type="checkbox" 
							 name="f#url.row#_#code#_check" 
                             id="f#url.row#_#code#_check"
							 onClick="hla('f#url.row#_#code#','#code#',this.checked)"></TD>
						<cfelse>
							<input type="hidden" name="f#url.row#_#code#" id="f#url.row#_#code#" value="#code#">
							<input type="checkbox" name="f#url.row#_#code#_check" id="f#url.row#_#code#_check"
							checked 
							onClick="hla('f#url.row#_#code#','#code#',this.checked)"></td>								
					    </cfif>
						</td>
						</tr>
						
						<cfif includespecification eq "1">

							<tr id="f#url.row#_#code#_1" class="<cfif Selected eq "">hide<cfelse>regular</cfif>">								
							<tr id="f#url.row#_#code#_2" class="<cfif Selected eq "">hide<cfelse>regular</cfif>">
							<td class="labelmedmium" valign="top" style="padding:5px">Memo:</td>
							<td colspan="2" style="padding:3px">
								<textarea style="width:99%" 
								    class="regular2" style="font-size:13px;padding:3px"
									rows="3" 
									name="f#url.row#_#code#_remarks"></textarea>								
							</td>							
							</tr>
						
						</cfif>
						
					</table>
					
					</td>
					<cfif GroupAll.recordCount eq "1">
   						<td width="50%"></td>
					</cfif>
				
				</CFOUTPUT>
														
				<cfif row eq "1">
					<td width="50%"></td>
				</cfif>
											
		    </table>
			
			</td></tr>
			
			</table>
								
		</td></tr>
						
	</table>
		
