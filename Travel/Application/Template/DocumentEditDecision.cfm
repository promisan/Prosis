

<cfparam name="ActionStatus" default="9">
<cfparam name="ActionRejectDisabled" default="1">
<cfparam name="ActionRequired" default="1">
<cfparam name="ActionCandidateRevoke" default="0">
<cfparam name="Actionbypassdisabled" default="1">

<cfif #ActionType# eq "Approval">

	    <cfif #ActionStatus# eq "0">
	    <option value="" selected>Pending</option>
		<option value="1">Approve</option>
		<cfelse>
		<option value="1" selected>Approve</option>
		</cfif>
		<cfif #ActionRequired# eq "0">
    		<option value="8">N/A</option>
		</cfif>
    	<cfif #ActionRejectDisabled# eq "0">
    		<option value="6">Not Approved</option>
		</cfif>		
		<cfif #ActionCandidateRevoke# eq "1">
    		<option value="9">Withdraw</option>
		</cfif>	
	
    <cfelseif #ActionType# eq "Clearance">		
		
		<cfif #ActionStatus# eq "0">
	    <option value="" selected>Pending</option>
		<option value="1">Clear</option>
		<cfelse>
		<option value="1" selected>Clear</option>
		</cfif>
		<cfif #ActionRejectDisabled# eq "0">
    		<option value="6">Not cleared</option>
		</cfif>	
		<cfif #ActionRequired# eq "0">
    		<option value="8">N/A</option>
		</cfif>
    	<cfif #ActionCandidateRevoke# eq "1">
    		<option value="9">Withdraw</option>
		</cfif>	
		
  	<cfelse>			
		
	    <!--- <cfif #ActionStatus# eq "0"> --->
	    <option value="" selected>Pending</option>
		<option value="1">Completed</option>
		<!---
    	<cfelse>
		<option value="1" selected>Completed</option>
		</cfif>		--->
		<cfif #ActionRejectDisabled# eq "0">
    		<option value="2">Reset</option>
		</cfif>			
	
		<cfif #ActionByPassDisabled# eq "0">
	 		<option value="7"<cfif #ActionStatus# eq "7">selected></cfif>>In Process</option>
		</cfif>
		<cfif #ActionRequired# eq "0">
    		<option value="8">N/A</option>
		</cfif>
    
		<cfif #ActionCandidateRevoke# eq "1">
    		<option value="9">Withdraw</option>
		<cfelse>
    		<option value="6">No further action</option>	
		</cfif>	
		
	</cfif>	