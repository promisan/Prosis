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
<cfoutput>

<cfparam name="url.mode" default="embed">

<cfsavecontent variable="menu">

	<cfmenu 
          name="costmenu"
          font="calibri"
          fontsize="15"
          bgcolor="dadada"		  
          selecteditemcolor="6688aa"
          selectedfontcolor="FFFFFF">

	 <cf_tl id="Back" var="1">
	 <cfset tBack = "#Lt_text#">

<cfif url.mode eq "embed">
		  
	<cfmenuitem 
          display="#tBack#"
          name="back"
          href="javascript:history.go(-1)"
          image="#SESSION.root#/Images/back.gif"/>					  
		  
		 <cf_tl id="Notes/Messages" var="1">
		 <cfset tNotes= "#Lt_text#">
			  
	<cfmenuitem 
          display="#tNotes#"
          name="mail"
          href="javascript:details('#url.objectid#','mail')"
          image="#SESSION.root#/Images/mail.gif"/>	
		  	 
</cfif>				  

<cf_tl id="Create" var="1">
<cfset tCreate= "#Lt_text#">				  	  	    

<cf_tl id="Expense Entry" var="1">
<cfset tExpense= "#Lt_text#">		  
		  
<cfmenuitem 
          display="#tExpense#"
          name="cost"
          href="javascript:costentry('#url.objectid#','','cost','regular','costcontainer')"
          image="#SESSION.root#/Images/calculate.gif"/>

<cf_tl id="Work Entry" var="1">
<cfset tWork= "#Lt_text#">		
		
<cfmenuitem 
          display="#tWork#"
          name="activity"
          href="javascript:costentry('#url.objectid#','','work','regular','costcontainer')"
          image="#SESSION.root#/Images/activity.gif"/>
		 

<cf_tl id="Summary" var="1">
<cfset tSummary= "#Lt_text#">		
		  
<cfmenuitem 
          display="#tSummary#"
          name="sum"
		  href="javascript:showsummary()"
          image="#SESSION.root#/Images/overview1.gif"/>					  	    

</cfmenu>

</cfsavecontent>

</cfoutput>

<cf_tl id="Cost management" var="1">

<cf_ViewTopMenu option="#menu#" background="gray" label="#lt_text#">
