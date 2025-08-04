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
	<cf_tl id="Request for assignment" var="1">	
	<cfset s = StructNew()> 
	<cfset s.value="req">
    <cfset s.display="<span class='labelmedium'>#lt_text#">
	<cfset s.img="">
	<cfset s.href="javascript:reqlist('','','#mission#')">
	<cfset s.parent="action">	
	<cfset s.leafnode=true/>	
	<cfset arrayAppend(result,s)/>			

	<cf_tl id="Movement Action" var="1">	
	<cfset s = StructNew()> 	
	<cfset s.value="mov">
    <cfset s.display="<span class='labelmedium'>#lt_text#">
	<cfset s.img="">
	<cfset s.parent="action">
	<cfset s.href="javascript:movelist('','','#mission#')">	
	<cfset s.leafnode=true/>	
	<cfset arrayAppend(result,s)/>			
			
	<cf_tl id="Disposal action" var="1">	
	<cfset s = StructNew()> 	
	<cfset s.value="dis">
    <cfset s.display="<span class='labelmedium'>#lt_text#">
	<cfset s.img="">
	<cfset s.parent="action">
	<cfset s.href="javascript:disposallist('','','#mission#')">								
	<cfset s.leafnode=true/>	
	<cfset arrayAppend(result,s)/>		
	
	<cf_tl id="Under Observation" var="1">	
	<cfset s = StructNew()> 	
	<cfset s.value="dis">
    <cfset s.display="<span class='labelmedium'>#lt_text#">
	<cfset s.img="">
	<cfset s.parent="action">
	<cfset s.href="javascript:observationlist('','','#mission#')">								
	<cfset s.leafnode=true/>	
	<cfset arrayAppend(result,s)/>		
		
								
