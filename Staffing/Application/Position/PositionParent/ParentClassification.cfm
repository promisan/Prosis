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

<cfquery name="Parent" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT *
	 FROM  PositionParent		 
	 WHERE PositionParentId = '#URL.ajaxid#' 
</cfquery>

<cfoutput>

<form name="formclassification" id="formclassification">

	<table width="96%" align="center" class="formpadding">
	
		<cf_wfActive entityCode="PostClassification" objectkeyvalue1="#positionparentid#">	
				
		<cfif Parent.ApprovalPostGrade eq "">
		
			<tr class="labelmedium line">
				<td style="font-size:18px" align="center" colspan="2">Has NO prior classification recorded</td>		
			</tr>
		
		<cfelse>
		
			<cfif wfexist eq "1">
			<tr class="labelmedium line">
				<td style="font-size:18px" colspan="2" align="center">Has prior classification approval flow</td>		
			</tr>
			</cfif>
						
			<tr class="labelmedium">
				<td><cf_tl id="Classified as">:</td>
				<td style="width:70%">#Parent.ApprovalPostGrade# #Parent.FunctionDescription#</td>
			</tr>
			
			<tr class="labelmedium">
				<td><cf_tl id="Approval date">:</td>
				<td style="width:70%"><cfif parent.ApprovalDate eq ""><cf_tl id="Not available"><cfelse>#dateformat(Parent.ApprovalDate,client.dateformatshow)#</cfif></td>
			</tr>
				
			<tr class="labelmedium">
				<td><cf_tl id="Classification Code">:</td>
				<td style="width:70%">#Parent.ApprovalReference#</td>
			</tr>
			
			<cfif wfexist eq "1">
				
				<tr class="labelmedium">
					<td valign="top" style="padding-top:6px"><cf_tl id="Classification document">:</td>
					<td>
					<cf_filelibraryN
						DocumentPath="PostClassification"
						SubDirectory="#wfObjectId#" 
						Filter=""			
						Insert="no"
						Remove="no"			
						Loadscript="no"
						width="100%"	
						showsize="0"		
						border="1">	
					</td>
				</tr>
			
			</cfif>
			
		</cfif>
		
		<cfquery name="Class" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
				SELECT  EntityCode, EntityClass, EntityClassName
			    FROM    Ref_EntityClass AS R
			    WHERE   EntityCode = 'PostClassification' 
				AND     Operational = 1 
				<!--- is published --->
				AND     EXISTS (SELECT  'X'
			                    FROM    Ref_EntityClassPublish AS ECP
			                    WHERE   R.EntityCode  = EntityCode 
							    AND     R.EntityClass = EntityClass)
								
				AND     
				
		         (
				 
				 <!--- class enabled for an owner to which the user has access through the entity --->
				 
		         R.EntityClass IN (
				 
				 				   SELECT EntityClass 
		                           FROM   Ref_EntityClassOwner 
								   WHERE  EntityCode = 'PostClassification'
								   AND    EntityClass = R.EntityClass
								   AND    EntityClassOwner IN (
								                               SELECT MissionOwner 
										                       FROM   Ref_Mission 
															   WHERE  Mission IN ('#parent.mission#')
															  )
									)
									
				 OR					
									
				 R.EntityClass IN (
				 
				 				   SELECT EntityClass 
		                           FROM   Ref_EntityClassMission 
								   WHERE  EntityCode  = 'PostClassification'
								   AND    EntityClass = R.EntityClass
								   AND    Mission     = '#Parent.mission#'
								  
								  )					
								   
				 OR
				
				  R.EntityClass NOT IN ( 
				  
				  						SELECT EntityClass 
				                        FROM   Ref_EntityClassOwner 
										WHERE  EntityCode = 'PostClassification'
										AND    EntityClass = R.EntityClass
										
									   )
								   
				 )		
						 
			 
		</cfquery>
		
		<tr>
			<td><cf_tl id="Request type">:</td>
			<td style="width:70%">
				<table>
				<tr class="labelmedium">
				    <cfloop query="Class">
					    <td><input type="radio" class="radiol" name="EntityClass" value="#EntityClass#" <cfif currentrow eq "1">checked</cfif>></td>
						<td style="padding-top:3px;padding-left:4px;padding-right:6px">#EntityClassName#</td>
					</cfloop>
				</tr>
				</table>
			</td>
		</tr>
			
		<TR bgcolor="ffffff">
	    <TD colspan="2">			
		    <cf_tlhelp SystemModule = "Staffing" Class = "Position" HelpId = "poscls" LabelId = "Instructions">			 			
		</TD>
		
		<cf_tl id="Initiate Request" var="1">
		
		<tr>
		<td align="center" colspan="2" style="padding-top:7px;border-top:1px solid silver">	
			<input type="button" name="Initiate request" class="botton10g" style="width:220px;height:29px" value="#lt_text#"
			onclick="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/Staffing/Application/Position/PositionParent/ParentClassificationWorkflow.cfm?class=init&positionparentid=#url.ajaxid#&ajaxid=#url.ajaxid#&init=1','#url.ajaxid#','','','POST','formclassification');ProsisUI.closeWindow('classify')">					
		</td>
		</tr>
		
		
	</table>

</form>

</cfoutput>