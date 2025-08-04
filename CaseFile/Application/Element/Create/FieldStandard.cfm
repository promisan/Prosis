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

<cfset row = row+1>

<cfoutput>

<tr><td valign="top" style="padding-top:4px" class="labelmedium">#row#.</td>	
		<td height="20" valign="top">	
			<table cellspacing="0" cellpadding="0">
				<tr><td valign="top" style="padding-top:2px" class="labelmedium"><cf_space spaces="68"><cf_tl id="Description">:</td></tr>
				<tr><td id="memocount"></td></tr>
			</table>
		</td>
		
		<td width="80%" colspan="2" class="labelit">		
		<cfif url.mode eq "Edit">
			<textarea name="ElementMemo"
	          class="regular"
	          style="width: 100%; padding:3px;font-size:13px;border-radius:4px;height: 70; word-wrap: break-word; word-break: break-all;"
	          onKeyUp="_cf_loadingtexthtml='';ColdFusion.navigate('#SESSION.root#/tools/input/text/memolength.cfm?field=ElementMemo&size=2000','memocount','','','POST','elementform')">#element.elementmemo#</textarea>		
		<cfelse>
			#element.elementmemo#
		</cfif>
		</td>
	</tr>
		
	<cfparam name="url.claimid" default="">
	
	<cfquery name="Topic" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	    SELECT Code
		FROM   Ref_TopicElementClass 
		WHERE  ElementClass = 'Document' 
		AND    PresentationMode = '6'		
	</cfquery>		
	
	<cfquery name="Document" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     CE.ElementId, 
	           E.Source, 
			   E.Reference, 
			   (SELECT TopicValue 
			    FROM   ElementTopic 
				WHERE  ElementId = E.ElementId 
				AND    ElementLineNo = 0 
				AND    Topic = '#topic.Code#') as Name,
			   E.ElementClass
	FROM       ClaimElement CE INNER JOIN
	                  Element E ON CE.ElementId = E.ElementId INNER JOIN
	                  Ref_ElementClass R ON E.ElementClass = R.Code
					  
	WHERE     R.AssociationSource = 1
	<cfif url.forclaimid neq "">
	AND       CE.ClaimId = '#url.forclaimid#'	
	<cfelse>
	AND       CE.ClaimId IN (SELECT ClaimId FROM ClaimElement WHERE ElementId = '#elementid#')
	</cfif> 
	
	</cfquery>
	
	<cfif url.claimid eq "">
		<cfset url.claimid = url.forclaimid>
	</cfif>
	
	<cfif url.claimid neq "" and document.recordcount neq "0">
		
		<cfif document.elementclass neq url.elementclass>
						
				<cfset row = row+1>
					
				<tr><td class="labelmedium">&nbsp;#row#.</td>
					 
					    <td class="labelmedium"><cf_tl id="Supporting Document">:&nbsp; <font color="red">*</font> </td>
						<td colspan="2" class="labelit">
						
						<cfparam name="CLIENT.SourceDocument" default="">
												
						<cfif caseelement.SourceElementId neq "">
						    <cfset sourcedocument = CaseElement.SourceElementId>
						<cfelse>
							<cfset sourcedocument = client.sourcedocument>
						</cfif>						
						
						<cf_tl id="Please select a supporting document." var="1" class="message">
						<cfselect name="SourceElementId" 
								  onchange="_cf_loadingtexthtml='';ColdFusion.navigate('ElementView.cfm?key='+this.value,'supporting')" 
								  required="true"
								  message="#lt_text#" class="regularxl enterastab">
						<option value=""></option>
						<cfloop query="Document">
						<option value="#ElementId#" <cfif sourcedocument eq ElementId>selected</cfif>>#Name# (#Reference#)</option>
						</cfloop>			
						</cfselect>	
									
						</td>
				</tr>	
				
				<tr><td height="3"></td></tr>
				
				<tr>
				<td></td>				
				<td></td>
				<td width="99%" height="2" colspan="3" bgcolor="fafafa" style="border:0px dotted gray;padding-left:4px;padding-right:4px"> 
					  	 
				   <cfif caseelement.sourceelementid eq "">
				    <cfdiv id="supporting">
				   <cfelse>
					<cfdiv bind="url:ElementView.cfm?key=#caseelement.sourceelementid#" id="supporting">
				   </cfif>	
				 
				</td>
				</tr>	
			
			</cfif>		
				
	</cfif>	
	
</cfoutput>	