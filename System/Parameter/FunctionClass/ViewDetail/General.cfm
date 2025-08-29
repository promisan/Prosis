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
<cfquery name="QClassFunction" 
		datasource="AppsControl" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     *
		FROM ClassFunction
		Where ClassFunctionId='#URL.ID#'
</cfquery>
	

<cfquery name="QClass" 
datasource="AppsControl" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT     *
FROM Class
order by ListingOrder
</cfquery>

<cfquery name="QType" 
datasource="AppsControl" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     Code,Name,Description
	FROM Ref_FunctionType
	Order by ListingOrder
</cfquery>

<cfoutput>


<cfform action="" method="post" name="header">

<input type="hidden" name="ClassFunctionId" id="ClassFunctionId" value="#URL.ID#">

<table width="99%" height="100%" align="center" border="0" bordercolor="silver" cellspacing="0" cellpadding="0" class="formpadding">

<tr>
<td colspan="2" align="center" height="10">
<input type="submit" name="Btn_Save" id="Btn_Save" class="button10g" value="Save" onclick="javascript:save_general()">
</td>
</tr>

<tr><td colspan="2" height="1" bgcolor="silver"></td></tr>

<tr height="23">
	<td width="140">Class</td>
	<td width="80%">
			<select name="ClassId" id="ClassId" required="Yes">
  				  <cfloop query="QClass">
				  <cfoutput>
				  <option value="#QClass.ClassId#" <cfif #QClass.ClassId# eq #QClassFunction.ClassId#>  SELECTED </cfif> >
						  #QClass.ClassDescription#
				  </option>
				  </cfoutput>	 
				  </cfloop>
			</select>		
	</td>
</tr>
<tr height="23">
	<td width="140">Type</td>
	<td width="80%">
			<select name="TypeId" id="TypeId" required="Yes">
  				  <cfloop query="QType">
				  <cfoutput>
				  <option value="#QType.Code#" <cfif #QType.Code# eq #QClassFunction.ClassFunctionType#>  SELECTED </cfif> >
						  #QType.Name#
				  </option>
				  </cfoutput>	 
				  </cfloop>
			</select>		
	</td>
</tr>

<tr height="23">
	<td width="140">UseCase ID</td>
	<td><input type="text" name="ClassfunctionCode" id="ClassfunctionCode" size="20" maxlength="20" class="regular" value="#trim(QClassFunction.ClassfunctionCode)#"></td>
</tr>
<tr>
	<td height="23" width="140">Name</td>
	<td><input type="text" name="FunctionDescription" id="FunctionDescription" size="100" maxlength="100" class="regular" value="#trim(QClassFunction.FunctionDescription)#"></td>
</tr>
<tr>
	<td colspan="2" style="border: 1px solid Silver;">
						 			
			  <cf_textarea 
		  		 name="FunctionReference" 						 
				 toolBar="Basic" 	
				 tooltip="Comments,Relevant Information"			 
				 richtext="true" 
				 skin="silver">#trim(QClassFunction.FunctionReference)#</cf_textarea>	
			 </td>
			
</tr>

</table>
</cfform>


</cfoutput>
