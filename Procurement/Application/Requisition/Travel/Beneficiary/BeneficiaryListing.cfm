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
<cfquery name="Traveller" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *,
				(SELECT Name FROM System.dbo.Ref_Nation WHERE Code = B.Nationality) as NationalityName
	    FROM  RequisitionLineBeneficiary B
		WHERE RequisitionNo = '#URL.RequisitionNo#'
		ORDER BY LastName, FirstName, birthDate
</cfquery>

 <table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding navigation_table">
				
    <tr class="line labelmedium">
	   <td><cf_tl id="LastName"></td>	
	   <td><cf_tl id="FirstName"></td>	
	   <td width="20%"><cf_tl id="Nationality"></td>
	   <td><cf_tl id="DOB"></td>		   
	   <td><cf_tl id="Passport"></td>					  
	   
	   <td align="right" style="min0width:70px">
	   
	    <cfoutput>
		 <cfif url.access eq "Edit">
		 <!---				 	
		     <A href="javascript:lookupperson('#url.mission#','parent.opener.selectBeneficiary')">[<cf_tl id="add">]</a>
			 --->
			 <A href="javascript:editBeneficiary('')">[<cf_tl id="add">]</a>
		 </cfif>
		 </cfoutput>
	   
	   </td>		   
	 </tr>
	 
	 <cfoutput query="traveller">
	 	<tr class="navigation_row" class="labelmedium line">
			<td style="padding-left:4px">#lastName#</td>
			<td>#firstName#</td>
			<td>#NationalityName#</td>
			<td>#dateformat(birthdate, client.dateformatshow)#</td>
			<td>#reference#</td>
			<td align="right">
				<cfif url.access eq "Edit">
					<table>
						<tr>
							<td><cf_img icon="edit" onclick="editBeneficiary('#beneficiaryId#')"></td>
							<td><cf_img icon="delete" onclick="removeBeneficiary('#beneficiaryId#')"></td>
						</tr>
					</table>				
				 </cfif>
			</td>
		</tr>
	 </cfoutput>
	 
</table>

<cfset AjaxOnLoad("doHighlight")>