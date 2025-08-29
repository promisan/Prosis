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
<cfparam name="url.TopicCode" default="">

<cfquery name="Category" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_ClaimCategory	
</cfquery>

<cfquery name="Status" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_Status
	WHERE StatusClass = 'lne'
</cfquery>

<cfquery name="CurrencyList" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Currency
</cfquery>

<cfquery name="Parameter" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Parameter
</cfquery>

<cfparam name="wf" default="1">
<cfparam name="url.id" default="">

<cfif url.id neq "">
	
	<cfquery name="Action" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  OrganizationObjectAction A, OrganizationObject O
		WHERE A.ObjectId = O.ObjectId
		AND   A.ActionId = '#URL.ID#'
	</cfquery>
	
	<cfparam name="URL.claimid" default="#Action.ObjectKeyValue4#">

</cfif>

<cfquery name="Claim" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Claim
	WHERE   ClaimId = '#URL.ClaimId#'	
</cfquery>

<cfquery name="Detail" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    ClaimLine INNER JOIN
            Ref_ClaimCategory ON ClaimLine.ClaimCategory = Ref_ClaimCategory.Code
	WHERE   ClaimId = '#URL.ClaimId#'	
	<cfif topiccode neq "">
	AND     TopicCode = '#TopicCode#'
	</cfif>
</cfquery>

<cfinvoke component="Service.Access"  
     method="CaseFileManager" 
     mission="#Claim.Mission#" 
	 claimtype="#claim.claimtype#"
     returnvariable="access">

<cfif Detail.recordcount eq "0" 
     and (Access eq "ALL" or Access eq "EDIT")>
	    <cfparam name="URL.ID2" default="new">
	  
<cfelse>
   <cfparam name="URL.ID2" default="">   	   
</cfif>			

	<table width="98%" border="0" bordercolor="silver" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	    <tr><td height="6"></td></tr>
		<tr>
	
	    <td width="100%" align="center">
		
		<cfform action="#SESSION.root#/CaseFile/Application/Case/Financial/ClaimLineSubmit.cfm?ClaimId=#URL.ClaimId#&topiccode=#url.topiccode#&id2=#url.id2#" 
		   method="POST" name="element">		
		
		    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="formspacing formpadding">
				
		    <TR height="18" class="line labelmedium">
			   <td width="100">Date</td>  
			   <td width="10%">Category</td>
			   <td width="10%">Curr.</td>
			   <td width="10%" align="right"><cf_tl id="Amount Claimed"></td>
			   <td width="10%" align="right"><cf_tl id="Amount Approved"></td> 
	   		   <td width="10%" align="right"><cf_tl id="Reference"></td>		    
			   <td width="15%" align="right"><cf_tl id="Status"></td>  
			   <td width="15%" align="right" style="padding-right:5px">
		       <cfoutput>
			     <cfif access eq "EDIT" or Access eq "ALL">	
				 	<cfif URL.ID2 neq "new">
				    	 <A href="javascript:ptoken.navigate('#SESSION.root#/CaseFile/Application/Case/Financial/ClaimLine.cfm?ClaimId=#URL.ClaimId#&topiccode=#url.topiccode#&ID2=new','contentbox#url.tabno#')">
						 <font color="0080FF"><cf_tl id="[add]"></font></a>
					 </cfif>
				  </cfif>	 
			   </cfoutput>
			   </td>
			  
		    </TR>	
							
			<cfif URL.ID2 eq "new">
												
				<TR>
				
				<td class="labelit">
				
					<cf_space spaces="29">
															
						  <cf_intelliCalendarDate9
							FieldName="DateApproval" 
							Default=""
							Calendar="show"
							Class="regularxl"
							AllowBlank="True">					
									 
				</td>			 
				
				<td class="labelit">
				
				    <select name="ClaimCategory" class="regularxl">
				      <cfoutput query="Category">
					    <option value="#Code#" selected>#Description#</option>
					  </cfoutput>
					</select>
				
		        </td>		
				
				<td class="labelit">
					 <select name="Currency" class="regularxl">
				      <cfoutput query="CurrencyList">
					    <option value="#currency#" <cfif Parameter.BaseCurrency eq currency >selected</cfif>>#Currency#</option>
					  </cfoutput>
					 </select>
					   
				</td>
					
				<td align="right" class="labelit">		
				
					<cf_tl id="You must enter an amount" var="1">
								 
					 <cfinput type="Text"
				       name="AmountClaim"
				       message="#lt_text#"
				       validate="float"
				       required="Yes"
				       size="10"
					   style="text-align:right"
				       maxlength="15" 
					   class="regularxl">				   
				</td>
								 					 
				<td align="right" class="labelit">		
				
					 <cf_tl id="You must enter a name" var="1">
					 
					 <cfinput type="Text"
				       name="AmountApproval"
				       message="#lt_text#"
				       validate="float"
				       size="10"
				       maxlength="15" 
					   style="text-align:right"
					   class="regularxl">				   
				</td>
				
	
				<td align="right" class="labelit">			
					<cf_tl id="You must enter a reference"	var="1">
					
					 <cfinput type="Text"
				       name="Reference"
				       message="#lt_text#"
				       size="15"
				       maxlength="15" 
					   class="regularxl">				   
				</td>
				
				<td align="right" class="labelit">
					 <select name="ActionStatus" class="regularxl">
				      <cfoutput query="Status">
					    <option value="#Status#">#Description#</option>
					  </cfoutput>
					 </select>				   
				</td>
	
												   
				<td align="right" class="labelit">
				
					<input type="submit" 
					value="Add" 
					class="button10s" 
					style="width:40">
				
				</td>	
						    
				</TR>	
					
				<tr>
					
					<td height="26" colspan="8" align="right" class="labelit">
							<table width="100%" cellspacing="0" cellpadding="0">
								<tr>
								<td width="50" align="center">
								<img src="<cfoutput>#Client.VirtualDir#</cfoutput>/images/postit.png" 
								alt="edit" 
								border="0" 
								align="absmiddle">
								</td>
								<td colspan="1">
								
								<input type="Text" 
								         name="ClaimLineMemo" 
										 style="width:90%" 
										 maxlength="100" 
										 class="regularxl">
										 
								</td>
							</table>														
					</td>
							
				</tr>	
				
				<tr><td colspan="8" class="line"></td></tr>
																
			</cfif>						
				
			<cfoutput>
			
			<cfloop query="Detail">			
			
			<cfquery name="GetStatus" 
				datasource="AppsCaseFile" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM  Ref_Status
					WHERE StatusClass = 'lne'
					AND Status = '#ActionStatus#' 
				</cfquery>
				
				<cfquery name="GetCategory" 
				datasource="AppsCaseFile" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM  Ref_ClaimCategory
					WHERE Code = '#ClaimCategory#'
				</cfquery>
																				
			<cfif URL.ID2 eq ClaimLineId>		
							
				<cfset cde = claimcategory>
				<cfset cur = currency>
				<cfset act = actionstatus>
													
				<TR>
				
					<td>
					
					<cf_space spaces="36">
					
				    <cf_intelliCalendarDate9
					FieldName="DateApproval" 
					Default="#dateformat(dateapproval,CLIENT.DateFormatShow)#"
					Class="regularxl"
					AllowBlank="True">	
						  
		           </td>
				  
				   <td>
				   	  <select name="ClaimCategory" class="regularxl">
				      <cfloop query="Category">
					    <option value="#Code#" <cfif cde eq code>selected</cfif>>#Description#</option>
					  </cfloop>
					</select>
						  
		           </td>
				   
				    <td>
				   	  <select name="Currency" class="regularxl">
				      <cfloop query="CurrencyList">
					    <option value="#currency#" <cfif cur eq currency or (cur eq "" and currency eq Parameter.BaseCurrency)>selected</cfif>>#Currency#</option>
					  </cfloop>
					 </select>	  
		           </td>
				   
				    <td>
					
					<cf_tl id="You must enter an amount" var="1">
					
				   <cfinput type="Text"
				       name="AmountClaim"
				       message="#lt_text#"
				       validate="float"
				       required="Yes"
					   value="#AmountClaim#"
				       size="10"
					   style="text-align:right"
				       maxlength="15" 
					   class="regularxl">	  
		           </td>
				   
				    <td>
					
					<cf_tl id="You must enter an amount" var="1">
					
				   	  <cfinput type="Text"
				       name="AmountApproval"
				       message="#lt_text#"
				       validate="float"
					   value="#AmountApproval#"
				       size="10"
				       maxlength="15" 
					   style="text-align:right"
					   class="regularxl">	  
		           </td>
				   
					<td align="right">			
					
					<cf_tl id="You must enter a reference" var="1">
						
					 <cfinput type="Text"
				       name="Reference"
				       message="#lt_text#"
				       size="15"
				       maxlength="15"
					   
					   value="#reference#" 
					   class="regularxl">				   
					</td>		   
				   			 			   
				   <td align="right">
					 <select name="ActionStatus" class="regularxl">
				      <cfloop query="Status">
					    <option value="#Status#" <cfif act eq status>selected</cfif>>#Description#</option>
					  </cfloop>
					 </select>
					   
				</td>
				   			   
				   <td align="right">
				   
				       <cf_tl id="Save" var="1">
				   
					   <input type="submit" 
				        value="<cfoutput>#lt_text#</cfoutput>" 
						class="button10g" 
						style="width:40">
						
					</td>
			    </TR>	
				
				<tr>
					<td colspan="8" align="right">
							<table width="100%" cellspacing="0" cellpadding="0">
								<tr>
								<td width="50" align="center">
								<img src="<cfoutput>#Client.VirtualDir#</cfoutput>/images/postit.png" 
								alt="edit" 
								border="0" 
								align="absmiddle">
								</td>
								<td colspan="1">
								
								<input type="Text" 
								    name="ClaimLineMemo" 
									style="width:99%;font-size:13px;padding;3px;border-radius:5px" 
									maxlength="80" 
									class="regularxl">
										 
								</td>
							</table>														
					</td>
							
				</tr>	
				
															
			<cfelse>
			
				<cfquery name="Drill" 
					datasource="AppsCaseFile" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT  *
						FROM    ClaimLineAction 
						WHERE   ClaimLineId = '#ClaimLineId#'	
					</cfquery>
						
				<TR>
				   <td class="labelit">#dateformat(DateApproval,"#CLIENT.DateFormatShow#")#</td>	
				   <td height="20" class="labelit">#getCategory.Description#</td>
				   <td class="labelit">#currency#</td>
				   <td align="right" class="labelit">#numberformat(AmountClaim,"__,__.__")#</td>
				   <td align="right" class="labelit">#numberformat(AmountApproval,"__,__.__")#</td>
				   <td align="right" class="labelit">#reference#</td>
				   
				   <td align="right" class="labelit"><a href="javascript:showdetail('#currentrow#')">#getStatus.Description#</a>
				   
				   <cfif drill.recordcount gte "1">
				   
				   <img src="#Client.VirtualDir#/Images/zoomin.jpg" 
					alt="Show history"  
					id="#currentRow#Exp" border="0" class="regular" 
					align="absmiddle" style="cursor: pointer;" 
					onClick="javascript:showdetail('#currentrow#')">
					
					<img src="#Client.VirtualDir#/Images/zoomout.jpg" 
					id="#currentRow#Min" 
					alt="Hide" border="0" 
					align="absmiddle" class="hide" style="cursor: pointer;" 
					onClick="javascript:showdetail('#currentrow#')">	
					
				   </cfif>	
				   
				   </td>
				   <td align="right" class="labelit">			   
				     <table>		
				     <tr>   
				     <cfif access eq "EDIT" or Access eq "ALL">		  
					   	<td>					
						  <cf_img icon="edit" onclick="ptoken.navigate('#SESSION.root#/CaseFile/Application/Case/Financial/ClaimLine.cfm?ClaimId=#URL.ClaimId#&topiccode=#url.topiccode#&ID2=#claimLineId#','contentbox#url.tabno#')">			
						</td>			
					    <td style="padding-left:4px"> 
							<cf_img icon="delete" onclick="ptoken.navigate('#SESSION.root#/CaseFile/Application/Case/Financial/ClaimLinePurge.cfm?ClaimId=#URL.ClaimId#&topiccode=#url.topiccode#&ID2=#claimLineId#','contentbox#url.tabno#')">			
						</td>				
					 </cfif>	
					 </table>					   
					 </tr>
	   		    </td>
				</tr>
				
				<tr><td colspan="8" class="line"></td></tr>
				
				<cfif claimlinememo neq "">
				<tr>
					<td height="25"></td>
					<td colspan="8" align="right" class="labelit">
						#ClaimLineMemo#	
					</td>						
				</tr>	
				</cfif>
				
				<cfif drill.recordcount gte "1">
				
				<tr id="act#currentrow#" class="hide">
				    <td></td>
					<td colspan="8">					
						<table width="100%" cellspacing="0" cellpadding="0">
						<cfloop query="drill">
						<tr class="labelit">
						   <td width="160" class="labelit">#officerFirstName# #OfficerLastName#</td>	
						   <td width="40" class="labelit">#currency#</td>
					       <td width="100" align="right" class="labelit">#numberformat(AmountClaim,"__,__.__")#</td>
					       <td width="100" align="right" class="labelit">#numberformat(AmountApproval,"__,__.__")#</td>
					       <td width="100" align="right" class="labelit">#Reference#</td>				   
					       <td width="100" align="right" class="labelit">#dateformat(DateApproval,"#CLIENT.DateFormatShow#")#</td>	
						   <td width="100" align="right" class="labelit">#dateformat(Created,"#CLIENT.DateFormatShow#")#</td>					   
						<tr>
						</cfloop>
						</table>		
					</td>									
				</tr>
				
				</cfif>
				
				<!--- dev removed actionStatus neq 0 condition as per EPST Request --->
				
				<cfif wf eq "1">
				
				<tr><td colspan="8" class="labelit">
				
				    <!--- reference to the workflow --->
					
					<cfset wflink = "#SESSION.root#/CaseFile/Application/Case/Financial/ClaimLineWorkflow.cfm">
				
					<input type="hidden" 
					   name="workflowlink_#claimlineid#" 
					   id="workflowlink_#claimlineid#" 				   
					   value="#wflink#">
				
					<cfdiv bind = "url:#wflink#?ajaxid=#claimlineid#" 
					       id   = "#claimlineid#">
						
				</td></tr>
				
				<cfelse>
				
				<tr><td colspan="8" class="line"></td></tr>
				
				</cfif>			
										 					
			</cfif>
							
			</cfloop>
			</cfoutput>									
					
			</table>		
										
		</cfform>
			
		</td>
		</tr>	
		
		<cfoutput>
			<cfset set = 160-(detail.recordcount*20)>
			<cfif set lte "0"><cfset set = 0></cfif>
			<tr><td height="#set#"></td></tr>		
		</cfoutput>		
		
	</table>				
	
<cfset ajaxonload("doHighlight")>
<cfset ajaxonload("doCalendar")>
	

