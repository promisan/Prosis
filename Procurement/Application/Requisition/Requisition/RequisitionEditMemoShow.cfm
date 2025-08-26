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
<!--- Prosis template framework --->
<cfsilent>
	<proUsr>dev</proUsr>
	<proOwn>dev dev</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->

<cfquery name="Line" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT L.*
    FROM   RequisitionLine L
	WHERE  RequisitionNo = '#URL.ID#'
</cfquery>

<cfoutput>

<cfparam name="access" default="VIEW">
<cfparam name="url.access" default="#Access#">

<cfset text = replace(Line.Remarks,"<script","disable","all")>
<cfset text = replace(text,"<iframe","disable","all")>		

<cfif url.Access eq "Edit" or url.Access eq "Limited">

	<cfif Line.Remarks neq "">
		
	  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">	        					
			<tr><td class="labelmedium" style="border:1px solid d6d6d6;padding:4px;cursor: pointer;">#ParagraphFormat(text)#</td></tr>									
	  </table>
	       
	<cfelse>
	
	  <!---
	
	  <table bgcolor="white" cellspacing="0" cellpadding="0" align="center">
		<tr>
			
			<td  class="labelmedium" style="Padding-left:5px;padding-top:2px">					  
				<a href="javascript:about('#access#')"><font color="808080"><i><cf_tl id="REQ023"></font></a>
			</td>
		</tr>
	  </table>
	  
	  --->
		
	</cfif>

<cfelse>

	<cfif Line.Remarks neq "">

	<table width="100%" class="formpadding">		   		
		<tr><td class="labelmedium" style="border:1px solid d6d6d6;padding:4px;cursor: pointer;">#ParagraphFormat(Line.Remarks)#</td></tr>		
	</table>
	
	<cfelse>	
	
	<table bgcolor="white">
		<tr>
			
			<td style="Padding-left:0px;padding-top:2px" class="labelmedium">					  
				<font color="808080"><cf_tl id="REQ023"></font></a>
			</td>
		</tr>
	</table>		
				
	</cfif>

</cfif>

</cfoutput>
