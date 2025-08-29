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
<cfparam name="URL.ID" default="">
<cfparam name="URL.ID1" default="">
<cfset au = "">

<cfquery name="Audit" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   A.*, S.Description as SubPeriodDescription
    FROM     Ref_Audit A, Ref_SubPeriod S  
	WHERE    Period = '#URL.ID#'
	AND      A.SubPeriod = S.SubPeriod
	ORDER BY AuditDate
</cfquery>

<cfquery name="Sub" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_SubPeriod A 
</cfquery>

<cfset row = "4">
<cfset cls=arrayNew(1)>
<cfset cls1 = "A">
<cfset cls2 = "B">
<cfset cls3 = "C">
<cfset cls4 = "D">
	
<cfform method="POST" name="auditdialog">
	
	<table width="100%" align="center">
	    
	  <tr>
	    <td width="100%">
		
	    <table width="100%" class="navigation_table">
		
		<cfoutput>
			
	    <tr class="labelmedium2 line fixlengthlist">
		   <td height="18">&nbsp;</td>
		   <td><cf_tl id="Sub period"></td>	
		   <td><cf_tl id="Date"></td>
		   <td><cf_tl id="Description"></td>
		   <td colspan="#row#"><cf_tl id="Usage class"></td>
		   <td><cf_tl id="Graph"></td>
		   <td colspan="2">&nbsp;</td>	
	    </tr>
															
		<cfloop query="Audit">
																			
			<cfif URL.ID1 eq AuditId>
											
				<tr bgcolor="ECEEF2">
								    		
					   <td height="30">&nbsp;</td>		
					   
					   <td>
						   <select name="SubPeriod" style="font:10px" class="enterastab">
						   <cfloop query="sub">
						     <option value="#SubPeriod#" <cfif Audit.SubPeriod eq SubPeriod>checked</cfif>>#Description#</option>
						   </cfloop>
						   </select>
					   </td>
					   							   						 						  
					   <td>							   	   
					  	  <cf_intelliCalendarDate9
							FieldName="AuditDate" 
							Default="#Dateformat(AuditDate, CLIENT.DateFormatShow)#"
							AllowBlank="False"
							class="regularxl enterastab">	
							
					   </td>
					   
					  <td>
					     <input type="text" class="regularxl enterastab" name="Description" value="#Description#" size="20" maxlength="20">
					  </td>		
					   				   
					  <cfloop index="itm" from="1" to="#row#">
					  
					    <cfset cls  = Evaluate("cls" & #itm#)>
					  				  
						  <cfquery name="Check" 
							datasource="AppsProgram" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT *
						    FROM   Ref_AuditClass A 
							WHERE  AuditId = '#AuditId#'
							AND    AuditClass = '#cls#'
						  </cfquery>
						  
						   <td class="regular">
						    <table cellspacing="0" cellpadding="0">
								<tr>
									<td>
									<input type="checkbox" class="radiol enterastab" onclick="if (this.checked) {st=false} else {st=true};document.getElementById('auditlabel_#itm#').disabled=st" name="AuditClass_#itm#" value="#cls#"  <cfif Check.recordcount eq "1">checked</cfif>>		    		     
									</td>
									<td style="padding-left:2px;padding-right:4px"><cfoutput>#cls#</cfoutput></td>
									<td>
									<cfoutput>				 
									<input <cfif Check.recordcount eq "0">disabled</cfif> type="input" class="regularxl enterastab" style="width:60" id="auditlabel_#itm#" name="auditlabel_#itm#" value="#Check.AuditLabel#">
									</cfoutput>
									</td>
								</tr>
							</table>		    		    
						</td>						 
						
					  </cfloop>	
					  
					  <td align="center"><input type="checkbox" class="enterastab" name="ShowGraph" value="1" <cfif ShowGraph eq "1">checked</cfif>></td>
					  
					  <input type="hidden" name="AuditId" value="#AuditId#" class="button7">						   
				  			  
				   <td colspan="2" align="center">
				   
				   	  <input type="button" 
					       onclick="_cf_loadingtexthtml='';ptoken.navigate('AuditSubmit.cfm?action=edit&id=#URL.ID#&box=#URL.box#','#url.box#','','','POST','auditdialog')" 
					       name="update" value="Add" class="button10g" style="font-size:12px;height:22px;width:60px">
					   
				   </td>
	
			    </TR>	
											
			<cfelse>
					
				<TR class="cellcontent lablmedium2 line fixlengthlist navigation_row" style="height:25px">
				   <td>&nbsp;</td>	
				   <td>#SubPeriodDescription#</td>
				   <td>#Dateformat(Audit.AuditDate, CLIENT.DateFormatShow)#</td>
				   <td>#Description#</td>	
				   <cfloop index="itm" from="1" to="#row#">
	   			  			  
				   <td >
				   			  			   
				   <cfset cls  = Evaluate("cls#itm#")>
				
				   <cfquery name="Check" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT *
				    FROM Ref_AuditClass A 
					WHERE AuditId = '#Audit.AuditId#'
					AND AuditClass = '#cls#'
				  </cfquery>
				   
				   <cfif Check.recordcount eq '1'>		   
	   				   #cls# (#check.AuditLabel#)
				   <cfelse>
					   <!--- nada --->
	    		   </cfif>	  
				  			  
				   </td>
				   
				   </cfloop>
				   
				   <td  align="center"><cfif ShowGraph eq "1">Yes</cfif></td>
				  			  
				   <td  align="center" colspan="2">
				   
				   	<table cellspacing="0" cellpadding="0">
						<tr>
							<td style="padding-right:5px;">
								<cf_img navigation="Yes" icon="edit" 
								   onclick="ptoken.navigate('Audit.cfm?action=edit&ID=#URL.ID#&ID1=#Audit.AuditId#&Box=#URL.Box#','#URL.box#')">
							</td>
							<td>
								<cfquery name="Check" 
								datasource="AppsProgram" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								
								    SELECT AuditId
									FROM   ProgramIndicatorAudit 
									WHERE  AuditId = '#auditid#'
									AND    AuditStatus != '0'
									
									UNION
									
									SELECT AuditId
									FROM   ProgramAllotmentRequestQuantity 
									WHERE  AuditId = '#auditid#'	
								   </cfquery>
								   
								   <cfif check.recordcount eq "0">
									  <cf_img icon="delete" onclick="ptoken.navigate('AuditPurge.cfm?ID=#URL.ID#&ID1=#Audit.AuditId#&Box=#URL.Box#','#URL.box#');">
									<cfelse>
								         <img src="#Client.VirtualDir#/Images/locked.jpg" align="absmiddle" alt="Used" border="0" height="14" width="14">	
								   </cfif>
							
							</td>
						</tr>
					</table>
					  
				    </td>
								   
			    </TR>	
						
			</cfif>							
				
		    <cfset au = AuditDate+daysinmonth(AuditDate)>
		
		</cfloop>
				
		</cfoutput>
				
			<cfif URL.ID1 eq ""> <!--- and #URL.ProgramAccess# eq "ALL" --->
																
					<tr>
								    		
					   <td style="height:36px">&nbsp;</td>		
					   
					   <td class="regular">
					   
					   <select name="SubPeriod" class="regularxl" style="font:10px">
					   <cfoutput query="sub">
					     <option value="#SubPeriod#">#Description#</option>
					   </cfoutput>
					   </select>
					   
					   </td>
					   							   						 						  
					   <td>
					   
					   <cfif Au neq "">
					   				   			   
					  	  <cf_intelliCalendarDate9
							FieldName="AuditDate" 
							Default="#DateFormat(Au,CLIENT.DateFormatShow)#"
							AllowBlank="False"
							class="regularxl enterastab">	
							
						<cfelse>	
						
						<cfquery name="Check" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT *
						    FROM Ref_Period A 
							WHERE Period = '#URL.ID#'
						</cfquery>
										
						<cf_intelliCalendarDate9
							FieldName  = "AuditDate" 
							Default    = "#DateFormat(Check.DateEffective+14,CLIENT.DateFormatShow)#"
							AllowBlank = "False"
							class      = "regularxl enterastab">		
						
						</cfif>		
					   </td>
					   
					    <td><input type="text" class="regularxl enterastab" name="Description" value="" size="20" maxlength="20"></td>	
					  
					  <cfloop index="itm" from="1" to="#row#">
					  
					    <cfset cls  = Evaluate("cls" & #itm#)>
					  
					    <td class="regular">
						    <table cellspacing="0" cellpadding="0">
							<tr>
							<td>
							<cfoutput>				 
							<input onclick="if (this.checked) {st=false} else {st=true};document.getElementById('auditlabel_#itm#').disabled=st" type="checkbox" class="radiol enterastab" name="AuditClass_#itm#" value="#cls#">
							</cfoutput>
							</td>
							<td style="padding-left:4px;padding-right:4px"><cfoutput>#cls#</cfoutput></td>
							<td>
							<cfoutput>				 
							<input type="input" disabled class="regularxl enterastab" style="width:60" id="auditlabel_#itm#" name="auditlabel_#itm#" value="">
							</cfoutput>
							</td>
							</tr>
							</table>		    		    
						</td>	
						
					  </cfloop>	
					  
					  <td align="center"><input type="checkbox" class="radiol" name="ShowGraph" value="1" checked></td>
									  				 				  			  
				   <td colspan="2" align="center">
				   
				    <cfoutput>
					
					   <input type="button" 
					   onclick="_cf_loadingtexthtml='';ptoken.navigate('AuditSubmit.cfm?action=insert&id=#URL.ID#&box=#URL.box#','#url.box#','','','POST','auditdialog')" 
					   name="update" value="Update" class="button10g" style="font-size:12px;height:21px;width:60px">
					   </cfoutput>
					   
					   </td>
	
			    </TR>	
				
				</cfif>	
								
			</table>
	
			</td>
		</tr>
					  			
	</table>	
	
	</cfform>
			
	<cfset ajaxonload("doHighlight")>
	<cfset ajaxonload("doCalendar")>
	
