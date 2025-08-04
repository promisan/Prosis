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

<cfparam name="url.routing" default="edit">

<cfquery name="Class"
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT DISTINCT R.*
		FROM   Ref_EntityClass R, 
		       Ref_EntityClassPublish P
		WHERE  R.Operational = '1'
		 AND   R.EntityCode   = P.EntityCode 
		 AND   R.EntityClass  = P.EntityClass
		 AND   R.EntityCode   = 'ProcInvoice' 
		 
		 <cfif getAdministrator("*") eq "1">
		 
		 <!--- no filtering as user is an administrator --->
		 
		 <cfelseif getAdministrator("#url.mission#") eq "1">
		 
		 	<!--- no filtering as user is an administrator --->
						
			AND     
			
	         (
			 
			 <!--- class enabled for an owner to which the user has access through the entity --->
			 
	         R.EntityClass IN (
			 
			 				   SELECT EntityClass 
	                           FROM   Ref_EntityClassOwner 
							   WHERE  EntityCode = 'ProcInvoice'
							   AND    EntityClass = R.EntityClass
							   AND    EntityClassOwner IN (
							                               SELECT MissionOwner 
									                       FROM   Ref_Mission 
														   WHERE  Mission IN ('#url.mission#')
														  )
								)
								
			 OR					
								
			 R.EntityClass IN (
			 
			 				   SELECT EntityClass 
	                           FROM   Ref_EntityClassMission 
							   WHERE  EntityCode  = 'ProcInvoice'
							   AND    EntityClass = R.EntityClass
							   AND    Mission     = '#url.mission#'
							  
							  )					
							   
			 OR
			
			  R.EntityClass NOT IN ( 
			  
			  						SELECT EntityClass 
			                        FROM   Ref_EntityClassOwner 
									WHERE  EntityCode = 'ProcInvoice'
									AND    EntityClass = R.EntityClass
									
								   )
							   
			 )		
			
		 
		 <cfelse>
		 
		 AND     
	         (
			 
			 <!--- class enabled for an owner to which the user has access through the entity --->
			 
	         R.EntityClass IN (
			 
			 				   SELECT EntityClass 
	                           FROM   Ref_EntityClassOwner 
							   WHERE  EntityCode = 'ProcInvoice'
							   AND    EntityClass = R.EntityClass
							   AND    EntityClassOwner IN (
							                               SELECT MissionOwner 
									                       FROM   Ref_Mission 
														   WHERE  Mission IN (SELECT Mission 
															                  FROM   OrganizationAuthorization 
																			  WHERE  UserAccount = '#SESSION.acc#' 
																			  AND    Role = 'ProcInvoice')
														  )
								)
								
			 OR					
								
			 R.EntityClass IN (
			 
			 				   SELECT EntityClass 
	                           FROM   Ref_EntityClassMission 
							   WHERE  EntityCode  = 'ProcInvoice'
							   AND    EntityClass = R.EntityClass
							   AND    Mission     = '#url.mission#'
							  
							  )					
							   
			 OR
			
			  R.EntityClass NOT IN ( 
			  
			  						SELECT EntityClass 
			                        FROM   Ref_EntityClassOwner 
									WHERE  EntityCode = 'ProcInvoice'
									AND    EntityClass = R.EntityClass
									
								   )
							   
			 )			
		
		
			  
		</cfif>	  			
												   
		ORDER BY R.ListingOrder											   
		
	</cfquery>

	<TR>
    	<TD class="labelmedium" style="padding-left:23px" width="10%"><font color="808080"><cf_space spaces="45"><cf_tl id="Clearance Routing">:</TD>
	    <TD colspan="1" class="labelit">
	
		<table cellspacing="0" cellpadding="0"><tr>
		
			<td style="width:24px" width="50%">
				<select name="entityclass" id="entityclass" class="regularxl enterastab" visible="Yes" enabled="Yes"  onchange="if (this.value != '') { document.getElementById('preview').className='regular' } else { document.getElementById('preview').className='hide' }">
				  <option value=""><cf_tl id="Please select"></option>
					 <cfoutput query="Class">
						<option value="#EntityClass#">#EntityClassName#</option>
					 </cfoutput>
				</select> 	
			</td>
			
			<td align="left" id="preview" class="hide" style="width:50%">
		
				<table cellspacing="0" cellpadding="0" class="formpadding">
				
				<tr>
				<td>
				<cfoutput>
				
					<button class="button3" type="button" style="width:300px"
					        onclick="workflow('ProcInvoice',document.getElementById('entityclass').value)">
							<img src    = "#SESSION.root#/Images/project.gif" 
							     alt    = "Preview workflow" 
								 border = "0" 
								 align  = "absmiddle">						 
					</button>
				
				</cfoutput>	
				
				</td>	       											
				<td class="labelmedium"><cf_tl id="Schedule">:</td>			
				<td style="padding-left:20px">
							
					<table cellspacing="0" cellpadding="0">
						<tr>
							<td>
								<input type="radio" checked name="schedule" class="radiol" id="schedule" value="direct"
								     onclick="document.getElementById('scheduledate').className='hide'">
							</td>
							<td class="labelmedium" style="padding-left:4px;padding-right:4px"><cf_tl id="Now"></td>
							<td style="padding-right:4px">
								<input type="radio" name="schedule" id="schedule" class="radiol" value="later" 
								    onclick="document.getElementById('scheduledate').className='regular'">
							</td>
							<td class="labelmedium" style="padding-left:4px;padding-right:4px"><cf_tl id="Later"></td>						
							<td class="hide" id="scheduledate" style="padding-right:4px">
							
								<cf_intelliCalendarDate9
				    		      FieldName="workflowdate" 
								  Icon="Images/schedule.gif"
								  class="regularxl"
								  DateValidStart="#Dateformat(now(), 'YYYYMMDD')#"						  
				    		      Default="#Dateformat(now(), CLIENT.DateFormatShow)#">		
							
							</td>
							
							<cfif url.routing eq "edit">							
								
								<td align="right" style="padding-right:4px">
								<cfif invoice.actionStatus neq "9">
									<cf_tl id="Submit for Processing" var="1">
									<input type="submit" style="width:200px;height:27px" class="button10g" name="Schedule" id="Schedule" value="<cfoutput>#lt_text#</cfoutput>">
								</cfif>
								</td>
							
							</cfif>
							
						</tr>							
					</table>
				
				</td>
													
				</tr>
				
				</table>
			
		</td>
												
		</tr>
			
		</table>			
		
		</td>
		
	</tr>
	