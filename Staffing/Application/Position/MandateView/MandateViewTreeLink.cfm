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
<cfset Criteria = ''>

<cfparam name="Form.Posttype"  default="">	
<cfparam name="Form.PostGrade" default="">	
<cfparam name="Form.OccGroup"  default="">	

<cfif #Form.Posttype# IS NOT "">
  <cfif #Criteria# neq "">
     <CFSET #Criteria# = #Criteria#&" AND P.Posttype IN ( #PreserveSingleQuotes(Form.Posttype)# )" >
  <cfelse>
  	 <CFSET #Criteria# = "P.Posttype IN ( #PreserveSingleQuotes(Form.Posttype)# )" >
  </cfif>
</cfif>  

<cfparam name="Form.Postgrade" default="">	

<cfif #Form.Postgrade# IS NOT "">
  <cfif #Criteria# neq "">
     <CFSET #Criteria# = #Criteria#&" AND P.Postgrade IN ( #PreserveSingleQuotes(Form.Postgrade)# )" >
  <cfelse>
  	 <CFSET #Criteria# = "P.Postgrade IN ( #PreserveSingleQuotes(Form.Postgrade)# )" >
  </cfif>
</cfif>  

<cfparam name="Form.OccGroup" default="">	

<cfif #Form.OccGroup# IS NOT "">
  <cfif #Criteria# neq "">
     <CFSET #Criteria# = #Criteria#&" AND O.OccupationalGroup IN ( #PreserveSingleQuotes(Form.OccGroup)# )" >
  <cfelse>
  	 <CFSET #Criteria# = "O.OccupationalGroup IN ( #PreserveSingleQuotes(Form.OccGroup)# )" >
  </cfif>
</cfif>  



<cfif #URL.Mission# IS NOT "">
  <cfif #Criteria# neq "">
     <CFSET #Criteria# = #Criteria#&" AND P.Mission = '#URL.Mission#'" >
  <cfelse>
  	 <CFSET #Criteria# = "P.Mission = '#URL.Mission#'" >
  </cfif>
</cfif>  

<cfset CLIENT.MandateFilter = Criteria>

<cflocation url="MandateViewTree.cfm" addtoken="No">