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
	<cfquery name="Org" 
	 datasource="AppsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT    *
		 FROM      Organization
		 WHERE     OrgUnit = '#Object.ObjectKeyValue2#'		
	</cfquery>	 
	
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
			
	<cfpdfform action="POPULATE"        
         source="#SESSION.rootPath#\Procurement\Application\Quote\Invitation\TemplateRFQ.pdf"		 
		 destination="#wfrpt#"
         overwrite="yes"
         overwritedata="yes">		
		
		 <cfpdfsubform name="form1">
		 
		    <cfpdfformparam name="JobNo"     value="#Object.ObjectKeyValue1#">		
			<cfpdfformparam name="OrgUnit"   value="#Object.ObjectKeyValue2#">
		 	<cfpdfformparam name="Name"      value="#Address.Contact#">			
			<cfpdfformparam name="Signature" value="#Address.Contact#">	
			<cfpdfformparam name="Fax"       value="#Address.FaxNo#">
			<cfpdfformparam name="eMail"     value="#Address.eMailAddress#">
			<cfpdfformparam name="Telephone" value="#Address.TelephoneNo#">			
		 	<cfpdfformparam name="OrgName"   value="#Org.OrgUnitName#">		 
		    
		    <cfloop query="Lines">
		 		
		 		<cfpdfformparam
				    name="ItemDescription" index="#currentrow#" 
					value="#RequestDescription#">
				
				<cfpdfformparam 
				    name="Quantity" index="#currentrow#"
				    value="#RequestQuantity#">		
					
				<cfpdfformparam 
				    name="UoM" index="#currentrow#"
				    value="#QuantityUoM#">				 		
								
			</cfloop>
		 	  
		 </cfpdfsubform>		 	
	
	</cfpdfform>
		
	


