<cfparam name="day" default="0">
<cfparam name="URL.ajax" default="No">

<table width="100%" cellspacing="0" cellpadding="0">

<tr><td style="padding-top:8px">
	
<cfoutput>

<cfquery name="Bucket" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  * 
	FROM    FunctionOrganization FO INNER JOIN
            Ref_SubmissionEdition R ON FO.SubmissionEdition = R.SubmissionEdition
	WHERE   FunctionId = '#URL.IDFunction#' 
</cfquery>

<cf_menuscript>
<cfif URL.ajax eq "No">	
	<cf_textareascript>
</cfif>		

<cfparam name="orgunit" default="">

<script language="JavaScript">

function bucketreq() {
	// ColdFusion.navigate('../../Maintenance/FunctionalTitles/FunctionGradeView.cfm?ID=#bucket.functionno#&id1=#bucket.gradedeployment#','detail') 
	ptoken.navigate('../Bucket/BucketProfile/BucketView.cfm?IDFunction=#url.idfunction#','detail') 	
}

function bucketann() {
	ptoken.navigate('#SESSION.root#/Vactrack/Application/Announcement/Announcement.cfm?mode=view&id=#url.idfunction#&header=no','detail')
}

function bucketsrc() {
	ptoken.navigate('FunctionViewLoopSearch.cfm?fileno=#fileNo#','detail')
}

function bucketsta() {
	ptoken.navigate('FunctionViewLoopSearch.cfm?fileno=#fileNo#','detail')
}

</script>

</cfoutput>

<cf_UItree
	id="root"
	title="<span style='font-size:16px;color:gray;padding-bottom:3px'>Bucket Administration</span>"	
	expand="Yes">
   
    <!--- access is limited to the role of roster admin --->
	
	<cfinvoke component="Service.Access"  
			 method="roster" 
			 Owner="#Bucket.Owner#"
			 returnvariable="Access"
			 role="'AdminRoster','CandidateProfile'">
			 
	<cfif Access eq "EDIT" or Access eq "ALL">	 
	
	 <cf_tl id="Configuration" var="vText">
	
	 <cf_UItreeitem value="bck"
		        display="<span style='font-size:17px;padding-top:15px;padding-bottom:15px;font-weight:bold' class='labelit'>#vText#</span>"
				parent="root"								
		        expand="Yes">	  
	   
    <cf_UItreeitem value="prf"
		        display="<span style='font-size:14px' class='labelit'>Bucket Job Profile</span>"
				parent="bck"			
				href="javascript:bucketreq()"							
				target="right"
		        expand="No">	
				
	 <cf_UItreeitem value="ann"
		        display="<span style='font-size:14px' class='labelit'>Announcement Text</span>"
				parent="bck"			
				href="javascript:bucketann()"							
				target="right"
		        expand="No">					
						   
   <cf_UItreeitem value="com"
		        display="<span style='font-size:14px' class='labelit'>Competencies</span>"
				parent="bck"			
				href="javascript:ptoken.navigate('../Bucket/BucketCompetence/RecordListing.cfm?idfunction=#url.idfunction#','detail')"							
				target="right"
		        expand="No">	
	   
	<cf_UItreeitem value="que"
		        display="<span style='font-size:14px' class='labelit'>Questions</span>"
				parent="bck"			
				href="javascript:ptoken.navigate('../Bucket/BucketQuestion/RecordListing.cfm?idfunction=#url.idfunction#','detail')"							
				target="right"
		        expand="No">				
	
	<cf_UItreeitem value="mes"
		        display="<span style='font-size:14px' class='labelit'>Messages</span>"
				parent="bck"			
				href="javascript:ptoken.navigate('../Bucket/BucketMessage/RecordListing.cfm?idfunction=#url.idfunction#','detail')"							
				target="right"
		        expand="No">			
					
	<cf_UItreeitem value="out"
		        display="<span style='font-size:14px' class='labelit'>Outflow Rules</span>"
				parent="bck"			
				href="javascript:ptoken.navigate('../Bucket/BucketOutflow/RecordListing.cfm?idfunction=#url.idfunction#','detail')"							
				target="right"
		        expand="No">				
				
	</cfif>		
	
	<cf_tl id="Candidates" var="vCan">	
	
	<cf_UItreeitem value="can"
		        display="<span style='font-size:17px;padding-top:15px;padding-bottom:15px;font-weight:bold' class='labelit'>#vCan#</span>"
				parent="root"								
		        expand="Yes">	  
	   		
		<cfset denied = 0>
		
		 <!--- relevant combinations --->
		 
		 <cfquery name="getStatus"
			   datasource="AppsSelection"
			   username="#SESSION.login#"
			   password="#SESSION.dbpw#">
				SELECT		*, 
				            (SELECT count(*) 
							 FROM ApplicantFunction
							 WHERE FunctionId = '#Function.FunctionId#'
							 AND   Status = R.Status) as Counted 
				FROM		Ref_StatusCode R 
				WHERE   	R.Id     = 'FUN' 			
				AND         R.Owner  = '#Function.Owner#'		
				ORDER BY 	R.Status
		</cfquery>
      		
		<cfoutput query="getStatus">
				
			<cfset label = meaning>	
			
			<cfquery name="getProcessStatus"         
	         dbtype="query">
			 SELECT * 
			 FROM   SearchResult
			 WHERE  Status = '#Status#'
			</cfquery> 
					   	   
			<cfinvoke component="Service.Access.Roster"  
			   	 method         = "RosterStep" 
			  	 returnvariable = "Access"
				 Owner          = "#Function.Owner#"
			     Status         = "#Status#"				
				 Process        = "Search"			   	
				 FunctionId     = "#Function.FunctionId#">	
								 
				<cfset st=status>				
				
			   	<cfif Access eq "1">
				
				  <cfif status eq "9">
			   
				   <cfloop query="getProcessStatus">
				   				   			   
					   <cfif url.caller eq "Technical clearance only"
						   and status lte "0p">
						   
						   <!--- check if this is still needed --->
						   <cfset expand = "0">
						  
					   <cfelse>
					   
					   	   <cfset expand = "1">						
							
					   </cfif>	
					   						   					   
				   	    <!--- embedded tree for level of denial but only for denails to which the person has access in the
						from [status to denial] --->
					 
						<cfinvoke component = "Service.Access.Roster"  
						   	 method           = "RosterStep" 
						  	 returnvariable   = "Access"
							 Status           = "#ProcessStatus#"
						     StatusTo         = "#Status#"
							 Process          = "Process"
						   	 Owner            = "#Function.Owner#"
							 FunctionId       = "#Function.FunctionId#">																
																										 								 
						    <cfif access eq "1">	
															
								<cfif denied eq "0"> 
								
									<!--- show a tree node with subnotes --->
									
									<cf_UItreeitem value="#st#"
								        display="<span style='font-size:14px' class='labelit'>#Label# <a id='count_#status#'>[#getStatus.counted#]</a></span>"
										parent="can"																			
										target="right"
								        expand="No">								
									
									<cfset denied = 1>
								
								</cfif>
							
							    <cfset myurl = "FunctionViewListing.cfm?tab=detail&owner=#function.owner#&idfunction=#url.idfunction#&process=#access#&expand=#expand#&day=#day#&status=#status#&processstatus=#processstatus#&meaning=#label#&processmeaning=#processmeaning#&orgunit=#orgunit#&total=#total#">
						 
								 <cf_UItreeitem value="#st#_#currentrow#"
								        display="<span style='font-size:13px' class='labelit'>from:#processmeaning#</span>"
										parent="#st#"																			
										target="right"										
										href="javascript:Prosis.busy('yes');_cf_loadingtexthtml='';ptoken.navigate('#myurl#','detail')"
								        expand="No">		
								
							</cfif>								
						 																				
				  </cfloop>	
				  
				  <cfelse>
				  
					  <cfset myurl = "FunctionViewListing.cfm?tab=detail&owner=#function.owner#&idfunction=#url.idfunction#&process=1&expand=1&day=#day#&status=#status#&processstatus=#status#&meaning=#label#&processmeaning=#meaning#&orgunit=#orgunit#&total=5">
					  
					  <cf_UItreeitem value="#st#"
					        display="<span style='font-size:14px' class='labelit' title='#StatusMemo#'>#Label# <a id='count_#status#'>[#getStatus.counted#]</a></span>"
							parent="can"																			
							target="right"
							href="javascript:Prosis.busy('yes');_cf_loadingtexthtml='';ptoken.navigate('#myurl#','detail')"
					        expand="No">	
									
				</cfif>		
				
			 </cfif>								
				
		</cfoutput>		
		
		 <cf_UItreeitem value="src"
		        display="<span style='padding-left:8px;padding-top:5px;font-size:15px;color:purple' class='labelit'>Search</span>"
				parent="can"	
				img="#SESSION.root#/Images/Search-R.png"		
				href="javascript:bucketsrc()"							
				target="right"
		        expand="No">			
				
        <cfinvoke component="Service.Access"  
			   method="roster" 
			   returnvariable="Access"
			   owner="#function.owner#"
			   role="'AdminRoster'">	
		   
		  <cfinvoke component="Service.Access.Roster"  
			   	 method         = "RosterStep" 
			  	 returnvariable = "AccessManual"
			     Status         = "IN"				
			   	 Owner          = "#Function.Owner#"
				 FunctionId     = "#Function.FunctionId#">										   	   
		  		  	   
		  <cfif access eq "EDIT" or access eq "ALL" or accessManual eq "EDIT">					
			   					  
			   <cfif Function.enableManualEntry eq "1">
			  			  
		  	    <cfset myurl = "FunctionViewListing.cfm?tab=detail&box=manual&source=manual&owner=#function.owner#&idfunction=#url.idfunction#&filter=0&total=0">
				
				 <cf_UItreeitem value="src"
			        display="<span style='padding-left:8px;font-size:15px;color:purple' class='labelit'>Manually Recorded</span>"
					parent="can"	
					img="#SESSION.root#/Images/Caret-Right.png"
	                href="javascript:ptoken.navigate('#myurl#','detail')"								
					target="right"
			        expand="No">	
							  	
			   </cfif>					  
				
		  </cfif>
		  
	<cf_UItreeitem value="aut"
        display="<span style='font-size:17px;padding-top:15px;padding-bottom:15px;font-weight:bold' class='labelit'>Authorization Settings</span>"
		parent="root"								
        expand="Yes">	  	  
			
	 <cf_UItreeitem value="delm"
	        display="<span style='font-size:14px;padding-left:8px' class='labelit'>This bucket delegation</span>"
			parent="aut"	
			img="#SESSION.root#/Images/Key.png"
			href="javascript:ptoken.navigate('FunctionViewLoopGrant.cfm?owner=#function.owner#&idfunction=#url.idfunction#&source=manual','detail')"						    				
			target="right"
	        expand="No">		
			
	<cf_UItreeitem value="delr"
	        display="<span style='font-size:14px;padding-left:8px' class='labelit'>Role based delegation</span>"
			parent="aut"	
			img="#SESSION.root#/Images/Key.png"
			href="javascript:ptoken.navigate('FunctionViewLoopGrant.cfm?owner=#function.owner#&idfunction=#url.idfunction#&source=manager','detail')"						
        	target="right"
	        expand="No">						

</cf_UItree>		
	
</td></tr>

</table>		  	
