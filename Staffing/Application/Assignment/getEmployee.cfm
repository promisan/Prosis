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

<cfparam name="URL.positionno" default="0">
<cfparam name="URL.selected"   default="">
<cfparam name="URL.personno"   default="#url.selected#">

<cfquery name="Position" 
	  datasource="AppsEmployee" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		SELECT     *
		FROM       Position 
		WHERE      PositionNo = '#URL.positionNo#'
</cfquery>

<cfquery name="Person" 
	  datasource="AppsEmployee" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		SELECT     *
		FROM       Person 
		WHERE      PersonNo = '#URL.personNo#'
</cfquery>

<cfoutput>

	<table cellspacing="0" cellpadding="0" height="23" class="formpadding">
		<tr>
		<td>&nbsp;
				
		<input type="hidden" name="name" size="60" maxlength="60" value="#Person.LastName#" readonly>
		
		<input type="hidden" name="personno" value="#URL.personNo#" 
		   class="regular" 
		   size="20" 
		   maxlength="20" 
		   readonly 
		   style="height:25;width:25;text-align: center;">
				
		</td>
		<td class="labelmedium"><a href="javascript:EditPerson('#Person.PersonNo#')"><font color="0080C0">#Person.IndexNo#</a></td>		
		<td style="padding-left:3px" class="labelmedium">#Person.FirstName# #Person.LastName#</td>		
		<td style="padding-left:3px" class="labelmedium"><cfif Person.gender neq "">(#Person.Gender#)</cfif></td>
		</tr>		
	</table>
	
<!--- check the status for the contract --->
	   
<cf_AssignmentContractCheck 
      mission="#position.mission#" 
      mandateno="#position.MandateNo#" 
	  personno="#url.selected#">
	
	<script>
	    ptoken.navigate('EmployeeAssignment.cfm?id=#URL.personNo#&header=0','historybox')
	</script>
		  
<cfif validcontract eq "1">

	<cfif validassignment eq "1">
	
		<script>
			alert("This person already has a recorded contract and assignment. Direct entry of assignment is NOT recommended!")
		</script>
	 
	</cfif>	  
	
</cfif>	

</cfoutput>


   


	