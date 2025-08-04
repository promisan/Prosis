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

<cfinvoke component="Service.Presentation.Presentation"  method="highlight"  returnvariable="stylescroll"/>
		
<cfparam name="url.id2" default="">	

<cfparam name="form.operational" default="0">	
	
<cfquery name="Listing" 
datasource="#alias#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT F.*,
			(
				SELECT COUNT(1)
				FROM WorkorderFunding W
				where W.fundingid=F.Fundingid
			) AS InUse
	
    FROM  Ref_Funding F
	<cfif client.search neq "">
	WHERE #PreserveSingleQuotes(client.search)#
	</cfif>	
<!---	ORDER BY F.fundingType, F.period, F.fund, F.created DESC--->
	ORDER BY F.fundingType, F.fund, F.created DESC
</cfquery>


<cfquery name="lookupGLAccount" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT	*
  	FROM Ref_Account A
  	WHERE EXISTS (SELECT *
					FROM Ref_AccountMission M
					WHERE M.GLAccount = A.GLAccount)
</cfquery>
	
<table width="97%" cellspacing="0" cellpadding="2" align="center" >
				
<!---     <TR class="labelit line">
	   <td width="8%">Funding Type</td>
	   <td width="8%">Fund</td>
	   <td width="8%">OrgUnit</td>
	   <td width="8%">Project</td>
	   <td width="8%">Program</td>
	   <td width="8%">Object</td>
	   <td width="20%">GLAccount</td>
	   <td width="8%">Reference</td>
	   <td width="5%">Officer</td>  
	   <td width="5%">Created</td>
	   <td width="6%"></td>			  	  
    </TR>	 --->
	
    <TR class="labelit line">
	   <td width="8%">Funding Type</td>
	   <td width="8%">Fund</td>
	   <td width="8%">Cost Center</td>
	   <td width="8%">WBSe</td>
	   <td width="8%">Func Area</td>
	   <td width="8%">Spon Class</td>
	   <td width="8%">Grant</td>
	   <td width="20%">GLAccount</td>
	   <td width="8%">Reference</td>
	   <td width="5%">Officer</td>  
	   <td width="5%">Created</td>
	   <td width="6%"></td>			  	  
    </TR>		
				
	<cfif URL.ID2 eq "new">
		<tr>
			<td colspan="11">
				
				<cfform method="POST" name="mytopic" onsubmit="return false">
			
				<table  width="100%" align="center" cellpadding="0" cellspacing="0">
				
					<tr style="background-color:#f4f4f4;">				
							
							<td width="7%">
							
							    <cfinput type="Text" 
							         value="" 
									 name="FundingType" 
									 message="You must enter a funding type" 
									 required="Yes" 
									 size="2" 
									 maxlength="10" 
									 class="regularH">
									 					 
					        </td>	
<!---							
							<td width="7%">
							
							    <cfinput type="Text" 
							         value="" 
									 name="Period" 
									 message="You must enter a period" 
									 required="Yes" 
									 size="2" 
									 maxlength="10" 
									 class="regularH">
									 					 
					        </td>	
--->							
							<td width="8%">
							
							    <cfinput type="Text" 
							         value="" 
									 name="Fund" 
									 message="You must enter a fund" 
									 required="Yes" 
									 size="2" 
									 maxlength="20" 
									 class="regularH">
									 					 
					        </td>	
							
							<td width="7%">
							
							    <cfinput type="Text" 
							         value="" 
									 name="orgUnitCode" 
									 message="You must enter an Cost Center" 
									 required="Yes" 
									 size="2" 
									 maxlength="20" 
									 class="regularH">
									 					 
					        </td>	
							
							<td width="7%">
							
							    <cfinput type="Text" 
							         value="" 
									 name="ProjectCode" 
									 message="You must enter a WBSe" 
									 required="Yes" 
									 size="2" 
									 maxlength="20" 
									 class="regularH">
									 					 
					        </td>	
							
							<td width="7%">
							
							    <cfinput type="Text" 
							         value="" 
									 name="ProgramCode" 
									 message="You must enter a Functional Area" 
									 required="Yes" 
									 size="2" 
									 maxlength="20" 
									 class="regularH">
									 					 
					        </td>	
							
							<td width="8%">
							
							    <cfinput type="Text" 
							         value="" 
									 name="ObjectCode" 
									 message="You must enter an Sponsored Class" 
									 required="Yes" 
									 size="2" 
									 maxlength="10" 
									 class="regularH">
									 					 
					        </td>	
							
							<td width="8%">
							
							    <cfinput type="Text" 
							         value="" 
									 name="CBGrant" 
									 message="You must enter a Grant" 
									 required="Yes" 
									 size="2" 
									 maxlength="10" 
									 class="regularH">
									 					 
					        </td>								
							
							<td width="17%">
											    
								<select name="GLAccount" id="GLAccount" class="regularH">
									<cfoutput query="lookupGLAccount">
									  <option value="#lookupGLAccount.glAccount#">#lookupGLAccount.glAccount# - #lookupGLAccount.description#</option>
								  	</cfoutput>
								</select>
									 					 
					        </td>	
							
							<td width="6%">
							
							    <cfinput type="Text" 
							         value="" 
									 name="reference" 
									 size="15" 
									 maxlength="20" 
									 class="regularH">
									 					 
					        </td>	
							
							<cfoutput>
							<td width="5%">
							
							    #SESSION.first# #SESSION.last#
									 					 
					        </td>
							
							<td width="3%">
							
							    #dateformat(now(),CLIENT.DateFormatShow)#
									 					 
					        </td> 
							</cfoutput>  
							
							<td align="center" width="11%">
								   
						   	  <input type="submit" 
						        value="Save" 
								onclick="save('new')"
								style="width:60px;height:18px"
								class="button10s">
							&nbsp;
							<input type="button" 
						        value="Cancel" 
								onclick="cancel()"
								style="width:60px;height:18px"
								class="button10s">
					
							</td>  
							
							</TR>				
				</table>
				</cfform>		
			</td>
		</tr>			
	
		<tr><td colspan="11" class="line"></td></tr>
				
												
	</cfif>						
		
	<cfif Listing.recordcount gt 100>
	
		<cf_message	message = "Your search exceeds the 100 records, please narrow your search." return = "no">					
		
	<cfelse>				
	
		<cfif Listing.recordcount eq 0>				
		
			<cf_message	message = "No records found for the selected criteria."return = "no">						
			
		<cfelse>		
		
			<cfoutput query="Listing" group="fundingType">							
																													
					<tr>
					  <td colspan="11" class="labellarge" style="height:30;padding-left:3px">#fundingType#</td>
					</tr>
<!---					
				<cfoutput group="period">
				
					<cfif period neq "">
						<tr>
						  <td></td>
						  <td colspan="11" class="labelmedium" style="height:25;">#period#</td>
						</tr>
											
						<tr>
						  <td colspan="12" class="line"></td>
						</tr>
					</cfif>
--->					
				<cfoutput>
				
				<cfif URL.ID2 eq fundingId>		
				
				<tr>
					<td colspan="11">
				
					<!---<cfform method="POST" name="mytopic" onsubmit="return false">--->
					<cfform name="mytopic" onsubmit="return false">													    
			
					<table  width="100%" align="center" cellpadding="0" cellspacing="0">
					
						<tr style="background-color:##f4f4f4;">					
						
							<td  width="7%">
								<input type="hidden" name="Code" id="Code" value="#fundingId#">
							    <cfinput type="Text" 
							         value="#fundingType#" 
									 name="FundingType" 
									 message="You must enter a funding type" 
									 required="Yes" 
									 size="2" 
									 maxlength="10" 
									 class="regularH">
									 					 
					        </td>	
<!---							
							<td width="7%">
							
							    <cfinput type="Text" 
							         value="#period#" 
									 name="Period" 
									 message="You must enter a period" 
									 required="Yes" 
									 size="2" 
									 maxlength="10" 
									 class="regularH">
									 					 
					        </td>	
--->							
							<td width="8%">
							
							    <cfinput type="Text" 
							         value="#fund#" 
									 name="Fund" 
									 message="You must enter a fund" 
									 required="Yes" 
									 size="2" 
									 maxlength="20" 
									 class="regularH">
									 					 
					        </td>	
							
							<td width="7%">
							
							    <cfinput type="Text" 
							         value="#orgUnitCode#" 
									 name="orgUnitCode" 
									 message="You must enter a cost center" 
									 required="Yes" 
									 size="2" 
									 maxlength="20" 
									 class="regularH">
									 					 
					        </td>	
							
							<td width="7%">
							
							    <cfinput type="Text" 
							         value="#projectCode#" 
									 name="ProjectCode" 
									 message="You must enter a WBSe" 
									 required="Yes" 
									 size="2" 
									 maxlength="20" 
									 class="regularH">
									 					 
					        </td>	
							
							<td width="7%">
							
							    <cfinput type="Text" 
							         value="#programCode#" 
									 name="ProgramCode" 
									 message="You must enter a Functional Area" 
									 required="Yes" 
									 size="2" 
									 maxlength="20" 
									 class="regularH">
									 					 
					        </td>	
							
							<td width="8%">
							
							    <cfinput type="Text" 
							         value="#objectCode#" 
									 name="ObjectCode" 
									 message="You must enter a sponsored class" 
									 required="Yes" 
									 size="2" 
									 maxlength="10" 
									 class="regularH">
									 					 
					        </td>	
							
							<td width="8%">
							
							    <cfinput type="Text" 
							         value="#CBGrant#" 
									 name="CBGrant" 
									 message="You must enter a Grant" 
									 required="Yes" 
									 size="2" 
									 maxlength="10" 
									 class="regularH">
									 					 
					        </td>								
							
							<td width="17%">
								<select name="GLAccount" id="GLAccount" class="regularH">
									<cfloop query="lookupGLAccount">
									  <option value="#lookupGLAccount.glAccount#" <cfif #lookupGLAccount.glAccount# eq #Listing.glAccount#>selected</cfif>>#lookupGLAccount.glAccount# - #lookupGLAccount.description#</option>
								  	</cfloop>
								</select>
									 					 
					        </td>			
							
							<td width="6%">
							
							    <cfinput type="Text" 
							         value="#reference#" 
									 name="reference" 
									 size="15" 
									 maxlength="20" 
									 class="regularH">
									 					 
					        </td>										
							
							<td width="5%">
							
							    #SESSION.first# #SESSION.last#
									 					 
					        </td>
							
							<td width="3%">
							
							    #dateformat(now(),CLIENT.DateFormatShow)#
									 					 
					        </td> 
							
							<td align="center" width="11%">
						   
						   	  <input type="submit" 
						        value="Save" 
								onclick="save('#fundingId#')"
								style="width:60px;height:18px"
								class="button10s">
							&nbsp;
							<input type="button" 
						        value="Cancel" 
								onclick="cancel()"
								style="width:60px;height:18px"
								class="button10s">
			
							</td>
						   
					    </TR>					
					
					</table>
					</cfform>
					</td>
				</tr>																																																		
													
			
										
					<tr><td colspan="11" class="line"></td></tr>
																			
				<cfelse>														
					<TR>
					  
					   <td>
						  <cf_img icon="edit" onclick="ColdFusion.navigate('RecordListingDetail.cfm?alias=#alias#&ID2=#fundingId#','listing')">
					  </td>					   					  
					  
					   <td>
						   <A href="javascript:ColdFusion.navigate('RecordListingDetail.cfm?alias=#alias#&ID2=#fundingId#','listing')" title="edit">
						   #fund#
						   </a>
					   </td>
					    <td>#orgUnitCode#</td>
						<td>#projectCode#</td>
					   <td>#programCode#</td>
					   <td>#objectCode#</td>
					   <td>#CBGrant#</td>					   
					   <td>#glAccount#</td>
					   <td>#reference#</td>
					   <td>#OfficerFirstName# #OfficerLastName#</td>
					   <td>#dateformat(created,CLIENT.DateFormatShow)#</td>					  					   						   
					   <td align="center">		
					   		<cfif InUse eq "0">
								<cf_img icon="delete" onclick="if (confirm('Do you want to remove this record ?')) ColdFusion.navigate('RecordListingPurge.cfm?alias=#alias#&FundingId=#fundingId#','listing')">
							</cfif>
					   </td>		   
				   </tr>	
				  
				   <tr><td colspan="11" class="line"></td></tr>
		
			   </cfif>	 			 
					 					
				</cfoutput>
		
<!---							
			</cfoutput>		
--->			
			</cfoutput>		
			
		</cfif>									
		
	</cfif>
				
</table>