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
<TITLE>Applicant - Update</TITLE>

 <link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
 
<cfset CLIENT.actionClass     = "Update Applicant">
<cfset CLIENT.actionType      = "Submit">
<cfset CLIENT.actionReference = "#CLIENT.AppNo#">
<cfset CLIENT.actionScript    = "">

<cfinclude template="../../Control/RegisterAction.cfm">

<cfif ParameterExists(Form.Update)> 

   <cfset Go = '1'>
  
   <cfif #Form.CandidateStatus# IS "1">
 
   <cfquery name="Verify" 
   datasource="AppsSelection" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	   SELECT ApplicantNo
	   FROM  ApplicantOccGroup
	   WHERE ApplicantNo = '#Form.ApplicantNo#'
	   AND   Status < '9'
   </cfquery>

      <cfif Verify.recordCount is 0 > 
        <cfset Go = '0'>
        <p><p><p><p><p>
        <hr>
        <p align="center">
        <font size="2" color="77C5EA"><cf_tl id="Change status to ASSESSED">
	    <p align="center">
	    <cf_tl id="Operational not allowed as candidate has no Occupational Group defined">
		</font></p>
        <hr>
	    <cfoutput>
        <FORM action="ApplicantDetail.cfm?ID=#URLEncodedFormat(Form.ApplicantNo)#" method="post">
        <INPUT type="submit" value="Edit Applicant">
		</FORM>
	    </cfoutput>
      </cfif>
   </cfif>
   
      <cfif Go is "1">
	  
	  <cfset dateValue = "">
      <CF_DateConvert Value="#Form.DOB#">
      <cfset DOB = #dateValue#>
	     
      <cfquery name="UpdateApplicant" 
      datasource="AppsSelection" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">

			UPDATE   Applicant 
			SET      IndexNo                = '#Form.IndexNo#',
					 LastName               = '#Form.LastName#',
					 FirstName              = '#Form.FirstName#',
					 MiddleName             = '#Form.MiddleName#', 
					 DOB                    = #DOB#,
					 Gender                 = '#Form.Gender#',
					 Nationality            = '#Form.Nationality#',
					 NationalityAdditional  = '#Form.NationalityAdditional#',
					 CandidateStatus        = '#Form.CandidateStatus#',
					 ApplicantClass         = '#Form.ApplicantClass#',
					 eMailAddress           = '#Form.eMailAddress#',
					 MobileNumber           = '#Form.MobileNumber#',
			         Remarks                = '#Form.Remarks#', 
					 Remarks2               = '#Form.Remarks2#',
					 Source                 = '#Form.Source#',
					 Dependants             = '#Form.Dependants#',
					 DocumentReference      = '#Form.DocumentReference#'
			WHERE ApplicantNo = '#CLIENT.AppNo#'

      </cfquery>
	 
       <cflocation addtoken="No" url="ApplicantDetail.cfm?ID=#URLEncodedFormat(CLIENT.AppNo)#">		  
           
    </cfif>

<cfelse>

    <p><p><p><p><p><hr>
    <p align="center">
    <cfoutput>
    <font size="2" color="77C5EA">Do you want to remove #Form.FirstName# #Form.LastName#? </font></p>
    </cfoutput>
    <hr>
    <FORM action="ApplicantRemove.cfm?ID=#URLEncodedFormat(CLIENT.AppNo)#" method="post">
    <input type="submit" name="No" value=" Cancel ">
    <input type="submit" name="Yes" value="    OK    ">
    </FORM>   
</cfif>	
