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

<cfset actionform = 'Offer'>

<cfparam name="Form.AreaSelect" default="All">  
<cfparam name="Form.ReportName" default=""> 
<cfparam name="Form.DSARate" default="0"> 
<cfparam name="Form.Postadjustment" default="0"> 
<cfparam name="Form.HardshipAllowance" default="0"> 
<cfparam name="Form.RepresentationAllowance" default="0"> 

<cfset amt_DSARate = replace(form.DSARate,',','',"ALL")>
<cfset amt_PostAdjustment = replace(form.PostAdjustment,',','',"ALL")>
<cfset amt_HardshipAllowance = replace(form.HardshipAllowance,',','',"ALL")>
<cfset amt_RepresentationAllowance = replace(form.RepresentationAllowance,',','',"ALL")>

<cfquery name="SearchResult" 
datasource="appsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   stOffer
	WHERE  DocumentNo = '#Object.ObjectKeyValue1#'
	AND    PersonNo   = '#Object.ObjectKeyValue2#'
</cfquery>	

<cfif searchresult.recordcount eq 0> <!--- always create a record --->

	<cfquery name="Insert" 
	datasource="appsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO stOffer
			 (ActionFrom,
			 DocumentNo,
			 PersonNo,	
			 Grade,
			 Step,	  
			 DSARate,
			 Postadjustment,
			 HardshipAllowance,
			 RepresentationAllowance,
			 EntryUserId,
			 EntryLastName,
			 EntryFirstName,	
			 EntryDate,
			 RecruitmentCountry,
			 RecruitmentCity)
	  VALUES ('#actionform#',
			  '#Object.ObjectKeyValue1#', 
			  '#Object.ObjectKeyValue2#',		  
			  '#Form.Grade#',
			  '#Form.Step#', 			  
			  '#amt_DSARate#',
			  '#amt_PostAdjustment#',
			  '#amt_HardshipAllowance#',
			  '#amt_RepresentationAllowance#',			  			  			  
			  '#SESSION.acc#',
			  '#SESSION.last#',		  
			  '#SESSION.first#',
			  getDate(),
			  '#Form.RecruitmentCountry#',
			  '#Form.RecruitmentCity#')</cfquery>
	
<cfelse>

	<cfquery name="Update" 
	datasource="appsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE    stOffer
	  SET     Grade                   = '#Form.Grade#',
	          Step                    = '#Form.Step#',
			  DSARate                 = #amt_DSARate#,  
			  Postadjustment          = #amt_PostAdjustment#,
			  HardshipAllowance       = #amt_HardshipAllowance#,
			  RepresentationAllowance = #amt_RepresentationAllowance#,
			  RecruitmentCountry      = '#Form.RecruitmentCountry#',
			  RecruitmentCity = '#Form.RecruitmentCity#'
	  WHERE   DocumentNo      = '#Object.ObjectKeyValue1#'
		AND   PersonNo        = '#Object.ObjectKeyValue2#'
	</cfquery>
	
</cfif>	
