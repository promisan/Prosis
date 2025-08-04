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
<cfparam name="attributes.path" 		default = "">
<cfparam name="attributes.filename" 	default = "">
<cfparam name="attributes.percentage"	default = "50"> <!--- 100 is the same width/height --->
<cfparam name="attributes.action"		default = "resize"> <!--- Resize --->


<cfset vPath     = Replace("#attributes.server#\#attributes.path#","/","\","ALL")>
<cfset vPath     = Replace(vPath,"\\","\","ALL")>

<cfset vFilename = Replace(attributes.filename,".JPG","_s.JPG","ALL")> 



<cfif not DirectoryExists("#vPath#Originals")>
	   <cftry>
		   <cfdirectory action="CREATE" 
	         directory="#vPath#Originals">
			 
		     <cfcatch></cfcatch>
		</cftry>
</cfif>



<cfswitch expression="#attributes.action#">
	
<cfcase value="resize" >
	<cfoutput>
		Checking: #vPath#Originals\#attributes.filename#
	</cfoutput>
		
	<cfif FileExists("#vPath#Originals\#attributes.filename#") EQ 'No'>
								

			<cfimage action="info" structname="imagetemp" 
			         source="#vPath##attributes.filename#"/>
					  
			<cfset nwidth  = attributes.percentage * imagetemp.width/100>
			<cfset nheight = attributes.percentage * imagetemp.height/100>
					  
			<cfset x = min(nwidth / imagetemp.width, nheight/ imagetemp.height)/>
			
			<cfset newwidth = x * imagetemp.width/>
			<cfset newheight = x * imagetemp.height/>
		
		
			<cfimage action="resize" source="#vPath##attributes.filename#" 
			         width="#newwidth#" height="#newheight#" 
			         destination="#vPath##vFilename#" 
			         overwrite="true"/>		
			         
						         
			<cffile action = "move" source = "#vPath##attributes.filename#" 
    				destination = "#vPath#Originals\#attributes.filename#">

			move done #vPath#Originals\#attributes.filename#!
			<br>
			
			<cffile action = "rename" source = "#vPath##vFileName#" 
    				destination = "#vPath##attributes.filename#">
			         	
	<cfelse>
		<cfoutput>
			It exists : #vPath#Originals\#attributes.filename#
		</cfoutput>			         			
	</cfif>
</cfcase>

</cfswitch>