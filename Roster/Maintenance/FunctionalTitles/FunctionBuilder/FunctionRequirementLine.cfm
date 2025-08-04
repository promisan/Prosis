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
<cfparam name="URL.header" 			default="0">
<cfparam name="URL.requirementId" 	default="">

<cfquery name="Detail" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
    FROM   FunctionRequirementLine L, Ref_ExperienceParent P
	WHERE  RequirementId     = '#url.requirementId#'
	AND    P.Parent = P.Parent
	AND    P.Parent = '#ParentCode#'
	ORDER BY RequirementLineNo  
</cfquery>

<cf_tl id="Operational" var="lblOperational">

<cfset line = "">

<cfif Detail.recordcount eq "0">
   <cfparam name="URL.ID2" default="new">
<cfelse>
   <cfparam name="URL.ID2" default="new">   
</cfif>

<table width="98%" border="0" cellspacing="0" cellpadding="0" align="right" class="navigation_table">

    <cfset par = parentcode>
	
  	<cfset cnt = 1>								
	<cfoutput query="Detail">
						
	    <cfset val = "">
		
		<cfif detail.area eq "Skills">
				
			<cfquery name="keys" 
			datasource="appsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT R.Description as TopicDescription,*
		    FROM   FunctionRequirementLineTopic K, 
			       Ref_Topic R,
				   Ref_TopicList L
			WHERE  K.RequirementId     = '#url.requirementId#'
			AND    K.RequirementLineNo = '#RequirementLineNo#' 
			AND    K.Topic    = R.Topic
			AND    K.Topic    = L.Code
			AND    K.ListCode = L.ListCode
			AND    R.Parent = '#par#'
			</cfquery>
										
			<cfloop query="keys">
				<cfset val = "#val#,#topic#">
			</cfloop>
			
			<cfset vListCodeList = "#keys.question#: ">
			<cfloop query="keys">
				<cfset vListCodeList = vListCodeList & "#listCode#, ">
			</cfloop>
			
			<cfif trim(vListCodeList) neq "">
				<cfset vListCodeList = mid(vListCodeList, 1, len(vListCodeList) - 2)>
			</cfif>
			
			<cfloop query="keys">
				
				<cfif currentRow eq "1">
			
					<tr class="navigation_row">
					   <td width="20" style="padding-left:4px;padding-top:2px;"></td>
					   <td style="padding-left:10px" class="labelit" width="30">#cnt#.</td>
					   <td class="labelit"  width="50%">#vListCodeList#</td>
					   <td class="labelit" width="30%">#OfficerLastName# (#dateFormat(Created, CLIENT.DateFormatShow)#)</td>
					   <td class="labelit" width="10%"></td>
					   <td title="#lblOperational#">
					   		<input type="Checkbox" <cfif Detail.operational eq 1>checked</cfif> onclick="setReqLineOperational('#url.requirementId#','#RequirementLineNo#', this)">
					   </td>
					   <td width="10%" id="op_#url.requirementId#_#RequirementLineNo#" style="padding-left:5px; padding-right:5px;"></td>
					</TR>				
					
					<cfset cnt = cnt + 1>
						
				</cfif>	
			
			</cfloop>
		
		<cfelse>
							
			<cfquery name="keys" 
			datasource="appsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
		    FROM   FunctionRequirementLineField K, 
			       Ref_Experience R,
				   Ref_ExperienceClass C
			WHERE  K.RequirementId     = '#url.requirementId#'
			AND    K.RequirementLineNo = '#RequirementLineNo#' 
			AND    K.ExperienceFieldId = R.ExperienceFieldId	
			AND    C.Parent = '#par#'
			AND    C.ExperienceClass = R.ExperienceClass			 
			</cfquery>
				
			<cfloop query="keys">
				<cfset val = "#val#,#ExperienceFieldId#">
			</cfloop>
				
			<cfloop query="keys">
				
				<cfif currentRow eq "1">
			
					<tr class="navigation_row">
					   <td width="20" style="padding-left:4px;padding-top:2px;">
					   
					   <cfif box neq "hide">
						  <cf_img icon="edit" navigation="Yes" onclick="editField('#url.requirementId#','#RequirementLineNo#','#par#','#val#','#box#');">
					    </cfif>
				   	  
					   </td>
					   <td style="padding-left:10px" class="labelit" width="30">#cnt#.<!---#RequirementLineNo#---></td>
					   <td class="labelit"  width="50%">#Description#</td>
					   <td class="labelit" width="30%">#OfficerLastName# (#dateFormat(Created, CLIENT.DateFormatShow)#)</td>
					   <td class="labelit" width="10%"></td>
					   <td title="#lblOperational#">
					   
					   <cfinvoke component="Service.AccessGlobal"   
    			          method="global" 
			              role="FunctionAdmin" 
			              returnvariable="Access"> 
                                                      
						  <cfif Access eq "EDIT" or Access eq "ALL">   	
					   		<input type="Checkbox" <cfif Detail.operational eq 1>checked</cfif> onclick="setReqLineOperational('#url.requirementId#','#RequirementLineNo#', this)">
						  </cfif>	
							
					   </td>
					   <td width="10%" id="op_#url.requirementId#_#RequirementLineNo#" style="padding-left:5px; padding-right:5px;"></td>
					</TR>	
					
					<cfset cnt = cnt + 1>			
			
				<cfelse>
						
					<tr class="labelit navigation_row">
					   <td></td><td></td>
					   <td width="50%"><b>OR</b> #Description#</td>
					   <td width="30%"></td>
					   <td width="10%"></td>
					   <td></td>
				    </TR>	
						
				</cfif>	
			
			</cfloop>
			
		</cfif>	
				
										
	</cfoutput>
								
</table>

<cfset ajaxonload("doHighlight")>
		