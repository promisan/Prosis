
<cfset criteria = ''>

<cfif isDefined("Form.Crit5_Value")>	
	<cfset criteria = " I.ItemClass IN (" & PreserveSingleQuotes(Form.Crit5_Value) & ") ">
</cfif>

<cfif isDefined("Form.Crit3_Value")>	
	<cfset criteria = " C.Category IN (" & PreserveSingleQuotes(Form.Crit3_Value) & ") ">
</cfif>

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
    FieldName="#Form.Crit4_FieldName#"
    FieldType="#Form.Crit4_FieldType#"
    Operator="#Form.Crit4_Operator#"
    Value="#Form.Crit4_Value#">
	
<CF_Search_AppendCriteria
    FieldName="#Form.Crit7_FieldName#"
    FieldType="#Form.Crit7_FieldType#"
    Operator="#Form.Crit7_Operator#"
    Value="#Form.Crit7_Value#">

<cfparam name="form.Crit9_Value" default="">		
<cfparam name="form.Crit10_Value" default="">


<cfset client.search = criteria>
	
<cflocation url="ItemSearchResult.cfm?idmenu=#url.idmenu#&used=#URLEncodedFormat(form.Crit9_Value)#&fmission=#URLEncodedFormat(form.Crit6_Value)#&programcode=#URLEncodedFormat(form.Crit10_Value)#" addtoken="No">	