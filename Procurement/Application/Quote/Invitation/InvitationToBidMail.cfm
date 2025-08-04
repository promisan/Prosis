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

<cfquery name="Lines" 
 datasource="AppsPurchase" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT    *
	 FROM      RequisitionLine
	 WHERE     JobNo = '#Object.ObjectKeyValue1#'
	 AND       ActionStatus NOT IN ('0z','9')
</cfquery>	 

<cfquery name="Param" 
 datasource="AppsPurchase" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT    *
	 FROM      Ref_ParameterMission
	 WHERE     Mission = '#Lines.Mission#'		
</cfquery>	 

<cfquery name="Address" 
 datasource="AppsOrganization" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT    *
	 FROM      vwOrganizationAddress
	 WHERE     OrgUnit = '#Object.ObjectKeyValue2#'		
	 AND       AddressType = '#Param.AddressTypeRFQ#'
</cfquery>	

<!--- request for quotation email ---> 

<cfif isValid("email", Address.eMailAddress)>
	<cfset mailto = "#Address.eMailAddress#">
<cfelse>
    <cfset mailto = "vanpelt@promisan.com">
</cfif>	