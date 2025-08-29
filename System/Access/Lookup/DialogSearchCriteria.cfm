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
<CFSET Criteria = ''>

<CF_Search_AppendCriteria
    FieldName="#Form.Crit0_FieldName#"
    FieldType="#Form.Crit0_FieldType#"
    Operator="#Form.Crit0_Operator#"
    Value="#Form.Crit0_Value#">

<CF_Search_AppendCriteria
    FieldName="#Form.Crit1_FieldName#"
    FieldType="#Form.Crit1_FieldType#"
    Operator="#Form.Crit1_Operator#"
    Value="#Form.Crit1_Value#">

<CF_Search_AppendCriteria
    FieldName="#Form.Crit2_FieldName#"
    FieldType="#Form.Crit2_FieldType#"
    Operator="#Form.Crit2_Operator#"
    Value="#Form.Crit2_Value#">

<!--- <CF_Search_AppendCriteria
    FieldName="#Form.Crit3_FieldName#"
    FieldType="#Form.Crit3_FieldType#"
    Operator="#Form.Crit3_Operator#"
    Value="#Form.Crit3_Value#"> --->
	
<CF_Search_AppendCriteria
    FieldName="#Form.Crit4_FieldName#"
    FieldType="#Form.Crit4_FieldType#"
    Operator="#Form.Crit4_Operator#"
    Value="#Form.Crit4_Value#">	
	
<cfset Crit = " Disabled = #Form.Status#">	

<cfif #Criteria# eq "">
    <cfset Criteria = #Crit#>
<cfelse>
    <cfset Criteria = "#Criteria# AND #Crit#">
</cfif>
	
<!--- Query returning search results --->

<cfset CLIENT.search          = #Criteria#>

<cflocation url="DialogResult.cfm?FormName=#Form.FormName#&flduserid=#FORM.flduserid#&fldlastname=#FORM.fldlastname#&fldfirstname=#FORM.fldfirstname#&&fldname=#FORM.fldname#" addtoken="No">
