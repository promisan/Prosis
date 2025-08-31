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
<cfquery name="get" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 SELECT    *
	 FROM      Element		
	 WHERE     ElementId = '#key#'			
</cfquery>

<cfquery name="getTopicList" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT    R.*, S.ElementClass
	     FROM      Ref_Topic R INNER JOIN Ref_TopicElementClass S ON R.Code = S.Code
		 WHERE     ElementClass = '#get.elementclass#'	
		 AND       Operational = 1
		 AND       R.TopicClass != 'Person'
		 ORDER BY  S.ListingOrder,R.ListingOrder
</cfquery>

<cfset element          = get.elementid>
<cfset personno         = get.personno>
<cfset elementclass     = get.elementclass>

<cfparam name="colorlabel" default="gray">
<cfparam name="fontsize"   default="2">

<cfinclude template="../Create/ElementViewCustom.cfm">

	