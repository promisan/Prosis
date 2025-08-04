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

<cfquery name="get" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    ClaimIncident
	WHERE   ClaimId = '#URL.ClaimId#'	
</cfquery>

<cfquery name="qCasualty" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM  Ref_Incident
	where class='Casualty'
</cfquery>

<cfquery name="Parameter" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  top 1 P.*
	FROM    Ref_ParameterMission P
</cfquery>

<cfquery name="qMission" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     *
	FROM         Ref_Mission	
	WHERE 
	<!--- Operational = 1 AND   --->
	MissionType = 'Mission' <!--- #parameter.MissionType# --->
	ORDER BY Mission
</cfquery>

<cfquery name="qCause" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_Incident
	where   Class = 'Cause'
</cfquery>

<cfquery name="qCircumstance" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_Incident
	WHERE   Class = 'Circumstance'
</cfquery>

<cfquery name="qCountry" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_Nation
	ORDER BY Name
</cfquery>

<cfoutput>

<cfform onsubmit="return false"	name="formincident">

<table width="95%" border="0" cellspacing="0" cellpadding="0" class="formpadding" align="center">
		
		<tr><td height="4"></td></tr>
		
		<tr><td height="26">
			<table width="100%">
			<tr><td class="labellarge" style="font-size:25px;color:##808080;"><cf_tl id="General Information"></td>
				<td align="right" id="incidentprocess"></td>
			</tr>
			</table>
		</td></tr>
		
		<tr><td colspan="4" class="line"></td></tr>
		
	    <tr>
			<td colspan="2" height="100%">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center"  class="formpadding formspacing">
						
				<tr>
				<td  height="25" width="17%" class="labelit" style="padding-left:10px"><cf_tl id="Incident Date">:</td>
				<td  height="25" width="83%" class="labelit">
				
				<cfif mode eq "Edit">
				
					<cfif get.recordcount eq "0">
					
						<cf_intelliCalendarDate9
							FieldName="IncidentDate" 
							Default=""
							class="regularxl"
							AllowBlank="False">	
							
					<cfelse>
					
						<cf_intelliCalendarDate9
							FieldName="IncidentDate" 
							Default="#dateformat(get.IncidentDate,CLIENT.DateFormatShow)#"
							class="regularxl"
							AllowBlank="False">	
					
					</cfif>
					
				<cfelse>
				
					#dateformat(get.IncidentDate,CLIENT.DateFormatShow)#
					
				</cfif>
				
				</tr>
				
				<tr>
				<td  height="25" width="17%" class="labelit" style="padding-left:10px"><cf_tl id="Mission">:</td>
				<td  height="25" width="83%" class="labelit">
				
				<cfif mode eq "Edit">
							<select name="Mission" class="regularxl">
							  <cfif #get.Mission# eq "UNDEFINED" or #get.Mission# eq "">
								  <option value="UNDEFINED" selected>Undefined</option>
							  <cfelse>
								  <option value="UNDEFINED">Undefined</option>
							  </cfif>
							
							  <cfloop query="qMission">
								<cfif #Mission# eq #get.Mission#>
									<option value="#Mission#" selected>#Mission#</option>
								<cfelse>
									<option value="#Mission#">#Mission#</option>
								</cfif>
							  </cfloop>
							</select>
				<cfelse>				
						#get.Mission#
				</cfif>
				</tr>
				
				<tr>
				<td  height="25" width="17%" class="labelit" style="padding-left:10px"><cf_tl id="Location">:</td>
				<td  height="25" width="83%" class="labelit">
				<cfif mode eq "Edit">
						<select name="Location" class="regularxl">
						  <cfif #get.Location# eq "UNDEFINED" or #get.Location# eq "">
								  <option value="UNDEFINED" selected>Undefined</option>
						  <cfelse>
							  <option value="UNDEFINED">Undefined</option>
						  </cfif>
						  <cfloop query="qCountry">
							<cfif #Code# eq #get.Location#>
								<option value="#Code#" selected>#Name#</option>
							<cfelse>
								<option value="#Code#">#Name#</option>
							</cfif>
						  </cfloop>
						</select>				
				<cfelse>
					<cfquery dbtype="query" name="DCountry">
						Select * from qCountry
						where Code='#get.Location#'
					</cfquery>
					#DCountry.Name#
				</cfif>
				</tr>								
				<tr>
				<td  height="25" width="17%" class="labelit" style="padding-left:10px"><cf_tl id="Cause">:</td>
				<td  height="25" width="83%" class="labelit">
				<cfif mode eq "Edit">
				    <select name="Cause" class="regularxl">
				      <cfloop query="qCause">
					  	<cfif #Code# eq #get.Cause# or (#get.recordcount# eq "0" and #Code# eq "UNDEFINED")>
						    <option value="#Code#" selected>#Description#</option>
						<cfelse>
						    <option value="#Code#">#Description#</option>
						</cfif>
					  </cfloop>
					</select>			
				<cfelse>
					<cfquery dbtype="query" name="DCause">
						Select * from 
						qCause
						where Code='#get.Cause#'
					</cfquery>
					#Dcause.Description#
				
				</cfif>
				</td>				
				</tr>

				<tr>
				<td  height="25" width="17%" class="labelit" style="padding-left:10px"><cf_tl id="Casualty">:</td>
				<td  height="25" width="83%">
				
				<table cellspacing="0" cellpadding="0">
				<tr><td class="labelit">
				
				
				<cfif mode eq "Edit">
				    <select name="CasualtyType" class="regularxl">
				    
					  	<cfif "Personal" eq get.CasualtyType or get.recordcount eq "0">
						    <option value="Personal" selected>Personal</option>
							 <option value="Family">Family</option>
						<cfelse>
						     <option value="Personal">Personal</option>
				  		    <option value="Family" selected>Family</option>
						</cfif>
					  
					</select>			
				<cfelse>
					#get.CasualtyType#
				</cfif>
				
				</td>
				
				<td>&nbsp;</td>
				
				<td class="labelit">
				
				<cfif mode eq "Edit">
				    <select name="Casualty" class="regularxl">
				      <cfloop query="qCasualty">
					  	<cfif Code eq get.Casualty or (#get.recordcount# eq "0" and #Code# eq "UNDEFINED")>
						    <option value="#Code#" selected>#Description#</option>
						<cfelse>
				  		    <option value="#Code#">#Description#</option>
						</cfif>
					  </cfloop>
					</select>			
				<cfelse>
					<cfquery dbtype="query" name="DCasualty">
						SELECT  * 
						FROM   qCasualty
						WHERE  Code='#get.Casualty#'
					</cfquery>					
					#DCasualty.Description#
				</cfif>
				
				</td></tr>
				
				</table>
								
				</td>							
				</tr>
					
				<tr>
				<td  height="25" width="17%" class="labelit" style="padding-left:10px"><cf_tl id="Circumstances">:</td>
				<td  height="25" width="83%" class="labelit">
				<cfif mode eq "Edit">
				    <select name="Circumstance" class="regularxl">
				      <cfloop query="qCircumstance">
					  	<cfif Code eq get.Circumstance or (get.recordcount eq "0" and Code eq "UNDEFINED")>
						    <option value="#Code#" selected>#Description#</option>
						<cfelse>
						    <option value="#Code#">#Description#</option>
						</cfif>
					  </cfloop>
					</select>						
				<cfelse>
					<cfquery dbtype="Query" name="DCircumstance">
						Select * from
						qCircumstance
						where Code='#get.Circumstance#'
					</cfquery>
					#DCircumstance.Description#
				</cfif>
				
				</td>							
				</tr>				
				
				<tr>
				<td  valign="top" height="25" width="17%" class="labelit" style="padding-top:5px;padding-left:10px"><cf_tl id="Additional"><br><cf_tl id="comments">:</td>
				<td  height="100%" width="83%" class="labelit">
				
					<cfif mode eq "Edit">
					
						<textarea class="regular" name="Remarks" style="font-size:13px;padding:3px;border-radius:5px;width:94%;height:130">#get.Remarks#</textarea>
													 
					 <cfelse>
				
						 #get.Remarks#
						 
					 </cfif>
				
				</td>							
				</tr>
			</table>
			</td>
		</tr>
		<tr>		
		
		<tr><td height="5"></td></tr>
		<tr><td   colspan="4" Class="line"></td></tr>	
		
		<tr>
			<td height="35" colspan="2" align="center">
				<cfif mode eq "Edit">
				   <input type="button" 
				    onclick="validateincident('#url.claimid#','#url.box#')"
			        value="Save" 
					class="button10g" 
					style="width:120;height:26">
				</cfif>
			</td>
		</tr>
		
</table>		

</cfform>

</cfoutput>