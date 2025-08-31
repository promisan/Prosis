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
<cfquery name="Ripple" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
  
	      SELECT   A.RequirementId,
		           A.ActionStatus,
		  		   I.Code AS ItemMaster, 
		           I.Description AS ItemMasterDescription, 
				   R.Code, 
				   A.RequestQuantity,
				   A.RequestPrice,				 
				   A.TopicValueCode,
				   R.Description, 
				   A.RequestDescription,
				   A.RequestAmountBase as RippleAmount,				  		   		
				   A.OfficerLastName,
				   A.OfficerFirstName,
				   A.Created
		  FROM     ProgramAllotmentRequest A INNER JOIN
		           Purchase.dbo.ItemMaster I ON A.ItemMaster = I.Code INNER JOIN
		           Ref_Object R ON A.ObjectCode = R.Code
		  WHERE    A.RequirementId = '#url.id#' 
	 
</cfquery>	

<form name="rippleform" id="rippleform">
	
	<cfoutput query="Ripple">
		<table style="width:95%" align="center" class="formpadding">
		    <tr class="labelmedium2 line" style="height:30px">
			    <td><cf_tl id="Last updated"></td><td>#ripple.OfficerfirstName# #ripple.OfficerLastName# #dateformat(created,client.dateformatshow)# #timeformat(created,"HH:MM")#</td>
			</tr>
			<tr class="labelmedium2" style="padding-left:14px;height:30px">
			    <td style="width:200px"><cf_tl id="Requirement"></td><td>#ripple.ItemMasterDescription# #ripple.TopicValueCode#</td>
			</tr>
			<tr class="labelmedium2" style="padding-left:14px;height:30px">
			    <td><cf_tl id="Budget Element"></td><td>#ripple.Description#</td>
			</tr>
			<tr class="labelmedium2" style="padding-left:14px;height:30px">
			    <td><cf_tl id="Quantity"></td><td>#ripple.RequestQuantity#</td>
			</tr>
			<tr class="labelmedium2" style="padding-left:14px;">
			    <td><cf_tl id="Price"></td><td><input type="text" style="background-color:ffffcf;width:100px;text-align:right" class="regularxxl" name="Amount" value="#numberFormat(RequestPrice,',.__')#"></td>
			</tr>
			<tr><td colspan="2" class="line"></td></tr>
			
			<tr class="labelmedium2">
			    <td align="center" colspan="2" style="height:35px">
				<cf_tl id="Submit" var="1">  
				<input type="button" class="button10g" value="#lt_text#" onclick="_cf_loadingtexthtml='';ptoken.navigate('RippleEditSubmit.cfm?id=#url.id#','ripple#url.id#','','','POST','rippleform')">
				</td>
			</tr>
		</table>
	</cfoutput>

</form>