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
<cfparam name="attributes.UserAccount" default="">
<cfparam name="attributes.IndexNo"     default="">
<cfparam name="attributes.gender"      default="M">
<cfparam name="attributes.style"       default="width:80px;height:80px">
<cfparam name="attributes.class"       default="">
<cfparam name="attributes.printmode"   default="0">

<cfset vPhoto = attributes.UserAccount>

<cfif not FileExists("#session.rootdocumentpath#\EmployeePhoto\#attributes.UserAccount#.jpg") OR trim(attributes.UserAccount) eq "">

	<cfset vPhoto = attributes.IndexNo>
		
	<cfif not FileExists("#session.rootdocumentpath#\EmployeePhoto\#attributes.IndexNo#.jpg") OR trim(attributes.IndexNo) eq "">
	
		<cfif attributes.Gender eq "f">
			<cfset vPhoto = "Female">
		<cfelse>
			<cfset vPhoto = "Male">
		</cfif>
				
	</cfif>

</cfif>

<!--- output --->

<cfoutput>
	
	<cfif vPhoto eq "Female">
	
		<cfset vPhoto = "#session.root#/Images/Logos/no-picture-female.png">
	
		<cfif attributes.printmode eq 0>
			<div class="img-circle clsRoundedPicture #attributes.class#" style="background-image:url('#vPhoto#'); #attributes.style#"></div>
		<cfelse>			
			<div style="float:left; padding:20px; width:90px"><img src="#vPhoto#" height="80px" width="80px"></div>	
		</cfif>	
	
	<cfelseif vPhoto eq "Male">
	
		<cfset vPhoto = "#session.root#/Images/Logos/no-picture-male.png">
	
		<cfif attributes.printmode eq 0>
			<div class="img-circle clsRoundedPicture #attributes.class#" style="background-image:url('#vPhoto#'); #attributes.style#"></div>
		<cfelse>
			<div style="float:left; padding:20px; width:90px"><img src="#vPhoto#" height="#height#px" width="#width#px"></div>
		</cfif>	
			
	<cfelse>	
		
		<!---																									
		<cffile action="COPY" 
			source="#SESSION.rootDocumentpath#\EmployeePhoto\#vPhoto#.jpg" 
  		    	destination="#SESSION.rootPath#\CFRStage\EmployeePhoto\#vPhoto#.jpg" nameconflict="OVERWRITE">
											
		<cfset vPhoto = "#SESSION.root#\CFRStage\EmployeePhoto\#vPhoto#.jpg">	
		
		--->

		<cfset vPhoto = "#SESSION.root#/CFRStage/getFile.cfm?id=#vPhoto#.jpg&mode=EmployeePhoto">

		<cfif attributes.printmode eq 0>
			<div><img src="#vPhoto#" style="#attributes.style#" class="img-circle clsRoundedPicture #attributes.class#"></div>
		<cfelse>
			<div style="float:left; padding:20px; width:90px"><img src="#vPhoto#" style="#attributes.style#"  class="#attributes.class#"></div>
		</cfif>			
	
		<!--- too slow : Hanno 4/2/2021
	
		<cfset myImage=ImageNew("#SESSION.rootDocumentpath#\EmployeePhoto/#vPhoto#.jpg")>						
		<cfimage class="img-circle clsRoundedPicture #attributes.class#" style="#attributes.style#" source="#myImage#" action="writeToBrowser">														
		
		--->
	
	
	</cfif>

</cfoutput>

