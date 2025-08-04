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

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#</cfoutput>/<cfoutput>#client.style#</cfoutput>">

<cftransaction action="begin"> 
	
<cfquery name="Parameter" 
datasource="AppsEPAS" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Parameter
</cfquery>	 

<cfquery name="Training" 
	datasource="AppsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT  T.*, 'Activity' AS Class, '' as DescriptionName, B.ActivityDescription AS Description
	FROM    ContractTraining T INNER JOIN
            ContractActivity B ON T.ContractId = B.ContractId AND T.ActivityId = B.ActivityId 
	WHERE   T.ContractId = '#URL.ContractId#'		
	UNION
    SELECT  T.*, 'Behavior' AS Class, R.BehaviorName AS DescriptionName, B.BehaviorDescription AS Description
	FROM    ContractTraining T INNER JOIN
            ContractBehavior B ON T.ContractId = B.ContractId AND T.BehaviorCode = B.BehaviorCode INNER JOIN
            Ref_Behavior R ON B.BehaviorCode = R.Code
	WHERE   T.ContractId = '#URL.ContractId#'			
	ORDER BY Class, Description		
	</cfquery>

<!--- Tasks --->

<cfloop query="training">

      <cfset rec = "#CurrentRow#">
  
      <cfparam name="Reason" default="">
	  <cfparam name="Descrip" default="">
	  <cfparam name="Target" default="01/01/2000">
	  <cfparam name="Reference" default="">
	  
	  <cfset Reason  = Evaluate("FORM.TrainingReason_" & #Rec#)>
	  <cfset Descrip = Evaluate("FORM.TrainingDescription_" & #Rec#)>
	  <cfset Target  = Evaluate("FORM.TrainingTarget_" & #Rec#)>
	  
	  <CF_DateConvert Value="#Target#">
	  <cfset Target = #dateValue#>
	  
	  <cfset Reference   = Evaluate("FORM.TrainingReference_" & #Rec#)>
	   	 		 		   
	   <cfquery name="UpdateTraining" 
	     datasource="AppsEPAS" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			 UPDATE ContractTraining
			 SET    TrainingReason      = '#Reason#', 
			        TrainingDescription = '#Descrip#',
				    TrainingTarget      = #Target#,
				    TrainingReference   = '#Reference#'
			 WHERE  ContractId          = '#URL.ContractId#'
			 AND    TrainingId          = '#TrainingId#' 
	  </cfquery>
	
</cfloop>

</cftransaction> 

<cfoutput>

<cf_Navigation
	 Alias         = "AppsEPAS"
	 Object        = "Contract"
	 Group         = "Contract"
	 Section       = "#URL.Section#"
	 Id            = "#URL.ContractId#"
	 NextEnable    = "1"
	 NextMode      = "1"
	 OpenDirect    = "1">
	 
</cfoutput>
	 
		
	

