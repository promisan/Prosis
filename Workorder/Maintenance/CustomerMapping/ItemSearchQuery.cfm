
<cfparam name="Form.Crit2_Value" default="">
<cfparam name="Form.Crit3_Value" default="">

<CFSET Criteria = ''>

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

<CF_Search_AppendCriteria
    FieldName="#Form.Crit6_FieldName#"
    FieldType="#Form.Crit6_FieldType#"
    Operator="#Form.Crit6_Operator#"
    Value="#Form.Crit6_Value#">
				
	<cfset client.search = criteria>	
			
<cflocation url="RecordListing.cfm?idmenu=#url.idmenu#&getNulls=#Form.Crit5_Value#" addtoken="No">	