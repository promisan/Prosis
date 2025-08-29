<!--
    Copyright © 2025 Promisan B.V.

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
<cfparam name="url.selection" default="">
<cfparam name="url.menuclass" default="">
<cfparam name="url.isreport"  default="0">

 <cfset att = "border='0' align='absmiddle'">
 
 <cfoutput>
   
 		<cfif url.isreport eq "0">
		
		    <table><tr><td style="padding:5px">
		    <table>
			<tr>
			<td align="center" style="border-radius:6px;height:40px;min-width:40px;padding:3px;background-color:##B0D8FF50">
			
			<!---
						
			 <cfif FunctionIcon eq "World">
	             <img src="#client.virtualdir#/Images/world.jpg"       width="34" height="34" #att#>
			 <cfelseif FunctionIcon eq "HowTo">
	             <img src="#client.virtualdir#/Images/manual.png"      height="34" width="34" #att#>
			 <cfelseif FunctionIcon eq "QuickGuide">
	             <img src="#client.virtualdir#/Images/QuickGuide.png"  height="34" width="34" #att#>
			 <cfelseif FunctionIcon eq "Time" >
			     <img src="#client.virtualdir#/Images/timesheet.jpg"   height="34" width="34" #att#>	
			 <cfelseif FunctionIcon eq "webcast">
			     <img src="#client.virtualdir#/Images/webcast.gif"     height="34" width="34" #att#>			 	
			 <cfelseif FunctionIcon eq "Help">
			     <img src="#client.virtualdir#/Images/help.png"        height="28" width="28" #att#>	
			  <cfelseif FunctionIcon eq "Personal">
			     <img src="#client.virtualdir#/Images/person.gif"      height="34" width="34" #att#>			 	
			 <cfelseif FunctionIcon eq "Schedule">
			     <img src="#client.virtualdir#/Images/schedule.png"    width="35" height="35" #att#>					 	
	      	 <cfelseif FunctionIcon eq "Plan">
			     <img src="#client.virtualdir#/Images/timesheet1.jpg"  #att#>	
			 <cfelseif FunctionIcon eq "Review">
			     <img src="#client.virtualdir#/Images/validate.gif"    #att#>
			 <cfelseif FunctionIcon eq "Maintain">			
				<cf_img icon="bullet">
			 <cfelseif FunctionIcon eq "Locate">
	             <img src="#client.virtualdir#/Images/search2.png"     width="36" height="36" #att#>	
			  <cfelseif FunctionIcon eq "Log">
	             <img src="#client.virtualdir#/Images/Log_icon.png"    width="36" height="36" #att#>		 					
			 <cfelseif FunctionIcon eq "Inquiry">
	             <img src="#client.virtualdir#/Images/locate2.png"     width="36" height="36" #att#>	
			 <cfelseif MenuClass eq "Builder">
	             <img src="#SESSION.root#/Images/logos/listing.png"    width="36" height="36" #att#>		 
			 <cfelseif FunctionIcon eq "Statistics">
	             <img src="#client.virtualdir#/Images/graph2.gif"      width="36" height="36" #att#>		
			 <cfelseif FunctionIcon eq "Monitor">
	             <img src="#client.virtualdir#/Images/monitoring2.png" #att# width="36" height="36" >		 
			 <cfelseif FunctionIcon eq "Access">
	             <img src="#client.virtualdir#/Images/access1.gif"     #att# height="34" width="34" #att#>	
			 <cfelseif FunctionIcon eq "Code">
	             <img src="#client.virtualdir#/Images/sourcecode.gif"  #att# height="34" width="34" #att#>		 
			 <cfelseif FunctionIcon eq "User">
	             <img src="#client.virtualdir#/Images/access1.gif"     #att# height="34" width="34" #att#>	
			 <cfelseif FunctionIcon eq "Group">
	             <img src="#client.virtualdir#/Images/group.png"       #att# height="34" width="34" #att#>	
			 <cfelseif FunctionIcon eq "Role">
	             <img src="#client.virtualdir#/Images/Role_admin.png"  #att# width="36" height="36">	
			 <cfelseif FunctionIcon eq "Tree">
	             <img src="#client.virtualdir#/Images/Tree.png"        #att# height="34" width="34" #att#>	
			 <cfelseif FunctionIcon eq "Utility">
	             <img src="#client.virtualdir#/Images/Utility.gif"     #att#>		 
			 <cfelseif FunctionIcon eq "Parameter">
	             <img src="#client.virtualdir#/Images/Setting.png" height="26" width="26" #att#>
			 <cfelseif FunctionIcon eq "Workflow">
			      <img src="#client.virtualdir#/Images/Logos/User/WorkFlow.png" height="34" width="34" #att#>				
			 <cfelseif FunctionIcon eq "Manual">
			      <img src="#client.virtualdir#/Images/manual.png" #att# height="34" width="34" #att#>	
			 <cfelseif FunctionIcon eq "Attachment">	
	              <img src="#client.virtualdir#/Images/attachment.png" #att#> 		  		  	  
			 <cfelseif FunctionIcon eq "PDF">	
	              <img src="#client.virtualdir#/Images/pdf_adobe.gif" #att#> 	
			 <cfelseif FunctionIcon eq "Report">				 
	              <img src="#SESSION.root#/Images/logos/system/reports.png" #att# width="35" height="35"> 		 
			 <cfelseif FunctionIcon eq "Library">	
	              <img src="#client.virtualdir#/Images/folder4.gif"  #att#> 
			 <cfelseif FunctionIcon eq "Roster">				
			      <img src="#client.virtualdir#/Images/Logos/Roster/Search-Roster.png"  #att# height="32" width="32"> 
	 		 <cfelseif FunctionIcon eq "Dictionary">	
			      <img src="#client.virtualdir#/Images/dictionary.png" align="absmiddle" width="32" height="32" border="0"> 				 	 
			 <cfelseif FunctionIcon eq "Document">	
	              <img src="#client.virtualdir#/Images/info.gif" #att#> 	
			 <cfelseif FunctionIcon eq "List">			 
	              <img src="#client.virtualdir#/Images/logos/listing.png" #att# width="38" height="36"> 	 	 			
			 <cfelseif FunctionIcon eq "Audit">	
	              <img src="#client.virtualdir#/Images/audit.png?8" #att# width="31" height="31">				  
			 <cfelseif FunctionIcon eq "Video">
			 	  <img src="#client.virtualdir#/Images/video.gif" #att#>
			 <cfelseif FunctionIcon eq "Dataset">			 
			     <img src="#client.virtualdir#/Images/dataset.png"   #att# height="34" width="34">	  
			 <cfelse>
				<cf_img icon="bullet">
	          </cfif>
			  
			  --->
			  
			 <cfif FunctionIcon eq "HowTo">
	             <img src="#client.virtualdir#/Images/manual.png"      height="34" width="34" #att#>
			 <cfelseif FunctionIcon eq "Time" >
			     <img src="#client.virtualdir#/Images/timesheet.jpg"   height="34" width="34" #att#>	
			 <cfelseif FunctionIcon eq "Schedule">
			     <img src="#client.virtualdir#/Images/schedule.png"    width="35" height="35" #att#>					 		        
			 <cfelseif FunctionIcon eq "Locate">
	             <img src="#client.virtualdir#/Images/search2.png"     width="36" height="36" #att#>	
			  <cfelseif FunctionIcon eq "Log">
	             <img src="#client.virtualdir#/Images/Log_icon.png"    width="36" height="36" #att#>		 					
			 <cfelseif FunctionIcon eq "Builder">
	             <img src="#SESSION.root#/Images/logos/listing.png"    width="36" height="36" #att#>		 
			 <cfelseif FunctionIcon eq "Monitor">
	             <img src="#client.virtualdir#/Images/monitoring2.png" #att# width="36" height="36" >		 
			 <cfelseif FunctionIcon eq "User">
	             <img src="#client.virtualdir#/Images/access1.gif"     #att# height="34" width="34" #att#>	
			 <cfelseif FunctionIcon eq "Tree">
	             <img src="#client.virtualdir#/Images/Tree.png"        #att# height="34" width="34" #att#>	
			 <cfelseif FunctionIcon eq "Workflow">
			      <img src="#client.virtualdir#/Images/Logos/User/WorkFlow.png" height="34" width="34" #att#>				
			 <cfelseif FunctionIcon eq "Report">				 
	              <img src="#SESSION.root#/Images/logos/system/reports.png" #att# width="35" height="35"> 		 
			 <cfelseif FunctionIcon eq "List">			 
	              <img src="#client.virtualdir#/Images/logos/listing.png" #att# width="38" height="36"> 	 	 			
			 <cfelseif FunctionIcon eq "Audit">	
	              <img src="#client.virtualdir#/Images/audit.png?8" #att# width="31" height="31">				  
			 <cfelseif FunctionIcon eq "Dataset">			 
			     <img src="#client.virtualdir#/Images/dataset.png"   #att# height="34" width="34">	  
			 <cfelse>
				<cf_img icon="bullet">
	          </cfif>
			  
			  </td></tr></table>
			  </td></tr></table>
		
		<cfelse>
				
			<!--- Icons for reports --->
			<cfif FunctionIcon eq "PDF">
			     <img src="#client.virtualdir#/Images/report6.gif"   #att# height="34" width="34">
			<cfelseif FunctionIcon eq "Dataset">
			     <img src="#client.virtualdir#/Images/dataset.png"  #att# height="34" width="34">
			<cfelseif FunctionIcon eq "Listing">
			     <img src="#client.virtualdir#/Images/list.png"      #att# height="34" width="34">				 
			<cfelse>			
				<img src="#client.virtualdir#/Images/report6.gif"    #att# height="34" width="34">
				
			</cfif>
		
		</cfif>
		  
 
 </cfoutput>