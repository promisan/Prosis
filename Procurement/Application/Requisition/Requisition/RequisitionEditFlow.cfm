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
<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<cfloop index="itm" list="#url.ajaxid#" delimiters="_"></cfloop>

	<cfquery name="Line" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT L.*
	    FROM RequisitionLine L
		WHERE RequisitionNo = '#itm#'
	</cfquery>
				 
	 <TR><TD id="collaboration" class="labelit">
		
			<cfif Line.entityClass eq "">				
			
				<cfquery name="Class"
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT DISTINCT R.*
					FROM  Ref_EntityClass R, 
					      Ref_EntityClassPublish P
					WHERE R.Operational = '1'
					AND  R.EntityCode   = P.EntityCode 
					AND  R.EntityClass  = P.EntityClass
					AND  R.EntityCode = 'ProcReq'			
				</cfquery>		
				
				<table class="formspacing"><tr><td>
			
				 <cf_tl id="Collaboration schema">:&nbsp;		
				<select name="entityclass" id="entityclass" class="regularxl">			
			    	<cfoutput query="Class">
						<option value="#EntityClass#">#EntityClassName#</option>				
					</cfoutput>			
				</select>
				
				</td>
				<td>			
				<button class="button10g" name="workflow" id="workflow" onclick="flowload(entityclass.value)">
					<cf_tl id="Initiate">
				</button>	
				</td>
				</tr></table>
			
			<cfelse>	
				
				<cfinclude template="RequisitionEditFlowShow.cfm">		
				
			</cfif>							
		</TD>	
	</TR>		
			
</table>