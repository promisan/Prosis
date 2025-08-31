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
	<cf_tl id="Advanced Search" var="1">
	<cfset s = StructNew()> 
	<cfset s.value = "Advanced"> 
	<cfset s.display = "<span class='labelit'>#lt_text#</span>"> 
	<cfset s.parent  = "Special">
	<cfset s.href    = "javascript:listshow('LOC','','#mission#')">
	<cfset s.leafnode=true/>	
	<cfset arrayAppend(result,s)/>			
	
	<cf_tl id="Received" var="1">
	<cfset s = StructNew()> 
	<cfset s.value = "today"> 
	<cfset s.display = "<span class='labelit'>#dateformat(now(), CLIENT.DateFormatShow)# : #lt_text#</span>"> 
	<cfset s.parent  = "Special">
	<cfset s.href    = "javascript:listshow('TOD','','#mission#')">
	<cfset s.img     = "">
	<cfset s.leafnode=true/>	
	<cfset arrayAppend(result,s)/>		
	
	<cf_tl id="Recorded" var="1">
	<cfset s = StructNew()> 
	<cfset s.value = "entered"> 
	<cfset s.display = "<span class='labelit'>#dateformat(now(), CLIENT.DateFormatShow)# : #lt_text#</span>"> 
	<cfset s.parent  = "Special">
	<cfset s.href    = "javascript:listshow('REC','','#mission#')">
	<cfset s.img     = "">
	<cfset s.leafnode=true/>	
	<cfset arrayAppend(result,s)/>		
	