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
	
</cfcomponent>	