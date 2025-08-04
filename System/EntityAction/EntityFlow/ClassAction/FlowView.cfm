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

<cfparam name="URL.Connector"    default="INIT"> <!--- JOB0080 / INIT --->
<cfparam name="url.link"         default="'#URL.Connector#'">
<cfparam name="URL.PublishNo"    default="">
<cfparam name="URL.ActionNoShow" default="000">
<cfparam name="URL.Print"        default="0">
<cfparam name="URL.Scope"        default="Config">
<cfparam name="URL.ObjectId"     default="">

<cfquery name="Class" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT   *
	 FROM     Ref_Entity E, Ref_EntityClass R
	 WHERE    R.EntityCode  = '#url.entityCode#'
	 AND      R.EntityClass = '#url.entityClass#'
	 AND      R.EntityCode  = E.EntityCode 
</cfquery>	

<cfif url.scope eq "object">
 
   <cf_screentop height="100%"    
        scroll="no" 
		layout="webapp" 
	    jquery="Yes" 
		SystemModule="System" 
		FunctionClass="window" 
		FunctionName="Workflow Presenter" 
		line="no" 
		banner="gray" 
		bannerenforce="Yes" 
		label="Workflow for #Class.EntityDescription#">
   
   <cf_dialogsystem>
   
	<cf_divscroll>   	
	   <cfinclude template="FlowViewContent.cfm">	
	</cf_divscroll>
	
	<cf_screenbottom layout="webapp">

<cfelse>
	
	<HTML><HEAD>
		<TITLE>Workflow Preview</TITLE>
	</HEAD>	
	
	<cfoutput>		
	<body onLoad="window.focus()">
	<link href="#SESSION.root#/#client.style#" rel="stylesheet" type="text/css">
	<script type="text/javascript" src="#SESSION.root#/Scripts/jQuery/jquery.js"></script>
	<link rel="stylesheet" type="text/css" href="../../../../print.css" media="print">
	
	
	<link rel="stylesheet" href="https://nova.un.org//scripts/kendoui/styles/kendo.common.min.css" />
	<link rel="stylesheet" href="https://nova.un.org//scripts/kendoui/styles/kendo.default-v2.min.css" />
	<link rel="stylesheet" href="https://nova.un.org//scripts/kendoui/styles/kendo.default.mobile.min.css" />

    <link rel="stylesheet" href="https://nova.un.org//scripts/kendoui/styles/kendo.rtl.min.css"/>
    <link rel="stylesheet" href="https://nova.un.org//scripts/kendoui/styles/kendo.silver.min.css"/>

	<script src="https://nova.un.org//scripts/kendoui/js/kendo.all.min.js"></script>
	
	<cfajaximport>
	<cf_UIGadgets>	
	<cf_SystemScript>
	
	</cfoutput>
	
	<cf_dialogsystem>
	
	<cfinclude template="FlowViewContent.cfm">
		
	</body>

</cfif>

<script>
parent.Prosis.busy('no')
</script>

</cfoutput>

