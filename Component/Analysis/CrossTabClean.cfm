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

<cf_compression>

<cfquery name="Report" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT    *     
	FROM      Ref_ReportControlOutput
    WHERE     ControlId = '#URL.ControlId#' 
</cfquery>

<cfquery name="Drop"
	datasource="#Report.Datasource#">	
     if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[vwListing#SESSION.acc#]') 
	 and OBJECTPROPERTY(id, N'IsView') = 1)
     drop view [dbo].[vwListing#SESSION.acc#]
</cfquery>
