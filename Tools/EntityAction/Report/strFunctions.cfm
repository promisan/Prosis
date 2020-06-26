
<cffunction name="TCase" access="public" returntype="string"> 
     <cfargument name="str" type="string" required="yes" /> 
     <cfset var vReturn = "" /> 
     <cfset var i = "" /> 
        <cfloop list="#arguments.str#" delimiters=" ;,:!?._-/&(" index="i"> 
                 <cftry>
                    <cfset vReturn = listAppend(vReturn, ucase(left(i,1)) & lcase(right(i,Len(i)-1))," ") /> 
                 <cfcatch></cfcatch>
                 </cftry>
        </cfloop> 
		
	 <cfset vPos =Find("'",vReturn)>	
	 <cfif vPos neq 0>
		<cfset 	vReturn = Mid(vReturn,1,vPos) & UCase(Mid(vReturn,vPos+1,1)) & Mid(vReturn,vPos+2,len(vReturn)-vPos)>
	 </cfif>	
     <cfreturn vReturn/> 
</cffunction>
 

<cffunction name="Prefix" access="public" returntype="string"> 
     <cfargument name="Gender" type="string" required="yes" /> 
  		<cfif Gender eq 'M'>
            <cfreturn "Mr."/>
        <cfelse>
            <cfreturn "Ms."/>
        </cfif>
</cffunction> 


<cffunction name="Belonginess" access="public" returntype="string"> 
     <cfargument name="Gender" type="string" required="yes" /> 
  		<cfif Gender eq 'M'>
            <cfreturn "his"/>
        <cfelse>
            <cfreturn "her"/>
        </cfif>
</cffunction>

<cffunction name="Subject" access="public" returntype="string">
    <cfargument name="Gender" type="string" required="yes" />
    <cfif Gender eq 'M'>
        <cfreturn "he"/>
    <cfelse>
        <cfreturn "she"/>
    </cfif>
</cffunction>

<cffunction name="Pronoun" access="public" returntype="string">
    <cfargument name="Gender" type="string" required="yes" />
    <cfif Gender eq 'M'>
        <cfreturn "him"/>
    <cfelse>
        <cfreturn "her"/>
    </cfif>
</cffunction>

<cffunction name="GetRelativePath" access="public" returntype="string"> 
     <cfset var vReturn = "" /> 
	<cfset Template_Path=ReplaceNoCase(GetDirectoryFromPath(GetCurrentTemplatePath()),SESSION.rootPath,"","ALL")>
		
	<cfset Executing_Path=ReplaceNoCase(ExpandPath( "./" ),SESSION.rootPath,"","ALL")>

	<cfset vPrefix="">	
    <cfset var i = "" /> 
        <cfloop list="#Executing_Path#" delimiters="\" index="i"> 
			<cfif vPrefix eq "">
				<cfset vPrefix = "..\..\">
			<cfelse>
				<cfset vPrefix = vPrefix & "..\">
			</cfif>
        </cfloop> 

	<cfset vReturn=vPrefix & Template_Path>
	<cfset vReturn=Replace(vReturn,"\","/","ALL")>
	
		
    <cfreturn vReturn/> 
</cffunction> 

<cffunction name="IndentMe" access="public" returntype="string">
	<cfreturn "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;">;
</cffunction>

