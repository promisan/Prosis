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

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfif ParameterExists(Form.Insert)> 

   <cfparam name="Form.ParentCode" default="">
	
   <cfquery name="Verify" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_Object
		WHERE Code  = '#Form.Code#' 	
   </cfquery>
  
   <cfif Verify.recordCount gte 1>
   
   <script language="JavaScript">
   
     alert("A record with this code has been registered already!")
     
   </script>  
  
   <cfelse>
   
   		<cfparam name="Form.RequirementMode" default="0">
   		
		<cfquery name="Insert" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_Object
		         (code,
				 CodeDisplay,
				 Description,
				 Resource,
				 ParentCode,
				 ListingOrder,
				 ObjectUsage,
				 Procurement,
				 RequirementPeriod,
				 RequirementUnit, 
				 SupportEnable,
				 RequirementMode,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
		  VALUES ('#Form.Code#',
		          '#Form.CodeDisplay#',
        		  '#Form.Description#', 
				  '#Form.Resource#',
				  '#Form.ParentCode#',
				  '#Form.ListingOrder#',
				  '#Form.ObjectUsage#',
				  '#Form.Procurement#',
				  '#Form.RequirementPeriod#',
				  '#Form.RequirementUnit#',
				  '#Form.SupportEnable#',
				  '#Form.RequirementMode#',
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')
		  </cfquery>
		  		  
		  <cf_LanguageInput
			TableCode       = "Ref_Object" 
			Mode            = "Save"
			Key1Value       = "#Form.Code#"
			Name1           = "Description">
			
			<cfquery name="FundTypeList"
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
				FROM Ref_FundType
				ORDER BY ListingOrder
			</cfquery>
			
			<cfloop query="FundTypeList">
			
				<cfparam name="Form.CodeDisplay_#currentrow#" default="">
				<cfset dis = evaluate("Form.CodeDisplay_#currentrow#")>
			
				<cfquery name="Insert" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				  INSERT INTO Ref_ObjectFundType
				         (Code,FundType,CodeDisplay,				
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName)
				  VALUES ('#Form.Code#','#Code#','#dis#', 				
							 '#SESSION.acc#',
					    	 '#SESSION.last#',		  
						  	 '#SESSION.first#')
				</cfquery>
						
			</cfloop>		
	     		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>

	<cfquery name="Verify" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_Object
		WHERE  Code  = '#Form.CodeOld#' 
	</cfquery>
		
	<cfif Form.CodeDisplay neq "">
	
		<cfquery name="Check" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_Object
		WHERE  Code != '#Form.CodeOld#' 
		AND    CodeDisplay = '#Form.CodeDisplay#'
	    </cfquery>
		
		<!--- 
		<cfif Check.recordcount gte "1">
		
		   <script language="JavaScript">	   
		     alert("Warning : A record with this display code has been registered already!")	     
		   </script>  
		   <cfabort>
		   
		</cfif>   
		--->
   
   </cfif>
   
   <cfparam name="Form.ParentCode" default="">
   <cfparam name="Form.RequirementMode" default="0">

   <cfif Verify.recordCount is 1>
   
		<cfquery name="UpdateCode" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE Ref_Object
			SET	Description       = '#Form.Description#', 
				CodeDisplay       = '#Form.CodeDisplay#',
			    Resource          = '#Form.Resource#',
				ParentCode        = '#Form.ParentCode#',
				ListingOrder      = '#Form.ListingOrder#',
				ObjectUsage       = '#Form.ObjectUsage#',
				Procurement       = '#Form.Procurement#',
				RequirementEnable = '#Form.RequirementEnable#',
				RequirementPeriod = '#Form.RequirementPeriod#',
				SupportEnable     = '#Form.SupportEnable#',
				RequirementUnit   = '#Form.RequirementUnit#',
				RequirementMode   = '#Form.RequirementMode#'
			WHERE code            = '#Form.CodeOld#'
		</cfquery>
		
		<cfquery name="UpdateChildren" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE Ref_Object
			SET	   Resource          = '#Form.Resource#',
				   ObjectUsage       = '#Form.ObjectUsage#'			
			WHERE  HierarchyCode     LIKE ('#Form.CodeOld#%')
		</cfquery>		
		
		<!--- language provision --->
		
		<cf_LanguageInput
			TableCode       = "Ref_Object" 
			Mode            = "Save"
			Key1Value       = "#Form.CodeOld#"
			Name1           = "Description">
			
		<!--- fundtype --->				
			
			<cfquery name="FundTypeList"
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
				FROM Ref_FundType
				ORDER BY ListingOrder
			</cfquery>
			
			<cfloop query="FundTypeList">
			
				<cfparam name="Form.CodeDisplay_#currentrow#" default="">
				<cfset dis = evaluate("Form.CodeDisplay_#currentrow#")>
				
				<cfquery name="Check" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT * FROM Ref_ObjectFundType
					WHERE Code = '#Form.CodeOld#'
					AND   FundType = '#Code#'				    
				</cfquery>
				
				<cfif check.recordcount eq "1">
				
					<cfquery name="Check" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE Ref_ObjectFundType
						SET CodeDisplay = '#dis#'
						WHERE Code = '#Form.CodeOld#'
						AND   FundType = '#code#'				    
					</cfquery>
				
				<cfelse>
			
					<cfquery name="Insert" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						INSERT INTO Ref_ObjectFundType
					         (Code,FundType,CodeDisplay,				
								 OfficerUserId,
								 OfficerLastName,
								 OfficerFirstName)
					  	VALUES ('#Form.CodeOld#','#code#','#dis#', 				
								 '#SESSION.acc#',
						    	 '#SESSION.last#',		  
							  	 '#SESSION.first#')
					  </cfquery>
				  
				 </cfif> 
						
			</cfloop>			
				
		</cfif>		
		
</cfif>	

<cfif ParameterExists(Form.Delete)> 

	<cfquery name="Check" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_Object
			WHERE  ParentCode = '#Form.CodeOld#'
			AND    Code != '#Form.CodeOld#'
		</cfquery>

  
    <cfif Check.recordcount gte "1">
		 
	     <script language="JavaScript">
	    
		   alert("Code is in use. Operation aborted.")
		        
	     </script>  
		 
		 <cfabort>
	 
    <cfelse>
			
		<!--- As per discussion with Hanno on Feb 29th, 2012 the below cleaning is safe. dev --->
		<cfquery name="Check"
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE 
			FROM   ProgramObject
			WHERE  ObjectCode = '#FORM.codeOld#'
		</cfquery>
			
		<cfquery name="Delete" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Ref_Object
			WHERE Code = '#FORM.codeOld#'
	    </cfquery>
			
	</cfif>
		
</cfif>	

<!--- ---------------- --->
<!--- update hierarchy --->
<!--- ---------------- --->
		
<cfquery name="SearchResult"
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *		   
		FROM     Ref_Object
		WHERE    ObjectUsage = '#Form.ObjectUsage#'	
		AND     (ParentCode is NULL or ParentCode = '')
		ORDER BY ListingOrder 
</cfquery>
	
<cfset ord = 10>
	
<cfloop query="SearchResult">
	
		<cfset Ord = Ord + 1>	
				
		<cfquery name="Update"
		     datasource="AppsProgram" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			     UPDATE  Ref_Object
				 SET     HierarchyCode  = '#Ord#' 
				 WHERE   Code = '#Code#'
		</cfquery>
		
		<cfquery name="Sub1"
		     datasource="AppsProgram" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT   *
			 FROM     Ref_Object
			 WHERE    ParentCode = '#SearchResult.Code#'
			 ORDER BY ListingOrder
		</cfquery>
		
		<cfset sub = 0>
		
		<cfloop query="sub1">
		
			<cfset sub = sub+1>
		
			<cfquery name="Update"
			     datasource="AppsProgram" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     UPDATE  Ref_Object
				 SET     HierarchyCode  = '#Ord#.#sub#'
				 WHERE   Code = '#Sub1.Code#' 
			</cfquery>
							
		</cfloop>
			
</cfloop>

<script language="JavaScript">
     window.close()
	 opener.history.go()	        
</script>  
