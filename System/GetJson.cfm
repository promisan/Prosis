<cfset vComponent = "#URLDecode(url.service)#">
<cfset vComponent = Replace(vComponent,"/",".","all")>
<cfset vComponent = Replace(vComponent,"component.","service.")>

<cfinvoke 
    component="#vComponent#" 
    method="#url.method#" 
    returnVariable="res"> 
    <cfloop collection="#url#" item="key" >
        <cfif key neq "method" and key neq "getAdministrator" and key neq "service">
            <cfinvokeargument name="#key#"  value="#url[key]#"> 
        </cfif>    
    </cfloop>
</cfinvoke> 
<cfoutput>#Replace(res,"//","")#</cfoutput>