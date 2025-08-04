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
<!--- generate views --->

<cfquery name="Source"
datasource="AppsSystem">
	SELECT   *
	FROM     LanguageSource
	WHERE    SystemModule IN (SELECT SystemModule 
                        	  FROM Ref_SystemModule 					   
					          WHERE Operational = 1)
					  
</cfquery>

<cfoutput query="source">



<!---

    <cftry>
	
	--->	

   	<cfquery name="Fields" 
	datasource="#DataSource#">
	SELECT   C.name, C.userType 
    FROM     SysObjects S, SysColumns C 
	WHERE    S.id   = C.id
	AND      S.name = '#TableName#'	
	ORDER BY C.ColId
	</cfquery>
	
	<cfset tbl   = "#TableCode#">
	<cfset ds    = "#DataSource#">
	<cfset nm    = "#TableName#">
	<cfset key   = "#KeyFieldName#">
	<cfset key2  = "#KeyFieldName2#">
	<cfset key3  = "#KeyFieldName3#">
	<cfset key4  = "#KeyFieldName4#">
		
	<cfset fld = "">
		
	<!--- deterime the select string for the view --->
	
	<cfloop query = "Fields">
	
		<cfquery name="CheckFields"
		datasource="AppsSystem">
		SELECT     *
		FROM      LanguageSourceField
		WHERE     TableCode = '#tbl#'
		AND       TranslationField = '#Name#' 
		</cfquery>
		
		<cfif CheckFields.recordcount eq "1">
		   <cfset pre = "TL">
		<cfelse>
		   <cfset pre = "T">
		</cfif>
				
		<cfif fld eq "">
		    <cfset fld="#pre#.#Name#">
		<cfelse>
		   <cfset fld="#fld#,#pre#.#Name#"> 	
		</cfif>

	</cfloop>
		
	<!--- create tables only if needed --->

	<cftry>	
		
	<cfquery name="Generate" 
	 datasource="#ds#">
	 	 				
	CREATE TABLE [#nm#_Language] (
		
	    [#key#] 
		
		<cfquery name="Check" 
			 datasource="#ds#">
				SELECT   Col.name AS Name, Type.name AS Type, Col.length AS Length
				FROM     syscolumns Col INNER JOIN
			                sysobjects Tbl ON Col.id = Tbl.id INNER JOIN
			                systypes Type ON Col.xtype = Type.xtype
				WHERE    Tbl.name = '#nm#' 
				AND      Col.name = '#key#' 
				ORDER BY Col.colorder
			</cfquery> 
		
		[#Check.Type#]<cfif Check.Type eq "varchar"> (#Check.Length#) </cfif> NOT NULL,
				
	    <cfloop index="fl" list="2,3,4" delimiters=",">
			
			<cfset k = evaluate("key#fl#")>
			
			<cfif k neq "">
			
				<cfquery name="Check" 
				 datasource="#ds#">
					SELECT   Col.name AS Name, Type.name AS Type, Col.length AS Length
					FROM     syscolumns Col INNER JOIN
			                 sysobjects Tbl ON Col.id = Tbl.id INNER JOIN
			                 systypes Type ON Col.xtype = Type.xtype
					WHERE    Tbl.name = '#nm#' 
					AND      Col.name = '#k#' 
					ORDER BY Col.colorder
				</cfquery> 
				
				<cfif check.type neq "">
										
				[#k#] [#Check.Type#] <cfif Check.Type eq "varchar"> (#Check.Length#) </cfif> NOT NULL,
				
				</cfif>

		</cfif>
	
		</cfloop>	
			
		[LanguageCode] [varchar] (10)  NOT NULL ,
		
		<cfquery name="FldLang"
		datasource="#ds#">
		SELECT     *
		FROM      System.dbo.LanguageSourceField
		WHERE     TableCode = '#tbl#'
		</cfquery>
		
		<cfloop query="FldLang">
		
				<cfquery name="Check" 
				 datasource="#ds#">
					SELECT   Col.name AS Name, Type.name AS Type, Col.length AS Length
					FROM     syscolumns Col INNER JOIN
			                 sysobjects Tbl ON Col.id = Tbl.id INNER JOIN
			                 systypes Type ON Col.xtype = Type.xtype
					WHERE    Tbl.name = '#nm#' 
					AND      Col.name = '#TranslationField#' 
					ORDER BY Col.colorder 
				</cfquery> 
				
		<cfif check.type neq "">		
		
		[#TranslationField#] [#Check.Type#] <cfif Check.Type eq "varchar"> (#Check.Length#) </cfif>  NULL,
		
		</cfif>
		
		</cfloop>
				
		[OfficerUserId] [varchar] (20) NULL ,
		[Created] [datetime] NOT NULL CONSTRAINT [DF_#nm#_Language_Created] DEFAULT (getdate()),
		CONSTRAINT [PK_#nm#_Language] PRIMARY KEY  CLUSTERED 
		(
			#Key#, 
	          <cfif #Key2# neq "">#Key2#,</cfif> 
			  <cfif #Key3# neq "">#Key3#,</cfif>
			  <cfif #Key4# neq "">#Key4#,</cfif>
			
			[LanguageCode]
		)  ON [PRIMARY] ,
		CONSTRAINT [FK_#nm#_Language_#nm#] FOREIGN KEY 
		(
				#Key# 
	          <cfif #Key2# neq "">,#Key2#</cfif> 
			  <cfif #Key3# neq "">,#Key3#</cfif>
			  <cfif #Key4# neq "">,#Key4#</cfif>
		) 
		REFERENCES [#nm#] 
		(
				#Key# 
	          <cfif #Key2# neq "">,#Key2#</cfif> 
			  <cfif #Key3# neq "">,#Key3#</cfif>
			  <cfif #Key4# neq "">,#Key4#</cfif>
			  ) ON DELETE CASCADE  ON UPDATE CASCADE 
	) ON [PRIMARY]
	</cfquery>	

	<cfcatch></cfcatch>
	
	</cftry>
		  	
	<!--- sync table with source --->
	
				
	<cfquery name="Language"
	datasource="AppsSystem">
		SELECT     *
		FROM      Ref_SystemLanguage
		<cfif InterfaceTable eq "0">
		WHERE     SystemDefault <> 1 
		AND       Operational = 2
		<cfelse>
		WHERE     Operational IN ('1','2')
		</cfif>
	</cfquery>
	
	<cfquery name="CheckFields"
		datasource="AppsSystem">
		SELECT     *
		FROM      LanguageSourceField
		WHERE     TableCode = '#tbl#'
	</cfquery>	
					
	<cfloop query="Language">					
					
		<cftry>
								
				<cfquery name="Check" 
				datasource="#ds#">	 
				INSERT INTO #nm#_language
				         (#Key#,	
						  <cfif nm neq "Ref_ModuleControl">
							  <cfif Key2 neq "">#Key2#,</cfif>  
							  <cfif Key3 neq "">#Key3#,</cfif>  
							  <cfif Key4 neq "">#Key4#,</cfif> 
						  </cfif> 
						  <cfloop query="CheckFields">
						  #TranslationField#,
						  </cfloop>		
						  LanguageCode,
						  OfficerUserId)
						  
				SELECT    S.#Key#, 
						  <cfif nm neq "Ref_ModuleControl">
					          <cfif Key2 neq "">S.#Key2#,</cfif> 
							  <cfif Key3 neq "">S.#Key3#,</cfif>
							  <cfif Key4 neq "">S.#Key4#,</cfif>  
						  </cfif>
						  <cfloop query="CheckFields">
						  '--'+S.#TranslationField#,
						  </cfloop>			  
				          '#Code#',
						  'Sync'
						  
				FROM      #nm# S  LEFT OUTER JOIN
	                      #nm#_language L 
						  ON  S.#Key# = L.#Key# 
						  <cfif nm neq "Ref_ModuleControl">
		 					  <cfif key2 neq "">
								 AND  S.#Key2# = L.#Key2#
							  </cfif>
							  <cfif key3 neq "">
								 AND  S.#Key3# = L.#Key3#
							  </cfif>
							  <cfif key4 neq "">
								 AND  S.#Key4# = L.#Key4#
							  </cfif>
						  </cfif>	  
						  AND  LanguageCode = '#Code#'		  
				
				GROUP BY  S.#Key#, 
						  <cfif nm neq "Ref_ModuleControl">
					          <cfif Key2 neq "">S.#Key2#,</cfif> 
							  <cfif Key3 neq "">S.#Key3#,</cfif>
							  <cfif Key4 neq "">S.#Key4#,</cfif>  
						  </cfif>
						  <cfloop query="CheckFields">
						  S.#TranslationField#,
						  </cfloop>		
						  LanguageCode
				HAVING    (LanguageCode IS NULL)
				</cfquery>
					
			<cfcatch>
			
				<cfquery name="Check" 
					 datasource="#ds#">	 
					INSERT INTO #nm#_language
					         (#Key#,							 
							 <cfif nm neq "Ref_ModuleControl">
							  <cfif Key2 neq "">#Key2#,</cfif>  
							  <cfif Key3 neq "">#Key3#,</cfif>  
							  <cfif Key4 neq "">#Key4#,</cfif>
							 </cfif>   					
							  LanguageCode,
							  OfficerUserId)
					SELECT    S.#Key#, 
							   <cfif nm neq "Ref_ModuleControl">
						          <cfif Key2 neq "">S.#Key2#,</cfif> 
								  <cfif Key3 neq "">S.#Key3#,</cfif>
								  <cfif Key4 neq "">S.#Key4#,</cfif>
							  </cfif>  					   
					          '#Code#',
							  'Sync'
					FROM      #nm# S  LEFT OUTER JOIN
		                      #nm#_language L 
							  ON  S.#Key# = L.#Key# 
							  <cfif nm neq "Ref_ModuleControl">
			 					  <cfif key2 neq "">
									 AND  S.#Key2# = L.#Key2#
								  </cfif>
								  <cfif key3 neq "">
									 AND  S.#Key3# = L.#Key3#
								  </cfif>
								  <cfif key4 neq "">
									 AND  S.#Key4# = L.#Key4#
								  </cfif>
							  </cfif>
							  AND  LanguageCode = '#Code#'		  
					GROUP BY  S.#Key#, 
					          <cfif nm neq "Ref_ModuleControl">
						          <cfif Key2 neq "">S.#Key2#,</cfif> 
								  <cfif Key3 neq "">S.#Key3#,</cfif>
								  <cfif Key4 neq "">S.#Key4#,</cfif>  					 
							  </cfif>
							  LanguageCode
					HAVING    LanguageCode IS NULL
					</cfquery>
			
			</cfcatch>
		
		</cftry>
								
		<cfquery name="Drop"
		datasource="#ds#">
	      if exists (select * from dbo.sysobjects 
		             where id = object_id(N'[dbo].[xl#Code#_#nm#]') 
	            	 and OBJECTPROPERTY(id, N'IsView') = 1)
	     drop view [dbo].[xl#Code#_#nm#]
		</cfquery>	
	
	    <cfquery name="CreateView"
		datasource="#ds#">
		CREATE VIEW dbo.xl#Code#_#nm#
			
		AS
		SELECT     <cfif nm eq "Ref_ModuleControl">TL.Mission,</cfif> #fld# 
		FROM       dbo.#nm# T, 
		           dbo.#nm#_Language TL
	    WHERE      T.#Key# = TL.#Key#
		       <cfif nm neq "Ref_ModuleControl">
				   <cfif key2 neq "">
				   AND T.#Key2# = TL.#Key2#
				   </cfif>
				   <cfif key3 neq "">
				   AND T.#Key3# = TL.#Key3#
				   </cfif>
				   <cfif key4 neq "">
				   AND T.#Key4# = TL.#Key4#
				   </cfif>			      
				</cfif>   
		AND TL.LanguageCode = '#Code#'		   
		</cfquery>					  
					  
	</cfloop>				
	
	<!---
	<cfcatch></cfcatch>
	
	</cftry>
	--->

</cfoutput>	  