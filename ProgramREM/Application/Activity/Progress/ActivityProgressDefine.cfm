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

<cfoutput>

<!--- START DATE --->

<cfif ds lt PerS>
	<cfset DT = PerS>
<cfelseif ds gt PerE>  
    <cfset DT = PerE>
<cfelse>
    <cfset DT = ds>
</cfif>

<!--- define box element that coincides with date --->
<!--- define year --->

<cfif Year(DT) eq SY>
   <cfset MthS = "0">
   <cfset ElmS = (MthS + #month(DT)#-#SM#)*4>
<cfelse>
   <cfset MthS = S[1]>
   <cfset ElmS = (MthS + #month(DT)#-1)*4>
</cfif>

<!--- define day and week matching --->
<cfif Day(DT) gte 23>
   <!--- last week of the month --->
   <cfset ElmS = ElmS+4>
<cfelseif Day(DT) gte 16>   
   <!--- 3rd week of the month --->
   <cfset ElmS = ElmS+3>
<cfelseif Day(DT) gte 9> 
   <!--- 2nd week of the month --->
   <cfset ElmS = ElmS+2>   
<cfelseif Day(DT) gte 2> 
   <!--- first week of the month --->
   <cfset ElmS = ElmS+1>       
</cfif>  

<!--- END DATE --->

<cfif de gt PerE>
	  <cfset DT = PerE>
<cfelseif de lt PerS>  
      <cfset DT = PerS>
<cfelse>
      <cfset DT = de>
</cfif>

<!--- define box element that coincides with date --->
<!--- define year --->

<cfif Year(DT) eq SY>
   <cfset MthE = 0>
   <cfset ElmE = (#MthE# + #month(DT)# - #SM#)*4>
<cfelse>
   <cfset MthE = #S[1]#>
   <cfset ElmE = (#MthE# + #month(DT)# - 1)*4>
</cfif>

<!--- define month and element --->
<cfif Day(DT) gt 23>
   <cfset ElmE = ElmE+4>
<cfelseif Day(DT) gt 16>   
   <cfset ElmE = ElmE+3>
<cfelseif Day(DT) gt 9> 
   <cfset ElmE = ElmE+2>   
<cfelseif Day(DT) gte 1> 
   <cfset ElmE = ElmE+1>       
</cfif> 

<!--- provision for a third year in the view --->
<cfif ElmE lt ElmS>
   <cfset ElmE = ElmE+48>
</cfif>

</cfoutput>