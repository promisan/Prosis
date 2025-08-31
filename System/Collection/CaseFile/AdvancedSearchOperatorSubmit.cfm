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
<cfparam name = "Form.db"             default = "">
<cfparam name = "Form.ds"             default = "">
<cfparam name = "Form.table"          default = "">
<cfparam name = "Form.class"          default = "">
<cfparam name = "Form.field"          default = "">
<cfparam name = "Form.lvalues"        default = "">
<cfparam name = "Form.operator"       default = "">

<cfparam name = "Form.Condition1"     default = "">
<cfparam name = "Form.Condition2"     default = "">

<cfparam name = "Form.ListDataSource" default = "">	
<cfparam name = "Form.ListCondition"  default = "">	
<cfparam name = "Form.ListTable"      default = "">	
<cfparam name = "Form.ListPk"         default = "">	
<cfparam name = "Form.ListDisplay"    default = "">	

<cfoutput>

<cfif Form.Mode eq "new">
	<cfquery name = "qInsert" datasource = "AppsSystem">
	INSERT INTO CollectionLogCriteria
           (SearchId,
           Layout,
           SearchDatabase,
           SearchDataSource,
		   SearchTable,
           SearchClass,
           SearchField,
           SearchFieldType,
           Operator,
           Condition1,
           Condition2,
           ListValue,
           ListDataSource,
           ListCondition,
           ListTable,
           ListPK,
           ListDisplay)
     VALUES
           ('#Form.searchid#',
           '#form.layout#',
           '#Form.db#',
           '#Form.ds#',
		   '#Form.table#',
           '#Form.class#',
           '#Form.field#',
           '#form.Type#',
           '#Form.operator#',
           '#Form.Condition1#',
           '#Form.Condition2#',
           '#Form.lvalues#',
           '#Form.ListDataSource#',
           '#Form.ListCondition#',
           '#Form.ListTable#',
           '#Form.ListPk#',
           '#Form.ListDisplay#')
	</cfquery>
</cfif>

<script>	
	ColdFusion.navigate ('CaseFile/AdvancedSearchCriteria.cfm?where=#form.where#&class=#form.class#&ds=#form.ds#&db=#form.db#&layout=#form.layout#&table=#form.table#&mode=new&searchid=#form.searchid#','dcriteria_#form.class#');	
</script>

</cfoutput>