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
<cfparam name="Form.EnableCurrency" default="0">
<cfparam name="Form.RequestPurge" default="1">
<cfparam name="Form.RequisitionListingMode" default="0">
<cfparam name="Form.RequisitionCaseNoCheck" default="0">
<cfparam name="Form.EnableRequisitionEditMode1" default="0">
<cfparam name="Form.EnableRequisitionEditMode2" default="0">
<cfparam name="Form.RequestPurge" default="1">
<cfparam name="Form.EnableCurrency" default="0">
<cfparam name="Form.EnableRequisitionEdit" default="0">
<cfparam name="Form.DefaultCurrency" default="">
<cfparam name="Form.ReqTagMode" default="Multiple">
<cfparam name="Form.ReqTagActivity" default="0">

<cfquery name="Update" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE Ref_ParameterMission
	SET   RequisitionPrefix        = '#Form.RequisitionPrefix#',	
	      RequisitionSerialNo      = '#Form.RequisitionSerialNo#', 
		  RequisitionLibrary       = '#Form.RequisitionLibrary#',
		  TemplateEMail            = '#Form.TemplateEMail#',
		  EnableDenyMail           = '#Form.EnableDenyMail#',
		  RequisitionTemplate      = '#Form.RequisitionTemplate#',
		  EnableCaseNo             = '#Form.EnableCaseNo#',
		  EnableDueDate            = '#Form.EnableDueDate#',	
		  EnableCurrency           = '#Form.EnableCurrency#',
		  <cfif Form.DefaultCurrency neq "">
		  DefaultCurrency		   = '#Form.DefaultCurrency#',
		  </cfif>		
		  ItemMasterObject         = '#Form.ItemMasterObject#',
		  RequestPurge             = '#Form.RequestPurge#',
		  EnableRequisitionEdit    = '#Form.EnableRequisitionEdit#',
		  RequisitionTextMode      = '#Form.RequisitionTextMode#',
		  EnableReqTag             = '#Form.EnableReqTag#',
		  ReqTagMode               = '#Form.ReqTagMode#',
		  ReqTagActivity           = '#Form.ReqTagActivity#',
		  RequestDescriptionMode   = '#Form.RequestDescriptionMode#',
		  RequisitionCaseNoCheck   = '#Form.RequisitionCaseNoCheck#',
		  RequisitionListingMode   = '#Form.RequisitionListingMode#',	

		<cfif Form.EnableRequisitionEdit eq "1">
			EnableRequisitionEditMode = '#Form.EnableRequisitionEditMode1#',
		<cfelse>
			EnableRequisitionEditMode = '#Form.EnableRequisitionEditMode2#',
		</cfif>			  

		  EnableBeneficiary        = '#Form.EnableBeneficiary#',
  		  OfficerUserId 	 	   = '#SESSION.ACC#',
		  OfficerLastName  		   = '#SESSION.LAST#',
		  OfficerFirstName 		   = '#SESSION.FIRST#',
		  Created          		   =  getdate()		  	
	WHERE Mission                  = '#url.Mission#' 
</cfquery>

<cfinclude template="ParameterEditRequisition.cfm">

	
