
<cfparam name="url.selection" default="">
<cfparam name="url.menuclass" default="">
<cfparam name="url.isreport"  default="0">

 <cfset att = "border='0' align='absmiddle'">
 
 <cfoutput>
  
 
 		<cfif url.isreport eq "0">

			 <cfif FunctionIcon eq "World">
	             <img src="#client.virtualdir#/Images/world.jpg"  width="30" height="32" #att#>
			 <cfelseif FunctionIcon eq "HowTo">
	             <img src="#client.virtualdir#/Images/HowTo.png"  height="32" #att#>
			 <cfelseif FunctionIcon eq "QuickGuide">
	             <img src="#client.virtualdir#/Images/QuickGuide.png"  height="32" #att#>
			 <cfelseif FunctionIcon eq "Time" >
			     <img src="#client.virtualdir#/Images/timesheet.jpg"   #att#>	
			 <cfelseif FunctionIcon eq "webcast">
			     <img src="#client.virtualdir#/Images/webcast.gif"   #att#>			 	
			 <cfelseif FunctionIcon eq "Help">
			     <img src="#client.virtualdir#/Images/help.png"        #att# height="28" width="28">	
			  <cfelseif FunctionIcon eq "Personal">
			     <img src="#client.virtualdir#/Images/person.gif"      #att#>			 	
			 <cfelseif FunctionIcon eq "Schedule">
			     <img src="#client.virtualdir#/Images/schedule.png"   #att# width="36" height="36">	
			 <cfelseif FunctionIcon eq "Dataset">
			     <img src="#client.virtualdir#/Images/dataset2.png" width="36" height="36"  #att#>		 	
	      	 <cfelseif FunctionIcon eq "Plan">
			     <img src="#client.virtualdir#/Images/timesheet1.jpg"  #att#>	
			 <cfelseif FunctionIcon eq "Review">
			     <img src="#client.virtualdir#/Images/validate.gif"    #att#>
			 <cfelseif FunctionIcon eq "Maintain">			
				<cf_img icon="bullet">
			 <cfelseif FunctionIcon eq "Locate">
	             <img src="#client.virtualdir#/Images/search2.png"  width="36" height="36"  #att#>	
			  <cfelseif FunctionIcon eq "Log">
	             <img src="#client.virtualdir#/Images/Log_icon.png"    #att# width="36" height="36">		 					
			 <cfelseif FunctionIcon eq "Inquiry">
	             <img src="#client.virtualdir#/Images/locate2.png"  width="36" height="36"   #att#>	
			 <cfelseif MenuClass eq "Builder">
	             <img src="#client.virtualdir#/Images/list2.png"  #att#  width="36" height="36">		 
			 <cfelseif FunctionIcon eq "Statistics">
	             <img src="#client.virtualdir#/Images/graph2.gif"      #att#>		
			 <cfelseif FunctionIcon eq "Monitor">
	             <img src="#client.virtualdir#/Images/monitoring2.png" #att# width="36" height="36" >		 
			 <cfelseif FunctionIcon eq "Access">
	             <img src="#client.virtualdir#/Images/access1.gif"     #att#>	
			 <cfelseif FunctionIcon eq "Code">
	             <img src="#client.virtualdir#/Images/sourcecode.gif"  #att#>		 
			 <cfelseif FunctionIcon eq "User">
	             <img src="#client.virtualdir#/Images/access1.gif"     #att#>	
			 <cfelseif FunctionIcon eq "Group">
	             <img src="#client.virtualdir#/Images/group.png"       #att#>	
			 <cfelseif FunctionIcon eq "Role">
	             <img src="#client.virtualdir#/Images/Role_admin.png"  #att# width="36" height="36">	
			 <cfelseif FunctionIcon eq "Tree">
	             <img src="#client.virtualdir#/Images/Tree.gif"        #att#>	
			 <cfelseif FunctionIcon eq "Utility">
	             <img src="#client.virtualdir#/Images/Utility.gif"     #att#>		 
			 <cfelseif FunctionIcon eq "Parameter">
	             <img src="#client.virtualdir#/Images/Setting.png" height="26" width="26" #att#>
			 <cfelseif FunctionIcon eq "Workflow">
			      <img src="#client.virtualdir#/Images/workflow1.gif" height="35" width="35" #att#>	
			 <cfelseif FunctionIcon eq "Manual">
			      <img src="#client.virtualdir#/Images/manual.gif" #att#>	
			 <cfelseif FunctionIcon eq "Manual">
			      <img src="#client.virtualdir#/Images/manual.gif" #att#>	
			 <cfelseif FunctionIcon eq "Attachment">	
	              <img src="#client.virtualdir#/Images/attachment.png" #att#> 		  		  	  
			 <cfelseif FunctionIcon eq "PDF">	
	              <img src="#client.virtualdir#/Images/pdf_adobe.gif" #att#> 	
			 <cfelseif FunctionIcon eq "Report">	
	              <img src="#client.virtualdir#/Images/report_icon.png" #att# width="36" height="36"> 		 
			 <cfelseif FunctionIcon eq "Library">	
	              <img src="#client.virtualdir#/Images/folder4.gif"  #att#> 
			 <cfelseif FunctionIcon eq "Roster">				
			      <img src="#client.virtualdir#/Images/Logos/Roster/Search-Roster.png"  #att# height="37" width="37"> 
	 		 <cfelseif FunctionIcon eq "Dictionary">	
			      <img src="#client.virtualdir#/Images/dictionary.png" align="absmiddle" width="36" height="36" border="0"> 				 	 
			 <cfelseif FunctionIcon eq "Document">	
	              <img src="#client.virtualdir#/Images/info.gif" #att#> 	
			 <cfelseif FunctionIcon eq "List">			 
	              <img src="#client.virtualdir#/Images/list2.png" #att# width="36" height="36"> 	 	 			
			 <cfelseif FunctionIcon eq "Audit">	
	              <img src="#client.virtualdir#/Images/audit.png" #att# width="25" height="25" >
			 <cfelseif FunctionIcon eq "Video">
			 	  <img src="#client.virtualdir#/Images/video.gif" #att#>
			 <cfelse>
				<cf_img icon="bullet">
	          </cfif>
		
		<cfelse>
		
			<!--- Icons for reports --->
			<cfif FunctionIcon eq "PDF">
			     <img src="#client.virtualdir#/Images/report6.gif"   #att# height="26" width="26">
			<cfelseif FunctionIcon eq "Dataset">
			     <img src="#client.virtualdir#/Images/dataset2.gif"   #att# height="26" width="26">
			<cfelseif FunctionIcon eq "Listing">
			     <img src="#client.virtualdir#/Images/list.png"   #att# height="26" width="26">				 
			<cfelse>			
				<img src="#client.virtualdir#/Images/report6.gif"   #att# height="26" width="26">
				
			</cfif>
		
		</cfif>
		  
 
 </cfoutput>