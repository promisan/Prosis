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

<TITLE>Submit Funding</TITLE>

<cftransaction action="BEGIN">

<cfif Form.Location eq "0">
  <cfset i = "0">
<cfelse>
  <cfset i = "1">
</cfif>

<cfloop index="Lor" from="#i#" to="#FORM.Location#">
      
	<cfloop index="Idc" from="1" to="#FORM.Indicator#">
				
	  <cfparam name="Form.status_#lor#_#idc#"    default="">
	  <cfparam name="Form.location_#lor#_#idc#"  default="">
	  <cfparam name="Form.indicator_#lor#_#idc#" default=""> 
	  <cfparam name="Form.remarks_#lor#_#idc#" default=""> 
	  	
	  <cfset status     = Evaluate("FORM.status_" & #lor# & "_" & #idc#)> 
	  <cfset location   = Evaluate("FORM.location_" & #lor# & "_" & #idc#)>
	  <cfset indicator  = Evaluate("FORM.indicator_" & #lor# & "_" & #idc#)>
	  <!---
	  <cfset date       = Evaluate("FORM.targetdate_" & #lor# & "_" & #idc#)>
	  --->
	  
	  	  	  
	  <cfset remarks    = Evaluate("FORM.remarks_" & #lor# & "_" & #idc#)>
	  
	  <cfif len(remarks) gt "300">
	      <cfset remarks = left(remarks,300)>
	  </cfif>
  
  	  <cfset dateValue = "">
	  
	  <cfif status eq "1">
  
	  <!--- reset prior entry --->
	  <cfquery name="Reset" 
	   datasource="AppsProgram" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   UPDATE ProgramIndicator
	   SET    RecordStatus = '9'
	   WHERE  ProgramCode   = '#URL.ProgramCode#'
	     AND  Period        = '#URL.Period#'
		 AND  LocationCode  = '#Location#'
		 AND  IndicatorCode = '#Indicator#'
	  </cfquery>	
	 	     
      <!--- define value and enter record --->
	 	
	  <cfquery name="Check" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM   ProgramIndicator
		WHERE  ProgramCode  = '#URL.ProgramCode#'
		  AND  Period = '#URL.Period#'
		  AND  LocationCode  = '#Location#'
		  AND  IndicatorCode = '#Indicator#' 
	  </cfquery>	
	  
	  <!---
	  <cfif #date# neq "">
   	   <CF_DateConvert Value="#date#">
       <cfset dte = #dateValue#>
	  <cfelse> 
	   <cfset dte = "NULL"> 
	  </cfif>
	  --->

	  <cfif Check.recordCount eq "1">
		
	     <cfquery name="Update" 
	      datasource="AppsProgram" 
	      username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
	      UPDATE ProgramIndicator
		  SET <!--- TargetDueDate    =  #dte#,  --->
		      Remarks          = '#Remarks#',
			  RecordStatus     = '1',
			  OfficerUserId    = '#SESSION.acc#',
			  OfficerLastName  = '#SESSION.last#',
			  OfficerFirstName = '#SESSION.first#',
	    	  Created = getDate() 
		  WHERE  ProgramCode   = '#URL.ProgramCode#'
			 AND Period        = '#URL.Period#'
			 AND LocationCode  = '#Location#'
			 AND IndicatorCode = '#Indicator#'
	     </cfquery>	
	 
	  <cfelse>	
					
		<cfquery name="Insert" 
	     datasource="AppsProgram" 
	     username=#SESSION.login# 
	     password=#SESSION.dbpw#>
	     INSERT INTO ProgramIndicator  
	       (ProgramCode, Period, IndicatorCode, LocationCode,
		    Remarks, OfficerUserId, OfficerLastName, OfficerFirstName, Created)
	     VALUES 
		   ('#URL.ProgramCode#', '#URL.Period#', '#Indicator#', '#Location#',  
	       '#remarks#', '#SESSION.acc#', '#SESSION.last#', '#SESSION.first#', getDate())		   
	     </cfquery>		
		 
	  </cfif>	
	  
	  <cfquery name="Check" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM   ProgramIndicator I, Ref_Indicator R
		WHERE  ProgramCode  = '#URL.ProgramCode#'
		  AND  Period = '#URL.Period#'
		  AND  LocationCode  = '#Location#'
		  AND  I.IndicatorCode = '#Indicator#' 
		  AND  I.IndicatorCode = R.IndicatorCode
	  </cfquery>		
	
	    		
	  <cfquery name="DELETE" 
      datasource="AppsProgram" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      DELETE FROM ProgramIndicatorTarget
	  WHERE   TargetId IN  (SELECT TargetId
						    FROM   ProgramIndicator
						    WHERE  ProgramCode   = '#URL.ProgramCode#'
						      AND  Period        = '#URL.Period#'
							  AND  LocationCode  = '#Location#'
							  AND  IndicatorCode = '#Indicator#')
	  </cfquery>	
	 	 
	
	  <cfloop index="sub" from="1" to="#FORM.Subperiod#">
	
	    <cfset value      = Evaluate("FORM.TargetValue_" & #lor# & "_" & #idc# & "_" & #sub#)>
		<cfset alternate  = Evaluate("FORM.TargetAlternate_" & #lor# & "_" & #idc# & "_1")>
		
		<cfif value neq "">
			<cfif Check.IndicatorType eq "0002">
			   <cfset value = value/100>
			</cfif>
		</cfif>
		<cfset subP   = Evaluate("FORM.SubPeriod_"   & #lor# & "_" & #idc# & "_" & #sub#)> 
		
		<cfif value eq "">
						
			<cfquery name="Insert" 
		     datasource="AppsProgram" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO ProgramIndicatorTarget  
		            (TargetId, SubPeriod, TargetValue, TargetAlternate) 
		     VALUES ('#Check.TargetId#', '#subP#', NULL,'#alternate#')			
		     </cfquery>		
		 
		 <cfelse>
		 		 
			 <cfquery name="Insert" 
		     datasource="AppsProgram" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO ProgramIndicatorTarget  
		       (TargetId, SubPeriod, TargetValue,TargetAlternate) 
		     VALUES ('#Check.TargetId#', '#subP#', '#value#','#alternate#')
			
		     </cfquery>		
		 
		 </cfif>
		 
	  </cfloop>	 
	  
	  </cfif>
		
	</cfloop>
	 
</cfloop>

</cftransaction>


<cflocation url="TargetView.cfm?ProgramCode=#URLEncodedFormat(URL.ProgramCode)#&Period=#URLEncodedFormat(URL.Period)#" addtoken="No">	


