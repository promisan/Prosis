
<cfparam name="Form.Class" default="">
<cfparam name="Form.Roster" default="">
<cfparam name="Form.Filter" default="">
<cfparam name="Form.Assessment" default="">

<CFSET Criteria = ''>

	<cfparam name="Form.Crit2_Value" default="">

	<cfif Form.Crit2_Value neq "">
		<CF_Search_AppendCriteria
		    FieldName="#Form.Crit2_FieldName#"
		    FieldType="#Form.Crit2_FieldType#"
		    Operator="#Form.Crit2_Operator#"
		    Value="#Rtrim(LTrim(Form.Crit2_Value))#">
	</cfif>		
	
	<cfif form.class eq "4">
	
		<cfif Form.Crit2a_Value neq "">
		<CF_Search_AppendCriteria
		    FieldName="#Form.Crit2a_FieldName#"
		    FieldType="#Form.Crit2a_FieldType#"
		    Operator="#Form.Crit2a_Operator#"
		    Value="#Rtrim(LTrim(Form.Crit2a_Value))#">
		</cfif>		
	
	</cfif>
	
	<cfparam name="Form.Crit3_Value" default="">
	
	<cfif Form.Crit3_Value neq "">
		<CF_Search_AppendCriteria
		    FieldName="#Form.Crit3_FieldName#"
		    FieldType="#Form.Crit3_FieldType#"
		    Operator="#Form.Crit3_Operator#"
		    Value="#Rtrim(LTrim(Form.Crit3_Value))#">
	</cfif>
	
	<cfparam name="Form.Crit4_Value" default="">
	
	<cfif Form.Crit4_Value neq "">		
		<CF_Search_AppendCriteria
		    FieldName="#Form.Crit4_FieldName#"
		    FieldType="#Form.Crit4_FieldType#"
		    Operator="#Form.Crit4_Operator#"
		    Value="#Form.Crit4_Value#">	
	</cfif>
	
	<cfparam name="Form.Crit5_Value" default="">
	
	<cfif Form.Crit5_Value neq "">			
		<CF_Search_AppendCriteria
		    FieldName="#Form.Crit5_FieldName#"
		    FieldType="#Form.Crit5_FieldType#"
		    Operator="#Form.Crit5_Operator#"
		    Value="#Form.Crit5_Value#">	
	</cfif>		
	
	<cfparam name="Form.Crit5a_Value" default="">
	
	<cfif Form.Crit5a_Value neq "">			
		<CF_Search_AppendCriteria
		    FieldName="#Form.Crit5a_FieldName#"
		    FieldType="#Form.Crit5a_FieldType#"
		    Operator="#Form.Crit5a_Operator#"
		    Value="#Form.Crit5a_Value#">	
	</cfif>						
	
	<cfparam name="Form.Crit6_Value" default="">
	
	<cfif Form.Crit6_Value neq "">			
		<CF_Search_AppendCriteria
		    FieldName="#Form.Crit6_FieldName#"
		    FieldType="#Form.Crit6_FieldType#"
		    Operator="#Form.Crit6_Operator#"
		    Value="#Form.Crit6_Value#">	
	</cfif>		
	
	<cfparam name="Form.Crit7_Value" default="">
		
	<cfif Form.Crit7_Value neq "">			
		<CF_Search_AppendCriteria
		    FieldName="#Form.Crit7_FieldName#"
		    FieldType="#Form.Crit7_FieldType#"
		    Operator="#Form.Crit7_Operator#"
		    Value="#Rtrim(LTrim(Form.Crit7_Value))#">		
	</cfif>
	
	<cfparam name="Form.Crit8_Value" default="">
	
	<cfif Form.Crit8_Value neq "">			
		<CF_Search_AppendCriteria
		    FieldName="#Form.Crit8_FieldName#"
		    FieldType="#Form.Crit8_FieldType#"
		    Operator="#Form.Crit8_Operator#"
		    Value="#Rtrim(LTrim(Form.Crit8_Value))#">		
	</cfif>								

<!--- Query returning search results --->

<cfoutput>

<cfif Criteria neq "">
  	<cfset Criteria = " AND #Criteria#">
</cfif>

<cfif Form.Class neq "">
    <CFSET Criteria = Criteria&" AND A.ApplicantClass = '#Form.class#'">
</cfif> 


<cfif Form.Assessment eq "1">
    <CFSET Criteria = Criteria&" AND A.PersonNo IN (SELECT DISTINCT A.PersonNo FROM ApplicantAssessment A INNER JOIN ApplicantAssessmentDetail Ad ON A.AssessmentId = Ad.AssessmentId)">
<cfelseif Form.Assessment eq "0">
    <CFSET Criteria = Criteria&" AND A.PersonNo NOT IN (SELECT DISTINCT A.PersonNo FROM ApplicantAssessment A INNER JOIN ApplicantAssessmentDetail Ad ON A.AssessmentId = Ad.AssessmentId)">
</cfif> 

<cfif Form.Roster eq "">

<cfelseif Form.Roster eq "1">

    <CFSET Criteria = #Criteria#&" AND B.ApplicantNo IN (SELECT ApplicantNo FROM ApplicantFunction WHERE Status IN ('1','2','3'))">
	
<cfelse>	

	<CFSET Criteria = #Criteria#&" AND B.ApplicantNo IN (SELECT ApplicantNo FROM ApplicantFunction F, FunctionOrganization F1 WHERE F1.FunctionId = F.FunctionId AND F1.SubmissionEdition = '#Form.Roster#' AND F.Status IN ('1','2','3'))">
	
</cfif> 

<cfif Form.Filter neq "">
    <CFSET Criteria = Criteria&" AND B.ApplicantNo IN (SELECT ApplicantNo FROM ApplicantFunctionAction F, RosterAction A WHERE F.RosterActionNo = A.RosterActionNo AND A.OfficerUserId = '#SESSION.acc#' AND F.Status IN ('1','2','3'))">
</cfif> 

</cfoutput>
	
<!--- Query returning search results --->

<cfset CLIENT.FilterCan       = Criteria>
