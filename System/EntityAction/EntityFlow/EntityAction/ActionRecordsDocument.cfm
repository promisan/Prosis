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
<!--- ----------------------------------------- --->

<cfif url.entitycode eq "">
	<cfabort>
</cfif>

<form name="actioninformation" id="actioninformation">
		
<table width="96%" align="center" class="navigation_table">

<tr class="labelmedium"><td style="font-size:18px" colspan="4">Associate actions to one ore more reusable objects.<br>This will then allow you to define if and how they are used in a step</td></tr>

<cfset show = 0>

<cfloop index="itm" list="Report,Attach,Field,Question,Activity,Mail,Session" delimiters=",">
	
	<cfquery name="GroupAll" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Ref_EntityDocument R 
		WHERE   R.EntityCode = '#URL.EntityCode#'
		AND     R.DocumentType = '#itm#'
		<cfif itm eq "Attach">
		AND     R.DocumentMode = 'step'
		</cfif>
		AND     R.Operational = 1
		ORDER BY DocumentOrder 
	 </cfquery>		 

	 <cfif GroupAll.recordcount neq "0">
	 
	 <tr><td style="padding-top:4px"></td></tr>
	 <tr class="labelmedium2 line">
		 <td colspan="4" style="height:40px;font-size:20px"><cfoutput><cf_tl id="#itm#"></cfoutput>:</td>
	 </tr>
	 
	 <cfset show = 1>
	 	 	 
	 <cfset r = 0>
	 		 		 
	 <cfoutput query="GroupAll">
	 
	    <cfquery name="Check" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_EntityActionDocument R 
			WHERE  R.ActionCode = '#URL.actioncode#'
			 AND   R.DocumentId = '#DocumentId#'			
		</cfquery>   
									
	    <cfif r eq "0"><TR style="height:15px" class="navigation_row"></cfif>
					
			<td width="25%">
				<table width="100%">
				<cfif check.recordcount eq "0">
					      <TR class="regular fixlengthlist" style="height:16px">
				<cfelse>  <TR class="highlight2 fixlengthlist" style="height:16px">
				</cfif>
			   
				<TD style="padding-left:6px;width:30px">	
				<cfif Check.Recordcount eq "0">
					<input type="checkbox" class="radiol" name="Document" id="Document" value="#DocumentId#" onClick="hl(this,this.checked)"></TD>
				<cfelse>
					<input type="checkbox" class="radiol" name="Document" id="Document" value="#DocumentId#" checked onClick="hl(this,this.checked)"></td>
			    </cfif> 
				<TD class="labelmedium" title="#documentDescription#" style="padding-left:6px">#DocumentDescription#</TD>
				</table>
			</td>
			<cfif GroupAll.recordCount eq "1">
				<td width="33%"></td>
			</cfif>
	  			<cfif r neq 2>
				   <cfset r = r+1>
				<cfelse>
				   <cfset r = 0>
				</TR>
				</cfif> 	
				
	    </CFOUTPUT>
	
	</cfif>

</cfloop>

<cfif show eq "1">
	
	<cfoutput>
	   <tr style="border-top:1px solid silver">
		 <td colspan="4" height="34" align="center" id="associatedaction">
		 
			 <input type="button" 
				 class="button10g" 
				 value="Close" 
				 style="width:100px"
				 onClick="ProsisUI.closeWindow('associatedobject')" 
				 name="Close" id="Close">
			 
			 <input type="button" 
				 style="width:100px" 
				 class="button10g" 
				 value="Save" 
				 onClick="objectsave('#url.box#','#url.actioncode#')" 
				 name="Save" id="Save">		 
				 
		 </td>
	   </tr>
	</cfoutput>	 
	
<cfelse>

	<tr><td colspan="4" align="center" class="labelmedium">No objects founds</td></tr>	

</cfif>
	
</table>

</form>
		
<cfset ajaxonload("doHighlight")>	