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
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  label="Task Order Type" 
			  scroll="Yes" 
			  layout="webapp" 
			  jquery="Yes"
			  banner="yellow" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfquery name="Get" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_TaskType
	WHERE  Code = '#URL.ID1#'
</cfquery>

<cfquery name="CountRec" 
      datasource="AppsMaterials" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT 	TaskType
      FROM  	RequestTask
      WHERE 	TaskType  = '#URL.ID1#' 	  
</cfquery>

<cfquery name="AddMission" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	INSERT INTO Ref_TaskTypeMission
	        (Code,Mission,OfficerUserId,OfficerLastName,OfficerFirstName)
	SELECT '#URL.ID1#', Mission, '#SESSION.acc#','#SESSION.last#','#SESSION.first#' 
	FROM 	Ref_ParameterMission
	WHERE   Mission NOT IN (SELECT Mission 
	                        FROM   Ref_TaskTypeMission 
							WHERE  Code = '#URL.ID1#')
</cfquery>

<cfoutput>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this record ?")) {	
	return true 	
	}	
	return false	
}

function editMission(code,mission) {

	var width = 600;
	var height = 250;	
	ProsisUI.createWindow('mydialog', 'Entity', '',{x:30,y:30,height:height,width:width,modal:true,center:true});    				
	ptoken.navigate("MissionEdit.cfm?idmenu=#url.idmenu#&id1=" + code + "&id2=" + mission + "&ts=" + new Date().getTime(),'mydialog'); 
}

function validateFields() {	
	var controlToValidate = document.getElementById('TaskOrderTemplate');	 
	var vReturn = false;
	
	var vMessage = '';
	
	if (controlToValidate.value != "") {
		if (document.getElementById('validatePath').value == 0) { 
			vMessage = vMessage + '[' + controlToValidate.value + '] not validated.\n';
			vReturn = false;
		} else {
			vReturn = true;
		}
	} else {
		vReturn = true;
	}
	
	if (!vReturn) alert(vMessage);
	return vReturn;
	}

</script>

</cfoutput>

<cfajaximport tags="cfform">

<!--- edit form --->

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#" method="POST" name="dialog">

<table width="95%" align="center" class="formpadding">

	<tr><td height="6"></td></tr>
    <cfoutput>
    <TR class="labelmedium2">
    <TD width="20%">Code:</TD>
    <TD>
	   <cfif CountRec.recordcount eq "0">	
		   	<cfinput type="Text" name="Code" value="#get.Code#" message="Please enter a code" required="Yes" size="10" maxlength="10" class="enterastab regularxxl">
	   <cfelse>
	   		#get.Code#
			<input type="hidden" name="Code" id="Code" value="#get.Code#">
	   </cfif>
	   <input type="hidden" name="Codeold" id="Codeold" value="#get.Code#">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Description:</TD>
    <TD>
	   <cfinput type="Text" name="Description" value="#get.Description#" message="Please enter a description" required="Yes" size="30" maxlength="50" class="enterastab regularxxl">
    </TD>
	</TR>
	
	<tr>		
		<td colspan="2">
			<cf_securediv id="divMissions" bind="url:MissionListing.cfm?id1=#url.id1#">
		</td>
	</tr>
			
	</cfoutput>
		
	<tr>
		
	<td align="center" colspan="2" height="40">
	<cfif CountRec.recordcount eq "0">
	<input class="button10g" type="submit" style="width:120" name="Delete" id="Delete" value="Delete" onclick="return ask()">
	</cfif>	
    <input class="button10g" type="submit" style="width:120" name="Update" id="Update" value="Update">
	</td>	
	
	</tr>	
	
</TABLE>

</CFFORM>

<cf_screenbottom layout="webapp">
	