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
<cfsilent>

	<proUsr>administrator</proUsr>
	<proOwn>Dev van Pelt</proOwn>
	<proDes></proDes>
	<proCom></proCom>
	<proCM></proCM>
	<proInfo>
	<table width="100%" cellspacing="0" cellpadding="0">
	<tr><td>
	All information is saved at run time, this screen saves the entered remarks and email address upon changing its values
	</td></tr>
	</table>
	</proInfo>

</cfsilent>

<cfif Len(Form.Remarks) lte 300>
	   
	<cfquery name="Remarks" 
			  datasource="appsTravelClaim" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  UPDATE Claim
			  SET Remarks = '#Form.Remarks#', EMailAddress = '#Form.EMailAddress#'
			  WHERE ClaimId = '#URL.ClaimId#'
	</cfquery>

</cfif>
	