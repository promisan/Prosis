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
<!--- run a script with ajax upon changing the effective date ----- ---> 
<!--- --------------------------contract edit form effective------- --->
<!--- ------------------------------------------------------------- --->

<cfset selectedDate = ParseDateTime("#url.thisdate#")>
<cfset newMask = dateFormat(selectedDate,'MM-YYYY')>

<cfoutput>
	
	<script language="JavaScript">
		
	effec = document.getElementById("OvertimePeriodEnd").value    
			
		if (effec != '') {
		   document.getElementById('OvertimeDate').value = effec;
		   //document.getElementById('overTimeDateMY').innerHTML = "#newMask#";
		}
		
	</script>
	
	
<cfquery name="Get" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   PersonContract
	WHERE  PersonNo = '#url.personNo#'
	AND    ActionStatus != '9'
	ORDER BY DateEffective DESC
</cfquery>


<cfif get.dateExpiration lt selecteddate>

	<cf_tl id="Attention">:<cf_tl id="There is no valid contract for this person">
	

</cfif>


</cfoutput>
