

<cf_RuleInsert
 Code               = "I17" 
 TriggerGroup       = "TravelClaim" 
 ValidationClass    = "Submission" 
 ValidationContext  = "Claim"
 Description        = "Entered itinerary does not return to the same city" 
 MessagePerson      = "Entered itinerary does not return to the same city" 
 MessageAuditor     = "" 
 Color              = "ffffcf" 
 ValidationPath     = "TravelClaim/Application/Process/ValidationRules" 
 ValidationTemplate = "ValidationRule_I17.cfm" 
 Remarks            = ""
 Operational        = "1">
 
<cf_RuleInsert
 Code               = "A09" 
 TriggerGroup       = "TravelClaim" 
 ValidationClass    = "Fund" 
 ValidationContext  = "Claim"
 Description        = "Non-Obligated lines exceed threshold value" 
 MessagePerson      = "Non-Obligated lines exceed threshold value" 
 MessageAuditor     = "" 
 Color              = "ffffcf" 
 ValidationPath     = "TravelClaim/Application/Process/ValidationRules" 
 ValidationTemplate = "ValidationRule_A09.cfm" 
 Remarks            = ""
 Operational        = "1">


<cf_RuleInsert
 Code               = "I11" 
 TriggerGroup       = "TravelClaim" 
 ValidationClass    = "Submission" 
 ValidationContext  = "Claim"
 Description        = "Verification if the Travel request has been approved" 
 MessagePerson      = "" 
 MessageAuditor     = "" 
 Color              = "ffffcf" 
 ValidationPath     = "TravelClaim/Application/Process/ValidationRules" 
 ValidationTemplate = "ValidationRule_I11.cfm" 
 Remarks            = ""
 Operational        = "1">
 
<cf_RuleInsert
 Code               = "I15" 
 TriggerGroup       = "TravelClaim" 
 ValidationClass    = "Submission" 
 ValidationContext  = "Claim"
 Description        = "Inconsistent Claim Itinerary with Travel Request" 
 MessagePerson      = "Claim cannot be submitted as Itinerary is not consistent with Travel Request" 
 MessageAuditor     = "" 
 Color              = "ffffcf" 
 ValidationPath     = "TravelClaim/Application/Process/ValidationRules" 
 ValidationTemplate = "ValidationRule_I15.cfm" 
 Remarks            = ""
 Operational        = "1"> 
  
<cf_RuleInsert
 Code               = "I16" 
 TriggerGroup       = "TravelClaim" 
 ValidationClass    = "Submission" 
 ValidationContext  = "Claim"
 Description        = "Claim Lines were not been completely mapped to Travel Request Obligated lines" 
 MessagePerson      = "There is a problem with your claim, Please contact your administrator" 
 MessageAuditor     = "" 
 Color              = "ffffcf" 
 ValidationPath     = "TravelClaim/Application/Process/ValidationRules" 
 ValidationTemplate = "ValidationRule_I16.cfm" 
 Remarks            = ""
 Operational        = "1"> 
 
<cf_RuleInsert
 Code               = "I06" 
 TriggerGroup       = "TravelClaim" 
 ValidationClass    = "Initial" 
 ValidationContext  = "Claim"
 Description        = "Travel request has only one ITN/NOC line" 
 MessagePerson      = "There are no reimbursable items.  If you disagree, please contact the Executive/Substantive Office"
 MessageAuditor     = "" 
 Color              = "ffffcf" 
 ValidationPath     = "TravelClaim/Application/Process/ValidationRules" 
 ValidationTemplate = "ValidationRule_I06.cfm" 
 Remarks            = ""
 Operational        = "1"> 
 
 <cf_RuleInsert
 Code               = "R09" 
 TriggerGroup       = "TravelClaim" 
 ValidationClass    = "Rule1" 
 ValidationContext  = "Claim"
 Description        = "TRM not obligated" 
 MessagePerson      = "TRM calculated by the Portal but not Obligated"
 MessageAuditor     = "" 
 Color              = "ffffcf" 
 ValidationPath     = "TravelClaim/Application/Process/ValidationRules" 
 ValidationTemplate = "ValidationRule_R09.cfm" 
 Remarks            = ""
 Operational        = "1"> 
 
 <cf_RuleInsert
 Code               = "R10" 
 TriggerGroup       = "TravelClaim" 
 ValidationClass    = "Rule1" 
 ValidationContext  = "Claim"
 Description        = "Claimant entered remarks" 
 MessagePerson      = "Claimant entered remarks which require review"
 MessageAuditor     = "" 
 Color              = "ffffcf" 
 ValidationPath     = "TravelClaim/Application/Process/ValidationRules" 
 ValidationTemplate = "ValidationRule_R10.cfm" 
 Remarks            = ""
 Operational        = "1"> 
  
<cf_RuleInsert
 Code               = "R12" 
 TriggerGroup       = "TravelClaim" 
 ValidationClass    = "Rule1" 
 ValidationContext  = "Claim"
 Description        = "Claimant selected MSA/HZA elements" 
 MessagePerson      = "You selected MSA and HZA "
 MessageAuditor     = "" 
 Color              = "ffffcf" 
 ValidationPath     = "TravelClaim/Application/Process/ValidationRules" 
 ValidationTemplate = "ValidationRule_R12.cfm" 
 Remarks            = ""
 Operational        = "1"> 
 
 
<cf_RuleInsert
 Code               = "V04" 
 TriggerGroup       = "TravelClaim" 
 ValidationClass    = "Advance" 
 ValidationContext  = "Claim"
 Description        = "Advance Status" 
 MessagePerson      = "Pending advances need prior action"
 MessageAuditor     = "" 
 Color              = "ffffcf" 
 ValidationPath     = "TravelClaim/Application/Process/ValidationRules" 
 ValidationTemplate = "ValidationRule_V04.cfm" 
 Remarks            = ""
 Enforce            = "1"
 Operational        = "1">  