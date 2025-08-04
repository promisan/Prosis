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

<cfparam name="Form.Select" default="">

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">


<cfif Form.Select neq "">


	<cfquery name="PK" 
	  datasource="AppsSystem" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT * 
	  FROM  Ref_ReportControlCriteria
	  WHERE ControlId = '#URL.ControlId#'
	  AND   CriteriaName = '#URL.CriteriaName#'  
	 </cfquery>
	 
	 <cfquery name="Fields" 
	  datasource="AppsSystem" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT *
	  FROM  Ref_ReportControlCriteriaField 
	  WHERE ControlId = '#URL.ControlId#'
	  AND   CriteriaName = '#URL.CriteriaName#'
	  AND   Operational = '1'
	  ORDER BY FieldOrder
	 </cfquery>
	 
	 <cfquery name="Table" 
	  datasource="#PK.LookupDataSource#" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  INSERT INTO userQuery.dbo.#SESSION.acc#_crit_#URL.CriteriaName#
	  SELECT DISTINCT <cfoutput query="Fields">#Fields.FieldName#,</cfoutput>
	   <cfif PK.LookupFieldDisplay neq "">
		    #PK.LookupFieldDisplay# as Display, 
		   <cfelse>
		    #PK.LookupFieldValue# as Display,	
	  </cfif>	
	             #PK.LookupFieldValue# as PK
	  FROM  #PK.LookupTable# 
	  WHERE #PK.LookupFieldValue# IN (#preserveSingleQuotes(Form.Select)#)  	  <!---
	  AND #PK.LookupFieldValue# NOT IN (SELECT DISTINCT #PK.LookupFieldValue# FROM userQuery.dbo.#SESSION.acc#_crit_#CriteriaName#)
	  --->
	 </cfquery>	 
		  
</cfif> 

<cfset CLIENT.extendedInit = "0">

 <cfoutput>
 <script language="JavaScript">   
    parent.ColdFusion.navigate('HTML/FormHTMLExtList.cfm?mult=1&Init=0&row=#url.row#&ControlID=#url.controlid#&ReportId=#url.reportid#&CriteriaName=#url.criteriaName#','i#url.row#')		
    parent.ProsisUI.closeWindow('myextension',true)	
 </script> 
 </cfoutput>