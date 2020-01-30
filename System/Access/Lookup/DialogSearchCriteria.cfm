
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
