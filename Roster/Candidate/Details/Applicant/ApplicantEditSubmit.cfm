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
 
<cfif ParameterExists(Form.Update)> 

      <cfset Go = '1'>
      
      <cfif Go is "1">
	  
	  <cfset dateValue = "">
      <CF_DateConvert Value="#Form.DOB#">
      <cfset DOB = dateValue>
	  
	  <cfparam name="Form.Nationality"           default="">
	  <cfparam name="Form.NationalityAdditional" default="">
	  <cfparam name="Form.eMailAddress"          default="">
	  <cfparam name="Form.MobileNumber"         default="">
	  <cfparam name="Form.MartitalStatus"        default="Single">
	 	  
	  <cfif form.Nationality eq "">
	  
	  	<cf_message message="You must define a nationality" return="back">
		<cfabort>
	  
	  </cfif>
	  
	   <cfquery name="Pers" 
	   datasource="AppsEmployee" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		   SELECT *
		   FROM  Person
		   WHERE PersonNo = '#Form.EmployeeNo#'   
	   </cfquery>	 
	  
	  <!--- obtain field and compare with Form input --->
	  	  
	  <cfinvoke component     = "Service.Process.System.Database"  
         method               = "getTableFields" 
         datasource           = "AppsSelection"         
         tableName            = "Applicant"
		 frameworkfields      = "Yes"      
		 ignorefields         = ""    
         returnvariable       = "fields">    
		 
	  <cfset i = 0>	  		
	  
	  <cfquery name="getApplicant" 
      datasource="AppsSelection" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
	  	  SELECT *
		  FROM   Applicant
		  WHERE  PersonNo = '#Form.PersonNo#'
	  </cfquery>     
  
	  <cfloop index="itm" list="#fields#">
	  
	      <cftry>
		  
		      <cfset old = Evaluate("getApplicant.#itm#")>
			  <cfset new = Evaluate("Form.#itm#")>			  
			  <cfif old neq new>
			  	<cfset i = i+1>
			  	<cfset ar[i][1] = "#itm#">
				<cfset ar[i][2] = "#old#">
				<cfset ar[i][3] = "#new#">				
			  </cfif>					    
		      <cfcatch></cfcatch>		  
		  </cftry>
	  
	  </cfloop>
	    	  
	  <cfif i gte "1">	 
	    <!--- has discrepancies ---> 
	  	<cf_RosterActionNo ActionRemarks="Amendment" ActionCode="PER" ActionList="#ar#">   					
	  </cfif>				 		
	  
	  <!--- UPDATE master record ---> 
	     
      <cfquery name="UpdateApplicant" 
      datasource="AppsSelection" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
	  
			UPDATE   Applicant 
			SET      LastName               = '#Form.LastName#',
					 LastName2              = '#Form.LastName2#',
					 MaidenName             = '#Form.MaidenName#',
					 FirstName              = '#Form.FirstName#',
					 MiddleName             = '#Form.MiddleName#', 
					 MiddleName2            = '#Form.MiddleName2#', 
					 DOB                    = #DOB#,
					 Gender                 = '#Form.Gender#',
					 Nationality            = '#Form.Nationality#',
					 NationalityAdditional  = '#Form.NationalityAdditional#',				
					 ApplicantClass         = '#Form.ApplicantClass#',
					 eMailAddress           = '#Form.eMailAddress#',
					 MobileNumber           = '#Form.MobileNumber#',
			         Remarks                = '#Form.Remarks#', 
					 Source                 = '#Form.Source#',
					 DocumentReference      = '#Form.DocumentReference#',
					 <cfif Pers.recordcount eq "1">
						 EmployeeNo             = '#Pers.PersonNo#',
						 IndexNo                = '#Pers.IndexNo#',
					 <cfelse>
						 EmployeeNo             = NULL,
						 IndexNo                = NULL,
					 </cfif>
					 MaritalStatus          = '#Form.MaritalStatus#'			 
					 
			WHERE    PersonNo = '#Form.PersonNo#'
		
        </cfquery>
		
		<cfquery name="get" 
      datasource="AppsSelection" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
	  
			SELECT * 
			FROM   Applicant 				 
			WHERE  PersonNo = '#Form.PersonNo#'
		
        </cfquery>
		
		<cf_verifyOperational 
         datasource= "AppsSelection"
         module    = "WorkOrder" 
		 Warning   = "No">
						
		<cfif operational eq "1">
		
			 <!--- patient update --->
	  
	   		 <cfquery name="updatePatientCustomer" 
			     datasource="AppsSelection" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">				 
				 UPDATE   WorkOrder.dbo.Customer
				 SET      CustomerName  = '#get.fullname#', 
				          eMailAddress  = '#Form.eMailAddress#'				 
		         WHERE    PersonNo      = '#Form.PersonNo#'
		     </cfquery>
		  
		 </cfif> 
		 
		 <cf_verifyOperational 
         datasource= "AppsSelection"
         module    = "Warehouse" 
		 Warning   = "No">
						
		 <cfif operational eq "1">		
		 		 
		 	 <!--- customer update --->
	  
	   		 <cfquery name="updatePatientCustomer" 
			     datasource="AppsSelection" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">				 
				 UPDATE   Materials.dbo.Customer
				 SET      CustomerName  = '#get.FullName#', 
				          eMailAddress  = '#Form.eMailAddress#'				 
		         WHERE    PersonNo      = '#Form.PersonNo#'
		     </cfquery>
		  
		 </cfif> 
		 
	</cfif>	 
	 
</cfif>	

<cfoutput>

<script language="JavaScript">
 	parent.refreshheader('#Form.PersonNo#')
	parent.ProsisUI.closeWindow('mydialog',true)
</script>

</cfoutput>
