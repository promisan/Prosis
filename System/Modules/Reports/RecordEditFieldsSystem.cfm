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
<cfoutput>
<table width="95%" border="0" align="center">

<form action="RecordSubmitSystem.cfm?ID=<cfoutput>#URL.ID#</cfoutput>" 
      method="POST" 
	  name="entry" 
      id="entry"
	  onSubmit="javascript:check()">

<input type="hidden" 
       name="pass" 
	   id="pass"
	   value="<cfoutput>#client.reportview#</cfoutput>" 
	   required="No" 
	   visible="Yes" 
	   enabled="Yes">

	<tr class="labelmedium">
	<td style="font-size:21px;font-weight:200">Set global Report Variables</font></td>
	</tr>
	<TR class="hide">
		<td width="24%" style="padding-left:20px">No. of horizontal parameter boxes:</td>
		<td><input type="Text" class="regular" style="text-align: center;" name="TemplateBoxes" id="TemplateBoxes" value="1" range="1,4" message="Please define the number of boxes accross" validate="integer" required="Yes" size="1" maxlength="1"></td>
	</tr>	
  	
	<tr><td height="3"></td></tr>
	
	<cfif Find("2", "#CLIENT.reportView#")>
	   <cfset s = "show">
	   <cfset cl = "regular">
	<cfelse>
	   <cfset s = "show">
	   <cfset cl = "regular">
	</cfif>
					
	<tr id="criteria" class="<cfif #Line.TemplateMode# eq 'table'>regular<cfelse>hide</cfif>">
		
	    <td colspan="2" class="regular">
		   <iframe src="#session.root#/System/Modules/Reports/Criteria.cfm?status=0&id=<cfoutput>#URL.ID#</cfoutput>" id="icrit" name="icrit" width="100%" height="100" marginwidth="0" marginheight="0" hspace="0" vspace="0" align="left" frameborder="0"></iframe>
		</td>
		
	</TR>
				
	 <tr><td height="25" align="center" colspan="2">
	    <input class="button10g" type="submit" name="update2" id="update2" value ="Close">	  
	 </td></tr>
	 
</form>	
							
</table>

	
</cfoutput>	
