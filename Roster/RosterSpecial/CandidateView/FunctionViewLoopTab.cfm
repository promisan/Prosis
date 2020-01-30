<cfparam name="day" default="0">
<cfparam name="URL.ajax" default="No">

<table width="100%" cellspacing="0" cellpadding="0">

<tr><td style="padding-top:8px">
	
<table width="98%" align="center" cellspacing="0" cellpadding="0" class="formpadding">

<tr><td>	

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
	ColdFusion.navigate('../Bucket/BucketProfile/BucketView.cfm?IDFunction=#url.idfunction#','detail') 	
}

function bucketann() {
	ColdFusion.navigate('#SESSION.root#/Vactrack/Application/Announcement/Announcement.cfm?mode=embed&id=#url.idfunction#&header=no','detail')
}

function bucketsrc() {
	ColdFusion.navigate('FunctionViewLoopSearch.cfm?fileno=#fileNo#','detail')
}

function bucketsta() {
	ColdFusion.navigate('FunctionViewLoopSearch.cfm?fileno=#fileNo#','detail')
}

</script>

</cfoutput>

<cfform>

<cftree name="root"
   font="-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif,'Raleway',sans-serif !important"
   fontsize="13"		
   bold="No"   
   format="html"    
   required="No"> 
   
    <!--- access is limited to the role of roster admin --->
	
	<cfinvoke component="Service.Access"  
			 method="roster" 
			 Owner="#Bucket.Owner#"
			 returnvariable="Access"
			 role="'AdminRoster','CandidateProfile'">
			 
	<cfif Access eq "EDIT" or Access eq "ALL">	 
	   
   	<cftreeitem value="bck"
        display="<span style='font-size:18px' class='labelit'>Bucket Configuration</span>"
		parent="Root"							
        expand="Yes">	
		   
   	<cftreeitem value="req"
	        display="<span class='labelmedium'>Job Profile</span>"
			parent="bck"				
			href="javascript:bucketreq()"						
	        expand="Yes">	
	   
	<cftreeitem value="vac"
	        display="<span class='labelmedium'>Announcement</span>"
			parent="bck"				
			href="javascript:bucketann()"						
	        expand="Yes">	
			
	<cftreeitem value="co"
	        display="<span class='labelmedium'>Competencies</span>"
			parent="bck"				
			href="javascript:ColdFusion.navigate('../Bucket/BucketCompetence/RecordListing.cfm?idfunction=#url.idfunction#','detail')"						
	        expand="Yes">	
			
	<cftreeitem value="que"
	        display="<span class='labelmedium'>Questions</span>"
			parent="bck"					
			href="javascript:ColdFusion.navigate('../Bucket/BucketQuestion/RecordListing.cfm?idfunction=#url.idfunction#','detail')"						
	        expand="Yes">	
			
	<cftreeitem value="mes"
	        display="<span class='labelmedium'>Messages</span>"
			parent="bck"				
			href="javascript:ColdFusion.navigate('../Bucket/BucketMessage/RecordListing.cfm?idfunction=#url.idfunction#','detail')"						
	        expand="Yes">						
			
	<cftreeitem value="out"
	        display="<span class='labelmedium'>Outflow Rules</span>"
			parent="bck"				
			href="javascript:ColdFusion.navigate('../Bucket/BucketOutflow/RecordListing.cfm?idfunction=#url.idfunction#','detail')"						
	        expand="Yes">					
	
	<cftreeitem value="dummy"
	        display=""
			parent="Root">	
			
	</cfif>			
					
	<cftreeitem value="can"
        display="<span style='padding-bottom:8px;font-size:18px'>Candidates</span>"
		parent="Root"							
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
							 
									<cftreeitem value="#st#"
								        display="<span class='labelmedium'><font color='FF0000'>#Label#</font> <a id='count_#status#'>[#getStatus.counted#]</a>"
										parent="can"																							
								        expand="yes">	
									
									<cfset denied = 1>
								
								</cfif>
							
							    <cfset myurl = "FunctionViewListing.cfm?tab=detail&owner=#function.owner#&idfunction=#url.idfunction#&process=#access#&expand=#expand#&day=#day#&status=#status#&processstatus=#processstatus#&meaning=#label#&processmeaning=#processmeaning#&orgunit=#orgunit#&total=#total#">
						 
								<cftreeitem value="#st#_#currentrow#"
							        display="<span class='labelmedium'>from:<font color='FF0000'>#processmeaning#"
									parent="#st#"	
									href="javascript:Prosis.busy('yes');_cf_loadingtexthtml='';ptoken.navigate('#myurl#','detail')">		
							
							</cfif>								
						 																				
				  </cfloop>	
				  
				  <cfelse>
				  
					  <cfset myurl = "FunctionViewListing.cfm?tab=detail&owner=#function.owner#&idfunction=#url.idfunction#&process=1&expand=1&day=#day#&status=#status#&processstatus=#status#&meaning=#label#&processmeaning=#meaning#&orgunit=#orgunit#&total=5">
							
				   		<cftreeitem value="#st#"
					        display="<span class='labelmedium'>#label# <a id='count_#status#'>[#counted#]</a>"
							parent="can"	
							href="javascript:Prosis.busy('yes');_cf_loadingtexthtml='';ptoken.navigate('#myurl#','detail')"
					        expand="Yes">	
				
				</cfif>		
				
			 </cfif>								
				
		</cfoutput>		
		
		<cftreeitem value="dummy"
	        display=""
			parent="can">	
	
		<cftreeitem value="src"
	        display="<span class='labelmedium'>Search</b>"
			href="javascript:bucketsrc()"
			img="#SESSION.root#/Images/Search-R.png"
			parent="can"							
	        expand="Yes">	
		
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
				
				<cftreeitem value="manual"
			        display="<span class='labelmedium'>Manually Recorded</b>"
					parent="can"	
					img="#SESSION.root#/Images/Caret-Right.png"
                    href="javascript:ColdFusion.navigate('#myurl#','detail')"						
		    	    expand="Yes">
			  	
			   </cfif>					  
				
		  </cfif>
		  
	  <cftreeitem value="dummy"
	        display=""
			parent="Root">	
				  
	<cftreeitem value="aut"
        display="<span style='font-size: 16px;position: relative;top: 4px;' class='labellarge'><b>Authorization Settings</span>"
		parent="Root"							
        expand="Yes">			
		<style>
            #ygtvc19{
                position: relative;
                top: 5px;
            }
        </style>
	<cftreeitem value="delm"
        display="This bucket delegation"
		parent="aut"	
		img="#SESSION.root#/Images/Key.png"
		href="javascript:ColdFusion.navigate('FunctionViewLoopGrant.cfm?owner=#function.owner#&idfunction=#url.idfunction#&source=manual','detail')"						
        expand="Yes">			
		
		<cftreeitem value="deli"
        display="Role based delegation"
		parent="aut"	
		img="#SESSION.root#/Images/Key.png"
		href="javascript:ColdFusion.navigate('FunctionViewLoopGrant.cfm?owner=#function.owner#&idfunction=#url.idfunction#&source=manager','detail')"						
        expand="Yes">					
			 

</cftree>

</cfform>

</td></tr>

</table>		  	

</td></tr>

</table>
