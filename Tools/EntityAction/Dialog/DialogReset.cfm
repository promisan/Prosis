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

<!--- define reset option --->

<cfquery name="Object" 
 datasource="appsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT *
	 FROM   OrganizationObject
	 WHERE  ObjectId = '#url.ObjectId#' 
 </cfquery>		
 
<cfoutput>	

<table width="90%" align="center" class="formpadding formspacing">

<tr class="labellarge">
<td colspan="2" style="font-size:16px">
Resetting the workflow will result in loosing process information you might have accumulated sofar. You have the following options:
</td></tr>

<tr class="labellarge">
<td style="min-width:50px" style="padding-top:3px" valign="top"><input class="radiol" type="radio" name="resetmode" id="purge" value="0"></td>
<td style="font-size:16px">Do not archive this workflow, all data will be generated again</td>
</tr>

<tr class="labellarge" style="padding-top:3px" valign="top">
<td><input class="radiol" type="radio" name="resetmode" value="1" id="archive" checked></td>
<td style="font-size:16px">
	<table>
	<tr>
	<td style="font-size:16px">Archive this workflow, and reinitiate the workflow object as if it was created the first time.
		
	<cfquery name="Entity" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT * FROM Ref_Entity WHERE EntityCode = '#Object.EntityCode#'
	</cfquery>	 
	
	<cfif Entity.EnableClassSelect eq "1" or getAdministrator("#Object.Mission#") eq "1"> 
		
		<cfquery name="Class" 
			 datasource="AppsOrganization"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 SELECT *
				 FROM   Ref_EntityClass R
				 WHERE  EntityCode = '#Object.entityCode#'							 
				 
				 <cfif Object.Owner neq ""> 
				 
				 AND     
			         (
					 
			         R.EntityClass IN (SELECT EntityClass 
			                           FROM   Ref_EntityClassOwner 
									   WHERE  EntityCode = '#Object.entityCode#'
									   AND    EntityClass = R.EntityClass
									   AND    EntityClassOwner = '#Object.Owner#')
									   
					 OR
					
					 R.EntityClass NOT IN (SELECT EntityClass 
			                           FROM   Ref_EntityClassOwner 
									   WHERE  EntityCode = '#Object.entityCode#'
									   AND    EntityClass = R.EntityClass)
									   
					  OR
					
					 R.EntityClass IN (SELECT EntityClass 
			                           FROM   Ref_EntityClassMission 
									   WHERE  EntityCode = '#Object.entityCode#'
									   AND    Mission = '#Object.Mission#'
									   AND    EntityClass = R.EntityClass)				   
									   
					 )				
				 		 
										
				 </cfif>
				 						 
				 <cfif Entity.EntityTableName neq "" and entity.EntityClassField neq "">
				 AND   EntityClass IN (SELECT #entity.EntityClassField# FROM #Entity.EntityTableName#)
				 </cfif>
				 
				 AND    EntityClass IN (SELECT   EntityClass
				              		    FROM     Ref_EntityClassPublish S
										WHERE    S.EntityCode     = '#Object.entityCode#')
				 				 
				 AND    Operational = 1
				
		</cfquery>				
				
		<cfif Object.EntityClass neq "">
			 <cfset cls = Object.EntityClass>
		<cfelse>
			 <cfset cls = url.entityclass>						
		</cfif>					   					
	
		Generate the new workflow using class:	
		
		<select name="newclass_#url.ObjectId#" id="newclass_#url.ObjectId#" style="background-color:f4f4f4;border:1px solid e6e6e6;font-size:16px" class="regularxl">
			<cfloop query="Class">
			<option value="#EntityClass#" <cfif entityClass eq cls>selected</cfif>>#EntityClassName#</option>
			</cfloop>
		</select>
		
		</td>
		</tr>
		<tr>		
		
		<td class="labelit" style="padding-bottom:4px">		
		Retain information elements and questionaires: <input type="checkbox" name="retain_#url.ObjectId#" id="retain_#url.ObjectId#" value="1" class="radiol">		
		</td>		
		
	<cfelse>
	
		<input type="hidden" name="newclass_#url.objectid#" id="newclass_#url.objectid#" value="#url.entityClass#">
	
	</cfif>	
	
	</td>
	</tr>
	</table>
</td>
</tr>

<tr class="line"><td colspan="2"></td></tr>

<tr><td colspan="2">
	
	<table class="formspacing"><tr>
	<td>
	<input type="button" value="Close" style="font-size:15px" class="button10g" onclick="ProsisUI.closeWindow('wfreset')">
	</td>
	<td>
	<input type="button" value="Apply" style="font-size:15px" class="button10g" onclick="resetwfapply('#url.objectid#','#url.ajaxid#',document.getElementById('archive').checked,document.getElementById('newclass_#url.objectid#').value,document.getElementById('retain_#url.objectid#').checked)">
	</td>
	</tr>
	</table>

</td></tr>

</table>

</cfoutput>