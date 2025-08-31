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
<cfparam name="attributes.DataSource"  default="AppsMaterials">
<cfparam name="attributes.ItemNo"      default="">
<cfparam name="attributes.UoMFrom"     default="">
<cfparam name="attributes.UoMTo"       default="">

<cfquery name="FromUoM" 
      datasource="#Attributes.DataSource#"  
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">	 
		 SELECT * 
		 FROM   Materials.dbo.ItemUoM 
		 WHERE  ItemNo = '#attributes.ItemNo#'
		 AND    UoM = '#Attributes.UoMFrom#'		 		
</cfquery>

<cfquery name="FromTo" 
     datasource="#Attributes.DataSource#"  
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">	 
		 SELECT * 
		 FROM   Materials.dbo.ItemUoM 
		 WHERE  ItemNo = '#attributes.ItemNo#'
		 AND    UoM = '#Attributes.UoMTo#'		 		
</cfquery>

<cfif FromTo.UoMMultiplier gte "1">
	<cfset caller.UoMMultiplier = FromUoM.UoMMultiplier / FromTo.UoMMultiplier>
<cfelse>
   	<cfset caller.UoMMultiplier = FromUoM.UoMMultiplier>
</cfif>
