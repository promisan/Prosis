
<cfparam name="url.idmenu" default="">

<cf_menuscript>
<cf_ListingScript>
<cf_actionlistingscript>
<cf_dialogPosition>

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Roster Submission Exercise" 			
			  line="no"			 
			  banner="gray" 
			  bannerforce="Yes"
			  jquery="Yes"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfquery name="Get" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM   Ref_SubmissionEdition
WHERE  SubmissionEdition = '#URL.ID1#'
</cfquery>

<cfquery name="Class"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_ExerciseClass
	WHERE ExcerciseClass = '#get.ExerciseClass#'
</cfquery>

<cfquery name="Posttype" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT R.PostType
    FROM  Ref_PostType R
</cfquery>

<cfquery name="OwnerStatus"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
	FROM   Ref_StatusCode
	WHERE  Owner = '#Get.Owner#'
	AND    Id = 'Fun'
	AND    (RosterAction = '1' OR Status = '0')
</cfquery>

<cfif OwnerStatus.recordcount eq "">
		
	<cfquery name="OwnerStatus"
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
		FROM   Ref_StatusCode
		WHERE  Owner = '#Get.Owner#'
		AND    Id = 'Fun'	
	</cfquery>

</cfif>

<cfoutput>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this Code?")) {	
	return true 	
	}	
	return false	
}	
	   
function assreview(postno) {
    ptoken.open("#SESSION.root#/Staffing/Application/Assignment/Review/AssignmentView.cfm?ID1=" + postno + "&Caller=edition", window, "unadorned:yes; edge:raised; status:yes; dialogHeight:799px; dialogWidth:940px; help:no; scroll:yes; center:yes; resizable:yes");	
}

function editeditionposition(pos,edition,idmenu) {		
	ProsisUI.createWindow('EditEditionPosition', 'Edit title', '',{x:100,y:100,height:document.body.clientHeight-80,width:document.body.clientWidth-80,modal:true,center:true,resizable:false});	    						
	ptoken.navigate("#SESSION.root#/Roster/Maintenance/RosterEdition/Position/PositionEditionView.cfm?idmenu="+idmenu+"&positionno="+pos+"&submissionedition="+edition,"EditEditionPosition")	
}

function referenceapply(edition,mission,grade) {
	ptoken.navigate('#SESSION.root#/Roster/Maintenance/RosterEdition/Position/setReference.cfm?op=update&id='+edition+'&mission='+mission+'&grade='+grade,'dresult','', '','POST','fReferences'); 	
}	

</script>

</cfoutput>


<table width="97%" height="100%" align="center">

	<tr><td height="40" style="padding:4px">
				
		<table width="100%" height="100%" align="center">		  		
						
			<cfset ht = "48">
			<cfset wd = "48">
					
			<tr>							
						
				<cf_menutab item       = "1" 					            
				            iconsrc    = "Logos/Staffing/Memo.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#" 
							targetitem = "1"
							class      = "highlight1"
							name       = "About this exercise"
							source     = "">			
							
			    <cf_menutab item       = "2" 
				            iconsrc    = "Logos/Staffing/Position.png" 
							iconwidth  = "#wd#" 
							targetitem = "2"
							iconheight = "#ht#" 								
							name       = "Associated Positions"
							source     = "#session.root#/Roster/Maintenance/RosterEdition/Position/PositionListing.cfm?submissionedition=#URL.ID1#">
				
				<!--- disabled not needed here							
				<cfif Class.TreePublish neq "">									
								
					<cf_menutab item       = "3" 
					            iconsrc    = "Logos/System/eMail.png" 
								iconwidth  = "#wd#" 
								targetitem = "2"
								iconheight = "#ht#" 								
								name       = "Published"
								source     = "#session.root#/Roster/Maintenance/RosterEdition/Recipient/PublishListing.cfm?submissionedition=#URL.ID1#">								
								
				</cfif>		
				--->
																									 		
				</tr>
		</table>
		
		</td>
	</tr>
			
	<tr valign="top"><td>
			
			<table width="100%" 
			      border="0"
				  cellspacing="0" 
				  cellpadding="0" 
				  align="center">	  	 		

					<cf_menucontainer item="1" class="regular">						
					     <cfinclude template="RecordEditForm.cfm">		
					<cf_menucontainer>		
					
					<cf_menucontainer item="2" class="hide"/>	
					
			</table>
			</td>
	</tr>				
	
</table>	

<cf_screenbottom layout="innerbox">
