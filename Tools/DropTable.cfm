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

<cfparam name="attributes.Full"     default="0">
<cfparam name="attributes.Range"    default="">
<cfparam name="SESSION.login"       default=""> 
<cfparam name="SESSION.dbpw"        default=""> 
<cfparam name="attributes.timeout"  default="30"> 

<cfif attributes.range eq "">
	
	<cfif SESSION.login neq "" and attributes.full eq "0">
	  
	     <cftry>
	   
		  <cfquery name="DELETEME"
	         datasource="#Attributes.dbname#"
	         timeout="#attributes.timeout#"
	         username="#SESSION.login#"
	         password="#SESSION.dbpw#">
				if exists  (SELECT * 
						    FROM   dbo.sysobjects 
			                WHERE  id = object_id(N'[#Attributes.tblname#]') 
			                AND    OBJECTPROPERTY(id, N'IsUserTable') = 1)
				   
			   DROP   table [#Attributes.tblname#]
				   
			   SELECT TOP 1 *  FROM Sysfiles
			</cfquery>
			
		    <cfcatch></cfcatch>
		  
		  </cftry>	  
	  
	<cfelse>
	  
	      <cftry>
		 
			  <cfquery name="DELETEME"
			   timeout="#attributes.timeout#"
			   datasource="#Attributes.dbname#">
			   if exists 
				  (SELECT * 
				   FROM   dbo.sysobjects 
				   WHERE  id = object_id(N'[#Attributes.tblname#]') 
				   AND    OBJECTPROPERTY(id, N'IsUserTable') = 1)				   
				   DROP   table [#Attributes.tblname#]				   
				   SELECT TOP 1 *  FROM Sysfiles
			  </cfquery>
		  
		     <cfcatch></cfcatch>
		  
		  </cftry>
	  
	</cfif>
	
<cfelse>

	<cfloop index="fileno" from="0" to="#attributes.range#">
		
		<cfif SESSION.login neq "" and attributes.full eq "0">
	  
	     <cftry>
	   
		  <cfquery name="DELETEME"
	         datasource="#Attributes.dbname#"
	         timeout="#attributes.timeout#"
	         username="#SESSION.login#"
	         password="#SESSION.dbpw#">
				if exists  (SELECT * 
						    FROM   dbo.sysobjects 
			                WHERE  id = object_id(N'[#Attributes.tblname#_#fileno#]') 
			                AND    OBJECTPROPERTY(id, N'IsUserTable') = 1)
				   
			   DROP   table [#Attributes.tblname#_#fileno#]
				   
			   SELECT TOP 1 *  FROM Sysfiles
			</cfquery>
			
		    <cfcatch></cfcatch>
		  
		  </cftry>	  
	  
		<cfelse>
	  
	      <cftry>
		 
			  <cfquery name="DELETEME"
			   timeout="#attributes.timeout#"
			   datasource="#Attributes.dbname#">
			   if exists 
				  (SELECT * 
				   FROM   dbo.sysobjects 
				   WHERE  id = object_id(N'[#Attributes.tblname#_#fileno#]') 
				   AND    OBJECTPROPERTY(id, N'IsUserTable') = 1)				   
				   DROP   table [#Attributes.tblname#_#fileno#]				   
				   SELECT TOP 1 *  FROM Sysfiles
			  </cfquery>
		  
		     <cfcatch></cfcatch>
		  
		  </cftry>
	  
		</cfif>
	
	</cfloop>
	

</cfif>	
  