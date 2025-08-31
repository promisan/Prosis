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
	<cfparam name="Attributes.height" default="120">
	<cfparam name="Attributes.scroll"  default="No">
	
	<cfquery name="Link"
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM PortalLinks L,Ref_ModuleControl R
		WHERE L.SystemFunctionId = R.SystemFunctionId	
		AND FunctionName = '#Attributes.FunctionName#' 
		AND L.Class = 'Custom'
		ORDER BY ListingOrder
	</cfquery>
	
	<cfoutput>
	
	<head>
		<title>Portal</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />		
		<link rel="stylesheet" type="text/css"  href="#SESSION.root#/#client.style#"> 	
	</head>
	
	<cfajaxImport>
	
	<script>
	
		function languageswitch(lan) {
	        ColdFusion.navigate('#SESSION.root#/Tools/Language/Switch.cfm?show=0&ID=' + lan + '&menu=yes','lanbox') 	
	    }
		
	</script>	
	
	<cfparam name="Attributes.graphic" default="Yes">
	<cfif attributes.graphic eq "Yes">
		<cfset row = "11">
	<cfelse>
		<cfset row = "9">
	</cfif>	
	
	<cfif attributes.scroll eq "Yes">
		<div class="screen"> 
	</cfif>
	
	<cfset image = "#SESSION.root#/tools/selfservice/LoginImages">
	
	<body bgcolor="D0D0D0" leftmargin="1" topmargin="0" rightmargin="1" bottommargin="0" style="overflow: auto;">
<center>
	
	<table border="0" cellpadding="0" cellspacing="0" width="100%" bgcolor="white">
	  <tr bgcolor="D0D0D0">
	   <td height="16"><img src="#image#/spacer.gif" width="10"  height="16" border="0" alt=""/></td>
	   <td><img src="#image#/spacer.gif" width="21"  height="1" border="0" alt=""/></td>
	   <td><img src="#image#/spacer.gif" width="154" height="1" border="0" alt=""/></td>
	   <td><img src="#image#/spacer.gif" width="16"  height="1" border="0" alt=""/></td>
	   <td><img src="#image#/spacer.gif" width="15"  height="1" border="0" alt=""/></td>
	   <td><img src="#image#/spacer.gif" width="343" height="1" border="0" alt=""/></td>
	   <td><img src="#image#/spacer.gif" width="361" height="1" border="0" alt=""/></td>
	   <td><img src="#image#/spacer.gif" width="21"  height="1" border="0" alt=""/></td>
	   <td><img src="#image#/spacer.gif" width="10"  height="1" border="0" alt=""/></td>
	   <td><img src="#image#/spacer.gif" width="1"   height="1" border="0" alt=""/></td>
	  </tr>     
	 
	  <tr>
	   <td height="56" rowspan="#row#" background="#image#/inside01_r1_c1a.jpg">&nbsp;</td>
	   <td rowspan="2"  colspan="5"><img src="#image#/#attributes.functionName#.jpg" width="549" height="56" border="0" alt="image" /></td>
	   <td colspan="2"  background="#image#/inside01_r1_c7.jpg" align="center" >
	   
	   	  <table align="right" cellspacing="0" cellpadding="0" border="0"><tr><td>
		  	    
		  <cfquery name="Language" 
			 datasource="AppsSystem"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT *
			 FROM Ref_SystemLanguage
			 WHERE Operational IN ('1','2')
		  </cfquery> 
		
		  <cfloop query="Language">
		     <cfif client.languageid eq code>
			 &nbsp <font face="Verdana" color="FFFFFF"><u>#LanguageName#</u>&nbsp <cfif currentrow neq recordcount>|</cfif></font>
			 <cfelse>
		     &nbsp;<a href="javascript:languageswitch('#code#')"><font face="Verdana"
		                                          color="FFFFFF">#LanguageName#</a>&nbsp <cfif currentrow neq recordcount>|</cfif></font>
			 </cfif>
		  </cfloop>&nbsp;
		  
		  	 </td>
			</tr></table>	
		  
		
	   </td>
	   <td rowspan="#row#" background="#image#/inside01_r1_c9a.jpg">&nbsp;</td>
	   <td bgcolor="d0d0d0" height="21" width="0"></td>
	  </tr>
			  	  
		<cfquery name="System" 
		datasource="AppsSystem">
			SELECT *
			FROM   Ref_ModuleControl
			WHERE  SystemModule   = 'SelfService'
			AND    FunctionClass  IN ('SelfService','Portal')
			AND    FunctionName   = '#URL.ID#' 
		</cfquery>
	    
	  <tr>
	   <td colspan="2" background="#image#/inside01_r2_c7.jpg" width="100%" align="right" style="padding-right:10px;padding-top:4px">
	   <font size="2" face="Verdana" color="204b8a">#System.FunctionMemo#</font>
	   </td>
	   <td><img src="#image#/spacer.gif" width="1" height="35" border="0" alt="" /></td>
	  </tr>
	  	
	  <cfif attributes.graphic eq "Yes" and link.recordcount gte "1">
		 	  
	   <tr>
	   <td colspan="7" background="#image#/inside01_r3_c2.jpg">
	   <div align="left">

	   <span class="style5">
	   
		   <cfloop query="Link">
		   
		   <cfif LocationFunctionId eq "">
		   
		   	<cfset ul = "#locationURL#">	
			
					<span class="style6">
			
						<a href="#ul#<cfif locationstring neq "">?#locationstring#</cfif>"
				    	target="#LocationTarget#"
					    title="#Description#">&nbsp;#Description#&nbsp;</a>
						
					</span>
			
		   <cfelse>
		   
			   <cfquery name="SystemFunction"
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
					FROM  Ref_ModuleControl R
					WHERE SystemFunctionId = '#LocationFunctionId#' 		
				</cfquery>
			   
			   <cfif LocationFunctionId neq "">
				   <cfset ul = "#SESSION.root#/#SystemFunction.FunctionDirectory#/#SystemFunction.FunctionPath#">				   
				   
				    <span class="style6">
			
						<a href="#ul#"
				    	target="#LocationTarget#"
					    title="#Description#">&nbsp;#Description#&nbsp;</a>
				
					</span>
				   
			   <cfelse>
			   
			      <cfset ul = "#locationURL#">	
				  
				    <span class="style6">
			
						<a href="#ul#<cfif locationstring neq "">?#locationstring#</cfif>"
				    	target="#LocationTarget#"
					    title="#Description#">&nbsp;#Description#&nbsp;</a>
						
					</span>
				  	   
			   </cfif>
		   
		   </cfif>
		  
		    <span class="style8">l</span> 
				   
		   </cfloop>	  
	   </span>
	   </div>
	   </td>
	   <td><img src="#image#/spacer.gif" width="1" height="22" border="0" alt="" /></td>
	  </tr>
	  
	  </cfif>
	 <!---
	  <tr>
	   <td colspan="7" background="#image#/inside01_r4_c2a.jpg"></td>
	   <td><img src="#image#/spacer.gif" width="1" height="7" border="0" alt="" /></td>
	  </tr>
	  <tr>
	   <td colspan="7" bgcolor="FFFFFF"></td>
	   <td><img src="#image#/spacer.gif" width="1" height="0" border="0" alt="" /></td>
	  </tr>
	  --->
	  <cfif attributes.graphic eq "Yes">
	  
	  <link rel="stylesheet" type="text/css"  href="#SESSION.root#/tools/selfservice/style.css">
	  
	  <tr style="position:relative">

	   <td colspan="7" bgcolor="FFFFFF" valign="top" align="right" >
	   	<img src="#image#/#attributes.functionName#1.jpg" border="0" style="position:absolute; top:0px; right:11px; z-index:6"></td>
	   <td><img src="#image#/spacer.gif" width="1" height="136" border="0" alt=""></td>

	  </tr>
	  
	  </cfif>
	  
	   <tr>
	   <td colspan="7" bgcolor="FFFFFF"></td>
	   <td><img src="#image#/spacer.gif" width="1" height="3" border="0" alt="" /></td>
	  </tr>
	 
	  <tr>
	   <td colspan="7" bgcolor="FFFFFF"><cfdiv id="lanbox"/></td>
	   <td><img src="#image#/spacer.gif" width="1" height="6" border="0" alt="" /></td>
	  </tr>
	   
	      
	  <tr>
	   <td bgcolor="FFFFFF" ></td>
	    <cfif attributes.graphic eq "Yes">
		   <cfset ht = client.height-400>
		<cfelse>		
		   <cfset ht = client.height-360>
		</cfif>   
	   <td colspan="5" valign="top" height="#ht#" style="position:relative; z-index:99"> 
	     
	</cfoutput>   


   