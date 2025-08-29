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
<cfparam name="Attributes.TextClass" default="0">
<cfparam name="Attributes.TextId" default="0">
<cfparam name="Attributes.TextENG" default="">
<cfparam name="Attributes.TextESP" default="">
<cfparam name="Attributes.TextFRA" default="">
<cfparam name="Attributes.TextGER" default="">
<cfparam name="Attributes.TextNED" default="">
<cfparam name="Attributes.TextPOR" default="">
<cfparam name="Attributes.TextCHI" default="">
<cfparam name="Attributes.OverWrite" default="No">


	<cfquery name="Check" 
	datasource="AppsInit">
	SELECT  *
	FROM    InterfaceText
	WHERE   TextId = '#Attributes.TextId#' 
	AND TextClass = '#Attributes.TextClass#' 
	</cfquery>
			
	<cfif Check.recordcount eq "0">
	
	   <cfquery name="Init" 
		datasource="AppsInit">
		INSERT INTO  InterfaceText
		      (TextId,TextClass, TextENG,TextESP,TextFRA,TextGER,TextNED,TextPOR,TextCHI)
		VALUES ('#Attributes.TextId#', 
			  '#Attributes.TextClass#', 
			  '#Attributes.TextENG#',
			  '#Attributes.TextESP#',
			  '#Attributes.TextFRA#',
			  '#Attributes.TextGER#',
			  '#Attributes.TextNED#',			  
 			  '#Attributes.TextPOR#',			  
 			  N'#Attributes.TextCHI#' ) 
	   </cfquery>
	   
	  <cfelse> 
	  	<cfif #Attributes.overwrite# eq "Yes">
		  <cfquery name="UpdateInit" 
			datasource="AppsInit" >
			UPDATE InterfaceText
			SET  TextENG='#Attributes.TextENG#',
			  TextESP='#Attributes.TextESP#',
			  TextFRA='#Attributes.TextFRA#',
			  TextGER='#Attributes.TextGER#',
			  TextNED='#Attributes.TextNED#',			  
 			  TextPOR='#Attributes.TextPOR#',			  
 			  TextCHI=N'#Attributes.TextCHI#'			
			WHERE   TextId = '#Attributes.TextId#' 
			AND TextClass = '#Attributes.TextClass#'   
		   </cfquery>
		</cfif>
	</cfif>