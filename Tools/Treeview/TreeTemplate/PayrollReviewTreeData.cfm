
<cfoutput>

['<b>&nbsp;Rate based</b>',null, 

<cfquery name="Group" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT DISTINCT TriggerGroup
  FROM Ref_TriggerGroup
  WHERE TriggerGroup <> 'Insurance'
</cfquery>

<cfloop query = "Group">

  <cfset #Grp# = #Group.TriggerGroup#>
  
  ['#Grp#','ControlListing.cfm?ID=#Grp#&ID1=All&ID2=0',
  
  <cfif #Grp# neq "Contract">
  
  <cfif #Grp# neq "Entitlement">
  
  <cfquery name="Trigger" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM Ref_PayrollTrigger
  WHERE TriggerGroup = '#GRP#' 
  AND Description is not NULL
  </cfquery>
  
  <cfelse>
  
   <cfquery name="Trigger" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM Ref_PayrollTrigger
  WHERE TriggerGroup IN ('Entitlement','Insurance') 
  AND Description is not NULL
  </cfquery>
  
  </cfif>
    
  <cfloop query = "Trigger">
  
  <cfset #Trg# = #Trigger.SalaryTrigger#>
  
  ['#Description#','ControlListing.cfm?ID=#Grp#&ID1=#Trg#&ID2=0',
    
  ['Pending','ControlListing.cfm?ID=#Grp#&ID1=#Trg#&ID2=0'],
  ['Denied','ControlListing.cfm?ID=#Grp#&ID1=#Trg#&ID2=9'],
      
  ],
  
  </cfloop>],
  
  <cfelse>
  
   ['Pending','ControlListing.cfm?ID=#Grp#&ID1=Contract&ID2=0'],
  ['Denied','ControlListing.cfm?ID=#Grp#&ID1=Contract&ID2=9'],
  
  ],
     
  </cfif>
     
  </cfloop>],
  
  ['<b>&nbsp;Individually calculated</b>',null, 
  
  
  ]

  
</cfoutput>


