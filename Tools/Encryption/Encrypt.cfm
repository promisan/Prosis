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

<cfparam name="attributes.algo" default="AES">
<cfparam name="attributes.enco" default="UU">

<cfset TEXT  = "#Attributes.Text#"> 
<cfset ALGO  = "#Attributes.algo#"> 
<cfset ENCO  = "#Attributes.enco#"> 

<cfset TEXT="#Attributes.Text#"> 

<cfif ALGO eq "AES">
	<cfset Seed="TE1AWHCQJ+SUZyJTVZWyoQ=="> 
<cfelseif ALGO eq "DES">
    <cfset Seed="tebjuhzlwsg="> 
</cfif>	

<cfif text neq "">
	<cfset Caller.EncryptedText = Encrypt(text,seed,algo,enco)> 	
<cfelse>
    <cfset Caller.EncryptedText = "">
</cfif>	


	
		
	