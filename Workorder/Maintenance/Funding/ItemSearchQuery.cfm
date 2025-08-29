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
    FieldName="#Form.Crit1_FieldName#"
    FieldType="#Form.Crit1_FieldType#"
    Operator="#Form.Crit1_Operator#"
    Value="#Form.Crit1_Value#">
<!---
<CF_Search_AppendCriteria
    FieldName="#Form.Crit2_FieldName#"
    FieldType="#Form.Crit2_FieldType#"
    Operator="#Form.Crit2_Operator#"
    Value="#Form.Crit2_Value#">
--->	
<CF_Search_AppendCriteria
    FieldName="#Form.Crit3_FieldName#"
    FieldType="#Form.Crit3_FieldType#"
    Operator="#Form.Crit3_Operator#"
    Value="#Form.Crit3_Value#">

<CF_Search_AppendCriteria
    FieldName="#Form.Crit4_FieldName#"
    FieldType="#Form.Crit4_FieldType#"
    Operator="#Form.Crit4_Operator#"
    Value="#Form.Crit4_Value#">
	
<CF_Search_AppendCriteria
    FieldName="#Form.Crit5_FieldName#"
    FieldType="#Form.Crit5_FieldType#"
    Operator="#Form.Crit5_Operator#"
    Value="#Form.Crit5_Value#">
	
<CF_Search_AppendCriteria
    FieldName="#Form.Crit6_FieldName#"
    FieldType="#Form.Crit6_FieldType#"
    Operator="#Form.Crit6_Operator#"
    Value="#Form.Crit6_Value#">
	
<CF_Search_AppendCriteria
    FieldName="#Form.Crit7_FieldName#"
    FieldType="#Form.Crit7_FieldType#"
    Operator="#Form.Crit7_Operator#"
    Value="#Form.Crit7_Value#">
	
<CF_Search_AppendCriteria
    FieldName="#Form.Crit8_FieldName#"
    FieldType="#Form.Crit8_FieldType#"
    Operator="#Form.Crit8_Operator#"
    Value="#Form.Crit8_Value#">
	
<CF_Search_AppendCriteria
    FieldName="#Form.Crit9_FieldName#"
    FieldType="#Form.Crit9_FieldType#"
    Operator="#Form.Crit9_Operator#"
    Value="#Form.Crit9_Value#">
					
	<cfset client.search = criteria>	
			
<cflocation url="RecordListing.cfm?idmenu=#url.idmenu#" addtoken="No">	