
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
	 
		
	

