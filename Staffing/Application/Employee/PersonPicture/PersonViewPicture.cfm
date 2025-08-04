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
<cfparam name="url.PictureWidth" 	default="80">
<cfparam name="url.PictureHeight" 	default="100">
<cfparam name="url.reference" 		default="empty">
<cfparam name="url.scope" 			default="backoffice">

<cfif FileExists("#SESSION.rootDocumentPath#\EmployeePhoto\#url.Personno#.jpg") and url.Personno neq "">   
   <cfset pict = url.Personno>	
<cfelseif FileExists("#SESSION.rootDocumentPath#\EmployeePhoto\#url.IndexNo#.jpg") and url.indexNo neq "">                           		
   <cfset pict = IndexNo>   
<cfelseif FileExists("#SESSION.rootDocumentPath#\EmployeePhoto\#url.Reference#.jpg") and url.reference neq "">   
   <cfset pict = url.Reference>		   
<cfelse>
   <cfset pict = "">      
</cfif>

<cfoutput>
	
	<table cellspacing="0" cellpadding="0">
			
		<cfinvoke component= "Service.Access"  
		  method   = "staffing" 
		  role     = "'HROfficer'"
		  returnvariable="accessStaffing">				
		
		<tr>
			<td class="labelit" align="center" style="width:#url.PictureWidth#;height:#url.PictureHeight#;border:1px solid gray">
			   
				<cf_assignid>
												
				<cfif pict eq "">  
				
					<cfparam name="url.personno" default="">				
								   
			         <cfquery name="get" 
					     datasource="AppsEmployee" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
			               	SELECT *
			                FROM   Person
			                WHERE  PersonNo = '#URL.PersonNo#'
			         </cfquery>   
				
					 <cfif get.Gender eq "female" or trim(get.Gender) eq "F">
				
						  <img src="#SESSION.root#\Images\logos\no-picture-female.png" 
								 title="Picture" name="EmployeePhoto"  
								 id="EmployeePhoto" 
								 width="130" 
								 height="auto" 
								 align="absmiddle"> 
						 
					 <cfelse>
					   
						    <img src="#SESSION.root#\Images\logos\no-picture-male.png" 
								 title="Picture" name="EmployeePhoto"  
								 id="EmployeePhoto" 
								 width="130" 
								 height="#url.PictureHeight#" 
								 align="absmiddle"> 
						 
					 </cfif> 
													
				 <cfelse>	


				    <cffile action="COPY" 
					    source="#SESSION.rootDocumentpath#\EmployeePhoto\#pict#.jpg" 
		  		    	destination="#SESSION.rootDocumentPath#\CFRStage\EmployeePhoto\#pict#.jpg" nameconflict="OVERWRITE">
					
					<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
					<cfset mid = oSecurity.gethash()/> 


				     <img src="#SESSION.root#/CFRStage/GetFile.cfm?id=#pict#.jpg&mode=EmployeePhoto&mid=#mid#" 
						 title  = "Picture" 
						 name   = "EmployeePhoto"  
						 id     = "EmployeePhoto" 
						 width  = "114" 
						 height = "#url.PictureHeight#" 
						 align  = "absmiddle">						
						 
				 </cfif>
		 
			</td>
		</tr>   
		
		<cfif accessStaffing neq "NONE">
		
			<cfif IndexNo neq "">
			
			<tr>
			 	<td align="center" class="labelmedium2 clsNoPrint" style="cursor:pointer;padding:1px;border:0px solid black">
				
			 		<a href="javascript:uploadPictureProfile('#url.indexNo#');">
						
							<cfif url.scope eq "Backoffice">
								<cf_tl id="Update">
							<cfelse>
								<cfquery name="getP" 
								     datasource="AppsEmployee" 
									 username="#SESSION.login#" 
									 password="#SESSION.dbpw#">
						               	SELECT *
						                FROM   Person
						                WHERE  PersonNo = '#URL.PersonNo#'
						         </cfquery> 
								#getP.firstName# #getP.LastName#
							</cfif>
						</font>
					</a>
			 	</td>
			</tr>
						
			</cfif>
		
		</cfif>	
	
	 
	 </table> 
 
 </cfoutput>