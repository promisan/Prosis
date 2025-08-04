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
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<!--- End Prosis template framework --->

<cfoutput>

<cfquery name="Requisition" 
 datasource="AppsPurchase" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	SELECT    L.RequisitionNo
	FROM      RequisitionLineQuote L, Job J, RequisitionLine R
	WHERE     J.JobNo = L.JobNo
	AND       R.RequisitionNo = L.RequisitionNo
	AND       R.ActionStatus  = '2k' 
	AND       L.Selected      = 1
	AND       J.Period        = '#URL.Period#'	
	AND       J.Mission       = '#URL.Mission#'
	
	<cfif getAdministrator(url.mission) eq "1">
	
		<!--- no filtering --->
	
	<cfelse>
	
	AND       L.JobNo IN (SELECT JobNo
	                      FROM JobActor 
						  WHERE OfficerUserId = '#SESSION.acc#') 
	</cfif>					  
	
</cfquery>
			
<cfif Requisition.recordcount gt "0">
		
		<tr><td colspan="2" class="linedotted"></td></tr>
		<tr>
		  <td width="4%" align="center"><img src="#SESSION.root#/Images/select4.gif" alt="" border="0"></td>
          <td width="45%" class="labelmedium">
		   <a href="javascript: ProcOrder('#URL.Mission#')"><font color="0080C0"><cf_tl id="Prepare Purchase Order"></b></a></td>
	    </tr>
		
</cfif>

</cfoutput>