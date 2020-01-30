
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
<body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0">

<cf_ActionListingScript>
<cf_FileLibraryScript>

<cfparam name="url.reviewId" default="">
	
<cfoutput>
<script language="JavaScript">

	function review(cde) {
	window.location = "Review/ReviewEntrySubmit.cfm?Owner=#URL.Owner#&Id=#URL.ID#&Id1=#URL.ID1#"
	}
		
	function del(id) {
	if (confirm("Do you want to remove this request ?")) {
		window.location = "Review/ReviewEntryDelete.cfm?Owner=#URL.Owner#&Id=#URL.ID#&Id1=#URL.ID1#&ReviewId="+id
	}
	
	return false
	
	}	
	
	function more(bx) {
 
		icM  = document.getElementById(bx+"Min")
	    icE  = document.getElementById(bx+"Exp")
		se   = document.getElementById("b"+bx);
				 		 
		if (se.className == "hide") {
		   	 icM.className = "regular";
		     icE.className = "hide";
			 se.className  = "regular";				 
		 } else {
		   	 icM.className = "hide";
		     icE.className = "regular";
	    	 se.className  = "hide"
		 }		 		
  }
	
</script>

</cfoutput>

<cfquery name="Topic" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     *
	FROM       Ref_ReviewClass R
	WHERE      R.Code = '#URL.ID1#'
	</cfquery>

	<cfquery name="Review" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     *, 
	           P.Description as PriorityName
	FROM       ApplicantReview I,
			   Ref_ReviewClass R,
			   Ref_Priority P
	WHERE      I.PersonNo     = '#URL.ID#'
	AND        I.Owner        = '#URL.Owner#'
	AND        I.ReviewCode   = R.Code
	AND        I.PriorityCode = P.Code
	AND        R.Code         = '#URL.ID1#'
	ORDER BY   R.Code, I.Created DESC
	</cfquery>
	
	<!--- access owner --->
	
	<cfinvoke component="Service.AccessGlobal"  
	 method="global" 
	 role="AdminRoster" 
	 parameter="#URL.Owner#"
	 returnvariable="Access">	
	 
	 <!--- access reviewer --->	
	 
	<cfinvoke component="Service.Access"  
	 method="CandidateReview" 
	 class="#URL.ID1#"
	 owner="#URL.Owner#"
	 returnvariable="aReview">	 
							
	<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
						 
	<tr><td width="100%" colspan="2">
	
	    <table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">
	
	<cfif URL.Topic neq "All">
	
		<tr class="labelmedium linedotted">
		    <td width="30"></td>
			<td><cf_tl id="Description"></td>
			<td><cf_tl id="Priority"></td>
			<td><cf_tl id="Status"></td>
			<td><cf_tl id="Initiated by"></td>
			<td><cf_tl id="Date"></td>
			<td></td>
		</tr>
				
	</cfif>
	
	<cfoutput>
	<tr>
	    
		<cfif Access eq "EDIT" or Access eq "ALL" or aReview eq "Edit">
		    <td colspan="7" style="padding-left:15px;height:30" class="labelmedium">
			<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/arrowright1.gif" align="absmiddle" alt="" border="0">&nbsp;				
			<a href="javascript:review('#URL.ID1#')">
			<font color="0080C0"><b>
			<u><cf_tl id="Verification of">#Topic.Description#</u></a>
			</td>
		<cfelse>
		   <td class="labelit">#Topic.Description#</td> 	
		   <td colspan="3"></td>
		</cfif>
		
		</td>
					
	</tr>
	</cfoutput>		
							
	<cfoutput query="Review">
		
	<cfset cl = "#listingcolor#">
	<cfif Status eq "1">
		<cfset cl = "CCFFCC">
	<cfelseif status eq "9">
		<cfset cl = "FFC6C6">
	</cfif>
	
	<TR bgcolor="#cl#"  class="linedotted">
		
		<td align="center" style="padding-left:10px" width="20">
		
			<cfset wflink = "#SESSION.root#/Roster/Candidate/Details/Review/ReviewWorkflow.cfm">
			
			<cfif url.reviewid eq reviewid>
			
				<cfset cl = "regular">  
			
			<cfelseif Status eq "0" or Status eq "1" or Status eq "9">
	   	     
				<img src="#SESSION.root#/Images/icon_expand.gif" alt="" 
					id="#currentrow#Exp" border="0" class="show" 
					align="absmiddle" style="cursor: pointer;" 
					onClick="more('#currentrow#');ColdFusion.navigate('#wflink#?ajaxid=#reviewid#','#reviewid#')">
					
					<img src="#SESSION.root#/Images/icon_collapse.gif" 
					id="#currentrow#Min" alt="" border="0" 
					align="absmiddle" class="hide" style="cursor: pointer;" 
					onClick="more('#currentrow#')">
								
				<cfset cl = "hide">
				
			<cfelse>
			
				 <cfset cl = "regular">  						
					     								
			</cfif>	
		</td>
	    <td style="height:20" class="labelit">
		<cfif status eq "0" or Status eq "1" or Status eq "9">
		<a href="javascript:more('#currentrow#');ColdFusion.navigate('#wflink#?ajaxid=#reviewid#','#reviewid#')">
		<font color="0080C0">
		</cfif>
		#Description#</a></td>
		<td class="labelit">#PriorityName#</td>
	    <td class="labelit">
			<cfswitch expression="#Status#">
					<cfcase value="0"><cf_tl id="Pending"></cfcase>
					<cfcase value="9"><font color="FF0000"><cf_tl id="Denied"></font></cfcase>
					<cfcase value="1"><cf_tl id="Cleared"></cfcase>
			</cfswitch>
		</td>
		<td class="labelit">#OfficerFirstName# #OfficerLastName#</td>
		<td class="labelit">#DateFormat(Created, CLIENT.DateFormatShow)#</td>
		<td style="padding-top:1px">
		
		<cfif access eq "ALL" or aReview eq "Edit">
			<cf_img icon="delete"  onClick="del('#ReviewId#')">
		</cfif>
		
		</td>
	
	</tr>
					
	<cfquery name="Detail" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    B.ExperienceCategory, B.ExperienceDescription, B.ExperienceStart, B.ExperienceEnd, B.OrganizationName
	FROM      ApplicantReviewBackground ARB INNER JOIN
                 ApplicantBackground B ON ARB.ExperienceId = B.ExperienceId
	WHERE     ReviewId = '#ReviewId#'		
	</cfquery>	
			
	<cfloop query="Detail">
	<tr bgcolor="F4FBFD" class="labelit">
	<td bgcolor="white"></td>
	<td>#ExperienceDescription#</td>
	<td>#OrganizationName#</td>
	<td colspan="3">#Dateformat(ExperienceStart,CLIENT.DateFormatShow)# - #Dateformat(ExperienceEnd,CLIENT.DateFormatShow)#</td>	
	</tr>	
	</cfloop>		
					
	<tr class="#cl#" id="b#currentrow#"><td colspan="7">
							
		<input type="hidden" 
			   name="workflowlink_#reviewid#" 
			   id="workflowlink_#reviewid#" 			   
			   value="#wflink#">
			   
		<cfif url.reviewid eq reviewid>
					
			  <cfdiv bind = "url:#wflink#?ajaxid=#reviewid#" id = "#reviewid#">	
			   
		<cfelseif Status eq "1" or Status eq "9">
		
			  <cfdiv id = "#reviewid#">	
		
		<cfelse>   
		
			  <cfdiv bind = "url:#wflink#?ajaxid=#reviewid#" id = "#reviewid#">	
			   
		</cfif>	   									
			
	</td></tr>
							
	</cfoutput>
				
	</table>
	</td>
	
	</tr>
	</table>
	
