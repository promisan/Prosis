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
<cfparam name="url.action"         default="">	
<cfparam name="url.personno"       default="">	
<cfparam name="Form.ReferenceName" default="zz">
<cfparam name="Form.Journal"       default="zz">
<cfparam name="Form.Period"        default="zz">
<cfparam name="Form.Status"        default="zz">
<cfparam name="Criteria"           default="">

<cfoutput>

<cfset Criteria = "WHERE 1=1">

<cfif url.personno IS NOT 'undefined'>
     <CFSET Criteria = "#Criteria# AND EXISTS (SELECT 'X' FROM Accounting.dbo.TransactionHeaderActor WHERE Journal = P.Journal AND JournalSerialNo = P.JournalSerialNo AND PersonNo = '#url.personno#')"> 	
</cfif> 

<cfif Form.Journal IS NOT 'zz'>
     <CFSET Criteria = "#Criteria# AND P.Journal IN ( #PreserveSingleQuotes(Form.Journal)# )">
</cfif> 

<cfif Form.Period IS NOT 'zz'>
     <CFSET Criteria = "#Criteria#& AND P.AccountPeriod IN ( #PreserveSingleQuotes(Form.Period)# )">
</cfif> 

<cfset client.payables = criteria>

<cfinclude template="InquiryData.cfm">

<script>    
  _cf_loadingtexthtml=''  
  ptoken.navigate('ShowAging.cfm?mode=#url.mode#&mission=#url.mission#&systemfunctionid=#url.systemfunctionid#','graph')     
  ptoken.navigate('ShowPayee.cfm?mode=#url.mode#&mission=#url.mission#&systemfunctionid=#url.systemfunctionid#','payee')    
  ptoken.navigate('InquiryListing.cfm?init=1&mode=#url.mode#&mission=#url.mission#&systemfunctionid=#url.systemfunctionid#','listbox')     
</script>	

<cfif url.action neq "person">
     <script>
	 ptoken.navigate('ShowPerson.cfm?mode=#url.mode#&mission=#url.mission#&systemfunctionid=#url.systemfunctionid#','person')
	 </script>
</cfif>

</cfoutput>
	

