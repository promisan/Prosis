<!--
    Copyright © 2025 Promisan

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
<cf_filelibraryCheck    	
		DocumentPath="Position"
		SubDirectory="#Position.PositionNo#" 
	    Filter="">		
		
	<cfif files gte "1" or AccessPosition eq "EDIT" or AccessPosition eq "ALL" or AccessLoaner eq "EDIT" or AccessLoaner eq "ALL">	
	
	<tr>
		<td valign="top" class="labelmedium2" style="background-color:f1f1f1;border-bottom:1px solid silver;padding-top:4px;padding-left:6px"><cf_tl id="Attachments">:</td>
		<td class="labelmedium2" style="padding-top:3px;padding-left:10px">
		
		<cfif AccessPosition eq "EDIT" or AccessPosition eq "ALL" or AccessLoaner eq "EDIT" or AccessLoaner eq "ALL">
						 	  
				 <cf_filelibraryN
				    Box="primary"
					DocumentPath="Position"
					SubDirectory="#Position.PositionNo#" 
					Filter=""
					Insert="yes"
					Remove="yes"
					Highlight="no"
					Listing="yes">
										
			
		 <cfelse>
				 
				 <cf_filelibraryN
				    Box="primary"
					DocumentPath="Position"
					SubDirectory="#Position.PositionNo#" 
					Filter=""
					Insert="no"
					Remove="no"
					Highlight="no"
					Listing="yes">
							 	 
		 </cfif>
	 
	    </td>
		
   </tr>	
   
   </cfif>
   
   <cfset spst = position.SourcePositionNo>
   
   <cfquery name="Exist" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT  *
	  FROM  Position
	  WHERE PositionNo = '#spst#'					
   </cfquery>
        
   <cfset row = 0>	
         
  <cfloop condition="#exist.recordcount# eq '1'">
  	     
	   <cfset row = row + 1>
   
	   <cf_filelibraryCheck    	
			DocumentPath="Position"
			SubDirectory="#spst#" 
		    Filter="">	
			
				   
	   <cfif files gte "1">	
		
		<tr>
			<td height="30" class="labelmedium2" style="background-color:f1f1f1;border-bottom:1px solid silver;padding-top:4px;padding-left:6px"><cf_tl id="Attachment Log"><cfoutput>/ #spst#</cfoutput>:</td>
			<td class="labelmedium2" style="padding-left:10px">
			
				<cfif AccessPosition eq "EDIT" or AccessPosition eq "ALL" or AccessLoaner eq "EDIT" or AccessLoaner eq "ALL">
				
					 <cf_filelibraryN
						Box="secunday#row#"
						DocumentPath="Position"
						SubDirectory="#spst#" 
						Filter=""
						Insert="no"
						Remove="yes"
						Highlight="no"
						Listing="yes"> 			
			
				<cfelse>
				
												
					 <cf_filelibraryN
						Box="secunday#row#"
						DocumentPath="Position"
						SubDirectory="#spst#" 
						Filter=""
						Insert="no"
						Remove="no"
						Highlight="no"
						Listing="yes"> 			
						
				</cfif>		
		 
		    </td>
			
	   </tr>
	   
	   </cfif>
	   
	   <cfquery name="Exist" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT  *
		  FROM  Position
		  WHERE PositionNo = '#Exist.SourcePositionNo#'					
	   </cfquery>	
	   
	   <cfset spst = exist.PositionNo>
	   
   </cfloop>