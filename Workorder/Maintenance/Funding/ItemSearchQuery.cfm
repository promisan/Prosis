
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