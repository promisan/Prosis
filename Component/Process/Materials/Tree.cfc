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
<cfcomponent output="false"	hint="Handles tree for itemClass">

    <cffunction name="getNodes" returnType="array" output="no" access="remote"> 
        <cfargument name="vmid"    required="true" default=""> 
        <cfargument name="vpath"   required="true" default=""> 
        <cfargument name="mission" required="true" default=""> 				  
		
        <cfset result = ArrayNew(1)> 
		
		<cfif vmid eq "">
		
			<cfset main = "Special,Action,Inventory,Standard">

			<cf_tl id="Inquiry" 			  var="l1">
			<cf_tl id="Pending Asset Actions" var="l2">
			<cf_tl id="Inventory" 			  var="l3">	
			<cf_tl id="Quick Views" 		  var="l4">				
			
			<cfset labels = "#l1#,#l2#,#l3#,#l4#">
			<cfset expand = "yes,yes,no,yes">

			<cfset j=0>
			<cfloop list="#main#" index="i">
															
				<cfset j = j + 1>
		        <cfset s = StructNew()> 
		        <cfset s.value   = "#i#"> 
		        <cfset s.display = "<span class='labellarge'>#ListGetAt(labels,j)#</span>">
				<cfset s.expand  = ListGetAt(expand,j)/>			
				<cfset arrayAppend(result,s)/>			
							
			</cfloop>	
			
		<cfelse>

			<cfset Level_Array = ListToArray(vPath,"\")>
			<cfset Level = ArrayLen(Level_Array)>

			<cfif Level neq 0>				
				
				<cfswitch expression = "#Level_Array[1]#"> 
					<cfcase value="Class,Organization,Location">
						<cfinclude template = "Tree/#Level_Array[1]#.cfm">								
					</cfcase>					
				</cfswitch>
				
			<cfelse>						
			
				<cfinclude template = "Tree/#vMid#.cfm">	
									
				<cfset s = StructNew()> 	
				<cfset s.value="">   									
				<cfset s.leafnode=true/>	
				<cfset arrayAppend(result,s)/>	
							
			</cfif>
			
		</cfif>
        <cfreturn result> 
    </cffunction>

	<cffunction name="getNodesV2" access="remote" returnFormat="json" output="false" secureJSON = "yes" verifyClient = "yes">
		<cfargument name="vpath"    required="true" default="">
		<cfargument name="value"   required="true" default="">
		<cfargument name="mission" required="true" default="">

		<cfset result = ArrayNew(1)>
		<cfset vmid = value>
		<cfif vmid eq "">


			<cfset main = "Special,Action,Inventory,Standard">

			<cf_tl id="Inquiry" 			  var="l1">
			<cf_tl id="Pending Asset Actions" var="l2">
			<cf_tl id="Inventory" 			  var="l3">
			<cf_tl id="Quick Views" 		  var="l4">

			<cfset labels = "#l1#,#l2#,#l3#,#l4#">
			<cfset expand = "yes,yes,no,yes">

			<cfset j=0>
			<cfloop list="#labels#" index="i">

				<cfset j = j + 1>
				<cfset s = StructNew()>
				<cfset vValue = replace(i," ","","all")>
				<cfset s.value   = "#vValue#">
				<cfset s.display = "<span class='labellarge'>#ListGetAt(labels,j)#</span>">
				<cfset s.expand  = ListGetAt(expand,j)/>
				<cfset arrayAppend(result,s)/>

			</cfloop>

		<cfelse>

			<cfset Level_Array = ListToArray(vPath,"\")>
			<cfset Level = ArrayLen(Level_Array)>

			<cfif Level neq 0>

				<cfswitch expression = "#Level_Array[1]#">
					<cfcase value="Class,Organization,Location">
						<cfinclude template = "Tree/#Level_Array[1]#.cfm">
					</cfcase>
				</cfswitch>

			<cfelse>
				<cfset vFileName = replace(vMid," ","","all")>
				<cfinclude template = "Tree/#vFileName#.cfm">



			</cfif>

		</cfif>

		<cfscript>
			treenodes = result;
			msg = SerializeJSON(treenodes);
		</cfscript>

		<cfreturn msg>



	</cffunction>


</cfcomponent>	